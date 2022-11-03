lorom

!ElevatorEvent     = $0080
!ElevatorEventByte = $7ED830

macro map_bit(area, s, x, y, b)
!offset = <s><<5+<y><<5+<x>
DB <area>, !offset>>3, 128>><b>
endmacro


;draw ship
org $82B777
; smart repoints some values here, so this just skips over all of that
	JSL DrawShipSprite
	BRA DrawShipSpriteEnd_A
org $82B796
DrawShipSpriteEnd_A:

org $82B6BC
; smart repoints some values here, so this just skips over all of that
	JSL DrawShipSprite
	BRA DrawShipSpriteEnd_B
org $82B6DB
DrawShipSpriteEnd_B:


org $80CD07
SetElevatorUsed:
	PHP
	PHB
	PHK
	PLB
	REP #$30
	LDA $079F              ;\
	ASL A                  ;|
	TAX                    ;|
	LDA $0793              ;|
	AND #$000F             ;|
	DEC A                  ;} Y = [$CD46 + [area index] * 2] + (([door bitflags] & Fh) - 1) * 2
	ASL A                  ;|
	CLC                    ;|
	ADC.w ElevatorBitList,x
	TAX                    ;/
	LDY $0000,X
	LDA #$0000             ; Clear A high
	SEP #$20
	LDA $0000,y            ;\
	TAX                    ;|
	LDA $0001,y            ;} $7E:D8F8 + [[Y]] |= [[Y] + 1] (set source elevator as used)
	ORA !ElevatorEventByte,X
	STA !ElevatorEventByte,X
	LDA $0002,y            ;\
	TAX                    ;|
	LDA $0003,y            ;} $7E:D8F8 + [[Y] + 2] |= [[Y] + 3] (set destination elevator as used)
	ORA !ElevatorEventByte,X
	STA !ElevatorEventByte,X

.loop
	LDA $0004,Y
	BMI .return
	CMP $079F
	BEQ .sameArea
.differentArea
	XBA
	LDA $0005,Y
	TAX
	LDA $0006,Y
	ORA $7ECD52,X
	STA $7ECD52,X
	BRA .nextLoop
.sameArea
	LDA #$00
	XBA
	LDA $0005,Y
	TAX
	LDA $0006,Y
	ORA $07F7,X
	STA $07F7,X
.nextLoop
	INY : INY : INY
	BRA .loop

.return
	PLB
	PLP
	RTL

org $80D600
DrawShipSprite:
	LDA $079F ; area
	BEQ .crateria
	CMP #$0006
	BNE .return

.ceres
	LDA #$0E00 ; set palette
	STA $03
	LDA #$00C8 ; x
	SEC
	SBC $B1
	TAX
	LDA #$0068 ; y
	SEC
	SBC $B3
	TAY
	BRA .draw

.crateria
	LDA #$001D
	JSL $808233 ; test event
	BCC .return

	; draw crashed ship
	LDA #$0000 ; set palette
	STA $03
	LDA #$0076 ; x
	SEC
	SBC $B1
	TAX
	LDA #$0051 ; y
	SEC
	SBC $B3
	TAY
	LDA #$0081 ; sprite
	JSL DrawElevatorSprite

	LDA #$0E00 ; set palette
	STA $03
	LDA #$0118 ; x
	SEC
	SBC $B1
	TAX
	LDA #$0040 ; y
	SEC
	SBC $B3
	TAY

.draw
	LDA #$0063 ; sprite
	JSL $81891F
.return
	RTL


ElevatorBitList:
	DW #Area0Elevators, #Area1Elevators, #Area2Elevators, #Area3Elevators
	DW #Area4Elevators, #Area5Elevators, #Area6Elevators, #Area7Elevators

Area0Elevators:
	DW #Elevator_Oceania_Caves
	DW #Elevator_Oceania_Rail
	DW #Elevator_Oceania_Mine
	DW #Elevator_Oceania_ShipR
	DW #Elevator_Oceania_ShipD
	DW #Elevator_Oceania_Suzi
