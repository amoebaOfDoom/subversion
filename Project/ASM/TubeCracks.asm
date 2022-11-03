lorom

org $86D606
  LDA #$0100
  SEC
  SBC $1B23,X
  NOP
  JSR more
  STA $1A4B,x

org $86F5A0 ;free space
more:
  AND #$00FF
  SEP #$20
  XBA
  LDA $1B24,X
  XBA
  REP #$20
  RTS