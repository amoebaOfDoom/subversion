lorom

;org $90C5EB
;  LDA $0AAA ;1 if arm cannon selection has changed this frame, else 2
;  CMP #$0002
;  BMI EXIT
;  LDA $09D2 ;Currently selected status bar item
;  TAX
org $90C5F7
  LDA $F260,x ;0 if arm cannon should be closed, else 1 (lower byte)
;  AND #$00FF
;  STA $12
;  LDA $0AA6 ;Flag; Arm cannon is open / opening (else arm cannon is closed / closing)
;  AND #$00FF
;  CMP $12
;  BEQ EXIT ;current state is correct, we're done
;  LDA $12
;  BEQ CLOSE_CANNON
;  LDA #$0000
;  STA $0AA8 ;Frame number of Arm cannon graphic (0 = closed/none, 3 = fully open)
;  BRA BRANCH_4
;CLOSE_CANNON:
;  LDA #$0004
;  STA $0AA8 ;Frame number of Arm cannon graphic (0 = closed/none, 3 = fully open) 4 = ????
;BRANCH_4:
;  LDA $12
;  ORA #$0100 ; $0100 or $0101 -- set Flag; Arm cannon is transitioning between open and closed
;  STA $0AA6
;  SEC
;  RTS
;EXIT:
;  CLC
;  RTS
;org $90C7D9

org $90DD52
  LDX #$000C ;#$000A move xray visor overide to load the 6th index not the 5th

org $90DD5C
  JSR (SelectedItemHandler,x)

org $90F260
ArmCannonOpened:
  DB $00, $01, $01, $00, $01, $00, $00
SelectedItemHandler:
  DW $B80D, $BE62, $BE62, $B80D, $DD6F, #ThermalHandler, #XRayHandler
warnpc $90F28D

;visor concept by black falcon
;first off, I apologize for the poor support on this one, it's merely just a concept (like almost anything else I put up),
;because this is very old code and I just don't feel like polishing it, you may use it as you want without credit needed
;I still left the random comments and commented code in, I have no idea what does what exactly anymore, you can play with it yourself
;this replaces the xray routine called when selecting the xray icon and holding run

;things that need to be done:
;  - temperature display (adjust thermalpalette according to temp,) >> of course Vortoroc depths need to be HOT!
;  - Thermal Visor enemy reaction (visible or not visible)

; Make xray use shoot instead of run
org $888737 ;thin line
  BIT $09B2
org $888759 ;expand
  BIT $09B2
org $8887B0 ;open+directable
  BIT $09B2
org $91CAE3
  BIT $09B2

org $90BFA7
  LDA $09D2
  JMP BombsActivatedHandler ;CMP #$0003
BombsActivatedHandler_Next:
;  BNE $1B ; do normal bombs
;  JMP $C01C ; do power bombs

org $90F720

XRayHandler:
  LDA $8B
  BIT $09B2
  BNE CheckThermalOn
  BRA NoXRay
CheckThermalOn:
  LDA $09A2
  BIT #$0800
  BEQ DoXRay
NoXRay:
  JSR $B80D
  RTS
DoXRay:
  JSR $91CAD6 ;go do xray stuff
  RTS

ThermalHandler:
  PHA : PHX : PHY : PHB
  JSL CHECK
  PLB : PLY : PLX : PLA
  RTS

BombsActivatedHandler:
  CMP #$0005
  BNE BombsActivatedHandler_NotThermal
  JSR ThermalHandler
  PLP
  RTS
BombsActivatedHandler_NotThermal:
  CMP #$0003
  JMP BombsActivatedHandler_Next

org $97E900
CHECK:
  LDA $0998 : CMP #$0008 : BEQ NormalGameMode
              CMP #$0027 : BPL NormalGameMode
  RTL
NormalGameMode:

  LDA $8F : BIT $09B2 : BEQ NoToggle
  LDA #$FFFF
  STA $7EFB20
  LDA $09A2
  BIT #$0800
  BNE ToggleOff
  ORA #$0800
  STA $09A2
  LDA #$0038
  JSL $809035
  JSR THERMAL
  RTL
ToggleOff:
  AND #$F7FF
  STA $09A2
  LDA #$0037
  JSL $809035
  JSR NOTHING
  RTL

NoToggle:
  LDA $09A2
  BIT #$0800
  BNE DoThermal
  JSR NOTHING
  RTL
DoThermal:
  JSR THERMAL
  RTL

NOTHING:
  LDA $7FFD80
  CMP #$1111
  BEQ +
  LDA #$1111
  STA $7FFD80

  LDX #$C200 ;src offset
  LDY #$C000 ;dest offset
  LDA #$01FF ;size
  MVN $7E7E ;src + dest banks
  JSL $88EF20 ; reload dark room (DarkRoom.asm)
  JSL $91DEBA
+
  RTS

GoOut:
  JMP Exit

THERMAL:
  LDA $7FFD80
  CMP #$2222
  BEQ GoOut

  CMP #$2222
  BNE Mutate
  JMP Exit