Area1Elevators:
	DW #Elevator_Oceania_Caves
	DW #Elevator_Oceania_Rail
	DW #Elevator_Caves_Lab
	DW #Elevator_Service_Lab
	DW #Elevator_Spore_Mine
	DW #Elevator_Service_Mine
	DW #Elevator_Service_Hive
	DW #Elevator_Rail_SkyL
	DW #Elevator_Rail_SkyR
	DW #Elevator_Rail_Lomyr
Area2Elevators:
	DW #Elevator_Oceania_Mine
	DW #Elevator_Spore_Mine
	DW #Elevator_Service_Mine
	DW #Elevator_Service_Hive
	DW #Elevator_Fire_Life
	DW #Elevator_Plant_Peak
	DW #Elevator_Mine_Lake
Area3Elevators:
	DW #Elevator_Caves_Lab
	DW #Elevator_Service_Lab
	DW #Elevator_Rail_Lomyr
	DW #Elevator_Fire_Life
	DW #Elevator_Lomyr_Space
Area4Elevators:
	DW #Elevator_Rail_SkyL
	DW #Elevator_Rail_SkyR
	DW #Elevator_Plant_Peak
Area5Elevators:
	DW #Elevator_Oceania_Suzi
	DW #Elevator_Suzi_Thunder
Area6Elevators:
	DW #Elevator_Lomyr_Space
	DW #Elevator_Oceania_Space
Area7Elevators:
	DW #Elevator_Oceania_ShipR
	DW #Elevator_Oceania_ShipD

Elevator_Oceania_Caves:
	DB $00, $01, $02, $01 ; elevator events
	%map_bit(0,1,$07,$0A,7)
	%map_bit(0,1,$09,$0A,1)
	%map_bit(1,0,$02,$0E,2)
	%map_bit(1,0,$01,$0C,1)
	DB $FF
Elevator_Oceania_Rail:
	DB $00, $02, $02, $02 ; elevator events
	%map_bit(0,1,$07,$03,7)
	%map_bit(0,1,$08,$01,0)
	%map_bit(1,0,$03,$07,3)
	%map_bit(1,0,$02,$09,2)
	DB $FF
Elevator_Oceania_Mine:
	DB $00, $04, $04, $01 ; elevator events
	%map_bit(0,0,$1D,$14,5)
	%map_bit(0,0,$1E,$16,6)
	%map_bit(2,0,$03,$04,3)
	%map_bit(2,0,$02,$03,2)
	DB $FF
Elevator_Oceania_ShipR:
	DB $00, $00, $0E, $01 ; elevator events
	%map_bit(7,0,$13,$0C,3)
	DB $FF
Elevator_Oceania_ShipD:
	DB $00, $00, $0E, $02 ; elevator events
	%map_bit(7,0,$0F,$0F,7)
	DB $FF
Elevator_Caves_Lab:
	DB $02, $04, $06, $01 ; elevator events
	%map_bit(1,0,$1C,$0C,4)
	%map_bit(1,0,$1F,$0C,7)
	%map_bit(3,0,$0B,$0D,3)
	%map_bit(3,0,$08,$0D,0)
	DB $FF
Elevator_Service_Lab:
	DB $02, $08, $06, $02 ; elevator events
	%map_bit(1,1,$00,$11,0)
	%map_bit(1,1,$03,$11,3)
	%map_bit(3,0,$0F,$12,7)
	%map_bit(3,0,$0C,$13,4)
	DB $FF
Elevator_Spore_Mine:
	DB $02, $10, $04, $02 ; elevator events
	%map_bit(1,0,$07,$18,7)
	%map_bit(1,0,$06,$1A,6)
	%map_bit(2,0,$11,$03,1)
	%map_bit(2,0,$10,$01,0)
	DB $FF
