lorom

;org $AFF400
;GFXLocation:
;	incbin ROMProject/Graphics/Geron.gfx
;
;org $A0F940
;	DW $0C00 ;GFX size
;	DW #GeronPalette ;Enemy Palette pointer
;	DW $0014 ;Energy
;	DW $0020 ;Damage
;	DW $0008 ;Width
;	DW $0020 ;Height
;	DB $A4 ;AI Bank
;	DB $00 ;Hurt Flash duration
;	DW $003E ;Hurt Sound
;	DW $0000 ;Boss Value
;	DW #GeronInitAI ;Initiation AI
;	DW $0001 ;Possessors
;	DW $0000 ;UNUSED [Extra AI #1: $0016,X]
;	DW #GeronRunAI ;Main AI
;	DW $800F ;Grapple AI
;	DW $804C ;Hurt AI
;	DW $8041 ;Frozen AI
;	DW $0000 ;X-Ray AI
;	DW $0004 ;Death Animation
;	DW $0000 ;UNUSED [Extra AI #2: $0024,X]
;	DW $0000 ;UNUSED [Extra AI #3: $0026,X]
;	DW $0000 ;Power Bomb AI
;	DW $0000 ;UNUSED [Extra AI #4: $002A,X]
;	DW $0000 ;UNUSED [Extra AI #5: $002C,X]
;	DW $0000 ;UNUSED [Extra AI #6: $002E,X]
;	DW $804C ;Touch AI
;	DW #GeronShotAI ;Shot AI
;	DW $0000 ;UNUSED [Extra AI #7: $0034,X]
;	DL #GFXLocation ;Enemy Graphics pointer
;	DB $05 ;Layer Priority
;	DW #GeronDrops ;Drops pointer ($B4)
;	DW #GeronWeaknesses ;Enemy Weaknesses pointer ($B4)
;	DW #GeronName ;Enemy Name pointer ($B4)
;
;org $B4F55A
;GeronWeaknesses:
;	DB $00 ;Power beam
;	DB $00 ;Wave beam
;	DB $FF ;Ice beam
;	DB $FF ;Ice + Wave beam
;	DB $00 ;Spazer beam
;	DB $00 ;Spazer + Wave beam
;	DB $FF ;Spazer + Ice beam
;	DB $FF ;Spazer + Wave + Ice beam
;	DB $00 ;Plasma beam
;	DB $00 ;Plasma + Wave beam
;	DB $FF ;Plasma + Ice beam
;	DB $FF ;Plasma + Wave + Ice beam
;	DB $00 ;Missiles
;	DB $00 ;Super missiles
;	DB $00 ;Bombs
;	DB $00 ;Power bombs
;	DB $00 ;Speedbooster
;	DB $00 ;Shinespark
;	DB $00 ;Screw Attack
;	DB $00 ;Charge beam / Hyper beam
;	DB $00 ;Psuedo screw attack
;	DB $02 ;Unused
;GeronDrops:
;	DB $00 ;small energy
;	DB $00 ;large energy
;	DB $00 ;missile
;	DB $00 ;nothing
;	DB $7F ;super missile
;	DB $80 ;power bomb
;GeronName:
;	DB $47,$45,$52,$4F,$4E,$20,$20,$20,$20,$20
;print pc

org $A4F6D0
GeronPalette:
	DW $0000, $67D3, $5B8F, $4F2C, $46A9, $3E47, $2D63, $2501, $5BFF, $03FC, $037D, $029F, $05FE, $10DD, $3831, $538E

{
GeronTileMap1:
	DW $0001,GeronStructure1,$812F
GeronTileMap2:
	DW $0001,GeronStructure2,$812F
GeronTileMap3:
	DW $0001,GeronStructure3,$812F

GeronTileMap4:
	DW $0001,GeronStructure4,$812F
GeronTileMap5:
	DW $0001,GeronStructure5,$812F
GeronTileMap6:
	DW $0001,GeronStructure6,$812F
GeronTileMap7:
	DW $0001,GeronStructure7,$812F
GeronTileMap8:
	DW $0001,GeronStructure8,$812F

GeronStructure1:
	DW $000C
	DW $0000,$FFE8,Map1_TL,GeronHitbox
	DW $0010,$FFE8,Map1_TR,GeronHitbox_R
	DW $0000,$FFF8,Map1_UL,GeronHitbox
	DW $0010,$FFF8,Map1_UR,GeronHitbox_R
	DW $0000,$0008,Map1_LL,GeronHitbox
	DW $0010,$0008,Map1_LR,GeronHitbox_R
	DW $0000,$0018,Map1_BL,GeronHitbox
	DW $0010,$0018,Map1_BR,GeronHitbox_R
	DW $0000,$FFF8,Map_Claw_UL,GeronHitbox
	DW $0010,$FFF8,Map_Claw_UR,GeronHitbox_R
	DW $0000,$0008,Map_Claw_LL,GeronHitbox
	DW $0010,$0008,Map_Claw_LR,GeronHitbox_R
GeronStructure2:
	DW $000C
	DW $0000,$FFE8,Map2_TL,GeronHitbox
	DW $0010,$FFE8,Map2_TR,GeronHitbox_R
	DW $0000,$FFF8,Map2_UL,GeronHitbox
	DW $0010,$FFF8,Map2_UR,GeronHitbox_R
	DW $0000,$0008,Map2_LL,GeronHitbox
	DW $0010,$0008,Map2_LR,GeronHitbox_R
	DW $0000,$0018,Map2_BL,GeronHitbox
	DW $0010,$0018,Map2_BR,GeronHitbox_R
	DW $0000,$FFF8,Map_Claw_UL,GeronHitbox
	DW $0010,$FFF8,Map_Claw_UR,GeronHitbox_R
	DW $0000,$0008,Map_Claw_LL,GeronHitbox
	DW $0010,$0008,Map_Claw_LR,GeronHitbox_R
GeronStructure3:
	DW $000C
	DW $0000,$FFE8,Map3_TL,GeronHitbox
	DW $0010,$FFE8,Map3_TR,GeronHitbox_R
	DW $0000,$FFF8,Map3_UL,GeronHitbox
	DW $0010,$FFF8,Map3_UR,GeronHitbox_R
	DW $0000,$0008,Map3_LL,GeronHitbox
	DW $0010,$0008,Map3_LR,GeronHitbox_R
	DW $0000,$0018,Map3_BL,GeronHitbox
	DW $0010,$0018,Map3_BR,GeronHitbox_R
	DW $0000,$FFF8,Map_Claw_UL,GeronHitbox
	DW $0010,$FFF8,Map_Claw_UR,GeronHitbox_R
	DW $0000,$0008,Map_Claw_LL,GeronHitbox
	DW $0010,$0008,Map_Claw_LR,GeronHitbox_R

GeronStructure4:
	DW $0008
	DW $0000,$FFE8,Map1_TL,GeronHitbox
	DW $0010,$FFE8,Map1_TR,GeronHitbox_R
	DW $0000,$0018,Map1_BL,GeronHitbox
	DW $0010,$0018,Map1_BR,GeronHitbox_R
	DW $0000,$FFF8,Map_Claw_UL,GeronHitbox
	DW $0010,$FFF8,Map_Claw_UR,GeronHitbox_R
	DW $0000,$0008,Map_Claw_LL,GeronHitbox
	DW $0010,$0008,Map_Claw_LR,GeronHitbox_R
GeronStructure5:
	DW $0008
	DW $0000,$FFE8,Map5_TL,GeronHitbox
	DW $0010,$FFE8,Map5_TR,GeronHitbox_R
	DW $0000,$FFF8,Map5_UL,GeronHitbox
	DW $0010,$FFF8,Map5_UR,GeronHitbox_R
	DW $0000,$0008,Map5_LL,GeronHitbox
	DW $0010,$0008,Map5_LR,GeronHitbox_R
	DW $0000,$0018,Map5_BL,GeronHitbox
	DW $0010,$0018,Map5_BR,GeronHitbox_R
GeronStructure6:
	DW $0004
	DW $0000,$FFE8,Map6_TL,GeronHitbox
	DW $0010,$FFE8,Map6_TR,GeronHitbox_R
	DW $0000,$0018,Map6_BL,GeronHitbox
	DW $0010,$0018,Map6_BR,GeronHitbox_R
GeronStructure7:
	DW $0004
	DW $0000,$FFE8,Map7_TL,GeronHitbox
	DW $0010,$FFE8,Map7_TR,GeronHitbox_R
	DW $0000,$0018,Map7_BL,GeronHitbox
	DW $0010,$0018,Map7_BR,GeronHitbox_R
GeronStructure8:
	DW $0004
	DW $0000,$FFE8,Map8_TL,GeronHitbox
	DW $0010,$FFE8,Map8_TR,GeronHitbox_R
	DW $0000,$0018,Map8_BL,GeronHitbox
	DW $0010,$0018,Map8_BR,GeronHitbox_R

Map_Claw_UL:
	DW $0003
	;DB $F0,$01,$F8,$1C,$21
	DB $F8,$01,$F8,$1D,$21
	DB $F0,$01,$00,$2C,$21
	DB $F8,$01,$00,$2D,$21
Map_Claw_UR:
	DW $0003
	DB $F0,$01,$F8,$1E,$21
	;DB $F8,$01,$F8,$1F,$21
	DB $F0,$01,$00,$2E,$21
	DB $F8,$01,$00,$2F,$21
Map_Claw_LL:
	DW $0003
	DB $F0,$01,$F8,$2C,$A1
	DB $F8,$01,$F8,$2D,$A1
	;DB $F0,$01,$00,$1C,$A1
	DB $F8,$01,$00,$1D,$A1
Map_Claw_LR:
	DW $0003
	DB $F0,$01,$F8,$2E,$A1
	DB $F8,$01,$F8,$2F,$A1
	DB $F0,$01,$00,$1E,$A1
	;DB $F8,$01,$00,$1F,$A1

Map1_TL:
	DW $0003
	DB $F0,$01,$F8,$00,$21
	DB $F8,$01,$F8,$01,$21
	;DB $F0,$01,$00,$10,$21
	DB $F8,$01,$00,$11,$21
Map1_TR:
	DW $0003
	DB $F0,$01,$F8,$02,$21
	DB $F8,$01,$F8,$03,$21
	DB $F0,$01,$00,$12,$21
	;DB $F8,$01,$00,$13,$21
Map1_BL:
	DW $0003
	;DB $F0,$01,$F8,$10,$A1
	DB $F8,$01,$F8,$11,$A1
	DB $F0,$01,$00,$00,$A1
	DB $F8,$01,$00,$01,$A1
Map1_BR:
	DW $0003
	DB $F0,$01,$F8,$12,$A1
	;DB $F8,$01,$F8,$13,$A1
	DB $F0,$01,$00,$02,$A1
	DB $F8,$01,$00,$03,$A1
Map1_UL:
	DW $0001
	DB $F0,$81,$F8,$20,$21
Map1_UR:
	DW $0001
	DB $F0,$81,$F8,$22,$21
Map1_LL:
	DW $0001
	DB $F0,$81,$F8,$40,$21
Map1_LR:
	DW $0001
	DB $F0,$81,$F8,$42,$21

Map2_TL:
	DW $0003
	DB $F0,$01,$F8,$04,$21
	DB $F8,$01,$F8,$05,$21
	;DB $F0,$01,$00,$14,$21
	DB $F8,$01,$00,$15,$21
Map2_TR:
	DW $0003
	DB $F0,$01,$F8,$06,$21
	DB $F8,$01,$F8,$07,$21
	DB $F0,$01,$00,$16,$21
	;DB $F8,$01,$00,$17,$21
Map2_BL:
	DW $0003
	;DB $F0,$01,$F8,$14,$A1
	DB $F8,$01,$F8,$15,$A1
	DB $F0,$01,$00,$04,$A1
	DB $F8,$01,$00,$05,$A1
Map2_BR:
	DW $0003
	DB $F0,$01,$F8,$16,$A1
	;DB $F8,$01,$F8,$17,$A1
	DB $F0,$01,$00,$06,$A1
	DB $F8,$01,$00,$07,$A1
Map2_UL:
	DW $0001
	DB $F0,$81,$F8,$24,$21
Map2_UR:
	DW $0001
	DB $F0,$81,$F8,$26,$21
Map2_LL:
	DW $0001
	DB $F0,$81,$F8,$44,$21
Map2_LR:
	DW $0001
	DB $F0,$81,$F8,$46,$21

Map3_TL:
	DW $0003
	DB $F0,$01,$F8,$08,$21
	DB $F8,$01,$F8,$09,$21
	;DB $F0,$01,$00,$18,$21
	DB $F8,$01,$00,$19,$21
Map3_TR:
	DW $0003
	DB $F0,$01,$F8,$0A,$21
	DB $F8,$01,$F8,$0B,$21
	DB $F0,$01,$00,$1A,$21
	;DB $F8,$01,$00,$1B,$21
Map3_BL:
	DW $0003
	;DB $F0,$01,$F8,$18,$A1
	DB $F8,$01,$F8,$19,$A1
	DB $F0,$01,$00,$08,$A1
	DB $F8,$01,$00,$09,$A1
Map3_BR:
	DW $0003
	DB $F0,$01,$F8,$1A,$A1
	;DB $F8,$01,$F8,$1B,$A1
	DB $F0,$01,$00,$0A,$A1
	DB $F8,$01,$00,$0B,$A1
Map3_UL:
	DW $0001
	DB $F0,$81,$F8,$28,$21
Map3_UR:
	DW $0001
	DB $F0,$81,$F8,$2A,$21
Map3_LL:
	DW $0001
	DB $F0,$81,$F8,$48,$21
Map3_LR:
	DW $0001
	DB $F0,$81,$F8,$4A,$21

Map5_TL:
	DW $0003
	DB $F0,$01,$F8,$04,$21
	DB $F8,$01,$F8,$05,$21
	;DB $F0,$01,$00,$1A,$21
	DB $F8,$01,$00,$1B,$21
Map5_TR:
	DW $0003
	DB $F0,$01,$F8,$06,$21
	DB $F8,$01,$F8,$07,$21
	DB $F0,$01,$00,$1C,$21
	;DB $F8,$01,$00,$1D,$21
Map5_BL:
	DW $0003
	;DB $F0,$01,$F8,$1A,$A1
	DB $F8,$01,$F8,$1B,$A1
	DB $F0,$01,$00,$04,$A1
	DB $F8,$01,$00,$05,$A1
Map5_BR:
	DW $0003
	DB $F0,$01,$F8,$1C,$A1
	;DB $F8,$01,$F8,$1D,$A1
	DB $F0,$01,$00,$06,$A1
	DB $F8,$01,$00,$07,$A1
Map5_UL:
	DW $0002
	DB $F0,$01,$F8,$13,$21
	DB $F8,$01,$F8,$14,$21
Map5_UR:
	DW $0002
	DB $F0,$01,$F8,$17,$21
	DB $F8,$01,$F8,$18,$21
Map5_LL:
	DW $0002
	DB $F0,$01,$00,$13,$A1
	DB $F8,$01,$00,$14,$A1
Map5_LR:
	DW $0002
	DB $F0,$01,$00,$17,$A1
	DB $F8,$01,$00,$18,$A1

Map6_TL:
	DW $0001
	DB $F0,$81,$F8,$4C,$21
Map6_TR:
	DW $0001
	DB $F0,$81,$F8,$4E,$21
Map6_BL:
	DW $0001
	DB $F0,$81,$F8,$4C,$A1
Map6_BR:
	DW $0001
	DB $F0,$81,$F8,$4E,$A1

Map7_TL:
	DW $0002
	DB $F0,$01,$F8,$3C,$21
	DB $F8,$01,$F8,$3D,$21
Map7_TR:
	DW $0002
	DB $F0,$01,$F8,$3E,$21
	DB $F8,$01,$F8,$3F,$21
Map7_BL:
	DW $0002
	DB $F0,$01,$00,$3C,$A1
	DB $F8,$01,$00,$3D,$A1
Map7_BR:
	DW $0002
	DB $F0,$01,$00,$3E,$A1
	DB $F8,$01,$00,$3F,$A1

Map8_TL:
	DW $0002
	DB $F0,$01,$F8,$0C,$21
	DB $F8,$01,$F8,$0D,$21
Map8_TR:
	DW $0002
	DB $F0,$01,$F8,$0E,$21
	DB $F8,$01,$F8,$0F,$21
Map8_BL:
	DW $0002
	DB $F0,$01,$00,$0C,$A1
	DB $F8,$01,$00,$0D,$A1
Map8_BR:
	DW $0002
	DB $F0,$01,$00,$0E,$A1
	DB $F8,$01,$00,$0F,$A1

GeronHitbox:
	DW $0001
	DW $FFF7,$FFF7,$0009,$0009,GeronTouchAI,GeronShotAI

GeronTileMaps:
	DW GeronTileMap1, GeronTileMap2, GeronTileMap3, GeronTileMap2
GeronTileMapDead:
	DW GeronTileMap4, GeronTileMap5, GeronTileMap6, GeronTileMap7, GeronTileMap8
}

GeronInitAI:
	;force flags so that the enemy can run regardless of what was set in SMILE
	LDX $0E54 ;Current Enemy Index
	LDA $0F86,X : ORA #$B000 : STA $0F86,X ;Property bits (Special from SMILE) - set Platform and Block Plasma
	LDA $0F88,X : ORA #$0004 : STA $0F88,X ;Extra property bits - set Extended tilemap format
	LDA #GeronTileMap1
	STA $0F92,X ;Tilemaps in SMILE - load the first tilemap in the animation
	STZ $0FA8,X
	STZ $0FAA,X
	STZ $0FAC,X
	RTL

GeronRunAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FAA,X
	BNE GeronRunAI_Dead

	LDA $7E1842
	BIT #$0007
	BNE GeronRunAI_Exit
	LDA $0FA8,X
	INC
	AND #$0003
	STA $0FA8,X

GeronRunAI_SetAnimation:
	ASL
	TAY
	LDA GeronTileMaps,Y
	STA $0F92,X ;Tilemaps in SMILE
	LDA #$0001
	STA $0F94,X
GeronRunAI_Exit:
	RTL

GeronRunAI_Dead:
	LDA $7E1842
	BIT #$0003
	BNE GeronRunAI_Exit
	LDA $0FA8,X
	INC
	STA $0FA8,X
	CMP #$0009
	BMI GeronRunAI_SetAnimation
	STZ $0F78,X ;Enemy ID Pointer
	RTL

print pc
GeronShotAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FAA,X
	BNE GeronShotAI_Dead
	LDA $0F9E,X
	BNE GeronShotAI_Frozen
GeronShotAI_Block:
	JMP $802D

GeronShotAI_Frozen:
	LDA $18A6 ;Projectile index
	ASL A
	TAY
	LDA $0C18,Y ;Projectile type array
	BIT #$8000 ;only live projectiles
	BEQ GeronShotAI_Block
	BIT #$0200 ;is super?
	BNE GeronShotAI_Kill
	BIT #$0100 ;is missile?
	BEQ GeronShotAI_Block
	LDA $0FAC,X
	CMP #$0004
	BEQ GeronShotAI_Kill
	INC
	STA $0FAC,X
	JSR PlayEnemyHit
	BRA GeronShotAI_Block

GeronShotAI_Kill:
	INC $0FAA,X
	STZ $0F9E,X ;Frozen timer
	LDA $0F86,X : AND #$2FFF : STA $0F86,X ;Property bits (Special from SMILE) - unset Platform and Block Plasma
	INC $0E50 ;enemy kill counter
	JSL $81FAA5 ; Incremment kill count (challenges.asm)	
	JSR PlayEnemyHit
	JSR PlayExplosions
GeronShotAI_Dead:
	RTL

PlayEnemyHit:
	LDA $0F7A,x
	STA $12
	LDA $0F7E,x
	STA $14
	LDA #$0037
	STA $16
	STZ $18
	JSL $B4BC26
	RTS

PlayExplosions:
	PHP
	PHB
	PEA $A000
	PLB
	PLB
	LDA #$0004 ;explosion type
	STA $0E20
	LDY #$F345
	JSL $868027
	PLB
	PLP
	RTS

GeronTouchAI:
	LDX $0E54 ;Current Enemy Index
	LDA $0FAA,X
	BNE GeronTouchAI_Exit
	LDA $0F9E,X ;Frozen timer
	BNE GeronTouchAI_Exit
	JMP $8023
GeronTouchAI_Exit:
	RTL

GeronHitbox_R:
	DW $0001
	DW $FFF0,$FFF0,$FFF7,$FFF7,GeronTouchAI,GeronShotAI