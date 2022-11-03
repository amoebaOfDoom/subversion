lorom

!pause_state = $0727
!pause_page  = $0763 ; 0 for map, 1 for status. Used for unpausing?
!screen_fade_delay   = $0723
!screen_fade_counter = $0725
!pause_page_new = $0753 ;'EQUIP' R = 00, neither (unpausing) = 01, 'MAP' L = 02
!pause_button_flash_frames = $0729 ; Frames to flash L/R/Start button on pause screen
!pause_button_flash = $0751 ;Which button lights up for 0729 frames when changing screens from pause screen (00 = none, 01 = L, 02 = R)

!state_count = #$0003

!EquipmentMain       = $AC4F
!EquipmentScreenInit = $AC52
!EquipmentDraw       = $AC55

!entry_count       = $7FFA59;$0759
!entry_category    = $7FFA5B;$075B
!entry_list_scroll = $7FFA5C;$075C
!text_pos          = $7FFA5D;$075D
!wram_pos          = $7FFA5F;$075F
!entry_unknown     = $7FFA61;$0761
!entry_color       = $7FFA62;$0762
!notif_timer       = $7FFA64
!entry_read        = $7FFA66

!log_events_address = $7FFE20

org $82B62B
DRAW_PAGE:
    PHP
    PHB
    PHK
    PLB
    REP #$30

    LDA !pause_page
    ASL A
    TAX
    JSR (#DRAW_LIST,x)
    PLB
    PLP
    RTL

warnpc $82B64F

org $82B650
    JSL DRAW_PAGE
    RTL
warnpc $82B671

org $82934B
    JSL DRAW_PAGE
    RTS
warnpc $829364

org $828F3D
    BRA SKIP_DEFAULT_WIREFRAME
org $828F68
SKIP_DEFAULT_WIREFRAME:

org $8290FF 
;; $90FF: Main pause routine ;;;
STATE_START:
    PHP
    PHB
    PHK
    PLB
    REP #$30
    LDA !pause_state ; Pause index
    BMI STATE_START_UNKNOWN
        ASL A
        TAX
        JSR (#STATE_LIST,x); Run pause index dependant code
        BRA STATE_START_RETURN

STATE_START_UNKNOWN:
    JSR STATE_LOAD

STATE_START_RETURN:
    PLB
    PLP
    RTL

STATE_LIST:
    DW #STATE_MAP_LOAD,   #STATE_MAP_ENTER,   #STATE_MAP_MAIN,   #STATE_MAP_LEAVE
    DW #STATE_EQUIP_LOAD, #STATE_EQUIP_ENTER, #STATE_EQUIP_MAIN, #STATE_EQUIP_LEAVE
    DW #STATE_LOG_LOAD,   #STATE_LOG_ENTER,   #STATE_LOG_MAIN,   #STATE_LOG_LEAVE

DRAW_LIST:
    DW #DRAW_MAP, #DRAW_EQUIP, #DRAW_LOG


DRAW_MAP:
    JSL $82BB30
    JSR $B9C8
    JSL $82B672
    RTS

DRAW_EQUIP:
    JSR !EquipmentDraw
    RTS

DRAW_LOG:
    JSL DrawEntryContinue
    JSL DrawLogSelector
    JSL DrawEntrySprite
    JSL DMA_BG1
    RTS

;;; $9120: Pause index 0 - map screen ;;;
STATE_MAP_MAIN:
    REP #$30
    
    JSL $82B934  
    JSL $82925D  ; Map scroll handler

    JSR $A59A  ; draw equipment screen sprite
    JSR DRAW_MAP
    JSR CHECK_CHANGE_PAGE
    JSR $A5B7    ; Play map noise and check for unpause
    RTS


;;; $9142: Pause index 1 - status screen ;;;
STATE_EQUIP_MAIN:
    STZ $B1      ; set scroll to 0
    STZ $B3      ; set scroll to 0

    JSR $A59A  ; draw equipment screen sprite
    JSR !EquipmentMain ;;; Equipment screen - main ;;;
    JSR CHECK_CHANGE_PAGE
    JSR $A5B7    ; Play map noise and check for unpause
    RTS


STATE_LOG_MAIN:
    JSL ProcessInputs

    JSR $A59A  ; draw equipment screen sprite
    JSR DRAW_LOG
    JSR CHECK_CHANGE_PAGE
    JSR $A5B7    ; Play map noise and check for unpause
    RTS


;;; $9156: Pause index 2 - map screen to status screen - fading out ;;;
STATE_MAP_LEAVE:
    ; store map scroll
    LDA $B1
    STA $BD
    LDA $B3
    STA $BF

    JSR DRAW_MAP
    BRA STATE_LEAVE_FINISH

;;; $9186: Pause index 5 - status screen to map screen - fading out ;;;
STATE_EQUIP_LEAVE:
    JSR DRAW_EQUIP
    BRA STATE_LEAVE_FINISH

;;; $9186: Pause index 5 - status screen to map screen - fading out ;;;
STATE_LOG_LEAVE:
    JSR DRAW_LOG

STATE_LEAVE_FINISH:
    JSR $A56D    ;;; Updates the flashing buttons when you change pause screens ;;;
    JSL $808924  ; Handle fading out
    SEP #$20
    LDA $51    
    CMP #$80     ; test screen active
    BNE STATE_LEAVE_RETURN ; if screen is off
        JSL $80834B  ; Enable NMI with $84 options
        REP #$20
        STZ !screen_fade_delay
        STZ !screen_fade_counter
        LDA #$FFFF
        STA !pause_state
STATE_LEAVE_RETURN:
    RTS


;;; $91AB: Pause index 3 - map screen to status screen - load status screen ;;;
STATE_MAP_LOAD:
    JSL $82BB30
    JSL $8293C3   ; Updates/loads the map and area
    JSR DRAW_MAP
    INC !pause_state
    RTS
 
STATE_EQUIP_LOAD:
    STZ $0755
    ;JSL $828EDA   ; DMA WRAM/VRAM

;    SEP #$30
;    LDA #$00
;    STA $2116
;    LDA #$38
;    STA $2117
;    LDA #$80
;    STA $2115
;    JSL $8091A9 ; Set up a (H)DMA transfer
;        DB $01,$01,$18,$B6E000,$0800
;    LDA #$02
;    STA $420B
;
;    LDA #$00
;    STA $2181
;    LDA #$38
;    STA $2182
;    LDA #$7E
;    STA $2183
;    JSL $8091A9 ; Set up a (H)DMA transfer
;        DB $01,$00,$80,$B6E800,$0800
;    LDA #$02
;    STA $420B
;    REP $30

;    LDY #$C639
;    LDX #$01D8
;    LDA #$0011
;    STA $14
;
;    LDA #$0008
;    STA $12
;
;    LDA $0000,y
;    STA $7E3000,x
;    INX
;    INX
;    INY
;    INY
;    DEC $12
;    BNE $F1
;    TXA
;    CLC
;    ADC #$0010
;    TAX
;    DEC $14
;    BNE $E2
;    JSR $B20C

    JMP ReloadEQscreenLayer1
ReloadEQscreenLayer1_return:

    JSR !EquipmentScreenInit
    JSR DRAW_EQUIP
    JSL $82AC22   ; DMA BG1
    INC !pause_state
    RTS

STATE_LOG_LOAD:
    LDA #$0000
    STA !entry_read 
    LDA #$000A
    STA $87 ; held input (repeat init delay)
    LDA #$0003
    STA $89 ; held input (repeat delay)
    JSL Log_Load
    JSR DRAW_LOG
    INC !pause_state
    RTS


STATE_LOAD:
    REP #$30
    LDA !pause_page_new
    STA !pause_page
    ASL A
    ASL A
    STA !pause_state

    JSR DRAW_BUTTON_LABELS
    STZ $073F  
    LDA $C10C  
    STA $072B  
    LDA #$0001
    STA !screen_fade_delay 
    STA !screen_fade_counter
    JSL STATE_START
    RTS


;;; $9200: Pause index 7 - status screen to map screen - fading in ;;;
STATE_MAP_ENTER:
    JSR DRAW_MAP
    BRA STATE_ENTER_FINSH 

;;; $9231: Pause index 4 - map screen to status screen - fading in ;;;
STATE_EQUIP_ENTER:
    JSR DRAW_EQUIP 
    BRA STATE_ENTER_FINSH

STATE_LOG_ENTER:
    JSR DRAW_LOG

STATE_ENTER_FINSH:
    JSL $80894D ; Handle fading in
    SEP #$20
    LDA $51    
    CMP #$0F    ; test screen brightness
    BNE STATE_ENTER_RETURN ; if screen full brightness
        REP #$20
        STZ !screen_fade_delay
        STZ !screen_fade_counter
        INC !pause_state
STATE_ENTER_RETURN:
    RTS

padbyte #$00
pad $82925C
warnpc $82925D


org $82A505
;;; $A505: Checks for L or R input during pause screens ;;;
CHECK_CHANGE_PAGE:
	JSR CHANGE_PAGE 
	RTS


CHANGE_PAGE:
	PHP
	REP #$30
	LDA $05E1  
	BIT #$0020 ; L
	BNE CHANGE_PAGE_L
	BIT #$0010 ; R
	BNE CHANGE_PAGE_R
	BRA CHANGE_PAGE_RETURN

CHANGE_PAGE_R:
    LDA !pause_state
    LSR
    LSR
    INC A
    CMP !state_count
    BMI CHANGE_PAGE_R_CONTINUE
        LDA #$0000
CHANGE_PAGE_R_CONTINUE:
    STA !pause_page_new
	LDA $C10A
	STA !pause_button_flash_frames
    LDA #$0002
    STA !pause_button_flash
    BRA CHANGE_PAGE_FINISH

CHANGE_PAGE_L:
    LDA !pause_state
    LSR
    LSR
    BNE CHANGE_PAGE_L_CONTINUE
        LDA !state_count
CHANGE_PAGE_L_CONTINUE:
    DEC A
    STA !pause_page_new
    LDA $C10A  
    STA !pause_button_flash_frames
    LDA #$0001
    STA !pause_button_flash
CHANGE_PAGE_FINISH:
	INC !pause_state
    LDA #$0038   ;\
	JSL $809049  ;} Queue sound 38h, sound library 1, max queued sounds allowed = 6
    JSR DRAW_BUTTON_LABELS_NONE
CHANGE_PAGE_RETURN:
	PLP
	RTS

warnpc $82A56D


org $82A615
;;; $A615:  ;;;
DRAW_BUTTON_LABELS:
    PHP
    REP #$30
    JSR DRAW_BUTTON_LABELS_BOTH
    PLP
    RTS

warnpc $82A628


org $828D44
    JSR DRAW_BUTTON_LABELS_LOAD


org $82A628
DRAW_BUTTON_LABELS_LOAD:
    STZ $05FF ; displaced code
    STZ !pause_page
    LDA #$0002
    STA !pause_state

DRAW_BUTTON_LABELS_BOTH:

    LDA !pause_page
    BNE DRAW_BUTTON_LABEL_LEFT_CONTINUE
        LDA !state_count
DRAW_BUTTON_LABEL_LEFT_CONTINUE:
    DEC A
    ASL A
    TAX
    LDA BUTTON_LABELS,x
    TAY

    LDX #$364A ; left label
    JSR DRAW_BUTTON_LABEL

    LDA !pause_page
    INC A
    CMP !state_count
    BMI DRAW_BUTTON_LABEL_RIGHT_CONTINUE
        LDA #$0000
DRAW_BUTTON_LABEL_RIGHT_CONTINUE:
    ASL A
    TAX
    LDA BUTTON_LABELS,x
    TAY

    LDX #$366C ; right label
    JSR DRAW_BUTTON_LABEL
    RTS

DRAW_BUTTON_LABELS_NONE:
    LDY #NO_BUTTON_LABEL
    LDX #$364A ; left label
    JSR DRAW_BUTTON_LABEL

    LDY #NO_BUTTON_LABEL
    LDX #$366C ; right label
    JSR DRAW_BUTTON_LABEL
    RTS

DRAW_BUTTON_LABEL:
    PHX
    JSR DRAW_BUTTON_LABEL_ROW
    PLA
    CLC
    ADC #$0040
    TAX
    JSR DRAW_BUTTON_LABEL_ROW
    RTS

DRAW_BUTTON_LABEL_ROW:
    LDA #$0005
    STA $00
DRAW_BUTTON_LABEL_LOOP:
    LDA $0000,y
    STA $7E0000,x
    INX
    INX
    INY
    INY
    DEC $00
    BNE DRAW_BUTTON_LABEL_LOOP
    RTS

BUTTON_LABELS:
    DW #MAP_BUTTON_LABEL, #EQUIP_BUTTON_LABEL, #LOG_BUTTON_LABEL

NO_BUTTON_LABEL:
    DW #$34E4, #$35AB, #$35AB, #$35AB, #$34E8
    DW #$34F4, #$35BB, #$35BB, #$35BB, #$34F8

MAP_BUTTON_LABEL:
    DW #$28E4, #$28E5, #$28E6, #$28E7, #$28E8
    DW #$28F4, #$28F5, #$28F6, #$28F7, #$28F8

EQUIP_BUTTON_LABEL:
    DW #$28E9, #$28EA, #$28EB, #$28EC, #$28ED
    DW #$28F9, #$28FA, #$28FB, #$28FC, #$28FD

LOG_BUTTON_LABEL:
    DW #$28E4, #$29A8, #$29A9, #$29AA, #$28E8
    DW #$28F4, #$29B8, #$29B9, #$29BA, #$28F8

ReloadEQscreenLayer1:
    PHK
    PEA.w ReloadEQscreenLayer1_return-1
    PHP
    SEP #$30
    JML $828F1D

warnpc $82A84D

!log_gfx1 = $E08000
!log_gfx2 = $E18000
!log_gfx3 = $E28000
!log_pal  = $A19000

macro gfx1_entry(entry)
    DL <entry>*$800+!log_gfx1
endmacro
macro gfx2_entry(entry)
    DL <entry>*$800+!log_gfx2
endmacro
macro gfx3_entry(entry)
    DL <entry>*$800+!log_gfx3
endmacro
macro pal_entry(entry)
    DL <entry>*$20+!log_pal
endmacro

org !log_gfx1
incbin ROMProject/Graphics/logbook/gfx1.gfx
org !log_gfx2
incbin ROMProject/Graphics/logbook/gfx2.gfx
org !log_gfx3
incbin ROMProject/Graphics/logbook/gfx3.gfx
org !log_pal
incbin ROMProject/Graphics/logbook/palette.bin



org $BC8000
LogbookTTB:
    incbin ROMProject/Graphics/logbook.ttb

; Max event = #$027F, Min event = #$0080
LogEventOffsets:
    DW #$0100, #$0140, #$0190, #$01C0

LogbookEntriesCategoriesText:
    DW locations__Description, equipment__Description, beastiary__Description, mission__Description

LogbookEntriesCategories:
    DW locations__Entries, equipment__Entries, beastiary__Entries, mission__Entries

LogbookEntriesCategoriesSubCount:
    DW -3, -4, -0, -0

incsrc ROMProject/ASM/Log/mission.asm
incsrc ROMProject/ASM/Log/locations.asm
incsrc ROMProject/ASM/Log/equipment.asm
incsrc ROMProject/ASM/Log/beastiary.asm
namespace off

!no = $0F

ASCII_Table:
  DB !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no
  DB !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no, !no

  DB $0F, $DF, $29, $15, $B4, $0A, !no, $DC, $16, $17, $0B, $26, $18, $DD, $DA, $1A
  DB $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0C, $28, $16, $25, $17, $DE

  DB !no, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE
  DB $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $16, $1B, $17, $27, $19

  DB $DC, $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE
  DB $CF, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $16, $2A, $17, $DD, !no

; Parameters
; Y   = Text Pointer
; X   = WRAM Destination Address
; A   = Tile Count
; $00 = Initial Color Mask
; $02 = NL WRAM Offset
; $0A = Make unknown
;
; Returns
; X = Next WRAM Destination Address
; Y = Next Text Pointer
;
; Uses
; $00-$05
DrawText:
    CPY #$0000
    BNE +
    RTS ; don't write if null pointer
+
    STA $04
    LDA $7E0000,X
    CMP #$3C19
    BNE +
    LDA #$3C0F
    STA $7E0000,X
+

.loop
    LDA $0000,Y
    AND #$00FF
    BEQ .textend
    BIT #$0080
    BEQ .no_color
.color
    AND #$0007
    ASL : ASL : XBA
    ORA #$2000
    STA $00
    INY
    BRA .loop
.no_color
    JSR GetNextChar
    BCC .nextchar

.draw
    PHA
    TXA
    AND #$003F
    CMP $02
    BPL .test_wrap
.space_wrap
    TXA
    AND #$FFC0
    ORA $02
    TAX
.test_wrap
    ; determine word wrap
    PHY : PHX
    INX : INX
.wrap_loop
    TXA
    AND #$003F
    ;CMP #$003E
    BEQ .wrap
    LDA $0000,Y
    AND #$00FF ; null
    BEQ .draw_continue
    CMP.w #$0020 ; space
    BEQ .draw_continue
    CMP #$000A ; NL
    BEQ .draw_continue
    JSR GetNextChar
    BCC +
    INX : INX
+
    BRA .wrap_loop
.wrap
    PLA
    AND #$FFC0
    ORA $02
    CLC
    ADC #$0040
    PHA
.draw_continue
    PLX : PLY : PLA

    INC $0A : DEC $0A ; test if unknown is set
    BEQ +
    LDA #$2438 ; change to '?'
+
    STA $7E0000,X
    INX : INX

    DEC $04
    BEQ .partialend
.nextchar
    BRA .loop

.textend
    TXA 
    AND #$FFC0
    ORA $02
    CLC
    ADC #$0040
    TAX
    LDY #$0000
    RTS

.partialend
    LDA $7E0000,X
    CMP #$3C0F
    BNE +
    LDA #$3C19
    STA $7E0000,X
+
    RTS


; Parameters
; Y   = Text Pointer
; X   = WRAM Destination Address
; $00 = Color Mask
; $02 = NL WRAM Offset
;
; Returns
; X = Next WRAM Destination Address
; Y = Next Text Pointer
; A = Tile
; C = carry clear -> skip draw
;
; Uses
; $00-$05
GetNextChar:
.loop
    LDA $0000,Y
    AND #$00FF
    BNE .tile ; null
.textend
    CLC
    RTS

.tile
    CMP #$00FF
    BNE .event

    INY
    LDA $0000,Y
    INY
    SEC
    BRA .return

.event
    CMP #$0001
    BNE .unevent

    INY
    LDA $0000,Y
    INY
    JSL GetLogEvent ; test event bit
    BCC .scan_event
    CLC
    BRA .return

.unevent
    CMP #$0002
    BNE .NL

    INY
    LDA $0000,Y
    INY
    JSL GetLogEvent ; test event bit
    BCS .scan_event
    CLC
    BRA .return

.scan_event
    INY
-
    LDA $0000,Y
    AND #$00FF
    BEQ .textend
    CMP #$0001
    BEQ .textend
    CMP #$0002
    BEQ .textend
    PHX
    JSR GetNextChar
    PLX
    BRA -

.NL
    CMP #$000A ; NL
    BNE .color

    TXA 
    AND #$FFC0
    ORA $02
    CLC
    ADC #$0040
    TAX
    CLC
    BRA .return

.color
    BIT #$0080
    BEQ .space
    CLC
    BRA .return

.space
    CMP.w #$0020 ; space
    BNE .ASCII
    INX : INX
    CLC
    BRA .return

.ASCII
    PHY : TAY
    LDA ASCII_Table,Y
    PLY
    AND #$00FF
    ORA $00
    SEC

.return
    INY
    RTS




ClearEntryList:
    PHA : PHX
    LDX #$3AC2
    LDA #$0008 : STA $14
.rowloop
    LDA #$000C : STA $12
    LDA #$3C0F
.colloop
    STA $7E0000,x
    INX : INX
    DEC $12
    BNE .colloop
    TXA : CLC : ADC #$0028 : TAX
    DEC $14
    BNE .rowloop
    PLX : PLA : RTS


ClearEntry:
    PHA : PHX
    LDX #$399C
    LDA #$0012 : STA $14
.rowloop
    LDA #$0011 : STA $12
    LDA #$3C0F
.colloop
    STA $7E0000,x
    INX : INX
    DEC $12
    BNE .colloop
    TXA : CLC : ADC #$001E : TAX
    DEC $14
    BNE .rowloop
    PLX : PLA : RTS


Mult10:
  ASL
  STA $12
  ASL
  ASL
  CLC
  ADC $12
  RTS

DrawPercent:
  LDA $12
  CMP $14
  BEQ Draw100Percent

  JSR Mult10
  STA $4204

  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ;BEQ SkipTotal10
  ORA #$3C00 : STA $7E0004,x
SkipTotal10:

  LDA $4216
  JSR Mult10
  STA $4204
  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214
  ORA #$3C00 : STA $7E0006,x

  LDA #$3C0A : STA $7E0008,x

  RTS
Draw100Percent:
  LDA #$3401 : STA $7E0002,x
  LDA #$3400 : STA $7E0004,x
  LDA #$3400 : STA $7E0006,x
  LDA #$340A : STA $7E0008,x
  RTS


LoadEntryList:
    PHP : PHA : PHX : PHY
    JSR ClearEntryList

    LDA #$0000
    STA !entry_count
    LDX #$3982
    LDY #$0000
    STZ $04
    STZ $06
.categoryloop
    PHY : PHX
    STZ $00
    LDA LogbookEntriesCategoriesSubCount,Y
    STA $12
    STA $14
    LDA.w LogbookEntriesCategories,Y
    STA $02
    TYX
    LDY #$0000

.category_countloop
    LDA ($02),Y
    BEQ .category_countend

    INC $14 ; add to total count
    TYA
    CLC : ADC.w LogEventOffsets,X
    PHA
    JSL GetLogEvent ; test event bit
    BCC .next_item
    INC $12 ; add to collected count

    ; check unresolved
    PHY 
    LDA ($02),Y : TAY
    LDA $0006,Y
    BEQ .normal_read
    INC $14 ; add to total count
    INC $06
    JSL GetLogEvent
    BCC .alt_read
    INC $12 ; add to collected count
    BRA .normal_read
.alt_read
    LDA $0006,Y
    CLC : ADC #$0020
    JSL GetLogEvent
    PLY
    BCS .next_item
    INC $00
    BRA .next_item
.normal_read
    PLY

    PLA : PHA : INC
    JSL GetLogEvent ; test event bit
    BCS .next_item
    INC $00 ; add to unread count

.next_item
    PLA
    INY : INY
    BRA .category_countloop

.category_countend
    PLX : PLY
    LDA $00
    BEQ +
    LDA #$22B7 ; notification
    BRA ++
+
    LDA #$22A7 ; no notification
++
    STA $7E0002,X

    LDA $04
    BEQ +
    LDA #$294E ; arrow line
    STA $7E0000,X
    BRA .category_deselect
+
    
    TYA 
    SEP #$20 : CMP !entry_category : REP #$20
    BNE +
.category_select
    INC $04
    LDA $14
    SEC : SBC LogbookEntriesCategoriesSubCount,Y
    SEC : SBC $06
    STA !entry_count
    LDA #$294F ; arrow angle
    STA $7E0000,X
    LDA #$0800
    STA $02
    BRA .category_color
+
    LDA #$3C0F ; blank
    STA $7E0000,X

.category_deselect
    LDA #$0C00
    STA $02

.category_color
    LDA #$0007
    STA $00
-
    LDA $7E0002,X
    AND #$E3FF
    ORA $02
    STA $7E0002,X
    INX : INX
    DEC $00
    BNE -

    JSR DrawPercent

.category_end
    INY : INY
    TXA : CLC : ADC #$0032 : TAX
    CPY #$0008
    BPL +
    JMP .categoryloop
+

    LDA !entry_category
    AND #$00FF
    TAX
    LDA.w LogbookEntriesCategories,X
    STA $08
    LDA #$0002 ; NL WRAM offset
    STA $02

    LDA !entry_list_scroll
    AND #$00FF
    ASL
    TAY
    BEQ +
    LDA #$3D4B ; up arrow
    STA $7E3ACC
    LDA #$7D4B ; up arrow
    STA $7E3ACE
    LDA #$3B02 ; wram position
    STA $06
    LDA #$0007
    STA $0C
    INY : INY
    BRA ++
+
    LDA #$3AC2 ; wram position
    STA $06
    LDA #$0008
    STA $0C
++

.loop
    LDA ($08),Y
    BNE +
    JMP .return
+

    PHY : PHA
    STZ $0A

    LDA !entry_category
    AND #$00FF
    TAX
    TYA : CLC : ADC.w LogEventOffsets,X : TAY
    JSL GetLogEvent ; test collected bit
    BCS .colleted_entry
.unknown_entry
    INC $0A
    BRA .writeentry

.colleted_entry
    PLX : PHX
    LDA $0006,X ; event pointer
    BEQ .check_read
    JSL GetLogEvent ; test read bit
    BCS .check_read

    LDA $0006,X ; event pointer
    CLC : ADC #$0020
    JSL GetLogEvent
    BCS +
    LDA #$3800 ; unresolved unread color
    BRA .set_color
+
    LDA #$2800 ; unresolved color
    BRA .set_color

.check_read
    TYA : INC
    JSL GetLogEvent ; test read bit
    BCS +
    LDA #$2C00 ; unread color
    BRA .set_color
+
    LDA #$3C00 ; read color
.set_color
    STA $00
    
.writeentry
    PLX
    LDY $0000,X ; text pointer
    LDX $06
    LDA #$FFFF ; tile count (all)
    JSR DrawText
    STX $06
    PLY

    INY : INY
    DEC $0C
    BNE .loop

.boxend
    LDA ($08),Y
    BEQ .return

    LDX #$0016
    LDA #$3C0F
-
    STA $7E3C82,X
    DEX : DEX
    BPL -
    LDA #$BD4B ; down arrow
    STA $7E3C8C
    LDA #$FD4B ; down arrow
    STA $7E3C8E

.return
    PLY : PLX : PLA : PLP : RTS


LoadSprite:
    PHY : PHX
    TAY
    BEQ .return

.gfx
    LDA $0000,Y ; GFX
    BEQ .return
    PHP
    REP #$30
    LDX $0330
    LDA #$0800 ; size (4 rows)
    STA $D0,x
    INX
    INX
    LDA $0000,Y ; source
    STA $D0,x   
    INX
    INX
    SEP #$20
    LDA $0002,Y ; source bank
    STA $D0,x
    REP #$20
    INX
    LDA #$2400 ; destination
    STA $D0,x
    INX
    INX
    STX $0330
    PLP

.palette
    PHB
    LDA $0004,Y ; bank
    PHA
    LDA $0003,Y ; Palette
    PLB : PLB
    TAY
    LDX #$003E
-
    LDA $003E,Y
    STA $7EC180,X
    DEY : DEY : DEX : DEX
    BPL -
    PLB

.return
    PLX : PLY : RTS


DrawEntrySprite:
    PHP : PHB : PHK : PLB
    REP #$30

    LDA !entry_unknown
    AND #$00FF
    BNE .return

    LDA $0756
    AND #$00FF
    CMP #$0004
    BMI .return

    LDA !entry_category
    AND #$00FF
    TAX
    LDA.w LogbookEntriesCategories,X
    STA $00

    LDA $0756
    AND #$00FF
    SEC : SBC #$0004
    ASL

    TAY
    LDA ($00),Y
    TAX
    LDY $0004,X
    BEQ .return
    LDA $0000,Y
    BEQ .return
    TYA : CLC : ADC #$0006 : TAY

    LDA #$0004
    STA $06

.load_oam
    LDA $0000,Y
    STA $18 ; entry count
    INY : INY

    LDA #$009F 
    STA $12 ; y position
    LDA #$0008
    STA $14 ; x position

    PHB
    PEA.w .return-1
    PHB
    JML $818A5F ; add sprite to OAM

.return
    PLB : PLP : RTL
    

LoadEntry:
    JSR ClearEntry
    LDA $0756
    AND #$00FF
    CMP #$0004
    BMI .category

.entry
    LDA !entry_category
    AND #$00FF
    TAX
    LDA.w LogbookEntriesCategories,X
    STA $00

    LDA $0756
    AND #$00FF
    SEC : SBC #$0004
    ASL

    PHA : TAY
    LDA ($00),Y
    TAY

    LDA $0004,Y
    JSR LoadSprite

    LDA $0002,Y
    STA !text_pos
    PLA : CLC : ADC.w LogEventOffsets,X 
    PHY : TAY

    JSL GetLogEvent ; test collected bit
    BCS +
    LDA #$0000
    STA !entry_read
    LDA #$2C01 ; palette 7 + unknown
    BRA ++
+
    TYA
    INC
    STA !entry_read
    LDA #$3C00 ; palette 7
++
    STA !entry_unknown

    ; use alternate unread if unresolved
    PLY
    LDA $0006,Y
    BEQ +
    JSL GetLogEvent ; test read bit
    BCS +
    LDA $0006,Y
    CLC : ADC #$0020
    STA !entry_read    
+

    LDA #$399C
    STA !wram_pos
    BRA .return

.category
    ASL
    TAX
    LDA.w LogbookEntriesCategoriesText,X
    STA !text_pos
    LDA #$399C
    STA !wram_pos
    LDA #$3C00 ; palette 7
    STA !entry_unknown


.return
    JSR LoadEntryList
    RTS


DrawLogSelector:
    PHP
    REP #$30
    LDA $0755
    AND #$FF00
    CMP #$0400
    BPL .entry

.category
    ORA #$0004
    STA $0755
    LSR : LSR : LSR : LSR : LSR
    CLC
    ADC #$0034
    TAY         ; y pos
    LDX #$001F  ; x pos
    BRA .return

.entry
    ORA #$0005
    STA $0755
    XBA : 
    SEC : SBC !entry_list_scroll
    AND #$00FF
    ASL : ASL : ASL
    CLC
    ADC #$003C
    TAY         ; y pos
    LDX #$0017  ; x pos

.return
    LDA #$0003  ; sprite #3
    JSL $82A87D ; draw sprite
    PLP
    RTL


ProcessInputs:
    PHB : PHK : PLB
    PHP : REP #$30    
    LDA $8F ; new pressed inputs
    ORA $93 ; held input (repeat)
.up
    BIT #$0800 ; Up
    BEQ .down
    LDA $0756
    AND #$00FF
    BEQ .down
    DEC $0756

    SEC : SBC !entry_list_scroll
    AND #$00FF
    CMP #$0006
    BNE +
    LDA !entry_list_scroll
    AND #$00FF
    BEQ +
    LDA !entry_list_scroll
    DEC
    STA !entry_list_scroll
+

    JSR LoadEntry
    LDA #$0037  ;\
    JSL $809049 ;} Queue sound 37h, sound library 1
    BRA .return
