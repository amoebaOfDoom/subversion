lorom

org $948EB2
	JSR AddSpikeDamage ; ADC #$003C

org $94DEF0
AddSpikeDamage:
	PHX : PHA
	LDA $079F ; area
	ASL : TAX : PLA
	CLC
	ADC DamageTable,X
	PLX
	RTS

DamageTable:
	DW 50 ; crateria
	DW 30 ; brinstar
	DW 70 ; norfair
	DW 40 ; wrecked ship
	DW 60 ; peaks
	DW 80 ; island
	DW 20 ; space port
	DW 20 ; cargo ship
