lorom

org $8BA3B0
	JSR GiveMissiles ; LDA #$0384

org $8BB76C
	JSR TakeMissiles ; STZ $09C8

;;; $F760: Free space ;;;
org $8BF8A0
GiveMissiles:
    LDA $09A2 ; load equipped items
    ORA #$0400 ; gravity boots
    STA $09A2
	INC $09CE
	LDA #$0384
	RTS

TakeMissiles:
    LDA $09A2 ; load equipped items
    AND #$FBFF ; gravity boots
    STA $09A2
	STZ $09CE
	STZ $09C8
	RTS

;;; $95:80D8: Tiles - title sprites ;;;
org $9580D8
	incbin ROMProject/Graphics/title_sprite.gfx


;;; $A0EF: Cinematic sprite object definitions ;;;
;         _________________ Initialisation function
;        |       __________ Pre-instruction
;        |      |       ___ Instruction list
;        |      |      |
org $8BA0EF
	DW $9CBC, $9CCF, $A03D
	DW $9D4A, $93D9, SpriteObj_SMART
	DW $9DC3, $93D9, SpriteObj_PRESENTS
	DW $9E45, $93D9, SpriteObj_METROID_3_1
	DW $9EB3, $93D9, $A0C5
	DW $9ED6, $93D9, $A0D3
	DW $9EFF, $93D9, $A0E1
	DW $9B1A, $93D9, $A0CB
	DW $9B2D, $93D9, $A0D9
	DW $9B40, $93D9, $A0E7


org $8BA055
SpriteObj_SMART:
	DW $0008, $88CE
	DW $0008, $88DA
	DW $0008, $88F0
	DW $0008, $8910
	DW $0045, $893A
	;DW $9D5D
	DW $9438       ; Delete

SpriteObj_PRESENTS:
	DW $0008, $8A46
	DW $0008, $8A52
	DW $0008, $8A68
	DW $0008, $8A88
	DW $0008, $8AB2
	DW $0008, $8AE6
	DW $0008, $8B24
	DW $002D, $8B6C
	;DW $9DD6
	DW $9438        ; Delete

SpriteObj_METROID_3_1:
	DW $0008, $8BBE
	DW $0008, $8BCA
	DW $0008, $8BE0
	DW $0008, $85C8
	DW $0008, $85F2
	DW $0008, $867D
	DW $0008, $86BB
	DW $0008, $8703
	DW $0008, $874B
	DW $0008, Sprite_METROID_3_
	DW $0068, Sprite_METROID_3_1
	;DW $9E58
	DW $9438        ; Delete

warnpc $8BA0C6

org $8BA03D
SpriteObj_2022:
	DW $003C, $0000 
	DW $0008, $8862 
	DW $0008, $886E 
	DW $0008, $8884 
	DW $002D, $88A4 
;	DW $9CE1
    DW $9438        ; Delete


;;; $8862: '2' ;;;
org $8C8862
	DW $0002
	DW $0008 : DB $00 : DW $33FF
	DW $0008 : DB $F8 : DW $33EF

;;; $886E: '20' ;;;
org $8C886E
	DW $0004
	DW $0008 : DB $00 : DW $33FE
	DW $0008 : DB $F8 : DW $33EE
	DW $0000 : DB $00 : DW $33FF
	DW $0000 : DB $F8 : DW $33EF

;;; $8884: '202' ;;;
org $8C8884
	DW $0006
	DW $01F8 : DB $00 : DW $33FF
	DW $01F8 : DB $F8 : DW $33EF
	DW $0000 : DB $00 : DW $33FE
	DW $0000 : DB $F8 : DW $33EE
	DW $0008 : DB $00 : DW $33FF
	DW $0008 : DB $F8 : DW $33EF

;;; $88A4: '2022' ;;;
org $8C88A4
	DW $0008
	DW $01F0 : DB $00 : DW $33FF
	DW $01F0 : DB $F8 : DW $33EF
	DW $01F8 : DB $00 : DW $33FE
	DW $01F8 : DB $F8 : DW $33EE
	DW $0000 : DB $00 : DW $33FF
	DW $0000 : DB $F8 : DW $33EF
	DW $0008 : DB $00 : DW $33FF
	DW $0008 : DB $F8 : DW $33EF


;;; $88CE: 'S' ;;;
org $8C88CE
	DW $0002
	DW $0010 : DB $F8 : DW $33A7
	DW $0010 : DB $00 : DW $33B7

;;; $88DA: 'SM' ;;;
org $8C88DA
	DW $0004
	DW $0010 : DB $F8 : DW $338A
	DW $0010 : DB $00 : DW $339A
	DW $0008 : DB $F8 : DW $33A7
	DW $0008 : DB $00 : DW $33B7

