LoRom

;Speed = XYZZ
;		X - Speed of X movement (can be negative)
;		Y - Speed of Y movement (can be negative)
;		ZZ - Delay when spike hits a wall before moving away again (pixels)
;Speed2 = XXYY
;		XX - Distance spike can be moved by shooting (pixels)
;		YY - Pause timer when shot (frames)

;org $A0FAC0
;	DW $0000,#Palette,$7FFF,$0030,$0007,$0007
;	DB $A5,$00,$00,$00,$00,$00
;	DW #Initiation,$0001,$0000,#Running,$800F,$804C,$8041,$0000,$0000
;	DW $0000,$0000,$0000,$0000,$0000,$0000,$8023,#ShotReact,$0000
;	DL $000000
;	DB $02
;	DW $F320,$F026,$DDEB
org $A5FA00
;Palette:
;	DW $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
;	DW $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
Initiation:
	LDX $0E54
	LDA #InstructionList : STA $0F92,X
	STZ $0FAC,X : STZ $0FAE,X : STZ $0FB0,X
	LDA $0FB4,X : AND #$F000 : LSR : LSR : LSR : LSR : XBA : JSR NegativeSpeedCheck : STA $0FA8,X
	LDA $0FB4,X : AND #$0F00 : XBA : JSR NegativeSpeedCheck : STA $0FAA,X
	RTL
NegativeSpeedCheck:
	CMP #$0008 : BCC $03 : ORA #$FFF0 : RTS

print pc
Running:
	JSR ShotMoveCheck
	LDX $0E54
	LDA $0FAC,X : BEQ MoveSpikes : DEC $0FAC,X
	RTL
MoveSpikes:
	JSR HSpikes : STA $0FA8,X
	JSR VSpikes : STA $0FAA,X
	RTL

print pc
ShotReact:
	PHY
	LDX $0E54
	LDA $0FB6,X
	AND #$00FF
	BEQ +
	STA $0FAC,X
	STA $0F94,X
+
	LDA $0FB6,X
	AND #$FF00
	BEQ ++
	XBA
	STA $0FAE,X
++
	LDA $18A6
	ASL
	TAY
	LDA $0C04,Y
	AND #$000F
	STA $0FB0,X
	PLY
	JMP $802D

HSpikes:
	LDA $0FA8,X : PHA
	CLC
	BPL +
	SEC
+
	ROR
	STA $14
	LDA #$0000
	ROR
	STA $12
	JSL $A0C69D
	STZ $12
	BCS HitWall
	PLA : RTS
VSpikes:
	LDA $0FAA,X : PHA
	CLC
	BPL +
	SEC
+
	ROR
	STA $14
	LDA #$0000
	ROR
	STA $12
	JSL $A0C778
	STZ $12
	BCS HitWall
	PLA : RTS
HitWall:
	LDA #$002F : JSL $8090C1
	LDA $0FB4,X : AND #$00FF : STA $0FAC,X
	PLA : EOR #$FFFF : INC : RTS

ShotMoveCheck:
	LDX $0E54
	LDA $0FAE,X : BEQ EndMoveCheck : DEC : STA $0FAE,X
	LDA $0FB0,X : AND #$000F : ASL : TAX
	STZ $12 : JSR (ShotMoveTable,X)
EndMoveCheck:
	RTS

ShotMoveTable:
	DW ShotMoveUpR,ShotMoveUpRight, ShotMoveRight, ShotMoveDownRight, ShotMoveDownR
	DW ShotMoveDownL, ShotMoveDownLeft, ShotMoveLeft, ShotMoveUpLeft, ShotMoveUpL
ShotMoveUpR:
ShotMoveUpL:
	LDX $0E54 : LDA #$FFFF : STA $14 : JSL $A0C778 : RTS
ShotMoveUpRight:
	LDX $0E54 : LDA #$FFFF : STA $14 : JSL $A0C778 : LDA #$0001 : STA $14 : JSL $A0C69D : RTS
ShotMoveRight:
	LDX $0E54 : LDA #$0001 : STA $14 : JSL $A0C69D : RTS
ShotMoveDownRight:
	LDX $0E54 : LDA #$0001 : STA $14 : JSL $A0C778 : LDA #$0001 : STA $14 : JSL $A0C69D : RTS
ShotMoveDownR:
ShotMoveDownL:
	LDX $0E54 : LDA #$0001 : STA $14 : JSL $A0C778 : RTS
ShotMoveDownLeft:
	LDX $0E54 : LDA #$0001 : STA $14 : JSL $A0C778 : LDA #$FFFF : STA $14 : JSL $A0C69D : RTS
ShotMoveLeft:
	LDX $0E54 : LDA #$FFFF : STA $14 : JSL $A0C69D : RTS
ShotMoveUpLeft:
	LDX $0E54 : LDA #$FFFF : STA $14 : JSL $A0C778 : LDA #$FFFF : STA $14 : JSL $A0C69D : RTS

InstructionList:
	DW $0006,SpriteMap1
	DW $0006,SpriteMap2
	DW $0006,SpriteMap3
	DW $0006,SpriteMap4
	DW $80ED,InstructionList
SpriteMap1:
	DW $0004
	DB $F8,$01,$F8,$00,$21
	DB $00,$00,$F8,$01,$21
	DB $F8,$01,$00,$02,$21
	DB $00,$00,$00,$03,$21
SpriteMap2:
	DW $0004
	DB $F8,$01,$F8,$04,$21
	DB $00,$00,$F8,$05,$21
	DB $F8,$01,$00,$06,$21
	DB $00,$00,$00,$07,$21
SpriteMap3:
	DW $0004
	DB $F8,$01,$F8,$08,$21
	DB $00,$00,$F8,$09,$21
	DB $F8,$01,$00,$0A,$21
	DB $00,$00,$00,$0B,$21
SpriteMap4:
	DW $0004
	DB $F8,$01,$F8,$0C,$21
	DB $00,$00,$F8,$0D,$21
	DB $F8,$01,$00,$0E,$21
	DB $00,$00,$00,$0F,$21