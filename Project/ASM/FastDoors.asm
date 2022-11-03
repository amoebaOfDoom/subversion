lorom

!speed = $0002
!delay = $007F

;BAF4 item delayed (bombs) grey right
;                   $C794, $BA7F, $BA4C
org $84BABF : DW !speed, $A6E3, !speed, $A6EF, !speed, $A6FB, !delay, $A683, CloseRight

;C842 grey left		$C794, $BE70, $BE59
org $84BEB0 : DW !speed, $A6B3, !speed, $A6BF, !speed, $A6CB, !delay, $A677, CloseLeft

;C848 grey right	$C794, $BED9, $BEC2
org $84BF19 : DW !speed, $A6E3, !speed, $A6EF, !speed, $A6FB, !delay, $A683, CloseRight

;C84E grey up		$C794, $BF42, $BF2B
org $84BF82 : DW !speed, $A713, !speed, $A71F, !speed, $A72B, !delay, $A68F, CloseUp

;C854 grey down		$C794, $BFAB, $BF94
org $84BFEB : DW !speed, $A743, !speed, $A74F, !speed, $A75B, !delay, $A69B, CloseDown

;C85A yellow left	$C7B1, $C014, $BFFD
org $84C04E : DW !speed, $A773, !speed, $A77F, !speed, $A78B, !delay, $A677, CloseLeft

;C860 yellow right	$C7B1, $C077, $C060
org $84C0B1 : DW !speed, $A7A3, !speed, $A7AF, !speed, $A7BB, !delay, $A683, CloseRight

;C866 yellow up		$C7B1, $C0DA, $C0C3
org $84C110 : DW !speed, $A7D3, !speed, $A7DF, !speed, $A7EB, !delay, $A68F, CloseUp

;C86C yellow down	$C7B1, $C139, $C122
org $84C173 : DW !speed, $A803, !speed, $A80F, !speed, $A81B, !delay, $A69B, CloseDown

;C872 green left	$C7B1, $C19C, $C185
org $84C1D2 : DW !speed, $A833, !speed, $A83F, !speed, $A84B, !delay, $A677, CloseLeft

;C878 green right	$C7B1, $C1FB, $C1E4
org $84C231 : DW !speed, $A863, !speed, $A86F, !speed, $A87B, !delay, $A683, CloseRight

;C87E green up		$C7B1, $C25A, $C243
org $84C290 : DW !speed, $A893, !speed, $A89F, !speed, $A8AB, !delay, $A68F, CloseUp

;C884 green down	$C7B1, $C2B9, $C2A2
org $84C2EF : DW !speed, $A8C3, !speed, $A8CF, !speed, $A8DB, !delay, $A69B, CloseDown

;C88A red left		$C7B1, $C318, $C301
org $84C351 : DW !speed, $A8F3, !speed, $A8FF, !speed, $A90B, !delay, $A677, CloseLeft

;C890 red right		$C7B1, $C37A, $C363
org $84C3B3 : DW !speed, $A923, !speed, $A92F, !speed, $A93B, !delay, $A683, CloseRight

;C896 red up		$C7B1, $C3DC, $C3C5
org $84C415 : DW !speed, $A953, !speed, $A95F, !speed, $A96B, !delay, $A68F, CloseUp

;C89C red down		$C7B1, $C43E, $C327
org $84C477 : DW !speed, $A983, !speed, $A98F, !speed, $A99B, !delay, $A69B, CloseDown

;C8A2 blue left		$C7BB, $C489, $C49E
org $84C48C : DW !speed, $A9BF, !speed, $A9CB, !speed, $A9D7, !delay, $A677, CloseLeft
org $84A9BF : DW $8004, $000D, $002D, $082D, $080D, $0000
org $84A9CB : DW $8004, $000E, $002E, $082E, $080E, $0000
org $84A9D7 : DW $8004, $000F, $002F, $082F, $080F, $0000

;C8A8 blue right	$C7BB, $C4BA, $C4CF
org $84C4BD : DW !speed, $A9FB, !speed, $AA07, !speed, $AA13, !delay, $A683, CloseRight
org $84A9FB : DW $8004, $040D, $042D, $0C2D, $0C0D, $0000
org $84AA07 : DW $8004, $040E, $042E, $0C2E, $0C0E, $0000
org $84AA13 : DW $8004, $040F, $042F, $0C2F, $0C0F, $0000

;C8AE blue up		$C7BB, $C4EB, $C500
org $84C4EE : DW !speed, $AA37, !speed, $AA43, !speed, $AA4F, !delay, $A68F, CloseUp
org $84AA37 : DW $0004, $043D, $043C, $003C, $003D, $0000
org $84AA43 : DW $0004, $041F, $041E, $001E, $001F, $0000
org $84AA4F : DW $0004, $043F, $043E, $003E, $003F, $0000

