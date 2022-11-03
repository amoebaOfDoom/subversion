lorom

org $A0A736
  JSL CheckIfVulerableToChargeOrHyper ;LDA $B40013,X
  AND #$00FF
  CMP #$00FF
  BEQ $66    ;[$A7A8]
  AND #$000F
  ; If charge beam multiplier is 0, fall back to the uncharged beam multiplier
  BEQ + ;BEQ $61    ;[$A7A8]
  STA $0E32
+

org $88F300 ;free space
CheckIfVulerableToChargeOrHyper:
  LDA.w $187A
  CMP.w #1000
  BMI CheckCharge
  ;LDA $0A76  ;Hyperbeam address (2 bytes)
  ;BEQ CheckCharge
;CheckHyper
  LDA $B40015,X
  BIT #$00FF
  BEQ CheckCharge
  RTL
CheckCharge:
  LDA $B40013,X
  RTL