Mutate:
  LDA #$2222
  STA $7FFD80

  LDX #$0000
Loop:
  CPX #$01A0
  BPL LoadFromPaletteBackup
  CPX #$0180
  BPL LoadFromSamusPaletteForSuit
  BRA LoadFromPaletteBackup

LoadFromPaletteBackup:
  LDA $7EC200,x
  BRA ProcessLoadedColor

LoadFromSamusPaletteForSuit:
  STX $18

  PHX
  LDX $7E0A74
  LDA $90F840,x ; suit palette array
  SEC
  SBC #$0180
  CLC
  ADC $18
  TAX
  LDA $9B0000,x
  PLX

ProcessLoadedColor:
  TAY
  JSR ProcessColor
  LDA $18
  STA $7EC000,x
  INX
  INX
  CPX #$0200
  BEQ Exit
  JMP Loop

Exit:
  RTS

ProcessColor:
    ;7E:C000 - 7E:C1FF    Color palletes, copied straight to CGRAM
    ;  7E:C000 - 7E:C01F    Area color palette line 0
    ;  7E:C020 - 7E:C03F    Area color palette line 1
    ;  7E:C040 - 7E:C05F    Area color palette line 2
    ;  7E:C060 - 7E:C07F    Area color palette line 3
    ;  7E:C080 - 7E:C0AF    Area color palette line 4
    ;  7E:C0A0 - 7E:C0BF    Area color palette line 5
    ;  7E:C0C0 - 7E:C0DF    Area color palette line 6
    ;  7E:C0E0 - 7E:C0FF    Area color palette line 7
    ;  7E:C100 - 7E:C11F    White palette for flashing enemies and pickups
    ;  7E:C120 - 7E:C13F    Enemy color palette line 0001
    ;  7E:C140 - 7E:C15F    Enemy color palette line 0002
    ;  7E:C160 - 7E:C17F    Enemy color palette line 0003
    ;  7E:C180 - 7E:C1AF    Samus' palette
    ;  7E:C1A0 - 7E:C1BF    Most common sprites (item drops, smoke, explosions, bombs, power bombs, missiles, gates(wall part), water splashes, grapple beam)
    ;  7E:C1C0 - 7E:C1DF    Beam Color palette line
    ;  7E:C1E0 - 7E:C1FF    Enemy color palette line 0007

  CPX #$0188
  BEQ HighlightBlue
  CPX #$0100
  BPL HighlightRed
  CPX #$008E
  BPL Grey
  CPX #$0088
  BPL FixMaridiaTricklingSand
  CPX #$0080
  BPL Grey
  CPX #$0010
  BMI MakeRed
  TXA
  AND #$001F
  CMP #$0008
  BMI LoadDoor
  CPX #$0010
  BMI MakeRed

  CPX #$0030
  BMI Grey
  CPX #$0038
  BPL Grey
  BRA MakeAverage

FixMaridiaTricklingSand:
  JSR IsInMaridia
  BCS HighlightRed
  BRA Grey

Grey:
  JSR MakeBW
  BRA Continue
HighlightRed:
  JSR MakeRed
  BRA Continue
HighlightBlue:
  JSR MakeBlue
  BRA Continue
LoadDoor:
  PHX
  TXA : AND #$0007
  TAX
  LDA DoorColors,X
  PLX
  STA $18
Continue:
  RTS

DoorColors:
  DW #%0000000000000000, #%0001000010011010, #%0001000010010111, #%0000000000010001

MakeRed:
  JSR MaxColor
  RTS

MakeRedAlt:
  JSR MaxColor
  RTS

MakeBlue:
  JSR MaxColor
  TYA
  XBA : LSR : LSR : LSR
  AND #%0000000000001111
  ORA $18
  STA $18
  RTS

MakeBW:
  JSR MaxColor
  ASL : ASL : ASL : ASL : ASL
  ORA $18
  ASL : ASL : ASL : ASL : ASL
  ORA $18
  STA $18
  RTS

MakeAverage:
  TYA
  PHB : PHK : PLB  
  AND #%0000000000011111 ;red
  STA $18
  TYA
  LSR : LSR : LSR : LSR : LSR
  AND #%0000000000011111 ;green
  CLC : ADC $18
  STA $18
  TYA
  XBA : LSR : LSR
  AND #%0000000000011111 ;blue
  CLC : ADC $18
  STA $4204
  SEP #$20 : LDA #$03 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ASL : ASL : ASL : ASL : ASL
  ORA $4214
  ASL : ASL : ASL : ASL : ASL
  ORA $4214
  STA $18
  PLB
  RTS


MaxColor:
  TYA
  AND #%0000000000011111 ;red
  STA $18
  TYA
  LSR : LSR : LSR : LSR : LSR
  AND #%0000000000011111 ;green
  CMP $18
  BMI +
  STA $18
