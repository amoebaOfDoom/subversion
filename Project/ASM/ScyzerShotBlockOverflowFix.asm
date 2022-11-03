LoRom
org $94A1B5 : JSR CheckIndex
org $94A1D6 : JSR CheckIndex
org $94DFF7
CheckIndex: TXA : AND #$FFFE : TAX : CPX $07B9 : RTS