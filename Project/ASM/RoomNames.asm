lorom

; Add room names to the HUD
;org $FFFFFF
;  JSL DrawRoomName

!AreaRoomNameTable = $DFD502
!AreaRoomNameBank = $DF0000


!RoomNameState    = $7EFD00
!RoomNameSize     = $7EFD02
!RoomNameTimer    = $7EFD04
!RoomNameGFX      = $7EFD06
!RoomNameGFX_prev = $7EFD08
!RoomNameOffset   = $7EFD0A
!RoomNameOAM      = $7EFD0C ; size = 0x20 * 5 + 2 = 0xA2

!AreaNameState    = $7EFE00
!AreaNameSize     = $7EFE02
!AreaNameTimer    = $7EFE04
!AreaNameY        = $7EFE06
!AreaNameIndex    = $7EFE08
!AreaNamePrev     = $7EFE0A
!AreaNameOverride = $7EFE0C
!AreaNameOAM      = $7EFE0E

!hyper_active = $7FFD72

;;; $818A5F: Add spritemap to OAM ;;;
;; Parameters:
;;     DB:YYYY = address of first entry in spritemap
;;     $12     = Y position of spritemap centre
;;     $14     = X position of spritemap centre
;;     $18     = number of entries
;
; Spritemap format is roughly:
;     nnnn         ; Number of entries (2 bytes)
;     xxxx yy aatt ; Entry 0 (5 bytes)
;     ...          ; Entry 1...
; Where:
;     n = number of entries
;     x = X offset of sprite from centre
;     y = Y offset of sprite from centre
;     a = attributes
;     t = tile number

; More specifically, a spritemap entry is:
;     s000000xxxxxxxxx yyyyyyyy YXppPPPttttttttt
; Where:
;     s = size bit
;     x = X offset of sprite from centre
;     y = Y offset of sprite from centre
;     Y = Y flip
;     X = X flip
;     P = palette
;     p = priority (relative to background)
;     t = tile number

org $9AD200
  incbin ROMProject/Graphics/common_sprites.gfx

;org $82DF62
;  JSL LoadName
;  NOP : NOP

org $82E4E0
  JSL LoadName_Room

org $A08CDE 
  LDA #$7800 ;LDA #$7000
org $A08CE4
  LDX #$7000 ;LDX #$6C00

org $8280F3
  LDA #$0005 ;LDA #$0006
org $828146
  LDA #$0005 ;LDA #$0006

org $82805F
  JSL LoadName_Init


org $A08855
  JSL DrawName

org $8ABC00
DrawName:
  PHP : PHB
  PEA $7E7E
  PLB : PLB

  LDA #$0008 ; X
  STA $14
  LDA #$00D0 ; Y
  STA $12

  LDY.w #!RoomNameOAM ;+2

  LDA !RoomNameState 
  BEQ .timerState0
  CMP #$0001
  BEQ .timerState1
  CMP #$0002
  BEQ .timerState2
  BRA .return

.timerState0
  DEC.w !RoomNameTimer
  BPL .draw

  LDA !RoomNameOAM
  CMP !RoomNameSize
  BPL .timerState0_next

.timerState0_continue
  INC
  STA !RoomNameOAM
  LDA #$0001
  STA !RoomNameTimer
  BRA .draw  

.timerState0_next
  INC !RoomNameState
  LDA #$0100
  STA !RoomNameTimer
  BRA .draw  

.timerState1
  DEC.w !RoomNameTimer
  BPL .draw

  INC !RoomNameState
  LDA #$0020
  STA !RoomNameTimer
  BRA .draw

.timerState2
  LDA #$00F0 ; Y
  SEC : SBC.w !RoomNameTimer
  STA $12
  DEC.w !RoomNameTimer
  BPL .draw

  INC !RoomNameState
  BRA .return

.draw
  ;LDA !RoomNameOAM
  ;STA $18

  ;;     DB:YYYY = address of first entry in spritemap
  ;;     $12     = Y position of spritemap centre
  ;;     $14     = X position of spritemap centre
  ;;     $18     = number of entries
  ;JSL $818A5F


  ;;; $879F: Add spritemap to OAM ;;;
  ;;     DB:YYYY = address of spritemap
  ;;     $12     = Y position of spritemap centre
  ;;     $14     = X position of spritemap centre
  ;;     $16     = palette bits of sprite (palette * 200h)
  LDA #$3000
  STA $16
  JSL $81879F

