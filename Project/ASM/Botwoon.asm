lorom

!enemy_index      = $0E54
!enemy_X          = $0F7A
!enemy_Y          = $0F7E
!enemy_var0       = $0FA8
!enemy_exvar00    = $7E7800
!enemy_exvar10    = $7E7820
!enemy_exvar30    = $7E8020
!enemy_exvar5F    = $7E883E
!enemy_flash_timer = $0F9C

!enemy_prop1      = $0F86
!enemy_param1     = $0FB4 
!enemy_var1       = $0FAA
!enemy_exvar20    = $7E8000
!enemy_exvar45    = $7E880A
!enemy_exvar46    = $7E880C
!enemy_exvar47    = $7E880E
!enemy_exvar48    = $7E8810
!enemy_exvar4E    = $7E881C ; paletteRAMoffset
!enemy_exvar4F    = $7E881E ; paletteHPIndex
!enemy_exvar59    = $7E8832 ; forcemove

!proj_index       = $1991
!proj_x           = $1A4B
!proj_y           = $1A93
!proj_instruction = $1B47
!proj_var0        = $1AB7
!proj_var1        = $1ADB
!proj_var2        = $1AFF
!proj_var3        = $1B23
!proj_unk         = $1BFB

!enemy_killed     = $0E50
!enemy_kill_goal  = $0E52


; change event bit
org $B39583
  LDA $7ED82F ;LDA $7ED82C
  ;AND #$0002


org $86EA31
BodyProj_Init:
;;; $EA31: Initialisation AI - enemy projectile $EBA0 (Botwoon's body) ;;;
  LDX !enemy_index

  LDA !enemy_X,X          ;\
  STA !proj_x,y           ;} Enemy projectile X position = [Botwoon X position]
  LDA !enemy_Y,X          ;\
  STA !proj_y,y           ;} Enemy projectile Y position = [Botwoon Y position]

  JSR BodyProj_SetDeathDelay

  PHY
  LDY #$0010             ; $12 = 10h
  LDA !enemy_var0,X       ; projSpawnIndex
  BNE +                  ;} If [Botwoon enemy_var0_projSpawnIndex]= 0:
  LDY #$0030             ; $12 = 30h
+

  STY $12              
  LDA $E9F1,y            ;\
  PLY                    ;} Enemy projectile instruction list pointer = [$E9F1 +       
  STA !proj_instruction,y ;/
  STA !proj_var3,y        ; Enemy projectile proj_var3_instprev= [enemy projectile instruction list pointer]
  LDA $12                ;\
  STA !proj_var2,y        ;} Enemy projectile proj_var2_instlist_index=      
  LDA #$EA98             ;\
  STA !proj_var0,y        ;} Enemy projectile function = $EA98

  TXA
  STA !proj_unk,Y
  CLC : ADC !enemy_var0,X ; projSpawnIndex
  TAX : TYA
  STA !enemy_exvar00,X   ; projectiles list
  LDA #$0001
  STA !enemy_exvar10,X   ; foreground list
  RTS

warnpc $86EA80


;;; $EA80: Pre-instruction - enemy projectile $EBA0 (Botwoon's body) ;;;
org $86EA80
BodyProj_PreInstruction:
  JSR BodyProj_LoadEnemyIndex : NOP ; LDA !enemy_exvar30


org $86EABD
  LDY !proj_unk,X
  LDA !enemy_flash_timer,Y
  BEQ BodyProj_Return
  NOP : NOP : NOP
  NOP : NOP


org $86EAD3
BodyProj_Return:


org $86EADD
  LDY !proj_unk,X
  LDA !enemy_flash_timer,Y
  BEQ BodyProj_Return
  NOP : NOP : NOP
  NOP : NOP

;;; $EAF4: Botwoon's body function - dying - set delay ;;;
org $86EAF4
  NOP
  NOP
  NOP
  NOP
  NOP : NOP : NOP
  NOP : NOP : NOP
  ; TXA                    ;\
  ; ASL A                  ;|
  ; ASL A                  ;|
  ; CLC                    ;} Enemy projectile proj_var2_instlist_index= [enemy projectile index] * 4 + 60h
  ; ADC #window_BG12       ;|
  ; STA proj_var2_instlist_index,x        ;/