;C8B4 blue down		$C7BB, $C51C, $C531
org $84C51F : DW !speed, $AA73, !speed, $AA7F, !speed, $AA8B, !delay, $A69B, CloseDown
org $84AA73 : DW $0004, $0C3D, $0C3C, $083C, $083D, $0000
org $84AA7F : DW $0004, $0C1F, $0C1E, $081E, $081F, $0000
org $84AA8B : DW $0004, $0C3F, $0C3E, $083E, $083F, $0000


org $84C32C : DB $03 ; Increment door hit counter for missile doors
org $84C38E : DB $03 ; Increment door hit counter for missile doors
org $84C3F0 : DB $03 ; Increment door hit counter for missile doors
org $84C452 : DB $03 ; Increment door hit counter for missile doors


;00/80 = no none
;08/88 = flip v
;04/84 = flip h
;0c/8c = flip v + h

org $84F5D2 : 

TestHeight:
	LDA $0AFA
	LSR A
	LSR A
	LSR A
	LSR A
	INC A
	CMP $1C2B
	BCC TestHeightBreak
	LDA $0AFA
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	SBC #$0006
	BMI $05
	CMP $1C2B
	BCS TestHeightBreak
TestHeightGo:
	SEC
	RTS
TestHeightBreak:
	;LDA $1D77,x
	;BNE TestHeightGo
	CLC
	RTS

TestWidth:
	LDA $0AF6
	LSR A
	LSR A
	LSR A
	LSR A
	INC A
	CMP $1C29
	BCC TestWidthBreak
	LDA $0AF6
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	SBC #$0006
	BMI $05
	CMP $1C29
	BCS TestWidthBreak
TestWidthGo:
	SEC
	RTS
TestWidthBreak:
	;LDA $1D77,x
	;BNE TestWidthGo
	CLC
	RTS

PRINT PC
CloseLeft:
	JSL $848290
	LDA $0AF6
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	ADC #$0003
	CMP $1C29
	BCC CloseA
	JSR TestHeight
	BCC CloseA
	BRA Loop
CloseA:
	LDY #$C49E
	RTS

PRINT PC
CloseRight:
	JSL $848290
	LDA $0AF6
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	SBC #$0005
	BMI $05
	CMP $1C29
	BCS CloseB
	JSR TestHeight
	BCC CloseB
	BRA Loop
CloseB:
	LDY #$C4CF
	RTS

Loop:
	DEY
	DEY	
	TYA
	STA $1D27,X
	LDA #$0001
	STA $7EDE1C,X
	PLA
	RTS

CloseUp:
	JSL $848290
	LDA $0AFA
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	ADC #$0003
	CMP $1C2B
	BCC CloseC
	JSR TestWidth
	BCC CloseC
	BRA Loop
CloseC:
	LDY #$C500
	RTS

CloseDown:
	JSL $848290
	LDA $0AFA
	LSR A
	LSR A
	LSR A
	LSR A
	SEC
	SBC #$0005
	BMI $05
	CMP $1C2B
	BCS CloseD
	JSR TestWidth
	BCC CloseD
	BRA Loop
CloseD:
	LDY #$C531
	RTS




org $80CED9 ;free space
GetSpeedIndex:
	LDA $7E0B42 ;Samus's horizontal speed forward. (pixels/frame)
	AND #$00FF
	CMP #$0008
	BPL GetSpeedIndexMax
	ASL
	TAX
	RTS
GetSpeedIndexMax:
	LDX #$0010
	RTS

GetDoorScrollSpeed:
	PHX
	JSR GetSpeedIndex
	LDA ScrollSpeedTable,X
	STA $186A
	PLX
	RTS
ScrollSpeedTable:
	DW $0004, $0004, $0006, $0006, $0006, $0006, $0008, $0008, $0008

CompareGetDoorScrollCountHorizontal:
	LDA $7E0B42 ;Samus's horizontal speed forward. (pixels/frame)
	CMP #$0006
	BPL CompareGetDoorScrollCountHorizontal_Fastest
	CMP #$0004
	BPL CompareGetDoorScrollCountHorizontal_Fast
	CMP #$0002
	BPL CompareGetDoorScrollCountHorizontal_Medium
	BRA CompareGetDoorScrollCountHorizontal_Slow

CompareGetDoorScrollCountHorizontal_Slow:
	CPX #$0040
	RTS
CompareGetDoorScrollCountHorizontal_Medium:
	CPX #$002B
	RTS
CompareGetDoorScrollCountHorizontal_Fast:
	CPX #$002B
	RTS
CompareGetDoorScrollCountHorizontal_Fastest:
	CPX #$0020
	RTS

