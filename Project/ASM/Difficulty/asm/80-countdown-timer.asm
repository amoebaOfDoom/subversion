org $809E0D ; ceres timer length
  JSR CeresTimer

org $809E20 ; Zebes timer length
  JSR ZebesTimer

org $80CC80
CeresTimer:
  LDA #$0038 ;hard mode
  JSL $808233
  LDA #$0200
  BCC +
  LDA #$0130
+
  RTS
ZebesTimer:
  LDA #$0038 ;hard mode
  JSL $808233
  LDA #$1000
  BCC +
  LDA #$0730
+
  RTS

org $90E0E6
  JSR CheckProcessTimer : NOP ;JSL $809DE7

org $90FCD0 ;free space
CheckProcessTimer:
  LDA #$003A ;easy mode
  JSL $808233
  BCC ProcessTimer
  LDA #$E90E
  STA $0A5A
  PLA ; pop return address
  RTS
ProcessTimer:
  JSL $809DE7
  RTS