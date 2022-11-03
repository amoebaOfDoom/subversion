lorom
;Disappearing/Reappearing blocks
;Will be PLMs. Needs these values:
;On time, Off time, Initial time, Initial value, Graphic
;Room Argument will be OffTime(High byte) and OnTime(Low byte). Multiplied by something to be reasonable (say, 16 frames, for a max of 68 seconds)
;Initial time will be BTS
;Initial value will be block type (0-7 = air, 8-F = solid. ASSUMED to be 0 or 8)
;Graphic will be original graphic, obviously (0 - FFF)

;HOW TO USE THIS PLM:

;Move F060.gif to SMILE's PLM folder.

;Make a block with whatever graphic you want it to use while it's solid.
;Make the block either air or solid, depending on how you want it to start.
;Give the block a BTS value from 00 to FF. This is the timer for how long the block waits before it first disappears/reappears.
;Put this PLM on top of the block.
;Change the High Index to how long you want the block to be unsolid every cycle (01 - FF, 00 is 18 hours)
;Change the Low Index to how long you want the block to be solid every cycle (01 - FF, 00 is 18 hours)

;Timer approximations:
;01 = 1/4 second (Exact value: 0.26666... seconds)
;04 = 1 second
;08 = 2 seconds
;0C = 3 seconds
;10 = 4 seconds
;80 = 34 seconds
;FF = 68 seconds
;Note that the time it takes for the block to disappear or reappear is exactly 1 timer tick.

org $84F4B0
DW DRInit, DRInstructions

DRInstructions:
DW $8C46 ;Play 'Break block' sound.
	DB $0A
DW $0004, $A345 ;Animation for breaking block
DW $0004, $A34B
DW $0004, $A351
DW $0004, $A357
DW Part1 ;Wait for 'Time off'
DRInstructionsB:
DW $0005, $A351 ;Animate breaking block in reverse
DW $0005, $A34B
DW $0005, $A345
DW $8B17 ;Acts like a 1-frame animation with the stored tile.
DW Part2

DRInit:
	LDA $1C87,Y
	LSR
	TAX
	LDA $7F6401,X
	SEP #$20
	LDA #$00
	STA $7F6402,X
	TYX
	XBA
	REP #$20
	ASL
	ASL
	ASL
	ASL
	INC
	STA $7EDE1C,X
	LDX $1C87,Y
	LDA $7F0002,X
	BMI SetGraphic
	PHA
;Need to mimic PLM instruction 8B17 here
	LDA #$00FF
	STA $7F0002,X
	STA $1E69
	LDA #$0001
	STA $1E67
	STZ $1E6B
	LDA #$1E67
	TYX
	STA $7EDE6C,X
	LDA #DRInstructionsB
	STA $1D27,Y
	JSR $861E
	LDX $1C27
	JSL $848290
	JSR $8DAA
	PLA
	ORA #$8000
	TXY
SetGraphic:
	STA $1E17,Y
	RTS


Part1:
	LDA $1DC7,X
	AND #$FF00
	BEQ Delete
	LSR
	LSR
	LSR
	LSR
	STA $7EDE1C,X
	TYA
	STA $1D27,X
	PLA
	RTS

Part2:
	LDA $1DC7,X
	AND #$00FF
	BEQ Delete
	ASL
	ASL
	ASL
	ASL
	STA $7EDE1C,X
	LDA #DRInstructions
	STA $1D27,X
	PLA
	RTS

Delete:
	PLA
	RTS
