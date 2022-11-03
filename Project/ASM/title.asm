lorom


;;; $9A22: Game state 1 - Opening ;;;
org $8B9A22 
	PHP
	PHB
	PHK                    ;\
	PLB                    ;} DB = $8B
	REP #$30
	PEA.w CinematicFuncReturn-1
	JMP ($1F51)            ;} Execute [cinematic function]
CinematicFuncReturn:
	JSR DrawStar
	JSR $93EF              ; Handle cinematic sprite objects
;	JSR $951D              ; Handle mode 7 objects (baby Metroid)
	JSL $8DC527            ; Palette FX object handler
	JSR $9746              ; Draw cinematic sprite objects
	JSR $9A48              ; Code suggests it handles button input to skip to title screen, but in practice, it has no effect
	JSR $9A6C              ; Code suggests it handles transitions
;	JSR $8518              ; Handle mode 7 transformation matrix - no rotation
	PLB
	PLP
	RTL


; on button press trigger skip to title plate screen
org $8B9A48
;$8B:9A48 AD 51 1F    LDA $1F51    ;\
;$8B:9A4B C9 28 9F    CMP #$9F28   ;} If [cinematic function] >= $9F28: return
;$8B:9A4E 10 1B       BPL $1B      ;/
	LDA $7F4902
	BMI +
	LDA $8F      ;\
	BIT #$9080   ;} If not newly pressed A, B or start: return
	BEQ $14      ;/
	LDA $1A53  
	BNE +   
	LDA #$0001
	STA $1A53  
	STZ $0723  
	LDA #$0002
	STA $0725  
+
	RTS


; transition: jump to title plate screen
org $8B9A9C
	JSL InitGraphics
	SEP #$30
	LDA #$01
	STA $7F5004
	REP #$30
	LDA #$0000
	STA $7F4900
	LDA #$7FFF
	STA $7F4902
	LDA #$0000
	STA $7F4904
	LDA #$0800
	STA $7F4906

	JSR $93DA    ; Clear cinematic sprite objects
	LDY #$A119   ;\
	JSR $938A    ;} Spawn cinematic sprite object $A119
	LDY #$A125   ;\
	JSR $938A    ;} Spawn cinematic sprite object $A125

	LDA #$0002
	STA $0725  
	LDA #$0003
	STA $1A53

	RTS

warnpc $8B9B1A


;;; $9B68: Cinematic function - title sequence ;;;
org $8B9B68
	JSL $8B9B87            ; Load title sequence graphics
	LDA #$FF03             ;\
	JSL $808FC1            ;} Queue title sequence music data
	LDA #$9A47             ;\
	STA $1F51              ;} Cinematic function = RTS
	LDY #$A0EF             ;\
	JSR $938A              ;} Spawn cinematic sprite object $A0EF
	LDA #$0005             ;\
	JSL $808FC1            ;} Queue song 0 music track
	RTS


org $81FC40
InitPPULong:
	JSR $8DBA ; Map VRAM for menu
	RTL


;;; $9B87: Load title sequence graphics ;;;
; Called by:
;     $9B68
;     $82:85FB: Game state 2Ch (transition from demo)
org $8B9B87
	PHP
	PHB
	PHK
	PLB
	REP #$30
	JSR $8000  
	JSL InitPPULong
	JSL InitGraphics

	LDA #$9400             ;\
	STA $48                ;|
	LDA #$E000             ;|
	STA $47                ;} Decompress title BG tiles to $7F:0000
	JSL $80B0FF            ;|
		DL $7F0000         ;/
	LDA #$9500             ;\
	STA $48                ;|
	LDA #$80D8             ;|
	STA $47                ;} Decompress title sprite tiles to $7F:5000
	JSL $80B0FF            ;|
		DL $7F5000         ;/

	LDA #$000F
	LDX #$0FFE
-
	STA $7F4000,X
	DEX : DEX
	BPL -

	SEP #$30
	;dma bg gfx
	LDA #$00
	STA $2116  
	LDA #$00
	STA $2117  
	LDA #$80
	STA $2115  
	JSL $8091A9
		DB $01, $01, $18 : DL $7F0000 : DW $4000
	LDA #$02
	STA $420B  

	;dma sprite gfx
	LDA #$00
	STA $2116  
	LDA #$60
	STA $2117  
	LDA #$80
	STA $2115  
	JSL $8091A9
		DB $01, $01, $18 : DL $7F5000 : DW $4000
	LDA #$02
	STA $420B  

	;dma tilemaps
	LDA #$00
	STA $2116  
	LDA #$50
	STA $2117  
	LDA #$80
	STA $2115  
	JSL $8091A9
		DB $01, $01, $18 : DL $7F4000 : DW $1000
	LDA #$02
	STA $420B  

	;dma tilemaps
	LDA #$00
	STA $2116  
	LDA #$58
	STA $2117  
	LDA #$80
	STA $2115  
	JSL $8091A9
		DB $01, $01, $18 : DL $7F4000 : DW $0800
	LDA #$02
	STA $420B  

	JSL $80834B             ; enable NMI
	REP #$30
	STZ $0723               ; fade delay
	STZ $09A2

	JSR InitRNG
	JSL SpawnHaze
	PLB
	PLP
	RTL


InitGraphics:
	SEP #$20
	LDA #$01
	STA $55  
	LDA #$0F
	STA $51 
	LDA #$13
	STA $69
	LDA #$23
	STA $72

	LDA #$80
	STA $74
	LDA #$40
	STA $75
	LDA #$20
	STA $76

	REP #$20
	STZ $0723
	STZ $0725
	STZ $B1
	STZ $B5
	STZ $B9
	STZ $B3
	STZ $B7
	STZ $BB  

	REP #$30
	STZ $AB     
	STZ $A7     

	LDA #$0000
	STA $1982 

	LDX #$0000             ;\
-	                       ;|
	LDA $8CE1E9,x          ;|
	STA $7EC000,x          ;|
	LDA $8CE2E9,x          ;|
	STA $7EC100,x          ;|
	INX                    ;} Load title palettes
	INX                    ;|
	CPX #$0100             ;|
	BMI -                  ;/
	
	RTL

warnpc $8B9CBC


org $8BFA00
InitRNG:
	; clear star map
	LDX #$07FE
	LDA #$0000
-
	STA $7F4100,X
	DEX : DEX
	BPL -

	; init state
	LDA #$0000
	STA $7F4900
	STA $7F4902
	STA $7F4906
	LDA #$0100
	STA $7F4904

	; increment load counter in sram
	LDA $701FDE
	INC 
	STA $701FDE

	; calculate checksum
	LDA #$0000
	LDX #$1FFE
	CLC
-
	ADC $700000,X
	DEX : DEX
	BPL -

	; update rng (unless value == 0)
	CMP #$0000
	BEQ +
	STA $05E5
  	STA $1C21
+

	; initialize star map
	LDX #$00FC
-
	JSL $808111 ; rng
	AND #$07FE
	STA $7F4000,X
	JSL $808111 ; rng
	AND #$000E
	INC : INC
	STA $7F4002,X
	DEX : DEX : DEX : DEX
	BPL -

	RTS


FinalizeStar:
	PHP
	SEP #$30
	LDA #$80
	STA $2115
	REP #$30

	LDA #$0100
	STA $B3

	LDX #$00FC
-
	PHX
	LDA $7F4000,X
	PHA
	LSR
	CLC : ADC #$5800
	STA $2116

	LDA $7F4002,X
	PLX
	STA $7F4100,X
	TAX
	LDA StarTiles,X
	STA $2118 ; write value

	PLX
	DEX : DEX : DEX : DEX
	BPL -

	LDX $0330
	LDA #$1000-$00C0
	STA $D0,X
	LDA.w #BG1_Tiletable>>8
	STA $D3,X
	LDA.w #BG1_Tiletable+$00C0
	STA $D2,X
	LDA #$5000
	STA $D5,X
	TXA : CLC : ADC #$0007
	STA $0330

	PLP
	RTL


DrawStar:
	PHP

	REP #$30

	LDA $7F4902
	BMI ++
	CMP #$7FFF
	BNE +
	JSL FinalizeStar
	LDA #$FFFE
+
	INC 
	STA $7F4902

	CMP #$0128
	BNE +
	LDY #$A0F5             ;\
	JSR $938A              ;} Spawn cinematic sprite object $A0EF
	BRA ++
+
	CMP #$0250
	BNE +
	LDY #$A0FB             ;\
	JSR $938A              ;} Spawn cinematic sprite object $A0EF
	BRA ++
+
	CMP #$0378
	BNE +
	LDY #$A101             ;\
	JSR $938A              ;} Spawn cinematic sprite object $A0EF
	BRA ++
+
	CMP #$0600
	BNE +
	LDA #$FFFF
	STA $7F4902
	LDY #$A107             ;\
	JSR $938A              ;} Spawn cinematic sprite object $A0EF
+
++

	LDA $7F4900
	INC
	STA $7F4900
	BIT #$0001 
	BEQ +
	JMP .return
