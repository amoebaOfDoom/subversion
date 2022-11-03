LoRom

; Super Metroid save/load routine expansion v1.1
; Made by Scyzer
; 
; **Free space used from $81:EF20 (0x00EF20) to $81:F0A4 (0x00F0A4)**
; 
; This patch/asm file will modify the saving and loading routine of Super Metroid for the SNES.
; The most basic function is that is will change how maps are stored and loaded, meaning you will be able to use the ENTIRE map for all areas.
; Debug is still not supported due to space limitations, but there is no map for this area anyway, so...
; 
; KejMap is made completely redundant by this patch, so dont bother applying it (it won't do anything if you already have)
; 
; There's a few other bits and pieces for more experienced hackers:
; 	$100 bytes of ram from $7F:FE00 to $7F:FEFF is saved per file.
; 		You can modify this ram, and it will still be the same when you load the game.
; 	$100 bytes of ram from $7F:FF00 to $7F:FFFF is saved GLOBALLY.
; 		Any ram here will apply to ALL 3 save game files (including if you clear all save games). Deleting the .srm file will remove these changes.
; 	
; v1.1 - Fixed a bug caused by also using the skip intro patch. Also removed IPS patch.
; v1.0 - Original release

!extra_sram = $7FFDFE


org $81B3BF
  CPX #$0800 ; clear debug map on new file
org $819A47 : LDA SRAMAddressTable,X : Skip 7 : LDA SRAMAddressTable,X : Skip 11 : CPY #$0A00
org $819CAE : LDA SRAMAddressTable,X : Skip 12 : CPY #$0A00
org $818000 : JMP SaveGame
org $818085 : JMP LoadGame
org $81EF20 
print "Save Game Global"
print pc
SaveGameGlobal_long:
	JML SaveGameGlobal
print "Save Game Extra"
print pc
SaveGameExtra_long:
	JML SaveGameExtra

SRAMAddressTable:
	DW $0010, $0A10, $1410
CheckSumAdd:
	CLC : ADC $14 : INC A : STA $14 : RTS

SaveGame:
	PHP : REP #$30 : PHB : PHX : PHY
	PEA $7E7E : PLB : PLB : STZ $14 : AND #$0003 : ASL A : STA $12

	; save ram to sram image
	LDA $079F : INC A : XBA : TAX : LDY #$00FE
	-	LDA $07F7,Y : STA $CD50,X : DEX #2 : DEY #2 : BPL -		;Saves the current map
	LDY #$005E
	-	LDA $09A2,Y : STA $D7C0,Y : DEY : DEY : BPL -			;Saves current equipment	
	LDA $078B : STA $D916		;Current save for the area
	LDA $079F : STA $D918		;Current Area

	; save sram
	LDX $12 : LDA SRAMAddressTable,X : TAX : LDY #$0000		;How much data to save for items and event bits
	-	LDA $D7C0,Y : STA $700000,X : JSR CheckSumAdd : INX #2 : INY #2 : CPY #$0160 : BNE -
	LDY #$06FE		;How much data to save for maps
	-	LDA $CD52,Y : STA $700000,X : INX #2 : DEY #2 : BPL -	
	TXA : STA !extra_sram
	JSL SaveGameExtra
	PEA $7E7E : PLB : PLB : LDY #$007E		;How much data to save for maps (area 7)
	-	LDA $D452,Y : STA $700000,X : INX #2 : DEY #2 : BPL -	

	; update checksum
	LDX $12 : LDA $14 : STA $700000,X : STA $701FF0,X : EOR #$FFFF : STA $700008,X : STA $701FF8,X

	JSL SaveGameGlobal
	PLY : PLX : PLB : PLP : RTL

LoadGame:
	PHP : REP #$30 : PHB : PHX : PHY
	PEA $7E7E : PLB : PLB : STZ $14 : AND #$0003 : ASL A : STA $12
	; load sram
	TAX : LDA SRAMAddressTable,X : STA $16 : TAX : LDY #$0000		;How much data to load for items and event bits
	-	LDA $700000,X : STA $D7C0,Y : JSR CheckSumAdd : INX #2 : INY #2 : CPY #$0160 : BNE -
	LDY #$06FE		;How much data to load for maps
	-	LDA $700000,X : STA $CD52,Y : INX #2 : DEY #2 : BPL -
	TXA : STA !extra_sram
	JSL LoadGameExtra
	PEA $7E7E : PLB : PLB : LDY #$007E		;How much data to load for maps (area 7)
	-	LDA $700000,X : STA $D452,Y : INX #2 : DEY #2 : BPL -
	LDY #$007E : LDA #$0000		;always load 0 for the rest of the area 7 map
	-	STA $D4D2,Y : DEY #2 : BPL -

	; load ram from sram image
	LDY #$005E
	-	LDA $D7C0,Y : STA $09A2,Y : DEY #2 : BPL -		;Loads current equipment	
	LDA $D916 : STA $078B		;Current save for the area
	LDA $D918 : STA $079F		;Current Area

	; check checksum
	LDX $12 : LDA $14
		CMP $700000,X : BNE .clearSave
		CMP $701FF0,X : BNE .clearSave
		EOR #$FFFF
		CMP $700008,X : BNE .clearSave
		CMP $701FF8,X : BNE .clearSave

	JSL LoadGameGlobal
	PLY : PLX : PLB : PLP : CLC : RTL

.clearSave
	; clear sram
	LDX $16 : LDY #$09FE : LDA #$0000
	-	STA $700000,X : INX #2 : DEY #2 : BPL -
	; update checksum
	;LDX $12 : LDA #$0160 : STA $700000,X : STA $701FF0,X : EOR #$FFFF : STA $700008,X : STA $701FF8,X

	JSL LoadGameGlobal
	PLY : PLX : PLB : PLP : SEC : RTL

SaveGameGlobal:
	PHP : REP #$30 : PHB : PHX : PHY
	PEA $7F7F : PLB : PLB : STZ $14
	LDY #$00FE : LDX #$1E10					;How much extra data to save globally (affects all saves)
	-	LDA $FF00,Y : STA $700000,X : JSR CheckSumAdd : INX #2 : DEY #2 : BPL -
	LDA $14 : STA $700006 : STA $701FF6 : EOR #$FFFF : STA $70000E : STA $701FFE
	PLY : PLX : PLB : PLP : RTL

LoadGameGlobal:
	PHP : REP #$30 : PHB : PHX : PHY
	PEA $7F7F : PLB : PLB : STZ $14
	LDY #$00FE : LDX #$1E10					;How much extra data to load globally (affects all saves)
	-	LDA $700000,X : STA $FF00,Y : JSR CheckSumAdd : INX #2 : DEY #2 : BPL -

	; check checksum
	LDA $14
		CMP $700006 : BNE .clearSave
		CMP $701FF6 : BNE .clearSave
		EOR #$FFFF
		CMP $70000E : BNE .clearSave
		CMP $701FFE : BNE .clearSave
	BRA .return

.clearSave
	; clear sram
	LDY #$00FE : LDX #$1E10 : LDA #$0000
	-	STA $FF00,Y : STA $700000,X : INX #2 : DEY #2 : BPL -
	; update checksum
	LDA #$0100 : STA $700006 : STA $701FF6 : EOR #$FFFF : STA $70000E : STA $701FFE

.return
	PLY : PLX : PLB : PLP : RTL

SaveGameExtra:
	PHB
	LDA	!extra_sram : TAX
	PEA $7F7F : PLB : PLB : LDY #$007E		;How much extra data to save per save
	-	LDA $FE00,Y : STA $700000,X : INX #2 : DEY #2 : BPL -
	PLB
	RTL

LoadGameExtra:
	PHB
	LDA	!extra_sram : TAX
	PEA $7F7F : PLB : PLB : LDY #$007E		;How much extra data to load per save
	-	LDA $700000,X : STA $FE00,Y : INX #2 : DEY #2 : BPL -
	PLB
	RTL

org $81B3B6
	JSR ClearCurrentMap
org $81FC50
ClearCurrentMap:
  LDA #$0000
-
	STA $7E07F7,X
	INX
	INX
	CPX #$0100
	BMI -
	LDX #$0000
	RTS

; give area map
org $8FFFF0
	LDA #$00FF
	STA $0789
	RTS