+
  TYA
  XBA : LSR : LSR
  AND #%0000000000011111 ;blue
  CMP $18
  BMI +
  STA $18
+
  LDA $18
  RTS


DoorFade:
  BEQ DoorFadeSkip ;some colors are overidden to black during the fade that we don't want to mess with
  LDA $09A2
  BIT #$0800
  BEQ DoorFadeSkip
  JSR ProcessColor
  LDA $18
  TAY
DoorFadeSkip:
  LDA $C000,x
  TAX
  RTL

print "ReloadSamusPalette"
; update in Suits.asm and Flamestar666BeamSwitch.ASM
print pc
ReloadSamusPalette:
  PHX
  PHY
  TXY
  LDX #$0000
ReloadSamusPalette_Loop_1:
  LDA $0000,y : STA $7EC380,x
  INX
  INX
  INY
  INY
  CPX #$0020
  BMI ReloadSamusPalette_Loop_1
  PLY
  PLX
  LDA $7E09A2
  BIT #$0800
  BNE ReloadSamusWithThermal
  PHX
  PHY
  TXY
  LDX #$0000
ReloadSamusPalette_Loop_2:
  LDA $0000,y : STA $7EC180,x
  INX
  INX
  INY
  INY
  CPX #$0020
  BMI ReloadSamusPalette_Loop_2
  PLY
  PLX
  RTL
ReloadSamusWithThermal:
  LDA $0000,x : TAY : JSR MakeRed : LDA $18 : STA $7EC180
  LDA $0002,x : TAY : JSR MakeRed : LDA $18 : STA $7EC182
  LDA $0004,x : TAY : JSR MakeRed : LDA $18 : STA $7EC184
  LDA $0006,x : TAY : JSR MakeRed : LDA $18 : STA $7EC186
  LDA $0008,x : TAY : JSR MakeBlue : LDA $18 : STA $7EC188
  LDA $000A,x : TAY : JSR MakeRed : LDA $18 : STA $7EC18A
  LDA $000C,x : TAY : JSR MakeRed : LDA $18 : STA $7EC18C
  LDA $000E,x : TAY : JSR MakeRed : LDA $18 : STA $7EC18E
  LDA $0010,x : TAY : JSR MakeRed : LDA $18 : STA $7EC190
  LDA $0012,x : TAY : JSR MakeRed : LDA $18 : STA $7EC192
  LDA $0014,x : TAY : JSR MakeRed : LDA $18 : STA $7EC194
  LDA $0016,x : TAY : JSR MakeRed : LDA $18 : STA $7EC196
  LDA $0018,x : TAY : JSR MakeRed : LDA $18 : STA $7EC198
  LDA $001A,x : TAY : JSR MakeRed : LDA $18 : STA $7EC19A
  LDA $001C,x : TAY : JSR MakeRed : LDA $18 : STA $7EC19C
  LDA $001E,x : TAY : JSR MakeRed : LDA $18 : STA $7EC19E
  RTL

print "ReloadBeamPalette"
; update in Suits.asm and Flamestar666BeamSwitch.ASM
print pc
ReloadBeamPalette:
  LDY #$0000
  LDX #$01C0

  LDA $09A2
  BIT #$0800
  BNE ReloadBeamWithThermal
BeamPaletteLoop_1:
  LDA [$00],y
  STA $7EC000,x
  STA $7EC200,x
  INX
  INX
  INY
  INY
  CPY #$0020
  BMI BeamPaletteLoop_1
  RTL
ReloadBeamWithThermal:
BeamPaletteLoop_2:
  LDA [$00],y
  STA $7EC200,x
  PHY
  TAY
  JSR MakeRed
  PLY
  STA $7EC000,x
  INX
  INX
  INY
  INY
  CPY #$0020
  BMI BeamPaletteLoop_2
  RTL

AreaGlow:
  PHA
  LDA $09A2
  BIT #$0800
  BNE AreaGlowWithThermal
  PLA
  STA $7EC000,x
  STA $7EC200,x
  RTL
AreaGlowWithThermal:
  PLA
  STA $7EC200,x
  PHY
  TAY

  CPX #$0188
  BEQ AreaGlowVisor
  CPX #$01A0
  BPL AreaGlowNotSamus
  CPX #$0180
  BPL AreaGlowSamus
  CPX #$0078
  BPL AreaGlowNotSamus
  CPX #$0068
  BPL AreaGlowMaridiaWaterfall
  BRA AreaGlowNotSamus

IsInMaridia:
  PHX
  LDX $7E07BB
  LDA $8F0003,x
  PLX
  AND #$00FF
  CMP #$000B
  BEQ InMaridia
  CMP #$000C
  BEQ InMaridia
  CMP #$001C
  CLC
  RTS
InMaridia:
  SEC
  RTS

AreaGlowMaridiaWaterfall:
  ;LDA #$0004
  ;CMP $7E079F
  JSR IsInMaridia
  BCS AreaGlowNotSamus
  JSR MakeBW
  BRA AreaGlowContinue
