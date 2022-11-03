lorom

org $A8ABBD
  JSR ClearBlocks ;LDA #$0004

org $A8FA80 ;free sapce
ClearBlocks:
  LDX $0E54
  LDA $0FB6,X
  BEQ Exit
  LDA $0F7E,X ;y position
  LSR : LSR : LSR : LSR
  DEC
  SEP #$20
  STA $4202
  LDA $07A5 ;room width
  STA $4203
  REP #$20
  LDA $0F7A,X ;x position
  LSR : LSR : LSR : LSR
  DEC
  CLC
  ADC $4216 ;product
  ASL
  TAX

  LDA $7F0002,X
  AND #$0FFF ; make air
  STA $7F0002,X
  LDA $7F0004,X
  AND #$0FFF ; make air
  STA $7F0004,X

  TXA
  LSR
  TAX
  LDA #$0000
  STA $7F6402,X

  TXA
  CLC
  ADC $07A5
  ASL
  TAX

  LDA $7F0002,X
  AND #$0FFF ; make air
  STA $7F0002,X
  LDA $7F0004,X
  AND #$0FFF ; make air
  STA $7F0004,X

  TXA
  LSR
  TAX
  LDA #$0000
  STA $7F6402,X  

Exit:
  LDA #$0004
  RTS
