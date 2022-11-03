lorom 

org $8080AF
	JSR LoadNewBlockHeader
	BRA NewBlockEnd

org $8080C4
NewBlockEnd:

org $80F000 ; freespace
LoadNewBlockHeader:
	LDA $0000,Y
	JSR $8103   ; inc Y bank split
	XBA
	LDA $0000,Y
	JSR $8103   ; inc Y bank split
	XBA
	TAX         ; block size
	LDA $0000,Y
	JSR $8103   ; inc Y bank split
	STA $002142 ; destination address low
	LDA $0000,Y
	JSR $8103   ; inc Y bank split
	STA $002143 ; destination address high
	RTS
