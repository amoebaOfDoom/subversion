lorom

!LoadedTiles    = $7EFB00
!PosPrev        = $7EFB20
!PauseTileID    = $7EFB22
!PauseTileVRAM  = $7EFB24
!TileGFX        = $7EFB30 ; 0x100 bytes
!TileGFX4bpp    = $7EFC30 ; 0x20 bytes

!MapColors   = $7EFF00 ; 0x8 bytes
!CenterTile  = $7EFF40

!HUD_VOffset2 = $7EFF10 ; 4 bytes

org $809AF3
	; don't init minimap on load
	JSL ClearMinimapData
	;JSL $90A8EF

org $809616
	DW #IRQ_Nothing, $9680, $968B, #IRQ_HUD_END_NORMAL
	DW $96D3, #IRQ_HUD_END_DOOR_START, $971A, #IRQ_HUD_END_DRAYGON
	DW $9758, #IRQ_HUD_END_DOOR_V, $97A9, $97C1
	DW #IRQ_HUD_END_DOOR_H, $980A
org $80966E
	DW #IRQ_Main_HUD_FBlank      ; IRQ Handler 58 - main gameplay - f-blank HUD drawing
	DW #IRQ_DoorStart_HUD_FBlank ; IRQ Handler 5A - start of door transition - f-blank HUD drawing
	DW #IRQ_Draygon_HUD_FBlank   ; IRQ Handler 5C - Draygon's room - f-blank HUD drawing
	DW #IRQ_DoorV_HUD_FBlank     ; IRQ Handler 5E - vertical door transition - f-blank HUD drawing
	DW #IRQ_DoorH_HUD_FBlank     ; IRQ Handler 60 - horizontal door transition - f-blank HUD drawing

org $88D8CA
; hud hdma table, line 30
	DW !HUD_VOffset2

org $80969F
	JSR IRQ_HUD_Start
	LDX #$0098             ; IRQ h-counter target = 98h
	LDA #$0058             ; Interrupt command = 6

org $8096E7
	JSR IRQ_HUD_Start
	LDX #$0098             ; IRQ h-counter target = 98h
	LDA #$005A             ; Interrupt command = Ah
	
org $809729
	JSR IRQ_HUD_Start
	LDX #$0098             ; IRQ h-counter target = 98h
	LDA #$005C             ; Interrupt command = Eh
	
org $809767
	JSR IRQ_HUD_Start
	LDX #$0098             ; IRQ h-counter target = 98h
	LDA #$005E             ; Interrupt command = 12h
	
org $8097D0
	JSR IRQ_HUD_Start
	LDX #$0098             ; IRQ h-counter target = 98h
	LDA #$0060             ; Interrupt command = 18h

org $888331
	JSL SetHudScroll
	LDA #$0000
	STA $7ECAD8


org $80D380
SetHudScroll:
	LDA #$0000
	STA !HUD_VOffset2+0
	LDA #$01E2
	STA !HUD_VOffset2+2
	LDA #$0002
	STA $7ECADA
	RTL


IRQ_Nothing: ;repointed for space
	LDA $A7       ; Interrupt command = [next interrupt command]
	BEQ $04       
	STZ $A7       ; Next interrupt command = 0
	BRA $03       

	LDA #$0000

	LDX #$0000    ; IRQ h-counter target = 0
	LDY #$0000    ; IRQ v-counter target = 0
	RTS


IRQ_HUD_Start:
	SEP #$20

	; main screen = None
	STZ $212C

	LDA $51
	ORA #$80 ; Enable forced blank
	STA $2100

	; set v-scroll
	LDA #$02
	STA $2112
	STZ $2112

	; palette 2, color 1
	LDA #$09
	STA $2121
	LDA $7EC012
	STA $2122
	LDA $7EC013
	STA $2122

	; palette 2, color 3
	LDA #$0B
	STA $2121
	LDA $7EC016
	STA $2122
	LDA $7EC017
	STA $2122

	; palette 3, color 1
	LDA #$0D
	STA $2121
	LDA $7EC01A
	STA $2122
	LDA $7EC01B
	STA $2122

	; palette 3, color 3
	LDA #$0F
	STA $2121
	LDA $7EC01E
	STA $2122
	LDA $7EC01F
	STA $2122

	LDA $51 ; Disable forced blank
	STA $2100

	NOP : NOP : NOP : NOP : NOP : NOP : NOP : NOP
	NOP : NOP

	; enable main screen = bg3
	LDA #$04
	STA $212C

	REP #$20
	LDY #$001D             ; IRQ v-counter target = 1Fh
	RTS


IRQ_Main_HUD_FBlank:
	PEA.w $0006
	BRA IRQ_HUD_FBlank
IRQ_DoorStart_HUD_FBlank:
	PEA.w $000A
	BRA IRQ_HUD_FBlank
IRQ_Draygon_HUD_FBlank:
	PEA.w $000E
	BRA IRQ_HUD_FBlank
IRQ_DoorV_HUD_FBlank:
	PEA.w $0012
	BRA IRQ_HUD_FBlank
IRQ_DoorH_HUD_FBlank:
	PEA.w $0018
