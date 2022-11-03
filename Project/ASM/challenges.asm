lorom

!challenge_address = $7FFF10
!kills_address     = $7ED842
!deaths_address    = $7FFE7E
!animals_event     = $000F
!dev_room_event    = $001E
!text_offset       = $7E3600
!time_offset       = $7E362A
!item_offset       = $7E3624
!DifficultyAddress = $7ED827 ;sram that stores difficulty used by game.
!DifficultyPage    = $7FFD80
!challenges_unlock = $7FFF08


org $819F49 : LDX #$0246
org $819F5B : LDX #$025C
org $819F67 : LDX #$02B4
org $819F76 : LDX #$0276

org $819F7F : LDX #$0346
org $819F91 : LDX #$035C
org $819F9D : LDX #$03B4
org $819FAC : LDX #$0376

org $81A027 : LDA #$002F 
org $81A02D : LDA #$004F 
org $81A033 : LDA #$006F 

org $819526 : LDA.w FileSelectCursorPos+0,x 
org $81952C : LDA.w FileSelectCursorPos+2,x 
org $81A061 : LDA.w FileSelectCursorPos+0,x 
org $81A067 : LDA.w FileSelectCursorPos+2,x 
org $81A2BF : LDA.w FileSelectCursorPos+0,x 
org $81A2C5 : LDA.w FileSelectCursorPos+2,x 

org $81A269 : LDA #$0006
org $81A274 : LDA #$0006
org $81A279 : CMP #$0005

org $81A28F : CMP #$0007
org $81A2A2 : CMP #$0007
org $81A2A7 : LDA #$0006

org $81A2CC : CMP #$0004
org $81A2E6 : CMP #$0005
org $81A306 : CMP #$0006

org $81A27E : LDA #$0003
org $81A29D : CMP #$0004

org $81A25E
MoveUp_Start:
org $81A281 : JSR CheckChallengesUnlockedUp   ; STA $0952
org $81A286
MoveDown_Start:
org $81A2AF : JSR CheckChallengesUnlockedDown ; STA $0952

org $819FDE : JSR LoadChallengesItem ; LDY #$B4EE

org $819405 : JSR.w (MenuIndexTable,X) ;JSR ($940A,x)[$81:944E];/

org $81A311
	CMP #$0003
	BNE .return
	JSR GotoChallengesPage
.return
	RTS

warnpc $81A32A

;org $81940A
;pad $81944D

org $81FAA0 ; free space
print "SetAchievements"
print pc
SetAchievements_Long: ; used in SkipCeres
	JSL SetAchievements
	RTL

print "IncrementKills"
print pc
IncrementKills_Long:
  LDA $7ED842
  INC
  BEQ +
  STA $7ED842
+
	RTL

MenuIndexTable:
;	DW $944E, $9E93, $9ED6, $A058, $A1C2, $94EE, $9561, $9532, $96C2, $977A, $9813, $98B7, $9984, $9A2C, $9AFA, $94F4
;	DW $9EF3, $951E, $9B28, $94EE, $9B33, $9532, $9B64, $9C0B, $9C36, $9C9E, $9D26, $94F4, $9EF3, $951E, $9D68, $9D77
;	DW $94A3, $94D5, $94EE, #LoadChallenges, $9532, #ChallengesMain

	DW $944E, $9E93, $9ED6, $A058, $A1C2, $94EE, $9561, $9532, $96C2, $977A, $9813, $98B7, $9984, $9A2C, $9AFA, $94F4
	DW $9EF3, $951E, $9B28, $94EE, $9B33, $9532, $9B64, $9C0B, $9C36, $9C9E, $9D26, $94F4, $9EF3, $951E, $9D68, $9D77
	DW $94A3, $94D5, $94EE, #LoadChallenges, #ChallengesFadeIn, #ChallengesMain

FileSelectCursorPos:
;;; $A312: File select menu selection missile co-ordinates ;;;
;                  ________ Y position
;                 |     ___ X position
;                 |    |
	        DW $0030, $000E ; Slot A
	        DW $0050, $000E ; Slot B
	        DW $0070, $000E ; Slot C
	        DW $008B, $000E ; Challenges
	        DW $00A3, $000E ; File copy
	        DW $00BB, $000E ; File clear
	        DW $00D3, $000E ; Exit

ChallengesTilemap:
	DW $206C ; C
	DW $2071 ; H
	DW $206A ; A
	DW $2075 ; L
	DW $2075 ; L
	DW $206E ; E
	DW $2077 ; N
	DW $2070 ; G
	DW $206E ; E
	DW $207C ; S
	DW $FFFF

LockedTilemap:
	DW $248A ; (
	DW $2475 ; L
	DW $2478 ; O
	DW $246C ; C
	DW $2474 ; K
	DW $246E ; E
	DW $246D ; D
	DW $248B ; )
	DW $FFFF

ChallengesHeader_Top:
	DW $200C ; C
	DW $2021 ; H
	DW $200A ; A
	DW $2025 ; L
	DW $2025 ; L
	DW $200E ; E
	DW $2027 ; N
	DW $200C ; G
	DW $200E ; E
	DW $202B ; S
	DW $FFFF
ChallengesHeader_Bottom:
	DW $201C ; C
	DW $2031 ; H
	DW $201A ; A
	DW $2035 ; L
	DW $2035 ; L
	DW $201E ; E
	DW $2037 ; N
	DW $2030 ; G
	DW $201E ; E
	DW $203B ; S
	DW $FFFF

GotoChallengesPage:
	LDA #$0038   ;\
	JSL $809049  ;} Queue sound 37h, sound library 1, max queued sounds allowed = 6 (moved cursor)
	LDA $57      ;\
	AND #$FF0F   ;|
	ORA #$0003   ;} Enable BG1/2 mosaic, block size = 0
	STA $57      ;/	
	LDA #$0022   ; index
	STA $0727
	RTS

LoadChallengesItem:
	LDY.w #LockedTilemap
	LDA !challenges_unlock
	BEQ +
	LDY.w #ChallengesTilemap
+

	LDX #$0448
	STZ $0F96 
	JSR $B3E2 

	LDY #$B4EE ; displaced
	RTS

CheckChallengesUnlockedUp:
	STA $0952
	CMP #$0003
	BNE .return
	LDA !challenges_unlock
	BNE .return
	PLA 
	PEA.w MoveUp_Start-1
.return
	RTS

CheckChallengesUnlockedDown:
	STA $0952
	CMP #$0003
	BNE .return
	LDA !challenges_unlock
	BNE .return
	PLA 
	PEA.w MoveDown_Start-1
.return
	RTS

LoadChallenges:
	JSR $95A6 ; clear tiles

	LDY.w #ChallengesHeader_Top
	LDX #$0056
	STZ $0F96 
	JSR $B3E2 
	LDY.w #ChallengesHeader_Bottom
	LDX #$0096
	STZ $0F96 
	JSR $B3E2 

	JSL DrawChallenges

	JSR $969F ; dma tiles
	JSL $808382 ; wait NMI
	INC $0727
	RTS

ChallengesFadeIn:
	REP #$30
	JMP $9538

ChallengesMain:
	LDA $8F ; new inputs
	BEQ .return
	LDA #$0038   ;\
	JSL $809049  ;} Queue sound 37h, sound library 1, max queued sounds allowed = 6 (moved cursor)
	LDA $57      ;\
	AND #$FF0F   ;|
	ORA #$0003   ;} Enable BG1/2 mosaic, block size = 0
	STA $57      ;/	
	LDA #$0003
	STA $0952
	LDA #$000F   ; index
	STA $0727

.return
	JSL $82BA35 ; draw box border
	RTS

warnpc $820000


org $A0A40A
	JSR AddKillCount ; INC $0E50

