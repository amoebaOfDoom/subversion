lorom

padbyte $FF

!bitchecksuit3 = #$0010
!bitcheckgravityboots = #$0400
!bitcheckunknown = #$0040
!bitcheckbeam = $FA48
!bitchecksuitmisc = $FA52
!bitcheckboot = $FA62

;;;; Remap the tiles in the graphics sheet
; Spritemap 14h
org $82C29F 
	DW $0001, $01FC : DB $FC : DW $3630
; Spritemap 16h
org $82C2F5 
	DW $0014
	DW $001C : DB $04 : DW $3422 
	DW $001C : DB $FC : DW $3422 
	DW $0004 : DB $04 : DW $3422 
	DW $0014 : DB $04 : DW $3422 
	DW $000C : DB $04 : DW $3422 
	DW $0014 : DB $FC : DW $3422 
	DW $000C : DB $FC : DW $3422 
	DW $0004 : DB $FC : DW $3422 
	DW $01FC : DB $04 : DW $3422 
	DW $01FC : DB $FC : DW $3422 
	DW $01DC : DB $04 : DW $3422 
	DW $01E4 : DB $04 : DW $3422 
	DW $01EC : DB $04 : DW $3422 
	DW $01F4 : DB $04 : DW $3422 
	DW $0024 : DB $04 : DW $3424
	DW $0024 : DB $FC : DW $3423
	DW $01F4 : DB $FC : DW $3422 
	DW $01EC : DB $FC : DW $3422 
	DW $01E4 : DB $FC : DW $3422 
	DW $01DC : DB $FC : DW $3421
; Spritemap 2Ah
org $82C465 
	DW $0008
	DW $0008 : DB $00 : DW $743A 
	DW $0000 : DB $00 : DW $343B 
	DW $01F8 : DB $00 : DW $343B 
	DW $01F0 : DB $00 : DW $343A 
	DW $0000 : DB $F8 : DW $743D 
	DW $0008 : DB $F8 : DW $743C 
	DW $01F8 : DB $F8 : DW $343D 
	DW $01F0 : DB $F8 : DW $343C

; Spritemap 1Bh
org $82C35B 
	DW $0001, $0000 : DB $00 : DW $3438
; Spritemap 1Ch
org $82C362 
	DW $0001, $0000 : DB $00 : DW $3437
; Spritemap 1Ah + 1F
org $82C369 
	DW $0001, $0000 : DB $00 : DW $3439
; Spritemap 1Dh
org $82C370 
	DW $0001, $0000 : DB $00 : DW $3438
; Spritemap 1Eh
org $82C377 
	DW $0001, $0000 : DB $00 : DW $3037

; Spritemap 20h
org $82C3D9 
	DW $0001, $0000 : DB $00 : DW $3437
; Spritemap 21h
org $82C3E0 
	DW $0001, $0000 : DB $00 : DW $3431
; Spritemap 22h
org $82C3E7 
	DW $0001, $0000 : DB $00 : DW $3432
; Spritemap 23h
org $82C3EE 
	DW $0001, $0000 : DB $00 : DW $3433
; Spritemap 24h
org $82C3F5 
	DW $0001, $0000 : DB $00 : DW $3434
; Spritemap 25h
org $82C3FC 
	DW $0001, $0000 : DB $00 : DW $3435
; Spritemap 26h
org $82C403 
	DW $0001, $0000 : DB $00 : DW $3436
; Spritemap 27h
org $82C40A 
	DW $0001, $0000 : DB $00 : DW $3438
; Spritemap 2Bh: start button pressed highlight
org $82C4B1
	DW $0008
		DW $0008 : DB $00 : DW $341F
		DW $0000 : DB $00 : DW $341E
		DW $01F8 : DB $00 : DW $341D
		DW $01F0 : DB $00 : DW $341C
		DW $0000 : DB $F8 : DW $340E
		DW $01F8 : DB $F8 : DW $340D
		DW $0008 : DB $F8 : DW $740C
		DW $01F0 : DB $F8 : DW $340C


; Tilemaps
org $82BF06
; MODE[MANUAL]
   DW $2519, $251A, $251B, $3D46, $3D47, $3D48, $3D49 
; RESERVE TANK
   DW $3EC8, $3EC9, $3ECA, $3ECB, $3ECC, $3ECD, $3ECE
; [MANUAL]
   DW $3D46, $3D47, $3D48, $3D49 
; [ AUTO ]
   DW $3D56, $3D57, $3D58, $3D59
; oCHARGE
   DW $0AFF, $0AD8, $0AD9, $0ADA, $0AE7 
; oICE
   DW $0AFF, $0ADB, $0ADC, $0AD4, $0AD4 
; oWAVE
   DW $0AFF, $0ADD, $0ADE, $0ADF, $0AD4 
; oSPAZER
   DW $0AFF, $0AE8, $0AE9, $0AEA, $0AEB 
; oPLASMA
   DW $0AFF, $0AEC, $0AED, $0AEE, $0AEF
; oVARIA SUIT
   DW $0AFF, $0900, $0901, $0902, $0903, $0904, $0905, $0AD4, $0AD4 
; oGRAVITY SUIT
   DW $0AFF, $0AD0, $0AD1, $0AD2, $0AD3, $0903, $0904, $0905, $0AD4 
; oMORPHING BALL
   DW $0AFF, $0920, $0921, $0922, $0923, $0917, $0918, $090F, $091F 