IRQ_HUD_FBlank:
	SEP #$20

	; main screen = None
	STZ $212C

	LDA $51
	ORA #$80 ; Enable forced blank
	STA $2100

	; palette 2, color 1 = 48FB
	LDA #$09
	STA $2121
	LDA #$FB
	STA $2122
	LDA #$48
	STA $2122

	; palette 2, color 3 = 0000
	LDA #$0B
	STA $2121
	STZ $2122
	STZ $2122

	; palette 3, color 1 = 6965
	LDA #$0D
	STA $2121
	LDA #$65
	STA $2122
	LDA #$69
	STA $2122

	; palette 3, color 3 = 0000
	LDA #$0F
	STA $2121
	STZ $2122
	STZ $2122

	; set v-scroll
	LDA #$E2
	STA $2112
	LDA #$01
	STA $2112

	LDA $51 ; Disable forced blank
	STA $2100

	NOP : NOP : NOP : NOP : NOP : NOP : NOP : NOP
	NOP : NOP

	; enable main screen = bg3
	LDA #$04
	STA $212C

	REP #$20
	LDY #$001F             ; IRQ v-counter target = 1Fh
	LDX #$0068             ; IRQ h-counter target = 98h
	PLA
	RTS

IRQ_HUD_END_NORMAL:
	SEP #$20
	STZ $212C

	LDA $BB
	STA $2112
	LDA $BC
	STA $2112

	LDA $70
	STA $2130
	LDA $5B
	STA $2109

	LDA $73
	STA $2131
	LDA $6A
	STA $212C

	REP #$20
	LDA $A7
	BEQ +
	STZ $A7
	BRA ++
+
	LDA #$0004
	LDY #$0000
	LDX #$0098
++
	RTS

IRQ_HUD_END_DOOR_START:
	SEP #$20
	STZ $212C

	LDA $BB
	STA $2112
	LDA $BC
	STA $2112

	LDA $07B3
	ORA $07B1
	BIT #$01
	BEQ +
	LDA #$10
	BRA ++
+
	LDA #$11
++
	STA $212C

	REP #$20
	LDA $A7
	BEQ +
	STZ $A7
	BRA ++
+
	LDA #$0008
	LDY #$0000
	LDX #$0098
++
	RTS

IRQ_HUD_END_DRAYGON:
	SEP #$20
	STZ $212C

	LDA $BB
	STA $2112
	LDA $BC
	STA $2112

	LDA $5B
	STA $2109
	LDA $70
	STA $2130

	LDA $73
	STA $2131

	REP #$20
	LDA $A7
	BEQ +
	STZ $A7
	BRA ++
+
	LDA #$000C
	LDY #$0000
	LDX #$0098
++
	RTS

IRQ_HUD_END_DOOR_V:
	SEP #$20
	STZ $212C

	LDA $BB
	STA $2112
	LDA $BC
	STA $2112

	STZ $2130
	STZ $2131

	LDA $07B3
	ORA $07B1
	BIT #$01
	BEQ +
	LDA #$10
	BRA ++
+
	LDA #$11
++
	STA $212C

	REP #$20
	LDA $05BC
	BPL +
	JSR $9632
+
	LDA $0931
	BMI +
	JSL $80AE4E
+
	LDA #$0014
	LDY #$00D8
	LDX #$0098
	RTS

IRQ_HUD_END_DOOR_H:
	SEP #$20
	STZ $212C

	LDA $BB
	STA $2112
	LDA $BC
	STA $2112

	STZ $2130
	STZ $2131

	LDA $07B3
	ORA $07B1
	BIT #$01
	BEQ +
	LDA #$10
	BRA ++
+
	LDA #$11
++
	STA $212C

	REP #$20
	LDA $0931
	BMI +
	JSL $80AE4E
+
	LDA #$001A
	LDY #$00B8 ;#$00A0
	LDX #$0098
	RTS


ClearMinimapData:
	PHX
	LDA #$0000

	LDX #$001E
-
	STA !LoadedTiles,X
	DEX : DEX
	BPL -

	STA !PosPrev
	STA !MapColors
	STA !MapColors+2
	STA !MapColors+4
	STA !MapColors+6
	STA !CenterTile
	PLX
	RTL


org $8582D4
	LDX #$003E ;#$0000

org $8581B2
	JSR MessageBoxHUD
	;JSR $8136 ; Wait for lag frame

org $8596D0
MessageBoxHUD:
	LDX #$0038
	LDA #$0002
-
	STA $7E3000,X
	DEX
	DEX
	BPL -

	LDA #$01E2
	STA $7E303A
	STA $7E303C

	;displaced code
	JSR $8136 ; Wait for lag frame
	RTS


org $90A8EF
GetMapCorner:
	DEC : DEC        ; two columns left
    SEC : SBC #$0020 ; one row up
    AND #$FBFF
	STA $04  ;/

	LDA $16
	DEC
	XBA
	STA $16
	LDA $12
	ORA $22
	DEC : DEC
	ORA $16
	STA $16

; get area tilemap pointer
	LDA $079F
	ASL A        
	CLC          
	ADC $079F
	TAX
	RTS

warnpc $90A91B


