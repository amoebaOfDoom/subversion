{; 82: STATUS SCREEN UI TWEAKS =================
  org $82B2C2 : JSR ScaleStatusReserve
  org $82B2DD : JSR ScaleStatusReserve
  org $82B2F1 : JSR ScaleStatusReserveFormula : NOP
  org $82B315 : JSR TweakStatusReserveFullCondition

  org $82FCD0
    ScaleStatusReserve:
      PHA
      JSL IsNormalModeEnabled : SEP #$20 : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      STA $4206 ;moved
      RTS
    ScaleStatusReserveFormula:
      STA $2A : STA $30
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA $0032 : STA !TempAddress ;reused to draw bars
      LDA $09D6 : STA $4204 ;hack: perform division again
      LDA #$0064 : STA $4206 ;100, for reserve digits
      NOP #7
      LDA $4216 : STA $32 ;overwrite
      LDA $4214 : STA $2A ;overwrite
    + PLA
      RTS
    TweakStatusReserveFullCondition:
      LDA $4216 ;moved
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      PLA
      LDA !TempAddress
      PHA
    + PLA
      RTS
}