; oBOMBS
   DW $0AFF, $0AD5, $0AD6, $0AD7, $0AD4, $0AD4, $0AD4, $0AD4, $0AD4 
; oSPRING BALL
   DW $0AFF, $0910, $0911, $0912, $0913, $0914, $0915, $0916, $0AD4
; Unused
   DW $0000
; oSCREW ATTACK
   DW $0AFF, $0AE0, $0AE1, $0AE2, $0AE3, $0AE4, $0AE5, $0AE6, $0AD4 
; oHI-JUMP BOOTS
   DW $0AFF, $0930, $0931, $0932, $0933, $0934, $0935, $0936, $0AD4 
; oSPACE JUMP
   DW $0AFF, $0AF0, $0AF1, $0AF2, $0AF3, $0AF4, $0AF5, $0AD4, $0AD4 
; oSPEED BOOSTER
   DW $0AFF, $0924, $0925, $0926, $0927, $0928, $0929, $092A, $092B 
; oHYPER
   DW $0AFF, $0937, $0938, $0939, $092F, $0AD4, $0AD4, $0AD4, $0AD4
; Blank placeholder
   DW $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F

org $82C02C
	REP 8 : DB $FF
org $82C034
	REP 8 : DB $FF
org $82C044
	REP 8 : DB $FF
org $82C04C
	REP 28 : DB $FF
org $82C068
	REP 32 : DB $FF
org $82C08C
	REP 38 : DB $FF

org $82C1E8
	DW #SelectorSpriteIndexes
org $82C593
	DW #BeamSelectorSprite
org $82C639
	DW #LogCategorySelectorSprite ; Sprite #68
	DW #LogEntrySelectorSprite    ; Sprite #69
	DW #MapItemCircle             ; Sprite #6A
	DW #MapItemDot                ; Sprite #6B
	DW #SmallBoxSprite            ; Sprite #6C
skip $20
SelectorSpriteIndexes:
	DW $0014, $0015, $0016, $0016, $0068, $0069 ; Item selector

pad $82C748 : warnpc $82C749

PRINT PC

org $94DC40
;rooms.SelectMany(
;room => statelist.SelectMany(
;state.plmlist.Where(isItem(@0)).Select(
;String.Format("[Area {0}] DW ${1:X4} : DB ${2:X2}, ${3:X2}",
;  room.area,
;  arg & 0xFF,
;  room.X + (X / 16), 
;  room.Y + (Y / 16) + 1
;)))).OrderBy(s => s).Distinct()
;.GroupBy(s => s.Substring(0, 8)).Select(g => String.Format("{0}: {1:X2}", g.Key, g.Count()))

TotalItemCount: ; referenced by credit.asm
  DW $007A
AreaItemCounts:
  ;  Crati  Brin*  Norfr  WShip  Marid  Touri  Ceres  Debug
  DW $0014, $001C, $0017, $0014, $000E, $0008, $0009, $0000
AreaItemCounts_alt:
  ;  Crati  Brin*  Norfr  WShip  Marid  Touri  Ceres  Debug
  DW $0015, $001C, $0017, $0018, $0010, $0008, $0000, $0002

Calc:
  STA $4204
  SEP #$20 : LDA #$64 : STA $4206   ; divide by 100
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4216 : STA $4204             ; take the remainder
  SEP #$20 : LDA #$0A : STA $4206   ; divide by 100
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214 : ASL A : STA $14       ; keep the result (10s digit)
  LDA $4216 : ASL A : STA $12       ; keep the remainder (1s digit)
  RTS

Mult10:
  ASL
  STA $12
  ASL
  ASL
  CLC
  ADC $12
  RTS

DrawPercent:
  LDA $12
  CMP $14
  BEQ Draw100Percent

  JSR Mult10
  STA $4204

  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ;BEQ SkipTotal10
  ASL A : TAY : LDA Numbers,y : STA $7E0008,x
SkipTotal10:

  LDA $4216
  JSR Mult10
  STA $4204
  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ASL A : TAY : LDA Numbers,y : STA $7E000A,x

  LDA #$3C0D : STA $7E000C,x

  LDA $4216
  JSR Mult10
  STA $4204
  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ASL A : TAY : LDA Numbers,y : STA $7E000E,x
  LDA #$3C0A : STA $7E0010,x

  RTS
Draw100Percent:
  LDA #$3401 : STA $7E000A,x
  LDA #$3400 : STA $7E000C,x
  LDA #$3400 : STA $7E000E,x
  LDA #$340A : STA $7E0010,x
  RTS

!r = $7E3A06
!t = $7E3AC6
!p = $7E3A86