;;; $AA43: Update HUD mini-map tilemap ;;;
{
;; Parameters:
;;     $12: Samus map X co-ordinate ([room X co-ordinate] + [Samus X position] / 100h) &1Fh
;;     $16: Index of Samus map row ([room Y co-ordinate] + [Samus Y position] / 100h + 1)
;;     $18: Explored row 0 map bits (([$07F7 + [$32/$30]]     << 8 | [$07F7 + [$32/$30] + 1]) << [$34] / 2 & FC00h)
;;     $1A: Explored row 1 map bits (([$07F7 + [$32/$30] + 4] << 8 | [$07F7 + [$32/$30] + 5]) << [$34] / 2 & FC00h)
;;     $1C: Explored row 2 map bits (([$07F7 + [$32/$30] + 8] << 8 | [$07F7 + [$32/$30] + 9]) << [$34] / 2 & FC00h)
;;     $22: Map page of Samus position ([room X co-ordinate] + [Samus X position] / 100h) & 20h
;;     $26: Row 0 map bits ([[$09]] << 8     | [[$09] + 1]) << [$34] / 2
;;     $28: Row 1 map bits ([[$09] + 4] << 8 | [[$09] + 5]) << [$34] / 2
;;     $2A: Row 2 map bits ([[$09] + 8] << 8 | [[$09] + 9]) << [$34] / 2
org $90AA43
	PHB : PHK : PLB
	LDA $16    ;\
	CLC        ;|
	ADC $22    ;|
	XBA        ;|
	LSR A      ;|
	LSR A      ;} $060B = ([$16] + [$22]) * 20h + [$12] (bit index of Samus map co-ordinate)
	LSR A      ;|
	CLC        ;|
	ADC $12    ;|
	STA $060B

	CMP !PosPrev
	BNE +
	JMP LoadMinimap_return
+
	STA !PosPrev
	JSR GetMapCorner
	BRA LoadMapTable

warnpc $90AA7C
org $90AA7C
LoadMapTable:
;$90:AA7C BF 4C 96 82 LDA $82964C,x
	LDA $82964C,x ; needs to be at this location for smart repoint
	STA $02
	NOP : NOP : NOP : NOP
;$90:AA86 BF 4A 96 82 LDA $82964A,x
	LDA $82964A,x ; needs to be at this location for smart repoint
	STA $00

.init_minimap_color
	LDX #$0006
	LDA #$0000
-
	STA !MapColors,X
	DEX
	DEX
	BPL -

.init_loop
	LDA #$0003
	STA $14 ; row remaining
	LDX #$0000  ; X = 0 (HUD mini-map tilemap index)

.rowloop
	PHX
	LDA #$0003
	SEC : SBC $14
	ASL
	TAX
	LDA $18,X
	STA $06
	LDA $26,X
	STA $08
	PLX

	LDA #$0005
	STA $12 ; column remaining

.columnloop
	LDA $16
	AND #$001F
	STA $04
	LDA $16
	AND #$1F00
	LSR
	LSR
	LSR
	ORA $04
	STA $04
	LDA $16
	AND #$0020
	XBA
	LSR
	LSR
	LSR
	ORA $04
;	BEQ +
;	LDA #$0400
;+
;	ORA $04
  	ASL : TAY
  	LDA #$3C1F ; blank tile

  	ASL $06
  	BCC +
  	ASL $08
  	LDA [$00],Y
  	JSL MinimapColor
  	BRA .writetile
+  
  	ASL $08
  	BCC .writetile
  	LDA [$00],Y
  	AND #$E3FF
  	ORA #$3C00
  
.writetile
  	JSL LoadTile
  	STA $7EC63C,X
  	INX : INX

  	INC $16
  	;INC $04
  	DEC $12
  	BNE .columnloop

  	;LDA $04
  	;CLC : ADC #$0020-5
  	;STA $04

  	LDA $16
  	CLC : ADC #$0100-5
  	STA $16

  	TXA
  	CLC : ADC #$0040-10
  	TAX

  	DEC $14
  	BNE .rowloop

	JSL FinalizeLoadedTiles
	JSL LoadCenterTile

LoadMinimap_return:
	LDA $05B5   ;\
	AND #$0008  ;} If [frame counter] & 8 = 0:
	PHP
	LDA !CenterTile
	PLP
	BNE +
	AND #$FF00
	ORA #$0070
+
	STA $7EC680

	PLB : PLP : RTL


padbyte #$00
pad $90AB5E
warnpc $90AB5F

org $82E46C 
	;LDA $078D 
	;CMP #$947A
	;BEQ $1E   
	NOP : NOP : NOP : NOP
	NOP : NOP : NOP : NOP
org $82E488
	;JSR $E039
	;dx 9AB200, 4000, 1000
	JSL ReloadTiles_door
	NOP : NOP : NOP : NOP : NOP : NOP


org $828300
	;LDA #$02 
	;STA $420B
	JSL ReloadTiles
	NOP

org $828ED3
	;LDA #$02 
	;STA $420B
	JSL ReloadTiles
	NOP

org $81909B
	;LDA #$02 
	;STA $420B
	JSL ReloadTiles
	NOP

org $A7C246
	;LDA #$02 
	;STA $420B
	JSL ReloadTiles
	NOP


org $829006 ; Don't reload first palette when pausing
	JMP LoadPauseMiniColors

org $82E4A5:
	JSR ReloadMinimapColors

org $82F70F:
LoadPauseMiniColors:
	LDA $7EC212
    STA $7EC012
	LDA $7EC216
    STA $7EC016
    LDA $7EC21A
    STA $7EC01A
    LDA $7EC21E
    STA $7EC01E
	PLP : PLP : RTS

ReloadMinimapColors:
	STA $099C
	JSL ReloadMinimapColors_long
	RTS

LoadPauseMapGraphics:
	JSR $943D
	JSL CheckItemIcons
	RTS


org $82E1F1
	JSL ReloadMinimapColors_long
	NOP : NOP
	;LDA $C012 : STA $C212