AreaGlowVisor:
  JSR MakeBlue
  BRA AreaGlowContinue
AreaGlowSamus:
  JSR MakeRed
  BRA AreaGlowContinue
AreaGlowNotSamus:
  JSR MakeRedAlt

AreaGlowContinue:
  LDA $18
  STA $7EC000,x

  PLY
  RTL

SamusVisorRoomTransition:
  PHY
  TAY
  LDA $09A2
  BIT #$0800
  BNE SamusVisorRoomTransitionWithThermal
  TYA
  STA $7EC188
  STA $7EC388
  PLY
  RTL
SamusVisorRoomTransitionWithThermal:
  TYA
  STA $7EC388
  JSR MakeBlue
  LDA $18
  STA $7EC188
  PLY
  RTL

SamusVisorGlow:
  PHX
  PHA
  LDA $09A2
  BIT #$0800
  BNE SamusVisorGlowWithThermal
  PLA
  STA $7EC188
  STA $7EC388
  PLX
  RTL
SamusVisorGlowWithThermal:
  PLA
  STA $7EC388
  TAY
  JSR MakeBlue
  LDA $18
  STA $7EC188 
  PLX
  RTL

SamusChargeShotFlash:
  LDA #$03FF
  STA $7EC182,x
  LDA $09A2
  BIT #$0800
  BNE SamusChargeShotFlashWithThermal
  LDA #$03FF
  STA $7EC382,x
  RTL
SamusChargeShotFlashWithThermal:
  LDA #$001F
  STA $7EC182,x
  RTL

GrappleSprite:
  LDA #$7F91
  STA $7EC3BE
  LDA $09A2
  BIT #$0800
  BNE GrappleSpriteWithThermal
  LDA #$7F91
  STA $7EC3BE
  RTL
GrappleSpriteWithThermal:
  LDA #$001D
  STA $7EC1BE
  RTL

LoadGame:
  LDX #$0000
  LDA $09A2
  BIT #$0800
  BNE LoadGameLoopWithThermal
LoadGameLoop:
  LDA $7EC200,x
  STA $7EC000,x
  INX
  INX
  CPX #$0200
  BNE LoadGameLoop
  RTL
LoadGameLoopWithThermal:
  LDA $7EC200,x
  TAY
  JSR ProcessColor
  LDA $18
  STA $7EC000,x
  INX
  INX
  CPX #$0200
  BNE LoadGameLoopWithThermal
  RTL

TestEnemyVisability:
  LDA $09A2
  BIT #$0800
  BNE TestEnemyVisabilityWithThermal
  LDA $7E0F86,x ; Load enemy special properties
  BIT #$0180
  RTL
TestEnemyVisabilityWithThermal:
  LDA $7E0F86,x ; Load enemy special properties
  BIT #$0080 ; super invisible
  RTL

StoreSingleColor:
StoreToAreaPalette_0:
StoreTo_000:
  STA $7EC200,x
  PHY
  PHA
  LDA $09A2
  BIT #$0800
  BNE StoreSingleColorWithThermal_2
  PLA
  STA $7EC000,x
  PLY
  RTL
StoreSingleColorWithThermal_2:
  PLA
  TAY
  JSR ProcessColor
  LDA $18
  STA $7EC000,x
  PLY
  RTL

StoreToRawColor:
  PHX
  PHA
  TXA
  SEC
  SBC #$C000
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

;StoreToAreaPalette_1:
;  PHX
;  PHA
;  TXA
;  CLC
;  ADC #$0020
;  TAX
;  PLA
;  JSL StoreSingleColor
;  PLX
;  RTL

;StoreToAreaPalette_2:
;  PHX
;  PHA
;  TXA
;  CLC
;  ADC #$0040
;  TAX
;  PLA
;  JSL StoreSingleColor
;  PLX
;  RTL

;StoreToAreaPalette_3:
;  PHX
;  PHA
;  TXA
;  CLC
;  ADC #$0060
;  TAX
;  PLA
;  JSL StoreSingleColor
;  PLX
;  RTL

StoreToAreaPalette_4:
  PHX
  PHA
  TXA
  CLC
  ADC #$0080
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreToAreaPalette_5:
  PHX
  PHA
  TXA
  CLC
  ADC #$00A0
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

;StoreToAreaPalette_6:
;  PHX
;  PHA
;  TXA
;  CLC
;  ADC #$00C0
;  TAX
;  PLA
;  JSL StoreSingleColor
;  PLX
;  RTL

StoreToAreaPalette_7:
  PHX
  PHA
  TXA
  CLC
  ADC #$00E0
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreToEnemyPalette_1:
  PHX
  PHA
  TXA
  CLC
  ADC #$0120
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreToEnemyPalette_2:
  PHX
  PHA
  TXA
  CLC
  ADC #$0140
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreToEnemyPalette_3:
  PHX
  PHA
  TXA
  CLC
  ADC #$0160
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreToEnemyPalette_7:
  PHX
  PHA
  TXA
  CLC
  ADC #$01E0
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

