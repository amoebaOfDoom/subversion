lorom

;pointer table for $949EA6 + (BTS * 2)
org $949EBE
	DW #IcePLM ;0C
	;DW #WavePLM ;0D
	DW #HyperPLM ;0D
	DW #SpazerPLM ;0E
	DW #PlasmaPLM ;0F

;---------------------------------------------------------------
;PLM headers

org $84F205
IcePLM:
	DW #IcePLM_Pre, $CBB7
;WavePLM:
;	DW #WavePLM_Pre, $CBB7
SpazerPLM:
	DW #SpazerPLM_Pre, $CBB7
PlasmaPLM:
	DW #PlasmaPLM_Pre, $CBB7
HyperPLM:
    DW #HyperPLM_Pre, $CBB7

org $84F221
IceBombReveal:
	DW $0001, $F227, $86BC, $0001, $C078, $0000
org $84F22D
HyperBombReveal:
	DW $0001, $F233, $86BC, $0001, $C077, $0000
org $84F239
SpazerBombReveal:
	DW $0001, $F23F, $86BC, $0001, $C079, $0000
org $84F245
PlasmaBombReveal:
	DW $0001, $F24B, $86BC, $0001, $C076, $0000

;---------------------------------------------------------------
;x-ray reaction table mods for $91

org $91D454
	DW $0078
org $91D458
	DW $0077
org $91D45C
	DW $0079
org $91D460
	DW $0076

org $84F105
IcePLM_Pre:
	LDX $0DDE
	LDA $0C18,X
	AND #$0F00
	CMP #$0500
	BEQ ICEAlpha
	LDA $0C18,X
	BIT #$0002
	BNE ICEBeta
	LDA #$0000
	STA $1C37,Y
	RTS
ICEBeta:
	LDX $1C87,Y
	LDA $7F0002,X
	AND #$F000
	ORA #$004D
	STA $1E17,Y
	AND #$8FFF
	STA $7F0002,X
	RTS
ICEAlpha:
	LDA #IceBombReveal
	STA $1D27,Y
	RTS

;WavePLM_Pre:
;	LDX $0DDE
;	LDA $0C18,X
;	AND #$0F00
;	CMP #$0500
;	BEQ WAVEAlpha
;	LDA $0C18,X
;	BIT #$0001
;	BNE WAVEBeta
;	LDA #$0000
;	STA $1C37,Y
;	RTS
;WAVEBeta:
;	LDX $1C87,Y
;	LDA $7F0002,X
;	AND #$F000
;	ORA #$004C
;	STA $1E17,Y
;	AND #$8FFF
;	STA $7F0002,X
;	RTS
;WAVEAlpha:
;	LDA #$F22D
;	STA $1D27,Y
;	RTS

SpazerPLM_Pre:
	LDX $0DDE
	LDA $0C18,X
	AND #$0F00
	CMP #$0500
	BEQ SPAZERAlpha
	LDA $0C18,X
	BIT #$0004
	BNE SPAZERBeta
	LDA #$0000
	STA $1C37,Y
	RTS
SPAZERBeta:
	LDX $1C87,Y
	LDA $7F0002,X
	AND #$F000
	ORA #$004E
	STA $1E17,Y
	AND #$8FFF
	STA $7F0002,X
	RTS
SPAZERAlpha:
	LDA #SpazerBombReveal
	STA $1D27,Y
	RTS

PlasmaPLM_Pre:
	LDX $0DDE
	LDA $0C18,X
	AND #$0F00
	CMP #$0500
	BEQ PLASMAAlpha
	LDA $0C18,X
	BIT #$0008
	BNE PLASMABeta
	LDA #$0000
	STA $1C37,Y
	RTS
PLASMABeta:
	LDX $1C87,Y
	LDA $7F0002,X
	AND #$F000
	ORA #$004F
	STA $1E17,Y
	AND #$8FFF
	STA $7F0002,X
	RTS
PLASMAAlpha:
	LDA #PlasmaBombReveal
	STA $1D27,Y
	RTS

HyperPLM_Pre:
	LDX $0DDE
	LDA $0C18,X
	AND #$0F00
	CMP #$0500
	BEQ HYPERAlpha
	LDA.w $0C2C,X
	CMP.w #1000
	BPL HYPERBeta
HYPERGamma:
	LDA #$0000
	STA $1C37,Y
	RTS
HYPERBeta:
	LDX $1C87,Y
	LDA $7F0002,X
	AND #$F000
	ORA #$004F
	STA $1E17,Y
	AND #$8FFF
	STA $7F0002,X
	RTS
HYPERAlpha:
	LDA #HyperBombReveal
	STA $1D27,Y
	RTS