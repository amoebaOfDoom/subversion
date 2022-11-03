lorom

org $B38902 : JSR CheckMaxHeight ; CMP samus_Y

org $B3F2B0
CheckMaxHeight:
	PHA
	CLC : ADC #$0100
	CMP $0FAC,X ; enemy_var2,x
	BPL .return
	PLA
	CLC 
	RTS 

.return
	PLA
	CMP $0AFA ; samus_Y ; displaced
	RTS