+

	BIT #$000F 
	BNE +
	SEP #$30
	LDA $7F5004
	DEC
	BEQ +
	STA $7F5004
+

	SEP #$30
	LDA #$80
	STA $2115
	REP #$30

	LDA $7F4900
	BIT #$0003
	BNE +
	LDA $B1
	INC : AND #$01FF
	STA $B1
+

	LDA $7F4904
	BEQ +
	DEC
	STA $7F4904
	BRA ++
+
	LDA $7F4900
	BIT #$0003
	BNE ++
	LDA $7F4906
	CMP #$0800
	BPL ++

	LDA $B3
	INC
	AND #$00FF
	STA $B3
	AND #$0007
	BNE ++

	JSR DMARow
++

	JSL $808111 ; rng
	AND #$00FC
	TAX
	LDA $7F4000,X
	PHA
	LSR
	CLC : ADC #$5800
	STA $2116

	LDA $7F4002,X
	STA $00
	PLX

	JSL $808111 ; rng
	AND #$0007
	BEQ .decrement

	LDA $7F4100,X
	CMP $00
	BPL .return
	INC : INC
	STA $7F4100,X
	TAX
	BRA .draw

.decrement
	LDA $7F4100,X
	BEQ .return
	DEC : DEC
	STA $7F4100,X
	TAX
	BRA .draw

.draw
	LDA StarTiles,X
	STA $2118 ; write value
.return
	PLP
	RTS

StarTiles:
	DW $0000, $0001, $0002, $0002, $0003, $0003, $0004, $0005, $0006


DMARow:
	LDX $0330
	LDA #$0040
	STA $D0,X
	STA $D7,X
	LDA.w #BG1_Tiletable>>8
	STA $D3,X
	STA $DA,X
	LDA $7F4906
	CLC : ADC.w #BG1_Tiletable
	STA $D2,X
	CLC : ADC.w #$0800
	STA $D9,X

	LDA $B3
	CLC : ADC #$00E0
	AND #$00F8
	ASL : ASL
	CLC : ADC #$5000
	STA $D5,X
	CLC : ADC #$0400
	STA $DC,X
	TXA : CLC : ADC #$000E
	STA $0330
	LDA $7F4906
	CLC : ADC #$0040
	STA $7F4906
	RTS

warnpc $8C0000


org $88FB50
SpawnHaze:
	JSL $8DC4D8 ; clear palette fx
	LDY #$E1B8
	JSL $8DC4E9 ; spawn palette fx
	JSL $8DC4C2 ; enable palette fx

	; load hdma table
	LDX #$0000
-
	LDA HazeTable,X
	STA $7F5000,X
	BEQ +
	INX : INX
	BRA -
+

	JSL $8882AC ; delete hdma objects
	JSL $888435                    ;\
		DB $00, $32 : DW #HazeInst ;} Spawn HDMA object for colour math subscreen backdrop colour with instruction list $DD62
	JSL $888288 ; enable hdma obj
	RTL

HazeInst:
	DW $8655 : DB $7F ; hdma table bank
	DW $866A : DB $88 ; indirect hdma data bank
HazeInst_Loop:
	DW $7777, $5000
	DW $85EC, #HazeInst_Loop

HazeTable:
	DB $70, $60
	DB $14, $60
	DB $5E, $60
	DB $10, $61
	DB $0F, $62
	DB $0E, $63
	DB $0C, $64
	DB $0A, $65
	DB $08, $66
	DB $06, $67
	DB $04, $68
	DB $02, $69
	DB $02, $6A
	DB $02, $6B
	DB $02, $6C
	DB $02, $6D
	DB $02, $6E
	DB $02, $6F
	DB $00, $00


org $80E000 ; ???
BG1_Tiletable:
	incbin ROMProject/Graphics/title_bg1.ttb

org $94E000
	incbin ROMProject/Graphics/title_bg.gfx

org $8CE1E9
	DW $0000, $373F, $2E9E, $2E3B, $25D8, $1D33, $14AE, $144A, $0803, $7DFF, $6819, $4C11, $340A, $2004, $1403, $0000
	DW $5149, $0441, $0843, $0C64, $0C87, $10AA, $14F0, $14C6, $2108, $31AD, $3A52, $4B18, $0000, $0000, $0C00, $0C63
org $8CE2A9
	DW $108A, $0421, $0020, $0040, $00A0, $0942, $19C6, $0C63, $18C6, $2D29, $41CD, $5652, $6718, $001C, $001D, $0060
org $8CE37B
	DW $7FFF

