lorom

org $84FF70
Header:
	DW #Setup, #InstructionList


InstructionList:
	DW $86B4 ; sleep


Setup:
	LDA $1C85

	STA $1D77,Y ;store first plm ID
	LDA.w #Main
	STA $1CD7,Y

	LDA $1E15 ; room arg
	BMI .return
	AND #$00FF
	JSL $80818E
	LDA $7ED870,X
	AND $05E7
	BEQ .return

.delete
	LDX $1C27
	STZ $1C37,X ; delete plm

.return
	RTS


Main:
	LDA $1C85
	CMP $1D77,X ;check if target plm is deleted
	BNE .trigger

	LDA $1D75
	CMP #$E03B ; shot block plm is in collected instruction
	BNE .return

.trigger
	; set item id
	PHX
	LDA $1DC7,x
	AND #$00FF
	JSL $80818E
	LDA $7ED870,x
	ORA $05E7 
	STA $7ED870,x
	PLX

	PHX
	LDA $1DC8,X ; room arg+1
	AND #$000F
	TAX
	PHP
	SEP #$20
	LDA $7ED860,X
	INC
	STA $7ED860,X
	PLP
	PLX 
	STZ $1C37,X ; delete plm

.return
	RTS

warnpc $84FFFF