org $82E1FD
	LDA $C03C  ;\
	STA $C23C  ;} Target BG3 palette 7 colour 2 = [BG3 palette 7 colour 2]
	;LDA $C01A ;\
	;STA $C21A ;} Target BG3 palette 3 colour 1 = [BG3 palette 3 colour 1]


org $82C3B4 : DW $2086
org $82C3BB : DW $2087


org $8293E2
	JSR LoadPauseMapGraphics ;JSR $943D


org $9BD500
CheckItemIcons:
	PHP : REP #$30
	PHB : PHK : PLB : PHA : PHX : PHY

	LDA #$0070
	STA !PauseTileID
	LDA #$0700
	STA !PauseTileVRAM


	LDA $079F : ASL A : TAX : LDA ItemAreaTable,X : TAX
	;LDA #$0E00 : STA $03
.itemloop
	LDA $0000,X : BPL + : JMP .return ; break on FFFF
+	

		PHX 
		LDA $0004,X
		BEQ +
		JSL $80818E
		LDA $7ED870,X : BIT $05E7
		BNE .continue ; test if alternate collected
+

		PLX : PHX 
		LDA $0000,X
		JSL $80818E
		LDA $7ED870,X : BIT $05E7
		BEQ .not_collected ; test if collected
		
		.collected
			PLX : PHX

			JSR GetTilemapIndex
			LDA $7E4000,X
			AND #$03EE
			CMP #$000E ; blank tiles: 0x000E, 0x000F, 0x001E, 0x001F
			BEQ .continue

			JSR LoadTile4bpp
			PLX : PHX
			LDA $0006,X
			BEQ +
			JSR DrawTilePlus
			BRA ++
+
			JSR DrawTileDot
++
			JSR DMATile4bpp

			BRA .continue

		.not_collected
			PLX : PHX

			LDA #$003F ; scanner room event
			JSL $808233
			BCS +
		    ; check easy mode + major
		    LDA #$003A ;easy mode
		    JSL $808233
		    BCC .continue
			LDA $0006,X
			BEQ .continue
+

			JSR GetTilemapIndex
			JSR LoadTile4bpp
			JSR DrawTileCircle
			JSR DMATile4bpp
.continue	    
		PLA : CLC : ADC #$0008 : TAX
	JMP .itemloop
.return 
	PLY : PLX : PLA : PLB : PLP 

	; restore dma channels
	LDA #$00
	STA $2116
	LDA #$30
	STA $2117
	LDA #$80
	STA $2115
	RTL

GetTilemapIndex:
	; 00 = tilemap index
	; 0000xyyy yyxxxxx0
	LDA $0002,X : AND #$001F ; X pos
		ASL : STA $00
	LDA $0001,X : AND #$2000 ; X pos page
		LSR : LSR : ORA $00 : STA $00
	LDA $0002,X : AND #$1F00 ; Y pos
		LSR : LSR : ORA $00 : STA $00
	LDX $00
	RTS


GetCircleTile:
	PHB : PHK : PLB
	PHA
	
	LDA $079F : ASL : TAX
	LDA.w ItemAreaTable,X : TAX
-
	LDA $0000,X
	BMI .blank
	LDA $0002,X
	CMP $16
	BEQ ++
	TXA : CLC : ADC #$0008 : TAX
	BRA -

++
    ; check alternate location collected
	LDA $0004,X
	BEQ +
	PHX
	JSL $80818E
	LDA $7ED870,X
	PLX
	BIT $05E7
	BNE .blank

+
    ; check collected
	LDA $0000,X
	AND #$00FF
	PHX
	JSL $80818E
	LDA $7ED870,X
	PLX
	BIT $05E7
	BEQ .circle
.dot
	PLA : PHA
	AND #$03EE
	CMP #$000E ; blank tiles: 0x000E, 0x000F, 0x001E, 0x001F
	BEQ .blank

	LDA $0006,X
	BEQ +
	LDA #$0800
	BRA ++
+
	LDA #$0400
++
	BRA .return
.circle
    ; check item scanner
	LDA #$003F
	JSL $808233
	BCS +
    ; check easy mode + major
    LDA #$003A ;easy mode
    JSL $808233
    BCC .blank
	LDA $0006,X
	BEQ .blank
+
	LDA #$0200
	BRA .return
.blank
	LDA #$0000

.return
	STA $24
	PLA
	AND #$01FF
	ORA $24
	PLB : RTL


MinimapColor:
	PHB : PHK : PLB
	PHX : PHA
	XBA : LSR
	AND #$000E
	BNE .findColor

.blank
	LDX #$0000
	BRA .setColor

.findColor
	TAX
	LDA ColorIndexTable,X

	LDX #$0000
-
	CMP !MapColors,X
	BEQ .setColor
	INX : INX
	CPX #$0008
	BNE -

.newColor
	PHA
	LDX #$0000
-
	LDA !MapColors,X
	BEQ +
	INX : INX
	CPX #$0006
	BNE -
+
	PLA
	STA !MapColors,X

.setColor
	PLA
	AND #$E0FF
	ORA SetColorTable,X
	PLX
	PLB
	RTL


SetColorTable:
	DW $2800, $2C00, $2900, $2D00
ColorIndexTable:
	DW $0000, $0000, $211F, $6965, $26AA, $027B, $58DA, $2108


FinalizeLoadedTiles:
	LDA !MapColors+0
    STA $7EC012
    STA $7EC212
	LDA !MapColors+2
    STA $7EC01A
    STA $7EC21A
	LDA !MapColors+4
    STA $7EC016
    STA $7EC216
	LDA !MapColors+6
    STA $7EC01E
    STA $7EC21E

  	LDA $09A2 ; equipment
    BIT #$0800 ; thermal
    BEQ .garbageCollection
    LDA #%0000000000010110
    STA $7EC012
    LDA #%0000000000001110
    STA $7EC01A
    LDA #%0000000000000000
    STA $7EC016
    LDA #%0000000000000000
    STA $7EC01E

.garbageCollection
	LDX #$001E
-
	LDA !LoadedTiles,X
	AND #$7FFF
	BIT #$4000
	BEQ +
	ORA #$8000
+
	AND #$BFFF
	STA !LoadedTiles,X
	DEX : DEX
	BPL -
	RTL


print pc
LoadTile:
	PHB : PHK : PLB
	PHX : PHY
	PHA
	JSL GetCircleTile

	BIT #$0F00 
	BNE +
	PLA
	JMP .return
+

	; Search for matching loaded tile
	STA $24
	LDX #$001E
-
	LDA !LoadedTiles,X
	AND #$0FFF
	CMP $24
	BNE +
	JMP .flag_tile
+

	DEX : DEX
	BPL -

.new_tile
	; Get first empty index
	LDX #$001E
-
	LDA !LoadedTiles,X
	BIT #$C000
	BEQ +
	DEX : DEX
	BPL -
	BNE +
	LDX #$0002 ; don't use the first slot
+
	
.load_tile
	PHX
	TXA
	ASL : ASL : ASL
	TAX
	PHX

	PHB
	LDA $24
	AND #$00FF
	ASL : ASL : ASL : ASL
	TAY
	PEA $9A00 : PLB : PLB
-
	LDA $B200,Y
	STA !TileGFX,X
	INX : INX
	INY : INY
	TXA : AND #$000F
	BNE -
	PLB

.modify_tile
	DEX : DEX
	LDY #$000E
	LDA $24

.modify_color
	BIT #$0100
	BEQ .modify_circle
	PHA : PHX : PHY
	PEA $0007
--
	LDY #$000E
-
	LDA !TileGFX,X
	AND ColorMask,Y
	CMP ColorTest,Y
	BNE +
	LDA !TileGFX,X
	ORA ColorMask,Y
	STA !TileGFX,X
+
	DEY : DEY
	BPL -

	DEX : DEX
	PLY : DEY : PHY
	BPL --
	PLY
	PLY : PLX : PLA

.modify_circle
	BIT #$0200
	BEQ .modify_dot
	PHA : PHX : PHY
-
	LDA !TileGFX,X
	AND.w CircleTileMask,Y
	ORA.w CircleTile,Y
	STA !TileGFX,X
	DEX : DEX
	DEY : DEY
	BPL -
	PLY : PLX : PLA

.modify_dot
	BIT #$0400
	BEQ .modify_plus
	PHA : PHX : PHY
-
	LDA !TileGFX,X
	AND.w DotTileMask,Y
	ORA.w DotTile,Y
	STA !TileGFX,X
	DEX : DEX
	DEY : DEY
	BPL -
	PLY : PLX : PLA

.modify_plus
	BIT #$0800
	BEQ .dma_tile
	PHA : PHX : PHY
-
	LDA !TileGFX,X
	AND.w PlusTileMask,Y
	ORA.w PlusTile,Y
	STA !TileGFX,X
	DEX : DEX
	DEY : DEY
	BPL -
	PLY : PLX : PLA

.dma_tile
	PLA : PHA
	CLC : ADC.w #!TileGFX
    LDX $0330
    STA $D2,X ; wram address
    LDA #$0010 
    STA $D0,X ; size
    SEP #$20
    LDA #$7E  
    STA $D4,X ; wram bank
    REP #$20
	PLA
	LSR
    STA $D5,X
	LDA $5D
	AND #$0F00
	ASL : ASL : ASL : ASL
	CLC : ADC #$0380 ; vram address
	CLC : ADC $D5,X
	STA $D5,X
    TXA : CLC : ADC #$0007
    STA $0330
    PLX

.flag_tile
	; mark used
	LDA $24
	ORA #$4000
	STA !LoadedTiles,X

	PLA
	AND #$FC00
	STA $24
	TXA
	LSR
	CLC : ADC #$0070 ; tile offset
	ORA $24

.return
	PLY : PLX : PLB : RTL


LoadTile4bpp:
	LDA $7E4000,X

	PHA
	AND #$FC00
	ORA !PauseTileID
	STA $7E4000,X 
	LDA !PauseTileID
	INC
	STA !PauseTileID
	
	PLA
	AND #$03FF
	INC
	ASL : ASL : ASL : ASL : ASL
	DEC : DEC
	TAY
	LDX #$001E

	PHB : PEA $B600 : PLB : PLB
-
	LDA $8000,Y
	STA !TileGFX4bpp,X
	DEY : DEY
	DEX : DEX
	BPL -
	PLB
	RTS

DrawTileDot:
	LDX #$000E
-
	LDA !TileGFX4bpp,X
	AND.w DotTileMask,X
	ORA.w DotTile,X
	STA !TileGFX4bpp,X
	DEX : DEX
	BPL -
	RTS

DrawTilePlus:
	LDX #$000E
-
	LDA !TileGFX4bpp,X
	AND.w PlusTileMask,X
	ORA.w PlusTile,X
	STA !TileGFX4bpp,X
	DEX : DEX
	BPL -
	RTS

DrawTileCircle:
	LDX #$000E