org $A0FFE0
AddKillCount:
	LDA !kills_address
	INC
	BEQ +
	STA !kills_address
+
	INC $0E50 ; displaced
	RTS

org $A18000
Challenges:
	DW #Challenge_1, #Challenge_2, #Challenge_3, #Challenge_4
	DW #Challenge_5, #Challenge_6, #Challenge_7, #Challenge_8
	DW #Challenge_9
	DW $0000

Challenge_1:
  DW .test, .goal, #GetNothing, #DrawTime, .text, .textGoal
.text
  DB "ANY% SPEEDRUN",$00
.textGoal
  DB "GOAL 1:45:00",$00
.goal
	LDA.w #01
	CMP !challenge_address+0,X
	BNE .goal_return
	LDA.w #45
	CMP !challenge_address+2,X
	BNE .goal_return
	LDA.w #00
	CMP !challenge_address+4,X
.goal_return
	RTS
.test
	JSR CompareTimes
	RTS
Challenge_2:
  DW .test, .goal, #GetNothing, #DrawTime, .text, .textGoal
.text
  DB "100% SPEEDRUN",$00
.textGoal
  DB "GOAL 2:20:00",$00
.goal
	LDA.w #02
	CMP !challenge_address+0,X
	BNE .goal_return
	LDA.w #20
	CMP !challenge_address+2,X
	BNE .goal_return
	LDA.w #00
	CMP !challenge_address+4,X
.goal_return
	RTS

.test
	JSR GetItemTotal
	CMP $94DC40 ; item total count in EquipmentScreen.asm
	BNE +
	JSR CompareTimes
	RTS
+
	CLC
	RTS
Challenge_3:
  DW .test, .goal, #GetItemTotal, .draw, .text, .textGoal
.text
  DB "LOW% ITEMS             . %",$00
.textGoal
  DB "GOAL 15.5%",$00
.goal
	LDA.w #20
	CMP !challenge_address+6,X
	RTS
.test
	JSR CheckNew
	BCS +
	JSR GetItemTotal
	STA $00
	LDA !challenge_address+6,X
	CMP $00
+
	RTS
.draw
	LDA $06
	AND #$1C00
	BEQ .item
.noItem
	LDA #$2487 ; -
	STA $7E3636-0,X
	STA $7E3636-4,X
	STA $7E3636-6,X
	BRA .draw_return
.item
print pc
  LDA #$2060 ; 0
  CLC : ADC $06
  STA $7E3632,X
  STA $7E3636,X

	PHY
	PHX
	LDX $02
	LDA !challenge_address+6,X
	LDY #$0006
	STZ $08

-
  STA $4204 ; dividend

	PLA : PHA
	CLC : ADC.w .offsets,Y
	TAX

  SEP #$20         
  LDA $94DC40 ; item total count in EquipmentScreen.asm
  STA $4206 ; divisor
  PHA : PLA : PHA : PLA : REP #$20

  LDA $08
  BEQ +
  LDA $4214 ; result
  CLC : ADC #$2060
  CLC : ADC $06
  STA $7E3600,X
  BRA .next
+

  LDA $4214 ; result
  BEQ .next
  CLC : ADC #$2060
  CLC : ADC $06
  STA $7E3600,X
  INC $08
.next
	LDA $4216
	JSR Mult10	
	DEY : DEY
	BPL -
	PLX
	PLY
.draw_return	
	RTS

.offsets
	DW $0036, $0032, $0030, $002E


Challenge_4:
  DW .test, .goal, .get, .draw, .text, .textGoal
.text
  DB "PACIFIST             KILLS",$00
.textGoal
  DB "GOAL 100 KILLS",$00
.test
	JSR CheckNew
	BCS +
	LDA !challenge_address+6,X
	CMP !kills_address
+
	RTS
.goal
	LDA.w #101
	CMP !challenge_address+6,X
	RTS
.get
	LDA !kills_address
	RTS 