RidleyEye:
  LDA $09A2
  BIT #$0800
  BNE RidleyEye_WithThermal
  LDA $E2AA,y
  STA $7EC1F8
  STA $7EC3F8
  LDA $E2AC,y
  STA $7EC1FA
  STA $7EC3FA
  LDA $E2AE,y
  STA $7EC1FC
  STA $7EC3FC
  RTL
RidleyEye_WithThermal:
  LDA $E2AA,y
  STA $7EC3F8
  PHY
  TAY
  JSR MakeRed
  PLY
  STA $7EC1F8
  LDA $E2AC,y
  STA $7EC3FA
  PHY
  TAY
  JSR MakeRed
  PLY
  STA $7EC1FA
  LDA $E2AE,y
  STA $7EC3FC
  PHY
  TAY
  JSR MakeRed
  PLY
  STA $7EC1FC
  RTL

StoreTo_002:
  PHX
  PHA
  TXA
  CLC
  ADC #$0002
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreTo_004:
  PHX
  PHA
  TXA
  CLC
  ADC #$0004
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreTo_112:
  PHX
  PHA
  TXA
  CLC
  ADC #$0112
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreTo_114:
  PHX
  PHA
  TXA
  CLC
  ADC #$0114
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreTo_116:
  PHX
  PHA
  TXA
  CLC
  ADC #$0116
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

StoreTo_118:
  PHX
  PHA
  TXA
  CLC
  ADC #$0118
  TAX
  PLA
  JSL StoreSingleColor
  PLX
  RTL

TurnOffThermalOnDeath:
  JSL $9BB3A7
  LDA $09A2
  AND #$F7FF
  STA $09A2

  LDA $7FFE7E ; death count
  INC
  BEQ +
  STA $7FFE7E ; death count
  JSL $81EF24 ; save extra log file data (saveload.asm)
+
  RTL

LoadSecondaryPalette:
  LDA $07C7   ;\
  STA $48     ;|
  LDY $07C6   ;|
  STY $47     ;} Decompress [tileset palette pointer] to $7E:C200
  JSL $80B0FF ;|
  DL $7EC200  ;/
  RTL

LoadTorizoPaletteLoop_6:
  LDA $7E8000,X
  LDX #$001E
  BIT #$0004
  BNE LoadTorizoPaletteLoop_6_4
LoadTorizoPaletteLoop_6_0:
  LDA $8727,X
  JSL StoreToEnemyPalette_2
  LDA $8707,X
  JSL StoreToEnemyPalette_1
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_6_0
  RTL
LoadTorizoPaletteLoop_6_4:
  LDA $8707,X
  JSL StoreToEnemyPalette_3
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_6_4
  RTL

LoadTorizoPaletteLoop_7:
  PHA
  PHX
  LDX $0E54
  LDA $7E8000,X
  PLX
  BIT #$0004
  BNE +
  PLA
  JSL StoreToEnemyPalette_2
  JSL StoreToEnemyPalette_1
  RTL
+
  PLA
  JSL StoreToEnemyPalette_3
  RTL

TorizoBlend:
  PHX
  PHY
  PHB
  PEA $7E7E
  PLB
  PLB
  LDA $C402
  PHA
  LDX $0E54
  LDA #$000C
  STA $8402,X
  STA $C402
  LDY #$0600 ; enemy pelettes 1, 2
  LDA $8000,X
  BIT #$0004
  BEQ +
  LDY #$0800 ; enemy palette 3
+
  TYA
  JSR UpdateTorizoBlend
  PLA
  STA $C402

  PLB
  PLY
  PLX
  RTL

UpdateTorizoBlend:
  PHA
  LDA $8402,X
  INC
  CMP $8400,X
  BCS TorizoBlend_NotDone
  LDA #$0000
  STA $8400,X
  PLA
  SEC
  RTS
TorizoBlend_NotDone:
  STZ $8404,X
TorizoBlend_Loop:
  PLA
  BEQ TorizoBlend_Loop_Exit
  LSR
  PHA
  BCS +
  LDA $8404,X
  ADC #$0020
  STA $8404,X
  BRA TorizoBlend_Loop
+
  JSL WriteSingleColorBlend
  BRA TorizoBlend_Loop
TorizoBlend_Loop_Exit:
  INC $8400,X
  CLC
  RTS


org $82E780
  JMP LoadTilesetInjection
org $82E78C
LoadTileset:
org $82E7BF
  PLB : PLP : RTL
LoadTilesetInjection:
  JSL LoadSecondaryPalette
  BRA LoadTileset

org $82DD7E
  JSL TurnOffThermalOnDeath ;JSL $9BB3A7

org $8B9A44
  JMP InitThermalOff
  ; PLB : PLP : RTL

org $8BF8C0
InitThermalOff:
  STZ $09A2
  PLB : PLP : RTL