.down
    BIT #$0400 ; Down
    BEQ .A
    LDA $0756
    AND #$00FF
    DEC : DEC : DEC
    CMP !entry_count
    BPL .A
    INC $0756

    SEC : SBC !entry_list_scroll
    AND #$00FF
    CMP #$0006
    BNE +
    LDA !entry_count
    SEC : SBC !entry_list_scroll
    AND #$00FF
    CMP #$0008
    BEQ +
    LDA !entry_list_scroll
    INC
    STA !entry_list_scroll
+

    JSR LoadEntry
    LDA #$0037  ;\
    JSL $809049 ;} Queue sound 37h, sound library 1
    BRA .return
.A
    BIT #$0080 ; A
    BEQ .return
    LDA $0756
    AND #$00FF
    CMP #$0004
    BPL .return
    ASL
    STA !entry_category
    JSR LoadEntryList
    LDA #$0038
    JSL $809049  ;  Play Sound

.return
    PLP : PLB : RTL


Log_Load:
    PHP : PHB : PHK : PLB : PHA : PHX : PHY
    REP #$30

    ; location subcategories
    LDA #$0100
    JSL SetLogEvent ; set event bit
    LDA #$0101
    JSL SetLogEvent ; set event bit
    LDA #$0118
    JSL SetLogEvent ; set event bit
    LDA #$0119
    JSL SetLogEvent ; set event bit
    LDA #$012C
    JSL SetLogEvent ; set event bit
    LDA #$012D
    JSL SetLogEvent ; set event bit

    ; equip subcategories
    LDA #$0140
    JSL SetLogEvent ; set event bit
    LDA #$0141
    JSL SetLogEvent ; set event bit
    LDA #$014E
    JSL SetLogEvent ; set event bit
    LDA #$014F
    JSL SetLogEvent ; set event bit
    LDA #$0168
    JSL SetLogEvent ; set event bit
    LDA #$0169
    JSL SetLogEvent ; set event bit
    LDA #$0178
    JSL SetLogEvent ; set event bit
    LDA #$0179
    JSL SetLogEvent ; set event bit

    ; TN578
    LDA #$0102
    JSL SetLogEvent ; set event bit

    ; test hyper beam...
    LDA $09A2
    BIT #$0010
    BEQ +
    LDA #$015C
    JSL SetLogEvent ; set event bit
