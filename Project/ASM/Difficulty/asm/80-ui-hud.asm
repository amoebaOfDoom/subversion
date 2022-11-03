{; 80: HUD UI TWEAKS =================
  org $809B96 : JSL SwitchUIEnergyFormula : NOP #2
  org $809BA0 : JSL ScaleUIEnergy : NOP #3
  org $809BB3 : JSL AdjustUIEnergy : NOP #2
  org $809BBD : JSL ScaleUIEnergy : NOP #3
  org $809BF3 : JSR HUDEnergyDigits

  org $80FF00
    HUDEnergyDigits:
      LDX #$008C ;moved
      LDA $09C2 : CLC : SBC #$0001 : CMP !StartingEnergyAddress : BPL +
      LDA $09C2 : STA $7E0012 ;moved
    + RTS      
}