Elevator_Service_Mine:
	DB $02, $20, $04, $04 ; elevator events
	%map_bit(1,0,$0C,$18,4)
	%map_bit(1,0,$0B,$1A,3)
	%map_bit(2,0,$16,$05,6)
	%map_bit(2,0,$15,$03,5)
	DB $FF
Elevator_Service_Hive:
	DB $02, $40, $04, $08 ; elevator events
	%map_bit(1,0,$11,$18,1)
	%map_bit(1,0,$10,$1A,0)
	%map_bit(2,0,$1B,$02,3)
	%map_bit(2,0,$1A,$01,2)
	DB $FF
Elevator_Rail_SkyL:
	DB $02, $80, $08, $01 ; elevator events
	%map_bit(1,0,$05,$02,5)
	%map_bit(1,0,$04,$01,4)
	%map_bit(4,0,$10,$0E,0)
	%map_bit(4,0,$0F,$10,7)
	DB $FF
Elevator_Rail_SkyR:
	DB $03, $01, $08, $02 ; elevator events
	%map_bit(1,0,$13,$02,3)
	%map_bit(1,0,$12,$01,2)
	%map_bit(4,0,$1E,$0E,6)
	%map_bit(4,0,$1D,$10,5)
	DB $FF
Elevator_Rail_Lomyr:
	DB $03, $02, $06, $04 ; elevator events
	%map_bit(1,0,$1D,$07,5)
	%map_bit(1,1,$00,$07,0)
	%map_bit(3,0,$0C,$08,4)
	%map_bit(3,0,$09,$07,1)
	DB $FF
Elevator_Plant_Peak:
	DB $04, $10, $08, $04 ; elevator events
	%map_bit(2,1,$02,$0B,2)
	%map_bit(2,1,$06,$0E,6)
	%map_bit(4,1,$03,$12,3)
	%map_bit(4,1,$04,$14,4)
	DB $FF
Elevator_Fire_Life:
	DB $04, $20, $06, $08 ; elevator events
	%map_bit(2,1,$1B,$07,3)
	%map_bit(2,1,$1C,$05,4)
	%map_bit(3,1,$01,$1C,1)
	%map_bit(3,1,$00,$1E,0)
	DB $FF
Elevator_Lomyr_Space:
	DB $06, $10, $0C, $01 ; elevator events
	%map_bit(3,0,$11,$01,1)
	%map_bit(3,0,$14,$02,4)
	%map_bit(6,0,$19,$1A,1)
	%map_bit(6,0,$18,$1C,0)
	DB $FF
Elevator_Oceania_Space:
	DB $00, $08, $00, $00 ; elevator events
	DB $FF
Elevator_Oceania_Suzi:
	DB $00, $10, $0A, $01
	%map_bit(0,0,$02,$15,2)
	%map_bit(0,0,$03,$15,3)
	%map_bit(0,0,$04,$15,4)
	%map_bit(0,0,$02,$17,2)
	%map_bit(5,1,$1C,$18,4)
	%map_bit(5,1,$1E,$1A,6)
	DB $FF
Elevator_Suzi_Thunder:
	DB $0A, $02, $00, $00
	%map_bit(5,0,$1B,$0C,3)
	%map_bit(5,0,$1B,$0B,3)
	%map_bit(5,0,$1B,$0A,3)
	DB $FF
Elevator_Mine_Lake:
	DB $04, $40, $00, $00
	%map_bit(2,0,$07,$0C,7)
	DB $FF
warnpc $80FFC0


org $82BB3A
	LDA $079F
	ASL : ASL : ASL : ASL
	CLC : ADC #!ElevatorEvent
	PHA
;$82:BB3A AE 9F 07    LDX $079F  [$7E:079F]  ;\
;$82:BB3D BF 08 D9 7E LDA $7ED908,x[$7E:D908];|
;$82:BB41 29 FF 00    AND #$00FF             ;} If not obtained current area map: return
;$82:BB44 F0 2D       BEQ $2D    [$BB73]     ;/

