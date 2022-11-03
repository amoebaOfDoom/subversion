lorom

org $A09169
  JMP RunIframes
RunIframes_Normal:

org $A09179
RunOtherStuff:

org $A0FF00 ; free space
RunIframes:
  LDA #$0038 ;hard mode
  JSL $808233
  BCS +
  LDA $18A8
  JMP RunIframes_Normal
+

  LDA $18A8
  SEC
  SBC #$0004
  BPL +
  LDA #$0000
+
  STA $18A8

  LDA $18AA
  SEC
  SBC #$0004
  BPL +
  LDA #$0000
+
  STA $18AA

  JMP RunOtherStuff