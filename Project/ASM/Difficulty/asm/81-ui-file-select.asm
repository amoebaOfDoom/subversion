{; 81: FILE SELECT UI TWEAKS =================
  ;org $81A0A8 : JSL SwitchUIEnergyFormula : NOP #2
  ;org $81A0B2 : JSL ScaleUIEnergy : NOP #3
  ;org $81A0C5 : JSL AdjustUIEnergy : NOP #2
  ;org $81A0CF : JSL ScaleUIEnergy : NOP #3
  ;org $81A117 : JSR TweakFileEnergyDigits
  org $81A149 : JSR DisplayDifficulty : NOP

  org $81FA00
;    TweakFileEnergyDigits:
;      PHA
;      JSL IsNormalModeEnabled : BEQ + : BMI +
;      LDA $09C2 : CLC : SBC #$0001 : CMP !StartingEnergyAddress : BPL +
;      LDA !EnergyPerTankAddress : LSR A : STA !TempAddress
;      PLA
;      CLC : ADC !TempAddress
;      PHA
;    + PLA
;      STA $4204 ;moved
;      RTS
    DisplayDifficulty:
      STA $7E3642,x ;moved
      PHX : PHY

      LDY #$0000
      LDA !DifficultyAddress
      AND #$0007
    - BEQ +
      INY : INY
      LSR
      BRA -

    + LDA DifficultySprites,y
      TAY
      TXA : AND #$FFC0 : TAX
    - LDA $0000,y
      BMI +
      STA $7E36A0,x
      INX : INX : INY : INY
      BRA -
    + PLY : PLX
      RTS
    DifficultySprites:
      DW NormalSprites,HardSprites,Quest2Sprites,EasySprites
    EasySprites:
      DW $000F,$206E,$206A,$207C,$2082,$000F,$2076,$2078,$206D,$206E,$FFFF
    NormalSprites:
      DW $2077,$2078,$207B,$2076,$206A,$2075,$000F,$2076,$2078,$206D,$206E,$FFFF
    HardSprites:
      DW $000F,$2071,$206A,$207B,$206D,$000F,$2076,$2078,$206D,$206E,$FFFF
    Quest2Sprites:
      DW $000F,$2062,$2077,$206D,$000F,$207A,$207E,$206E,$207C,$207D,$FFFF
}