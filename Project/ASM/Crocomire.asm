lorom

!edge = #$075F


org $A4CBC5 : DW 0003, $FFCE,$FFDB,$0028,$FFF0,$B93D,$BA05, $FFCC,$FFC6,$002A,$FFDA,$B93D,$802D, $FFE0,$FFF3,$0028,$0000,$B93D,$802D
org $A4CBEB : DW 0003, $FFD2,$FFCB,$000D,$FFF0,$B93D,$BA05, $FFD7,$FFB6,$0010,$FFC7,$B93D,$802D, $FFDB,$FFF0,$0010,$FFFD,$B93D,$802D


org $A48A7A
  BIT #$0001 ;#$0002
org $A49B97
  ORA #$0001 ;#$0002
org $A4F681
  BIT #$0001 ;#$0002

org $A48C6E
  ;JSL $A48D5E
  LDX $0E54
  JSL $A48B5B
  RTS

;org $A48C6E
  JSR LedgeCheck ;JSL $A48D5E
  NOP

org $A4990A
  JSR LedgeCheck2 ;LDA $0FAE

org $A487CA
  JSR LedgeCheck2 ;LDA $0FAE

org $A4B93D ; body hitbox touch
  JSR SpeedCheck ;JSL $A0A477
  LDA #$FFFC
  STA $0B58
  RTL

org $A48ADC
  JSR SetScrolls
  NOP : NOP : NOP : NOP
  NOP : NOP : NOP : NOP
  ;LDA #$0101
  ;STA $7ECD20
  ;STA $7ECD22

org $A49B65
  JSR SetScrolls
  NOP : NOP : NOP : NOP
  NOP : NOP : NOP : NOP
  ;LDA #$0101
  ;STA $7ECD20
  ;STA $7ECD22

org $A48B06
  JMP $8B0E

org $A4997A
  JMP $9982

org $A48E9F
  JMP $8EA7

org $A4FCB0 ;free space
LedgeCheck:
  ;JSL $A48D5E ;Crack/collapse bridge
  LDA $0F7A ;X position
  CMP !edge+1
  BMI LedgeCheck_Exit:
  LDA !edge
  STA $0F7A
  JSL $A4B992
  STZ $0F9C ;Timer for hurt flash
LedgeCheck_Exit:
  RTS

LedgeCheck2:
  LDA $0F7A
  CMP !edge
  BMI LedgeCheck2_Exit
  STZ $0FAE
LedgeCheck2_Exit:
  LDA $0FAE
  RTS

SpeedCheck:
  LDA $0A6E ;Samus' contact damage index.
  AND #$00FF
  CMP #$0002
  BEQ SpeedCheck_Fast
  ;Normal contact
  LDX $0E54
  JSL $A0A477
  LDA $0FAA
  ORA #$4000
  STA $0FAA
  LDA #$0004 ; knockback
  STA $18AA
  STZ $0A54
  RTS
SpeedCheck_Fast:
LDA #$0001
STA $0DD0
JSL EndShineSpark

JSL $81FAA5 ; Incremment kill count (challenges.asm)

  LDA #$0008
  STA $183E ;Type of screen-shaking
  LDA #$0040
  STA $1840 ;Duration of screen-shaking
  ;LDA #$0010
  ;STA $0FAE

  PHK
  LDA #SpeedCheck_Exit-1
  PHA
  ;PEA $FCF1
  PHY
  JML $A48E44
  print pc
SpeedCheck_Exit:
  RTS

SetScrolls:
  LDA #$0102
  STA $7ECD20
  LDA #$0101
  STA $7ECD22
  RTS

SpawnWallProjectiles:
  LDX $0E54
  LDY #$90C1
  JSL $868027
  LDX $0E54
  LDY #AltSpikeWallProjectile
  JSL $868027
  RTS

