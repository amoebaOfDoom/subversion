lorom


!plmvar_roomvar = $1DC7
!plmvar_trigger = $1D77
!plmvar_trigger_delay = $1E17
!plmvar_projectile = $7EDF0C

!projectile_x = $1A4B
!projectile_y = $1A93
!projvar_plm = $1A27
!projvar_size = $1A6F
!projvar_top = $1AB7
!projvar_bottom = $1ADB
!projvar_target_top = $1AFF
!projvar_target_bottom = $1B23


org $8DB4EE 
Gate_Projectile_Sprite0:
  DW $0000
Gate_Projectile_Sprite1:
  DW $0001
    DW $C200 : DB $00 : DW $2ABE
Gate_Projectile_Sprite2:
  DW $0002
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
Gate_Projectile_Sprite3:
  DW $0003
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
Gate_Projectile_Sprite4:
  DW $0004
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
    DW $C200 : DB $30 : DW $2ABE
Gate_Projectile_Sprite5:
  DW $0005
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
    DW $C200 : DB $30 : DW $2ABE
    DW $C200 : DB $40 : DW $2ABE
warnpc $8DB562

org $8D897C
Gate_Projectile_Sprite6:
  DW $0006
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
    DW $C200 : DB $30 : DW $2ABE
    DW $C200 : DB $40 : DW $2ABE
    DW $C200 : DB $50 : DW $2ABE
Gate_Projectile_Sprite7:
  DW $0007
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
    DW $C200 : DB $30 : DW $2ABE
    DW $C200 : DB $40 : DW $2ABE
    DW $C200 : DB $50 : DW $2ABE
    DW $C200 : DB $60 : DW $2ABE
Gate_Projectile_Sprite8:
  DW $0008
    DW $C200 : DB $00 : DW $2ABE
    DW $C200 : DB $10 : DW $2ABE
    DW $C200 : DB $20 : DW $2ABE
    DW $C200 : DB $30 : DW $2ABE
    DW $C200 : DB $40 : DW $2ABE
    DW $C200 : DB $50 : DW $2ABE
    DW $C200 : DB $60 : DW $2ABE
    DW $C200 : DB $70 : DW $2ABE
warnpc $8D8A16

org $84A525
GatePLMOn:
  DW $0001, $80D7, $0000
GatePLMOff:
  DW $0001, $80D6, $0000

warnpc $84A55D

org $868C36
Gate_Projectile_InstList:

org $86E533
Gate_Projectile:
  DW #Gate_Projectile_Init
  DW #Gate_Projectile_Preinst
  DW #Gate_Projectile_InstList
  DB $00, $00 ; x, y radius
  DW $2000, $0000, $84FC ; props, touch, shot

Gate_Projectile_SpriteMaps:
  DW #Gate_Projectile_Sprite0
  DW #Gate_Projectile_Sprite1
  DW #Gate_Projectile_Sprite2
  DW #Gate_Projectile_Sprite3
  DW #Gate_Projectile_Sprite4
  DW #Gate_Projectile_Sprite5
  DW #Gate_Projectile_Sprite6
  DW #Gate_Projectile_Sprite7
  DW #Gate_Projectile_Sprite8

Gate_Projectile_Init:
  LDA $1C27
  STA !projvar_plm,Y
  TAX
  JSL Gate_Projectile_SetTarget

  LDA $1C29          ;\
  ASL A              ;|
  ASL A              ;|
  ASL A              ;} Projectile X position = [current PLM X position] * 10h
  ASL A              ;|
  STA !projectile_x,Y        ;/

  LDA !projvar_target_top,Y
  STA !projvar_top,Y

  LDA !projvar_target_bottom,Y
  AND #$000F
  BEQ +
  SEC : SBC #$0010
+
  CLC : ADC !projvar_target_top,Y
  STA !projectile_y,Y

  LDA !projvar_target_bottom,Y
  STA !projvar_bottom,Y
  SEC : SBC !projvar_top,Y
  DEC
  LSR : LSR : LSR : LSR
  INC
  AND #$00FF
  ORA #$FF00
  STA !projvar_size,Y
  AND #$00FF
  ASL
  TAX
  LDA.w Gate_Projectile_SpriteMaps,X
  STA $1B6B,Y
  RTS


