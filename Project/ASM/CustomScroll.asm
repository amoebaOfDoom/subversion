lorom

!leftbound  = #$0050
!rightbound = #$00B0

org $8FE99A
    JSL $88A7D8 ; scrolling sky init code
	LDA #BoundScrolling
	STA $07E9

	LDA #$FFFF
	STA $05D5
	STA $05D7
	RTS

; 0911 ; screen x-pos
; 0915 ; screen y-pos
; 0AF6 ; Samus's X position in pixels
; 0AFA ; Samus's Y position in pixels
; 05D5 ; Saved X-Scroll position ($0911). Unused (Debug mode)
; 05D7 ; Saved Y-Scroll position ($0915). Unused (Debug mode)
org $90F7B0
BoundScrolling:
	LDA $0911

	LDX $05D7
	BPL $06
	LDX $0915
	STX $05D7

	LDX $05D5
	BPL $04
	STA $05D5
	TAX

	;LDX $0AFA
	;CPX #$0100
	;BCC BoundScrollingContinue
	LDX $0AF6
	CPX !leftbound+$18
	BCC AlcoveScrolling
	CPX !rightbound-$18+$100
	BCS AlcoveScrolling

	LDX $05D5
LeftBound:
	CMP !leftbound
	BCS RightBound
	CPX !leftbound
	BCS SnapLeftBound
ScrollLeftBound:
	INC A
	INC A
	BRA RightBound
SnapLeftBound:
	LDA !leftbound

RightBound:
	CMP !rightbound+1
	BCC Return
	CPX !rightbound+1
	BCS ScrollRightBound
SnapRightBound:
	LDA !rightbound
	BRA Return
ScrollRightBound:
	DEC A
	DEC A
	BRA Return
	
AlcoveScrolling:
	LDX $05D7 ; fix the y-scroll
	STX $0915

Return:
	STA $0911
	STA $05D5
	LDA $0915
	STA $05D7
	RTS


print pc
