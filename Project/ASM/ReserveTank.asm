lorom

;;; $9B44: Handle HUD tilemap (HUD routine when game is paused/running) ;;;
; in hud2.5 org $809B4E : LDA #$0000 ;LDA $09C0  ;\
org $809B59 : LDA #$0000 ;LDA $09D6  ;\

;;; $DB69: Handle Samus running out of health and increment game time ;;;
org $82DB73 : LDA #$0000 ;LDA $09C0

;;; $8986: Instruction - collect [[Y]] health reserve tank ;;;
org $848986
	INC $09D4
	STZ $0A06 ; set prev hp to 0 to force hp updates
	BRA CollectReserveContinue
org $848998
	CollectReserveContinue:

;;; Collect health refill
org $86F143 : ADC #$0000 ;ADC $09D6  ;} If [Samus' health] + [Samus' reserve health] >= 30:
org $86F17F : LDY #$0000 ;LDY $09D6  ;\
org $86F182 : CPY #$0000 ;CPY $09D4  ;} If [Samus' reserve health] = [Samus' max reserve health]: go to BRANCH_FULL_HEALTH

;;; $D5A2: Crystal flash ;;;
org $90D5CD : LDA #$0000 ;LDA $09D6  ;\

;;; $DF12: Give health to Samus ;;;
org $91DF2D : ADC #$0000 ;ADC $09D6  ;|
org $91DF30 : CMP #$0000 ;CMP $09D4  ;} Samus' reserve health = min([Samus' max reserve health], health overflow + Samus' reserve health)
org $91DF38 : NOP : NOP : NOP ;STA $09D6  ;/
org $91DF3D : LDA #$0000 ;LDA $09C0  ;\
org $91DF45 : NOP : NOP : NOP ;STA $09C0  ;} Reserve health mode = auto

org $91E3BA : LDA #$0000 ;LDA #$01F3 ;\
org $91E3BD : NOP : NOP : NOP ;STA $09D6  ;} Current reserve tanks = 499

org $A9CAA9 : LDA #$0000 ;LDA $09D4
org $A9CAAC : NOP : NOP : NOP ;STA $09D6

