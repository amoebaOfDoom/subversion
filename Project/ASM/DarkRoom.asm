lorom

;(high to low)
;dark
	; darken  1
	; base    5
	; layer2  1
	; layer1  1
	; thermal 1
	; range   3
	; speed   4

;color
	; null    1
	; blue    5
	; green   5
	; red     5

!plm_id       = $1C37
!plm_arg      = $1DC7
!plm_speed    = $1D77
!plm_range    = $1E17

!dark_timer   = $1778
!dark_glow    = $177A
!dark_enable  = $177C
!dark_base    = $177E
!dark_color   = $1780
!dark_plm     = $1780
!dark_red     = $1781
!dark_green   = $1782
!dark_blue    = $1783

org $89AA10
	DW $1084, $0000, $0000

org $84F800
DarkRoomPLM:
	DW DarkRoomInit, $B7E9
ColorRoomPLM:
	DW $B3D0, $B7E9

DarkRoomInst:
	DW $86BC ;delete

DarkRoomInit:
	JSL DarkRoomInit_long
	RTS


org $888010
	JSR DarkRoomMain
	;BIT $1987

org $8882CD
	STZ !dark_enable
	BRA skip_quake_checks
	; remove checks for rooms to activate quake
	; CMP #$9804
	; BEQ $1B   
	; CMP #$96BA
	; BEQ $16   
	; CMP #$B32E
	; BEQ $11   
	; CMP #$B457
	; BEQ $0C   
	; CMP #$DD58
	; BEQ $07   
	; CMP #$DEDE
	; BEQ $02   
	; BRA $06   	
	; LDA #$FFFF
	; STA $0609 
org $8882F3
skip_quake_checks:


org $88EF20
DarkRoomMain_long:
	JSR DarkRoomMain
	RTL

DarkRoomInit_long:
	PHP
	REP #$30

	LDA #$0001
	STA !dark_enable

	LDA !plm_arg,Y
	LSR : LSR : LSR : LSR
	AND #$0007
	ASL : ASL
	STA !plm_range,Y

	LDA !plm_arg,Y
	AND #$000F
	STA !plm_speed,Y

	LDA !plm_arg+1,Y
	LSR : LSR
	AND #$001F
	STA !dark_base

	TYA
	STA !dark_plm
	STZ !dark_color+2
	STZ !dark_timer
	STZ !dark_glow

	LDX #$004E
.loop
	LDA !plm_id,X
	CMP #$F804
	BEQ .color
	DEX
	DEX
	BPL .loop
	BRA .return
.color
	STZ !plm_id,X
	LDA !plm_arg,X
	LSR : LSR : LSR : LSR : LSR
	SEP #$20
	AND #$1F
	STA !dark_green
	LDA !plm_arg,X
	AND #$1F
	STA !dark_red
	LDA !plm_arg+1,X
	LSR : LSR
	AND #$1F
	STA !dark_blue
.return
	PLP
	RTL


ColorAberation_Red:
	DB $00, $01, $01, $01
ColorAberation_Green:
	DB $00, $00, $00, $01
ColorAberation_Blue:
	DB $00, $00, $00, $00


DarkRoomMain:
	PHA : PHX : PHY : PHP
	REP #$30

	LDA $1987 ; Layer blending window 2 configuration
	BIT #$0080 ; power bomb explosion active
	BEQ +
	JMP DarkRoomMain_return
+

	LDA $0A78 ; x-ray freeze time
	BEQ +
	JMP DarkRoomMain_return
+

	LDA !dark_enable
	BNE +
	JMP DarkRoomMain_return
+

	INC !dark_timer

	LDA !dark_plm
	AND #$00FF
	TAX
	
	LDA !plm_arg,X
	ASL : ASL : ASL : ASL
	EOR $09A2
	AND #$0800
	BEQ .enabled
	JMP DarkRoomMain_return