;;; $EB04: Botwoon's body function - dying - waiting ;;;
org $86EB04
  DEC !proj_var1,x
  NOP : NOP : NOP
  NOP : NOP : NOP
  BNE $06
  ;INC proj_var2_instlist_index,x        ; Increment enemy projectile proj_var2_instlist_index
  ;LDA proj_var2_instlist_index,x        ;\
  ;CMP #$0100             ;} If [enemy projectile proj_var2_instlist_index]>= 100h:
  ;BMI $06    [$EB15]     ;


org $86EB72
  LDX !proj_unk,Y
  LDA !enemy_exvar5F,X
  DEC
  STA !enemy_exvar5F,X
  ;CPY #$000A        
  ;BNE $07    [$EB7E]
  ;LDA #$0001        
  ;STA enemy_exvar5F 

; make the proj blockers delete plasma as well
org $A09A3D : JSR DeleteProj ; LDA $0B64,x
org $A0FFF0 ; free space
DeleteProj:
  LDA $0C04,y ; delete
  ORA #$0010
  STA $0C04,y
  LDA $0B64,x ; displaces
  RTS


org $86FB30 ; Projectile Free space
BodyProj_LoadEnemyIndex:
  LDA !proj_unk,X
  TAX
  LDA !enemy_exvar30,X
  PHP
  LDX !proj_index
  PLP
  RTS

BodyProj_SetDeathDelay:
  LDA !enemy_var0,X
  ASL : ASL
  EOR #$FFFF : INC
  CLC : ADC #$0040
  STA !proj_var1,y

  PHX
  LDA #$0002
  TYX
  STA $7EF380,X ; hit reaction = none
  PLX

  RTS

;; $949B:  ;;;
; hole definitions (2 point rectangle definitions)
org $B3949B
  DW $004C, $0054, $006C, $0074
  DW $008C, $0094, $00AC, $00B4
  DW $00AC, $00B4, $005C, $0064
  DW $00EC, $00F4, $008C, $0094

; speed, stepsize
;;; $94BB:  ;;;
;{
;$B3:94BB             dw 0002,0018,
;                        0003,0010,
;                        0004,000C
;}


; initialization
org $B395B3
  JSR ExtraInitializations ; LDA #$0018

org $B395EA
  NOP : NOP : NOP : NOP ;  STA !enemy_exvar20

org $B39611
  JSR GetRandomHole ; LDA #$0000


; start next phase
org $B398B5
  JSR CheckForceMove : NOP ; LDA enemy_exvar59_forcemove,x


;;; $9675 ;;; unused
org $B39675
warnpc $B396C6


;;; $96FF ;;; unused
org $B396FF
warnpc $B3971B


;;; $981B: Botwoon health thresholds for palette change ;;;
;{
;; 3000, 2625, 2250, 1875, 1500, 1125, 750, 375
;$B3:981B             dw 0BB8, 0A41, 08CA, 0753, 05DC, 0465, 02EE, 0177
;}


; allow different palette rows to be used
org $B39865
  AND #$001F ; CMP #$0200


;;; $9ACA: Botwoon function - die - wait for body to fall to ground ;;;
org $B39ACD
  JSR CheckDeathDone : NOP ; LDA enemy_exvar5F,x
  BCC $09 ; BEQ $09


;;; $9C7B_savepos:  ;;;
org $B39C7E
  JSR GetMovementTableOffset_updatetable ; LDX enemy_var1_posindex,y


org $B39D14
  JSR GetMovementTableOffset_updateproj
  NOP : NOP : NOP
  ; LDX $12              
  ; LDA $7E9000,x 


org $B39C9A : JSR AndMovementTableMask ; AND #$03FF
org $B39C9F : JSR LoadBodyLength       ; LDA #$0018
org $B39D2D : JSR AndMovementTableMask ; AND #$03FF
org $B39D46 : JSR AndMovementTableMask ; AND #$03FF
org $B39D50 : JSR LoadBodyLength       ; LDA #$0018
org $B39D6B : JSR CompareBodyLength    ; CMP #$0018