+
    
    ; test item scanner
    LDA #$003F
    JSL $808233
    BCC +
    LDA #$0176
    JSL SetLogEvent
+

    STZ $B1      ; BG1 X scroll = 0
    STZ $B3      ; BG1 Y scroll = 0
    LDA #$0004
    STA $0755
    LDA #$0000
    STA !entry_category
    STA !entry_count
    STA !text_pos
    STA !wram_pos
    STA !entry_unknown

    LDA #$3900
    STA $2181
    SEP #$30
    LDA #$7E
    STA $2183  
    JSL $8091A9  ; Set up a (H)DMA transfer
    DB $01, $00, $80 : DL #LogbookTTB : DW $0540
    LDA #$02
    STA $420B 
    REP #$30

    JSR LoadEntry
    PLY : PLX : PLA : PLB : PLP : RTL



DrawEntryContinue:
    PHP : REP #$30
    PHB : PHK : PLB
    LDA !entry_unknown
    AND #$FF00
    STA $00
    LDA #$001C
    STA $02
    LDA !entry_unknown
    AND #$00FF
    STA $0A
    LDA !wram_pos : TAX
    LDA !text_pos : TAY
    LDA #$0002 ; characters to draw
    JSR DrawText
    LDA !entry_unknown
    AND #$00FF
    ORA $00
    STA !entry_unknown
    TXA : STA !wram_pos
    TYA : STA !text_pos

    ; Play typewriter sound
    BEQ +
    BIT #$0007
    BNE +
    LDA #$000D
    JSL $809143   ;  Play Sound library 2
