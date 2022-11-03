lorom 
padbyte $FF


!thermalbit = #$0800
!missiles = $09C6
!maxmissiles = $09C8
!notif_timer = $7FFA64

org $80988B
	incbin ROMProject/Graphics/hud.ttb


;;; $9CEA: Toggle HUD item highlight ;;;
org $809CEA 
	STX $077C              ; HUD item tilemap palette bits = [X]
	DEC A                  ;\
	BMI .return            ;} If [A] <= 0: return

	; X = Tilemap offset, Y = count
	ASL : ASL : TAY
	LDX HUDItemOffsetTable,y
	INY : INY
	LDA HUDItemOffsetTable,y
	TAY

	LDA $7EC608,x          ;\
	CMP #$3C0F             ;} If top-left icon tile is blank, return:
	BEQ .return            ;/

.loop
	LDA $7EC608,x          ;\
	AND #$E3FF             ;\
	ORA $077C              ;} Set tile's palette bits
	STA $7EC608,x          ;/

	LDA $7EC648,x          ;\
	AND #$E3FF             ;\
	ORA $077C              ;} Set tile's palette bits
	STA $7EC648,x          ;/

	INX : INX
	DEY
	BNE .loop

.return
	RTS

; HUD item tilemap offsets
HUDItemOffsetTable:
;Offset, Size
	DW $0010, $0003 ; Missiles
	DW $0016, $0002 ; Super missiles
	DW $001A, $0003 ; Power bombs
	DW $0020, $0002 ; Grapple beam
	DW $0024, $0003 ; Thermal
	DW $002A, $0002 ; X-ray

pad $809D77 : warnpc $809D78

;running part:
org $809C10
	LDX #$009A
org $809C16
	JSR DRAW_MAX_MISSLES
	JSR DRAW_CHARGE
	BRA DrawHUDAmmoUpdate_Continue
	pad $809C54
org $809C55
	DrawHUDAmmoUpdate_Continue:

org $809B01
  	; Draw missile ammo
 	LDA $09C8 
	BEQ $09   
	LDA $09C6 
	LDX #$009A
	JSR $9D78 

	JSR DRAW_MAX_MISSLES

	; Display thermal icon
	LDA $09A4  
	BIT !thermalbit 
	BEQ $04    
	JSL DrawThermalHUDIcon

	LDA #$0000
	STA !notif_timer ; clear notification timer

	LDA $09D2   ;\
	LDX #$1000  ;} Highlight selected HUD item
	JSR $9CEA   ;/
	LDA $0A0E   ;\
	LDX #$1400  ;} Unhighlight previously selected HUD item
	JSR $9CEA   ;/
	JSL $809B44 ; Handle HUD tilemap

	PLB
	PLP
	RTL

pad $809B43 : warnpc $809B44

org $80998B
MissileHUDTilemap:
  DW $3480, $3481, $7480
  DW $3490, $3491, $7490
SuperMissileHUDTilemap:
  DW $3482, $7482
  DW $3492, $7492
PowerBombHUDTilemap:
  DW $3483, $3484, $7483
  DW $3493, $3494, $7493
GrappleHUDTilemap:
  DW $3485, $7485
  DW $3495, $7495
ThermalHUDTilemap:
	DW $3486, $3487, $7486
	DW $3496, $3497, $7496
XRayHUDTilemap:
  DW $3488, $7488
  DW $3498, $7498

pad $8099CE : warnpc $8099CF

org $8099CF
DrawMissileHUDIcon:
	PHP
	PHX
	PHY
	PHB
	PHK                    ;\
	PLB                    ;} DB = $80
	REP #$30
	LDY.w #MissileHUDTilemap
	LDX #$0010 ; hud offset

Draw3x2HUDIcon:
	LDA $0000,y       ;\
	STA $7EC608,x     ;|
	LDA $0002,y       ;} Write top row
	STA $7EC60A,x     ;|
	LDA $0004,y       ;|
	STA $7EC60C,x     ;/
	LDA $0006,y       ;\
	STA $7EC648,x     ;|
	LDA $0008,y       ;} Write bottom row
	STA $7EC64A,x     ;|
	LDA $000A,y       ;|
	STA $7EC64C,x     ;/
	PLB
	PLY
	PLX
	PLP
	RTL

pad $809A0D : warnpc $809A0E

org $809A4C
Draw2x2HUDIcon:

; Draw HUD Icon functions
; X = HUD offset
; Y = Tile Source
org $809A16 ; Super Missile
	LDY.w #SuperMissileHUDTilemap
	LDX #$0016
	BRA Draw2x2HUDIcon
