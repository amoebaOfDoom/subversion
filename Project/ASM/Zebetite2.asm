lorom

!Y = ",Y"
!Bank = $A3

;Speed = Where to spawn spark
;	00 = none
;	01 = top/left
;	02 = bottom/right
;	03 = both
;Speed2 = Event bit #
;	(0000 for always returning)
;
;Requires enemy $EA3F (SPA) to be added to the room's enemy list if sparks are spawned

;org $AFEC00 
;GFXLocation:
;	incbin ROMProject/Graphics/Zebetite2.gfx
;
;org $A0F800
;	DW $0400 ;GFX size
;	DW #ZebetitePalette ;Enemy Palette pointer
;	DW $012C ;Energy
;	DW $0000 ;Damage
;	DW $0000 ;Width
;	DW $0000 ;Height
;	DB !Bank ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $0000 ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #ZebetiteInitAI_V ;Initiation AI
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #ZebetiteRunAI ;Main AI
;	DW $800F ;Grapple AI
;	DW $804C ;Hurt AI
;	DW $8041 ;Frozen AI
;	DW $0000 ;X-Ray AI
;	DW $0004 ;Death Animation
;	DW $0000 ;UNUSED [Extra AI #2: $0024,X]
;	DW $0000 ;UNUSED [Extra AI #3: $0026,X]
;	DW $0000 ;Power Bomb AI
;	DW $0000 ;UNUSED [Extra AI #4: $002A,X]
;	DW $0000 ;UNUSED [Extra AI #5: $002C,X]
;	DW $0000 ;UNUSED [Extra AI #6: $002E,X]
;	DW #ZebetiteTouchAI ;Touch AI
;	DW #ZebetiteShotAI ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL #GFXLocation ;Enemy Graphics pointer
;	DB $05 ;Layer Priority
;	DW #ZebetiteDrops ;Drops pointer ($B4)
;	DW #ZebetiteWeaknesses ;Enemy Weaknesses pointer ($B4)
;	DW #ZebetiteName ;Enemy Name pointer ($B4)
;;org $A0F840
;	DW $0400 ;GFX size
;	DW #ZebetitePalette ;Enemy Palette pointer
;	DW $012C ;Energy
;	DW $0000 ;Damage
;	DW $0000 ;Width
;	DW $0000 ;Height
;	DB !Bank ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $0000 ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #ZebetiteInitAI_H ;Initiation AI
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #ZebetiteRunAI ;Main AI
;	DW $800F ;Grapple AI
;	DW $804C ;Hurt AI
;	DW $8041 ;Frozen AI
;	DW $0000 ;X-Ray AI
;	DW $0004 ;Death Animation
;	DW $0000 ;UNUSED [Extra AI #2: $0024,X]
;	DW $0000 ;UNUSED [Extra AI #3: $0026,X]
;	DW $0000 ;Power Bomb AI
;	DW $0000 ;UNUSED [Extra AI #4: $002A,X]
;	DW $0000 ;UNUSED [Extra AI #5: $002C,X]
;	DW $0000 ;UNUSED [Extra AI #6: $002E,X]
;	DW #ZebetiteTouchAI ;Touch AI
;	DW #ZebetiteShotAI ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL #GFXLocation ;Enemy Graphics pointer
;	DB $05 ;Layer Priority
;	DW #ZebetiteDrops ;Drops pointer ($B4)
;	DW #ZebetiteWeaknesses ;Enemy Weaknesses pointer ($B4)
;	DW #ZebetiteName ;Enemy Name pointer ($B4)
;
;org $B4F4C0
;ZebetiteWeaknesses:
;	DB $00 ;Power beam
;	DB $00 ;Wave beam
;	DB $00 ;Ice beam
;	DB $00 ;Ice + Wave beam
;	DB $00 ;Spazer beam
;	DB $00 ;Spazer + Wave beam
;	DB $00 ;Spazer + Ice beam
;	DB $00 ;Spazer + Wave + Ice beam
;	DB $00 ;Plasma beam
;	DB $00 ;Plasma + Wave beam
;	DB $00 ;Plasma + Ice beam
;	DB $00 ;Plasma + Wave + Ice beam
;	DB $02 ;Missiles
;	DB $02 ;Super missiles
;	DB $00 ;Bombs
;	DB $00 ;Power bombs
;	DB $00 ;Speedbooster
;	DB $00 ;Shinespark
;	DB $00 ;Screw Attack
;	DB $00 ;Charge beam / Hyper beam
;	DB $00 ;Psuedo screw attack
;	DB $02 ;Hyper Beam
;ZebetiteDrops:
;	DB $00 ;small energy
;	DB $00 ;large energy
;	DB $00 ;missile
;	DB $FF ;nothing
;	DB $00 ;super missile
;	DB $00 ;power bomb
;ZebetiteName:
;	DB $5A,$45,$42,$45,$54,$49,$54,$45,$32,$20
;print pc

org $A3F380
ZebetitePalette:
	DW $3800, $5739, $4273, $2DAD, $14C6, $19DA, $1174, $0D0F, $08AA, $3BEA, $3F86, $3AE2, $3642, $31A2, $6FDF, $0006,

{
ZebetiteTileMapV1:
	DW $0001,ZebetiteStructureV1,$812F
ZebetiteTileMapV2:
	DW $0001,ZebetiteStructureV2,$812F
ZebetiteTileMapV3:
	DW $0001,ZebetiteStructureV3,$812F
ZebetiteTileMapV4:
	DW $0001,ZebetiteStructureV4,$812F
ZebetiteTileMapV5:
	DW $0001,ZebetiteStructureV5,$812F
ZebetiteTileMapV6:
	DW $0001,ZebetiteStructureV6,$812F
ZebetiteTileMapV7:
	DW $0001,ZebetiteStructureV7,$812F
ZebetiteTileMapV8:
	DW $0001,ZebetiteStructureV8,$812F

ZebetiteTileMapH1:
	DW $0001,ZebetiteStructureH1,$812F
ZebetiteTileMapH2:
	DW $0001,ZebetiteStructureH2,$812F
ZebetiteTileMapH3:
	DW $0001,ZebetiteStructureH3,$812F
ZebetiteTileMapH4:
	DW $0001,ZebetiteStructureH4,$812F
ZebetiteTileMapH5:
	DW $0001,ZebetiteStructureH5,$812F
ZebetiteTileMapH6:
	DW $0001,ZebetiteStructureH6,$812F
ZebetiteTileMapH7:
	DW $0001,ZebetiteStructureH7,$812F
ZebetiteTileMapH8:
	DW $0001,ZebetiteStructureH8,$812F

ZebetiteStructureV1:
	DW $0003
	DW $0000,$FFF0,VMap1,ZebetiteHitbox
	DW $0000,$0000,VMap1,ZebetiteHitbox
	DW $0000,$0010,VMap1,ZebetiteHitbox
ZebetiteStructureH1:
	DW $0003
	DW $FFF0,$0000,HMap1,ZebetiteHitbox
	DW $0000,$0000,HMap1,ZebetiteHitbox
	DW $0010,$0000,HMap1,ZebetiteHitbox

ZebetiteStructureV2:
	DW $0003
	DW $0000,$FFF0,VMap2,ZebetiteHitbox
	DW $0000,$0000,VMap2,ZebetiteHitbox
	DW $0000,$0010,VMap2,ZebetiteHitbox
ZebetiteStructureH2:
	DW $0003
	DW $FFF0,$0000,HMap2,ZebetiteHitbox
	DW $0000,$0000,HMap2,ZebetiteHitbox
	DW $0010,$0000,HMap2,ZebetiteHitbox

ZebetiteStructureV3:
	DW $0003
	DW $0000,$FFF0,VMap3,ZebetiteHitbox
	DW $0000,$0000,VMap3,ZebetiteHitbox
	DW $0000,$0010,VMap3,ZebetiteHitbox
ZebetiteStructureH3:
	DW $0003
	DW $FFF0,$0000,HMap3,ZebetiteHitbox
	DW $0000,$0000,HMap3,ZebetiteHitbox
	DW $0010,$0000,HMap3,ZebetiteHitbox

ZebetiteStructureV4:
	DW $0003
	DW $0000,$FFF0,VMap4,ZebetiteHitbox
	DW $0000,$0000,VMap4,ZebetiteHitbox
	DW $0000,$0010,VMap4,ZebetiteHitbox
ZebetiteStructureH4:
	DW $0003
	DW $FFF0,$0000,HMap4,ZebetiteHitbox
	DW $0000,$0000,HMap4,ZebetiteHitbox
	DW $0010,$0000,HMap4,ZebetiteHitbox

ZebetiteStructureV5:
	DW $0003
	DW $0000,$FFF0,VMap5,ZebetiteHitbox
	DW $0000,$0000,VMap5,ZebetiteHitbox
	DW $0000,$0010,VMap5,ZebetiteHitbox
ZebetiteStructureH5:
	DW $0003
	DW $FFF0,$0000,HMap5,ZebetiteHitbox
	DW $0000,$0000,HMap5,ZebetiteHitbox
	DW $0010,$0000,HMap5,ZebetiteHitbox

ZebetiteStructureV6:
	DW $0003
	DW $0000,$FFF0,VMap6,ZebetiteHitbox
	DW $0000,$0000,VMap6,ZebetiteHitbox
	DW $0000,$0010,VMap6,ZebetiteHitbox
ZebetiteStructureH6:
	DW $0003
	DW $FFF0,$0000,HMap6,ZebetiteHitbox
	DW $0000,$0000,HMap6,ZebetiteHitbox
	DW $0010,$0000,HMap6,ZebetiteHitbox

ZebetiteStructureV7:
	DW $0003
	DW $0000,$FFF0,VMap7,ZebetiteHitbox
	DW $0000,$0000,VMap7,ZebetiteHitbox
	DW $0000,$0010,VMap7,ZebetiteHitbox
ZebetiteStructureH7:
	DW $0003
	DW $FFF0,$0000,HMap7,ZebetiteHitbox
	DW $0000,$0000,HMap7,ZebetiteHitbox
	DW $0010,$0000,HMap7,ZebetiteHitbox

ZebetiteStructureV8:
	DW $0003
	DW $0000,$FFF0,VMap8,ZebetiteHitbox
	DW $0000,$0000,VMap8,ZebetiteHitbox
	DW $0000,$0010,VMap8,ZebetiteHitbox
ZebetiteStructureH8:
	DW $0003
	DW $FFF0,$0000,HMap8,ZebetiteHitbox
	DW $0000,$0000,HMap8,ZebetiteHitbox
	DW $0010,$0000,HMap8,ZebetiteHitbox
	
ZebetiteHitbox:
	DW $0001
	DW $FFF7,$FFF7,$0009,$0009,ZebetiteTouchAI,ZebetiteShotAI
VMap1:
	DW $0004
	DB $F8,$01,$F8,$00,$21
	DB $00,$00,$F8,$01,$21
	DB $F8,$01,$00,$00,$21
	DB $00,$00,$00,$01,$21
VMap2:
	DW $0004
	DB $F8,$01,$F8,$10,$21
	DB $00,$00,$F8,$11,$21
	DB $F8,$01,$00,$10,$21
	DB $00,$00,$00,$11,$21
VMap3:
	DW $0004
	DB $F8,$01,$F8,$02,$21
	DB $00,$00,$F8,$03,$21
	DB $F8,$01,$00,$02,$21
	DB $00,$00,$00,$03,$21
VMap4:
	DW $0004
	DB $F8,$01,$F8,$12,$21
	DB $00,$00,$F8,$13,$21
	DB $F8,$01,$00,$12,$21
	DB $00,$00,$00,$13,$21

VMap5:
	DW $0004
	DB $F8,$01,$F8,$04,$21
	DB $00,$00,$F8,$05,$21
	DB $F8,$01,$00,$04,$21
	DB $00,$00,$00,$05,$21
VMap6:
	DW $0004
	DB $F8,$01,$F8,$14,$21
	DB $00,$00,$F8,$15,$21
	DB $F8,$01,$00,$14,$21
	DB $00,$00,$00,$15,$21
VMap7:
	DW $0004
	DB $F8,$01,$F8,$06,$21
	DB $00,$00,$F8,$07,$21
	DB $F8,$01,$00,$06,$21
	DB $00,$00,$00,$07,$21
VMap8:
	DW $0004
	DB $F8,$01,$F8,$16,$21
	DB $00,$00,$F8,$17,$21
	DB $F8,$01,$00,$16,$21
	DB $00,$00,$00,$17,$21

HMap1:
	DW $0004
	DB $F8,$01,$F8,$08,$21
	DB $00,$00,$F8,$08,$21
	DB $F8,$01,$00,$18,$21
	DB $00,$00,$00,$18,$21
HMap2:
	DW $0004
	DB $F8,$01,$F8,$09,$21
	DB $00,$00,$F8,$09,$21
	DB $F8,$01,$00,$19,$21
	DB $00,$00,$00,$19,$21
HMap3:
	DW $0004
	DB $F8,$01,$F8,$0A,$21
	DB $00,$00,$F8,$0A,$21
	DB $F8,$01,$00,$1A,$21
	DB $00,$00,$00,$1A,$21
HMap4:
	DW $0004
	DB $F8,$01,$F8,$0B,$21
	DB $00,$00,$F8,$0B,$21
	DB $F8,$01,$00,$1B,$21
	DB $00,$00,$00,$1B,$21
HMap5:
	DW $0004
	DB $F8,$01,$F8,$0C,$21
	DB $00,$00,$F8,$0C,$21
	DB $F8,$01,$00,$1C,$21
	DB $00,$00,$00,$1C,$21
HMap6:
	DW $0004
	DB $F8,$01,$F8,$0D,$21
	DB $00,$00,$F8,$0D,$21
	DB $F8,$01,$00,$1D,$21
	DB $00,$00,$00,$1D,$21
HMap7:
	DW $0004
	DB $F8,$01,$F8,$0E,$21
	DB $00,$00,$F8,$0E,$21
	DB $F8,$01,$00,$1E,$21
	DB $00,$00,$00,$1E,$21
HMap8:
	DW $0004
	DB $F8,$01,$F8,$0F,$21
	DB $00,$00,$F8,$0F,$21
	DB $F8,$01,$00,$1F,$21
	DB $00,$00,$00,$1F,$21

ZebetiteTM1:
	DW ZebetiteTileMapV1,ZebetiteTileMapH1
ZebetiteTM2:
	DW ZebetiteTileMapV2,ZebetiteTileMapH2
ZebetiteTM3:
	DW ZebetiteTileMapV3,ZebetiteTileMapH3
ZebetiteTM4:
	DW ZebetiteTileMapV4,ZebetiteTileMapH4
ZebetiteTM5:
	DW ZebetiteTileMapV5,ZebetiteTileMapH5
ZebetiteTM6:
	DW ZebetiteTileMapV6,ZebetiteTileMapH6
ZebetiteTM7:
	DW ZebetiteTileMapV7,ZebetiteTileMapH7
ZebetiteTM8:
	DW ZebetiteTileMapV8,ZebetiteTileMapH8

ZebetiteSize:
	DW $0008,$0018,$0018,$0008
ZebetiteTMTable:
	DW ZebetiteTM1
	DW ZebetiteTM2
	DW ZebetiteTM3
	DW ZebetiteTM4
	DW ZebetiteTM5
	DW ZebetiteTM6
	DW ZebetiteTM7
	DW ZebetiteTM8
}

ZebetiteInitAI_H:
	LDX $0E54 ;Current Enemy Index
	LDA #$0002
	STA $0FAA,X ;misc enemy ram - using as horizontal/vertical marker
	BRA ZebetiteInitAI_All
ZebetiteInitAI_V:
	LDX $0E54 ;Current Enemy Index
	STZ $0FAA,X ;misc enemy ram - using as horizontal/vertical index
ZebetiteInitAI_All:
	LDX $0E54 ;Current Enemy Index
	LDA $0FB6,X ;Speed2 from SMILE
	BEQ SetupZebetite
	DEC A
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	BIT $05E7
	BEQ SetupZebetite
	LDX $0E54 ;Current Enemy Index
	STZ $0F78,X ;Enemy ID Pointer - delete this enemy

	JSR PreloadSparkParams
	JSR SpawnSpark
	RTL
SetupZebetite:
	;force flags so that the enemy can run regardless of what was set in SMILE
	LDX $0E54 ;Current Enemy Index
	LDA $0F86,X : ORA #$B000 : STA $0F86,X ;Property bits (Special from SMILE) - set Platform and Block Plasma
	LDA $0F88,X : ORA #$0004 : STA $0F88,X ;Extra property bits - set Extended tilemap format
	;LDA $0FB4,X : AND #$00FF : STA $0FAA,X ;Speed from SMILE
	LDA $0FAA,X ;vertical/horizontal index
	TAY
	LDA ZebetiteTM1!Y
	STA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	TYA : ASL A : TAY
	LDA ZebetiteSize!Y : STA $0F82,X ;Collision radius width (Width from DNA)
	LDA ZebetiteSize+2!Y : STA $0F84,X ;Collision radius height (Height from DNA)
	STZ $0FA8,X ;misc enemy ram - using as frame counter
	RTL

ZebetiteRunAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FA8,X
	INC
	CMP #$0010
	BNE $03
	LDA #$0000
	STA $0FA8,X
	LSR
	STA $10
LoadZebetiteTM:
	LDA $10 : ASL A : TAY : LDA ZebetiteTMTable,Y : STA $12 : SEP #$20 : LDA #!Bank : STA $14 : REP #$20
	LDA $0FAA,X : TAY
	LDA [$12],Y : STA $0F92,X : LDA #$0001 : STA $0F94,X : RTL 

ZebetiteShotAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FB6,X ;Speed2 from SMILE
	STA $08
	JSR PreloadSparkParams

	JSL $A0A63D
	LDX $0E54 ;Current Enemy Index
	LDA $0F8C,X ; Enemy HP
	BNE EndZebetiteShotAI
	DEC $0E50 ; kill count
	LDA $7ED842
	DEC
	STA $7ED842
	JSR SpawnSpark
;CheckSetEventBit:
	LDA $08
	BEQ EndZebetiteShotAI
	DEC A
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	ORA $05E7
	STA $7ED820,X
EndZebetiteShotAI:
	RTL

PreloadSparkParams: ;get data from the zebetite before it gets deleted so it can be used to initilize the spark
	LDA $0FAA,X ;vertical/horizontal index
	STA $00
	LDA $0F7A,X ;X position
	STA $02
	LDA $0F7E,X ;Y position
	STA $04
	LDA $0FB4,X ;Speed from SMILE
	STA $06
	RTS

SpawnSpark:
;Spark1
	PHX
	LDA $00
	BNE Spark1_H
	LDA $04
	SEC
	SBC #$0014
	STA $04
	BRA Spark1_check
Spark1_H:
	LDA $02
	SEC
	SBC #$0014
	STA $02
Spark1_check:
	LDA $06
	BIT #$0001
	BEQ Spark2
;SpawnSpark_1
	LDX #SpawnData
	JSL $A09275
	LDY $0E4A
	LDA $02
	STA $0F7A,Y ;X position
	LDA $04
	STA $0F7E,Y ;Y position
Spark2:
	LDA $00
	BNE Spark2_H
	LDA $04
	CLC
	ADC #$0028
	STA $04
	BRA Spark2_check
Spark2_H:
	LDA $02
	CLC
	ADC #$0028
	STA $02
Spark2_check:
	LDA $06
	BIT #$0002
	BEQ EndSpawnSpark
;SpawnSpark_2
	LDX #SpawnData
	JSL $A09275
	LDY $0E4A
	LDA $02
	STA $0F7A,Y ;X position
	LDA $04
	STA $0F7E,Y ;Y position
EndSpawnSpark:
	PLX
	RTS
SpawnData:
	DW $EA3F ;Enemy ID
	DW $0000 ;X position
	DW $0000 ;Y position
	DW $0000 ;Pointer to current instruction
	DW $2000 ;Property bits (Special from SMILE)
	DW $0000 ;Extra property bits
	DW $0001 ;Speed from SMILE
	DW $0080 ;Speed2 from SMILE

ZebetiteTouchAI:
	RTL