.return
  LDA $0998
  CMP #$0027
  BPL +
  JSR DrawArea
+

  PLB : PLP

  ; displaced code
  JSL $B4BD32 ; Draw sprite objects
  RTL


DrawArea:
  LDY.w #!AreaNameOAM ;+2

  LDA #$0008 ; X
  STA $14
  LDA #$00C6 ; Y
  STA $12

  LDA !AreaNameState 
  BEQ .timerState0
  CMP #$0001
  BEQ .timerState1
  CMP #$0002
  BEQ .timerState2
  BRA .return

.timerState0
  DEC.w !AreaNameTimer
  BPL .draw

  LDA !AreaNameOAM
  CMP !AreaNameSize
  BPL .timerState0_next

.timerState0_continue
  INC
  STA !AreaNameOAM
  LDA #$0020
  STA !AreaNameTimer
  BRA .draw  

.timerState0_next
  INC !AreaNameState
  LDA #$0200
  STA !AreaNameTimer
  BRA .draw  

.timerState1
  DEC.w !AreaNameTimer
  BPL .draw

  INC !AreaNameState
  LDA #$0000
  STA !AreaNameTimer
  BRA .draw

.timerState2
  INC.w !AreaNameTimer
  LDA #$0008 ; X
  SEC : SBC.w !AreaNameTimer
  STA $14
  LDA.w !AreaNameTimer
  CMP #$0080
  BMI .draw

  INC !AreaNameState
  BRA .return

.draw
  ;LDA !RoomNameOAM
  ;STA $18

  ;;     DB:YYYY = address of first entry in spritemap
  ;;     $12     = Y position of spritemap centre
  ;;     $14     = X position of spritemap centre
  ;;     $18     = number of entries
  ;JSL $818A5F


  ;;; $879F: Add spritemap to OAM ;;;
  ;;     DB:YYYY = address of spritemap
  ;;     $12     = Y position of spritemap centre
  ;;     $14     = X position of spritemap centre
  ;;     $16     = palette bits of sprite (palette * 200h)
  LDA #$3000
  STA $16
  JSL $81879F

.return
  RTS


; A = vram dest
LoadGraphics:
  STA $05BE
  
  LDA #$9A00 ; wram source
  STA $05C1
  LDA #$EC00
  STA $05C0

  LDA #$0400 ; size
  STA $05C3

.checkNMI
  LDA $84
  AND #$0080
  BEQ .gameLoad
.doorTransition
  LDA #$8000
  TSB $05BC
- LDA $05BC
  BMI -
  BRA .return
.gameLoad
  SEP #$20
  LDX $05BE  ;\
  STX $2116  ;} VRAM address = [door transition VRAM update destination]
  LDX #$1801 ;\
  STX $4310  ;} DMA 1 control / target = 16-bit VRAM write
  LDX $05C0  ;\
  STX $4312  ;|
  LDA $05C2  ;} DMA 1 source address = [door transition VRAM update source]
  STA $4314  ;/
  LDX $05C3  ;\
  STX $4315  ;} DMA 1 size = [door transition VRAM update size]
  LDA #$80   ;\
  STA $2115  ;} VRAM address increment mode = 16-bit access
  LDA #$02   ;\
  STA $420B  ;} Enable DMA 1
  LDA #$80   ;\
  REP #$20
.return
  RTS


LoadGraphicsSpecial:
  STZ $14
  LDA !RoomNameGFX
  CMP !RoomNameGFX_prev
  BEQ .return
  STA !RoomNameGFX_prev
  INC $14
  STZ.w !RoomNameGFX
  STZ.w !RoomNameOffset
  CMP #$0008
  BPL .return
  ASL
  TAX
  LDA.l .specialGraphicsTable,X
  STA $12
  JMP ($0012)