org $82BB4F 
.loop
	JMP CheckElevatorBit
Elevator_loop_continue:
	BEQ Elevator_loop_return
	BCC Elevator_loop_loopNext
	NOP
;$82:BB4F BD 00 00    LDA $0000,x[$82:C759]  ;\
;$82:BB52 C9 FF FF    CMP #$FFFF             ;} If [[X]] = FFFFh: return
;$82:BB55 F0 1C       BEQ $1C    [$BB73]     ;/

org $82BB67
	JSL DrawElevatorSprite

org $82BB6C
Elevator_loop_loopNext:

org $82BB73
Elevator_loop_return:

;; Spritemap 59h: elevator destination - Crateria
org $82C4DB
CheckElevatorBit:
	LDA $0000,X
	CMP #$FFFF
	BNE +
	PLA
	SEP #$02 ; set zero
	JMP Elevator_loop_continue
+
	TAY
	PLA : INC : PHA : DEC
	JSL $808233 ; check event
	TYA
	BCS +
	TXA
+
	REP #$02 ; clear zero
	JMP Elevator_loop_continue

warnpc $82C569 ; sprite pointers


org $97F000
DrawElevatorSprite:
	CMP #$0080
	BPL +
	JML $81891F
+
	SEC : SBC #$0080
	PHB
	PEA $9700
	PLB
	PLB
	STY $12                ; $12 = [Y] (Y position of spritemap centre)
	STX $14                ; $14 = [X] (X position of spritemap centre)
	ASL A                  ;\
	TAX                    ;} Y = [$82:C569 + [A] * 2] (address of spritemap)
	LDY.w SpriteList,x       ;/
	JML $81892E

SpriteList:
;org $82C631B
    DW #SPACE_PORT                ; Sprite #80
    DW #CARGO_SHIP                ; Sprite #81
    DW #PIRATE_LAB                ; Sprite #82
    DW #CARGO_RAIL                ; Sprite #83
    DW #LIFE_TEMPLE               ; Sprite #84
    DW #FIRE_TEMPLE               ; Sprite #85
	DW #OCEANIA                   ; Sprite #86
	DW #LOMYR_VALLEY              ; Sprite #87
	DW #VULNAR_PEAKS              ; Sprite #88
	DW #VULNAR_CAVES              ; Sprite #89
	DW #SERVICE_SECTOR            ; Sprite #8A
	DW #SPORE_FIELD               ; Sprite #8B
	DW #VERDITE_MINE              ; Sprite #8C
	DW #THE_HIVE                  ; Sprite #8D
	DW #ENERGY_PLANT              ; Sprite #8E
	DW #SUZI_ISLAND               ; Sprite #8F
	DW #SKY_TEMPLE                ; Sprite #90
;warnpc $82C749


!tile_A = $2200
!tile_B = $2201
!tile_C = $2202
!tile_D = $2203
!tile_E = $2204
!tile_F = $2205
!tile_G = $2206
!tile_H = $2207
!tile_I = $2208
!tile_K = $2209
!tile_L = $2217
!tile_M = $2218
!tile_N = $2219
!tile_O = $22B4
!tile_P = $22B5
!tile_R = $2210
!tile_S = $2212
!tile_T = $2213
!tile_U = $2214
!tile_V = $2215
!tile_Y = $2216
!tile_Z = $6212

!h_flip = $4000
!v_flip = $8000
!tile_corner = $22B6
!tile_h_pipe = $22C4
!tile_v_pipe = $22C5
!tile_d_pipe = $22C6
!tile_bend__ = $22C7

;org $82F800
OCEANIA:
	DW 7
	DW 00 : DB 0 : DW !tile_O
	DW 04 : DB 0 : DW !tile_C
	DW 08 : DB 0 : DW !tile_E
	DW 12 : DB 0 : DW !tile_A
	DW 16 : DB 0 : DW !tile_N
	DW 21 : DB 0 : DW !tile_I
	DW 23 : DB 0 : DW !tile_A

