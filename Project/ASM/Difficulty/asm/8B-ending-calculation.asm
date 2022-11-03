{; 8B: ITEM% CALCULATION =================
  org $8BE62F : JSR SetupCollectionHack
  org $8BE643 : JSR ScaleCollection
  org $8BE00A : JSR ForceEnding
  org $8BE1E0 : JSR ForceEnding
  org $8BE276 : JSR ForceEnding
  org $8BE2E4 : JSR ForceEnding
  org $8BE325 : JSR ForceEnding
  org $8BE36C : JSR ForceEnding
    
  org $8BF8A0
    SetupCollectionHack:
      LDX #$0008 ;moved
      LDA $09C4  : SEC : SBC !StartingEnergyAddress : STA $09C4
      RTS
    ScaleCollection:
      PHA
      JSL IsNormalModeEnabled : SEP #$20 : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      STA $4206 ;moved
      RTS
    ForceEnding:
      LDA $09E0
      PHA
      JSL IsNormalModeEnabled : BEQ + : BPL +
      PLA
      ADC #$00FF : STA $09E0 ;hack, add hours to force bad ending
      PHA
    + PLA
      RTS
}