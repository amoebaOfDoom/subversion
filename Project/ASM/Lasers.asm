lorom

!hLaser = #$A0E0
!vLaser = #$A0E1
!crossLaser = #$A0E2
!mirrorLitTile = #$80E3
!mirrorTile = #$80E4
!BitSuit3 = #$0010 ; metroid suit

!DrawPos = $7EDF0C
!DelPos = $7EDEBC
!DrawDir = $1E17
!DelDir = $1E18
!TriggerFlag = $1D77

!LaserPowerEvent = #$001F


org $84FE90 : 
LaserPLM:
	DW $84E6, #LaserPLMCode 	;RTS, plmcode
LaserPLMCode:
	DW #LoadGFX
	DW #UpdateGFX

TriggerPLM:
	DW $84E6, #TriggerPLMCode 	;RTS, plmcode
TriggerPLMCode:
	DW $0001, DrawOffTrigger
	DW #TriggerCode
	DW $0001, DrawOnTrigger
	DW TestOffTrigger
	DW $8724, #TriggerPLMCode

LongDrawJSR:
	JSR $8DAA
	RTL

TestOffTrigger:
	JSL TestOffTrigger_long
	BRA TriggerCode_return
TriggerCode:
	JSL TriggerCode_long
TriggerCode_return:
	LDA #$0001
	STA $7EDE1C,X  	; Set delay
	PLA
	RTS

TriggerPLMOff_Perma:
	DW $0001, DrawOnTrigger
	DW $86BC 

DrawOffTrigger:
	DW $0001, $80D6, $0000
DrawOnTrigger:
	DW $0001, $80D7, $0000


LoadGFX:
	TYA
	STA $1D27,X ; Update instruction addr
	JSL LoadGFXLong

	LDA #$0001
	STA $7EDE1C,X  	; Set delay
	PLA	
	RTS

UpdateGFX:
	JSL UpdateGFXLong

	LDA #$0001
	STA $7EDE1C,X  	; Set delay
	PLA
	RTS

org $85A000 : 
	JMP UpdateLaserRotor

TestLasersIdle:
	PHY
	PHX
 	PHA

	LDA #$FE90
	LDX #$004E
TestLasersIdle_Loop:
	CMP $1C37,X
	BNE TestLasersIdle_NotFound

	LDY !DrawDir,X
	CPY #$FFFF
	BEQ TestLasersIdle_NotFound
	CLC
	BRA TestLasersIdle_End

TestLasersIdle_NotFound:
	DEX
	DEX
	BPL TestLasersIdle_Loop
	SEC

TestLasersIdle_End:
	PLA
	PLX
	PLY
	RTL



UpdateLaserRotor:
	PHX
	PHY
	STA $0C
	PHB
 	LDA #$8500 ; Update DB
 	PHA
 	PLB
 	PLB

	LDA #$FE90
	LDX #$004E
	LDY #$FFFF
SearchLaserLoop:
	CMP $1C37,X
	BNE SearchLaserLoop_NotFound
	TXY
	JSR SearchLaserFound
SearchLaserLoop_NotFound:
	DEX
	DEX
	BPL SearchLaserLoop
SearchLaser_End:
	PLB
	PLY
	PLX
	RTL

SearchLaserFound:
	PHA
	PHY
	PHX

	;LDA !DrawDir,x
	;CMP #$FFFF
	;BNE SearchMirror_End
	LDA $1DC7,X 
	AND #$0003
 	ASL
	TAY
	LDA $1C87,X 	; plm location
	STA $0E

SearchMirrorNext:
	LDA $0E
	TYX
	JSR (MoveDirection,X)
	CPX $0C
	BEQ SearchMirrorFound
	STA $0E
	LDA $7F0002,X 	; update gfx tile
	STA $10
	AND #$00FF
	CMP !mirrorLitTile&#$00FF
	BNE SearchMirrorNotMirror
	LDA $11 	; update gfx tile
	AND #$000C
	LSR
	LSR
	CLC
	ADC MirrorTable,Y
	PHX
	TAX
	LDA $0000,X
	PLX
	AND #$00FF
	BIT #$00F0
	BNE SearchMirror_End
	TAY
	BRA SearchMirrorNext
