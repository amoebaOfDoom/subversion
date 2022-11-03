lorom 

org $829E2B
	LDA $05AE  ;\
	CLC        ;|
	ADC $05AC  ;|
	LSR A      ;|
	NOP
	AND #$FFF8
	;CLC        ;} BG1 X scroll = midpoint([map min X scroll], [map max X scroll]) - 80h
	;ADC $05AC  ;|