LoadSpikeGraphics:
  LDY $0330
  LDA #$0400
  STA $00D0,Y
  LDA #$9700
  STA $00D3,Y
  LDA.w #SpikeGraphics
  STA $00D2,Y
  LDA #$7E00;#$FC00
  STA $00D5,Y
  TYA
  CLC
  ADC #$0007
  STA $0330
  RTS


org $90F716 ; free space
EndShineSpark:
  PHB : PHK : PLB
  JSR $D2BA ; end shine spark
  PLB
  RTL


org $97F440
SpikeGraphics:
  incbin ROMProject/Graphics/CrocWall.gfx

org $A4B8BD ; Sprite palette 2
  DW $0000, $02BF, $017F, $0015, $4F95, $42AE, $3206, $2523, $152A, $14C7, $1463, $0402, $0CA1, $1840, $7EB5, $0000
org $A4B91D ; Sprite palette 3
  DW $0000, $4F95, $42AE, $20E0, $1DA7, $2D21, $28A0, $1820, $26A9, $25E9, $1542, $0420, $26A9, $0082, $2771, $0000

org $A499AD
  JSR LoadSpikeGraphics
  LDA #$0004
  STA $12
-
  JSR SpawnWallProjectiles
  DEC $12
  BNE -
  LDA #$0030
  JSL $8090CB
  JMP $9BB3
  RTS

;  LDA #$0008
;  STA $12
;-
;  LDX $0E54
;  LDY #$90C1
;  JSL $868027
;  DEC $12
;  BNE -
;  LDA #$0030
;  JSL $8090CB
;  JMP $9BB3
;  RTS

org $86F580:
AltSpikeWallProjectile:
  DW $90CF, $9115, #AltSpikeWallProjectileList
  DB $00, $00
  DW $0000, $0000, $84FC
AltSpikeWallProjectileList:
  DW $7FFF, #AltSpikeWallProjectileSpriteMap
  DW $81AB, #AltSpikeWallProjectileList
org $8D8110
  DW $0004
  DW $C210 : DB $F8 : DW $25ED
  DW $C200 : DB $F8 : DW $25EB
  DW $C3F0 : DB $F8 : DW $27E9
  DW $C3E0 : DB $F8 : DW $27E7
;org $8D811C
AltSpikeWallProjectileSpriteMap:
  DW $0004
  DW $C210 : DB $F8 : DW $25E6
  DW $C200 : DB $F8 : DW $25E4
  DW $C3F0 : DB $F8 : DW $27E2
  DW $C3E0 : DB $F8 : DW $27E0

org $A48AF6
  JSL $8483D7
    DB $20,$03
    DW $B753
  JMP $8B0E

org $A490D0 
  NOP : NOP : NOP : NOP ;JSL $8483D7
  NOP : NOP : NOP : NOP ;dx 4E,03,B753

;$A4:97EB 22 D7 83 84 JSL $8483D7[$84:83D7]
;$A4:97EF             dx 30,03,B757

org $A49B3A
  JSL $8483D7
  DB $30, $03
  DW $B747

org $849B7F
  DW $8008, $0080, $0080, $0080, $0080, $0080, $0080, $0080, $0080
  DB $01, $00
  DW $8008, $0080, $0080, $0080, $0080, $0080, $0080, $0080, $0080
  DB $02, $00
  DW $8008, $0080, $0080, $0080, $0080, $0080, $0080, $0080, $0080
  DW $0000

org $849BBB
  DW $8008, $8080, $8AEE, $82EC, $82EE, $8AEE, $82EC, $82EE, $8080
  DW $0000
;$84:9BBB             dx 8008, 8080, 8107, 8127, 8107, 8127, 8147, 8080, 8080
;                        01, 00
;                        8008, 8080, 8108, 8128, 8108, 8128, 8148, 8080, 8080
;                        02, 00
;                        8008, 8080, 8109, 8129, 8109, 8129, 8149, 8080, 8080
;                        0000

org $849B5B
  DW $8008, $0080, $0AEE, $02EC, $02EE, $0AEE, $02EC, $02EE, $0080
  DW $0000