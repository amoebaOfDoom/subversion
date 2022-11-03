lorom

!BitSuit1 = #$0020 ; aqua suit
!BitSuit2 = #$0001 ; varia suit
!BitSuit3 = #$0010 ; metroid suit


org $90806F
  DW #IceEffect

org $8DE379
  LDA $09A2
  AND !BitSuit2
  BNE DoneHeatBitDamage
  LDA $0A4E
  CLC
  ADC #$6000 ; Sub health units to lose every frame (reduced by suits)
  STA $0A4E
  LDA $0A50
  ADC #$0000 ; Health units to lose every frame (reduced by suits)
  STA $0A50
  LDA $05B6 ; Frame counter. Incremented EVERY NMI when processing has been completed (05B4 has been set)
  BIT #$0007
  BNE DoneHeatBitDamage
  LDA #$0046
  CMP $09C2 ; Samus' health
  BCS DoneHeatBitDamage
  LDA #$002D
  JSL $80914D
DoneHeatBitDamage:

org $909E8B
  DW $8000, $0001 ; lava damage (minor, major)
  DW $0000, $0001 ; acid damage (minor, major)

; Check for air bit
org $9081C9
  LDA $197E  ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
  BIT #$0004 ; Check for water disable flag set
  BNE LavaImmune

  JSR SetLavaPhysics

  LDA $09A2
  BIT !BitSuit3
  BNE LavaImmune
  JSR LavaFadeIn
  NOP

org $90820C
  JSR LavaFadeIn
  JMP $8078
LavaImmune:
  JSR LavaFadeOut
  RTS

org $90820A
  BRA LiquidDamageEffect
org $90820C : LavaNotSubmerged:
org $908258 : LiquidDamageEffect:

org $909741
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $9098C2
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $9099DC
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $909A2F
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $909BD4
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

; Handled in gravity boots
;org $909C5B
  ;LDA $09A2
  ;BIT #$0020
  ;JSL CheckLavaPhysics
  ;NOP : NOP

org $90A439
  ;LDA $0A74
  ;BIT #$0004
  JSL CheckLavaPhysics
  NOP : NOP

;org $90EDEC
;  ;JSL $90EC3E
;  ;LDA $195E
;  JSL CheckLavaPhysics_2
;  NOP : NOP : NOP
;
;org $90EE6F
;  ;JSL $90EC3E
;  ;LDA $195E
;  JSL CheckLavaPhysics_2
;  NOP : NOP : NOP

org $91D9B2
  ;LDA $0A74  [$91:0A74]
  ;BIT #$0004
  JSL CheckLavaPhysics
  NOP : NOP

;org $91F116
;  ;JSL $90EC3E
;  ;LDA $195E
;  JSL CheckLavaPhysics_2
;  NOP : NOP : NOP
;
;org $91F166
;  ;JSL $90EC3E
;  ;LDA $195E
;  JSL CheckLavaPhysics_2
;  NOP : NOP : NOP

org $91F68A
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $91F6EB
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $91FA76
  ;JSL $90EC3E
  ;LDA $195E
  JSL CheckLavaPhysics_2
  NOP : NOP : NOP

org $91FB0E
  ;LDA $09A2
  ;BIT #$0020
  JSL CheckLavaPhysics
  NOP : NOP

org $90E9CE
  PHP
  REP #$30
  LDA $0A78 ; pause time
  BNE SquelchFurtherDamage

  LDA $0A50
  ORA $0A4E
  BEQ NoDamage ; if there is no damage to apply, skip this

  JSR ApplySuitModifier

  LDA $0A50 ; full units of damage we're about to do this frame
  BPL DamageValid_1
  JMP $808573 ; infinite loop -- assert damage >= 0
DamageValid_1:
  ;Update Samus' health
  LDA $0A4C
  SEC
  SBC $0A4E
  STA $0A4C
  LDA $09C2
  SBC $0A50
  STA $09C2
  BPL SquelchFurtherDamage ; HP > 0?
  ; HP = 0
  STZ $0A4C
  STZ $09C2
  STZ $0A4E
  STZ $0A50
  PLP
  RTS
SquelchFurtherDamage:
  STZ $0A4E
  STZ $0A50
NoDamage:
  PLP
  RTS

warnpc $90EA44

Padbyte $FF : pad $90EA45

org $A0A45E
  STA $12
  JSL ApplySuitModifier_2
  LDA $12
  RTL
Padbyte $FF : pad $A0A476

org $89AB90
  JMP ResetLavaFade_nocheck
org $89ABA3
  JMP ResetLavaFade_nocheck
org $89ACC0
  JMP ResetLavaFade

org $89AF80
print "ResetLavaFade_long"
print pc
ResetLavaFade_long:
  STA $1978 ; Set Lava Height
  STA $1962
  PHP : PHB : BRA ResetLavaFade

ResetLavaFade:
  LDA $196E
  CMP #$0002
  BNE ResetLavaFade_nocheck

  LDA $197E  ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
  BIT #$0004 ; Check for water disable flag set
  BNE .skip_suit_check

  LDA $09A2
  BIT !BitSuit3
  BEQ ResetLavaFade_nocheck
.skip_suit_check

  PHX
  JSL $90EC58
  CMP $1962
  BPL +
  PLY
  BRA ResetLavaFade_opaque
+

  LDA #$000F
  STA $7FFD7E

  ASL
  ASL
  TAX
  LDA.l LavaPaletteTable,x
  STA $7EC232
  LDA.l LavaPaletteTable+2,x
  STA $7EC234
  PLX

  BRA ResetLavaFade_exit

ResetLavaFade_opaque:
  LDA.l LavaPaletteTable
  STA $7EC232
  LDA.l LavaPaletteTable+2
  STA $7EC234

ResetLavaFade_nocheck:
  LDA #$0000
  STA $7FFD7E

ResetLavaFade_exit:
  PLB
  PLP
  RTL

org $9BCC00 ;Default
  DB $00, $38, $C3, $00, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $AF, $02, $04, $11, $74, $00, $0D, $00

org $9BCC80 ;Speed squat
  DB $00, $00, $05, $01, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $40, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $AA, $1D, $A7, $1F, $EB, $2C, $E7, $4B, $2D, $36, $9F, $5F, $15, $57, $B2, $4A, $7C, $1D, $E7, $1E, $07, $1E, $A7, $1E, $AA, $29, $56, $1D, $F1, $1C
  DB $00, $00, $70, $3E, $CF, $3F, $F2, $49, $EF, $5B, $D3, $4E, $BF, $6B, $58, $63, $16, $5B, $5D, $3E, $4F, $3F, $AF, $3E, $0F, $3F, $71, $46, $39, $3E, $F6, $3D
  DB $00, $00, $36, $5F, $D7, $5F, $F8, $62, $F7, $6B, $59, $67, $DF, $73, $9B, $6F, $7A, $6B, $1E, $5F, $97, $5F, $57, $5F, $77, $5F, $38, $63, $1C, $5F, $FA, $5E

org $9BCD00 ;Loading/Charge/Death
  DB $00, $00, $03, $01, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $40, $02, $04, $11, $74, $00, $0D, $00
  DB $63, $0C, $47, $0D, $A3, $0F, $68, $20, $E3, $43, $EA, $29, $9F, $5B, $F3, $4E, $70, $42, $1B, $0D, $C3, $0E, $A3, $0D, $63, $0E, $47, $1D, $D5, $0C, $6F, $0C
  DB $E7, $1C, $AA, $1D, $A7, $1F, $EB, $2C, $E7, $4B, $2D, $36, $9F, $5F, $15, $57, $B2, $4A, $7C, $1D, $E7, $1E, $07, $1E, $A7, $1E, $AA, $29, $56, $1D, $F1, $1C
  DB $6B, $2D, $0D, $2E, $AB, $2F, $6E, $39, $EB, $53, $70, $42, $BF, $63, $36, $5B, $D4, $52, $DC, $2D, $0B, $2F, $4B, $2E, $CB, $2E, $0E, $3A, $B8, $2D, $73, $2D
  DB $EF, $3D, $70, $3E, $CF, $3F, $F2, $49, $EF, $5B, $D3, $4E, $BF, $6B, $58, $63, $16, $5B, $5D, $3E, $4F, $3F, $AF, $3E, $0F, $3F, $71, $46, $39, $3E, $F6, $3D
  DB $73, $4E, $D3, $4E, $D3, $4F, $75, $56, $F3, $63, $16, $5B, $BF, $6F, $7A, $6B, $58, $63, $BD, $4E, $73, $4F, $F3, $4E, $53, $4F, $D4, $52, $9A, $4E, $78, $4E
  DB $F7, $5E, $36, $5F, $D7, $5F, $F8, $62, $F7, $6B, $59, $67, $DF, $73, $9B, $6F, $7A, $6B, $1E, $5F, $97, $5F, $57, $5F, $77, $5F, $38, $63, $1C, $5F, $FA, $5E
  DB $7B, $6F, $99, $6F, $DB, $6F, $7B, $6F, $FB, $73, $9C, $73, $DF, $77, $BD, $77, $BC, $73, $7E, $6F, $BB, $6F, $9B, $6F, $BB, $6F, $9B, $6F, $7D, $6F, $7C, $6F

org $9BCE00 ;Speed boost
  DB $00, $00, $05, $01, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $40, $02, $04, $11, $74, $00, $0D, $00
  DB $03, $20, $CB, $28, $AD, $37, $05, $3C, $E0, $63, $A8, $49, $9F, $7F, $D2, $72, $4E, $62, $BB, $28, $AD, $36, $C0, $35, $6A, $2A, $04, $39, $74, $28, $0D, $28
  DB $03, $20, $6B, $51, $B2, $4B, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $AD, $4A, $20, $4A, $0C, $53, $A4, $61, $14, $51, $AD, $50
  DB $00, $00, $AB, $52, $B7, $5F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $4D, $5F, $C0, $5E, $EC, $53, $E4, $62, $54, $52, $ED, $51

org $9BCE80 ;Screw attack
  DB $00, $38, $C3, $00, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $AF, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $38, $A8, $01, $E0, $03, $45, $15, $E0, $43, $E8, $22, $FF, $57, $F2, $4B, $8E, $3B, $FB, $01, $40, $03, $00, $02, $54, $03, $44, $12, $B4, $01, $4D, $01
  DB $00, $38, $48, $02, $E0, $33, $85, $16, $E0, $4F, $E8, $23, $FF, $57, $F2, $4B, $EE, $3B, $3B, $03, $E0, $03, $A0, $02, $F4, $03, $84, $13, $F4, $02, $8D, $02
  DB $00, $38, $E8, $02, $E0, $5B, $C5, $3F, $E0, $63, $E8, $4B, $FF, $7F, $F2, $73, $EE, $63, $FB, $2B, $E0, $37, $40, $03, $F2, $2B, $E4, $3B, $F4, $2B, $ED, $2B

org $9BCF00 ;Shine spark
  DB $00, $38, $05, $01, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $40, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $38, $CB, $01, $C9, $0F, $2E, $21, $E9, $47, $70, $2E, $BF, $63, $36, $57, $D4, $46, $7C, $01, $0A, $03, $09, $02, $A9, $02, $0D, $1E, $98, $0D, $33, $0D
  DB $00, $38, $70, $02, $D2, $17, $36, $32, $F1, $57, $37, $3F, $DF, $73, $9B, $67, $79, $57, $5D, $02, $74, $03, $B1, $02, $12, $03, $F5, $2E, $9B, $1E, $39, $1E
  DB $00, $38, $36, $03, $FB, $23, $5F, $3F, $FA, $63, $FF, $4B, $FF, $7F, $FF, $73, $FF, $63, $1E, $03, $DE, $03, $5A, $03, $7B, $03, $FE, $3B, $BF, $2B, $5F, $2B

DeathPaletteTable:
  DW $B7D3, $B7E7, $B7FB, #GreenSuitDeathPalette
GreenSuitDeathPalette:
  DW $CD00, $9420, $CD20, $CD40, $CD60, $CD80, $CDA0, $CDC0, $CD00, $A220

org $90ECB6
  JSL LoadPaletteIndex
  RTS

;----------------------------------------------------------
; There was duplicate code in these functions that are 
; close enough to each other to BRA. So the longer version
; of the load is spread across the space freed up by
; cleaning up the duplicates.
;
org $91DE6A
  JSR LoadSuitPalette
  JSR $DD5B ; update live samus palette
  JMP $91DE8D ; jump around to the rest of the function this hijack is in

YellowSuitPalette:
  LDX #$9400
  BRA DoneLoadingPalette
OrangeSuitPalette:
  LDX #$9520
  BRA DoneLoadingPalette
PurpleSuitPalette:
  LDX #$9800
  BRA DoneLoadingPalette
GreenSuitPalette:
  LDX #$CC00
  BRA DoneLoadingPalette
Padbyte $FF : pad $91DE8D

org $91DEBA
  PHP
  PHB
  PHK
  PLB
  REP #$30
  JSR LoadSuitPalette
  JSR $DD5B ; update live samus palette
  PLB
  PLP
  RTL

LoadSuitPalette:
  LDA $09A2
  BIT !BitSuit3
  BNE GreenSuitPalette
  BIT !BitSuit2
  BNE OrangeSuitPalette
  BIT !BitSuit1
  BNE PurpleSuitPalette
  BRA YellowSuitPalette
DoneLoadingPalette:
  RTS
Padbyte $FF : pad $91DEE6

org $91DEE6
  PHP
  PHB
  PHK
  PLB
  REP #$30
  JSR LoadSuitPalette
  JSR $DDD7 ; update target/backup samus palette
  PLB
  PLP
  RTL
p_2:
  DW $CF60, $CF60, $CF60, $CC00, $CC00, $CC00
p_3:
  DW $CD00, $CD20, $CD40, $CD60, $CD40, $CD20
Padbyte $FF : pad $91DF12

org $9BB4BC
  LDA DeathPaletteTable,y ;LDA $B5C8,y
org $9BB5D4
  LDA DeathPaletteTable,y ;LDA $B6D2,y

;----------------------------------------------------------

org $90F23C
  JSR LoadFromSave
  JSL $91DEBA
  JSL $91F433
  LDA #$0003
  STA $0A94
  LDA #$0002
  STA $0A96
  STZ $0DEC
  SEC
  RTS
warnpc $90F28D
;Padbyte $FF : pad $90F28D
  

;----------------------------------------------------------
; Called during room transition to setup the pointers used
; for the Norfair area glow that affects Samus' palette.
org $8DE3BE
  JSL SetupCodePointer_1
  LDA ($12),y
  STA $1EBD,x
  RTS
Padbyte $FF : pad $8DE3DF
  RTS ; there is a branch to this RTS

org $8DE440
  JSL SetupCodePointer_2
  RTS
Padbyte $FF : pad $8DE45E

;---------------------------------------------------------
; Things that use the palette index to look up palettes

