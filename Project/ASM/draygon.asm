lorom

; turrets are not affected by missiles/supers
org $84DB64:
	RTS

; double turret fire rate to compensate for more turrets
org $A587AD
	AND #$001F ; AND #$003F

; change turret list offset to allow all 6 to work
org $A587B6
	AND #$0007 ; AND #$0003
	NOP : NOP : NOP : NOP ; CLC : ADC #$0002

; set turret as not destroyed
org $A586F0
    NOP : NOP : NOP       ; LDA #$0001
	NOP : NOP : NOP : NOP ; STA $7E880A

org $A587C1
	LDA $7E8810,X ; LDA $7E8800,x


org $A587DC:
TurretPositions:
	DW $00B0, $0054
	DW $0034, $00C0
	DW $0034, $012F
	DW $01CC, $0101
	DW $01CC, $015E
	DW $0160, $0054

org $A59618 : JSR IncrementKills ; LDA #$C8C5

org $A5FC00
IncrementKills:
	JSL $81FAA5 ; Incremment kill count (challenges.asm)
	LDA #$C8C5 ; displaced
	RTS
