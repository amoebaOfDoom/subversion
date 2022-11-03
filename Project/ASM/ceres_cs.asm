lorom

org $95A82F
	incbin ROMProject/Graphics/space_station_mode7.gfx
org $8CE5E9
	incbin ROMProject/Graphics/space_station_mode7.pal
org $96FE69
	incbin ROMProject/Graphics/space_station_mode7.ttb
org $96D10A
	incbin ROMProject/Graphics/space_station_sprite.gfx


org $8BC29B
	JSR SpawnShipSprites ; JSR $938A ;} Spawn cinematic sprite object $CF33 (Ceres explosion spawner)


org $8BFC30 ; freespace
SpawnShipSprites:
	JSR $938A
	LDY.w #ShipSpriteHeader_L
	JSR $938A
	LDY.w #ShipSpriteHeader_R
	JSR $938A
	RTS

ShipSpriteHeader_L:
	DW #ShipSpriteHeader_L_Init
	DW #ShipSpriteHeader_L_Main
	DW #ShipSpriteHeader_L_Inst

ShipSpriteHeader_R:
	DW #ShipSpriteHeader_R_Init
	DW #ShipSpriteHeader_R_Main
	DW #ShipSpriteHeader_R_Inst


ShipSpriteHeader_L_Init:
	LDA #$0036
	STA $1A7D,y ; X
	LDA #$0094
	STA $1A9D,y ; Y
	LDA #$0C00
	STA $1ABD,y ; palette
	RTS

ShipSpriteHeader_R_Init:
	LDA #$0064
	STA $1A7D,y ; X
	LDA #$0090
	STA $1A9D,y ; Y
	LDA #$0C00
	STA $1ABD,y ; palette
	RTS

ShipSpriteHeader_L_Main:
	LDA $05B6
	AND #$000F
	BNE +
	LDA $1A7D,x ; X
	DEC
	STA $1A7D,x ; X
+
	LDA $05B6
	AND #$0007
	BNE +
	LDA $1A9D,x ; Y
	INC
	STA $1A9D,x ; Y
+
	RTS

ShipSpriteHeader_R_Main:
	LDA $05B6
	AND #$0003
	BNE +
	LDA $1A7D,x ; X
	INC
	STA $1A7D,x ; X
+
	LDA $05B6
	AND #$0007
	BNE +
	LDA $1A9D,x ; Y
	INC
	STA $1A9D,x ; Y
+
	RTS

ShipSpriteHeader_L_Inst:
	DW $0001, #ShipSpriteHeader_L_Sprite
	DW $9442 ; sleep

ShipSpriteHeader_R_Inst:
	DW $0001, #ShipSpriteHeader_R_Sprite
	DW $9442 ; sleep


org $8CF5A0 ; free space
ShipSpriteHeader_L_Sprite:
	DW $0004	
		DW $8000 : DB $00 : DW $3100
		DW $8010 : DB $00 : DW $3102
		DW $8000 : DB $10 : DW $3120
		DW $8010 : DB $10 : DW $3122

ShipSpriteHeader_R_Sprite:
	DW $0002
		DW $8000 : DB $00 : DW $3104
		DW $8010 : DB $00 : DW $3106

