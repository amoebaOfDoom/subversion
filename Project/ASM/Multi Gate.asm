lorom

;Speed = 000X
;	X = Gate direction
;		0 = Left
;		1 = Right
;		2 = Up
;		3 = Down
;Speed2 = 0YYY
;	YYY = PLM # to trigger
;Tilemaps = Frames gate remains active before reseting
;
;Put multiples of this enemy in a row in the enemy list with the same target PLM to require multiple active simultaneously.

;org $AFF000 
;GFXLocation:
;	;incbin ROMProject/Graphics/GrappleGate.gfx
;
;org $A0F900
;	DW $0400 ;GFX size
;	DW #MultiGatePalette ;Enemy Palette pointer
;	DW $0014 ;Energy
;	DW $0000 ;Damage
;	DW $0008 ;Width
;	DW $0008 ;Height
;	DB $A2 ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $003E ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #MultiGateInitAI ;Initiation AI $9C9F
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #MultiGateRunAI ;Main AI $9D16
;	DW $800F ;Grapple AI
;	DW $804C ;Hurt AI
;	DW $8041 ;Frozen AI
;	DW $0000 ;X-Ray AI
;	DW $0000 ;Death Animation
;	DW $0000 ;UNUSED [Extra AI #2: $0024,X]
;	DW $0000 ;UNUSED [Extra AI #3: $0026,X]
;	DW $0000 ;Power Bomb AI
;	DW $0000 ;UNUSED [Extra AI #4: $002A,X]
;	DW $0000 ;UNUSED [Extra AI #5: $002C,X]
;	DW $0000 ;UNUSED [Extra AI #6: $002E,X]
;	DW $804C ;Touch AI
;	DW #MultiGateShotAI ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL #GFXLocation ;Enemy Graphics pointer
;	DB $05 ;Layer Priority
;	DW #MultiGateDrops ;Drops pointer ($B4)
;	DW #MultiGateWeaknesses ;Enemy Weaknesses pointer ($B4)
;	DW #MultiGateName ;Enemy Name pointer ($B4)
;
;org $B4F534
;MultiGateWeaknesses:
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
;	DB $00 ;Missiles
;	DB $00 ;Super missiles
;	DB $00 ;Bombs
;	DB $00 ;Power bombs
;	DB $00 ;Speedbooster
;	DB $00 ;Shinespark
;	DB $00 ;Screw Attack
;	DB $00 ;Charge beam / Hyper beam
;	DB $00 ;Psuedo screw attack
;	DB $00 ;Unused
;MultiGateDrops:
;	DB $00 ;small energy
;	DB $00 ;large energy
;	DB $00 ;missile
;	DB $FF ;nothing
;	DB $00 ;super missile
;	DB $00 ;power bomb
;MultiGateName:
;	DB $4D,$55,$4C,$54,$49,$20,$47,$41,$54,$45
;print pc

org $A2FB50
MultiGatePalette:
	DW $0000, $72B2, $71C7, $4D03, $5F37, $3E10, $296C, $14A5, $7FFF, $02DF, $01D7, $00AC, $0000, $0000, $0000, $0000

{
MultiGateTileMapOffL:
	DW $0001,MultiGateStructureOffL,$812F
MultiGateTileMapOnL:
	DW $0001,MultiGateStructureOnL,$812F

MultiGateTileMapOffR:
	DW $0001,MultiGateStructureOffR,$812F
MultiGateTileMapOnR:
	DW $0001,MultiGateStructureOnR,$812F

MultiGateTileMapOffU:
	DW $0001,MultiGateStructureOffU,$812F
MultiGateTileMapOnU:
	DW $0001,MultiGateStructureOnU,$812F

MultiGateTileMapOffD:
	DW $0001,MultiGateStructureOffD,$812F
MultiGateTileMapOnD:
	DW $0001,MultiGateStructureOnD,$812F

MultiGateStructureOffL:
	DW $0002
	DW $FFF8,$0000,MapL1,MultiGateHitboxOffL
	DW $0008,$0000,MapL2,MultiGateHitboxBlock
MultiGateStructureOnL:
	DW $0002
	DW $FFF8,$0000,MapL1,MultiGateHitboxOnL
	DW $0008,$0000,MapL3,MultiGateHitboxBlock

MultiGateStructureOffR:
	DW $0002
	DW $0008,$0000,MapR1,MultiGateHitboxOffR
	DW $FFF8,$0000,MapR2,MultiGateHitboxBlock
MultiGateStructureOnR:
	DW $0002
	DW $0008,$0000,MapR1,MultiGateHitboxOnR
	DW $FFF8,$0000,MapR3,MultiGateHitboxBlock

MultiGateStructureOffU:
	DW $0002
	DW $0000,$FFF8,MapU1,MultiGateHitboxOffU
	DW $0000,$0008,MapU2,MultiGateHitboxBlock
MultiGateStructureOnU:
	DW $0002
	DW $0000,$FFF8,MapU1,MultiGateHitboxOnU
	DW $0000,$0008,MapU3,MultiGateHitboxBlock

MultiGateStructureOffD:
	DW $0002
	DW $0000,$0008,MapD1,MultiGateHitboxOffD
	DW $0000,$FFF8,MapD2,MultiGateHitboxBlock
MultiGateStructureOnD:
	DW $0002
	DW $0000,$0008,MapD1,MultiGateHitboxOnD
	DW $0000,$FFF8,MapD3,MultiGateHitboxBlock

MultiGateHitboxOffR:
	DW $0002
	DW $FFF8,$FFFF,$0009,$0001,$8004,MultiGateShotAI
	DW $FFF8,$FFF8,$0004,$0008,$8004,MultiGateShotAI
MultiGateHitboxOnR:
	DW $0002
	DW $FFF8,$FFFF,$0009,$0001,$8004,$802D
	DW $FFF8,$FFF8,$0004,$0008,$8004,$802D

MultiGateHitboxOffL:
	DW $0002
	DW $FFF8,$FFFF,$0009,$0001,$8004,MultiGateShotAI
	DW $0004,$FFF8,$0008,$0008,$8004,MultiGateShotAI
MultiGateHitboxOnL:
	DW $0002
	DW $FFF8,$FFFF,$0009,$0001,$8004,$802D
	DW $0004,$FFF8,$0008,$0008,$8004,$802D

MultiGateHitboxOffD:
	DW $0002
	DW $FFFF,$FFF8,$0001,$0009,$8004,MultiGateShotAI
	DW $FFF8,$FFF8,$0008,$FFF4,$8004,MultiGateShotAI
MultiGateHitboxOnD:
	DW $0002
	DW $FFFF,$FFF8,$0001,$0009,$8004,$802D
	DW $FFF8,$FFF8,$0008,$FFF4,$8004,$802D

MultiGateHitboxOffU:
	DW $0002
	DW $FFFF,$FFF8,$0001,$0009,$8004,MultiGateShotAI
	DW $0004,$0008,$0008,$0008,$8004,MultiGateShotAI
MultiGateHitboxOnU:
	DW $0002
	DW $FFFF,$FFF8,$0001,$0009,$8004,$802D
	DW $0004,$0008,$0008,$0008,$8004,$802D

MultiGateHitboxBlock:
	DW $0001
	DW $FFF8,$FFF8,$0008,$0008,$8004,$802D

MapL1:
	DW $0001
	DB $F8,$81,$F8,$04,$21
MapL2:
	DW $0001
	DB $F8,$81,$F8,$08,$21
MapL3:
	DW $0001
	DB $F8,$81,$F8,$0A,$21

MapR1:
	DW $0001
	DB $F8,$81,$F8,$04,$61
MapR2:
	DW $0001
	DB $F8,$81,$F8,$08,$61
MapR3:
	DW $0001
	DB $F8,$81,$F8,$0A,$61

MapU1:
	DW $0001
	DB $F8,$81,$F8,$06,$21
MapU2:
	DW $0001
	DB $F8,$81,$F8,$0C,$21
MapU3:
	DW $0001
	DB $F8,$81,$F8,$0E,$21

MapD1:
	DW $0001
	DB $F8,$81,$F8,$06,$A1
MapD2:
	DW $0001
	DB $F8,$81,$F8,$0C,$A1
MapD3:
	DW $0001
	DB $F8,$81,$F8,$0E,$A1

MultiGateTileMapOff:
	DW MultiGateTileMapOffL, MultiGateTileMapOffR, MultiGateTileMapOffU, MultiGateTileMapOffD
MultiGateTileMapOn:
	DW MultiGateTileMapOnL, MultiGateTileMapOnR, MultiGateTileMapOnU, MultiGateTileMapOnD

MultiGateWidth:
	DW $0010, $0010, $0008, $0008
MultiGateHeight:
	DW $0008, $0008, $0010, $0010
}

MultiGateInitAI:
	;force flags so that the enemy can run regardless of what was set in SMILE
	LDX $0E54 ;Current Enemy Index
	LDA $0F86,X : ORA #$B000 : STA $0F86,X ;Property bits (Special from SMILE) - set Platform and Block Plasma
	LDA $0F88,X : ORA #$0004 : STA $0F88,X ;Extra property bits - set Extended tilemap format
	LDA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	BNE CooldownSet
	LDA #$0014
CooldownSet:
	STA $0FAA,X
	LDA $0FB4,X ;Speed from SMILE
	ASL
	TAY
	LDA MultiGateTileMapOff,Y
	STA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	LDA MultiGateWidth,Y
	STA $0F82,X ;Collision radius width (Width from DNA)
	LDA MultiGateHeight,Y
	STA $0F84,X ;Collision radius height (Height from DNA)
	STZ $0FB2,X ;Cooldown
	LDA $0FB6,X : AND #$0FFF : STA $0FB6,X ;Speed2 from SMILE

LoadPalette:
	PHB : PHX : PHY
	PEA.w $7E7E : PLB : PLB
	LDA $0F96,X ; Palette index (palette << 9)
	LSR : LSR : LSR : LSR ; A = palette << 5
	TAX
	LDY #$0006
.loop
	LDA $C208,Y
	STA $C30E,X
	DEX : DEX
	DEY : DEY
	BPL .loop
	PLY : PLX : PLB
	
	RTL

MultiGateRunAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FB2,X ;Cooldown
	BEQ MultiGateRunAI_Exit
	DEC
	STA $0FB2,X
	BNE MultiGateRunAI_Exit
	LDA $0FB4,X ;Speed from SMILE
	ASL
	TAY
	LDA MultiGateTileMapOff,Y
	STA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	LDA #$0001
	STA $0F94,X
	JSR CheckAllGatesSet
MultiGateRunAI_Exit:
	RTL

MultiGateShotAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FB2,X ;Cooldown
	BNE MultiGateShotAI_Exit

	LDA $0FAA,X
 	STA $0FB2,X ;Cooldown
 	LDA $0FB4,X ;Speed from SMILE
	ASL
	TAY
	LDA MultiGateTileMapOn,Y
	STA $0F92,X
	LDA #$0001
	STA $0F94,X

 	JSR CheckAllGatesSet
MultiGateShotAI_Exit:
	JSL $A2802D
	RTL

CheckAllGatesSet:
	PHX
	PHY
	LDX $0E54
	TXY
	LDA $0FB6,X ;Speed2 from SMILE
	STA $00
	
FindFirstGateEnemy_Loop:
	LDA $0F78,X ;Enemy ID
	CMP #$F900
	BNE FindFirstGateEnemy_Loop_Exit
	LDA $0FB6,X ;Speed2 from SMILE
	CMP $00
	BNE FindFirstGateEnemy_Loop_Exit

	TXY

	TXA
	SEC
	SBC #$0040
	TAX
	BPL FindFirstGateEnemy_Loop

FindFirstGateEnemy_Loop_Exit:
	TYX
CheckAllGatesSet_Loop:
	LDA $0F78,X ;Enemy ID
	CMP #$F900
	BNE TriggerPLM
	LDA $0FB6,X ;Speed2 from SMILE
	CMP $00
	BNE TriggerPLM

	LDA $0FB2,X ;Cooldown
	BEQ CheckAllGatesSet_Exit

	TXA
	CLC
	ADC #$0040
	TAX
	CMP #$0800
	BNE CheckAllGatesSet_Loop

TriggerPLM:
	LDX $0E54
	LDA $0FB6,X ;Speed2 from SMILE
	ASL
	STA $02
	LDA #$004E
	SEC
	SBC $02
	TAX
	LDA #$FFFF
	STA $1D77,X

	TYX
SetLongCooldown_Loop:
	LDA $0F78,X ;Enemy ID
	CMP #$F900
	BNE CheckAllGatesSet_Exit
	LDA $0FB6,X ;Speed2 from SMILE
	CMP $00
	BNE CheckAllGatesSet_Exit

	LDA #$0054
	STA $0FB2,X ;Cooldown

	TXA
	CLC
	ADC #$0040
	TAX
	CMP #$0800
	BNE SetLongCooldown_Loop

CheckAllGatesSet_Exit:
	PLY
	PLX
	RTS
