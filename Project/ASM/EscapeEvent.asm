lorom

org $8FE9B0
CheckBit:
  LDA #$001D
  JSL $808233
  BCC End
RunTimer:
  LDA #$0001
  STA $0943
  LDA #$E0E6
  STA $0A5A

  LDA #$0002
  STA $093F
ChangeMusic:
  LDA #$0000
  JSL $808FC1
  LDA #$FF1E
  JSL $808FC1
  LDA #$0005
  JSL $808FC1
LoadTimerGFX:
  LDX $0330
  LDA #$0400
  STA $D0,X
  LDA #$C000
  STA $D2,X
  LDA #$B0B0
  STA $D4,X
  LDA #$7E00
  STA $D5,X
  TXA
  CLC
  ADC #$0007
  STA $0330
ClearFX2Pointer:
  STZ $07DF
End:
  RTS

print pc
  LDA #$000E
  JSL $808233
  BCC End
  LDA #$0002
  STA $0943
  LDA #$E0E6
  STA $0A5A

  LDA #$0000
  JSL $808FC1
  LDA #$FF24
  JSL $808FC1
  LDA #$0007
  JSL $808FC1

  BRA LoadTimerGFX