+

    CPY #$0000
    BNE .return
    LDA !entry_read
    BEQ .return
    JSL SetLogEvent ; mark read bit
    LDA #$0000
    STA !entry_read    
    JSR LoadEntryList

.return
    PLB : PLP
    RTL


DMA_BG1:
    PHP
    REP #$30
    LDX $0330
    LDA #$0540
    STA $D0,x
    INX
    INX
    LDA #$3900
    STA $D0,x
    INX
    INX
    SEP #$20
    LDA #$7E
    STA $D0,x
    REP #$20
    INX
    LDA #$3080
    STA $D0,x
    INX
    INX
    STX $0330
    PLP
    RTL


ItemEntryMap:
    DW $FD40, $0001 ; gravity boots
    DW $FE20, $0017 ; metroid suit
    DW $FDB0, $0019 ; dark visor
    DW $F900, $001F ; ammo tank
    DW $F904, $001F ; ammo tank, chozo orb
    DW $F908, $001F ; ammo tank, shot block
    DW $F0A0, $0021 ; damage amp
    DW $F87E, $0020 ; accel charge
    DW $F780, $0009 ; hypercharge

    DW $EEE7, $0012 ; Bombs
    DW $EF3B, $0012 ; Bombs, chozo orb
    DW $EF8F, $0012 ; Bombs, shot block
    DW $EEEB, $0008 ; Charge beam
    DW $EF3F, $0008 ; Charge beam, chozo orb
    DW $EF93, $0008 ; Charge beam, shot block
    DW $EED7, $001D ; Energy tank
    DW $EF2B, $001D ; Energy tank, chozo orb
    DW $EF7F, $001D ; Energy tank, shot block
    DW $EF17, $000F ; Grapple beam
    DW $EF6B, $000F ; Grapple beam, chozo orb
    DW $EFBF, $000F ; Grapple beam, shot block
    DW $EF0B, $0015 ; Gravity suit
    DW $EF5F, $0015 ; Gravity suit, chozo orb
    DW $EFB3, $0015 ; Gravity suit, shot block
    DW $EEF3, $0002 ; Hi-jump
    DW $EF47, $0002 ; Hi-jump, chozo orb
    DW $EF9B, $0002 ; Hi-jump, shot block
    DW $EEEF, $000B ; Ice beam
    DW $EF43, $000B ; Ice beam, chozo orb
    DW $EF97, $000B ; Ice beam, shot block
    DW $EEDB, $0010 ; Missile tank
    DW $EF2F, $0010 ; Missile tank, chozo orb
    DW $EF83, $0010 ; Missile tank, shot block
    DW $EF23, $0005 ; Morph ball
    DW $EF77, $0005 ; Morph ball, chozo orb
    DW $EFCB, $0005 ; Morph ball, shot block
    DW $EF13, $000D ; Plasma beam
    DW $EF67, $000D ; Plasma beam, chozo orb
    DW $EFBB, $000D ; Plasma beam, shot block
    DW $EEE3, $0013 ; Power bomb tank
    DW $EF37, $0013 ; Power bomb tank, chozo orb
    DW $EF8B, $0013 ; Power bomb tank, shot block
    DW $EF27, $001E ; Reserve tank
    DW $EF7B, $001E ; Reserve tank, chozo orb
    DW $EFCF, $001E ; Reserve tank, shot block
    DW $EF1F, $0018 ; Screw attack
    DW $EF73, $0018 ; Screw attack, chozo orb
    DW $EFC7, $0018 ; Screw attack, shot block
    DW $EF1B, $0004 ; Space jump
    DW $EF6F, $0004 ; Space jump, chozo orb
    DW $EFC3, $0004 ; Space jump, shot block
    DW $EEFF, $000C ; Spazer beam
    DW $EF53, $000C ; Spazer beam, chozo orb
    DW $EFA7, $000C ; Spazer beam, shot block
    DW $EEF7, $0003 ; Speed booster
    DW $EF4B, $0003 ; Speed booster, chozo orb
    DW $EF9F, $0003 ; Speed booster, shot block
    DW $EF03, $0006 ; Spring ball
    DW $EF57, $0006 ; Spring ball, chozo orb
    DW $EFAB, $0006 ; Spring ball, shot block
    DW $EEDF, $0011 ; Super missile tank
    DW $EF33, $0011 ; Super missile tank, chozo orb
    DW $EF87, $0011 ; Super missile tank, shot block
    DW $EF07, $0016 ; Varia suit
    DW $EF5B, $0016 ; Varia suit, chozo orb
    DW $EFAF, $0016 ; Varia suit, shot block
    DW $EEFB, $000A ; Wave beam
    DW $EF4F, $000A ; Wave beam, chozo orb
    DW $EFA3, $000A ; Wave beam, shot block
    DW $EF0F, $001A ; X-ray scope
    DW $EF63, $001A ; X-ray scope, chozo orb
    DW $EFB7, $001A ; X-ray scope, shot block
    DW $0000


