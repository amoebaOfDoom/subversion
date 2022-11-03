lorom
;free fall

org $8FE6B0
  JSR $C116

  STZ $12
  STZ $14

  LDA $0AF6
  CMP #$0080
  BMI SamusTooFarLeft
  BEQ GoingDown
  LDA #$FFFF
  STA $12
  LDA #$A000
  STA $14
  BRA GoingDown
SamusTooFarLeft:
  LDA #$6000
  STA $14

GoingDown:
  JSL $94971E
  STZ $12
  STZ $14

  LDA $07E5
  STA $13
  LDA $0AFA
  CMP #$0100
  BMI SetupLoop
  CMP #$0280
  BMI MoveSamus
  DEC $07E3
  BMI MoveSamus
  LDA #$FF00 ;tp up a screen
  STA $14
  STZ $12
  BRA MoveSamus

SetupLoop:
  LDA #$0020
  STA $07E3

MoveSamus:
  LDA $12
  LDX $14
  STX $12
  STA $14
  JSL $949763

  LDX #$0000
Delete_Loop:
  LDA $0C7C,x
  BNE Delete
  LDA $0B78,x
  CMP $0AFA
  BMI AboveSamus
Delete:
  JSL $90ADB7
AboveSamus:
  INX
  INX
  CPX #$000A
  BNE Delete_Loop

  LDA $07E5
  CLC
  ADC $07E7
  CLC
  ADC #$0E20
  CMP #$16C1
  BCS +
  SEC
  SBC #$0E20
  STA $07E5
+
  RTS