SearchMirrorNotMirror:
	LDA $10 	; update gfx tile
	AND #$00FC
	CMP !hLaser&#$00FF
	BEQ SearchMirrorNext
	BRA SearchMirror_End

SearchMirrorFound:
	PLX
	LDA $0E
	STA !DrawPos,X
	STA !DelPos,X
	TYA
	SEP #$20
	STA !DrawDir,X
	STA !DelDir,X
	REP #$20

	LDA $0C
	PHA
	JSR DeleteLaser
	PLA
	STA $0C
	PHX

SearchMirror_End:
	PLX
	PLY
	PLA
 	RTS


DrawLaser:
 	PHY
	LDA #$0001
	STA $1E67
	STZ $1E6B
	LDA #$1E67 		
	STA $7EDE6C,X 	; Set draw pointer
	;JSL $848290 	; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	LDA !DrawDir,X
	AND #$00FF
	TAY
DrawNext:
	PHX
	LDA !DrawPos,X
	TYX
	JSR (MoveDirection,X)
	STA $00

	PLX
	PHX
	CMP !DelPos,X
	BNE DrawContinueDel
	LDA !DelDir,X
	AND #$00FF
	CMP #$00FF
	BEQ DrawContinueDel
	SEP #$20
	LDA ReverseDirection,Y
	CMP !DelDir,X
	BNE DrawContinueDel
	LDA #$FF
	STA !DelDir,X
DrawContinueDel:
	REP #$20
	LDX $00

	LDA $7F0002,X 	; update gfx tile
	STA $10
	CMP LaserTileDirection+2,Y
	BNE NotIntersectLaser
	LDA !crossLaser      ; + Laser
	BRA DrawContinue
NotIntersectLaser:	
	LDA $10 	; update gfx tile
	AND #$00FF
	CMP !mirrorTile&#$00FF
	BEQ Mirror
	CMP !mirrorLitTile&#$00FF
	BNE NotMirror
Mirror:
	LDA $11 	; update gfx tile
	AND #$000C
	LSR
	LSR
	CLC
	ADC MirrorTable,Y
	PHX
	TAX
	LDA $0000,X
	PLX
	AND #$00FF
	BIT #$00F0
	BNE DrawEnd
	TAY
	LDA $10 	; update gfx tile
	AND #$0C00
	ORA !mirrorLitTile
	BRA DrawContinue
NotMirror:
	LDA $10 	; update gfx tile
	AND #$00FC
	CMP !hLaser&#$00FF
	BNE NotLaser
	LDA $10
	BRA DrawContinue
NotLaser:
	LDA $10 	; update gfx tile
	AND #$F000
	BNE DrawEnd
	LDA LaserTileDirection,Y ; tile to draw
DrawContinue:
	STA $7F0002,X 	; update gfx tile
	STA $1E69 		; $1E67 -> $0001, newtile, $0000
	JSR SetSuit3BTS

	TXA
	PLX
	STA !DrawPos,X
	TYA
	SEP #$20
	STA !DrawDir,X
	REP #$20

	LDA !DrawPos,X
	JSL $848293 	; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	JSL LongDrawJSR 		; Draw graphics
	PLY
	RTS
DrawEnd:
	LDY $00
	LDA #$0001
	JSR SearchTriggerPLM
	PLX
	SEP #$20
	LDA #$FF
	STA !DrawDir,X
	REP #$20
	PLY
	RTS


DeleteLaser:
 	PHY
	LDA #$0001
	STA $1E67
	STZ $1E6B
	LDA #$1E67 		
	STA $7EDE6C,X 	; Set draw pointer
	;JSL $848290 	; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	LDA !DelDir,X
	AND #$00FF
	TAY
