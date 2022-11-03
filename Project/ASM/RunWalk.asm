lorom

!runwalkAdr = $09EC

; invert run input check if configured (Kejardon)
org $908542
	JSR AutoRunCheck
org $909781
	JSR AutoRunCheck
org $90FFE0
AutoRunCheck:
	AND $09B6
	PHX
	LDX $0998
	CPX #$001E ; intro CS
	BEQ +
	CPX #$0028
	BPL +
	LDX !runwalkAdr
	BEQ +
	EOR $09B6
+
	PLX
	BIT $09B6	
	RTS
warnpc $910000

; Remove check L/R for aim (graphics)
org $82F5CA
	RTS

; Remove check L/R for aim (binding)
org $918241 : NOP : NOP : NOP ; AD BE 09    LDA $09BE  [$7E:09BE]  ;\
org $918244 : NOP : NOP : NOP ; 89 30 00    BIT #$0030             ;} If aim up binding is L or R:
org $918247 : NOP : NOP       ; F0 07       BEQ $07    [$8250]     ;/
org $918257 : NOP : NOP : NOP ; AD BC 09    LDA $09BC  [$7E:09BC]  ;\
org $91825A : NOP : NOP : NOP ; 89 30 00    BIT #$0030             ;} If aim up binding is L or R:
org $91825D : NOP : NOP       ; F0 07       BEQ $07    [$8266]     ;/
org $9182AC : NOP : NOP : NOP ; AD BE 09    LDA $09BE  [$7E:09BE]  ;\
org $9182AF : NOP : NOP : NOP ; 89 30 00    BIT #$0030             ;} If aim up binding is L or R:
org $9182B2 : NOP : NOP       ; F0 07       BEQ $07    [$82BB]     ;/
org $9182C2 : NOP : NOP : NOP ; AD BC 09    LDA $09BC  [$7E:09BC]  ;\
org $9182C5 : NOP : NOP : NOP ; 89 30 00    BIT #$0030             ;} If aim up binding is L or R:
org $9182C8 : NOP : NOP       ; F0 07       BEQ $07    [$82D1]     ;/


; Special menu options
org $82F037 : LDA #$0003 ; LDA #$0002
org $82F054 : CMP #$0004 ; CMP #$0003
org $82F084 : JSR (SpecialInputHandlers,X) ; JSR ($F088,x)

org $82F093 : LDA.w SpecialRAMAddresses,X ; LDA $F0AE,x

org $82EFA6
	LDA #$0002
-
	STA $099E
	PHA
	JSR $F0B9
	PLA
	DEC
	BPL -
	NOP

print pc
warnpc $82EFB6

org $82F0B9
SpecialDraw:
	LDA $00
	PHA

	LDA $099E ; submenu index
	ASL
	TAX

	STZ $00
	LDA.w SpecialRAMAddresses,X
	TAX
	LDA $0000,X
	BNE +
	LDA #$0400
	STA $00
+

	LDA $099E
	ASL : ASL : ASL
	TAX
	LDY #$0003

-
	PHY : PHX
	LDA.w SpecialDrawPositions,X
	TAX

	LDY #$000C
	LDA $00
	JSR $ED28 ; set palette
	LDA $00
	EOR #$0400
	STA $00
	PLX : PLY
	INX : INX : DEY
	BPL -

	PLA
	STA $00
	RTS

SpecialDrawAll:
	LDA #$0002
-
	STA $099E
	PHA
	JSR $F0B9
	PLA
	DEC
	BPL -
	RTS


SpecialDrawPositions:
       ; TL,   TR,     BL,    BR
	DW $01E0, $01EE, $0220, $022E ; 0
	DW $02E0, $02EE, $0320, $032E ; 1
	DW $03E0, $03EE, $0420, $042E ; 2

;org $82F088
SpecialInputHandlers:
	DW $F08E, $F08E, $F08E, $F0B2
;org $82F0AE
SpecialRAMAddresses:
	DW $09EA, $09E4, !runwalkAdr
;org $82F33F
SpecialSpritePositions:
	DW $0010, $0040
	DW $0010, $0060
	DW $0010, $0080
	DW $0010, $00A0

print pc

warnpc $82F159

org $82F2FD
	DW SpecialSpritePositions ; $F33F


org $978FCD
incbin ROMProject/Graphics/control_options.ttb

org $97938D
incbin ROMProject/Graphics/special_options.ttb