LOMYR_VALLEY:
	DW 11
	DW 00 : DB 0 : DW !tile_L
	DW 03 : DB 0 : DW !tile_O
	DW 07 : DB 0 : DW !tile_M
	DW 13 : DB 0 : DW !tile_Y
	DW 17 : DB 0 : DW !tile_R
;      21

	DW 00 : DB 7 : DW !tile_V
	DW 04 : DB 7 : DW !tile_A
	DW 08 : DB 7 : DW !tile_L
	DW 11 : DB 7 : DW !tile_L
	DW 14 : DB 7 : DW !tile_E
	DW 18 : DB 7 : DW !tile_Y
;	   22

VULNAR_PEAKS:
	DW 11
	DW 00 : DB 0 : DW !tile_V
	DW 04 : DB 0 : DW !tile_U
	DW 08 : DB 0 : DW !tile_L
	DW 11 : DB 0 : DW !tile_N
	DW 16 : DB 0 : DW !tile_A
	DW 20 : DB 0 : DW !tile_R
;      24

	DW 00+2 : DB 7 : DW !tile_P
	DW 04+2 : DB 7 : DW !tile_E
	DW 08+2 : DB 7 : DW !tile_A
	DW 12+2 : DB 7 : DW !tile_K
	DW 16+2 : DB 7 : DW !tile_S
;      20

VULNAR_CAVES:
	DW 11
	DW 00 : DB 0 : DW !tile_V
	DW 04 : DB 0 : DW !tile_U
	DW 08 : DB 0 : DW !tile_L
	DW 11 : DB 0 : DW !tile_N
	DW 16 : DB 0 : DW !tile_A
	DW 20 : DB 0 : DW !tile_R
;      24

	DW 00+2 : DB 7 : DW !tile_C
	DW 04+2 : DB 7 : DW !tile_A
	DW 08+2 : DB 7 : DW !tile_V
	DW 12+2 : DB 7 : DW !tile_E
	DW 16+2 : DB 7 : DW !tile_S
;      20

SERVICE_SECTOR:
	DW 13
	DW 00 : DB 0 : DW !tile_S
	DW 04 : DB 0 : DW !tile_E
	DW 08 : DB 0 : DW !tile_R
	DW 12 : DB 0 : DW !tile_V
	DW 16 : DB 0 : DW !tile_I
	DW 18 : DB 0 : DW !tile_C
	DW 22 : DB 0 : DW !tile_E
;      26

	DW 00+1 : DB 7 : DW !tile_S
	DW 04+1 : DB 7 : DW !tile_E
	DW 08+1 : DB 7 : DW !tile_C
	DW 12+1 : DB 7 : DW !tile_T
	DW 16+1 : DB 7 : DW !tile_O
	DW 20+1 : DB 7 : DW !tile_R
;      24

SPORE_FIELD:
	DW 10
	DW 00 : DB 0 : DW !tile_S
	DW 04 : DB 0 : DW !tile_P
	DW 08 : DB 0 : DW !tile_O
	DW 12 : DB 0 : DW !tile_R
	DW 16 : DB 0 : DW !tile_E
;      20

	DW 00+1 : DB 7 : DW !tile_F
	DW 04+1 : DB 7 : DW !tile_I
	DW 06+1 : DB 7 : DW !tile_E
	DW 10+1 : DB 7 : DW !tile_L
	DW 13+1 : DB 7 : DW !tile_D
;      17

VERDITE_MINE:
	DW 11
	DW 00 : DB 0 : DW !tile_V
	DW 04 : DB 0 : DW !tile_E
	DW 08 : DB 0 : DW !tile_R
	DW 12 : DB 0 : DW !tile_D
	DW 16 : DB 0 : DW !tile_I
	DW 18 : DB 0 : DW !tile_T
	DW 22 : DB 0 : DW !tile_E