-
	LDA !TileGFX4bpp,X
	AND.w CircleTileMask,X
	ORA.w CircleTile,X
	STA !TileGFX4bpp,X
	DEX : DEX
	BPL -
	RTS

DMATile4bpp:
	LDA !PauseTileVRAM
	STA $2116
	CLC : ADC #$0010
	STA !PauseTileVRAM

	PHP
	SEP #$20
	LDA #$80               ;|
	STA $2115              ;} VRAM $0000..1FFF = [$B6:8000..BFFF] (pause menu BG1/2 tiles)
	JSL $8091A9            ;|
	  DB $01, $01, $18 : DL !TileGFX4bpp : DW $0020
	LDA #$02               ;|
	STA $420B              ;/
	PLP

	RTS


ColorMask:
	DW $0101, $0202, $0404, $0808, $1010, $2020, $4040, $8080
ColorTest:
	DW $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080

CircleTileMask:
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%1110011111100111
	DW #%1101101111011011
	DW #%1101101111011011
	DW #%1110011111100111
	DW #%1111111111111111
	DW #%1111111111111111
CircleTile:
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%0001100000000000
	DW #%0010010000000000
	DW #%0010010000000000
	DW #%0001100000000000
	DW #%0000000000000000
	DW #%0000000000000000
DotTileMask:
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%1110011111100111
	DW #%1110011111100111
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%1111111111111111
DotTile:
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%0001100000000000
	DW #%0001100000000000
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%0000000000000000
PlusTileMask:
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%1110011111100111
	DW #%1100001111000011
	DW #%1100001111000011
	DW #%1110011111100111
	DW #%1111111111111111
	DW #%1111111111111111
PlusTile:
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%0001100000000000
	DW #%0011110000000000
	DW #%0011110000000000
	DW #%0001100000000000
	DW #%0000000000000000
	DW #%0000000000000000
SquareTileMask:
	DW #%0001100000011000
	DW #%0111111001111110
	DW #%0111111001111110
	DW #%1111111111111111
	DW #%1111111111111111
	DW #%0111111001111110
	DW #%0111111001111110
	DW #%0001100000011000
SquareTile:
	DW #%1110011100000000
	DW #%1000000100000000
	DW #%1000000100000000
	DW #%0000000000000000
	DW #%0000000000000000
	DW #%1000000100000000
	DW #%1000000100000000
	DW #%1110011100000000

LoadCenterTile:
print pc
	PHB : PHK : PLB
	PHX : PHY

	LDA $7EC680 ; center tile
	STA !CenterTile
	AND #$00FF
	CMP #$0070
	BMI .load_rom
	CMP #$0080
	BPL .load_rom

.load_ram
	SEC : SBC #$0070

	PHB
	INC
	ASL : ASL : ASL : ASL
	DEC : DEC
	TAY
	PEA $7E00 : PLB : PLB
	LDX #$000E
-
	LDA.w !TileGFX,Y
	STA.w !TileGFX,X
	DEY : DEY
	DEX : DEX
	BPL -
	PLB
	BRA .modify_square

.load_rom
	PHB
	INC
	ASL : ASL : ASL : ASL
	DEC : DEC
	TAY
	PEA $9A00 : PLB : PLB
	LDX #$000E
-
	LDA $B200,Y
	STA !TileGFX,X
	DEY : DEY
	DEX : DEX
	BPL -
	PLB

.modify_square
	LDX #$000E
-
	LDA !TileGFX,X
	AND.w SquareTileMask,X
	ORA.w SquareTile,X
	STA !TileGFX,X
	DEX : DEX
	BPL -

.dma_tile
    LDX $0330
    LDA #$0010 
    STA $D0,X ; size
    LDA #$7E00  
    STA $D3,X ; wram bank
    LDA.w #!TileGFX
    STA $D2,X ; wram address

	LDA $5D
	AND #$0F00
	ASL : ASL : ASL : ASL
	CLC : ADC #$0380 ; vram address
	STA $D5,X
    TXA : CLC : ADC #$0007
    STA $0330

	PLY : PLX : PLB : RTL


ItemAreaTable: 
	DW CrateriaItems, BrinstarItems, NorfairItems, WreckedShipItems
	DW MaridiaItems,  TourianItems,  CeresItems,   DebugItems


;rooms.SelectMany(
;room => statelist.SelectMany(
;state.plmlist.Where(isItem(@0)).Select(
;String.Format("[Area {0}] DW ${1:X4} : DB ${2:X2}, ${3:X2}",
;  room.area,
;  arg & 0xFF,
;  room.X + (X / 16), 
;  room.Y + (Y / 16) + 1
;)))).OrderBy(s => s).Distinct()

	;  ItemID,    X,  Y
CrateriaItems:
	DW $0000 : DB $22, $09 : DW $0000, $0000
	DW $0001 : DB $21, $06 : DW $0078, $0000
	DW $0002 : DB $22, $0B : DW $0000, $0001
	DW $0003 : DB $1C, $08 : DW $0000, $0000
	DW $0004 : DB $1A, $0C : DW $0000, $0000
	DW $0005 : DB $1B, $09 : DW $0000, $0000
	DW $0006 : DB $0E, $12 : DW $0000, $0001
	DW $0007 : DB $08, $0F : DW $0000, $0000
	DW $0008 : DB $0D, $0C : DW $0000, $0001
	DW $0009 : DB $0B, $0E : DW $0000, $0000
	DW $000A : DB $0B, $15 : DW $0000, $0000
	DW $000B : DB $0C, $16 : DW $0000, $0000
	DW $000C : DB $10, $12 : DW $0000, $0000
	DW $000D : DB $10, $16 : DW $0000, $0001
	DW $000E : DB $15, $11 : DW $0000, $0000
	DW $000F : DB $13, $11 : DW $0000, $0000
	DW $0010 : DB $18, $0E : DW $0000, $0000
	DW $006C : DB $19, $14 : DW $0000, $0000
	DW $006D : DB $1D, $07 : DW $0000, $0000
	DW $006F : DB $05, $15 : DW $0000, $0000
	DW $00C6 : DB $0A, $0F : DW $0000, $0000
	DW $FFFF