.specialGraphicsTable
  DW .reload, .ridley, .upperSection, .noDraw, .return, .crocomire, .draygon, .cridley

.reload
  LDA #$6D00 ; vram dest
  JSR LoadGraphics
  BRA .return

.upperSection
  LDA #$7C00 ; vram dest
  JSR LoadGraphics
  LDA #$00F0
  STA !RoomNameOffset
  BRA .return

.noDraw
  LDA #$0003
  STA !AreaNameState
  LDA #$0000
  STA !RoomNameOAM
  STA !RoomNameSize
  CLC
  RTS

.return
  SEC
  RTS

.cridley
  LDA #$0000
  STA !RoomNameOAM
  LDA.l CRidleyRoomName
  STA !RoomNameSize
  LDA.l CRidleyRoomName+2
  TAX
.cridleyLoop
  ; copy oam tiles
  LDA.l CRidleyRoomName+4,X
  STA !RoomNameOAM+2,X
  DEX : DEX
  BPL .cridleyLoop
  BRA .initDrawState

.ridley
  LDA #$0000
  STA !RoomNameOAM
  LDA.l RidleyRoomName
  STA !RoomNameSize
  LDA.l RidleyRoomName+2
  TAX
.ridleyLoop
  ; copy oam tiles
  LDA.l RidleyRoomName+4,X
  STA !RoomNameOAM+2,X
  DEX : DEX
  BPL .ridleyLoop
.initDrawState
  ; init draw state
  LDA #$0003
  STA !AreaNameState
  LDA #$0000
  STA !RoomNameState
  STA !RoomNameOAM
  LDA #$0010
  STA !RoomNameTimer
  CLC
  RTS

.crocomire
  LDA #$0000
  STA !RoomNameOAM
  LDA.l CrocomireRoomName
  STA !RoomNameSize
  LDA.l CrocomireRoomName+2
  TAX
.crocomireLoop
  ; copy oam tiles
  LDA.l CrocomireRoomName+4,X
  STA !RoomNameOAM+2,X
  DEX : DEX
  BPL .crocomireLoop
  BRA .initDrawState

.draygon
  LDA #$0000
  STA !RoomNameOAM
  LDA.l DraygonRoomName
  STA !RoomNameSize
  LDA.l DraygonRoomName+2
  TAX
.draygonLoop
  ; copy oam tiles
  LDA.l DraygonRoomName+4,X
  STA !RoomNameOAM+2,X
  DEX : DEX
  BPL .draygonLoop
  BRA .initDrawState

LoadName_Init:
  LDA #$FFFF
  STA !AreaNameIndex
  STA !AreaNamePrev
  LDA #$0000
  STA !AreaNameOverride
  STA !RoomNameGFX
  STA !RoomNameGFX_prev
  STA !RoomNameOffset
  STA !hyper_active

  ; displaced code
  JSL $80A07B
  BRA LoadName

LoadName_Room:
  ; displaced code
  JSL $91DEE6

  LDA #$0000
  STA !hyper_active
  JSL $90AC8D ; reload beam graphics

LoadName:
  PHP
  PHB

  ; set bank for Y reg
  PEA $7E7E
  PLB : PLB


  ;check if boss room
  JSR LoadGraphicsSpecial
  BCC .return

  JSR LoadAreaName

  ; init state
  LDA #$0000
  STA !RoomNameState
  STA !RoomNameOAM
  LDA #$0010
  STA !RoomNameTimer

  ; get room name string
  LDA $079F ; Region Number
  ASL : TAX
  LDA $079D ; Room Number
  ASL
  CLC
  ADC !AreaRoomNameTable,x ;Table for names for this region
  TAX
  LDA !AreaRoomNameBank,x ; Location of room name string
  TAX
  LDA !AreaRoomNameBank,x ; Length of string
  AND #$00FF
  STA $12 ; length
  INX

  ; init sprite map
  LDA.w #!RoomNameOAM+2
  TAY
  LDA #$0000
  STA.w !RoomNameSize ; init sprite count to 0
  STZ $14 ; x offset