.enabled
	LDA !dark_timer
	LSR : LSR
	STA $26
	LDA !plm_speed,X
	STA $28
	JSL $A0B6FF ; multiply

	LDA !plm_range,X
	STA $0E32
	LDA $2A
	JSL $A0B0C6 ; sin

	LDA $0E36
	CLC
	ADC !plm_range,X
	LSR
	PHA
	AND #$0003
	TAY
	PLA
	LSR : LSR

	CLC
	ADC !dark_base
	STA $02

	SEP #$20
	LDA !dark_red
	CLC : ADC $02
	ADC.w ColorAberation_Red,Y
	CMP #$1F
	BMI +
	LDA #$1F
+
	STA $00
	ORA #$20
	STA $74

	LDA !dark_green
	CLC : ADC $02
	ADC.w ColorAberation_Green,Y
	CMP #$1F
	BMI +
	LDA #$1F
+
	STA $01
	ORA #$40
	STA $75

	LDA !dark_blue
	CLC : ADC $02
	ADC.w ColorAberation_Blue,Y
	CMP #$1F
	BMI +
	LDA #$1F
+
	STA $02
	ORA #$80
	STA $76

	LDA #$13
	STA $69
	LDA #$04
	STA $6B
	LDA #$02
	STA $6E

	LDA !plm_arg+1,X
	AND #$83
	ORA #$30
	STA $71

	REP #$20
	LDX #$0004
.loop
	LDA $0998
	CMP #$000B ; door transition
	BNE .normal_load
	LDA $099C
	CMP #$E737 ; fade in
	BNE .skip_load

.fadein_load
	LDA $7EFF02,X
	JSR AddColors
	STA $7EC232,X
	BRA .skip_load
.normal_load
	LDA $7EC232,X
	JSR AddColors
	STA $7EC032,X

.skip_load
	DEX : DEX
	BPL .loop

DarkRoomMain_return:
	PLP : PLY : PLX : PLA
	BIT $1987
	RTS


; A = source color
; 00-02 = RGB color to add
; 05 = returned sum color
AddColors:
	STA $03
    LDA $04
    LSR : LSR
    AND #$001F
    CLC
    ADC $02
    AND #$00FF
    CMP #$001F
    BMI +
    LDA #$001F
+
    XBA : ASL : ASL
    STA $05

    LDA $03
    LSR : LSR : LSR : LSR : LSR
    AND #$001F
    CLC
    ADC $01
    AND #$00FF
    CMP #$001F
    BMI +
    LDA #$001F
+
	XBA : LSR : LSR : LSR
	ORA $05
	STA $05

    LDA $03
    AND #$001F
    CLC
    ADC $00
    AND #$00FF
    CMP #$001F
    BMI +
    LDA #$001F
+
	ORA $05
	STA $05
	RTS


org $82E72C ; fade in start (door)
	JSR FadeStartDoor
	;STA $099C

org $82E767 ; fade in done (door)
	JSR FadeEndDoor
	;STA $0998

org $82F742
FadeStartDoor:
	STA $099C
	LDA $7EC232
	STA $7EFF02
	LDA $7EC234
	STA $7EFF04
	LDA $7EC236
	STA $7EFF06
	RTS

FadeEndDoor:
	STA $0998
	LDA $7EFF02
	STA $7EC232
	LDA $7EFF04
	STA $7EC234
	LDA $7EFF06
	STA $7EC236
	RTS

org $91D283 ; x-ray hdma code
    LDX #$4000
	LDA !dark_enable
	NOP : NOP : NOP
	BNE BRANCH_FIREFLEA
org $91D2B0 ; x-ray firefly
BRANCH_FIREFLEA:


; fire flea max darkness
org $A38E7A
	CMP #$001F ; #$000E
org $A38E9C
	CMP #$001F ; #$000E


;;; $D2BC: X-ray setup stage 8 - set backdrop colour
org $91D2BC
	RTL

