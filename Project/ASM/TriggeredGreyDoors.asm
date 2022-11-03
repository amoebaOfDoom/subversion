lorom

;BAF4 item delayed (bombs) grey right
org $84BAF4
	DW SetupTriggeredGreyDoor, TriggeredGreyDoorMain, TriggeredGreyDoorMain


org $84BA4C ;check for bombs loop
TriggeredGreyDoorMain:
	DW $0002, $A683
	DW #CheckTriggeredGreyDoor, $BA4C ;if condition to close met close door, otherwise loop
	DW $0028, $A683 ; frames to wait before really closing the door
	;close door stuff

;org $84BA7F
;DW $8A72, >$C4E2 ;If PLM room-arg is positive and the matching door bit is set, goto arg (become blue door)
;DW $8A24, >$BA93 ;Load arg and store in PLM Goto Instruction Pointer (handle contact)

;DW $BE3F
;$84BE3F 5A          PHY
;$84BE40 BC 17 1E    LDY $1E17,x[$84:1E55] ;unlock condition type
;$84BE43 B9 4B BE    LDA $BE4B,y[$84:BE53] ;load instruction pointer from table
;$84BE46 9D D7 1C    STA $1CD7,x[$84:1D15] ;save pre-PLM instruction instruction
;$84BE49 7A          PLY
;$84BE4A 60          RTS
;     00 -> $0000 -> $BDD4 = Main boss for the area is dead.
;     04 -> $0002 -> $BDE3 = Mini boss for the area is dead.
;     08 -> $0004 -> $BDF2 = Torizo for the area is dead.
;     0C -> $0006 -> $BE01 = Enemies Dead matches Enemies Needed.
;     10 -> $0008 -> $BE1C = Always closed.
;     14 -> $000A -> $BE1F = Delay in Tourian Gate room.
;     18 -> $000C -> $BE30 = Eticoons/Dachora saved?

;--- $BA8A Draw grey door closed
;DW $0001, >$A6D7

;--- $BA8D Do nothing loop
;DW $86B4
;DW $8724, >$BA8D

;--- $BA93 Handle contact
;DW $8A24, >$BAB7 ;Load arg and store in PLM Goto Instruction Pointer (handle contact 2)
;    $BA97
;DW $86C1, $BD0F ;Nothing????

;--- $BA9B blink door loop
;DW $0003, >$A9EF
;DW $0004, >$A6D7
;DW $0003, >$A9EF
;DW $0004, >$A6D7
;DW $0003, >$A9EF
;DW $0004, >$A6D7
;DW $8724, >$BA9B

;--- $BAB7 handle contact 2
;DW $8A91 ; Set door bit and prevent setting door bit again with this PLM, set PLM Goto Instruction Pointer to $8AA6 (RTS), and set next instruction to $BABC (the next one)
;  DB $01
;  DW >$BABC
;--- $BABC
;DW $8C19 ; Play open door sound
;  DB $07
; open door and stuff

org $84F6B0
SetupTriggeredGreyDoor:
	LDA $1DC8,Y
	AND #$007C ;Get unlock condition type
	;LSR A
	STA $1E17,Y ;store as offset into jump table
	LDA $1C85
	STA $1D77,Y ;store first plm ID
	LDA $1DC7,Y ;PLM Room argument
	AND #$83FF  ;mask out unlock condition type
	STA $1DC7,Y ;save door bit to use
	LDX $1C87,Y ;PLM's location in the room (nth block * 2)
	LDA #$C044
	JSR $82B4
	RTS

print pc
CheckTriggeredGreyDoor:
	PHX
	JSL $848290
	LDA $1C29
	INC : INC
	ASL : ASL : ASL : ASL
	CMP $0AF6
	BPL GreyDoorNotTriggered

	LDA $1E17,X
	AND #$0060
	LSR
	LSR
	LSR
	LSR
	TAX
	JMP (CloseTriggerCheckTable,X)

CloseTriggerCheckTable:
	DW CheckBombs, CheckHyper ; 4 things can go here

CheckBombs:
	PLX : PHX
	LDA $1C85
	CMP $1D77,X ;check if target plm is deleted
	BRA CheckTriggerCondition
CheckHyper:
    LDA $0A76

CheckTriggerCondition:
	BEQ GreyDoorNotTriggered
	PLX
	INY
	INY
	LDA $1E17,X
	AND #$001C ;Get unlock condition type
	LSR A
	STA $1E17,X ;store as offset into jump table
	RTS
GreyDoorNotTriggered:
	PLX
	LDA $0000,Y
	TAY
	RTS