CompareGetDoorScrollCountVertical_1:
	LDA $7E0B42 ;Samus's horizontal speed forward. (pixels/frame)
	CMP #$0006
	BPL CompareGetDoorScrollCountVertical_1_Fastest
	CMP #$0004
	BPL CompareGetDoorScrollCountVertical_1_Fast
	CMP #$0002
	BPL CompareGetDoorScrollCountVertical_1_Medium
	BRA CompareGetDoorScrollCountVertical_1_Slow

CompareGetDoorScrollCountVertical_1_Slow:
	CPX #$0039
	RTS
CompareGetDoorScrollCountVertical_1_Medium:
	CPX #$002E
	RTS
CompareGetDoorScrollCountVertical_1_Fast:
	CPX #$0027
	RTS
CompareGetDoorScrollCountVertical_1_Fastest:
	CPX #$001D
	RTS

CompareGetDoorScrollCountVertical_2:
	LDA $7E0B42 ;Samus's horizontal speed forward. (pixels/frame)
	CMP #$0006
	BPL CompareGetDoorScrollCountVertical_2_Fastest
	CMP #$0004
	BPL CompareGetDoorScrollCountVertical_2_Fast
	CMP #$0002
	BPL CompareGetDoorScrollCountVertical_2_Medium
	BRA CompareGetDoorScrollCountVertical_2_Slow

CompareGetDoorScrollCountVertical_2_Slow:
	CPX #$0005
	RTS
CompareGetDoorScrollCountVertical_2_Medium:
	CPX #$0005
	RTS
CompareGetDoorScrollCountVertical_2_Fast:
	CPX #$0004
	RTS
CompareGetDoorScrollCountVertical_2_Fastest:
	CPX #$0003
	RTS

AdjustDoorLoadPosition:
	PHA
	LDA $7E0B42 ;Samus's horizontal speed forward. (pixels/frame)
	CMP #$0006
	BPL AdjustDoorLoadPositiont_Fastest
	CMP #$0004
	BPL AdjustDoorLoadPosition_Fast
	CMP #$0002
	BPL AdjustDoorLoadPosition_Medium
	BRA AdjustDoorLoadPosition_Slow

AdjustDoorLoadPosition_Slow: ;*1
	PLA
	BRA ApplyAdjustedValue
AdjustDoorLoadPosition_Medium: ;*1.25
	PLA
	STA $186A
	LSR : LSR
	CLC
	ADC $186A
	BRA ApplyAdjustedValue
AdjustDoorLoadPosition_Fast: ; *1.5
	PLA
	STA $186A
	LSR
	CLC
	ADC $186A
	BRA ApplyAdjustedValue
AdjustDoorLoadPositiont_Fastest: ;*2
	PLA
	ASL
	BRA ApplyAdjustedValue

ApplyAdjustedValue:
	STA $13
	LDA $12
	RTL

AdjustFadeOutSpeed:
	PHX
	JSR GetSpeedIndex
	LDA FadeOutSpeedTable,X
	STA $7EC402
	PLX
	RTL
FadeOutSpeedTable:
	DW $000C, $000C, $000A, $000A, $0008, $0008, $0006, $0006, $0006

SetupScrollHorizontal:
	JSR GetDoorScrollSpeed
	JSR CompareGetDoorScrollCountHorizontal
	LDA $0911 ;Screen's X position in pixels
	RTS

SetupScrollVertical:
	JSR GetDoorScrollSpeed
	LDA $0915 ;Screen's X position in pixels
	RTS

AdjustDoorAlignSpeed:
	PHX
	JSR GetSpeedIndex
	LDA DoorAlignSpeedTable,X
	STA $186A
	PLX
	RTS
DoorAlignSpeedTable:
	DW $0001, $0001, $0002, $0002, $0004, $0004, $0006, $0006, $0006

org $80D040 ;free space
AdjustHorizontalAlignUp:
	JSR AdjustDoorAlignSpeed
	LDA $0915
	AND #$00FF
	CMP $186A
	BMI AdjustHorizontalAlign_Center
	LDA $0915
	SEC
	SBC $186A
	STA $0915
	RTL

AdjustHorizontalAlign_Center:
	LDA $0915
	AND #$FF00
	STA $0915
	RTL

AdjustHorizontalAlignDown:
	JSR AdjustDoorAlignSpeed
	LDA $0915
	AND #$00FF
	EOR #$00FF
	INC
	AND #$00FF
	CMP $186A
	BMI AdjustHorizontalAlign_Center
	LDA $0915
	CLC
	ADC $186A
	STA $0915
	RTL

