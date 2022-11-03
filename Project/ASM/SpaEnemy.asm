lorom

;A0:EA3F dx 0200, E587, 0050, 001E, 0008, 0008, A8, 00, 0000, 0000, E637, 0001, 0000, E68E, 801E, 804C, 8041, 0000, 0000, 00000000, 0000, 0000, 00000000, 8023, E70E, 0000, B1EA00, 05, F458, EEC6, E133

; Extended sprite graphics clone
org $A0F980
  DW $8200 ;GFX size
  DW $E587 ;Enemy Palette pointer
  DW $0050 ;Energy
  DW $001E ;Damage
  DW $0008 ;Width
  DW $0008 ;Height
  DB $A8 ;AI Bank
  DB $00 ;Hurt Flash duration
  DW $0000 ;Hurt Sound
  DW $0000 ;Boss Value
  DW Ex_InitAI ;Initiation AI
  DW $0001 ;Possessors
  DW $0000 ;UNUSED [Extra AI #1: $0016,X]
  DW $E68E ;Main AI
  DW $801E ;Grapple AI
  DW $804C ;Hurt AI
  DW $8041 ;Frozen AI
  DW $0000 ;X-Ray AI
  DW $0000 ;Death Animation
  DW $0000 ;UNUSED [Extra AI #2: $0024,X]
  DW $0000 ;UNUSED [Extra AI #3: $0026,X]
  DW $0000 ;Power Bomb AI
  DW $0000 ;UNUSED [Extra AI #4: $002A,X]
  DW $0000 ;UNUSED [Extra AI #5: $002C,X]
  DW $0000 ;UNUSED [Extra AI #6: $002E,X]
  DW TouchAI ;Touch AI
  DW $E70E ;Shot AI
  DW $0000 ;UNUSED [Extra AI #7: $0034,X]
  DL $B1EA00 ;Enemy Graphics pointer
  DB $05 ;Layer Priority
  DW $F458 ;Drops pointer ($B4)
  DW $EEC6 ;Enemy Weaknesses pointer ($B4)
  DW $E133 ;Enemy Name pointer ($B4)

org $A0EA6F
  ;DW $8023
  DW TouchAI


org $A098A4
  BRA SkipIFrameCheck
  ;LDA $18A8  ;\
  ;BEQ $03    ;} If [Samus invincibility timer] != 0:
  ;PLB        ;\
  ;PLP        ;} Return
  ;RTL        ;/

  ;LDA $0A6E  ;\
  ;BNE $6F    ;} If [Samus contact damage index] != normal: return
org $A098B1
  SkipIFrameCheck:

org $A09912
  ;JSR $9923
  ;DEC $18A6
  ;DEC $18A6
  ;LDA $18A6
  JSL ProjectileDamage
  LDA $18A6
  DEC : DEC
  STA $18A6

org $A0A09B
  JSR CheckHyper ; LDA $18A8 ; check iframes

org $A09923
CheckHyper:
  LDA $0F78,Y  
  CMP #$F980 ; spark enemy ID
  BNE .return 

  LDA $09A2 ; equipped items
  BIT #$0010 ; metroid suit
  BEQ .return
  LDA #$0000 ; ignore iframes
  RTS

.return
  LDA $18A8 ; check iframes
  RTS
warnpc $A0996C

org $A8FC00 ; free space
Ex_InitAI:
  LDX $0E54
  LDA #$01D0
  STA $0F98,x
  JMP $E637
TouchAI:
  LDA $09A2
  BIT #$0010 ; metroid suit
  BNE HyperPowers
  JSL $A0A477
  RTL
HyperPowers:
  LDA $7FFD70
  CMP #$0003
  BPL NoExtraHyperBeamNeeded
  LDA #$0003
  STA $7FFD70
NoExtraHyperBeamNeeded:
  RTL

; Handler for all? projectile damage. This runs after collision/vincibility has been confirmend.
; Deletes the projectile unless a flag is set
ProjectileDamage:
  LDA $1997,X
  CMP #$F498 ; SPA falling spark projectile
  BNE .checkSamusIFrames

  LDA $09A2 ; equipped items
  BIT #$0010 ; metroid suit
  BEQ +
  ; enable hyper timer
  LDA #$0020
  STA $7FFD70
  BRA .updateDraw
+

.checkSamusIFrames
  LDA $18A8 ;} If [Samus invincibility timer] != 0:
  BNE .return 
  LDA $0A6E  ;\ If [Samus contact damage index] != normal
  BNE .return

.applyDamage
  LDA #$0060
  STA $18A8 ; Samus's invincibility timer when hurt
  LDA #$0005
  STA $18AA ; Samus's hurt-timer (pushed back, unable to move)

  LDA $1BD7,x ; Often: bits 0-11 = damage value, bit 12 = invisibility, bit 13 = disable collisions with Samus's projectiles, bit 14 = don't die on contact, bit 15 = detect collisions with projectiles (all not really tested)
  AND #$0FFF
  JSL $A0A45E
  JSL $91DF51

  LDY #$0000
  LDA $0AF6 ; Samus's X position in pixels
  SEC
  SBC $1A4B,x ; X position of projectile, in pixels
  BMI +
  LDY #$0001
+
  STY $0A54 ; Direction Samus moves when she gets hurt. 0 = left, 1 = right

.updateDraw
  TXY
  LDX $1997,y ; Header / ID for projectiles
  LDA $86000A,x ; collision graphics
  BEQ +
  STA $1B47,y ; Instruction address / Graphic AI for e/r projectiles
  LDA #$0001
  STA $1B8F,y ; Frames Delay for $1B47
+

.checkDelete
  TYX
  BIT $1BD7,x ; Often: bits 0-11 = damage value, bit 12 = invisibility, bit 13 = disable collisions with Samus's projectiles, bit 14 = don't die on contact, bit 15 = detect collisions with projectiles (all not really tested)
  BVS +
  STZ $1997,x ; delete projectile
+

.return
  RTL



org $8683DC
  AND #$01FF
org $8683E4
  AND #$FE00

org $A8E668
  RTL