; A = event id
SetLogNotif:
    PHA
    JSL GetLogEvent ; test event bit
    PLA
    BCS .return
    JSL SetLogEvent ; set event bit
    LDA.w #200 ; frames to display
    STA.l !notif_timer
.return
    RTL


SetItemLog:
    ; Displaced Code
    LDA $7ED870,X
    ORA $05E7
    STA $7ED870,X

    PHP
    PHX
    PHY
    PHA

    LDY $1C27 ; PLM index
    LDX #$0000
.loop
    LDA.l ItemEntryMap,X
    BEQ .return
    CMP $1C37,Y ; PLM ID
    BNE +

    LDA.l ItemEntryMap+2,X
    ASL
    CLC : ADC #$0140
    JSL SetLogNotif
    BRA .return
+
    INX : INX : INX : INX
    BRA .loop
.return

    PLA
    PLY
    PLX
    PLP

    RTL


SetHeatLog:
    LDA $09A2
    AND #$0001 ; varia suit
    BEQ .no_suit
.suit
    LDA #$01E5
    JSL SetLogEvent ; set event bit
.no_suit
    LDA #$01C8
    JSL SetLogEvent ; set event bit

    ; displaced code
    LDA $1EED
    CMP $1EEF
    RTL


; 808233 ; get
GetLogEvent:
    PHX
    PHY
    PHP
    REP #$30
    JSL $80818E
    LDA !log_events_address,x
    AND $05E7
    BNE .was_set