Gate_Projectile_Preinst:
  ; set temp vars
  LDA !projvar_top,X
  STA $14
  LDA !projvar_bottom,X
  STA $16
  LDY !projvar_plm,X
  LDA !plmvar_roomvar+1,Y
  AND #$000F
  STA $18

.move_top
  LDA $14
  CMP !projvar_target_top,X
  BEQ .move_bottom
  BPL +
  LDA $14
  CLC : ADC $18
  STA $14
  BRA .test_collide
 +
  LDA $14
  SEC : SBC $18
  STA $14
  BRA .test_collide

.move_bottom
  LDA $16
  CMP !projvar_target_bottom,X
  BNE +
  JMP .return
+
  BPL +
  LDA $16
  CLC : ADC $18
  STA $16
  BRA .test_collide
 +
  LDA $16
  SEC : SBC $18
  STA $16

.test_collide
  ; check if X collision
  LDA !projectile_x,X
  CLC : ADC #$0008 ; get center
  SEC : SBC $0AF6 ; samus x center
  BPL +
  EOR #$FFFF : INC
+
  CMP #$000A ; "x radius"
  BPL .update_pos

  ; check if Y collision
  LDA $14
  AND #$FFF0
  CLC : ADC $16
  AND #$FFF0
  CLC : ADC #$0010
  LSR
  STA $18

  SEC : SBC $0AFA ; samus center
  BPL +
  EOR #$FFFF : INC
+

  PHA
  LDA $16
  AND #$FFF0
  CLC : ADC #$0010
  SEC : SBC $18
  CLC : ADC $0B00 ; samus radius
  STA $18
  PLA

  CMP $18
  BMI .return

.update_pos
  LDA $16
  SEC : SBC $14
  DEC
  LSR : LSR : LSR : LSR
  INC
  AND #$00FF
  SEP #$20
  STA !projvar_size,X
  REP #$20

  LDA $14
  STA !projvar_top,X
  LDA $16 
  STA !projvar_bottom,X
  AND #$000F
  BEQ +
  SEC : SBC #$0010
+
  CLC : ADC $14
  STA !projectile_y,X

  LDA $16
  SEC : SBC !projectile_y,X
  DEC
  LSR : LSR : LSR : LSR
  INC  
  AND #$00FF
  ASL
  TAY
  LDA.w Gate_Projectile_SpriteMaps,Y
  STA $1B6B,x
.return
  RTS

warnpc $86E684


org $84C826 : DW #Gate_PLM_Init, $B7E9 ; Downwards open gate
org $84C82A : DW $0000, $0000       ; Downwards closed gate
org $84C82E : DW $0000, $0000       ; Upwards open gate
org $84C832 : DW $0000, $0000       ; Upwards closed gate


org $84C66A
; X = plm index, Y = proj index
Gate_Projectile_SetTarget:
  JSL $848290        ;} Calculate current PLM co-ordinates

  LDA !plmvar_roomvar,X
  BMI .direction_up
.direction_down
  LDA $1C2B
  INC
  ASL : ASL : ASL : ASL
  STA !projvar_target_top,Y
  LDA !plmvar_roomvar,X
  BIT #$4000
  BEQ .down_closed
.down_open
  LDA !projvar_target_top,Y
  STA !projvar_target_bottom,Y
  BRA .return

.down_closed
  AND #$00FF
  CLC : ADC !projvar_target_top,Y
  STA !projvar_target_bottom,Y
  BRA .return

.direction_up
  LDA $1C2B
  ASL : ASL : ASL : ASL
  STA !projvar_target_bottom,Y
  LDA !plmvar_roomvar,X
  BIT #$4000
  BEQ .up_closed
.up_open
  LDA !projvar_target_bottom,Y
  STA !projvar_target_top,Y
  BRA .return