; charge release; wall jump with screw attack
org $91D717
  JSL Load_1 ;LDX $0A74
  NOP : NOP ;LDA $D727,x

org $91D762
  JSL Load_2 ;LDX $0A74
  NOP : NOP ;LDA $D7FF,x  ; charge flashing suit
  ;STA $24
  ;BRA $08
org $91D76C
  JSL Load_3 ;LDX $0A74
  NOP : NOP ;LDA $D7D5,x
  ;STA $24

  ;LDA $0B62
  ;CLC
  ;ADC $24
  ;TAX
  ;LDA $0000,x
  ;TAX
  ;JSR $DD5B

org $91D95B
  JSL Load_4 ;LDX $0A74
  NOP : NOP ;LDA $D998,x

org $91DA1B
  JSL Load_5 ;LDX $0A74
  NOP : NOP ;LDA $DA4A,x
  NOP : NOP ;STA $24
  NOP : NOP : NOP ;LDA $0ACE
  NOP ;CLC
  NOP : NOP ;ADC $24
  NOP ;TAX
  NOP : NOP : NOP ;LDA $0000,x
  ;TAX
  ;JSR $DD5B

org $91DA81
  JSL Load_6 ;LDX $0A74
  NOP : NOP ;LDA $DAA9,x
  NOP : NOP ;STA $24
  NOP : NOP : NOP ;LDA $0ACE
  NOP ;CLC
  NOP : NOP ;ADC $24
  NOP ;TAX
  NOP : NOP : NOP ;LDA $0000,x
  ;TAX
  ;JSR $DD5B

org $91DAE0
  JSL Load_7 ;LDX $0A74
  NOP : NOP ;LDA $DB10,x
  NOP : NOP ;STA $24
  NOP : NOP : NOP ;LDA $0ACE
  NOP ;CLC
  NOP : NOP ;ADC $24
  NOP ;TAX
  NOP : NOP : NOP ;LDA $0000,x
  ;TAX
  ;JSR $DD5B

org $91DB45
  JSL Load_8 ;LDX $0A74
  NOP : NOP ;LDA $DB75,x
  NOP : NOP ;STA $24
  NOP : NOP : NOP ;LDA $0ACE
  NOP ;CLC
  NOP : NOP ;ADC $24
  NOP ;TAX
  NOP : NOP : NOP ;LDA $0000,x
  ;TAX
  ;JSR $DD5B

; clear out the existing tables that are getting replaced
org $91D727
  REP 3 : DW $FFFF
org $91D7FF
  REP 3 : DW $FFFF
org $91D7D5
  REP 3 : DW $FFFF
org $91D998
  REP 3 : DW $FFFF
org $91DA4A
  REP 3 : DW $FFFF
org $91DAA9
  REP 3 : DW $FFFF
org $91DB10
  REP 3 : DW $FFFF
org $91DB75
  REP 3 : DW $FFFF

org $91DA50
  REP 6 : DW $FFFF
org $91DA5C
  REP 6 : DW $FFFF
org $91DA68
  REP 6 : DW $FFFF

org $91DAAF
  REP 4 : DW $FFFF
org $91DAB7
  REP 4 : DW $FFFF
org $91DABF
  REP 4 : DW $FFFF

org $91DB16
  REP 6 : DW $FFFF
org $91DB22
  REP 6 : DW $FFFF
org $91DB2E
  REP 6 : DW $FFFF

org $91DB7B
  REP 4 : DW $FFFF
org $91DB83
  REP 4 : DW $FFFF
org $91DB8B
  REP 4 : DW $FFFF

;----------------------------------------------------------

org $90F840 ; Free space
  DW $9400, $9520, $9800, $CC00
  DW $D805, $D811, $D81D, #p_2
  DW $D7DB, $D7E7, $D7F3, #p_3
  DW $9B80, $9D80, $9F80, $CE60
  DW #ScrewAttackTable+0, #ScrewAttackTable+12, #ScrewAttackTable+24, #ScrewAttackTable+36 ;DW $DA50, $DA5C, $DA68
  DW #SpeedBoostTable+0, #SpeedBoostTable+8, #SpeedBoostTable+16, #SpeedBoostTable+24 ;DW $DAAF, $DAB7, $DABF
  DW #SpeedSquatTable+0, #SpeedSquatTable+12, #SpeedSquatTable+24, #SpeedSquatTable+36 ;DW $DB16, $DB22, $DB2E
  DW #ShineSparkTable+0, #ShineSparkTable+8, #ShineSparkTable+16, #ShineSparkTable+24 ;DW $DB7B, $DB83, $DB8B

ScrewAttackTable:
  DW $9CA0, $9CC0, $9CE0, $9D00, $9CE0, $9CC0
  DW $9EA0, $9EC0, $9EE0, $9F00, $9EE0, $9EC0
  DW $A0A0, $A0C0, $A0E0, $A100, $A0E0, $A0C0
  DW $CE80, $CEA0, $CEC0, $CEE0, $CEC0, $CEA0

SpeedBoostTable:
  DW $9B20, $9B40, $9B60, $9B80
  DW $9D20, $9D40, $9D60, $9D80
  DW $9F20, $9F40, $9F60, $9F80
  DW $CE00, $CE20, $CE40, $CE60

SpeedSquatTable:
  DW $9BA0, $9BC0, $9BE0, $9C00, $9BE0, $9BC0
  DW $9DA0, $9DC0, $9DE0, $9E00, $9DE0, $9DC0
  DW $9FA0, $9FC0, $9FE0, $A000, $9FE0, $9FC0
  DW $CC80, $CCA0, $CCC0, $CCE0, $CCC0, $CC80

ShineSparkTable:
  DW $9C20, $9C40, $9C60, $9C80
  DW $9E20, $9E40, $9E60, $9E80
  DW $A020, $A040, $A060, $A080
  DW $CF00, $CF20, $CF40, $CF60

Load_1:
  LDX $0A74
  LDA $90F840,x
  RTL
Load_2:
  LDX $0A74
  LDA $90F848,x
  RTL
Load_3:
  LDX $0A74
  LDA $90F850,x
  RTL
Load_4:
  LDX $0A74
  LDA $90F858,x
  RTL
Load_5:
  LDX $0A74
  LDA $90F860,x
  BRA LoadSecondTable
Load_6:
  LDX $0A74
  LDA $90F868,x
  BRA LoadSecondTable
Load_7:
  LDX $0A74
  LDA $90F870,x
  BRA LoadSecondTable
Load_8:
  LDX $0A74
  LDA $90F878,x
  BRA LoadSecondTable

LoadSecondTable:
  STA $24
  LDA $0ACE
  CLC
  ADC $24
  TAX
  LDA $900000,x
  RTL

GetSuitModifierOffset:
  LDX #$0000
  LDA $09A2 ; equipped items
  BIT !BitSuit3
  BEQ +
  INX : INX
+
  BIT !BitSuit2
  BEQ +
  INX : INX
+
  BIT !BitSuit1
  BEQ +
  INX : INX
+
  RTS


ApplySuitModifier:
  PHX
  JSR GetSuitModifierOffset
  JMP (ApplySuitModifier_jumptable,X)

ApplySuitModifier_jumptable:
  DW #ApplySuitModifier_normal
  DW #ApplySuitModifier_threequarter
  DW #ApplySuitModifier_half
  DW #ApplySuitModifier_quarter

ApplySuitModifier_threequarter:
  LDA $0A4F
  LSR A
  STA $18
  LSR A
  CLC
  ADC $18
  BRA ComputeNewDamage
ApplySuitModifier_half:
  LDA $0A4F
  LSR A
  BRA ComputeNewDamage
