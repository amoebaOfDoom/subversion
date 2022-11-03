{; 84: EXPANSION SCALING =================
  org $848968 : JSR ScaleEnergyExpansion : NOP #4
  org $848986 : JSR ScaleReserveExpansion : NOP #4
  org $8489A9 : JSR ScaleMissileExpansion : NOP #17
  org $8489D2 : JSR ScaleSuperMissileExpansion : NOP #17
  org $8489FB : JSR ScalePowerBombExpansion : NOP #17

  org $84FA00
    ScaleEnergyExpansion:
      JSR ScaleEnergyCapacity
      CLC : ADC $09C4
      RTS
    ScaleReserveExpansion:
      JSR ScaleEnergyCapacity
      CLC : ADC $09D4
      RTS
    ScaleMissileExpansion:
      JSR ScaleAmmoCapacity
      PHA
      CLC : ADC $09C8 : STA $09C8
      PLA
      CLC : ADC $09C6 : STA $09C6
      RTS
    ScaleSuperMissileExpansion:
      JSR ScaleAmmoCapacity
      PHA
      CLC : ADC $09CC : STA $09CC
      PLA
      CLC : ADC $09CA : STA $09CA
      RTS
    ScalePowerBombExpansion:
      JSR ScaleAmmoCapacity
      PHA
      CLC : ADC $09D0 : STA $09D0
      PLA
      CLC : ADC $09CE : STA $09CE
      RTS
    ScaleEnergyCapacity:
      LDA $0000,y
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      RTS
    ScaleAmmoCapacity:
      LDA $0000,y
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      RTS
}