lorom

org $A7C3ED : JSR UnsetKillCounts ; STA $0E54

org $A7FF90 ; free space
UnsetKillCounts:
	STA $0E54 ; displaced
  	LDA $7ED842
  	SEC : SBC #$0004
 	STA $7ED842
	RTS