DeleteNext:
	PHX
	LDA !DelPos,X
	TYX
	JSR (MoveDirection,X)
	STA $00

	PLX
	PHX
	CMP !DrawPos,X
	BNE DelContinueDel
	LDA !DrawDir,X
	AND #$00FF
	CMP #$00FF
	BEQ DelContinueDel
	SEP #$20
	LDA ReverseDirection,Y
	CMP !DrawDir,X
	BNE DelContinueDel
	REP #$20
	BRA DeleteEnd
DelContinueDel:
	REP #$20
	LDX $00

	LDA $7F0002,X 	; update gfx tile
	STA $10
	CMP !crossLaser
	BNE DeleteNotIntersectLaser
	LDA LaserTileDirection+2,Y ; + Laser
	BRA DeleteContinue
DeleteNotIntersectLaser:	
	LDA $10 	; update gfx tile
	AND #$00FF
	CMP !mirrorLitTile&#$00FF
	BNE DeleteNotMirror
DeleteMirror:
	LDA $11 	; update gfx tile
	AND #$000C
	LSR
	LSR
	CLC
	ADC MirrorTable,Y
	PHX
	TAX
	LDA $0000,X
	PLX
	AND #$00FF
	BIT #$00F0
	BNE DeleteEnd
	TAY
	LDA $10 	; update gfx tile
	AND #$0C00
	ORA !mirrorTile
	BRA DeleteContinue
DeleteNotMirror:
	LDA $10 	; update gfx tile
	AND #$00FE
	CMP !hLaser&#$00FF
	BNE DeleteEnd
	LDA #$00FF
DeleteContinue:
	STA $7F0002,X 	; update gfx tile
	STA $1E69 		; $1E67 -> $0001, newtile, $0000
	JSR SetSuit3BTS

	TXA
	PLX
	STA !DelPos,X
	TYA
	SEP #$20
	STA !DelDir,X
	REP #$20

	LDA !DelPos,X
	JSL $848293 	; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	JSL LongDrawJSR 		; Draw graphics
	PLY
	RTS
DeleteEnd:
	LDY $00
	LDA #$0000
	JSR SearchTriggerPLM
	PLX
	SEP #$20
	LDA #$FF
	STA !DelDir,X
	REP #$20
	PLY
	RTS


MoveRight:
	INC A
	INC A
	TAX
	RTS
MoveLeft:
	DEC A
	DEC A
	TAX
	RTS
MoveUp:
	LSR
	SEC
	SBC $07A5
	ASL
	TAX
	RTS
MoveDown:
	LSR
	CLC
	ADC $07A5
	ASL
	TAX
	RTS


SetSuit3BTS:
	PHX 
	LDA $7F0002,X
	AND #$F000
	CMP #$A000
	BNE SetSuit3BTSNoSuit3
	LDA #$0007
	STA $00
	BRA SetSuit3BTSContinue
SetSuit3BTSNoSuit3:
	STZ $00
SetSuit3BTSContinue:
	TXA
	LSR
	TAX 
	SEP #$20     
	LDA $00 ; Get BTS
	STA $7F6402,x ; Set BTS
	REP #$20     
	PLX   
	RTS  


MoveDirection:
	DW #MoveRight, #MoveUp, #MoveLeft, #MoveDown
LaserTileDirection:
	DW !hLaser, !vLaser, !hLaser, !vLaser, !hLaser

; DL, DR, UL, UR
; 00, 04, 08, 0C
MirrorTable:
	DW #MirrorTableRight, #MirrorTableUp, #MirrorTableLeft, #MirrorTableDown
MirrorTableRight:
	DB $FF, $02, $FF, $06
MirrorTableUp:
	DB $FF, $FF, $00, $04
MirrorTableLeft:
	DB $02, $FF, $06, $FF
MirrorTableDown:
	DB $00, $04, $FF, $FF