.was_clear
    PLP
    PLY
    PLX
    CLC
    RTL

.was_set
    PLP
    PLY
    PLX
    SEC
    RTL

; 8081FA ; set
SetLogEvent:
    PHX
    PHY
    PHP
    REP #$30
    JSL $80818E
    LDA !log_events_address,x
    BIT $05E7
    BNE +
    ORA $05E7
    STA !log_events_address,x
    JSL $81EF24 ; save extra log file data
    SEC
+
    PLP
    PLY
    PLX
    RTL

warnpc $BD0000

org $8DE3AB
    JSL SetHeatLog
    NOP : NOP


org $8488A3
    ;LDA $7ED870,x
    JSL SetItemLog


org $8FE643
    AND #$0010 ; suit (was 0004 for morph)


org $84FB00
;arg
;    n xxxxxxx yyyyyyy 
;        n = notification
;        x = time in seconds (or touch)
;        y = event
LogPLMHeader:
    DW #LogPLMSetup, #LogPLMInstructions

LogPLMInstructions:
    DW $0001, $AF62 ; set touch reaction bts
    DW $86C1, #WaitTimer ; set preinst
    DW $86B4 ; sleep
    DW #LogPLMTrigger
    DW $86BC ; delete

LogPLMSetup:
    SEP #$30
    LDA.b #60 ; 1 sec
    STA $4202
    LDA $1DC8,Y ; room arg + 1
    AND #$7F
    STA $4203
    REP #$30
    PHA : PLA : NOP
    LDA $4216 ; multiply
    STA $1D77,Y ; timer
    JMP $B371 ; scroll plm setup