DrawTimeAndPercent:
  PHY

  ;LDA #$2D4D : STA !r
  ;LDA #$2D4E : STA !r+2
  ;LDA #$2D4F : STA !r+4

  LDA $09E0 : JSR Calc
  LDX $14 : LDA Numbers,x : STA !r+0
  LDX $12 : LDA Numbers,x : STA !r+2
  LDA #$3C0C : STA !r+4

  LDA $09DE : JSR Calc
  LDX $14 : LDA Numbers,x : STA !r+6
  LDX $12 : LDA Numbers,x : STA !r+8
  LDA #$3C0C : STA !r+10

  LDA $09DC : JSR Calc
  LDX $14 : LDA Numbers,x : STA !r+12
  LDX $12 : LDA Numbers,x : STA !r+14
  ;LDA #$2CBB : STA !r+18

  ;LDA $09DA
  ;JSR Mult10 ; Multiply frame counter by 10 / 6
  ;STA $4204
  ;SEP #$20 : LDA #$06 : STA $4206
  ;PHA : PLA : PHA : PLA : REP #$20
  ;LDA $4214
  ;JSR Calc
  ;LDX $14 : LDA Numbers,x : STA !r+26
  ;LDX $12 : LDA Numbers,x : STA !r+28

  LDA #$2D2C : STA !t
  LDA #$2D2D : STA !t+2
  LDA #$2D2E : STA !t+4

  LDX #$0000
  STZ $12
SumAreaCountLoop:
  LDA $7ED868,x
  AND #$00FF
  CLC
  ADC $12
  AND #$00FF ; max 8 bit to handle negatives
  STA $12
  INX
  CPX #$0008
  BMI SumAreaCountLoop

  LDA TotalItemCount
  STA $14
  LDX #$3AC4
  JSR DrawPercent

  LDA #$2D1C : STA !p
  LDA #$2D1D : STA !p+2
  LDA #$2D1E : STA !p+4

  LDX $7E079F ; Region Number
  LDA $7ED868,x : AND #$00FF : STA $12
  TXA : ASL : TAX

  LDX $7E079F ; Region Number
  LDA #$001D
  JSL $808233 ; test event bit
  BCS .postcrash 
.precrash
  LDA $7ED868,x : AND #$00FF : STA $12
  TXA : ASL : TAX
  LDA.l AreaItemCounts,x
  BRA +
.postcrash
  LDA $7ED868,X : CLC : ADC $7ED860,X : AND #$00FF : STA $12
  TXA : ASL : TAX
  LDA.l AreaItemCounts_alt,x
+

  STA $14
  LDX #$3A84
  JSR DrawPercent

  PLY
  RTL
Print PC

org $84F0E0
RecordItemPickup:
  LDA #$FFFF
  STA $7EFB20

  PHP
  SEP #$20
  LDX $7E079F ; Region Number
  LDA $7ED868,x
  INC
  STA $7ED868,x
  PLP
  RTS


org $8488AA
  ;STA $7ED870,x
  JSR RecordItemPickup
  NOP


org $828F6B : 
	NOP : NOP : NOP ; JSR $8F70
org $829186
	;NOP : NOP : NOP : JSR EquipmentDraw
org $829231
	;NOP : NOP : NOP : JSR EquipmentDraw
org $82935E
	NOP : NOP : NOP : JSR EquipmentDraw
org $82B639
	;NOP : NOP : NOP : JSR EquipmentDraw
org $82B65B
	NOP : NOP : NOP : JSR EquipmentDraw

org $8291B1
	;JSR EquipmentScreenInit ;JSR SetInitialCursorPosition
org $829013
	JSR EquipmentScreenInit
org $829146
	;JSR EquipmentMain

org $828F70
; ----------------------------------------
;     Equipment Data Pointer Tables
; ----------------------------------------

;C02C - C033 : Pointers to start of RAM offsets for specific tilemaps: (this,list_index),item_index = RAM offset
TileMapRAMArr:
	DW #TileMapRAMBeam, #TileMapRAMBoot, #TileMapRAMSuitMisc, #TileMapRAM3SuitMisc

;C034 - C03B : Pointers to bit checklists: (this,list_index),item_index = bit to check
BitCheckArr:
	DW #BitCheckBeam, #BitCheckBoot, #BitCheckSuitMisc, #BitCheck3SuitMisc

;C044 - C04B : Indirect pointers to tilemaps for enabled (?) items: (this,list_index),item_index = Tilemap pointer
TileMapROMArr:
	DW #TileMapsROMBeam, #TileMapsROMBoot, #TileMapsROMSuitMisc, #TileMapsROM3SuitMisc

;C18E -> $C196, $C19E, $C1B2, $C1CA
CursorPointer:
	DW #CursorBeam, #CursorBoot, #CursorSuitMisc, #Cursor3SuitMisc

; ----------------------------------------
;     Equipment Tilemap ROM Tables
; ----------------------------------------

TileMapsROMBeam:
	DW #TileMapCharge, #TileMapHypercharge, #TileMapIce, #TileMapWave, #TileMapSpazer, #TileMapPlasma
TileMapsROMSuitMisc:
TileMapsROM3SuitMisc:
	DW #TileMapAquaSuit, $BF64, #TileMap3Suit, $BF88, $BF9A, #TileMapSpeedBall, $BFC0, #TileMapUnknownItem
TileMapsROMBoot:
	DW #TileMapGravityBoots, $BFD2, $BFF6, $BFE4

; ----------------------------------------
;     Equipment Table Sizes
; ----------------------------------------

TileMapCounts:
	DW $000A, $0006, $000C, $000C
TileMapSizes:
	DW $0010, $0012, $0012, $0012

MapItemCircle:
    DW $0001 ; tile count
    	;   * X        Y        Tile
    	DW $0000 : DB $FF : DW $203E
MapItemDot:
    DW $0001 ; tile count
    	;   * X        Y        Tile
    	DW $0000 : DB $FF : DW $203F

pad $828FD3 : warnpc $828FD4


