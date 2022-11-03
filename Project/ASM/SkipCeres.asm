lorom

org $8BF800 ;free space
GameStarting:
  LDA #$0022
  STA $7ED914
  STA $0998
  STZ $0723
  STZ $0725
  LDA #$C5CA ; fly to Zebes cutscene
  RTS

PostCeresEscape_1:
  SEP #$20
  LDA #$10
  STA $6F
  LDA #$37
  STA $72
  REP #$20
  LDA $1991
  CLC
  ADC #$0000
  STA $1991
  LDA $1993
  ADC #$0002
  STA $1993
  LDA $198D
  DEC
  AND #$00FF
  STA $198D
  LDA $198F
  CMP #$0010
  BMI +
  SEC
  SBC #$0010
  STA $198F
  RTS
+
  LDA #PostCeresEscape_2
  STA $1F51
  LDA #$00C0
  STA $1A49
  RTS

PostCeresEscape_2:
  DEC $1A49
  BEQ +
  BPL ++
+  
  LDA #$0001
  STA $0723
  STA $0725
  LDA #PostCeresEscape_3
  STA $1F51
  LDA #$0080
  JSL $808FC1
++  
  RTS

PostCeresEscape_3:
  JSL $808924
  LDA $50
  BPL +
  LDA #$CADF
  STA $1F51
+
  RTS

SetupLandingMusic:
  LDA #$0006
  CMP $079F
  BEQ +
  DEC
+
  JSL $808FC1
  RTL

org $8BBDCC  ;this runs after the green text is gone (this is where the 'fly to Ceres' cutscene would start)
  JSR GameStarting ;LDA #$BDE4
org $8BBDDC  
  LDY #$0266 ; frame delay for song 5

org $8283E3
  NOP : NOP : NOP : NOP ;JSL $818000

org $82EED1
  LDA #$C5CA ;#$C11B

org $8BC3DF
  LDA #PostCeresEscape_1 ;#$CADF ;#$C5CA

org $8BC48C
  CMP #PostCeresEscape_1 ;#$CADF ;#$C5CA

org $82801D
  LDA $7ED914
  CMP #$0005
  BEQ LoadingContinue
  CMP #$0022
  BNE LoadingContinue

ShipLanding:
  LDA #$0006
  CMP $079F
  BEQ ShipLanding_Zebes
ShipLanding_Ceres:
  STA $079F
  LDA #$0002
  STA $078B
  JSL $809E93
  BRA LoadingContinue
ShipLanding_Zebes:
  ;LDA #$0012
  STA $078B
  STZ $079F
  JSL $80858C
  NOP : NOP
print pc
;org $82804E
LoadingContinue:

org $8280BF
  JSL SetupLandingMusic ;JSL $808FC1

; Ship stuff

org $A2A676
  ;LDA $0AFA
  JSR Ship_init

org $A2A80F
  ;CMP #$0300
  CMP $16FC

org $A2A8AD
  ;CMP #$045F
  CMP $16FA

org $A2A8B2
  ;LDA #$045F
  CMP $16FA

org $A2AAA2
  LDA $079F ;LDA #$000E
  JSR CheckEscapeEvent : NOP ;JSL $808233
  ;BCS $4D

org $A2AD20
  JSR SetEscaped
  ;LDA #$0026 zebes escape & LDA #$0020 ceres escape
  ;STA $0998

org $A2F500 ; free space
Ship_init:
  LDA $0F7E,X
  SEC
  SBC #$0019
  STA $16FA
  LSR
  STA $16FC

  LDA $0AFA
  RTS

CheckEscapeEvent:
  BEQ CheckEscape_Zebes
  LDA #$001D
  JSL $808233 
  RTS
CheckEscape_Zebes:
  LDA #$000E
  JSL $808233
  RTS

SetEscaped:
  LDA $09A2
  AND #$F7FF
  STA $09A2

  STZ $093F
  LDA $079F
  BEQ SetEscaped_Zebes
  LDA #$0020
  RTS
SetEscaped_Zebes:
; UnlockHardmode
  LDA $7FFF00
  ORA #$0002
  STA $7FFF00
  LDA #$0001
  STA $7FFF02
  JSL $81FAA0 ; set achievements (challenges.asm)
  JSL $81EF20 ; save global sram (saveload.asm)

  LDA #$0026
  RTS