.loop
  LDA !AreaRoomNameBank,x ; Character in string
  AND #$00FF
  PHX
  TAX

  ; set sprite pos
  LDA #$0000
  STA $0001,Y ; Sprite Y pos
  LDA $14
  STA $0000,Y ; Sprite X pos

  ; add to sprite x offset
  CLC
  ADC ASCII_Size,x
  AND #$00FF
  STA $14

  ; get tile
  LDA ASCII_Tile,x
  PLX
  AND #$00FF
  BEQ .loopnext

.addSprite
  CLC : ADC.w !RoomNameOffset

  ;ORA #$3A00 ; palette 5, priority 3
  STA $0003,Y ; Sprite Tile
  LDA #$0000
  INY #5
  INC.w !RoomNameSize
  
.loopnext
  INX
  DEC $12
  BNE .loop

.return
  PLB
  PLP

  RTL


print pc
LoadAreaName:
  LDA !AreaNameOverride
  BEQ .noOverride
  LDA #$0000
  STA !AreaNameOverride
  LDA !AreaNameIndex
  CMP !AreaNamePrev
  BNE .drawname

.forceReload
  LDA $14
  BNE .drawname_noinit
  JMP .return

.noOverride
  LDA $07CB ; Room music data index
  STA $004204 ; dividend
  LDA #$0003 
  SEP #$30 
  STA $004206 ; divisor
  REP #$30
  PHA : PLA : PHA : PLA : PHA : PLA
  LDA $004214 ; quotient
  TAX
  LDA.l MusicMap,X
  AND #$00FF
  CMP #$00FF
  BEQ .forceReload

  STA !AreaNameIndex
  CMP !AreaNamePrev
  BEQ .forceReload

.drawname
  STA !AreaNamePrev

  ; init state
  LDA #$0000
  STA !AreaNameState
  STA !AreaNameOAM
  LDA #$0010
  STA !AreaNameTimer

.drawname_noinit
  LDA !AreaNamePrev
  BMI .return

  ; get room name string
  ASL : TAX
  LDA AreaNames,X
  TAX

  ; init sprite map
  LDA.w #!AreaNameOAM+2
  TAY
  LDA #$0000
  STA.w !AreaNameSize ; init sprite count to 0
  STZ $14 ; x offset

.loop
  LDA $8A0000,x ; Character in string
  AND #$00FF
  BEQ .return
  PHX
  TAX

  ; set sprite pos
  LDA #$0000
  STA $0001,Y ; Sprite Y pos
  LDA $14
  STA $0000,Y ; Sprite X pos

  ; add to sprite x offset
  CLC
  ADC ASCII_Size,x
  AND #$00FF
  STA $14

  ; get tile
  LDA ASCII_Tile,x
  PLX
  AND #$00FF
  BEQ .loopnext

.addSprite
  CLC : ADC.w !RoomNameOffset

  ;ORA #$3A00 ; palette 5, priority 3
  STA $0003,Y ; Sprite Tile
  LDA #$0000
  INY #5
  INC.w !AreaNameSize
  
.loopnext
  INX
  BNE .loop

.return
  RTS


MusicMap:
  DB $FF ;00
  DB $FF ;03
  DB $0F ;06 ENERGY_PLANT
  DB $10 ;09 WAR_TEMPLE
  DB $00 ;0C SURFACE
  DB $12 ;0F FIRE_TEMPLE
  DB $13 ;12 SKY_TEMPLE
  DB $0D ;15 CARGO_RAIL
  DB $08 ;18 VULNAR_ROOT
  DB $14 ;1B Ocean sand
  DB $FF ;1E
  DB $FF ;21
  DB $FF ;24
  DB $FF ;37
  DB $FF ;2A
  DB $09 ;2D SPACE_PORT
  DB $0C ;30 PIRATE_LAB
  DB $FF ;33
  DB $FF ;36
  DB $FF ;39
  DB $FF ;3C
  DB $FF ;3F
  DB $FF ;42
  DB $FF ;45
  DB $01 ;48 OCEAN_DEPTHS
  DB $03 ;4B SERVICE_SECTOR
  DB $06 ;4E THE_HIVE
  DB $07 ;51 MAGMA_LAKE
  DB $0A ;54 CARGO_SHIP
  DB $0B ;57 GFS_DAPHNE
  DB $0A ;5A CARGO_SHIP_CRASHED
  DB $0B ;5D GFS_DAPHNE_CRASHED
  DB $0E ;60 VERDITE_MINE
  DB $11 ;63 LIFE_TEMPLE
  DB $00 ;66 OCEAN SURFACE
  DB $19 ;69 THUNDER LABORATORY
  DB $17 ;6C SUZI RUINS
  DB $18 ;6F SUZI REEF
  DB $FF ;72
  DB $FF ;75


