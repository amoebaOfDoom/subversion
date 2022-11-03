lorom

org $81A995 
	CMP $079F ;CMP $0950

org $81A99F
	LDA $1C
	ASL
	TAX
	CPX #$000C
	BEQ .space_port
.ground
	LDA $7ED830,X ; area transition flags
	BEQ BRANCH_NEXT
	BRA BRANCH_FOUND_USED_SAVE_POINT
.space_port
	LDA #$001D ; space 3
    JSL $808233 ; test event bit
	BCS BRANCH_NEXT
	BRA BRANCH_FOUND_USED_SAVE_POINT

LoadAlternateBG1Tilemap:
	LDA #$001D ; space 3
    JSL $808233 ; test event bit
	BCC LoadAlternateTilemap_return

	LDA.w #AlternateBG1Tilemap
	BRA LoadAlternateTilemap_return_set

LoadAlternateBG3Tilemap:
	LDA #$001D ; space 3
    JSL $808233 ; test event bit
	BCC LoadAlternateTilemap_return

	TYA
	XBA
	ASL A
	ASL A
	ASL A
	CLC
	ADC.w #AlternateBG3Tilemap

LoadAlternateTilemap_return_set:
	STA $D2,x
	LDA #$0089 ; source bank
	RTS
LoadAlternateTilemap_return:
    LDA #$0081 ; source bank
	RTS

warnpc $81A9EE
org $81A9EC
BRANCH_FOUND_USED_SAVE_POINT:
	LDA $1C
	ASL
	ASL
	TAX
warnpc $81A9F3

org $81A9FC
	NOP
	NOP
	NOP : NOP : NOP
	;ASL
	;TAX
	;LDA $AAA0,x

org $81AA0C
BRANCH_NEXT:

org $81A555
	JSR LoadAlternateBG1Tilemap ; LDA #$0081

org $81A59D
	JSR LoadAlternateBG3Tilemap ; LDA #$0081


org $89C000
AlternateBG1Tilemap:
	incbin ROMProject/Graphics/hexmapbg1.ttb
AlternateBG3Tilemap:
	incbin ROMProject/Graphics/hexmapbg3_area0.ttb
	incbin ROMProject/Graphics/hexmapbg3_area1.ttb
	incbin ROMProject/Graphics/hexmapbg3_area2.ttb
	incbin ROMProject/Graphics/hexmapbg3_area3.ttb
	incbin ROMProject/Graphics/hexmapbg3_area4.ttb

org $82C5D9
	DW Sprite_PLANET_TN578
	DW Sprite_OCEANIA
	DW Sprite_VULNAR
	DW Sprite_DEPTHS
	DW Sprite_LOMYR
	DW Sprite_PEAKS
	DW Sprite_ISLAND
	DW Sprite_SPACE_PORT

org $82CBFB
; Spritemap 38h: area select - planet Zebes
Sprite_PLANET_TN578:
	DW $0016 
	DW $01D0 : DB $F8 : DW $300D
	DW $01D0 : DB $00 : DW $3038
	DW $01D8 : DB $F8 : DW $3025
	DW $01D8 : DB $00 : DW $3035
	DW $01E0 : DB $F8 : DW $300A
	DW $01E0 : DB $00 : DW $301A
	DW $01E8 : DB $F8 : DW $3027
	DW $01E8 : DB $00 : DW $3037
	DW $01F0 : DB $F8 : DW $300E
	DW $01F0 : DB $00 : DW $301E
	DW $01F8 : DB $F8 : DW $302C
	DW $01F8 : DB $00 : DW $3011

	DW $0008 : DB $F8 : DW $302C
	DW $0008 : DB $00 : DW $3011
	DW $0010 : DB $F8 : DW $3027
	DW $0010 : DB $00 : DW $3037
	DW $0018 : DB $F8 : DW $3099
	DW $0018 : DB $00 : DW $30A9
	DW $0020 : DB $F8 : DW $30B1
	DW $0020 : DB $00 : DW $30C1
	DW $0028 : DB $F8 : DW $30B2
	DW $0028 : DB $00 : DW $30C2


Sprite_OCEANIA:
	DW $0007
	DW $0200-0-25 : DB $FC : DW $3078
	DW $0208-0-25 : DB $FC : DW $306C
	DW $0210-0-25 : DB $FC : DW $306E
	DW $0218-0-25 : DB $FC : DW $306A
	DW $0020-0-25 : DB $FC : DW $3077
	DW $0028-3-25 : DB $FC : DW $3072
	DW $0030-5-25 : DB $FC : DW $306A

Sprite_VULNAR:
	DW $0006
	DW $0200-0-23 : DB $FC : DW $307F
	DW $0208-0-23 : DB $FC : DW $307E
	DW $0210-0-23 : DB $FC : DW $3075
	DW $0018-0-23 : DB $FC : DW $3077
	DW $0020-0-23 : DB $FC : DW $306A
	DW $0028-0-23 : DB $FC : DW $307B

Sprite_DEPTHS:
	DW $0006
	DW $0200-0-23 : DB $FC : DW $306D
	DW $0208-0-23 : DB $FC : DW $306E
	DW $0210-0-23 : DB $FC : DW $3079
	DW $0018-1-23 : DB $FC : DW $307D
	DW $0020-2-23 : DB $FC : DW $3071
	DW $0028-2-23 : DB $FC : DW $307C

Sprite_LOMYR:
	DW $0005
	DW $0200-0-19 : DB $FC : DW $3075
	DW $0208-1-19 : DB $FC : DW $3078
	DW $0210-1-19 : DB $FC : DW $3076
	DW $0018-2-19 : DB $FC : DW $3082
	DW $0020-2-19 : DB $FC : DW $307B

Sprite_PEAKS:
	DW $0005
	DW $0200-0-20 : DB $FC : DW $3079
	DW $0208-0-20 : DB $FC : DW $306E
	DW $0210-0-20 : DB $FC : DW $306A
	DW $0018-0-20 : DB $FC : DW $3074
	DW $0020-0-20 : DB $FC : DW $307C

Sprite_ISLAND:
	DW $0006
	DW $0200-2-22 : DB $FC : DW $3072
	DW $0208-4-22 : DB $FC : DW $307C
	DW $0210-4-22 : DB $FC : DW $3075
	DW $0218-4-22 : DB $FC : DW $306A
	DW $0020-4-22 : DB $FC : DW $3077
	DW $0028-4-22 : DB $FC : DW $306D

Sprite_SPACE_PORT:
	DW $0009
	DW $0200-0-20 : DB $F8 : DW $307C
	DW $0208-0-20 : DB $F8 : DW $3079
	DW $0210-0-20 : DB $F8 : DW $306A
	DW $0018-0-20 : DB $F8 : DW $306C
	DW $0020-0-20 : DB $F8 : DW $306E

	DW $0200+5-20 : DB $00 : DW $3079
	DW $0208+5-20 : DB $00 : DW $3078
	DW $0010+5-20 : DB $00 : DW $307B
	DW $0018+5-20 : DB $00 : DW $307D

warnpc $82CDCE