;      26

	DW 00+4 : DB 7 : DW !tile_M
	DW 06+4 : DB 7 : DW !tile_I
	DW 08+4 : DB 7 : DW !tile_N
	DW 13+4 : DB 7 : DW !tile_E
;      17

THE_HIVE:
	DW 7
	DW 00+1 : DB 0 : DW !tile_T
	DW 04+1 : DB 0 : DW !tile_H
	DW 08+1 : DB 0 : DW !tile_E
;      12

	DW 00 : DB 7 : DW !tile_H
	DW 04 : DB 7 : DW !tile_I
	DW 06 : DB 7 : DW !tile_V
	DW 10 : DB 7 : DW !tile_E
;      14

ENERGY_PLANT:
	DW 11
	DW 00 : DB 0 : DW !tile_E
	DW 04 : DB 0 : DW !tile_N
	DW 09 : DB 0 : DW !tile_E
	DW 13 : DB 0 : DW !tile_R
	DW 17 : DB 0 : DW !tile_G
	DW 22 : DB 0 : DW !tile_Y
;      26

	DW 00+2 : DB 7 : DW !tile_P
	DW 04+2 : DB 7 : DW !tile_L
	DW 08+2 : DB 7 : DW !tile_A
	DW 12+2 : DB 7 : DW !tile_N
	DW 17+2 : DB 7 : DW !tile_T
;      21

SPACE_PORT:
	DW 9
	DW 00 : DB 0 : DW !tile_S
	DW 04 : DB 0 : DW !tile_P
	DW 08 : DB 0 : DW !tile_A
	DW 12 : DB 0 : DW !tile_C
	DW 16 : DB 0 : DW !tile_E
;      20

	DW 00+2 : DB 7 : DW !tile_P
	DW 04+2 : DB 7 : DW !tile_O
	DW 08+2 : DB 7 : DW !tile_R
	DW 12+2 : DB 7 : DW !tile_T
;      16


CARGO_SHIP:
	DW 32
;top
	DW $00+1 : DB $08   : DW !tile_v_pipe
	DW $00+1 : DB $08-3 : DW !tile_corner
	DW $08   : DB $08-3 : DW !tile_h_pipe
	DW $10   : DB $08-3 : DW !tile_h_pipe
	DW $18   : DB $08-3 : DW !tile_corner|!h_flip|!v_flip
	DW $18   : DB $00-3 : DW !tile_corner
	DW $20   : DB $00-3 : DW !tile_h_pipe
	DW $28   : DB $00-3 : DW !tile_h_pipe
	DW $30-4 : DB $00-3 : DW !tile_bend__|!v_flip
	DW $37-4 : DB $07-3 : DW !tile_d_pipe|!v_flip

	DW $3A   : DB $0B   : DW !tile_bend__|!h_flip
	DW $41   : DB $0B   : DW !tile_corner|!h_flip
	DW $41   : DB $13   : DW !tile_corner|!h_flip|!v_flip
	DW $3B   : DB $13   : DW !tile_bend__|!h_flip|!v_flip

;bottom
	DW $38-2 : DB $18   : DW !tile_d_pipe
	DW $30-1 : DB $20-1 : DW !tile_bend__
	DW $28-1 : DB $20-1 : DW !tile_h_pipe
	DW $20-1 : DB $20-1 : DW !tile_h_pipe
	DW $18-1 : DB $20-1 : DW !tile_h_pipe
	DW $10-1 : DB $20-1 : DW !tile_bend__|!h_flip
	DW $08   : DB $18   : DW !tile_bend__|!v_flip
	DW $00+1 : DB $18   : DW !tile_corner|!v_flip
	DW $00+1 : DB $10   : DW !tile_v_pipe



;text
	DW 00+$1C : DB 0+$0C : DW !tile_C
	DW 04+$1C : DB 0+$0C : DW !tile_A
	DW 08+$1C : DB 0+$0C : DW !tile_R
	DW 12+$1C : DB 0+$0C : DW !tile_G
	DW 17+$1C : DB 0+$0C : DW !tile_O
