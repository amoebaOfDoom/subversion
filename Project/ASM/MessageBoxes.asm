lorom

org $858150
  LDA #$19  ;\
  STA $2121 ;|
  LDA #$B5  ;|
  STA $2122 ;} CGRAM palette 1 colour 9
  LDA #$02  ;| 
  STA $2122 ;/
  LDA #$6B  ;\
  STA $2122 ;|
  LDA #$01  ;} CGRAM palette 1 colour Ah
  STA $2122 ;/

org $858510
  LDY #$0050
org $858518
  LDY #$0090

org $85851B
  LDX #$0110
  LDA #$0010

org $85846D
  REP #$30
  LDA $1C1F
  AND #$00FF
  ASL
  TAX
  LDA MessageBoxWaitTable,X
  BIT #$8000
  BEQ +
  BIT #$1000
  BEQ HandleConfirmation
  STZ $05F9
  BRA HandleConfirmationLoop
+
  AND #$0FFF
  TAX
  SEP #$20
  BRA WaitLoop:
print pc

warnpc $858493

org $858493
WaitLoop:

org $8584B5
HandleConfirmation:
  TDC : DEC ;LDA #$FFFF
  STA $05F9
HandleConfirmationLoop:

org $8584F8
  LDA $05F9
  BMI HandleConfirmationLoop
  RTS
  NOP ; align with existing branches
QuickExit:
  LDA #$0002
  JMP QuickExit_2

org $858507
  JSR Merge3State ;LDA $05F9

org $858089
  JSR ClearSfx : NOP
  ;JSL $82BE17

org $85810B
  ; CMP #$001C ;\
  ; BEQ $05    ;} If [message box index] != gunship save confirmation:
  ; CMP #$0017 ;\
  ; BNE $03    ;} If [message box index] != save confirmation: return
  LDA $05F9
  RTS
warnpc $858119

org $85869B
ClearSfx:
  REP #$30
  LDA $1C1F
  AND #$00FF
  ASL
  TAX
  LDA MessageBoxWaitTable,X
  BIT #$4000
  BNE +
  JSL $82BE17
+
  RTS

Merge3State:
  LDA $05F9
  BMI +
  RTS
+
  LDA $8F
  BIT #$2200
  BEQ +
  LDA #$0002
  RTS
+
  LDA #$0000
  RTS

QuickExit_2:
  STA $05F9
  JSR $8518
  LDA $05F9
  RTS

MessageBoxWaitTable:
  DW #$0168
  
  DW #$4030 ; energy tank
  DW #$0168 ; missiles
  DW #$0168 ; super missiles
  DW #$0168 ; power bombs
  DW #$0168 ; grapple beam
  DW #$0168 ; xray
  DW #$0168 ; varia suit
  DW #$0168 ; speed ball
  DW #$0168 ; morph
  DW #$0168 ; screw atack
  DW #$0168 ; high jump
  DW #$0168 ; space jump
  DW #$0168 ; speed booster
  DW #$0168 ; charge beam
  DW #$0168 ; ice beam
  DW #$0168 ; wave beam
  DW #$0168 ; spazer beam
  DW #$0168 ; plasma beam
  DW #$0168 ; bombs
  DW #$000A ; map station
  DW #$000A ; energy station
  DW #$000A ; ammo station
  DW #$900A ; save station
  DW #$000A ; saved
  DW #$4030 ; reserve
  DW #$0168 ; gravity suit
  DW #$001E ; didn't save
  DW #$900A ; ship save
  DW #$4030 ; damage amp
  DW #$4030 ; small ammo
  DW #$4030 ; large ammo
  DW #$4030 ; accel charge
  DW #$4030 ; space jump boost
  DW #$0168 ; gravity boots
  DW #$0168 ; dark visor
  DW #$0168 ; metroid suit
  DW #$4030 ; unknown item
  DW #$8100 ; bridge
  DW #$8100 ; detonate
  DW #$0100 ; locked
  DW #$0064 ; scanner
  DW #$0064 ; generator deactivated
  DW #$0064 ; generator activated
  DW #$800A ; dangerous save
  DW #$0100 ; puzzle 1
  DW #$0100 ; puzzle 2
  DW #$0100 ; puzzle 3
  DW #$0100 ; puzzle 1.1
  DW #$0100 ; puzzle 2.2
  DW #$0168 ; ice missiles
  DW #$0080 ; key 1
  DW #$0080 ; key 2
  DW #$0080 ; key 3
  DW #$0080 ; key 4
  DW #$0080 ; key 5
  DW #$0080 ; key 6
  DW #$0080 ; key 7
  DW #$0168 ; hypercharge
  DW #$0168 ; dev room
  DW #$0168 ; dev room
