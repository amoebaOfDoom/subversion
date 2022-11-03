{; 97: SPECIAL SETTINGS TILEMAPS =================
org $978DF4
incbin ROMProject/ASM/Difficulty/bin/Options.bin
}

org $82EDDA
IncrementDifficulty:
  PHP : SEP #$30
  LDA !DifficultyAddressIndex
  JSR NextDifficulty
  STA !DifficultyAddressIndex
  PLP
  BRA DrawDifficulty

warnpc $82EDEE

org $82EDED  
DrawDifficulty:
  LDA #$0000 ; palette 0
  JSR CheckNewGame
  BEQ +
  LDA #$0400 ; palette 1
+
  LDX #$0288 ; address
  LDY #$0014 ; bytes
  PHA
  JSR $ED28 ; set tile palette
  PLA
  LDX #$02C8 ; address
  LDY #$0014 ; bytes
  JSR $ED28 ; set tile palette

  LDY #$0006
.drawSelected
  LDX DifficultyTileOffset,Y
  LDA DifficultyUnlockFlags,Y
  AND #$00FF
  BEQ .setHighlight
  AND !DifficultyUnlockAddress
  BNE .setHighlight

  PHY
  LDY #$0009
  LDA #$000F
-
  STA $7E3000,X
  INX : INX
  DEY
  BNE -
  PLY
  BRA .next

.setHighlight
  TYA
  EOR !DifficultyAddressIndex
  BEQ +
  LDA #$0400
+

  PHY
  LDY #$0012
  JSR $ED28
  PLY

.next
  DEY : DEY
  BPL .drawSelected

.return
  RTS

warnpc $82EE54


org $82ED53 : JSR SkipDifficultyOption_Up         ; DEC $099E 
org $82ED6E : JSR SkipDifficultyOption_Down : NOP ; LDA $099E : INC


{; 82: SPECIAL SETTINGS TEXT =================
  org $82FD2F
CheckNewGame:
  LDX $09DA; Game time, frames
  BNE .return
  LDX $09DC; Game time, seconds
  BNE .return
  LDX $09DE; Game time, minutes
  BNE .return
  LDX $09E0; Game time, hours (capped at 99:59:59.59)
.return
  RTS

print pc
NextDifficulty:
  TAX
-
  INX : INX
  CPX #$08
  BNE +
  LDX #$00
+
  LDA DifficultyUnlockFlags,X
  BEQ +
  AND !DifficultyUnlockAddress
  BEQ -
+
  LDA !DifficultyAddress
  AND #$F8
  ORA DifficultyFlags,X
  STA !DifficultyAddress
  TXA
  RTS

DifficultyFlags:
  DW $0000, $0001, $0002, $0004
DifficultyUnlockFlags:
  DW $0000, $0002, $0004, $0000
DifficultyTileOffset:
  DW $038E, $0360, $03A0, $034E


SkipDifficultyOption_Up:
  LDA $099E
  DEC
  CMP #$0002
  BNE .return
  DEC
  JSR CheckNewGame
  BEQ .return
  DEC
.return
  STA $099E
  CMP #$0000
  RTS

SkipDifficultyOption_Down:
  LDA $099E
  INC
  CMP #$0002
  BEQ .skip
  CMP #$0001
  BNE .return
  JSR CheckNewGame
  BEQ .return
  INC
.skip
  INC
.return
  RTS


}