lorom

!Bank = $A3

;Speed = X position of mirror tile
;Speed2 = f00dd000 yyyyyyyy
;	f = full rotation mode
;	d = rotation direction
;		0 = CCW
;       1 = CW
;       2 = Flip
;	y = Y position of mirror tile
;Tilemaps = First of the pair of even bits to use to save the rotation state

;org $A0F8C0
;	DW $0400 ;GFX size
;	DW $DA9C ;Enemy Palette pointer - Reflec palette
;	DW $0014 ;Energy
;	DW $0000 ;Damage
;	DW $0008 ;Width
;	DW $0008 ;Height
;	DB !Bank ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $003E ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #RotatorControlInitAI ;Initiation AI $9C9F
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #RotatorControlRunAI ;Main AI $9D16
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
;	DW #RotatorControlShotAI ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL $AFAE00 ;Enemy Graphics pointer - Reflec graphics
;	DB $05 ;Layer Priority
;	DW $F31A ;Drops pointer ($B4) - Reflec drops
;	DW $EEC6 ;Enemy Weaknesses pointer ($B4) - Reflec weaknesses
;	DW #RotatorControlName ;Enemy Name pointer ($B4)
;
;org $B4F52A
;RotatorControlName:
;	DB $52,$4F,$54,$41,$54,$45,$20,$53,$50,$44
;print pc

org $A3F9A0
{
Instructions_Activate:
	DW $0006, #SpriteMapOn1
	DW $0006, #SpriteMapOn2
	DW $0006, #SpriteMapOn3
	DW $0006, #SpriteMapOn4
	DW #LoopActive, #Instructions_Activate
Instructions_Deactivate:
	DW $0001, #SpriteMapOff
	DW $812F ; sleep

SpriteMapOff:
	DW $0001
	DW $81F8 : DB $F8 : DW $2100
SpriteMapOn1:
	DW $0001
	DW $81F8 : DB $F8 : DW $2108
SpriteMapOn2:
	DW $0001
	DW $81F8 : DB $F8 : DW $210A
SpriteMapOn3:
	DW $0001
	DW $81F8 : DB $F8 : DW $210C
SpriteMapOn4:
	DW $0001
	DW $81F8 : DB $F8 : DW $210E
}

print "init"
print pc
RotatorControlInitAI:
	;force flags so that the enemy can run regardless of what was set in SMILE
	LDX $0E54 ;Current Enemy Index
	LDA $0F86,X : ORA #$B000 : STA $0F86,X ;Property bits (Special from SMILE) - set Platform and Block Plasma
	;LDA $0F88,X : ORA #$0004 : STA $0F88,X ;Extra property bits - set Extended tilemap format

	;Store the tile number matching the X,Y coordinated from paramaters
	LDA $0FB6,X ;Speed2 from SMILE - Y position
	AND #$8000
	STA $0FAE,X ; full rotation range
	LDA $0FB6,X ;Speed2 from SMILE - Y position
	XBA
	AND #$0018
	STA $0FB0,X ; rotation direction

	LDA $0FB6,X ;Speed2 from SMILE - Y position
	AND #$07FF
	TAY
	LDA $07A5 ;Current room's width in blocks
	JSL $8082D6 ;multiply A*Y -> 32-bits starting at $05F1
	LDA $05F3 ;high product
	BNE NonsenseTileNumber ;the tile number should never be this high
	LDA $05F1 ;low product
	CLC
	ADC $0FB4,X ;Speed from SMILE - X position
	ASL
	BMI NonsenseTileNumber ;the tile number should never be this high
	BRA SaveTileNumber
NonsenseTileNumber:
	LDA $0000
SaveTileNumber:
	STA $0FA8,X

	;Apply any rotations made previously
	LDA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	STA $0FAA,X
	PHX
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	PLX
	BIT $05E7
	BEQ InitRotateDone_1
	JSR RotateMirror