WaitTimer:
    LDA $1E17,X ; already triggered
    BNE +
    LDA $1D77,X ; timer
    BEQ +
    DEC
    STA $1D77,X
    BNE +
    INC $1D27,X
    INC $1D27,X ; plm inst
    INC $1E17,X ; triggered
    LDA #$0001
    STA $7EDE1C,X ; inst timer
+
    RTS

LogPLMTrigger:
    LDA $0998 ;Game state
    CMP #$0027;Game is loading from demo
    BPL .return
    
    LDA $1DC7,X ; room arg
    PHP ; save minus flag
    AND #$00FF
    CLC : ADC #$0100
    PLP
    BMI .notify
.no_notify
    JSL SetLogEvent ; set event bit
    BRA .return
.notify
    JSL SetLogNotif
.return
    PHX
    LDA $1C87,X
    TAX
    LDA #$0000 ; air
    JSR $82B4 ; change tile
    PLX
    RTS


; Allow sprite offset to be negative
org $818ABC
    BEQ $62 ; $61
org $818B0C
    CLC ; allow previous math to set carry
    ADC #$0005
    TAY       
    TXA       
    ADC #$0004
    AND #$01FF
    TAX       
    DEC $18   
    BNE $A9 ; $AA   
    STX $0590 
    PLY
    RTL