;      21

	DW 00+3+$1C : DB 7+$0C : DW !tile_S
	DW 04+3+$1C : DB 7+$0C : DW !tile_H
	DW 08+3+$1C : DB 7+$0C : DW !tile_I
	DW 10+3+$1C : DB 7+$0C : DW !tile_P
;      14

PIRATE_LAB:
	DW 9
	DW 00 : DB 0 : DW !tile_P
	DW 04 : DB 0 : DW !tile_I
	DW 06 : DB 0 : DW !tile_R
	DW 10 : DB 0 : DW !tile_A
	DW 14 : DB 0 : DW !tile_T
	DW 18 : DB 0 : DW !tile_E
;      22

	DW 00+5 : DB 7 : DW !tile_L
	DW 04+5 : DB 7 : DW !tile_A
	DW 08+5 : DB 7 : DW !tile_B
;      12

CARGO_RAIL:
	DW 9
	DW 00 : DB 0 : DW !tile_C
	DW 04 : DB 0 : DW !tile_A
	DW 08 : DB 0 : DW !tile_R
	DW 12 : DB 0 : DW !tile_G
	DW 17 : DB 0 : DW !tile_O
;      21

	DW 00+4 : DB 7 : DW !tile_R
	DW 04+4 : DB 7 : DW !tile_A
	DW 08+4 : DB 7 : DW !tile_I
	DW 10+4 : DB 7 : DW !tile_L
;      14


LIFE_TEMPLE:
	DW 10
	DW 00+6 : DB 0 : DW !tile_L
	DW 04+6 : DB 0 : DW !tile_I
	DW 06+6 : DB 0 : DW !tile_F
	DW 10+6 : DB 0 : DW !tile_E
;      14

	DW 00 : DB 7 : DW !tile_T
	DW 04 : DB 7 : DW !tile_E
	DW 08 : DB 7 : DW !tile_M
	DW 14 : DB 7 : DW !tile_P
	DW 18 : DB 7 : DW !tile_L
	DW 22 : DB 7 : DW !tile_E
;      26

FIRE_TEMPLE:
	DW 10
	DW 00+6 : DB 0 : DW !tile_F
	DW 04+6 : DB 0 : DW !tile_I
	DW 06+6 : DB 0 : DW !tile_R
	DW 10+6 : DB 0 : DW !tile_E
;      14

	DW 00 : DB 7 : DW !tile_T
	DW 04 : DB 7 : DW !tile_E
	DW 08 : DB 7 : DW !tile_M
	DW 14 : DB 7 : DW !tile_P
	DW 18 : DB 7 : DW !tile_L
	DW 22 : DB 7 : DW !tile_E
;      26

SUZI_ISLAND:
	DW 10
	DW 00+4 : DB 0 : DW !tile_S
	DW 04+4 : DB 0 : DW !tile_U
	DW 05+4 : DB 0 : DW !tile_Z
	DW 12+4 : DB 0 : DW !tile_I

	DW 00 : DB 7 : DW !tile_I
	DW 02 : DB 7 : DW !tile_S
	DW 06 : DB 7 : DW !tile_L
	DW 09 : DB 7 : DW !tile_A
	DW 13 : DB 7 : DW !tile_N
	DW 18 : DB 7 : DW !tile_D

SKY_TEMPLE:
	DW 9
	DW 00+8 : DB 0 : DW !tile_S
	DW 04+8 : DB 0 : DW !tile_K
	DW 08+8 : DB 0 : DW !tile_Y

	DW 00 : DB 7 : DW !tile_T
	DW 04 : DB 7 : DW !tile_E
	DW 08 : DB 7 : DW !tile_M
	DW 14 : DB 7 : DW !tile_P
	DW 18 : DB 7 : DW !tile_L
	DW 22 : DB 7 : DW !tile_E



print pc

warnpc $BCFFFF