BrinstarItems:
	DW $0011 : DB $0B, $11 : DW $0000, $0001
	DW $0012 : DB $06, $0A : DW $0000, $0000
	DW $0013 : DB $08, $0A : DW $0000, $0001
	DW $0014 : DB $10, $0B : DW $0000, $0000
	DW $0015 : DB $10, $0D : DW $0000, $0000
	DW $0016 : DB $13, $09 : DW $0000, $0000
	DW $0017 : DB $12, $08 : DW $0000, $0000
	DW $0018 : DB $12, $09 : DW $0000, $0000
	DW $0019 : DB $03, $0E : DW $0000, $0000
	DW $001A : DB $07, $0F : DW $0000, $0000
	DW $001B : DB $03, $10 : DW $0000, $0000
	DW $001C : DB $0C, $0A : DW $0000, $0000
	DW $001D : DB $10, $08 : DW $0000, $0001
	DW $001E : DB $0C, $0D : DW $0000, $0000
	DW $001F : DB $08, $0C : DW $0000, $0000
	DW $0020 : DB $09, $08 : DW $0000, $0001
	DW $0021 : DB $06, $08 : DW $0000, $0000
	DW $0022 : DB $07, $09 : DW $0000, $0000
	DW $0023 : DB $07, $0A : DW $0000, $0000
	DW $0024 : DB $15, $0C : DW $0000, $0000
	DW $0025 : DB $17, $10 : DW $0000, $0000
	DW $0026 : DB $07, $13 : DW $0000, $0001
	DW $0027 : DB $0A, $17 : DW $0000, $0000
	DW $0028 : DB $11, $12 : DW $0000, $0000
	DW $0029 : DB $0F, $17 : DW $0000, $0000
	DW $002A : DB $1C, $11 : DW $0000, $0000
	DW $002B : DB $18, $0A : DW $0000, $0000
	DW $002C : DB $0A, $03 : DW $0000, $0000
	DW $FFFF
NorfairItems:
	DW $002D : DB $10, $19 : DW $0000, $0000
	DW $002E : DB $14, $1C : DW $0000, $0001
	DW $002F : DB $09, $05 : DW $0000, $0000
	DW $0030 : DB $1D, $17 : DW $0000, $0000
	DW $0031 : DB $15, $11 : DW $0000, $0000
	DW $0032 : DB $10, $10 : DW $0000, $0000
	DW $0033 : DB $0F, $0A : DW $0000, $0000
	DW $0034 : DB $13, $09 : DW $0000, $0000
	DW $0035 : DB $0C, $0C : DW $0000, $0000
	DW $0036 : DB $0C, $0D : DW $0000, $0000
	DW $0037 : DB $0D, $15 : DW $0000, $0001
	DW $0038 : DB $23, $06 : DW $0000, $0000
	DW $0039 : DB $24, $08 : DW $0000, $0000
	DW $003A : DB $28, $08 : DW $0000, $0000
	DW $003B : DB $2C, $0D : DW $0000, $0000
	DW $003C : DB $30, $11 : DW $0000, $0001
	DW $003D : DB $29, $12 : DW $0000, $0000
	DW $003E : DB $31, $0C : DW $0000, $0000
	DW $003F : DB $30, $08 : DW $0000, $0000
	DW $0040 : DB $33, $09 : DW $0000, $0000
	DW $0041 : DB $14, $0D : DW $0000, $0001
	DW $0042 : DB $18, $0F : DW $0000, $0000
	DW $006E : DB $04, $0F : DW $0000, $0000
	DW $FFFF
WreckedShipItems:
	DW $0043 : DB $14, $0C : DW $0000, $0000
	DW $0044 : DB $2A, $0A : DW $0079, $0000
	DW $0045 : DB $2F, $0B : DW $007A, $0000
	DW $0046 : DB $2F, $0D : DW $007B, $0000
	DW $0047 : DB $0C, $0E : DW $0000, $0001
	DW $0048 : DB $15, $0D : DW $0000, $0001
	DW $0049 : DB $12, $0F : DW $0000, $0000
	DW $004A : DB $11, $13 : DW $0000, $0000
	DW $004B : DB $15, $13 : DW $0000, $0000
	DW $004C : DB $10, $11 : DW $0000, $0000
	DW $004D : DB $0E, $10 : DW $0000, $0001
	DW $004E : DB $16, $12 : DW $0000, $0000
	DW $004F : DB $15, $10 : DW $0000, $0000
	DW $0050 : DB $21, $0C : DW $0000, $0000
	DW $0051 : DB $28, $12 : DW $0000, $0000
	DW $0052 : DB $2B, $13 : DW $0000, $0000
	DW $0053 : DB $30, $14 : DW $0000, $0000
	DW $0054 : DB $30, $18 : DW $0000, $0001
	DW $0055 : DB $20, $16 : DW $0000, $0000
	DW $0056 : DB $29, $1A : DW $0000, $0001
	DW $0057 : DB $27, $1B : DW $0000, $0000
	DW $0058 : DB $23, $1C : DW $0000, $0000
	DW $0059 : DB $3C, $0A : DW $007C, $0000
	DW $0081 : DB $28, $18 : DW $0000, $0000
	DW $FFFF
