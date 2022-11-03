{; A2,A3,A6,A7: SAMPLE ENEMY EDITS =================
  org $A2E6BE : JSR DragonFireballs
  org $A3EEFF : JSR MetroidDamage
  org $A69AB1 : JSR MiniKraidSteps
  org $A7B8D2 : JSR KraidSpikeRate
    
  org $A2FA00
    DragonFireballs:
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA #$0005 : BRA ++
    + LDA #$0003 ;moved
   ++ RTS

  org $A3FA00
    MetroidDamage:
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA #$0002 : BRA ++
    + LDA #$0001 ;moved
   ++ RTS

  org $A6FF00
    MiniKraidSteps:
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA #$0006 : BRA ++
    + LDA #$0004 ;moved
   ++ RTS

  org $A7FF00
    KraidSpikeRate:
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA #$00D0 : BRA ++
    + LDA #$012C ;moved
   ++ RTS    
}