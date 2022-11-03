lorom

; Bomb explosion collision check
;$94:9D17 20 52 A0    JSR $A052  [$94:A052]
;$94:9D1A 20 34 9D    JSR $9D34  [$94:9D34]  ; X = block index above (bug if bomb is laid on top row of room)
;$94:9D1D 20 52 A0    JSR $A052  [$94:A052]
;$94:9D20 20 3E 9D    JSR $9D3E  [$94:9D3E]  ; X = block index to the right
;$94:9D23 20 52 A0    JSR $A052  [$94:A052]
;$94:9D26 20 49 9D    JSR $9D49  [$94:9D49]  ; X = block index to the left
;$94:9D29 20 52 A0    JSR $A052  [$94:A052]
;$94:9D2C 20 4E 9D    JSR $9D4E  [$94:9D4E]  ; X = block index below
;$94:9D2F 20 52 A0    JSR $A052  [$94:A052]
;
;$94:9D32 60          RTS
;}

org $949D17
	TXA
	DEC : DEC
	SEC : SBC $07A5 : SBC $07A5
	TAX
	PHY
	LDY #$0002
	BRA bomb_check
warnpc $949D32

org $949D34
bomb_check:
	PHX
	JSR $A052 ; bomb react
	INX : INX
	JSR $A052 ; bomb react
	INX : INX
	JSR $A052 ; bomb react
	PLX
	TXA
	CLC : ADC $07A5 : ADC $07A5
	TAX
	DEY
	BPL bomb_check
	PLY
	RTS


;	TAX
;	JSR $A052 ; bomb react
;	INX : INX
;	JSR $A052 ; bomb react
;	INX : INX
;	JSR $A052 ; bomb react
;	PLA
;	SEC : SBC $07A5 : SBC $07A5
;	TAX
;	JSR $A052 ; bomb react
;	INX : INX
;	JSR $A052 ; bomb react
;	INX : INX
;	JSR $A052 ; bomb react
;	RTS
warnpc $949D59
