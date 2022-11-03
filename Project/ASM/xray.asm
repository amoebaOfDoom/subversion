lorom 

;;; $831A: Load x-ray blocks ;;;
; Note that any new PLMs created in the free space in this bank will be considered to be an "item PLM",
; meaning the PLM argument specified in the PLM populations will be used as a unique ID in the picked up items table ($7E:D870)
; and won't show an x-ray block if they've been "picked up".

; Note that these same PLMs are expected to have $7E:DF0C,x set to a 'PLM item GFX index',
; which is an index (2k for k in 0..7) to the table of draw instruction pointers responsible for drawing the x-ray tile
org $84831A
    PHP
    PHB
    REP #$30
    PHX
    PHY
    PHK
    PLB
    LDX #$004E   ; X = 4Eh

; LOOP_PLM
.loop
    LDA $1C37,x  ;\
    CMP #$DF89   ;} If not an item PLM: go to BRANCH_NEXT
    BCC .next    ;/
    CMP #$F0A0
    BCC .item

    LDY #$0000
-                    
    LDA.w CustomItems,Y
    BEQ .next
    CMP $1C37,x
    BEQ .item
    INY : INY
    BRA -

.item
    PHX
    LDA $1DC7,x
    BMI .draw
    AND #$00FF
    JSL $80818E    ;\
    LDA $7ED870,x  ;|
    PLX            ;} If nth item is picked up (n = [PLM room argument]): go to BRANCH_NEXT
    AND $05E7      ;|
    BNE .next      ;/
    PHX

.draw
    JSL $848290    ; Calculate PLM block co-ordinates
    LDA $7EDF0C,x  ;\
    TAY            ;|
    LDX $839D,y    ;} A = [[$839D + [PLM item GFX index]] + 2] & FFFh
    LDA $0002,x    ;|
    AND #$0FFF     ;/
    LDX $1C29      ; X = [PLM X block]
    LDY $1C2B      ; Y = [PLM Y block]
    JSL $91D04C    ; Load block to x-ray tilemap
    PLX

; BRANCH_NEXT
.next
    DEX            ;\
    DEX            ;} X -= 2
    BPL .loop      ; If [X] >= 0: go to LOOP_PLM

    PLY
    PLX
    PLB
    PLP
    RTL

CustomItems:
  DW $F0A0, $F87E, $F900, $F904, $F908, $FCC0, $FD40, $FDB0, $DE20, $0000

warnpc $84839E

org $91D3B4
    DW $CF36, $00FF ; enemy solid tile
    