ApplySuitModifier_quarter:
  LDA $0A4F
  LSR A
  LSR A
ComputeNewDamage:

  PHA
  LDA #$0038 ;hard mode
  JSL $808233
  BCC +
  PLA : ASL : PHA
+

  LDA #$003A ;easy mode
  JSL $808233
  BCC +
  PLA : LSR : PHA
+
  PLA : PHA

  XBA
  AND #$FF00
  STA $0A4E
  PLA
  XBA
  AND #$00FF
  STA $0A50

ApplySuitModifier_normal:
  PLX
  RTS

ApplySuitModifier_2:
  PHX
  JSR GetSuitModifierOffset
  JMP (ApplySuitModifier_2_jumptable,X)

ApplySuitModifier_2_jumptable:
  DW #ApplySuitModifier_2_normal
  DW #ApplySuitModifier_2_threequarter
  DW #ApplySuitModifier_2_half
  DW #ApplySuitModifier_2_quarter

 ApplySuitModifier_2_threequarter:
  LDA $12
  LSR A
  STA $12
  LSR A
  CLC
  ADC $12
  STA $12
  PLX
  RTL
ApplySuitModifier_2_half:
  LSR $12
  PLX
  RTL
ApplySuitModifier_2_quarter:
  LSR $12
  LSR $12
ApplySuitModifier_2_normal:
  PLX
  RTL

LoadPaletteIndex:
  LDA $09A2
  BIT !BitSuit3
  BNE GreenSuitPaletteIndex
  BIT !BitSuit2
  BNE OrangeSuitPaletteIndex
  BIT !BitSuit1
  BNE PurpleSuitPaletteIndex
YellowSuitPaletteIndex:
  STZ $0A74
  RTL
PurpleSuitPaletteIndex:
  LDA #$0004
  STA $0A74
  RTL
OrangeSuitPaletteIndex:
  LDA #$0002
  STA $0A74
  RTL
GreenSuitPaletteIndex:
  LDA #$0006
  STA $0A74
  RTL

LoadFromSave:
  LDA $09A2
  BIT !BitSuit3
  BNE LoadFromSaveGreen
  BIT !BitSuit2
  BNE LoadFromSaveOrange
  BIT !BitSuit1
  BNE LoadFromSavePurple
  BRA LoadFromSaveYellow
LoadFromSaveYellow:
  LDY #LoadFromSaveGlowList+0 ;#$E1F4
  JSL $8DC4E9
  LDA #$0000
  STA $0A1C
  RTS
LoadFromSavePurple:
  LDY #LoadFromSaveGlowList+4 ;#$E1FC
  JSL $8DC4E9
  LDA #$009B
  STA $0A1C
  RTS
LoadFromSaveOrange:
  LDY #LoadFromSaveGlowList+8 ;#$E1F8
  JSL $8DC4E9
  LDA #$009B
  STA $0A1C
  RTS
LoadFromSaveGreen:
  LDY #LoadFromSaveGlowList+12
  JSL $8DC4E9
  LDA #$009B
  STA $0A1C
  RTS

SetupCodePointer_1:
  LDA $09A2
  BIT !BitSuit3
  BNE SetupGreenCodePointer_1
  BIT !BitSuit2
  BNE SetupOrangeCodePointer_1
  BIT !BitSuit1
  BNE SetupPurpleCodePointer_1

SetupYellowCodePointer_1:
  LDA #YellowHeatGlowJumpList
  BRA StoreCodePointer_1
SetupPurpleCodePointer_1:
  LDA #PurpleHeatGlowJumpList
  BRA StoreCodePointer_1
SetupOrangeCodePointer_1:
  LDA #OrangeHeatGlowJumpList
  BRA StoreCodePointer_1
SetupGreenCodePointer_1:
  LDA #GreenHeatGlowJumpList

StoreCodePointer_1:
  STA $12
  RTL

SetupCodePointer_2:
  LDA $09A2
  BIT !BitSuit3
  BNE SetupGreenCodePointer_2
  BIT !BitSuit2
  BNE SetupOrangeCodePointer_2
  BIT !BitSuit1
  BNE SetupPurpleCodePointer_2

SetupYellowCodePointer_2:
  LDA #YellowHeatGlowStart
  BRA StoreCodePointer_2
SetupPurpleCodePointer_2:
  LDA #PurpleHeatGlowStart
  BRA StoreCodePointer_2
SetupOrangeCodePointer_2:
  LDA #OrangeHeatGlowStart
  BRA StoreCodePointer_2
SetupGreenCodePointer_2:
  LDA #GreenHeatGlowStart

StoreCodePointer_2:
  STA $1EBD,y
  RTL

!ovalred   = #$19 ;#%00101001 ;abcddddd a = Blue b = Green c = Red ddddd = Color Data
!ovalgreen = #$50 ;#%01010000 ;abcddddd a = Blue b = Green c = Red ddddd = Color Data
!ovalblue  = #$89 ;#%10001001 ;abcddddd a = Blue b = Green c = Red ddddd = Color Data

StartOvalColor:
  LDA $1C1F
  CMP #$001A
  BNE StartGreenOval
  SEP #$30
  LDA #$30
  STA $0DF0
  LDA #$49
  STA $0DF1
  LDA #$90
  STA $0DF2
  LDA #$02
  STA $0DF3 ;????
  REP #$30
  RTL
StartGreenOval:
  SEP #$30
  LDA !ovalred
  STA $0DF0
  LDA !ovalgreen
  STA $0DF1
  LDA !ovalblue
  STA $0DF2
  LDA #$01
  STA $0DF3 ;????
  REP #$30
  RTL

RestoreOvalColor:
  LDA $1C1F
  CMP #$001A
  BNE RestoreGreenOval
  SEP #$20
  LDA $0DF0
  CMP #$30
  BEQ max_poval_r
  DEC A
  STA $0DF0
max_poval_r:
  LDA $0DF1
  CMP #$49
  BEQ max_poval_g
  DEC A
  STA $0DF1
max_poval_g:
  LDA $0DF2
  CMP #$90
  BEQ max_poval_b
  DEC A
  STA $0DF2
max_poval_b:
  REP #$20
  SEC
  RTL
RestoreGreenOval:
  SEP #$20
  LDA $0DF0
  CMP !ovalred
  BEQ max_goval_r
  DEC A
  STA $0DF0
max_goval_r:
  LDA $0DF1
  CMP !ovalgreen
  BEQ max_goval_g
  DEC A
  STA $0DF1
max_goval_g:
  LDA $0DF2
  CMP !ovalblue
  BEQ max_goval_b
  DEC A
  STA $0DF2
max_goval_b:
  REP #$20
  SEC
  RTL


SetLavaPhysics:
  LDA #$0002  ;\
  STA $0AD2   ;} Liquid physics type = lava

  JSL CheckLavaPhysicsSuit
  BNE +
  LDA $9E95
  STA $0A9C   ; Set Animation frames delay for lava
  RTS
+
  STZ $0A9C   ; Clear Animation frames delay
  RTS

CheckLavaPhysics:
  LDA $197E ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
  BIT #$0004 ; Check for water disable flag set
  BEQ CheckLavaPhysicsSuit
  RTL
CheckLavaPhysicsSuit:
  LDA $09A2
  BIT !BitSuit1 ; What grants immunity lava physics?
  RTL

CheckLavaPhysics_2:
  JSL CheckLavaPhysics
  BNE NoLavaPhysics
  JSL $90EC3E
  LDA $195E
  RTL
