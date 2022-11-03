lorom

;tile used is BF in CRE
;crumble block  bts is $08

org $91D3AA	;x-ray reaction to display correctly
DB $BF

org $949149	;crumble block bts $08 
DW #Norespawn

org $949DB4	;bomb reaction table
DW #Bombreact

org $84F580
Norespawn:
DW Init,Animate

Init:
LDA $0A1C	;7E:0A1C - 7E:0A1D    Samus's current position/state
CMP #$0081
BEQ Screw
CMP #$0082
BEQ Screw
CMP #$0083
BEQ WallJump
CMP #$0084
BEQ WallJump
Solid:
LDA #$0000
STA $1C37,Y	;7E:1C37 - 7E:1C86    PLM header table
SEC
RTS
WallJump:
LDA $09A2
BIT #$0008
BEQ Solid
Screw:
CLC
RTS

Animate:
DB $7C,$8C,$06 	;play a sound
DW $0001,$A345
DW $0001,$A34B
DW $0001,$A351
DW $0030,$A357
DW $86BC

Bombreact:
DW $CFA0,Reveal

Reveal:
DW $0001,Showtile,$86BC

Showtile:
DB $01,$00,$BF,$B0,$00,$00