PRINT PC
LoadGFXLong:
	PHB
	PHY
 	LDA #$8500 ; Update DB
 	PHA
 	PLB
 	PLB

 	; Check if laser should be disabled by event
 	LDA $079F
 	CMP #$0005 ; always on in space station
 	BCS LoadGFXLong_Continue
    LDA !LaserPowerEvent
    JSL $808233
    BCC LoadGFXLong_Continue:
    LDA $1DC7,X ; \
    ORA #$8000  ; } Set to disabled and draw
    STA $1DC7,X ; /

    ; Check if disabled
LoadGFXLong_Continue:
 	LDA $1DC7,X 
 	BIT #$8000
 	BEQ LoadGFXLong_LoadDirection
LoadGFXLong_Disable:
 	LDA #$FFFF ; no direction
 	BRA LoadGFXLong_SetDirection
LoadGFXLong_LoadDirection:
 	AND #$0003
 	ASL
 	ORA #$FF00
LoadGFXLong_SetDirection:
 	STA !DrawDir,x
 	LDA $1C87,X 	; plm location
 	STA !DrawPos,x

LoadGFXLong_DrawLaser:
	JSR DrawLaserShooter
	PLY
	PLB
	RTL


PRINT pc
UpdateGFXLong:
	PHB
 	LDA #$8500 ; Update DB
 	PHA
 	PLB
 	PLB

	LDA !DrawDir,x
	CMP #$FFFF
	BNE TriggerFlagCheckDone
	LDA !TriggerFlag,X
	BEQ TriggerFlagCheckDone
 	LDA $1DC7,X 
 	AND #$0003
 	ASL
 	ORA #$FF00
 	STA $00
 	LDA $1DC7,X 
 	BIT #$8000
 	BEQ DeactivateOff 

 	LDA $00
 	STA !DrawDir,x
 	LDA $1C87,X 	; plm location
 	STA !DrawPos,x
 	BRA ActivateContinue
DeactivateOff:
 	LDA $00
 	XBA
 	STA !DrawDir,x
 	LDA $1C87,X 	; plm location
 	STA !DelPos,x
ActivateContinue: 
 	LDA #$8000
 	EOR $1DC7,X 
 	STA $1DC7,X
	JSR DrawLaserShooter 	
TriggerFlagCheckDone:

 	LDA !DelDir-1,x
 	BMI DoNotDel
 	JSR DeleteLaser
DoNotDel:
 	LDA !DrawDir-1,x
 	BMI DoNotDraw
 	JSR DrawLaser
DoNotDraw:
	
	LDA !DrawDir,x
	CMP #$FFFF
	BNE ClearTriggerFlagDone
	STZ !TriggerFlag,X
ClearTriggerFlagDone:

	;LDA $7EDF0C,x ; load dynamic GFX ID
	;TAX
	LDX #$0006                   
	LDA VRAMoffset,x ; VRAM location
	STA $12     

	LDA $1842 ; frame count
	AND #$0007
	XBA
	CLC
	ADC #LaserGFX ;Load GFX frame pointer
	STA $08

	LDX $0330  ; D-stack pointer
	LDA #$00C0 ; DMA Size             
	STA $D0,x  
	LDA $08 ; GFX Source Pointer (in ROM)
	STA $D2,x  
	LDA #$0085 ; GFX Source Bank             
	STA $D4,x  
	LDA $12    ; VRAM Destination
	STA $D5,x  

	TXA                     
	CLC                     
	ADC #$0007              
	STA $0330  ; update stack pointer

	LDX $1C27  ; restore X
 	PLB
	RTL


DrawLaserShooter:
	PHX
	PHY

 	LDA $1C87,X
 	STA $00

	LDA #$1E67 		
	STA $7EDE6C,X 	; Set draw pointer
	LDA #$0001
	STA $1E67
	STZ $1E6B

 	LDA $1DC7,X 
 	AND #$0003
 	ASL
 	TAY

 	PHX
 	LDA $1DC7,X 
	LDX LaserShooterTiles,Y ; tile to draw
 	BIT #$8000
 	BEQ DrawLaserShooter_Active
	INX