org $809A26 ; Power Bomb
	LDY.w #PowerBombHUDTilemap
	LDX #$001A 
	BRA Draw3x2HUDIcon
org $809A36 ; Grapple
	LDY.w #GrappleHUDTilemap
	LDX #$0020 
	BRA Draw2x2HUDIcon
org $809A46 ; X-Ray
	LDY.w #XRayHUDTilemap
	LDX #$002A
	; fallthrough to Draw2x2HUDIcon


org $809AC9
	LDA $09CE ; LDA $09C8


org $80CD90 ; Thermal
print pc
DrawThermalHUDIcon:
	PHP
	PHX
	PHY
	PHB
	PHK         ;\
	PLB         ;} DB = $80
	REP #$30
	LDY.w #ThermalHUDTilemap 
	LDX #$0024  ; X = Thermal HUD tilemap destination offset
	JMP Draw3x2HUDIcon


org $90C4E4 : CMP #$0007
org $90C4FD : CMP #$0007

org $90C539
; Switched to HUD item handlers
	DW SwitchToBeam ; Nothing
	DW TestSwitchToMissile ; Missiles
	DW TestSwitchToSuper ; Super missiles
	DW TestSwitchToPB ; Power bombs
	DW TestSwitchToGrapple ; Grapple
	DW TestSwitchToThermal ; Thermal
	DW TestSwitchToXRay ; X-ray
}


;;; $C545: Switched to HUD item handler - nothing ;;;
	
SwitchToBeam:
	STZ $0CD0   ; Clear beam charge counter
	JSR $BCBE   ; Clear charge beam animation state
	JSL $91DEBA ; Load Samus' suit palette
	CLC         ;\
	RTS         ;} Return carry clear
	
TestSwitchToMissile:
	JSR CanUseMissile
	BNE SwitchToBeam ;} If [Samus' missiles] = 0:
	SEC         ;\
	RTS         ;} Return carry se

TestSwitchToSuper:
	JSR CanUseSuper
	BCS SwitchToBeam ;} If [Samus' missiles] = 0:
TestSwitchToSuper_Fail:
	SEC         ;\
	RTS         ;} Return carry se
	
TestSwitchToPB:
	JSR CanUsePB
	BCS SwitchToBeam ;} If [Samus' missiles] = 0:
TestSwitchToPB_Fail:	
	SEC         ;\
	RTS         ;} Return carry se
	
TestSwitchToGrapple:
	LDA $09A2   ;\
	BIT #$4000  ;} If not equipped grapple:
	BNE $02     ;/
	SEC         ;\
	RTS         ;} Return carry set

	LDA $0D32   ;\
	CMP #$C4F0  ;} If [grapple function] != inactive: return carry clear
	BNE $10     ;/
	JSL $91DEBA ; Load Samus' suit palette
	STZ $0CD0   ; Clear beam charge counter
	JSR $BCBE   ; Clear charge beam animation state
	LDA #$C4F0  ;\
	STA $0D32   ;} Grapple function = inactive

	CLC         ;\
	RTS         ;} Return carry clear
	
TestSwitchToXRay:
  JSL TestSwitchToXRay_2
  RTS

TestSwitchToThermal:
	LDA $09A4 ; collected items
	BIT !thermalbit
	BNE SwitchToBeam
	SEC         ;\
	RTS         ;} Return carry set

CanUseMissile:
	LDA $09CE
	BEQ CanUseMissile_Fail
	LDA $09C6   ;\
CanUseMissile_Fail:
	RTS
	
CanUseSuper:
	LDA $09CC  
	CLC
	BEQ CanUseSuper_Fail
	LDA $09C6   ;\
	CMP.w #5
CanUseSuper_Fail:
	RTS
	
CanUsePB:
	LDA $09D0  
	CLC
	BEQ CanUsePB_Fail
	LDA $09C6   ;\
	CMP.w #10
CanUsePB_Fail:	
	RTS         ;} Return carry se

pad $90C5C3 : warnpc $90C5C4

org $90BF3C 
	JSR CanUseSuper
	BCS $03
org $90C0A1
	JSR CanUsePB
	BCS $03
org $90BE8A
	JSR CanUseMissile
org $90BF35
	JSR CanUseMissile


org $809BCC : 
; $12 = sub-tank energy
; $14 = whole tanks full
; $16 = collected tanks
	STA $16
	LDA $09D4
	STA $18
	BEQ DrawETanksLoop
	LDA #$3010
	STA $7EC648

