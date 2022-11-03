lorom

org $8FE740
DoubleStateTest:
  LDA $0000,X
  AND #$00FF
  JSL $808233
  BCC Exit
  LDA $0001,X
  AND #$00FF
  JSL $808233
  BCC Exit
  LDA $0002,X
  TAX
  JMP $E5E6
Exit:
  INX
  INX
  INX
  INX
  RTS

org $8FE770
EquipTest:
  LDA $0000,X
  AND $09A4
  CMP $0000,X
  BNE Exit
  LDA $0002,X
  TAX
  JMP $E5E6

print pc