lorom

org $B3EE00
  LDX $0E54
  LDA $0FB4,X
  BIT #$0001
  BEQ +
  LDA #InstructionList_Idle_R
  BRA ++
+
  LDA #InstructionList_Idle_L
++
  STA $0F92,X
  LDA #$0000
  STA $0FA8,X
  RTL

org $B3EE20
  RTL

SizeUp:
  DEC $0F7E,X
  DEC $0F7E,X
  INC $0F84,X
  INC $0FA8,X
  RTL
SizeDown:
  INC $0F7E,X
  INC $0F7E,X
  DEC $0F84,X
  DEC $0FA8,X
  RTL


Trigger:
  LDA $0FB4,X
  BIT #$0001
  BNE TriggerRight
TriggerLeft:
  LDA $0F7A,X
  CMP $0AF6
  BMI LoopArg
  SEC
  SBC $0FB6,X
  CMP $0AF6
  BPL LoopArg
  BRA TriggerVertical
TriggerRight:
  LDA $0F7A,X
  CMP $0AF6
  BPL LoopArg
  CLC
  ADC $0FB6,X
  CMP $0AF6
  BMI LoopArg
TriggerVertical:
  LDA $0F7E,X
  CLC
  ADC $0FA8,X
  SEC
  SBC #$0060
  CMP $0AFA
  BPL LoopArg
  CLC
  ADC #$00C0
  CMP $0AFA
  BMI LoopArg

  LDA $0002,Y
  BRA TriggerLeft_Exit
LoopArg:
  LDA $0000,Y
TriggerLeft_Exit:
  TAY
  RTL

FireLaser:
  PHX
  PHY

  LDA $0F7E,X
  CLC
  ADC #$0005
  CLC
  SBC $0FA8,X
  STA $14 ;y
  
  LDA $0FB4,X
  AND #$0001
  STA $16 ;l/r
  
  BEQ +
  LDA $0F7A,X
  CLC
  ADC #$0004
  BRA ++
+
  LDA $0F7A,X
  SEC
  SBC #$0004
++
  STA $12 ;x
  
  LDY #$A17B
  JSL $868097
  PLY
  PLX
  RTL

InstructionList_Idle_L:
  DW $0001, SpriteMap_0_L
  DW Trigger, InstructionList_Idle_L, InstructionList_Extend_L
InstructionList_Idle_R:
  DW $0001, SpriteMap_0_R
  DW Trigger, InstructionList_Idle_R, InstructionList_Extend_R

InstructionList_Extend_L:
  DW SizeUp
  DW $0006, SpriteMap_1_L
  DW SizeUp
  DW $0006, SpriteMap_2_L
  DW SizeUp
  DW $0006, SpriteMap_3_L
  DW SizeUp
  DW $0006, SpriteMap_4_L
  DW SizeUp
  DW $0006, SpriteMap_5_L
  DW SizeUp
  DW $0006, SpriteMap_6_L
  DW SizeUp
  DW $0006, SpriteMap_7_L
  DW SizeUp

InstructionList_Attack_L:
  DW $0008, SpriteMap_8_L
  DW $0004, SpriteMap_9_L
  DW $0004, SpriteMap_A_L
  DW $0004, SpriteMap_B_L
  DW FireLaser
  DW $0010, SpriteMap_C_L
  DW $0004, SpriteMap_B_L
  DW $0004, SpriteMap_A_L
  DW $0004, SpriteMap_9_L
  DW $0008, SpriteMap_8_L
  DW Trigger, InstructionList_Retract_L, InstructionList_Attack_L

InstructionList_Retract_L:
  DW SizeDown
  DW $0006, SpriteMap_7_L
  DW SizeDown
  DW $0006, SpriteMap_6_L
  DW SizeDown
  DW $0006, SpriteMap_5_L
  DW SizeDown
  DW $0006, SpriteMap_4_L
  DW SizeDown
  DW $0006, SpriteMap_3_L
  DW SizeDown
  DW $0006, SpriteMap_2_L
  DW SizeDown
  DW $0006, SpriteMap_1_L
  DW SizeDown
  DW $80ED, InstructionList_Idle_L

InstructionList_Extend_R:
  DW SizeUp
  DW $0006, SpriteMap_1_R
  DW SizeUp
  DW $0006, SpriteMap_2_R
  DW SizeUp
  DW $0006, SpriteMap_3_R
  DW SizeUp
  DW $0006, SpriteMap_4_R
  DW SizeUp
  DW $0006, SpriteMap_5_R
  DW SizeUp
  DW $0006, SpriteMap_6_R
  DW SizeUp
  DW $0006, SpriteMap_7_R
  DW SizeUp

InstructionList_Attack_R:
  DW $0008, SpriteMap_8_R
  DW $0004, SpriteMap_9_R
  DW $0004, SpriteMap_A_R
  DW $0004, SpriteMap_B_R
  DW FireLaser
  DW $0010, SpriteMap_C_R
  DW $0004, SpriteMap_B_R
  DW $0004, SpriteMap_A_R
  DW $0004, SpriteMap_9_R
  DW $0008, SpriteMap_8_R
  DW Trigger, InstructionList_Retract_R, InstructionList_Attack_R

InstructionList_Retract_R:
  DW SizeDown
  DW $0006, SpriteMap_7_R
  DW SizeDown
  DW $0006, SpriteMap_6_R
  DW SizeDown
  DW $0006, SpriteMap_5_R
  DW SizeDown
  DW $0006, SpriteMap_4_R
  DW SizeDown
  DW $0006, SpriteMap_3_R
  DW SizeDown
  DW $0006, SpriteMap_2_R
  DW SizeDown
  DW $0006, SpriteMap_1_R
  DW SizeDown
  DW $80ED, InstructionList_Idle_R