DrawETanksLoop:
	JSR GetEtankTile
	LDX $9CCE,y   ;} $7E:C608 + [$9CCE + [Y]] = [X] (write energy tank tile)
	STA $7EC608,x ;/
	INY           ;\
	INY           ;} Y += 2 (next energy tank index)
	CPY #$001C    ;\
	BMI DrawETanksLoop       ;} If [Y] < 1Ch: go to LOOP_ETANKS
warnpc $809BEE
padbyte $EA : pad $809BEE : padbyte $FF
org $809BEE
DrawEtanksEnd:	



org $80D100
SpaceJumpTilesFirst:
	DW $30A1, $30A2	
SpaceJumpTiles1:
	DW $3020, $3021
SpaceJumpTiles2:
	DW $3022, $3023, $3024

DrawSpaceJumpCounts:
	PHY
	LDA $09CA ; max
	AND #$000F
	INC
	STA $12
	SEC
	SBC $7FFDE0 ; cur used
	STA $14


DrawSpaceJumpCounts_First:
	LDA $09A2 
	BIT #$0200 ; space jump
	BNE .active

.zero
	LDA #$3C0F
	BRA .continue

.active
	LDA $12
	BEQ	.zero
	DEC $12

.one
	LDX.w #SpaceJumpTilesFirst

		LDA $14
		BEQ	+
		INX : INX
		DEC $14
	+
		LDA $0000,X

.continue
	TYX
	STA $7EC6B0


	LDY #$0000
DrawSpaceJumpCounts_Loop:
	LDA $09A2 
	BIT #$0200 ; space jump
	BNE DrawSpaceJumpCounts_Active
DrawSpaceJumpCounts_Zero:	
	LDA #$3C0F
	BRA DrawSpaceJumpCounts_Continue
DrawSpaceJumpCounts_Active:	

	LDA $12
	BEQ	DrawSpaceJumpCounts_Zero
	DEC $12
	BEQ DrawSpaceJumpCounts_One
	DEC $12

DrawSpaceJumpCounts_Two:
		LDX.w #SpaceJumpTiles2

		LDA $14
		BEQ	DrawSpaceJumpCounts_Two_Continue
		INX : INX
		DEC $14
		BEQ DrawSpaceJumpCounts_Two_Continue
		INX : INX
		DEC $14
	DrawSpaceJumpCounts_Two_Continue:
		LDA $0000,X
	BRA DrawSpaceJumpCounts_Continue

DrawSpaceJumpCounts_One:
	LDX.w #SpaceJumpTiles1

		LDA $14
		BEQ	DrawSpaceJumpCounts_One_Continue
		INX : INX
		DEC $14
	DrawSpaceJumpCounts_One_Continue:
		LDA $0000,X

DrawSpaceJumpCounts_Continue:
	TYX
	STA $7EC6B2,X
	INY : INY
	CPY #$0008
	BCC DrawSpaceJumpCounts_Loop

	PLY
	RTS


EtankTiles:
	  ;    Reserves
      ; None   Mid    End
	DW $3013, $3014, $3015 ; Full  \
	DW $3016, $3017, $3018 ; Empty } Etanks
	DW $3C0F, $3011, $3012 ; None  /

GetEtankTile:
	; Get Etank state row index
	LDA $14
	BEQ GetEtankTile_EmptyTanks
	LDX #$0000
	DEC $14
	DEC $16
	BRA GetEtankTile_Continue
GetEtankTile_EmptyTanks:
	LDX #$000C
	LDA $16
	BEQ GetEtankTile_Continue
	LDX #$0006
	DEC $16

GetEtankTile_Continue:
	; Get Reserve state row index
	LDA $18
	BEQ GetEtankTile_End
	INX : INX
	DEC A : STA $18
	BNE GetEtankTile_End
	INX : INX
GetEtankTile_End:
	LDA.w EtankTiles,X
	RTS


DRAW_MAX_MISSLES:
  LDA !maxmissiles
  CMP $0A0A
  BEQ OUT_2
  STA $0A0A
  LDX #$00A2
  JSR $9D78
  LDA #$3C1A
  STA $7EC6A8
OUT_2:
  RTS

DRAW_CHARGE:
  JSR DrawSpaceJumpCounts
  JSR DrawLogNotif
  LDA $0998
  CMP #$0003
  BNE DRAW_CHARGE_CHECK_BEAM
  RTS

DRAW_CHARGE_CHECK_BEAM:
  LDA $09A6 ;equipped beams
  BIT #$1000 ;charge beam
  BNE DRAW_CHARGE_CHECK_HYPER