AreaNames:
  DW .name00, .name01, .name02, .name03, .name04, .name05, .name06, .name07
  DW .name08, .name09, .name0A, .name0B, .name0C, .name0D, .name0E, .name0F
  DW .name10, .name11, .name12, .name13, .name14, .name15, .name16, .name17
  DW .name18, .name19

.name00
  DB "SURFACE",$00
.name01
  DB "OCEAN DEPTHS",$00
.name02
  DB "VULNAR CAVES",$00
.name03
  DB "SERVICE SECTOR",$00
.name04
  DB "VULNAR PEAKS",$00
.name05
  DB "SPORE FIELD",$00
.name06
  DB "THE HIVE",$00
.name07
  DB "MAGMA LAKE",$00
.name08
  DB "VULNAR ROOT",$00
.name09
  DB "SPACE PORT",$00
.name0A
  DB "CARGO SHIP",$00
.name0B
  DB "GFS DAPHNE",$00
.name0C
  DB "PIRATE RESEARCH LAB",$00
.name0D
  DB "CARGO TRANSIT RAIL",$00
.name0E
  DB "VERDITE MINE",$00
.name0F
  DB "GEOTHERMAL ENERGY PLANT",$00
.name10
  DB "WAR TEMPLE",$00
.name11
  DB "LIFE TEMPLE",$00
.name12
  DB "FIRE TEMPLE",$00
.name13
  DB "SKY TEMPLE",$00
.name14
  DB "OCEAN FLOOR",$00
.name15
  DB "JUNGLE'S HEART",$00
.name16
  DB "",$00
.name17
  DB "SUZI RUINS",$00
.name18
  DB "SUZI REEF",$00
.name19
  DB "THUNDER LABORATORY",$00

!no = $00
!na = $04

ASCII_Tile:
  DB !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no
  DB !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no

  DB !no, !no, !no, !no, !no, !no, !no, $EE, !no, !no, !no, !no, !no, !no, !no, !no
  DB !no, $EA, $EB, $EC, $ED, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no

  DB !no, $D0, $D1, $D2, $D3, $D4, $E1, $E2, $E3, $E4, $D9, $DA, $DB, $DC, $DD, $DE
  DB $DF, $E0, $D5, $D6, $D7, $D8, $E5, $E6, $E7, $E8, $E9, !no, !no, !no, !no, !no

  DB !no, $D0, $D1, $D2, $D3, $D4, $E1, $E2, $E3, $E4, $D9, $DA, $DB, $DC, $DD, $DE
  DB $DF, $E0, $D5, $D6, $D7, $D8, $E5, $E6, $E7, $E8, $E9, !no, !no, !no, !no, !no

ASCII_Size:
  DB !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na
  DB !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na

  DB !na, !na, !na, !na, !na, !na, !na, $03, !na, !na, !na, !na, !na, !na, !na, !na
  DB !na, $07, $06, $06, $07, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na, !na

  DB !na, $06, $06, $06, $06, $06, $06, $06, $06, $05, $06, $06, $05, $07, $06, $06
  DB $06, $07, $06, $06, $05, $06, $06, $07, $07, $07, $05, !na, !na, !na, !na, !na

  DB !na, $06, $06, $06, $06, $06, $06, $06, $06, $05, $06, $06, $05, $07, $06, $06
  DB $06, $07, $06, $06, $05, $06, $06, $07, $07, $07, $05, !na, !na, !na, !na, !na