SpriteMap_0_L:
  DW $0003
  DW $81F8 : DB $F8 : DW $2100
  DW $01F8 : DB $F7 : DW $2104
  DW $0000 : DB $F7 : DW $2105
SpriteMap_1_L:
  DW $0002
  DW $81F8 : DB $FA : DW $2100
  DW $81F8 : DB $F7 : DW $2104
SpriteMap_2_L:
  DW $0002
  DW $81F8 : DB $FC : DW $2100
  DW $81F8 : DB $F7 : DW $2104
SpriteMap_3_L:
  DW $0002
  DW $81F8 : DB $FE : DW $2100
  DW $81F8 : DB $F7 : DW $2104
SpriteMap_4_L:
  DW $0003
  DW $81F8 : DB $00 : DW $2100
  DW $81F8 : DB $F7 : DW $2104
  DW $81F8 : DB $FF : DW $210E
SpriteMap_5_L:
  DW $0003
  DW $81F8 : DB $02 : DW $2100
  DW $81F8 : DB $F7 : DW $2104
  DW $81F8 : DB $FF : DW $210E
SpriteMap_6_L:
  DW $0003
  DW $81F8 : DB $04 : DW $2100
  DW $81F8 : DB $F7 : DW $2104
  DW $81F8 : DB $07 : DW $210E
SpriteMap_7_L:
  DW $0003
  DW $81F8 : DB $06 : DW $2100
  DW $81F8 : DB $F7 : DW $2104
  DW $81F8 : DB $07 : DW $210E
SpriteMap_8_L:
  DW $0003
  DW $81F8 : DB $08 : DW $2100
  DW $81F8 : DB $F7 : DW $2104
  DW $81F8 : DB $07 : DW $210E

SpriteMap_9_L:
  DW $0004
  DW $81F8 : DB $08 : DW $2100
  DW $01F8 : DB $F7 : DW $2106
  DW $0000 : DB $F7 : DW $2105
  DW $81F8 : DB $FF : DW $210E
SpriteMap_A_L:
  DW $0004
  DW $81F8 : DB $08 : DW $2100
  DW $01F8 : DB $F7 : DW $2116
  DW $0000 : DB $F7 : DW $2105
  DW $81F8 : DB $FF : DW $210E
SpriteMap_B_L:
  DW $0003
  DW $81F8 : DB $08 : DW $2100
  DW $81F8 : DB $F7 : DW $210A
  DW $81F8 : DB $FF : DW $210E
SpriteMap_C_L:
  DW $0003
  DW $81F8 : DB $08 : DW $2100
  DW $81F8 : DB $F7 : DW $210C
  DW $81F8 : DB $FF : DW $210E


SpriteMap_0_R:
  DW $0003
  DW $81F8 : DB $F8 : DW $6100
  DW $0000 : DB $F7 : DW $6104
  DW $01F8 : DB $F7 : DW $6105
SpriteMap_1_R:
  DW $0002
  DW $81F8 : DB $FA : DW $6100
  DW $81F8 : DB $F7 : DW $6104
SpriteMap_2_R:
  DW $0002
  DW $81F8 : DB $FC : DW $6100
  DW $81F8 : DB $F7 : DW $6104
SpriteMap_3_R:
  DW $0002
  DW $81F8 : DB $FE : DW $6100
  DW $81F8 : DB $F7 : DW $6104
SpriteMap_4_R:
  DW $0003
  DW $81F8 : DB $00 : DW $6100
  DW $81F8 : DB $F7 : DW $6104
  DW $81F8 : DB $FF : DW $610E
SpriteMap_5_R:
  DW $0003
  DW $81F8 : DB $02 : DW $6100
  DW $81F8 : DB $F7 : DW $6104
  DW $81F8 : DB $FF : DW $610E
SpriteMap_6_R:
  DW $0003
  DW $81F8 : DB $04 : DW $6100
  DW $81F8 : DB $F7 : DW $6104
  DW $81F8 : DB $07 : DW $610E
SpriteMap_7_R:
  DW $0003
  DW $81F8 : DB $06 : DW $6100
  DW $81F8 : DB $F7 : DW $6104
  DW $81F8 : DB $07 : DW $610E
SpriteMap_8_R:
  DW $0003
  DW $81F8 : DB $08 : DW $6100
  DW $81F8 : DB $F7 : DW $6104
  DW $81F8 : DB $07 : DW $610E

SpriteMap_9_R:
  DW $0004
  DW $81F8 : DB $08 : DW $6100
  DW $0000 : DB $F7 : DW $6106
  DW $01F8 : DB $F7 : DW $6105
  ;DW $81F8 : DB $F7 : DW $6106
  DW $81F8 : DB $FF : DW $610E
SpriteMap_A_R:
  DW $0004
  DW $81F8 : DB $08 : DW $6100
  DW $0000 : DB $F7 : DW $6116
  DW $01F8 : DB $F7 : DW $6105
  ;DW $81F8 : DB $F7 : DW $6108
  DW $81F8 : DB $FF : DW $610E
SpriteMap_B_R:
  DW $0003
  DW $81F8 : DB $08 : DW $6100
  DW $81F8 : DB $F7 : DW $610A
  DW $81F8 : DB $07 : DW $610E
SpriteMap_C_R:
  DW $0003
  DW $81F8 : DB $08 : DW $6100
  DW $81F8 : DB $F7 : DW $610C
  DW $81F8 : DB $07 : DW $610E
warnpc $B3FFFF