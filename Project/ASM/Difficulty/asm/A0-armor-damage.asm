{; A0: ARMOR & DAMAGE SCALING =================
  org $A0A460 : JSR ScaleArmor
  org $A0A6E4 : JSR ScaleDamage

  org $A0FA00
    ScaleArmor:
      JSL IsNormalModeEnabled : BEQ + : BMI ++
      ASL $7E0012
      BRA +
   ++ LSR $7E0012
    + LDA $09A2 ;moved
      RTS
    ScaleDamage:
      LDA $0C2C,x ;moved
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      PLA
      LSR A : LSR A : STA !TempAddress
      LDA $0C2C,x : SEC : SBC !TempAddress ;deal 0.75x damage
      PHA
    + PLA
      RTS    
}