;;; $88F0: 'SMA' ;;;
org $8C88F0
	DW $0006
	DW $0010 : DB $F8 : DW $3367
	DW $0010 : DB $00 : DW $3377
	DW $0008 : DB $F8 : DW $338A
	DW $0008 : DB $00 : DW $339A
	DW $0000 : DB $F8 : DW $33A7
	DW $0000 : DB $00 : DW $33B7

;;; $8910: 'SMAR' ;;;
org $8C8910
	DW $0008
	DW $0010 : DB $F8 : DW $338F
	DW $0010 : DB $00 : DW $339F
	DW $0008 : DB $F8 : DW $3367
	DW $0008 : DB $00 : DW $3377
	DW $0000 : DB $F8 : DW $338A
	DW $0000 : DB $00 : DW $339A
	DW $01F8 : DB $F8 : DW $33A7
	DW $01F8 : DB $00 : DW $33B7

;;; $893A: 'SMART' ;;;
org $8C893A
	DW $000A
	DW $0010 : DB $F8 : DW $33A8
	DW $0010 : DB $00 : DW $33B8
	DW $0008 : DB $F8 : DW $338F
	DW $0008 : DB $00 : DW $339F
	DW $0000 : DB $F8 : DW $3367
	DW $0000 : DB $00 : DW $3377
	DW $01F8 : DB $F8 : DW $338A
	DW $01F8 : DB $00 : DW $339A
	DW $01F0 : DB $F8 : DW $33A7
	DW $01F0 : DB $00 : DW $33B7

;;; $874B: 'METROID 3.' ;;;
Sprite_METROID_3_:
	DW $0011
	DW $001C : DB $00 : DW $33ED
	DW $0014 : DB $00 : DW $3311
	DW $0014 : DB $F8 : DW $3301
	DW $0004 : DB $00 : DW $337A
	DW $0004 : DB $F8 : DW $336A
	DW $01FC : DB $00 : DW $337F
	DW $01FC : DB $F8 : DW $336F
	DW $01F4 : DB $00 : DW $339C
	DW $01F4 : DB $F8 : DW $338C
	DW $01EC : DB $00 : DW $339F
	DW $01EC : DB $F8 : DW $338F
	DW $01E4 : DB $00 : DW $33B8
	DW $01E4 : DB $F8 : DW $33A8
	DW $01DC : DB $00 : DW $337B
	DW $01DC : DB $F8 : DW $336B
	DW $01D4 : DB $00 : DW $339A
	DW $01D4 : DB $F8 : DW $338A

;;; $874B: 'METROID 3.1' ;;;
Sprite_METROID_3_1:
	DW $0013
	DW $001C : DB $00 : DW $3310
	DW $001C : DB $F8 : DW $3300
	DW $0014 : DB $00 : DW $33ED
	DW $000C : DB $00 : DW $3311
	DW $000C : DB $F8 : DW $3301
	DW $01FC : DB $00 : DW $337A
	DW $01FC : DB $F8 : DW $336A
	DW $01F4 : DB $00 : DW $337F
	DW $01F4 : DB $F8 : DW $336F
	DW $01EC : DB $00 : DW $339C
	DW $01EC : DB $F8 : DW $338C
	DW $01E4 : DB $00 : DW $339F
	DW $01E4 : DB $F8 : DW $338F
	DW $01DC : DB $00 : DW $33B8
	DW $01DC : DB $F8 : DW $33A8
	DW $01D4 : DB $00 : DW $337B
	DW $01D4 : DB $F8 : DW $336B
	DW $01CC : DB $00 : DW $339A
	DW $01CC : DB $F8 : DW $338A

warnpc $8C8A467

org $8B9E45
	; Metroid 3.1 x pos
	LDA #$0089 ;LDA #$0081

org $8B9EB9
	; Super metroid y pos
	LDA #$0028 ; LDA #$0030
org $8B9B20
	; Super metroid y pos
	LDA #$0028 ; LDA #$0030



;;; $A0C5: Instruction list - cinematic sprite object $A107 (yyyy) ;;;
org $8BA0C5
	DW $0020, Sprite_SUPER_METROID
	DW $9ECD


;;; $A0CB: Instruction list - cinematic sprite object $A119 (yyyy) ;;;
org $8BA0CB
	DW $0001, Sprite_SUPER_METROID
	DW $94BC, $A0CB   ; Go to $A0CB

;;; $A0E1: Instruction list - cinematic sprite object $A113 (yyyy) ;;;
org $8BA0E1
	DW $0020, Sprite_CopyrightText
	DW $9F19

;;; $A0E7: Instruction list - cinematic sprite object $A125 (yyyy) ;;;
org $8BA0E7
	DW $0001, Sprite_CopyrightText
	DW $94BC, $A0E7  ; Go to $A0E7