DrawLaserShooter_Active:
	TXA

 	LDX $00
	STA $7F0002,X 	; update gfx tile
	STA $1E69 		; $1E67 -> $0001, newtile, $0000
	PLX

	JSL $848290 	; Calculate PLM X, Y position into $1C29(X) and $1C2B(Y)
	JSL LongDrawJSR ; Draw graphics

 	PLY
 	PLX
	RTS

LaserShooterTiles:
	  ; Right, Up,    Left,  Down
	DW $80E7, $80E5, $84E7, $88E5

ReverseDirection:
	DW $0004, $0006, $0000, $0002


VRAMoffset: ; Offset of table 16? VRAM address?
	DW $3E00
	DW $3E80 
	DW $3F00 
	DW $3F80 

GFXTableOffset: ; GFX Tile ID offset
	DW $03E0 
	DW $03E8 
	DW $03F0 
	DW $03F8 

LaserGFX:
	incbin ROMProject/Graphics/LaserGFX.GFX


; A = TestCountValue
; Y = Origin
SearchTriggerPLM:
	STA $12
	TYA
	LDX #$004E      

SearchTriggerPLMNext:
	CMP $1C87,X
	BNE SearchNoPLMFound  
	LDA $1C37,X
	CMP #$FE98
	BEQ SearchTriggerPLMFound
	TYA
SearchNoPLMFound:
	DEX                 
	DEX               
	BPL SearchTriggerPLMNext
	RTS

SearchTriggerPLMFound:
	TYA
	JSR CountLaser
	CMP $12
	BNE SearchTriggerPLMEnd
	INC $1D77,X
SearchTriggerPLMEnd:
	RTS                  

; A = Origin
CountLaser:
	PHX
	PHY
	STA $00
	STZ $02
	LDY #$0006

CountNext:
	LDA $00
	JSR ScanLaser
	DEY
	DEY
	BPL CountNext

	LDA $02
	PLY
	PLX
	RTS

; Y = Direction
; A = Origin
; INC $02 if laser detected
ScanLaser:
	TYX
	JSR (MoveDirection,X)
	LDA $7F0002,X 
	STA $10

	CMP !crossLaser
	BNE ScanNotIntersectLaser
	INC $02
	RTS
ScanNotIntersectLaser:	
	LDA $10 	
	AND #$00FF
	CMP !mirrorLitTile&#$00FF
	BNE ScanNotMirror
ScanMirror:
	LDA $11 	
	AND #$000C
	LSR
	LSR
	CLC
	ADC MirrorTable,Y
	TAX
	LDA $0000,X
	AND #$00FF
	CMP #$00FF ; SEC if equal, CLC if not equal
	BEQ ScanEnd
	INC $02
	RTS
ScanNotMirror:
	LDA $10 	
	CMP LaserTileDirection,Y ; SEC if equal, CLC if not equal
	BNE ScanEnd
	INC $02
ScanEnd:
	RTS



TestOffTrigger_long:
	LDA $1DC7,X
	BPL TriggerCode_long
	AND #$00FF
	ASL
	STA $00
	LDA #$004E
	SEC
	SBC $00
	PHX
	TAX ; Load triggered PLM
	LDA $1D77,X
	BNE TriggerCodeEnd
	PLX : PHX
	STA $1D77,X
	BRA TriggerCodeBreak

TriggerCode_long:
	PHX
	LDA $1D77,X
	BEQ TriggerCodeEnd

	LDA $1DC7,X
	AND #$00FF
	ASL
	STA $00
	LDA #$004E
	SEC
	SBC $00
	TAX ; Load triggered PLM

	LDA $1D77,X
	BNE TriggerCodeEnd
	INC $1D77,X
	PLX
	PHX
	DEC $1D77,X
TriggerCodeBreak:
	TYA
	BIT $1DC7,X
	BVC +
	LDA #TriggerPLMOff_Perma
+
	STA $1D27,X ; Update instruction addr

TriggerCodeEnd:
	PLX
	RTL