; --------------------------------------------------------------
; Injection sites where palettes are modified

org $82810F
;LoadGameLoop:
  JSL LoadGame
  NOP : NOP : NOP ;LDY #$0200
  NOP : NOP : NOP ;LDX #$0000
  ;NOP : NOP : NOP : NOP ;LDA $7EC200,x
  NOP : NOP : NOP : NOP ;STA $7EC000,x
  NOP ;INX
  NOP ;INX
  NOP ;DEY
  NOP ;DEY
  NOP : NOP ;BNE LoadGameLoop

org $828184
;LoadDemoLoop:
  JSL LoadGame
  NOP : NOP : NOP ;LDY #$0200
  NOP : NOP : NOP ;LDX #$0000
  ;NOP : NOP : NOP : NOP ;LDA $7EC200,x
  NOP : NOP : NOP : NOP ;STA $7EC000,x
  NOP ;INX
  NOP ;INX
  NOP ;DEY
  NOP ;DEY
  NOP : NOP ;BNE LoadGameLoop


org $82DA2C ;careful with this, there is a branch into this code
  TAY
  JSL DoorFade
  ;LDA $C000,x
  ;TAX
  LDA $C400
  JSR $DA4A
  LDX $C404
  STA $C000,x
  INX
  INX

org $82E151
  NOP : NOP : NOP : NOP

org $82E52E
  JSL SamusVisorRoomTransition
  ;STA $7EC188

org $8DC57E
  ;STA $7EC000,x
  JSL AreaGlow

org $90ACC2
  PHP
  PHB
  PHK
  PLB
  REP #$30
  AND #$0FFF
  ASL A
  TAY
  LDA #$0090 ;JMP targets this line
  XBA
  STA $01
  LDA $C3C9,y
  STA $00
  JSL ReloadBeamPalette
  PLB
  PLP
  RTL

org $90ACFC
  AND #$0FFF
  ASL A
  TAY
  LDA #$0090
  XBA
  STA $01
  LDA $C3C9,y
  STA $00
  JSL ReloadBeamPalette
  RTS

org $91D7A1
  NOP : NOP : NOP
  JSL SamusChargeShotFlash

org $91D873
  JSL SamusVisorGlow
  ;STA $7EC188

org $91DD64
  PHY
  PHX
  JSL ReloadSamusPalette
  PLX
  PLY
  ;LDA $0000,x
  ;STA $7EC180
  ;LDA $0002,x
  ;STA $7EC182
  ;LDA $0004,x
  ;STA $7EC184
  ;LDA $0006,x
  ;STA $7EC186
  ;LDA $0008,x
  ;STA $7EC188
  ;LDA $000A,x
  ;STA $7EC18A
  ;LDA $000C,x
  ;STA $7EC18C
  ;LDA $000E,x
  ;STA $7EC18E
  ;LDA $0010,x
  ;STA $7EC190
  ;LDA $0012,x
  ;STA $7EC192
  ;LDA $0014,x
  ;STA $7EC194
  ;LDA $0016,x
  ;STA $7EC196
  ;LDA $0018,x
  ;STA $7EC198
  ;LDA $001A,x
  ;STA $7EC19A
  ;LDA $001C,x
  ;STA $7EC19C
  ;LDA $001E,x
  ;STA $7EC19E
  PLB
  PLP
  RTS

org $9BC686 
  ;LDA #$7F91
  ;STA $7EC1BE
  NOP : NOP : NOP
  JSL GrappleSprite

org $A09105
  ;LDA $0F86,x[$A0:0F86]
  ;BIT #$0300
  JSL TestEnemyVisability
  NOP : NOP


org $82F780
WriteSingleColorBlend:
  LDY $8404,X
  LDA $8200,Y
  CMP $C200,Y
  BEQ WriteBlend_Continue

;  PHA ;TAY
;  LDA $C200,Y
;  PHA ;TAX
;  LDA $8400,X
;  PLX
;  PLY
;  JSR $DA4A

  PEA.w ComputeColorReturn-1
  LDA $8400,X
  PHA
  PHA
  LDA $C200,Y
  PHA
  LDA $8200,Y
  PHA
  JMP $DA4E
ComputeColorReturn:
  LDX $0E54
  LDY $8404,X
  TYX
  JSL StoreSingleColor
  LDX $0E54
WriteBlend_Continue:
  LDA $8404,X
  INC
  INC
  STA $8404,X
  BIT #$001F
  BNE WriteSingleColorBlend
  RTL

; --------------------------------------------------------------
; Simple hooks for palette edits

; torizo
org $84801D
  JSL StoreToEnemyPalette_2 ;STA $7EC140,x
org $848024
  JSL StoreToEnemyPalette_1 ;STA $7EC120,x

org $8682E9
  JSL StoreSingleColor ;STA $7EC000,x
org $86B8A7
  JSL StoreSingleColor ;STA $7EC000,x

