; based on DoubleJump by Crashtour99

lorom

org $90A4C4
  JSL ActivateSpaceJump

org $90DD00
  JSR ResetJumpCount

org $90A488 ; remove y speed restrictings on space jump
  JMP $A4B1

;org $809B54
;  JSL RefreshSpaceJump
;  BRA SkipReserves
;org $809B8B
;SkipReserves:

org $90F810 ; free space
ResetJumpCount:
  JSR $AECE ; displaced code
  JSL RefreshSpaceJump
  RTS

org $9DF800 ; free space
RefreshSpaceJump:
  LDA $7FFDE0
  BIT #$FFF0
  BEQ RefreshSpaceJump_NotEmpty
  LDA #$0000
  STA $7FFDE0
RefreshSpaceJump_NotEmpty:

  LDA $7FFDE0
  BNE RefreshSpaceJump_NotZero
  LDA #$0000
  BRA RefreshSpaceJump_Update
RefreshSpaceJump_NotZero:

  LDA $09CA
  AND #$000F
  INC
  SEC : SBC $7FFDE0
  ASL
  TAX

  LDA $7FFDDE
  CLC : ADC $7FFDE2
  CMP RefillTimes,X
  BMI RefreshSpaceJump_Update

  LDA $7FFDE0
  DEC
  STA $7FFDE0
  LDA $7FFDE2
  INC
  STA $7FFDE2
  LDA #$0000
RefreshSpaceJump_Update:
  STA $7FFDDE
RefreshSpaceJump_Exit:
  RTL

RefillTimes:
  DW $0100, $00A0, $0090, $0080
  DW $0070, $0068, $0060, $0050
  DW $0030, $0020, $0018, $0014
  DW $0010, $000C, $000A, $0008

ActivateSpaceJump:
  LDA $0A1C
  CMP #$0083
  BEQ WallJumpSkip
  CMP #$0084
  BEQ WallJumpSkip
  CMP #$00B8
  BEQ WallJumpSkip
  CMP #$00B9
  BEQ WallJumpSkip

  ; screw attack
  CMP #$0081
  BEQ +
  CMP #$0082
  BNE ++
+
  LDA $0A96 ; animation frame
  CMP #$001B ; screw attack pose wall jump animation frame
  BEQ WallJumpSkip
++

  ; space jump
  CMP #$001B
  BEQ +
  CMP #$001C
  BNE ++
+
  LDA $0A96 ; animation frame
  CMP #$000B ; space jump pose wall jump animation frame
  BEQ WallJumpSkip
++

  LDA $09CA
  AND #$000F
  CMP $7FFDE0
  BMI NoMoreJumps

MoreJumps:
  LDA #$0000
  STA $7FFDDE
  LDA #$0001
  STA $7FFDE2
  LDA $7FFDE0
  INC A
  STA $7FFDE0

WallJumpSkip:
  JSL $9098BC

NoMoreJumps:
  RTL
warnpc $9DFFFF

; --------------------------------------------------------------
; Item definition, referenced by the files in the PLMs directory.
org $84FCC0
  ; item header: EE64 for a pickup
  DW $EE64,item_data

item_data:
  DW $8764,$8600 ; space jump graphics
    DB 1,1,1,1,1,1,1,1  ; make it green
  DW $887C,end_plm ; if item has been picked up, delete PLM
  DW $8A2E,$DFAF ; chozo ball stuff (x2)
  DW $8A2E,$DFC7
  DW $8A24,pickup_plm ; save address of 'pickup triggered' PLM routine
  DW $86C1,$DF89 ; set pre-PLM instruction
  DW $874E       ; store $16 to 1D77,X (the 'variable use PLM value')
    DB $16         ; no idea why, but Chaos Arms did it, and taking it out crashes.

gfx_plm:
  DW $E04F       ; graphics/pickup stuff
  DW $E067       ; flashing animation
  DW $8724,gfx_plm ; use graphics stuff as next (frame's?) PLM instruction

pickup_plm:
  DW $8899       ; mark PLM as picked up
;  DW $8BDD
;    DB $02       ; play track 02 (item collect)
  DW $8C07
    DB $2B
  DW JumpBoostCollect
    DB $21, $25       ; msgbox identifier, I think $1D may be the first free msgbox?
  DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
  DW $86BC       ; done: delete PLM

; PLM arguments:
; Value (2 bytes), unused since the math is too hard for me yet
; Message box (1 byte)

JumpBoostCollect:
  LDA $09CA   ; load current number of jump boosts
  PHA
  AND #$000F
  INC         ; add one more jump
  CMP #$000A
  BMI SaveNew
  LDA #$0009
SaveNew:
  STA $09CA
  PLA
  AND #$FFF0
  ORA $09CA
  STA $09CA

  ;LDA #$0168  ; frame delay for music/messagebox
  ;JSL $82E118 ; do music

  LDA #$0200
  BIT $09A4
  BNE LoadNormalMessage
  LDA $0001,Y ; grab alternate message box arg
  BRA ShowMessage
LoadNormalMessage:
  LDA $0000,Y ; grab message box arg
ShowMessage:
  AND #$00FF  ; convert to byte
  JSL $858080 ; display message box

  INY         ; advance past our args, to next instruction
  INY
  RTS         ; return to PLM loop