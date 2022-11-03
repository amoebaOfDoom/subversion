lorom

org $86DD30
  CMP #$0400

org $A5EDFB
  JSR SporeSpawnDead ;LDX $0E54

org $A5F95A
SporeSpawnDead:
  LDA #$0003
  JSL $808FC1
  
  JSL $81FAA5 ; Incremment kill count (challenges.asm)

  LDA #$F4B0 ; megaman blocks id
  LDX #$004E
-
  CMP $1C37,X
  BNE +
  PHA
  LDA #$0100
  STA $1DC7,X
  LDA #$0001
  STA $7EDE1C,X

  LDA $1D27,X
  CMP #$F4B4 ; wait to destory inst
  BNE ++
  STZ $1C37,X
++

  PLA
+
  DEX
  DEX
  BPL -

  LDX $0E54
  RTS

org $A5E757
  DW $0100 ; make pattern rotate on miss still
  