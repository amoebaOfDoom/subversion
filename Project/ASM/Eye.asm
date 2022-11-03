lorom

;org $A89050 : DW $0080 ; activate x range
;org $A89052 : DW $00B0 ; deactivate x range
;org $A89054 : DW $0080 ; activate y range
;org $A89056 : DW $0080 ; deactivate y range


org $A890E5
	LDA $09A4
	BIT #$1000
	BNE $03