.draw
	LDA $06
	AND #$1C00
	BEQ .item
.noItem
	LDA #$2487 ; -
	STA $7E362C-0,X
	STA $7E362C-2,X
	STA $7E362C-4,X
	BRA .draw_return
.item
	PHX
	TXA
	CLC : ADC.w #$002C
	TAX
	PHX
	LDX $02
	LDA !challenge_address+6,X
	PLX
	JSR DrawNumber
	PLX
.draw_return
	RTS


Challenge_5:
  DW .test, $0000, #GetNothing, $0000, .text, $0000
.text
  DB "DEATHLESS",$00
.test
	CLC
	LDA !deaths_address
	BNE +
	SEC
+
	RTS
Challenge_6:
  DW .test, $0000, #GetNothing, $0000, .text, $0000
.text
  DB "SKIP VARIA SUIT",$00
.test
	CLC
	LDA $09A4 ; equipment
	BIT #$0001
	BNE +
	SEC
+
	RTS
Challenge_7:
  DW .test, $0000, #GetNothing, $0000, .text, $0000
.text
  DB "SKIP PLASMA BEAM",$00
.test
	CLC
	LDA $09A8 ; beams
	BIT #$0008
	BNE +
	SEC
+
	RTS
Challenge_8:
  DW .test, $0000, #GetNothing, $0000, .text, $0000
.text
  DB "SAVE THE ANIMALS",$00
.test
	LDA #!animals_event
	JSL $808233 ; test event
	RTS
Challenge_9:
  DW .test, $0000, #GetNothing, $0000, .text, $0000
.text
  DB "FORBIDDEN ROOM",$00
.test
	LDA #!dev_room_event
	JSL $808233 ; test event
	RTS

GetNothing:
	LDA #$0000
	RTS


GetItemTotal:
	PHX
	LDX #$0007
	LDA #$0000
-
	CLC
	ADC $7ED868,X
	DEX
	BPL -
	AND #$00FF
	PLX
	RTS

CheckNew:
	CLC
	; check zero
	LDA !challenge_address+4,X
	BNE +
	LDA !challenge_address+2,X
	BNE +
	LDA !challenge_address+0,X
	BNE +
	SEC
+
	RTS

; Input X = challenge sram address
; Return C=1 if new time PB
CompareTimes:
	JSR CheckNew
	BCS .return

	LDA !challenge_address+0,X
	CMP $09E0 ; Game time, hours
	BNE .return
	LDA !challenge_address+2,X
	CMP $09DE ; Game time, minutes
	BNE .return
	LDA !challenge_address+4,X
	CMP $09DC ; Game time, seconds
.return
	RTS


Exec_00:	
	JMP ($0000)


SetAchievements:
	PHB : PHK : PLB : PHX : PHY : PHA
	LDA !DifficultyAddress
  AND #$0007
  CMP #$0004 ; easy
  BEQ .return

	LDY #$0000
.loop
	LDX.w Challenges,Y
	BEQ .return
	LDA $0000,X
	STA $00

	TYA
	ASL : ASL : ASL
	TAX

	; check test
	JSR Exec_00
	BCC .nextChallenge

	LDA $09E0 ; Game time, hours
	STA !challenge_address+0,X
	LDA $09DE ; Game time, minutes
	STA !challenge_address+2,X
	LDA $09DC ; Game time, seconds
	STA !challenge_address+4,X

	PHX
	LDX.w Challenges,Y
	LDA $0004,X
	STA $00
	PLX

	; get value
	JSR Exec_00
	STA !challenge_address+6,X

.nextChallenge
	INY : INY
	BRA .loop
.return
	LDA #$0001
	STA !challenges_unlock
	PLA : PLY : PLX : PLB
	RTL

