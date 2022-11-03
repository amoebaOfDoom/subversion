lorom

org $A8CB77
  LDA #$001F
  JSL $808233
  BCC Activated
  JMP Deactivate
Activated:

org $A8CBCC
Deactivated:

org $A8D196
  LDA #$001F
  JSL $808233
  NOP : NOP : NOP
  BCS $26

org $A8F9D0 ;free space
Deactivate:
  LDX $0E54
  LDA $0F7E,X
  CLC
  ADC #$0010
  STA $0F7E,X

  LSR : LSR : LSR : LSR
  DEC
  SEP #$20
  STA $4202
  LDA $07A5 ;room width
  STA $4203
  REP #$20
  LDA $0F7A,X ;x position
  LSR : LSR : LSR : LSR
  CLC
  ADC $4216 ;product
  ASL
  TAX

  LDA $7F0002,X
  AND #$0FFF
  ORA #$8000 ; make solid
  STA $7F0002,X

  TXA
  LSR
  TAX
  LDA $7F6402,X
  AND #$00FF
  STA $7F6402,X

  TXA
  CLC
  ADC $07A5
  ASL
  TAX

  LDA $7F0002,X
  AND #$0FFF
  ORA #$8000 ; make solid
  STA $7F0002,X

  TXA
  LSR
  TAX
  LDA $7F6402,X
  AND #$00FF
  STA $7F6402,X

  LDX $0E54
  JMP Deactivated