NoLavaPhysics:
  LDA #$FFFF
  RTL

IceEffect:
print pc
  LDA #$003A ;easy mode
  JSL $808233
  BCS IceEffect_return

  LDA $0E18
  BNE IceEffect_return
  LDA $197E  ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
  BIT #$0002 ; Check for 'heat' bit
  BEQ IceEffect_return

  LDX #$0000
  LDA $09A2
  BIT !BitSuit3
  BEQ IceEffect_nometroidsuit
  LDX #$0002
IceEffect_nometroidsuit:

  LDA $09A2
  BIT !BitSuit2
  BEQ IceEffect_novariasuit
  INX
IceEffect_novariasuit:

  CPX #$0001
  BEQ IceEffect_nobeep
  LDA $09DA   ;\
  BIT #$0007  ;} If [in-game time frames] % 8 = 0:
  BNE IceEffect_nobeep ;/
  LDA $09C2   ;\
  CMP #$0047  ;} If [Samus' health] >= 71:
  BMI IceEffect_nobeep
  PHX
  LDA #$002D  ;\
  JSL $809139 ;} Queue sound 2Dh, sound library 3, max queued sounds allowed = 3
  PLX
IceEffect_nobeep:

  TXA
  ASL
  ASL
  TAX

  LDA $0A4E         ;\
  CLC               ;|
  ADC IceDamage+2,x ;|
  STA $0A4E         ;}
  LDA $0A50         ;|
  ADC IceDamage+0,x ;|
  STA $0A50         ;/F
IceEffect_return:
  RTS

IceDamage: 
  DW $0000, $0C00 ; no suit
  DW $0000, $0000 ; varia
  DW $0001, $8000 ; metroid
  DW $0000, $8000 ; metroid + varia

LavaFadeOut:
  LDA $09A2
  BIT #$0800
  BEQ +
  LDA #%0100011000110001
  STA $7EC032
  LDA #%0011110111101111
  STA $7EC034
+

  LDA $1962
  CMP $14
  BPL LavaFadeIn

  LDA $09DA
  BIT #$0003
  BNE LavaFade_Exit
  LDA $7FFD7E
  INC
  BIT #$0010
  BNE LavaFade_Exit
  STA $7FFD7E
  BRA LoadLavaPalette
LavaFadeIn:
  LDA $09DA
  BIT #$0003
  BNE LavaFade_Exit
  LDA $7FFD7E
  DEC
  BMI LavaFade_Exit
  STA $7FFD7E
  BRA LoadLavaPalette
LavaFade_Exit:
  RTS

LoadLavaPalette:
  PHX
  ASL
  ASL
  TAX
  LDA $09A2
  BIT #$0800
  BNE LoadLavaPaletteWithThermal
  LDA.w LavaPaletteTable,x
  STA $7EC032
  STA $7EC232
  LDA.w LavaPaletteTable+2,x
  STA $7EC034
StoreLastLavaPalette:
  STA $7EC234
  PLX
  RTS
LoadLavaPaletteWithThermal:
  LDA.w LavaPaletteTable,x
  STA $7EC232
  LDA.w LavaPaletteTable+2,x
  BRA StoreLastLavaPalette
;  STA $7EC234
;  PLX
;  RTS

LavaPaletteTable:
  DW #%0000111000111111, #%0000110101111111
  DW #%0000111000011110, #%0000110101011101
  DW #%0000111000011100, #%0000110100111011
  DW #%0000110111111010, #%0000110100011001
  DW #%0000100111011001, #%0000100011110111
  DW #%0000100111011000, #%0000100011010101
  DW #%0000100110110110, #%0000100010110011
  DW #%0000100110010101, #%0000100010010001
  DW #%0000010110010011, #%0000010001101111
  DW #%0000010101110010, #%0000010001001101
  DW #%0000010101010000, #%0000010000101011
  DW #%0000010101001111, #%0000010000001001
  DW #%0000000100101101, #%0000000000000111
  DW #%0000000100001100, #%0000000000000101
  DW #%0000000011001011, #%0000000000000011
  DW #%0000000010101010, #%0000000000000011

print pc
warnpc $90FFFF

; --------------------------------------------------------------
; Item definition, referenced by the files in the PLMs directory.
org $89B240 ; graphics
PLM_Graphics:
  incbin ROMProject/Graphics/suit3.gfx

org $84FE20
  ; item header: EE64 for a pickup
  DW $EE64,item_data

item_data:
  DW $8764,PLM_Graphics
    DB 1,1,1,1,1,1,1,1  ; make it green
  DW $887C,end_plm ; if item has been picked up, delete PLM
  DW $8A2E,$DFAF ; chozo ball stuff (x2)
  DW $8A2E,$DFC7
  DW $8A24,pickup_plm ; save address of 'pickup triggered' PLM routine
  DW $86C1,$DF89 ; set pre-PLM instruction
  DW $874E       ; store $16 to 1D77,X (the 'variable use PLM value')
    DB $16         ; no idea why, but Chaos Arms did it, and taking it out crashes.