org $878362
  JSL StoreSingleColor ;STA $7EC000,x
  JSL StoreTo_002 ;STA $7EC002,x
  JSL StoreTo_004 ;STA $7EC004,x

org $A3DB34
  JSL StoreTo_112 ;STA $7EC112,x

org $A49873
  JSL StoreToEnemyPalette_3 ;STA $7EC160,x
org $A499A1
  JSL StoreToEnemyPalette_1 ;STA $7EC120,x
org $A48CE3
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x
org $A48CF2
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x

org $A5956A ;Draygon
  JSL StoreToRawColor ;STA $7E0000,x
org $A59589 ;Draygon
  LDX #$0012
  LDA $96AF,Y
  JSL StoreToAreaPalette_5 ;STA $7EC0B2,x
  INY
  INY
  INX
  INX
  CPX #$001A
org $A595B9 ;Draygon
  JSL StoreToRawColor ;STA $7E0000,x
org $A59722 ;Draygon
  LDX #$0012
  LDA $96AF,Y
  JSL StoreToAreaPalette_5 ;STA $7EC0B2,x
  INY
  INY
  INX
  INX
  CPX #$001A

org $A5E8D8 ;Spore Spawn
  JSL StoreToEnemyPalette_1 ;STA $7EC120,x
org $A5E8F1 ;Spore Spawn
  JSL StoreToAreaPalette_4 ;STA $7EC080,x
org $A5E90A ;Spore Spawn
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x

org $A5EE55
  JSL StoreToEnemyPalette_1 ;STA $7EC120,x

org $A6A3B5
  JSL RidleyEye
  RTS
  ;LDX #$01F8
  ;LDA $E2AA,y
  ;STA $7EC000,x
  ;LDA $E2AC,y
  ;STA $7EC002,x
  ;LDA $E2AE,y
  ;STA $7EC004,x
  ;RTS

org $A6A403 ;Ridley
  JSL StoreSingleColor ;STA $7EC000,x
org $A6A409 ;Ridley
  JSL StoreSingleColor ;STA $7EC000,x

org $A6C197
  JSL StoreSingleColor ;STA $7EC000,x

org $A6C1CC
  JSL StoreSingleColor ;STA $7EC000,x
org $A6C1D3
  JSL StoreTo_002 ;STA $7EC002,x
org $A6C1DA
  JSL StoreTo_004 ;STA $7EC004,x

org $A7B386 ;Kraid
  JSL StoreToEnemyPalette_7 ;STA $7EC1E0,x
org $A7B3BE ;Kraid
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x
org $A7B3C5 ;Kraid
  JSL StoreToEnemyPalette_7 ;STA $7EC1E0,x
org $A7B724 ;Kraid
  JSL StoreSingleColor ;STA $7EC000,x
org $A7B771 ;Kraid
  LDA $7EC200,X
  DEC A
  JSL StoreSingleColor
org $A7B78F ;Kraid
  LDA $7EC200,X
  SEC
  SBC #$0020
  JSL StoreSingleColor
org $A7C37E ;Kraid
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x

org $A7DBC1 ;Phantoon
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x
org $A7DBFB ;Phantoon
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x
org $A7DC81 ;Phantoon
  NOP : NOP : NOP : NOP ;JSL StoreSingleColor ;STA $7EC000,x
org $A7DD61 ;Phantoon
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x
org $A7DD82 ;Phantoon
  JSL StoreToAreaPalette_7 ;STA $7EC0E0,x

org $A7F535
  PHP
  REP #$30
  PHX
  LDA $0F96,X
  LSR : LSR : LSR : LSR
  CLC
  ADC #$0100
  TAX
  LDA #$0020
  STA $00
-
  LDA $0000,Y
  JSL StoreSingleColor
  INX
  INX
  INY
  INY
  DEC $00
  DEC $00
  BPL -

  PLX
  PLP
  RTS


; ghost

!enemy_target_palette = $7E8800

org $A89B31
    STA !enemy_target_palette,X ; $7EC200,x

org $A89B5E
    LDA $7EC200,X ; $7EC000,x
    AND #$001F
    CMP #$001F
    BPL $0D
    LDA $7EC200,X ; $7EC000,x
    CLC
    ADC #$0421
    JSL StoreSingleColor ; STA $7EC000,x
    DEY

org $A89B9E
    STA !enemy_target_palette,X ; $7EC200,x

org $A89D08
    STA !enemy_target_palette,X ; $7EC200,x

;;; $9E88_InterpolateColor:  ;;;
org $A89EAE
    LDA !enemy_target_palette,X ; $7EC200,x
    CMP $7EC200,X ; $7EC000,x
org $A89EC0
    LDA $7EC200,X ; $7EC000,x
org $A89ED3
    LDA $7EC200,X ; $7EC000,x
org $A89EDC
    JSL StoreSingleColor ; STA $7EC000,x

org $A89EE1
    LDA !enemy_target_palette,X ; $7EC200,x
org $A89EEA
    LDA $7EC200,X ; $7EC000,x
