lorom

!Bank = $A2

;Speed = Distance to sink when grappled (pixels)
;Speed2 = XYYY
;	X = What should happen when fully descended
;		0 = nothing
;		1 = trigger gate
;	YYY = PLM # to trigger

;org $AFF000 
;GFXLocation:
;	incbin ROMProject/Graphics/GrappleGate.gfx
;
;org $A0F880
;	DW $0400 ;GFX size
;	DW #GrappleGatePalette ;Enemy Palette pointer
;	DW $0014 ;Energy
;	DW $0000 ;Damage
;	DW $0008 ;Width
;	DW $0008 ;Height
;	DB !Bank ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $003E ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #GrappleGateInitAI ;Initiation AI $9C9F
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #GrappleGateRunAI ;Main AI $9D16
;	DW $8014 ;Grapple AI
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
;	DW $802D ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL #GFXLocation ;Enemy Graphics pointer
;	DB $05 ;Layer Priority
;	DW #GrappleGateDrops ;Drops pointer ($B4)
;	DW #GrappleGateWeaknesses ;Enemy Weaknesses pointer ($B4)
;	DW #GrappleGateName ;Enemy Name pointer ($B4)
;
;org $B4F4E6
;GrappleGateWeaknesses:
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
;GrappleGateDrops:
;	DB $00 ;small energy
;	DB $00 ;large energy
;	DB $00 ;missile
;	DB $FF ;nothing
;	DB $00 ;super missile
;	DB $00 ;power bomb
;GrappleGateName:
;	DB $47,$52,$41,$50,$50,$4C,$45,$47,$41,$54
;print pc

org $A2F8A0
GrappleGatePalette:
	DW $0000, $0000, $0000, $0000, $5F37, $3E10, $296C, $14A5, $7EB3, $55AD, $392A, $1C84, $7FFF, $7FFF, $7FFF, $0000

{
GrappleGateTileMap1:
	DW $0001,GrappleGateStructure1,$812F

GrappleGateStructure1:
	DW $0001
	DW $0000,$FFFF,Map1,GrappleGateHitbox

GrappleGateHitbox:
	DW $0001
	DW $FFF7,$FFF7,$0009,$0009,$804C,$802D
Map1:
	DW $0001
	DB $F8,$81,$F8,$00,$21
}

GrappleGateInitAI:
	;force flags so that the enemy can run regardless of what was set in SMILE
	LDX $0E54 ;Current Enemy Index
	LDA $0F86,X : ORA #$B000 : STA $0F86,X ;Property bits (Special from SMILE) - set Platform and Block Plasma
	LDA $0F88,X : ORA #$0004 : STA $0F88,X ;Extra property bits - set Extended tilemap format
	LDA $0FB4,X
	BNE DistanceSet
	LDA #$0010 ;One tile
DistanceSet:
	INC
	AND #$7FFF ;Don't let the distance be negative
	STA $0FB4,X

	LDA #GrappleGateTileMap1
	STA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	STZ $0FB2,X
	LDA $0F7E,X
	STA $0FAE,X
	CLC : ADC $0FB4,X : STA $0FB0,X

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

GrappleGateRunAI:
	LDX $0E54
	LDA $0F8A,X
	CMP #$0001
	BNE FloatUp
	LDA $0FB2,X
	INC
	STA $0FB2,X 
	CMP #$0008
	BMI ExitGrappleGateRunAI
	STZ $0FB2,X
	LDA $0F7E,X
	INC
	CMP $0FB0,X
	BPL AtBottom
	STA $0F7E,X
	BRA ExitGrappleGateRunAI
FloatUp:
	LDA $0FB2,X
	INC
	STA $0FB2,X 
	CMP #$0008
	BMI ExitGrappleGateRunAI
	STZ $0FB2,X
	LDA $0F7E,X
	DEC
	CMP $0FAE,X
	BMI AtTop
	STA $0F7E,X
	BRA ExitGrappleGateRunAI
AtTop:
	LDA $0FB6,X
	AND #$7FFF
	STA $0FB6,X
	BRA ExitGrappleGateRunAI
AtBottom:
	LDA $0FB6,X
	BIT #$1000
	BEQ ExitGrappleGateRunAI
	BIT #$8000
	BNE ExitGrappleGateRunAI

	AND #$0FFF
	ASL
	STA $00
	LDA #$004E
	SEC
	SBC $00
	TAX
	LDA #$FFFF
	STA $1D77,X

	LDX $0E54
	LDA $0FB6,X
	ORA #$8000
	STA $0FB6,X
ExitGrappleGateRunAI:
	RTL