MaridiaItems:
	DW $005A : DB $2B, $0E : DW $0000, $0000
	DW $005B : DB $2A, $0E : DW $007D, $0000
	DW $005C : DB $27, $0F : DW $007E, $0000
	DW $005D : DB $10, $0A : DW $0000, $0000
	DW $005E : DB $1F, $0A : DW $0000, $0000
	DW $005F : DB $23, $0C : DW $0000, $0000
	DW $0060 : DB $24, $0E : DW $0000, $0000
	DW $0061 : DB $23, $0D : DW $0000, $0000
	DW $0062 : DB $21, $0A : DW $0000, $0000
	DW $0063 : DB $13, $05 : DW $0000, $0000
	DW $0064 : DB $17, $04 : DW $0000, $0001
	DW $0065 : DB $17, $0B : DW $0000, $0001
	DW $0066 : DB $18, $0B : DW $0000, $0000
	DW $0067 : DB $14, $08 : DW $0000, $0000
	DW $0068 : DB $1A, $08 : DW $0000, $0000
	DW $006B : DB $1A, $0A : DW $0000, $0000
	DW $FFFF
TourianItems:
	DW $0070 : DB $17, $19 : DW $0000, $0000
	DW $0071 : DB $0E, $0F : DW $0000, $0000
	DW $0072 : DB $1B, $11 : DW $0000, $0000
	DW $0073 : DB $29, $0C : DW $0000, $0000
	DW $0074 : DB $28, $13 : DW $0000, $0000
	DW $0075 : DB $1F, $19 : DW $0000, $0000
	DW $0076 : DB $14, $0A : DW $0000, $0000
	DW $0077 : DB $14, $04 : DW $0000, $0001
	DW $FFFF
CeresItems:
	DW $0078 : DB $13, $14 : DW $0000, $0000
	DW $0079 : DB $1F, $13 : DW $0000, $0000
	DW $007A : DB $26, $0F : DW $0000, $0000
	DW $007B : DB $26, $11 : DW $0000, $0000
	DW $007C : DB $34, $10 : DW $0000, $0000
	DW $007D : DB $1B, $12 : DW $0000, $0000
	DW $007E : DB $1A, $10 : DW $0000, $0000
	DW $007F : DB $09, $13 : DW $0000, $0001
	DW $0080 : DB $0A, $12 : DW $0000, $0001
	DW $FFFF
DebugItems:
	DW $0069 : DB $0D, $0E : DW $007F, $0001
	DW $006A : DB $0E, $0D : DW $0080, $0001
	DW $FFFF

ReloadTiles:
	LDA #$02
	STA $420B
	LDA #$80
	STA $2116
	LDA #$43
	STA $2117
	LDA #$80
	STA $2115
	JSL $8091A9
	DB $01, $01, $18 : DL !TileGFX : DW $0100
	LDA #$02
	STA $420B
	RTL

ReloadTiles_door:
	LDA #$4000	;\
	STA $05BE  	;} Dest
	LDA #$9A00	;\ 
	STA $05C1  	;|
	LDA #$B200	;} Source
	STA $05C0  	;/
	LDA #$0700	;\
	STA $05C3  	;} Size
	LDA #$8000 	;\
	TSB $05BC  	;} Update VRAM
-
	BIT $05BC  	;\
	BMI -    	;} Wait for VRAM update
	
 	LDA #$4380	;\
 	STA $05BE  	;} Dest
 	LDA #$7E00	;\ 
 	STA $05C1  	;|
 	LDA.w #!TileGFX	;} Source
 	STA $05C0  	;/
 	LDA #$0100	;\
 	STA $05C3  	;} Size
 	LDA #$8000 	;\
 	TSB $05BC  	;} Update VRAM
 -
 	BIT $05BC  	;\
 	BMI -    	;} Wait for VRAM update

	LDA #$4400	;\
	STA $05BE  	;} Dest
	LDA #$9A00	;\ 
	STA $05C1  	;|
	LDA #$BA00	;} Source
	STA $05C0  	;/
	LDA #$0800	;\
	STA $05C3  	;} Size
	LDA #$8000 	;\
	TSB $05BC  	;} Update VRAM
-
	BIT $05BC  	;\
	BMI -    	;} Wait for VRAM update
	RTL


ReloadMinimapColors_long:
	LDA $7EC012 ;\
	STA $7EC212 ;} Target BG3 palette 2 colour 1 = [BG3 palette 2 colour 1]
	LDA $7EC016 ;\
	STA $7EC216 ;} Target BG3 palette 2 colour 1 = [BG3 palette 2 colour 3]
	LDA $7EC01A ;\
	STA $7EC21A ;} Target BG3 palette 3 colour 1 = [BG3 palette 3 colour 1]
	LDA $7EC01E ;\
	STA $7EC21E ;} Target BG3 palette 3 colour 1 = [BG3 palette 3 colour 3]
	RTL

warnpc $BDFFFF

; turn minimap off and mark boss room as explored
org $90A7E2
	RTL ; don't do anything and return
warnpc $90A8A6