org $A89F03
    LDA $7EC200,X ; $7EC000,x
org $A89F0C
    JSL StoreSingleColor ; STA $7EC000,x

org $A89F11
    LDA !enemy_target_palette,X ; $7EC200,x
org $A89F1A
    LDA $7EC200,X ; $7EC000,x
org $A89F33
    LDA $7EC200,X ; $7EC000,x
org $A89F3C
    JSL StoreSingleColor ; STA $7EC000,x


org $A8B0D9
  LDA $1794
  CLC
  ADC #$0012
  TAX

  LDA $AC2E,y
  JSL StoreSingleColor
  LDA $AC30,y
  INX : INX
  JSL StoreSingleColor
  LDA $AC32,y
  INX : INX
  JSL StoreSingleColor
  LDA $AC34,y
  INX : INX
  JSL StoreSingleColor
  RTL
warnpc $A8CCBB

org $A8CC1F ;ws robot
  JSL StoreTo_112 ;STA $7EC112,x
  JSL StoreTo_114 ;STA $7EC114,x
  JSL StoreTo_116 ;STA $7EC116,x
  JSL StoreTo_118 ;STA $7EC118,x
org $A8CC91
  JSL StoreTo_112 ;STA $7EC112,x
org $A8CC98
  JSL StoreTo_114 ;STA $7EC114,x
org $A8CC9F
  JSL StoreTo_116 ;STA $7EC116,x
org $A8CCA6
  JSL StoreTo_118 ;STA $7EC118,x

org $A8E896 ;blue face
  JSL StoreTo_112 ;STA $7EC112,x

org $A9AF77 ;MB
  LDX #$001E ;LDX #$001C
  LDA $7EC320,X ;LDA $7EC122,x
  JSL StoreToEnemyPalette_7 ;STA $7EC1E2,x
org $A9CFE5 ;MB
  LDX #$001E ;LDX #$001C
  LDA $7EC300,X ;LDA $7EC102,x
  JSL StoreToEnemyPalette_1 ;STA $7EC122,x
  JSL StoreToEnemyPalette_3 ;STA $7EC162,x
  JSL StoreToAreaPalette_4 ;STA $7EC082,x
org $A9D2E9 ;Copy 2*A bytes from Y to 7E:C000,X
  JSL StoreSingleColor ;STA $7EC000,x

org $AAB274 ;torizo
  JSL TorizoBlend
org $AAC6B2 ;torizo
  JSL TorizoBlend
org $AAC2B0 ;torizo
LoadTorizoPalette_6:
  PHX
  LDX $0E54
  JSL LoadTorizoPaletteLoop_6 ; restore after flash colors
  PLX
  RTS
;org $AAC2B7 ;torizo
;  JSL StoreToEnemyPalette_2 ;STA $7EC140,x
;org $AAC2BE ;torizo
;  JSL StoreToEnemyPalette_1 ;STA $7EC120,x
org $AAC696 ;torizo
  JSL LoadTorizoPaletteLoop_7 ; flash colors
  NOP : NOP : NOP : NOP
;  JSL StoreToEnemyPalette_2 ;STA $7EC140,x
;  JSL StoreToEnemyPalette_1 ;STA $7EC120,x
org $AAD3D2
  JSL StoreToEnemyPalette_2 ;STA $7EC140,x
  JSL StoreToEnemyPalette_1 ;STA $7EC120,x

org $B39857 ;Botwoon
  JSL StoreSingleColor ;STA $7EC000,x

; --------------------------------------------------------------
; Item definition, referenced by the files in the PLMs directory.
org $89B340 ; graphics
PLM_Graphics:
  incbin ROMProject/Graphics/visor.gfx

org $84FDB0
  ; item header: EE64 for a pickup
  DW $EE64,item_data

item_data:
  DW $8764,PLM_Graphics
    DB 1,1,1,1,1,1,1,1
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
  DW ThermalVisorCollect,$0000 ; item type + value (the latter unused)
    DB $23       ; msgbox identifier, I think $1D may be the first free msgbox?
  DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
  DW $86BC       ; done: delete PLM

; PLM arguments:
; Value (2 bytes), unused since the math is too hard for me yet
; Message box (1 byte)

org $84FF20

ThermalVisorCollect:
  LDA #$0168  ; frame delay for music/messagebox
  JSL $82E118 ; do music

  LDA $0002,Y ; grab message box arg
  AND #$00FF  ; convert to byte
  JSL $858080 ; display message box

  LDA $09A4 ; collected items
  ORA #$0800 ; thermal visor
  STA $09A4

  LDA $09A2 ; load equipped items
  ORA #$0800 ; thermal visor
  STA $09A2

  PHX
  PHY
  JSL DoThermal
  PLY
  PLX

  ; DrawThermalHUDIcon from hud.asm
  JSL $80CD90 ; Draw Thermal HUD Icon

  INY         ; advance past our args, to next instruction
  INY
  INY
  RTS         ; return to PLM loop
