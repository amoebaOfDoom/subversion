lorom

org $90ED88
  LDX $07BB ; Current roomstate pointer
  LDA $8F0011,X
  AND #$000F
  BEQ +
  DEC
  ASL
  TAX
  JMP (StepHandlers,X)
+
  LDA $1966
  BNE +
  TDC
  BRA ++
+
  LDA $196E
  AND #$000F
++
  TAX
  JMP (StepFxHandlers,X)
StepHandlers:
  DW $EE64 ; 1 = dust
  DW $EDEC ; 2 = water
  DW $EE63 ; 3 = none
  DW $EE6F ; 4 = more dust
StepFxHandlers:
  DW $EE64 ;None
  DW $EE64 ;Lava
  DW $EE64 ;Acid
  DW $EDEC ;Water
  DW $EE64 ;Spores
  DW $EDEC ;Rain
  DW $EE64 ;Fog
  DW $EE64 ;Stars
warnpc $90EDEC

org $91F0A5
  LDX $07BB ; Current roomstate pointer
  LDA $8F0011,X
  AND #$00F0
  BEQ +
  BRA ++
warnpc $91F0BE

org $91F0C5
++
  LSR : LSR : LSR : LSR
  DEC
  ASL
  TAX
  JMP (FallHandlers,X)
+
  LDA $1966
  BNE +
  TDC
  BRA ++
+
  LDA $196E
  AND #$000F
++
  TAX
  JMP (FallFxHandlers,X)
FallHandlers:
  DW $F166 ; 1 = dust
  DW $F116 ; 2 = water
  DW $F0BE ; 3 = kill
FallFxHandlers:
  DW $F166 ;None
  DW $F166 ;Lava
  DW $F166 ;Acid
  DW $F116 ;Water
  DW $F166 ;Spores
  DW $F116 ;Rain
  DW $F0BE ;Fog
  DW $F0BE ;Stars
warnpc $91F116