.up_closed
  AND #$00FF
  EOR #$FFFF : INC
  CLC : ADC !projvar_target_bottom,Y
  STA !projvar_target_top,Y

.return
  RTL

warnpc $84C6E0

org $84BB52
Gate_PLM_Init:
  ; init state vars
  LDA #$0000
  STA !plmvar_trigger,Y
  LDA #$FFFF
  STA !plmvar_trigger_delay,Y

  ; spawn projectile
  PHX
  PHY
  LDY #Gate_Projectile
  JSL $868097
  PLY
  TYX
  STA !plmvar_projectile,X ; proj index
  PLX

  ; set pre-instruction
  LDA #Gate_PLM_PreInst
  STA $1CD7,Y
  RTS


Gate_PLM_PreInst:
  LDA !plmvar_projectile,X
  TAY
  LDA !projvar_size,Y
  XBA
  CMP !projvar_size,Y
  BNE .update_tiles
  JMP .check_trigger
.update_tiles
  ; update collision
  XBA
  AND #$00FF
  STA $14

  LDA !plmvar_roomvar,X
  DEC
  LSR : LSR : LSR : LSR
  INC
  AND #$000F
  STA $12

  ; set collision
  LDA !plmvar_roomvar,X
  BMI .update_tiles_up
.update_tiles_down
  LDA $07A5
  ASL
  STA $16
  BRA +
.update_tiles_up
  LDA $07A5
  ASL
  EOR #$FFFF
  INC
  STA $16
+

  PHX
  LDA $1C87,X
  TAX

  LDA $7F0002,X
  AND #$0FFF
  ORA #$8000 ; make solid
  STA $7F0002,X

.update_tiles_loop
  TXA
  CLC : ADC $16
  TAX

.update_tiles_continue
  LDA $7F0002,X
  AND #$0FFF ; make air
  DEC $14
  BMI +
  ORA #$8000 ; make solid
+
  STA $7F0002,X

  DEC $12
  BNE .update_tiles_loop

  PLX
  SEP #$20
  LDA !projvar_size,Y
  STA !projvar_size+1,Y
  REP #$20

.check_trigger
  LDA !plmvar_trigger,X
  BEQ .return
  LDA !plmvar_trigger_delay,X
  BMI .new_trigger
  DEC !plmvar_trigger_delay,X
  BPL .return
  STZ !plmvar_trigger,X
  BRA .return

.new_trigger
  LDA #$0010 ; cooldown
  STA !plmvar_trigger_delay,X
  LDA !plmvar_roomvar,X
  EOR #$4000
  STA !plmvar_roomvar,X
  JSL Gate_Projectile_SetTarget
  LDA #$000E
  JSL $80914D ; play sfx

.return
  ; set tile draw
  LDA !projvar_target_top,Y
  CMP !projvar_top,Y
  BNE .drawOn
  LDA !projvar_target_bottom,Y
  CMP !projvar_bottom,Y
  BNE .drawOn
.drawOff
  LDA #GatePLMOff
  BRA .draw_continue
.drawOn
  LDA #GatePLMOn
.draw_continue
  CMP $7EDE6C,X
  BEQ +
  STA $7EDE6C,X
  JSR $861E     ; Process PLM draw instruction
  LDX $1C27     ; X = [PLM index]
  JSL $848290   ; Calculate PLM block co-ordinates
  JSR $8DAA     ; Draw PLM
+
  RTS

warnpc $84BCAF



org $84C64C
  LDX #$004E             ; X = 4Eh (PLM index)

.loop
  CMP $1C87,x  ;\
  BNE +        ;} If [PLM [X] block index] = [A]: go to BRANCH_FOUND

  PHA
  LDA $1D77,x  ;\
  BNE $03      ;} If PLM [X] is not triggered:
  INC $1D77,x  ; Trigger PLM [X]
  PLA
+

  DEX          ;\
  DEX          ;} X -= 2
  BPL .loop    ; If [X] >= 0: go to LOOP

  LDA #$0000  ;\
  STA $1C37,y ;} Delete PLM
  SEC
  RTS
warnpc $84C66B