AdjustVerticalAlignLeft:
	JSR AdjustDoorAlignSpeed
	LDA $0911
	AND #$00FF
	CMP $186A
	BMI AdjustVerticalAlign_Center
	LDA $0911
	SEC
	SBC $186A
	STA $0911
	RTL

AdjustVerticalAlign_Center:
	LDA $0911
	AND #$FF00
	STA $0911
	RTL

AdjustVerticalAlignRight:
	JSR AdjustDoorAlignSpeed
	LDA $0911
	AND #$00FF
	EOR #$00FF
	INC
	AND #$00FF
	CMP $186A
	BMI AdjustVerticalAlign_Center
	LDA $0911
	CLC
	ADC $186A
	STA $0911
	RTL

;org $80AE98
;	JSR SetupScrollHorizontal
;	;LDA $0911 ;Screen's X position in pixels
;	CLC
;	ADC $186A;#$0004
;	STA $0911
;	LDA $0917 ;Layer 2's X scroll in room in pixels?
;	CLC
;	ADC $186A;#$0004
;	STA $0917
;	JSL $80A3A0
;	PLX
;	INX
;	STX $0925 ;How many times the screen has scrolled?
;	JSR CompareGetDoorScrollCountHorizontal;CPX #$0040
;
;
;org $80AEDC
;	JSR SetupScrollHorizontal
;	;LDA $0911 ;Screen's X position in pixels
;	SEC
;	SBC $186A;#$0004
;	STA $0911
;	LDA $0917 ;Layer 2's X scroll in room in pixels?
;	SEC
;	SBC $186A;#$0004
;	STA $0917
;	JSL $80A3A0
;	PLX
;	INX
;	STX $0925 ;How many times the screen has scrolled?
;	JSR CompareGetDoorScrollCountHorizontal;CPX #$0040
;
;org $80AF5F
;	JSR SetupScrollVertical
;	;LDA $0915 ;Screen's Y position in pixels
;	CLC
;	ADC $186A;#$0004
;	STA $0915
;	LDA $0919 ;Layer 2's Y scroll in room in pixels? (up = positive)
;	CLC
;	ADC $186A;#$0004
;	STA $0919
;	JSL $80A3A0
;	PLX
;	INX
;	STX $0925 ;How many times the screen has scrolled?
;	JSR CompareGetDoorScrollCountVertical_1;CPX #$0039
;
;org $80AFE1
;	JSR SetupScrollVertical
;	;LDA $0915 ;Screen's Y position in pixels
;	SEC
;	SBC $186A;#$0004
;	STA $0915
;	LDA $0919 ;Layer 2's Y scroll in room in pixels? (up = positive)
;	SEC
;	SBC $186A;#$0004
;	STA $0919
;	JSR CompareGetDoorScrollCountVertical_2;CPX #$0005
;
;org $80B024
;	PLX
;	INX
;	STX $0925 ;How many times the screen has scrolled?
;	JSR CompareGetDoorScrollCountVertical_1;CPX #$0039
;
;org $82D961
;	;LDA #$000C ;Affects fade out speed
;	;STA $7EC402
;	JSL AdjustFadeOutSpeed
;	JSR $DA02
;	RTS
;
;org $82DE49
;	STZ $12
;	STZ $14
;	LDA $0008,x
;	BPL ProcessDoorLoadPosition
;
;	LDA $0791
;	BIT #$0002
;	BNE $05
;	LDA #$00C8
;	BRA $03
;	LDA #$0180
;
;ProcessDoorLoadPosition:
;	JSL AdjustDoorLoadPosition
;	;STA $13
;	;LDA $12
;	STA $092B
;	LDA $14 ;Movement speed for room transitions (subpixels per frame of room transition movement)
;	STA $092D ;Movement speed for room transitions (pixels per frame of room transition movement)
;	RTS
;
;org $82F7EC
;AdjustHorizontalAlignUp_Inject:
;	JSL AdjustHorizontalAlignUp
;	RTS
;AdjustHorizontalAlignDown_Inject:
;	JSL AdjustHorizontalAlignDown
;	RTS
;AdjustVerticalAlignLeft_Inject:
;	JSL AdjustVerticalAlignLeft
;	RTS
;AdjustVerticalAlignRight_Inject:
;	JSL AdjustVerticalAlignRight
;	RTS
;
;org $82E327
;	JSR AdjustHorizontalAlignUp_Inject ;DEC $0915; Decrement Samus' Y position
;org $82E32C
;	JSR AdjustHorizontalAlignDown_Inject ;INC $0915; Increment Samus' Y position
;org $82E33B
;	JSR AdjustVerticalAlignLeft_Inject ;DEC $0911; Decrement Samus' X position
;org $82E340
;	JSR AdjustVerticalAlignRight_Inject ;INC $0911; Increment Samus' X position