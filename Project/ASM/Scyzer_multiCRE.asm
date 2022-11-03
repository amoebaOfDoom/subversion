lorom

org $808000
  DB $01
;  DL CRESetPointers ; repointed by SMART as needed

org $80D003 ;Free space
GetCRESet:
PRINT PC
  STA $00 ;Which pointer to load
  PHB

  LDX $07BB ; Current roomstate pointer
  LDA $8F0010,X ;"unused" pointer in room MDB
  AND #$000F
  ASL A
  TAY

  PHP
  SEP #$20  
  LDA $808003 ; CREsets pointer bank
  PHA
  PLB
  PLP
  LDA $808001 ; CRESetPointers
  PHA
  LDA ($01,S),Y ; CRESetPointers indexed
  CLC
  ADC $00 ;Which pointer to load
  TAX
  PLA

  LDA $0001,X
  STA $48
  LDA $0000,X
  STA $47

  PLB
  RTL
PRINT PC

org $82E413
  LDA #$0003 : JSL GetCRESet : BRA $01
org $82E795
  LDA #$0003 : JSL GetCRESet : BRA $01
org $82E83B
  LDA #$0000 : JSL GetCRESet : BRA $01
org $82EAEB
  LDA #$0000 : JSL GetCRESet : BRA $01