org $91CAFC
	;LDA #$01
	;STA $0A78
	JSL SetupXRayHudHDMA
	NOP


org $91D143
XRayEnableCheck:
  LDA $07CD ; fx pointer
  BEQ XRayEnableCheck_Boss
  LDA $197E ; fx liquid flags
  EOR #$FFFF
  BIT #$0010
  BEQ XRayEnableCheck_Return
  BRA XRayEnableCheck_Boss
org $91D158
XRayEnableCheck_Boss:
org $91D172
XRayEnableCheck_Return:


org $91D286
	JSL GetLayerBlendingMode
	STA $0073
	NOP
org $8886F5
	JSL GetLayerBlendingMode
	STA $0073
	NOP
org $888959
	JSL GetLayerBlendingMode
	STA $0073
	NOP
org $8889C0
	JSL GetLayerBlendingMode
	STA $0073
	NOP
org $888A0E
	JSL GetLayerBlendingMode
	STA $0073
	NOP

;org $91D28C
;	NOP : NOP ;BEQ $22
;org $8886FB
;	NOP : NOP ;BEQ $1B
;org $88895F
;	NOP : NOP ;BEQ $0C
;org $8889C6
;	NOP : NOP ;BEQ $0C
;org $888A14
;	NOP : NOP ;BEQ $0C

org $888A6D
	LDA.b #$01
	NOP
	;LDA !dark_enable
	NOP : NOP
	;LDA $196E
	;CMP #$24


org $91E217
	JSL GetLayerBlendingMode_Start
	NOP : NOP
	; LDA #$0001  ;\
	; STA $0A78   ;} Time is frozen flag = x-ray is active


org $97E800
SetupXRayHudHDMA:
	PHX
	PHY
	LDA #$01
	STA $0A78
	PHP
	REP #$30
	JSL $888435 ;spawn HDMA object
		DB $00, $21
		DW BackdropInstructionList_addr
	JSL $888435 ;spawn HDMA object
		DB $02, $22
		DW BackdropInstructionList_value
	PLP
	PLY
	PLX
	RTL

BackdropInstructionList_addr:
	DW $8655 ;HDMA table bank = $97
		DB $97
	DW $8570
		DL BackdropPreInstruction ;$88ADB2 ; Pre-instruction
BackdropInstructionList_addr_Loop:
	DW $7000, BackdropHDMAtable_addr
	DW $85EC, BackdropInstructionList_addr_Loop

BackdropHDMAtable_addr:
	DB $1F, $00
	DB $01, $00
	DB $00

BackdropInstructionList_value:
	DW $8655 ;HDMA table bank = $97
		DB $97
	DW $8570
		DL BackdropPreInstruction ;$88ADB2 ; Pre-instruction
BackdropInstructionList_value_Loop:
	DW $7000, BackdropHDMAtable_value
	DW $85EC, BackdropInstructionList_value_Loop

BackdropHDMAtable_value:
	DB $1F
		DW $0000
	DB $01
		DW #%0000110001100011
	DB $00

BackdropPreInstruction:
	PHP
	REP #$30
	LDA $0A78 ; x-ray freeze time
	BNE +
	LDX $18B2 ; HDMA object index
	STZ $18B4,x ; delete HDMA object
+
	PLP
	RTL

GetLayerBlendingMode_Start:
	LDA #$0001
	STA $0A78 ; displaced
GetLayerBlendingMode:
	PHX
	LDA !dark_enable
	BEQ .normal_xray
	LDX #$004E
.loop
	LDA !plm_id,X
	CMP #$F800
	BEQ .color
	DEX
	DEX
	BPL .loop
	BRA .normal_xray
.color
	LDA !plm_arg,X
	BIT #$8000
	BEQ .normal_xray
	LDA $73
	ORA #$00FF
	;AND #$FFAF
	PLX
	RTL
.normal_xray
	LDA $73
	PLX
	RTL
