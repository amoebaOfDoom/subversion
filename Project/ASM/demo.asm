lorom

; need to setup HDMA handler before gameplay is shown
org $828530
	JSL $8884B9  ; HDMA object handler (also handle music queue)
	JSR $8B44    ; Main gameplay
	JSL $808338  ; Wait for NMI


org $8286FC
	LDA #$0000
	; LDA #$FFFF
org $82872D
	LDA #$0000
	; LDA #$FFFF

org $918A43
;;; $8A43: Demo Samus setup - standing facing left - low health ;;; (unused now)
	; LDA #$0014             ;\
	; STA $09C2  [$7E:09C2]  ;} Samus health = 20

org $80D7F0
ApplyEnvironmentalDamage:
	LDA $09C2
	SEC : SBC $0A50
	STA $09C2
	STZ $0A50
    RTL

; stop demo
org $8285C5
	JSL ResetThermal

	BRA ClearEnemyData

	; LDA #$1C1F
	; DEC A     
	; DEC A     
	; SEC       
	; SBC #$198D
warnpc $8285CF
org $8285CE
ClearEnemyData:

; shinespark demo
org $918A72
	LDA #$00CC
	; LDA #$00CD


org $918A81
EnableHeatDamage:
	JSL ApplyEnvironmentalDamage
	RTS

ResetThermal:
	STZ $177C ; turn off glow effect
	JSL $9BB3A7 ; turn off dark visor
    LDA $09A2
    AND #$F7FF
    STA $09A2
	LDA #$0290
    RTL
warnpc $918A9B
