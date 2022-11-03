lorom
;Space elevator

org $8FE301
  LDA #$FFFA
  STA $07A3
  JSR $C116

  LDA #$0080
  STA $0AF6
  STZ $0AF8
  STZ $12
  STZ $14

  STZ $05F7
  LDA $0AFA
  CMP #$0680
  BPL MimimapUpdateOn
  STA $05F7
MimimapUpdateOn:

  LDA $07E5
  BPL GoingDown
GoingUp:
  DEC $14
  STA $13
  LDA $0AFA
  CMP #$0400
  BPL SetupLoop
  CMP #$0280
  BPL MoveSamus
  DEC $07E3
  BMI MoveSamus
  LDA #$0100 ;tp down a screen
  STA $14
  STZ $12
  BRA MoveSamus

GoingDown:
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
  LDA $07E5
  CLC
  ADC $07E7
  CLC
  ADC #$0E20
  CMP #$1C41
  BCS +
  SEC
  SBC #$0E20
  STA $07E5
+
  RTS

org $89AA0A
  DW #%0011110111101111, #%0010000001101000, #%0010110001100011