gfx_plm:
  DW $E04F       ; graphics/pickup stuff
  DW $E067       ; flashing animation
  DW $8724,gfx_plm ; use graphics stuff as next (frame's?) PLM instruction

pickup_plm:
  DW $8899       ; mark PLM as picked up
  DW $8BDD
    DB $02       ; play track 02 (item collect)
  DW $E29D       ; set charge to 0
  DW MetroidSuitCollect,$0000 ; item type + value (the latter unused)
    DB $24       ; msgbox identifier, I think $1D may be the first free msgbox?
  DW $870B
    DL $91D5BA
  DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
  DW $86BC       ; done: delete PLM

; PLM arguments:
; Value (2 bytes), unused since the math is too hard for me yet
; Message box (1 byte)

MetroidSuitCollect:
  LDA $09A4 ; collected items
  ORA !BitSuit3
  STA $09A4

  LDA $09A2 ; load equipped items
  ORA !BitSuit3
  STA $09A2

  LDA #$0168  ; frame delay for music/messagebox
  JSL $82E118 ; do music

  LDA $0002,Y ; grab message box arg
  AND #$00FF  ; convert to byte
  JSL $858080 ; display message box

  INY         ; advance past our args, to next instruction
  INY
  INY
  RTS         ; return to PLM loop

;----------------------------------------------------------
; hijacks into the gravity collect code to make load the
; colors for two suits as appropriate.
;
org $91D5BE
  JSL StartOvalColor
  ;NOP : NOP ;SEP #$30
  ;NOP : NOP ;LDA !ovalred
  NOP : NOP : NOP ;STA $0DF0
  NOP : NOP ;LDA !ovalgreen
  NOP : NOP : NOP ;STA $0DF1
  NOP : NOP ;LDA !ovalblue
  NOP : NOP : NOP ;STA $0DF2
  NOP : NOP ;LDA #$01
  NOP : NOP : NOP ;STA $0DF3 ;????
  NOP : NOP ;REP #$30

org $88E3A2
  JSL RestoreOvalColor
  RTS


;----------------------------------------------------------
; Glow
;

;$C655 - 2 (store arg in $1E8D,x)
;$C648 - 1 (store arg in $1EDD,x)
;$C595 - 2 (calls $C589; break loop)
;$C589 - 2 (load $1E7B into X; store 4+y in $1EBD,x)
;$C639 - 2 (DEC 1EDD,x; if == 0 go next, else jmp arg)
;$C5CF - 0 (disable this animation; break loop)
;positive number - store in $1ECD,x, load $1E8D,x into X, and start copying palette data to $7EC000,x

;org $8DDB62
;DB $55, $C6, $80, $01

;DB $48, $C6, $24, $03, $00
;DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
;DB $95, $C5, $03, $00
;DB $00, $00, $AE, $52, $BD, $5F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $55, $5F, $0B, $5E, $F6, $53, $E4, $62, $54, $52, $ED, $51
;DB $95, $C5, $39, $C6, $69, $DB

;DB $48, $C6, $03, $03, $00
;DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
;DB $95, $C5, $03, $00
;DB $00, $00, $AE, $52, $BD, $5F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $55, $5F, $0B, $5E, $F6, $53, $E4, $62, $54, $52, $ED, $51
;DB $95, $C5, $39, $C6, $B8, $DB

;DB $48, $C6, $03, $03, $00
;DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
;DB $95, $C5, $03, $00
;DB $03, $20, $6E, $51, $BD, $4B, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $B5, $4A, $6B, $49, $B6, $52, $A4, $61, $14, $51, $AD, $50
;DB $95, $C5, $39, $C6, $07, $DC

;DB $48, $C6, $02, $03, $00
;DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
;DB $95, $C5, $03, $00
;DB $03, $20, $CE, $28, $BD, $37, $05, $3C, $E0, $63, $A8, $49, $9F, $7F, $D2, $72, $4E, $62, $BB, $28, $B5, $36, $6B, $35, $16, $2A, $04, $39, $74, $28, $0D, $28
;DB $95, $C5, $39, $C6, $56, $DC

;DB $01, $00
;DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
;DB $95, $C5, $CF, $C5

org $9BD000
SamusGlowPaletteTable:
;-------- Load From Save
; Yellow
  DB $00, $38, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $AE, $52, $BD, $5F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $55, $5F, $0B, $5E, $F6, $53, $E4, $62, $54, $52, $ED, $51
  DB $03, $20, $6E, $51, $BD, $4B, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $B5, $4A, $6B, $49, $B6, $52, $A4, $61, $14, $51, $AD, $50
  DB $03, $20, $CE, $28, $BD, $37, $05, $3C, $E0, $63, $A8, $49, $9F, $7F, $D2, $72, $4E, $62, $BB, $28, $B5, $36, $6B, $35, $16, $2A, $04, $39, $74, $28, $0D, $28
; Orange
  DB $00, $00, $08, $01, $FF, $02, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $BE, $01, $8E, $00, $52, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $A8, $79, $9F, $7B, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $5E, $76, $2E, $75, $4D, $52, $E4, $62, $54, $52, $ED, $51
  DB $03, $20, $08, $51, $FF, $52, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $BE, $51, $8E, $50, $4D, $3E, $A4, $61, $14, $51, $AD, $50
  DB $03, $20, $08, $29, $FF, $2A, $05, $3C, $E0, $63, $A8, $49, $9F, $7F, $D2, $72, $4E, $62, $BB, $28, $BE, $29, $8E, $28, $4D, $2A, $04, $39, $74, $28, $0D, $28
; Purple
  DB $00, $38, $08, $01, $1F, $42, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $14, $59, $AA, $30, $74, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $AE, $52, $FF, $7F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $F4, $7E, $8A, $7E, $F6, $53, $E4, $62, $54, $52, $ED, $51
  DB $03, $20, $6E, $51, $BF, $7E, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $B4, $7D, $4A, $7D, $B6, $52, $A4, $61, $14, $51, $AD, $50
  DB $03, $20, $6E, $51, $BF, $7E, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $B4, $7D, $4A, $7D, $B6, $52, $A4, $61, $14, $51, $AD, $50
; Green
  DB $00, $38, $C3, $00, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $AF, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $AB, $52, $A0, $5F, $E5, $65, $E0, $7F, $88, $73, $FF, $7F, $F2, $7F, $EE, $7F, $9B, $56, $40, $5F, $00, $5E, $E0, $53, $E4, $62, $54, $52, $ED, $51
  DB $03, $20, $6B, $51, $A0, $4B, $A5, $64, $E0, $7F, $48, $72, $FF, $7F, $72, $7F, $EE, $7E, $5B, $55, $A0, $4A, $60, $49, $A0, $52, $A4, $61, $14, $51, $AD, $50
  DB $03, $20, $CB, $28, $A0, $37, $05, $3C, $E0, $63, $A8, $49, $9F, $7F, $D2, $72, $4E, $62, $BB, $28, $A0, $36, $60, $35, $00, $2A, $04, $39, $74, $28, $0D, $28
;-------- Heat Glow
; Yellow
  DB $00, $00, $08, $01, $BD, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $B5, $02, $6B, $01, $52, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $09, $01, $BD, $03, $06, $14, $E1, $3B, $CA, $25, $9F, $57, $D3, $4A, $4F, $3A, $BC, $00, $B6, $02, $6C, $01, $53, $02, $05, $11, $75, $00, $0E, $00
  DB $00, $00, $0A, $01, $BE, $03, $07, $14, $E2, $3B, $CC, $25, $9F, $57, $D4, $4A, $50, $3A, $BC, $00, $B7, $02, $6D, $01, $54, $02, $06, $11, $76, $00, $0F, $00
  DB $00, $00, $0B, $01, $BE, $03, $08, $14, $E3, $3B, $EE, $29, $9F, $57, $D5, $4A, $51, $3A, $BD, $00, $B8, $02, $6E, $01, $55, $02, $07, $11, $77, $00, $10, $00
  DB $00, $00, $0D, $01, $BE, $03, $0A, $14, $E5, $3B, $0F, $2E, $9F, $57, $D7, $4A, $53, $3A, $BD, $00, $BA, $02, $70, $01, $57, $02, $09, $11, $79, $00, $12, $00
; Orange
  DB $00, $00, $08, $01, $FF, $02, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $BE, $01, $8E, $00, $52, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $09, $01, $FF, $02, $06, $14, $E1, $3B, $CA, $25, $9F, $57, $D3, $4A, $4F, $3A, $BC, $00, $BE, $01, $8F, $00, $53, $02, $05, $11, $75, $00, $0E, $00
  DB $00, $00, $0A, $01, $FF, $02, $07, $14, $E2, $3B, $CC, $25, $9F, $57, $D4, $4A, $50, $3A, $BC, $00, $BE, $01, $90, $00, $54, $02, $06, $11, $76, $00, $0F, $00
  DB $00, $00, $0B, $01, $FF, $02, $08, $14, $E3, $3B, $EE, $29, $9F, $57, $D5, $4A, $51, $3A, $BD, $00, $BE, $01, $91, $00, $55, $02, $07, $11, $77, $00, $10, $00
  DB $00, $00, $0D, $01, $FF, $02, $0A, $14, $E5, $3B, $0F, $2E, $9F, $57, $D7, $4A, $53, $3A, $BD, $00, $BF, $01, $93, $00, $57, $02, $09, $11, $79, $00, $12, $00
; Purple
  DB $00, $00, $08, $01, $1F, $42, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $14, $59, $AA, $30, $74, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $09, $01, $1F, $42, $06, $14, $E1, $3B, $CA, $25, $9F, $57, $D3, $4A, $4F, $3A, $BC, $00, $15, $59, $AB, $30, $53, $02, $05, $11, $75, $00, $0E, $00
  DB $00, $00, $0A, $01, $1F, $42, $07, $14, $E2, $3B, $CC, $25, $9F, $57, $D4, $4A, $50, $3A, $BC, $00, $16, $59, $AC, $30, $54, $02, $06, $11, $76, $00, $0F, $00
  DB $00, $00, $0B, $01, $1F, $42, $08, $14, $E3, $3B, $EE, $29, $9F, $57, $D5, $4A, $51, $3A, $BD, $00, $17, $59, $AD, $30, $55, $02, $07, $11, $77, $00, $10, $00
  DB $00, $00, $0D, $01, $1F, $42, $0A, $14, $E5, $3B, $0F, $2E, $9F, $57, $D7, $4A, $53, $3A, $BD, $00, $19, $59, $AF, $30, $57, $02, $09, $11, $79, $00, $12, $00
; Green
  DB $00, $00, $C3, $00, $A0, $03, $05, $14, $E0, $3B, $A8, $21, $9F, $57, $D2, $4A, $4E, $3A, $BB, $00, $A0, $02, $60, $01, $AF, $02, $04, $11, $74, $00, $0D, $00
  DB $00, $00, $06, $01, $A1, $03, $06, $14, $E1, $3B, $CA, $25, $9F, $57, $D3, $4A, $4F, $3A, $BC, $00, $A2, $02, $62, $01, $42, $02, $05, $11, $75, $00, $0E, $00
  DB $00, $00, $07, $01, $A2, $03, $07, $14, $E2, $3B, $CC, $25, $9F, $57, $D4, $4A, $50, $3A, $BC, $00, $A4, $02, $64, $01, $44, $02, $06, $11, $76, $00, $0F, $00
  DB $00, $00, $08, $01, $A3, $03, $08, $14, $E3, $3B, $EE, $29, $9F, $57, $D5, $4A, $51, $3A, $BD, $00, $A6, $02, $66, $01, $47, $02, $07, $11, $77, $00, $10, $00
  DB $00, $00, $0A, $01, $A5, $03, $0A, $14, $E5, $3B, $0F, $2E, $9F, $57, $D7, $4A, $53, $3A, $BD, $00, $AA, $02, $68, $01, $4A, $02, $09, $11, $79, $00, $12, $00

LoadSamusGlowPaletteFromTable:
  STA $12

  PHP
  REP #$30
  PHB
  PEA $9B00
  PLB
  PLB

  PHY
  PHX

  LDA $12
  AND #$00FF
  XBA
  LSR
  LSR
  LSR

  CLC
  ADC #SamusGlowPaletteTable
  TAX

  JSL $97EAE9 ;ThermalVisor.asm => ReloadSamusPalette

  PLX
  PLY

  PLB
  PLP
  RTL

org $8DFFF1
  LDA $0000,y
  JSL LoadSamusGlowPaletteFromTable
  INY
  RTS

org $8DDB62
LoadFromSaveYellowStart:
DW $C655
  DW $0180 ; setup future X offset to point to samus' palette ... we don't actually use this anymore

DW $C648
  DB $20 ; run this section 32 times
LoadFromSaveYellowLoop_1:
DW $FFF1
  DB $00 ; load palette 0
DW $0003, $0000 ; wait 3 frames
DW $C595 ; yeild
DW $FFF1
  DB $01 ; load palette 1
DW $0003, $0000
DW $C595 ; yeild
DW $C639
  DW #LoadFromSaveYellowLoop_1 ; if this section hasn't run the specified number or times, go back to the start of the section

DW $C648
  DB $06
LoadFromSaveYellowLoop_2:
DW $FFF1
  DB $00
DW $0003, $0000
DW $C595
DW $FFF1
  DB $02
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveYellowLoop_2

DW $C648
  DB $07
LoadFromSaveYellowLoop_3:
DW $FFF1
  DB $00
DW $0003, $0000
DW $C595
DW $FFF1
  DB $03
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveYellowLoop_3

DW $FFF1
  DB $00
DW $0001, $0000
DW $C595
DW $C5CF ; Destroy this glow

LoadFromSaveOrangeStart:
DW $C655
  DW $0180

DW $C648
  DB $20
LoadFromSaveOrangeLoop_1:
DW $FFF1
  DB $04
DW $0003, $0000
DW $C595
DW $FFF1
  DB $05
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveOrangeLoop_1

DW $C648
  DB $06
LoadFromSaveOrangeLoop_2:
DW $FFF1
  DB $04
DW $0003, $0000
DW $C595
DW $FFF1
  DB $06
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveOrangeLoop_2

DW $C648
  DB $07
LoadFromSaveOrangeLoop_3:
DW $FFF1
  DB $04
DW $0003, $0000
DW $C595
DW $FFF1
  DB $07
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveOrangeLoop_3

DW $FFF1
  DB $04
DW $0001, $0000
DW $C595
DW $C5CF

LoadFromSavePurpleStart:
DW $C655
  DW $0180

DW $C648
  DB $20
LoadFromSavePurpleLoop_1:
DW $FFF1
  DB $08
DW $0003, $0000
DW $C595
DW $FFF1
  DB $09
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSavePurpleLoop_1

DW $C648
  DB $06
LoadFromSavePurpleLoop_2:
DW $FFF1
  DB $08
DW $0003, $0000
DW $C595
DW $FFF1
  DB $0A
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSavePurpleLoop_2

DW $C648
  DB $07
LoadFromSavePurpleLoop_3:
DW $FFF1
  DB $08
DW $0003, $0000
DW $C595
DW $FFF1
  DB $0B
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSavePurpleLoop_3

DW $FFF1
  DB $08
DW $0001, $0000
DW $C595
DW $C5CF

LoadFromSaveGreenStart:
DW $C655
  DW $0180

DW $C648
  DB $20
LoadFromSaveGreenLoop_1:
DW $FFF1
  DB $0C
DW $0003, $0000
DW $C595
DW $FFF1
  DB $0D
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveGreenLoop_1

DW $C648
  DB $06
LoadFromSaveGreenLoop_2:
DW $FFF1
  DB $0C
DW $0003, $0000
DW $C595
DW $FFF1
  DB $0E
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveGreenLoop_2

DW $C648
  DB $07
LoadFromSaveGreenLoop_3:
DW $FFF1
  DB $0C
DW $0003, $0000
DW $C595
DW $FFF1
  DB $0F
DW $0003, $0000
DW $C595
DW $C639
  DW #LoadFromSaveGreenLoop_3

DW $FFF1
  DB $0C
DW $0001, $0000
DW $C595
DW $C5CF

LoadFromSaveGlowList:
  DW $C685, #LoadFromSaveYellowStart
  DW $C685, #LoadFromSavePurpleStart
  DW $C685, #LoadFromSaveOrangeStart
  DW $C685, #LoadFromSaveGreenStart

Padbyte $FF : Pad $8DDF94

org $8DE3E0
Padbyte $FF : Pad $8DE440

; $C5D4 - 2 (store arg in $1EAD,x)
; $C61E - 2 (jump to arg - used to loop)

org $8DE45E

YellowHeatGlowJumpList:
DW #HG_y_0, #HG_y_1, #HG_y_2, #HG_y_3, #HG_y_4, #HG_y_5, #HG_y_6, #HG_y_7, #HG_y_8, #HG_y_9, #HG_y_A, #HG_y_B, #HG_y_C, #HG_y_D, #HG_y_E, #HG_y_F
PurpleHeatGlowJumpList:
DW #HG_p_0, #HG_p_1, #HG_p_2, #HG_p_3, #HG_p_4, #HG_p_5, #HG_p_6, #HG_p_7, #HG_p_8, #HG_p_9, #HG_p_A, #HG_p_B, #HG_p_C, #HG_p_D, #HG_p_E, #HG_p_F
OrangeHeatGlowJumpList:
DW #HG_o_0, #HG_o_1, #HG_o_2, #HG_o_3, #HG_o_4, #HG_o_5, #HG_o_6, #HG_o_7, #HG_o_8, #HG_o_9, #HG_o_A, #HG_o_B, #HG_o_C, #HG_o_D, #HG_o_E, #HG_o_F
GreenHeatGlowJumpList:
DW #HG_g_0, #HG_g_1, #HG_g_2, #HG_g_3, #HG_g_4, #HG_g_5, #HG_g_6, #HG_g_7, #HG_g_8, #HG_g_9, #HG_g_A, #HG_g_B, #HG_g_C, #HG_g_D, #HG_g_E, #HG_g_F

YellowHeatGlowStart:
DW $C5D4
  DW $E379
DW $C655
  DW $0180
HeatGlowYellowLoop:
HG_y_0:
DW $FFF1
  DB $10
DW $0010, $0000
DW $C595
HG_y_1:
DW $FFF1
  DB $11
DW $0004, $0000
DW $C595
HG_y_2:
DW $FFF1
  DB $11
DW $0004, $0000
DW $C595
HG_y_3:
DW $FFF1
  DB $12
DW $0005, $0000
DW $C595
HG_y_4:
DW $FFF1
  DB $12
DW $0006, $0000
DW $C595
HG_y_5:
DW $FFF1
  DB $13
DW $0007, $0000
DW $C595
HG_y_6:
DW $FFF1
  DB $13
DW $0008, $0000
DW $C595
HG_y_7:
DW $FFF1
  DB $14
DW $0008, $0000
DW $C595
HG_y_8:
DW $FFF1
  DB $14
DW $0008, $0000
DW $C595
HG_y_9:
DW $FFF1
  DB $13
DW $0008, $0000
DW $C595
HG_y_A:
DW $FFF1
  DB $13
DW $0007, $0000
DW $C595
HG_y_B:
DW $FFF1
  DB $12
DW $0006, $0000
DW $C595
HG_y_C:
DW $FFF1
  DB $12
DW $0005, $0000
DW $C595
HG_y_D:
DW $FFF1
  DB $11
DW $0004, $0000
DW $C595
HG_y_E:
DW $FFF1
  DB $11
DW $0004, $0000
DW $C595
HG_y_F:
DW $FFF1
  DB $10
DW $0010, $0000
DW $C595
DW $C61E
  DW HeatGlowYellowLoop

PurpleHeatGlowStart:
DW $C5D4
  DW $E379
DW $C655
  DW $0180
HeatGlowPurpleLoop:
HG_p_0:
DW $FFF1
  DB $1A
DW $0010, $0000
DW $C595
HG_p_1:
DW $FFF1
  DB $1B
DW $0004, $0000
DW $C595
HG_p_2:
DW $FFF1
  DB $1B
DW $0004, $0000
DW $C595
HG_p_3:
DW $FFF1
  DB $1C
DW $0005, $0000
DW $C595
HG_p_4:
DW $FFF1
  DB $1C
DW $0006, $0000
DW $C595
HG_p_5:
DW $FFF1
  DB $1D
DW $0007, $0000
DW $C595
HG_p_6:
DW $FFF1
  DB $1D
DW $0008, $0000
DW $C595
HG_p_7:
DW $FFF1
  DB $1E
DW $0008, $0000
DW $C595
HG_p_8:
DW $FFF1
  DB $1E
DW $0008, $0000
DW $C595
HG_p_9:
DW $FFF1
  DB $1D
DW $0008, $0000
DW $C595
HG_p_A:
DW $FFF1
  DB $1D
DW $0007, $0000
DW $C595
HG_p_B:
DW $FFF1
  DB $1C
DW $0006, $0000
DW $C595
HG_p_C:
DW $FFF1
  DB $1C
DW $0005, $0000
DW $C595
HG_p_D:
DW $FFF1
  DB $1B
DW $0004, $0000
DW $C595
HG_p_E:
DW $FFF1
  DB $1B
DW $0004, $0000
DW $C595
HG_p_F:
DW $FFF1
  DB $1A
DW $0010, $0000
DW $C595
DW $C61E
  DW HeatGlowPurpleLoop

OrangeHeatGlowStart:
DW $C5D4
  DW $E379
DW $C655
  DW $0180
HeatGlowOrangeLoop:
HG_o_0:
DW $FFF1
  DB $15
DW $0010, $0000
DW $C595
HG_o_1:
DW $FFF1
  DB $16
DW $0004, $0000
DW $C595
HG_o_2:
DW $FFF1
  DB $16
DW $0004, $0000
DW $C595
HG_o_3:
DW $FFF1
  DB $17
DW $0005, $0000
DW $C595
HG_o_4:
DW $FFF1
  DB $17
DW $0006, $0000
DW $C595
HG_o_5:
DW $FFF1
  DB $18
DW $0007, $0000
DW $C595
HG_o_6:
DW $FFF1
  DB $18
DW $0008, $0000
DW $C595
HG_o_7:
DW $FFF1
  DB $19
DW $0008, $0000
DW $C595
HG_o_8:
DW $FFF1
  DB $19
DW $0008, $0000
DW $C595
HG_o_9:
DW $FFF1
  DB $18
DW $0008, $0000
DW $C595
HG_o_A:
DW $FFF1
  DB $18
DW $0007, $0000
DW $C595
HG_o_B:
DW $FFF1
  DB $17
DW $0006, $0000
DW $C595
HG_o_C:
DW $FFF1
  DB $17
DW $0005, $0000
DW $C595
HG_o_D:
DW $FFF1
  DB $16
DW $0004, $0000
DW $C595
HG_o_E:
DW $FFF1
  DB $16
DW $0004, $0000
DW $C595
HG_o_F:
DW $FFF1
  DB $15
DW $0010, $0000
DW $C595
DW $C61E
  DW HeatGlowOrangeLoop

GreenHeatGlowStart:
DW $C5D4
  DW $E379
DW $C655
  DW $0180
HeatGlowGreenLoop:
HG_g_0:
DW $FFF1
  DB $1F
DW $0010, $0000
DW $C595
HG_g_1:
DW $FFF1
  DB $20
DW $0004, $0000
DW $C595
HG_g_2:
DW $FFF1
  DB $20
DW $0004, $0000
DW $C595
HG_g_3:
DW $FFF1
  DB $21
DW $0005, $0000
DW $C595
HG_g_4:
DW $FFF1
  DB $21
DW $0006, $0000
DW $C595
HG_g_5:
DW $FFF1
  DB $22
DW $0007, $0000
DW $C595
HG_g_6:
DW $FFF1
  DB $22
DW $0008, $0000
DW $C595
HG_g_7:
DW $FFF1
  DB $23
DW $0008, $0000
DW $C595
HG_g_8:
DW $FFF1
  DB $23
DW $0008, $0000
DW $C595
HG_g_9:
DW $FFF1
  DB $22
DW $0008, $0000
DW $C595
HG_g_A:
DW $FFF1
  DB $22
DW $0007, $0000
DW $C595
HG_g_B:
DW $FFF1
  DB $21
DW $0006, $0000
DW $C595
HG_g_C:
DW $FFF1
  DB $21
DW $0005, $0000
DW $C595
HG_g_D:
DW $FFF1
  DB $20
DW $0004, $0000
DW $C595
HG_g_E:
DW $FFF1
  DB $20
DW $0004, $0000
DW $C595
HG_g_F:
DW $FFF1
  DB $1F
DW $0010, $0000
DW $C595
DW $C61E
  DW HeatGlowGreenLoop

Padbyte $FF : Pad $8DEAE2
