lorom

;free space
org $A2F600
  LDX $0E54
  LDA #$001F
  JSL $808233
  BCC Activated
  LDA #$0000
  STA $0F78,X
  RTL
Activated:
  JMP $B62A