org $82AC4F
	JMP.w EquipmentMain
	JMP.w EquipmentScreenInit
	JMP.w EquipmentDraw

; ----------------------------------------
;     Equipment Bitmask Data
; ----------------------------------------

BitCheckBeam:
	DW $1000, $2000, $0002, $0001, $0004, $0008
BitCheckSuitMisc:
BitCheck3SuitMisc:
	DW $0020, $0001, !bitchecksuit3, $0004, $1000, $0002, $0008, !bitcheckunknown
BitCheckBoot:
	DW !bitcheckgravityboots, $0100, $2000, $0200

BitRAMEquippedTable:
	DW $09A6, $09A2, $09A2, $09A2
BitRAMOwnedTable:
	DW $09A8, $09A4, $09A4, $09A4

; ----------------------------------------
;     Equipment Tilemap RAM Addresses
; ----------------------------------------

TileMapRAMBeam:
	DW $3B86, $3BC6, $3C06, $3C46, $3C86, $3CC6
TileMapRAMSuitMisc:
	DW $3A6A, $3AAA, $0000, $3B2A, $3B6A, $3BAA, $3BEA, $3C2A
TileMapRAM3SuitMisc:
	DW $3A2A, $3A6A, $3AAA, $3B2A, $3B6A, $3BAA, $3BEA, $3C2A
TileMapRAMBoot:
	DW $3C6A, $3CAA, $3CEA, $3D2A

; ----------------------------------------
;     Equipment Tilemap Data
; ----------------------------------------

TileMapCharge:
	DW $0AFF, $0AD8, $0AD9, $0ADA, $0AE7, $0AA4, $0AA5, $0AA6
TileMapHypercharge:
	DW $0AFF, $0A94, $0A95, $0937, $0938, $0939, $092F, $0AD4
TileMapIce:
	DW $0AFF, $0ADB, $0ADC, $0AA4, $0AA5, $0AA6, $0AD4, $0AD4
TileMapWave:
	DW $0AFF, $0ADD, $0ADE, $0ADF, $0AA4, $0AA5, $0AA6, $0AD4
TileMapSpazer:
	DW $0AFF, $0AE8, $0AE9, $0AEA, $0AEB, $0AA4, $0AA5, $0AA6
TileMapPlasma:
	DW $0AFF, $0AEC, $0AED, $0AEE, $0AEF, $0AA4, $0AA5, $0AA6

TileMapAquaSuit:
	DW $0AFF, $0961, $0962, $0963, $0903, $0904, $0905, $0AD4, $0AD4
TileMap3Suit:
	DW $0AFF, $0967, $0968, $0969, $096A, $096B, $0903, $0904, $0905

TileMapSpeedBall:
	DW $0AFF, $0924, $0925, $0926, $0927, $0964, $0965, $0AD4, $0AD4

TileMapGravityBoots:
	DW $0AFF, $0AD0, $0AD1, $0AD2, $0AD3, $0910, $0911, $0912, $0913

TileMapUnknownItem:
	DW $0EFF, $0E80, $0E81, $0E82, $0E83, $0E84, $0E85, $0E86, $0E87

; ----------------------------------------
;     Equipment Cursor Locations
; ----------------------------------------

CursorBeam:
	DW $0028, $0074, $0028, $007C, $0028, $0084, $0028, $008C, $0028, $0094, $0028, $009C
CursorSuitMisc:
	DW $00CC, $004C, $00CC, $0054, $0000, $0000, $00CC, $0064, $00CC, $006C, $00CC, $0074, $00CC, $007C, $00CC, $0084
Cursor3SuitMisc:
	DW $00CC, $0044, $00CC, $004C, $00CC, $0054, $00CC, $0064, $00CC, $006C, $00CC, $0074, $00CC, $007C, $00CC, $0084
CursorBoot:
	DW $00CC, $008C, $00CC, $0094, $00CC, $009C, $00CC, $00A4

Numbers:
  DW $3C00, $3C01, $3C02, $3C03, $3C04, $3C05, $3C06, $3C07, $3C08, $3C09

SmallBoxSprite: 
	DW $0001, $0000 : DB $00 : DW $342F

BeamSelectorSprite:
    DW $0012;$0012 ; tile count
    	; If X 8000, then set size bit
    	; If X 0100, then set negative
    	;   * X        Y        Tile
    	DW $0010 : DB $04 : DW $3422
    	DW $0010 : DB $FC : DW $3422
    	DW $01F0 : DB $04 : DW $3422
    	DW $01F8 : DB $04 : DW $3422
    	DW $0000 : DB $04 : DW $3422
    	DW $0008 : DB $04 : DW $3422
    	DW $0008 : DB $FC : DW $3422
    	DW $0000 : DB $FC : DW $3422
    	DW $01F8 : DB $FC : DW $3422

    	DW $0018 : DB $04 : DW $3422
    	DW $0018 : DB $FC : DW $3422
    	DW $0020 : DB $04 : DW $3422
    	DW $0020 : DB $FC : DW $3422
    	DW $0028 : DB $04 : DW $3422
    	DW $0028 : DB $FC : DW $3422

    	DW $0030 : DB $04 : DW $3424 ; |
    	DW $0030 : DB $FC : DW $3423 ; `
    	DW $01F0 : DB $FC : DW $3421 ; |-

LogCategorySelectorSprite:
    DW $0010 ; tile count
    	; If X 8000, then set size bit
    	; If X 0100, then set negative
    	;   * X        Y        Tile
    	DW $01F0 : DB $FC : DW $3420 ; |-
    	DW $01F0 : DB $04 : DW $3422
    	DW $01F8 : DB $FC : DW $3422
    	DW $01F8 : DB $04 : DW $3422
    	DW $0000 : DB $FC : DW $3422
    	DW $0000 : DB $04 : DW $3422
    	DW $0008 : DB $FC : DW $3422
    	DW $0008 : DB $04 : DW $3422
    	DW $0010 : DB $FC : DW $3422
    	DW $0010 : DB $04 : DW $3422
    	DW $0018 : DB $FC : DW $3422
    	DW $0018 : DB $04 : DW $3422
    	DW $0020 : DB $FC : DW $3422
    	DW $0020 : DB $04 : DW $3422
    	DW $0028 : DB $FC : DW $3423 ; `
    	DW $0028 : DB $04 : DW $3424 ; |