;;; $879D: SUPER METROID title logo ;;;
org $8CF3E9
Sprite_SUPER_METROID:
	DW $003B
	DW $0058 : DB $18 : DW $349C
	DW $0048 : DB $F8 : DW $341E
	DW $C238 : DB $F0 : DW $340C
	DW $C248 : DB $10 : DW $348A
	DW $C238 : DB $10 : DW $3488
	DW $C228 : DB $10 : DW $3486
	DW $C250 : DB $00 : DW $3484
	DW $C240 : DB $00 : DW $3482
	DW $C230 : DB $00 : DW $3480
	DW $C218 : DB $10 : DW $346E
	DW $C208 : DB $10 : DW $346C
	DW $C3F8 : DB $10 : DW $346A
	DW $C3E8 : DB $10 : DW $3468
	DW $C3D8 : DB $10 : DW $3466
	DW $C3C8 : DB $10 : DW $3464
	DW $C3B8 : DB $10 : DW $3462
	DW $C3A8 : DB $10 : DW $3460
	DW $C220 : DB $00 : DW $344E
	DW $C210 : DB $00 : DW $344C
	DW $C200 : DB $00 : DW $344A
	DW $C3F0 : DB $00 : DW $3448
	DW $C3E0 : DB $00 : DW $3446
	DW $C3D0 : DB $00 : DW $3444
	DW $C3C0 : DB $00 : DW $3442
	DW $C3B0 : DB $00 : DW $3440
	DW $C228 : DB $F0 : DW $342E
	DW $C218 : DB $F0 : DW $342C
	DW $C208 : DB $F0 : DW $342A
	DW $C3F8 : DB $F0 : DW $3428
	DW $C3E8 : DB $F0 : DW $3426
	DW $C3D8 : DB $F0 : DW $3424
	DW $C3C8 : DB $F0 : DW $3422
	DW $C3B8 : DB $F0 : DW $3420
	DW $C220 : DB $E0 : DW $340A
	DW $C210 : DB $E0 : DW $3408
	DW $C200 : DB $E0 : DW $3406
	DW $C3F0 : DB $E0 : DW $3404
	DW $C3E0 : DB $E0 : DW $3402
	DW $C3D0 : DB $E0 : DW $3400

	DW $81B6 : DB $22 : DW $34E0
	DW $81C6 : DB $22 : DW $34E2
	DW $81D6 : DB $22 : DW $34E4
	DW $81E6 : DB $22 : DW $34E6
	DW $81F6 : DB $22 : DW $34E8

	DW $8006 : DB $22 : DW $34EA
	DW $8016 : DB $22 : DW $34EC
	DW $8026 : DB $22 : DW $34EE
	DW $8036 : DB $22 : DW $3528
	DW $0046 : DB $2A : DW $353A

	DW $81AE : DB $32 : DW $3502
	DW $81BE : DB $32 : DW $3504
	DW $81CE : DB $32 : DW $3506
	DW $81DE : DB $32 : DW $3508
	DW $81EE : DB $32 : DW $350A

	DW $81FE : DB $32 : DW $350C
	DW $800E : DB $32 : DW $350E
	DW $801E : DB $32 : DW $3522
	DW $802E : DB $32 : DW $3524
	DW $803E : DB $32 : DW $3526

Sprite_CopyrightText:
	DW $001B
	DW $0190 : DB $06 : DW $31C1 ; c
	DW $0198 : DB $06 : DW $31C2 ; 20
	DW $01A0 : DB $06 : DW $31C3 ; 2
	DW $01A8 : DB $06 : DW $31C4 ; 2

	DW $01B0 : DB $06 : DW $31E3 ; t
	DW $01B8 : DB $06 : DW $31D4 ; e
	DW $01C0 : DB $06 : DW $31E2 ; s
	DW $01C8 : DB $06 : DW $31E3 ; t

	DW $01D2 : DB $06 : DW $31E1 ; r
	DW $01DA : DB $06 : DW $31E4 ; u
	DW $01E2 : DB $06 : DW $31DD ; n
	DW $01EA : DB $06 : DW $31DD ; n
	DW $01F2 : DB $06 : DW $31D4 ; e
	DW $01FA : DB $06 : DW $31E1 ; r

	DW $0002 : DB $06 : DW $31EA ; +

	DW $000C : DB $06 : DW $31D0 ; a
	DW $0014 : DB $06 : DW $31DC ; m
	DW $001C : DB $06 : DW $31DE ; o
	DW $0024 : DB $06 : DW $31D4 ; e
	DW $002C : DB $06 : DW $31D1 ; b
	DW $0034 : DB $06 : DW $31D0 ; a

	DW $003E : DB $06 : DW $31DE ; o
	DW $0046 : DB $06 : DW $31D5 ; f

	DW $0050 : DB $06 : DW $31D3 ; d
	DW $0058 : DB $06 : DW $31DE ; o
	DW $0060 : DB $06 : DW $31DE ; o
	DW $0068 : DB $06 : DW $31DC ; m

warnpc $8CFFFF