InitRotateDone_1:
	LDA $0FAE,X ; 2 bits if full rotation mode
	BEQ InitRotateDone_2

	LDA $0FAA,X
	INC
	PHX
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	PLX
	BIT $05E7
	BEQ InitRotateDone_2
	JSR RotateMirror
	JSR RotateMirror
InitRotateDone_2:

	LDA.w #Instructions_Deactivate
	STA $0F92,X
	LDA #$0001
	STA $0F94,X
	STZ $0FB2,X ; Enable State
	RTL


LoopActive:
	JSL $85A003
	BCS .continue
.wait
	LDA $0000,Y
	TAY
	RTL
.continue
	STZ $0FB2,X ; Enable State
	INY : INY
	RTL


print "main"
print pc
RotatorControlRunAI:
	RTL

;	LDA $0FB2,X ;Cooldown
;	BEQ RotatorControlRunAI_Exit
;	DEC
;	STA $0FB2,X
;RotatorControlRunAI_Exit:
;	RTL

print "shot"
print pc
RotatorControlShotAI:
	LDX $0E54 ;Current Enemy Index
	PHX

	LDA $0F86,X ;Property bits (Special from SMILE)
	BIT #$0100 ;Invisable flag
	BEQ RotatorControlShotAI_NoVisorRequired
	LDA $09A4 ; collected items
	BIT #$0800
	BEQ RotatorControlShotAI_Exit
RotatorControlShotAI_NoVisorRequired:

	LDA $0FB2,X ;Cooldown
	BNE RotatorControlShotAI_Exit
	JSL $85A003
	BCC RotatorControlShotAI_Exit

	LDA.w #Instructions_Activate
	STA $0F92,X
	LDA #$0001
	STA $0F94,X
	INC $0FB2,X

	LDA #$0028
 	STA $0FB2,X ;Cooldown
 	LDA #$0038
 	JSL $809049 ;play sound
	LDA $0FA8,X
	JSL $85A000 ;rotate mirror tile on the specified tile
	JSR RotateMirror

	;Update event bits to save rotation position
	LDA $0FAA,X
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	EOR $05E7
	STA $7ED820,X ;Event bit array
	BIT $05E7
	BNE RotatorControlShotAI_Exit
	PLX
	LDA $0FAE,X ; 2 bits if full rotation mode
	BEQ RotatorControlShotAI_ExitNoPLX 

	LDA $0FAA,X
	PHX
	INC
	JSL $80818E ;Setup bitmask in $05E7 for event
	LDA $7ED820,X ;Event bit array
	EOR $05E7
	STA $7ED820,X ;Event bit array

RotatorControlShotAI_Exit:
	PLX
RotatorControlShotAI_ExitNoPLX:
	RTL

print pc
RotateMirror:
	PHY : PHX : TXY
	LDA $0FA8,Y
	TAX
	LDA $7F0003,X 
	AND #$000C
	LSR
	CLC : ADC $0FB0,Y
	TAY
	LDA $7F0002,X
	AND #$F3FF
	ORA MirrorRotateTable,Y
	STA $7F0002,X     ; update gfx tile

.drawtile
	STA $1E69 		; $1E67 -> $0001, newtile, $0000

	LDA $7EDE6C 	; Set draw pointer
	PHA

	LDA #$0001
	STA $1E67
	STZ $1E6B
	LDA #$1E67
	STA $7EDE6C 	; Set draw pointer

	TXA
	LDX #$0000
	JSL $848293 ; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	JSL $84FEAC ; Draw graphics

	PLA
	STA $7EDE6C	

.invert_direction
	PLX : PLY

	LDA $0FAE,X ; test if full rotation mode
	BNE +
	LDA #$0008
	EOR $0FB0,X
	STA $0FB0,X
+
	RTS

MirrorRotateTable:
.counter_clockwise
	DW $0400, $0C00, $0000, $0800
.clockwise
	DW $0800, $0000, $0C00, $0400
.flip1:
	DW $0C00, $0800, $0400, $0000
.flip2:
	DW $0C00, $0800, $0400, $0000