RidleyRoomName:
  DW $000F : DW $004C
  DW $0000 : DB $00 : DW $310F ;b
  DW $0006 : DB $00 : DW $315F ;r
  DW $000C : DB $00 : DW $315E ;o
  DW $0012 : DB $00 : DW $315E ;o
  DW $0018 : DB $00 : DW $311F ;d
  DW $001E : DB $00 : DW $313F ;i
  DW $0023 : DB $00 : DW $314F ;n
  DW $0029 : DB $00 : DW $312F ;g

  DW $0033 : DB $00 : DW $311E ;c
  DW $0039 : DB $00 : DW $313E ;h
  DW $003F : DB $00 : DW $310E ;a
  DW $0045 : DB $00 : DW $314E ;m
  DW $004C : DB $00 : DW $310F ;b
  DW $0052 : DB $00 : DW $312E ;e
  DW $0058 : DB $00 : DW $315F ;r


CrocomireRoomName:
  DW $000F : DW $004C
  DW $0000 : DB $00 : DW $31CC ;c
  DW $0006 : DB $00 : DW $31CD ;r
  DW $000C : DB $00 : DW $31DC ;o
  DW $0012 : DB $00 : DW $31CC ;c
  DW $0018 : DB $00 : DW $31DC ;o
  DW $001E : DB $00 : DW $31DD ;m
  DW $0025 : DB $00 : DW $31EE ;i
  DW $002A : DB $00 : DW $31CD ;r
  DW $0030 : DB $00 : DW $31EF ;e
  DW $0036 : DB $00 : DW $3120 ;'
  DW $0039 : DB $00 : DW $30E6 ;s

  DW $0043 : DB $00 : DW $31FE ;l
  DW $0049 : DB $00 : DW $31FF ;a
  DW $004F : DB $00 : DW $31EE ;i
  DW $0054 : DB $00 : DW $31CD ;r

DraygonRoomName:
  DW $000F : DW $004C
  DW $0000 : DB $00 : DW $310B ;s
  DW $0006 : DB $00 : DW $310C ;c
  DW $000C : DB $00 : DW $3128 ;o
  DW $0012 : DB $00 : DW $3147 ;r
  DW $0018 : DB $00 : DW $310C ;c
  DW $001E : DB $00 : DW $311B ;h
  DW $0024 : DB $00 : DW $3176 ;i
  DW $0029 : DB $00 : DW $3177 ;n
  DW $002F : DB $00 : DW $317F ;g

  DW $0039 : DB $00 : DW $31C0 ;a
  DW $003F : DB $00 : DW $31C1 ;b
  DW $0045 : DB $00 : DW $31B4 ;y
  DW $004C : DB $00 : DW $310B ;s
  DW $0052 : DB $00 : DW $310B ;s

CRidleyRoomName:
  DW $000B : DW $0038
  DW $0000 : DB $00 : DW $314C ;f
  DW $0006 : DB $00 : DW $314D ;u
  DW $000C : DB $00 : DW $312E ;e
  DW $0012 : DB $00 : DW $315C ;l
  DW $0017 : DB $00 : DW $313F ;i
  DW $001C : DB $00 : DW $314F ;n
  DW $0022 : DB $00 : DW $312F ;g

  DW $002C : DB $00 : DW $3142 ;p
  DW $0032 : DB $00 : DW $315E ;o
  DW $0038 : DB $00 : DW $315F ;r
  DW $003E : DB $00 : DW $315D ;t


org $84fb80
; area name set plm
  DW AreaNamePLMInit, $AAE3 ; (delete inst)
; special name plm
  DW NameGFXPLMInit, $AAE3 ; (delete inst)

print pc
AreaNamePLMInit:
  LDA $1DC7,Y ; room arg
  STA !AreaNameIndex
  LDA #$0001
  STA !AreaNameOverride
  RTS

NameGFXPLMInit:
  LDA $1DC7,Y ; room arg
  STA !RoomNameGFX
  BNE +
  LDA #$FFFF
  STA !RoomNameGFX_prev
+
  RTS

;;; $FC00: Standard target sprite palette line 0 (whites and greys for flashing) ;;;
org $9AFC00
  DW $0000, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $6B5A, $6318, $7FFF, $77BD, $1084
