lorom

;ECE9

org $A9D7C4
  LDX $0E54
  LDA #$FFFF
  STA $7E7810,X
  LDA #$DA64
  STA $0FA8,X
  LDA #$0E00
  STA $0F96,X
  LDA #$ECE9
  JSL $A9C453
  LDY #$DD68
  JSR $DC5F
  RTL

org $A9D375
  LDA #$0400
  TSB $0F86
  JSR RecordEnemyDeath

org $A9D433
  LDA #$0400
  TSB $0F86
  JSR RecordEnemyDeath

org $A9FE80
RecordEnemyDeath:
  LDA #$0001
  STA $0E50
  RTS