ASCII_Table:
	DB $8F, $0F, $0F, $0F, $0F, $8D, $0F, $0F, $8A, $8B, $0F, $86, $89, $87, $88, $0F
	DB $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $8C, $0F, $0F, $0F, $0F, $0F
	DB $0F, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $77, $78
	DB $79, $7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83, $0F, $0F, $0F, $0F, $0F

DrawText:
	LDA $0000,Y
	AND #$00FF
	BEQ .return
	PHY
	TAY
	LDA ASCII_Table-$20,Y
	AND #$00FF
	PLY
	CLC : ADC $06
	ORA #$2000
	STA !text_offset,X
	INX : INX : INY
	BRA DrawText
.return
	RTS

DrawTime:
	LDA $06
	AND #$1C00
	BEQ .time

.noTime
	LDA #$2487 ; -
	STA !time_offset+0,X
	STA !time_offset+2,X
	STA !time_offset+6,X
	STA !time_offset+8,X
	STA !time_offset+12,X
	STA !time_offset+14,X
	LDA #$248C ; :
	STA !time_offset+4,X
	STA !time_offset+10,X
	JMP .return

.time
	LDA #$2060 ; 0
	CLC : ADC $06
	STA !time_offset+0,X
	STA !time_offset+2,X
	STA !time_offset+6,X
	STA !time_offset+8,X
	STA !time_offset+12,X
	STA !time_offset+14,X
	LDA #$208C ; :
	CLC : ADC $06
	STA !time_offset+4,X
	STA !time_offset+10,X

	LDA $04
	CLC : ADC.w #!time_offset&$003F+2
	STA $00

	LDX $02
	LDA !challenge_address+0,X ; hour
	LDX $00
	JSR DrawNumber
	LDA $00
	CLC : ADC #$0006
	STA $00

	LDX $02
	LDA !challenge_address+2,X ; min
	LDX $00
	JSR DrawNumber
	LDA $00
	CLC : ADC #$0006
	STA $00

	LDX $02
	LDA !challenge_address+4,X ; sec
	LDX $00
	JSR DrawNumber

.return
	RTS


Mult10:
  ASL
  STA $12
  ASL
  ASL
  CLC
  ADC $12
  RTS

DrawDigit:
  STA $4204 ; dividend
  SEP #$20 : LDA #$0A : STA $4206 ; divisor
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4216 ; remainder

  CLC : ADC #$2060
  CLC : ADC $06
  STA $7E3600,X
  DEX : DEX
  LDA $4214 ; result
  RTS

DrawNumber:
	JSR DrawDigit
  BNE DrawNumber
  RTS

print pc
DrawChallenges:
	PHB : PHK : PLB : PHX : PHY : PHA
	LDY #$0000
	LDA #$0180
	STA $04 ; tile offset
.loop
	TYA
	ASL : ASL : ASL
	STA $02 ; sram offset
	TAX

	PHY
	LDA #$0400
	STA $06 ; color
	JSR CheckNew
	BCS +

	LDA #$00D0
	STA $06

	; check goal
	LDA.w Challenges,Y
	TAY
	LDA $0002,Y
	BEQ +
	STA $00
	JSR Exec_00
	BCS +
	STZ $06
+
	PLY

	PHY
	LDA.w Challenges,Y
	TAY

	; draw text
	PHY
	LDA $0008,Y
	TAY
	LDA $04
	CLC : ADC #$0006
	TAX
	JSR DrawText
	PLY

	; draw value
	PHY
	LDA $0006,Y
	BEQ +
	STA $00
	LDX $04
	JSR Exec_00
+
	PLY

	; draw goal
	PHY
	LDA $000A,Y
	BEQ ++
	TAY
	LDA $04
	CLC : ADC #$0040
	STA $04
	CLC : ADC #$000C
	TAX
	JSR DrawText
++
	PLY

.nextChallenge
	LDA $04
	CLC : ADC #$0080
	STA $04

	PLY
	INY : INY
	LDA.w Challenges,Y
	BEQ .return
	JMP .loop

.return
	PLA : PLY : PLX : PLB
	RTL