LogEntrySelectorSprite:
    DW $001A ; tile count
    	; If X 8000, then set size bit
    	; If X 0100, then set negative
    	;   * X        Y        Tile
    	DW $01F0 : DB $FC : DW $3420 ; |-
    	DW $01F0 : DB $04 : DW $3422
    	DW $01F8 : DB $FC : DW $3422
    	DW $01F8 : DB $04 : DW $3422
    	DW $0000 : DB $FC : DW $3422
    	DW $0000 : DB $04 : DW $3422
    	DW $0008 : DB $FC : DW $3422
    	DW $0008 : DB $04 : DW $3422
    	DW $0010 : DB $FC : DW $3422
    	DW $0010 : DB $04 : DW $3422
    	DW $0018 : DB $FC : DW $3422
    	DW $0018 : DB $04 : DW $3422
    	DW $0020 : DB $FC : DW $3422
    	DW $0020 : DB $04 : DW $3422
    	DW $0028 : DB $FC : DW $3422
    	DW $0028 : DB $04 : DW $3422
    	DW $0030 : DB $FC : DW $3422
    	DW $0030 : DB $04 : DW $3422
    	DW $0038 : DB $FC : DW $3422
    	DW $0038 : DB $04 : DW $3422
    	DW $0040 : DB $FC : DW $3422
    	DW $0040 : DB $04 : DW $3422
    	DW $0048 : DB $FC : DW $3422
    	DW $0048 : DB $04 : DW $3422
    	DW $0050 : DB $FC : DW $3423 ; `
    	DW $0050 : DB $04 : DW $3424 ; |


DmgAmpTanksPostionX:
	DW $0038, $003D, $0042, $0047, $004C, $0051
DmgAmpTanksPostionY:
	DW $00A0
AccChgTanksPostionY:
	DW $00A8
SpaceJumpTanksPostionX:
   DW $00A8, $00B0, $00B8, $00C0, $00C8, $00D0, $00D8, $00E0, $00E8, $00F0
SpaceJumpTanksPostionY:
	DW $00A8


DamageBox:
	LDA $09D8
	BNE DamageContinue
	RTS
DamageContinue:
	;CMP #$0004
	;BMI $03
	;LDA #$0004
	DEC A
	ASL
	TAY
DamageBoxLoop:
	PHY
	LDX.w DmgAmpTanksPostionX, Y ; X position of each box
	LDY.w DmgAmpTanksPostionY   ; Y position of boxes
	DEY
	LDA #$006C
	JSL $81891F  ;  Draw sprite?
	PLY
	DEY
	DEY
	BPL DamageBoxLoop
	RTS


AccelBox:
	LDA $7ED840
	AND #$000F
	BNE AccelContinue
	RTS
AccelContinue:
	;CMP #$0004
	;BMI $03
	;LDA #$0004
	DEC A
	ASL
	TAY
AccelBoxLoop:
	PHY
	LDX.w DmgAmpTanksPostionX, Y ; X position of each box
	LDY.w AccChgTanksPostionY   ; Y position of boxes
	DEY
	LDA #$006C
	JSL $81891F  ;  Draw sprite?
	PLY
	DEY
	DEY
	BPL AccelBoxLoop
	RTS


SpaceJumpBox:
	LDA #$0200
	BIT $09A2 ; equipeed
	BNE SpaceJumpContinue
	LDA $09CA
	AND #$000F
	BEQ ExitSpaceJumpBox
	; Else draw the bar disabled
	;CMP #$0009
	;BMI $03
	;LDA #$0009
	TAY

	LDA #$0200
	BIT $09A4 ; collected
	BNE +
;DrawUnknownItem:
	DEY : PHY
	LDA #$0012   ; 9 tiles
	STA $16
	LDX #TileMapUnknownItem
	LDA #$3D2A
	STA $00
	JSR $A27E
	PLY
+

	LDA #$3A2B
	LDX #$3D6A
-
	STA $7E0000,X
	INX : INX
	DEY
	BPL -
ExitSpaceJumpBox:
	RTS
SpaceJumpContinue:
	LDA $09CA
	AND #$000F
	;CMP #$0009
	;BMI $03
	;LDA #$0009
	ASL
	TAY

SpaceJumpSpriteCap:
	PHY
	LDA SpaceJumpTanksPostionX+2,Y ; X position of each box
	TAX
	LDY SpaceJumpTanksPostionY   ; Y position of boxes
	DEY
	LDA #$001A
	JSL $81891F  ;  Draw sprite?
	PLY
SpaceJumpLoop:
	PHY
	LDA SpaceJumpTanksPostionX,Y ; X position of each box
	TAX
	LDY SpaceJumpTanksPostionY   ; Y position of boxes
	DEY
	LDA #$001B
	JSL $81891F  ;  Draw sprite?
	PLY
	DEY
	DEY
	BPL SpaceJumpLoop
	RTS


CheckPlasmaSpazer:
	LDA $0755
	BEQ CheckPlasmaSpazer_Return
	JSR GetSelectedSectionAndIndex
	CPX #$0000
	BNE CheckPlasmaSpazer_Return
CheckSpazer:	
	CPY #$0008
	BNE CheckPlasma
	LDA $09A6
	BIT #$0004
	BEQ CheckPlasma
	AND #$FFF7
	STA $09A6
	LDY #$000A
	BRA CheckPlasmaSpazer_UpdateColor
CheckPlasma:
	CPY #$000A
	BNE CheckPlasmaSpazer_Return
	LDA $09A6
	BIT #$0008
	BEQ CheckPlasmaSpazer_Return
	AND #$FFFB
	STA $09A6
	LDY #$0008

CheckPlasmaSpazer_UpdateColor:
	; get tilemap ram address
	LDA.w TileMapRAMBeam,Y
	STA $00
	LDA.w TileMapSizes,X
	STA $16
	LDA #$0C00 ; disabled pallete
	STA $12
	JSR $A29D    ; Set pallete
CheckPlasmaSpazer_Return:
	RTS


EquipmentMain:
	PHP
	REP #$30
	JSR EquipmentDraw	
	JSR ProcessInputs
	JSR $B1E0 ; DMA BG1
	PLP
	RTS

EquipmentDraw:
	JSR DamageBox
	JSR AccelBox
	JSR SpaceJumpBox
	JSR DrawItemSelector
	RTS

EquipmentScreenInit:
	REP #$30

	JSL DrawTimeAndPercent
	JSR DrawExtraFrames
	JSR SetInitialCursorPosition
	JSR EquipmentDraw

	LDX #$0004

NextEquipmentSection:
	STX $0F
	JSR GetEquipmentAdjustedIndex
	LDA.w TileMapRAMArr,X
	STA $03
	LDA.w BitCheckArr,X
	STA $05
	LDA.w TileMapROMArr,X
	STA $07
	LDA.w TileMapSizes,X
	STA $09
	LDY.w BitRAMEquippedTable,X
	LDA $0000,Y
	STA $0B
	LDY.w BitRAMOwnedTable,X
	LDA $0000,Y
	STA $0D
	LDY.w TileMapCounts,X

NextEquipmentLine:
	LDA ($03),Y
	STA $00
	LDA $09
	STA $16
	LDA ($05),Y
	BIT $0D
	BNE EquipmentOwned

	; Draw blank tiles
	LDX #$C01A   ; Pointer to a bunch of 0000's (9 tiles worth)
	JSR $A27E
	BRA EquipmentLineEndLoop

EquipmentOwned:
	; Draw equipment tiles
	LDA ($07), Y
	TAX
	JSR $A27E

	LDA ($05),Y
	BIT $0B
	BNE EquipmentLineEndLoop

	; Set disable color
	LDA ($03),Y
	STA $00
	LDA $09
	STA $16
	LDA #$0C00   ; Pallete override
	STA $12
	JSR $A29D    ; Set pallete

EquipmentLineEndLoop:
	DEY : DEY
	BPL NextEquipmentLine
	LDX $0F : DEX : DEX
	BPL NextEquipmentSection
	RTS


SetInitialCursorPosition:
	PHP
	REP #$30
	STZ $B1      ; BG1 X scroll = 0
	STZ $B3      ; BG1 Y scroll = 0

	STZ $0741    ; Equipment screen selection flashing animation index = 0
	LDA $C10C : AND #$00FF : STA $072D  ;} Equipment screen selection flashing animation timer = Fh
	STZ $0743    ; Equipment screen reserve tank flashing animation index = 0
	LDA $C165 : AND #$00FF : STA $072F  ;} Equipment screen reserve tank flashing animation timer = Fh

SetInitialCursorPosition_GetBeamIndex:
	LDX #$0000
	JSR GetFirstIndexInSection
	BCC SetInitialCursorPosition_GetSuitIndex ; No beams
	XBA : ORA #$0001 : STA $0755 : BRA SetInitialCursorPosition_Return

SetInitialCursorPosition_GetSuitIndex:
	LDX #$0004
	JSR GetFirstIndexInSection
	BCC SetInitialCursorPosition_GetBootsIndex ; No suits/misc
	XBA : ORA #$0003 : STA $0755 : BRA SetInitialCursorPosition_Return

SetInitialCursorPosition_GetBootsIndex:
	LDX #$0002
	JSR GetFirstIndexInSection
	BCC SetInitialCursorPosition_Return ; No boots
	XBA : ORA #$0002 : STA $0755

SetInitialCursorPosition_Return:
	PLP : RTS


GetEquipmentAdjustedIndex:
	CPX #$0004
	BNE GetEquipmentAdjusted_Return
	LDA $09A4
	BIT #!bitchecksuit3
	BEQ GetEquipmentAdjusted_Return
	INX : INX
GetEquipmentAdjusted_Return:
	RTS
pad $82B1DF : warnpc $82B1E0


org $82B267 
GetFirstIndexInSection:
	LDY #$0000
	BRA GetNextIndexInSection_Continue
GetNextIndexInSection:
	TYA : INY : INY
	CMP.w TileMapCounts,X
	BCS GetFirstIndexInSection_NoMatch

GetNextIndexInSection_Continue:
	JSR GetIndexData

GetFirstIndexInSection_Loop:
	LDA ($00),Y
	BIT $02
	BNE GetFirstIndexInSection_Found
	TYA : INY : INY
	CMP.w TileMapCounts,X
	BMI GetFirstIndexInSection_Loop
GetFirstIndexInSection_NoMatch:
	CLC
	BRA GetFirstIndexInSection_Return
GetFirstIndexInSection_Found:
	SEC
GetFirstIndexInSection_Return:
	TYA
	RTS


GetIndexData:
	PHY
	JSR GetEquipmentAdjustedIndex	
	LDA.w BitCheckArr,X
	STA $00
	LDY.w BitRAMOwnedTable,X
	LDA $0000,Y
	STA $02
	PLY
	RTS


GetLastIndexInSection:
	JSR GetIndexData
	LDY.w TileMapCounts,X
	BRA GetLastIndexInSection_Loop
GetPrevIndexInSection:
	JSR GetIndexData
	DEY : DEY
	BMI GetLastIndexInSection_NoMatch

GetLastIndexInSection_Loop:
	LDA ($00),Y
	BIT $02
	BNE GetLastIndexInSection_Found
	DEY : DEY
	BPL GetLastIndexInSection_Loop
GetLastIndexInSection_NoMatch:	
	CLC
	BRA GetLastIndexInSection_Return
GetLastIndexInSection_Found:
	SEC
GetLastIndexInSection_Return:
	TYA
	RTS	

HandleToggleItem:
	LDA $0755
	BEQ HandleToggleItem_Return ; If nothing is selected, return

	LDA #$0038
	JSL $809049  ;  Play Sound

	JSR GetSelectedSectionAndIndex

	; get tilemap ram address
	LDA.w TileMapRAMArr,X
	STA $00
	LDA ($00),Y
	STA $00

	LDA.w TileMapSizes,X
	STA $16

	; Get equimepnt bit
	LDA.w BitCheckArr,X
	STA $02
	LDA ($02),Y
	STA $02

	; flip equipped bit
	LDY.w BitRAMEquippedTable,X
	LDA $0000,Y
	EOR $02
	STA $0000,Y

	; Update pallete
	BIT $02
	BEQ HandleToggleItem_GetDisabledPallete
	LDA #$0800 ; active pallete
	BRA HandleToggleItem_SetPallete
HandleToggleItem_GetDisabledPallete:
	LDA #$0C00 ; disabled pallete
HandleToggleItem_SetPallete:
	STA $12
	JSR $A29D    ; Set pallete
	JSR SpaceJumpBox
HandleToggleItem_Return:
	RTS


GetSelectedSectionAndIndex:
	; Get Selected Section
	LDA $0755
	AND #$00FF
	DEC : ASL :	TAX
	JSR GetEquipmentAdjustedIndex

	; Get Selected Index
	LDA $0755
	AND #$FF00 : XBA
	TAY
	RTS


DrawItemSelector:
	PHP
	REP #$30
	LDA $0755
	BEQ DrawItemSelector_Return

	; Get Selected Section
	JSR GetSelectedSectionAndIndex
	TYA : ASL
	CLC
	ADC.w CursorPointer,X ; Position Address
	TAY

	; Draw sprite 3 at position (X-1, Y)
	LDX $0000,Y : DEX
	LDA $0002,Y : TAY
	LDA #$0003
	JSR $A881

DrawItemSelector_Return:
	PLP
	RTS


ProcessInputs:
	PHP
	REP #$30

	LDA $0755
	BEQ ProcessInputs_Return

ProcessInputs_TestUp:
	LDA $8F ; new pressed inputs
    BIT #$0800 ; Up
    BEQ ProcessInputs_TestDown
    JSR ProcessMoveUp
ProcessInputs_TestDown:
    BIT #$0400 ; Down
    BEQ ProcessInputs_TestLeft
    JSR ProcessMoveDown
ProcessInputs_TestLeft:
    BIT #$0200 ; Left
    BEQ ProcessInputs_TestRight
    JSR ProcessMoveLeft
ProcessInputs_TestRight:
    BIT #$0100 ; Right
    BEQ ProcessInputs_TestA
    JSR ProcessMoveRight
ProcessInputs_TestA:
    BIT #$0080 ; A
    BEQ ProcessInputs_Return
    JSR HandleToggleItem
	JSR CheckPlasmaSpazer
ProcessInputs_Return:
	PLP
	RTS


ProcessMoveLeft:
	PHA

	LDA $0755
	AND #$00FF
	CMP #$0002
	BEQ ProcessMoveLeft_FromBoots
	CMP #$0003
	BNE ProcessMoveLeft_Return
ProcessMoveLeft_FromSuits:
	LDX #$0000
	JSR GetFirstIndexInSection
	BCC ProcessMoveLeft_Return
	BRA ProcessMoveLeft_Set

ProcessMoveLeft_FromBoots:
	LDX #$0000
	JSR GetLastIndexInSection
	BCC ProcessMoveLeft_Return

ProcessMoveLeft_Set:
	XBA
	ORA #$0001
	STA $0755
	LDA #$0037  ;\
	JSL $809049 ;} Queue sound 37h, sound library 1
	
ProcessMoveLeft_Return:
	PLA
	RTS


ProcessMoveRight:
	PHA

	JSR GetSelectedSectionAndIndex
	CPX #$0000
	BNE ProcessMoveRight_Return

	CPY #$0006 ; Spazer index
	BCS ProcessMoveRight_FromLowerBeam
ProcessMoveRight_FromUpperBeam:
	LDX #$0004
	JSR GetEquipmentAdjustedIndex
	JSR GetFirstIndexInSection
	XBA : ORA #$0003
	BCS ProcessMoveRight_Set
	LDX #$0002
	JSR GetFirstIndexInSection
	XBA : ORA #$0002
	BCC ProcessMoveRight_Return
	BRA ProcessMoveRight_Set

ProcessMoveRight_FromLowerBeam:
	LDX #$0002
	JSR GetFirstIndexInSection
	XBA : ORA #$0002
	BCS ProcessMoveRight_Set
	LDX #$0004	
	JSR GetEquipmentAdjustedIndex
	JSR GetLastIndexInSection
	XBA : ORA #$0003	
	BCC ProcessMoveRight_Return

ProcessMoveRight_Set:
	STA $0755
	LDA #$0037  ;\
	JSL $809049 ;} Queue sound 37h, sound library 1
	
ProcessMoveRight_Return:
	PLA
	RTS


ProcessMoveDown:
	PHA

	JSR GetSelectedSectionAndIndex
	JSR GetNextIndexInSection
	BCS ProvessMoveDown_SameSection

	CPX #$0004
	BCC ProcessMoveDown_Return

	LDX #$0002
	JSR GetFirstIndexInSection
	BCC ProcessMoveDown_Return

	XBA
	ORA #$0002
	STA $0755
	BRA ProvessMoveDown_Sound

ProvessMoveDown_SameSection:
	XBA
	STA $00
	LDA $0755
	AND #$00FF
	ORA $00
	STA $0755
ProvessMoveDown_Sound:
	LDA #$0037  ;\
	JSL $809049 ;} Queue sound 37h, sound library 1

ProcessMoveDown_Return:
	PLA
	RTS


ProcessMoveUp:
	PHA

	JSR GetSelectedSectionAndIndex
	JSR GetPrevIndexInSection
	BCS ProcessMoveUp_SameSection

	CPX #$0002
	BNE ProcessMoveUp_Return

	LDX #$0004
	JSR GetEquipmentAdjustedIndex
	JSR GetLastIndexInSection
	BCC ProcessMoveUp_Return

	XBA
	ORA #$0003
	STA $0755
	BRA ProcessMoveUp_Sound

ProcessMoveUp_SameSection:
	XBA
	STA $00
	LDA $0755
	AND #$00FF
	ORA $00
	STA $0755
ProcessMoveUp_Sound:
	LDA #$0037  ;\
	JSL $809049 ;} Queue sound 37h, sound library 1

ProcessMoveUp_Return:
	PLA
	RTS	
pad $82B5E7 : warnpc $82B5E8

org $82A12B
; ----------------------------------------
;     Equipment Alternate Frames Data
; ----------------------------------------

SuitFrame1: ; /--SUIT--\
	DW $3941, $3942, $3942, $3943, $2AF6, $2AF7, $2AF8, $7943, $3942, $3942, $7941
SuitFrame2: ; |        |
	DW $3940, $280F, $280F, $280F, $280F, $280F, $280F, $280F, $280F, $280F, $7940

SpaceJumpFrame1:
	DW $F954, $3A38, $3A38, $3A38, $3A38, $3A38, $3A38, $3A38, $3A38, $3A38, $3944
SpaceJumpFrame2:
	DW $B941, $B942, $B942, $B942, $B942, $B942, $B942, $B942, $B942, $B942, $F941

DrawExtraFrames:
    LDA #$0200
    BIT $09A4
    BNE DrawSpaceJumpFrame
    LDA $09CA
	AND #$000F
	BEQ Check3SuitFrame
DrawSpaceJumpFrame:
	LDA #$0016   ; 11 tiles
	STA $16
	LDX #SpaceJumpFrame1
	LDA #$3D68
	STA $00
	JSR $A27E
	LDA #$0016   ; 11 tiles
	STA $16
	LDX #SpaceJumpFrame2
	LDA #$3DA8
	STA $00
	JSR $A27E
Check3SuitFrame:
	LDA #!bitchecksuit3 ; 3 suit test
	BIT $09A4
	BEQ DrawExtraFrames_Return
Draw3SuitFrame:
	LDA #$0016   ; 11 tiles
	STA $16
	LDX #SuitFrame1
	LDA #$39E8
	STA $00
	JSR $A27E  ;  Draw frame1
	LDA #$0016   ; 11 tiles
	STA $16
	LDX #SuitFrame2
	LDA #$3A28
	STA $00
	JSR $A27E  ;  Draw frame2
DrawExtraFrames_Return:
	RTS

pad $82A27D : warnpc $82A27E

org $82AB47
pad $82AC21 : warnpc $82AC22