ERASE_CHARGE:
  LDA #$000E
  STA $7EC698
  STA $7EC69A
  STA $7EC69C
  STA $7EC69E
  STA $7EC6A0
  RTS

DRAW_CHARGE_CHECK_HYPER:
  LDA $0A76 ;load hyper beam state
  BEQ DRAW_CHARGE_NORMAL

  LDA $09DA   ;\
  BIT #$0002  ;} If [in-game time frames] % 8 = 0:
  BNE DRAW_CHARD_HYPER_INDEX_1
DRAW_CHARD_HYPER_INDEX_0:
  LDA #$0000
  BRA DRAW_CHARGE_CONTINUE
DRAW_CHARD_HYPER_INDEX_1:
  LDA #$000D
  BRA DRAW_CHARGE_CONTINUE

DRAW_CHARGE_NORMAL:
  LDA $0CD0 ;charge value
  ASL
  ASL
  STA $00
  ASL
  CLC
  ADC $00
  STA $4204
  LDA $7ED840
  AND #$000F
  TAY
  LDA ACCEL_CHARGE_TABLE,Y
  AND #$00FF
  SEP #$20
  STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214 ;quotient

DRAW_CHARGE_CONTINUE:
  ASL
  ASL
  TAY

  LDA $09D2
  CMP #$0004
  BNE DRAW_CHARGE_CHECK_BEAM_SELECTED
  LDY #$0000

DRAW_CHARGE_CHECK_BEAM_SELECTED:
  LDA $09D2
  BEQ BEAM_SELECTED
  LDA #$1400
  STA $00  
  BRA DRAW_CHARGE_TILES
BEAM_SELECTED:
  LDA #$1000
  STA $00

DRAW_CHARGE_TILES:
  LDA #$0025
  ORA $00
  STA $7EC698
  
  LDA CHARGE_BAR_TABLE,Y
  AND #$00FF
  ORA $00
  STA $7EC69A
  INY
  
  LDA CHARGE_BAR_TABLE,Y
  AND #$00FF
  ORA $00
  STA $7EC69C
  INY
  
  LDA CHARGE_BAR_TABLE,Y
  AND #$00FF
  ORA $00
  STA $7EC69E

  LDA #$4025
  ORA $00
  STA $7EC6A0

  RTS

ACCEL_CHARGE_TABLE:
  DB #$78, #$69, #$5A, #$4B, #$3C, #$2D, #$1E, #$0F, #$02

CHARGE_BAR_TABLE:
  DB #$26, #$26, #$26, #$00
  DB #$27, #$26, #$26, #$00
  DB #$28, #$26, #$26, #$00
  DB #$29, #$26, #$26, #$00
  DB #$2A, #$26, #$26, #$00
  DB #$2A, #$27, #$26, #$00
  DB #$2A, #$28, #$26, #$00
  DB #$2A, #$29, #$26, #$00
  DB #$2A, #$2A, #$26, #$00
  DB #$2A, #$2A, #$27, #$00
  DB #$2A, #$2A, #$28, #$00
  DB #$2A, #$2A, #$29, #$00
  DB #$2A, #$2A, #$2A, #$00
  DB #$2B, #$2B, #$2B, #$00 ;Hyper

LogNotif:
	DW $3C89, $3C8A, $3C8B
	DW $3C99, $3C9A, $3C9B

DrawLogNotif:
print pc
	LDA $00
	PHA

	LDA !notif_timer
	BEQ .return
	DEC
	BEQ .setblank
	BMI .setblank
	STA !notif_timer

	STZ $00
	BIT #$000F ; don't update on non-changing frames
	BNE .return
.setcolor
	BIT #$0010
	BEQ +
	LDA #$0003
	STA $00
+

	LDX #$0004
-
	LDA.w LogNotif,X
	CLC : ADC $00
	STA $7EC636,x
	LDA.w LogNotif+6,X
	CLC : ADC $00
	STA $7EC676,x
	DEX : DEX
	BPL -
	BRA .return
.setblank
	LDA #$0000
	STA !notif_timer
	LDA #$000E
	STA $7EC636
	STA $7EC676
	STA $7EC638
	STA $7EC678
	LDA #$7C1E
	STA $7EC63A
	STA $7EC67A
.return
	PLA
	STA $00
	RTS

TestSwitchToXRay_2:
	LDA $09A2   ;\
	BIT #$8000  ;} If not equipped x-ray:
	BEQ SkipXray
	BIT !thermalbit
	BEQ SelectXray:
SkipXray:
	SEC
	RTL
SelectXray:
  PLA
  PEA.w SwitchToBeam
	RTL