; botwoon free space
org $B3F1A0
MovementTableOffsets:
  DW $0000, $0200, $0500, $0600
MovementTableMasks:
  DW $01FF, $01FF, $00FF, $00FF
BodyLength:
  DW $000C, $000A, $0002, $0002
DisableSpitting:
  DW $0000, $0001, $0001, $0001
EnablePaletteHP:
  DW $0001, $0000, $0000, $0000
InitDelay:
  DW $0100, $0180, $0200, $0200


ExtraInitializations:
  ; displaced
  STA !enemy_exvar4E,x ; paletteRAMoffset

  LDY !enemy_param1,X

  LDA.w MovementTableOffsets,Y
  STA !enemy_exvar45,X

  LDA.w MovementTableMasks,Y
  STA !enemy_exvar46,X

  LDA.w BodyLength,Y
  STA !enemy_exvar47,X
  LSR
  STA !enemy_exvar5F,X

  LDA.w DisableSpitting,Y
  STA !enemy_exvar48,X

  LDA.w InitDelay,Y
  STA !enemy_exvar20,X ; statetimer

  LDA.w EnablePaletteHP,Y
  BNE +
  LDA #$0010
  STA !enemy_exvar4F,X ; paletteHPIndex
+

  LDA !enemy_exvar47,X ; projectile counter
  RTS


GetRandomHole:
  ; set randome starting hole
  JSL $808111   ; rng       
  AND #$0018
  RTS

CheckForceMove:
  LDA !enemy_exvar59,x ; forcemove
  BNE .return
  LDA !enemy_exvar48,X
.return
  RTS


GetMovementTableOffset_updatetable:
  TYX
  LDA !enemy_var1,X ; posindex
  CLC : ADC !enemy_exvar45,X
  TAX
  RTS


GetMovementTableOffset_updateproj:
  LDA $12
  CLC : ADC !enemy_exvar45,X
  TAX
  LDA $7E9000,X ; displaced
  RTS


LoadBodyLength:
  LDA !enemy_exvar47,X
  RTS


CompareBodyLength:
  LDX !enemy_index
  CMP !enemy_exvar47,X
  RTS

AndMovementTableMask:
  AND !enemy_exvar46,X
  RTS


LoadProjectileIndex:
  TXA
  CLC : ADC !enemy_index
  TAX
  LDA !enemy_exvar00,x ; projectiles
  RTS

ToggleProjectileForeground:
  TXA
  CLC : ADC !enemy_index
  TAX
  LDA !enemy_exvar10,x ; projForegroundList
  EOR #$0001
  STA !enemy_exvar10,x ; projForegroundList
  PHP
  LDX $14
  PLP
  RTS
  
LoadProjectileForeground:
  TXA
  CLC : ADC !enemy_index
  TAX
  LDA !enemy_exvar00,x ; projectiles
  TAY
  LDA !enemy_exvar10,x ; projForegroundList
  PHP
  LDX $16
  PLP
  RTS
  
CheckDeathDone:
  CLC
  LDA !enemy_exvar5F,x
  BPL .return

  JSL $81FAA5 ; Incremment kill count (challenges.asm)

  LDA !enemy_killed
  INC
  STA !enemy_killed
  CMP !enemy_kill_goal
  BCS .return

.kill
  LDA !enemy_prop1,x
  ORA #$0200
  STA !enemy_prop1,x

.return
  RTS


org $B39CA6
  JSR LoadProjectileIndex : NOP 
  ; LDA enemy_exvar00_projectiles,x 

org $B39CB8 
  JSR ToggleProjectileForeground : NOP 
  NOP : NOP : NOP
  NOP : NOP : NOP : NOP
  ; LDA enemy_exvar10_projForegroundList,x ; flip foreground state
  ; EOR #$0001
  ; STA enemy_exvar10_projForegroundList,x  

org $B39D59
  JSR LoadProjectileForeground : NOP 
  NOP
  NOP : NOP : NOP : NOP
  ; LDA enemy_exvar00_projectiles,x    
  ; TAY
  ; LDA enemy_exvar10_projForegroundList,x    
