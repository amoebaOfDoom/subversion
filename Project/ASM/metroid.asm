lorom

org $A3F014
	JSR HitBeamDisplaced

org $A3FFC0
HitBeamDisplaced:
	LDA #$0010 ; destroy projectile
	STA $0C04,Y
	LDA #$0008 ; flash timer
	RTS

CheckHyper:
	LDX $0E54
	LDA.w $0C2C,Y ; damage
	CMP.w #1000
	BCS .return
	LDA $0F9E,X ; frozen
.return
	RTS

warnpc $A40000

org $A3EF16
	JSR CheckHyper
	BCS DoDamage
	BEQ NotFrozen
	NOP

org $A3EF2E
DoDamage:
org $A3EF79
NotFrozen:
