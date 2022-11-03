;
; To use:
; 1) Map station PLM must be the first plm in the room
; 2) Only one map station plm in a room will work exactly as expected
; 3) Set map station room arg
;    - 000F for the left half
;    - 00F0 for the right half
;    - 00FF for the whole map
;
; Map sprites (elevator labels) and boss icons will only show on the half of the map that has been collected.
; Note boss icons will always show if the boss is dead (vanilla).
; Missile refil, energy refil, and map station icons show if you have been in the room (vanilla).
;

lorom

org $8085E1
  LDX $079F
  SEP #$20
  LDA $0789
  STA $7ED908,x
  REP #$20
  PLP
  RTL

;Bank $82.html-$82:9EC1 85 B3       STA $B3    [$7E:00B3]
;Bank $82.html-
;Bank $82.html-$82:9EC3 60          RTS
;Bank $82.html-}
;Bank $82.html-
;Bank $82.html-
;Bank $82.html-;;; $9EC4:  ;;;
;Bank $82.html-{
;Bank $82.html-$82:9EC4 08          PHP
;Bank $82.html-$82:9EC5 8B          PHB
;Bank $82.html:$82:9EC6 AD 89 07    LDA $0789  [$7E:0789]
;Bank $82.html-$82:9EC9 F0 15       BEQ $15    [$9EE0]
;Bank $82.html-$82:9ECB A9 82 00    LDA #$0082
;Bank $82.html-$82:9ECE 85 08       STA $08    [$7E:0008]
;Bank $82.html-$82:9ED0 A9 17 97    LDA #$9717
;Bank $82.html-$82:9ED3 85 06       STA $06    [$7E:0006]
;Bank $82.html-$82:9ED5 AD 9F 07    LDA $079F  [$7E:079F]
;Bank $82.html-$82:9ED8 0A          ASL A
;Bank $82.html-$82:9ED9 A8          TAY
;Bank $82.html-$82:9EDA B7 06       LDA [$06],y[$82:9717]
;Bank $82.html-$82:9EDC 85 06       STA $06    [$7E:0006]
;--

;;;;;;;;;;;;;;;;; compute x/y bounds for the map 0789 is used to switch between the map screen bits or the explored bits for populating
;$05AC ;Minimum X scroll on mini-map
;$05AE ;Maximum X scroll on mini-map
;$05B0 ;Minimum Y scroll on mini-map
;$05B2 ;Maximum Y scroll on mini-map


org $829EC6
NOP : NOP : NOP ;LDA $0789
NOP : NOP       ;BEQ $15

org $829F01 ;vanilla has an adjustment for the min map x for Maridia
NOP : NOP : NOP ;LDA $079F
NOP : NOP : NOP ;CMP #$0004
NOP : NOP       ;BNE $0A
NOP : NOP : NOP ;LDA $05AC
NOP             ;SEC
NOP : NOP : NOP ;SBC #$0018
NOP : NOP : NOP ;STA $05AC

org $829F61
  ;LDA [$00],y
  ;BIT $12
  JSL LoadMapBitsForX

org $829FC0
  ;LDA [$00],y
  ;BIT $12
  JSL LoadMapBitsForX

org $82A023
  ;LDA [$00],y
  ;BNE TopBound
  ;LDA [$03],y
  NOP : NOP
  JSL LoadMapBitsForY
  ;BNE TopBound
;org $82A051
;TopBound:

org $82A06D
  ;LDA [$00],y
  ;BNE BottomBound
  ;LDA [$03],y
  NOP : NOP
  JSL LoadMapBitsForY
  ;BNE BottomBound
;org $82A098
;BottomBound:

;Display map boss icons
; Input: X = #$C7CB - pointer to area boss icon list
org $82B892
  STX $20
  LDX $079F ;area index
  LDA $7ED828,x ;area boss bits
  AND #$00FF
  STA $24
  TXA ;LDA $079F ;area index
  ASL
  TAY
  LDA ($20),y
  BEQ BossIcon_Exit ;if boss icon list pointer is 0000 stop.
  TAX

BossIcon_Loop:
  LDA $0000,x ; load next icon
  CMP #$FFFF
  BEQ BossIcon_Exit ;FFFF terminates icon lists
  CMP #$FFFE
  BEQ BossIcon_Skip ;FFFE is a placeholder icon entry
  LDY #$0E00
  LSR $24
  BCS DrawBossDeadIcon

  ;LDA $0789  ; map station collected?
  ;BEQ BossIcon_Continue
  AND #$0100
  LSR
  BNE BossIcon_Check
  LDA #$000F
BossIcon_Check:
  AND $0789
  BEQ BossIcon_Continue

  LDA #$0009 ;boss icon sprite index
  JSR DrawIcon

BossIcon_Continue:
  INX
  INX
  INX
  INX
  BRA BossIcon_Loop

BossIcon_Skip:
  LSR $24
  BRA BossIcon_Continue

DrawBossDeadIcon:
  LDA #$0062 ;boss cross out box sprite index
  JSR DrawIcon
  LDY #$0C00
  LDA #$0009 ;boss icon sprite index
  JSR DrawIcon
  BRA BossIcon_Continue

DrawIcon:
  STA $22
  STY $03
  PHX
  LDA $0002,x
  SEC
  SBC $B3
  TAY
  LDA $0000,x
  SEC
  SBC $B1
  TAX
  LDA $22
  JSL $81891F
  PLX
BossIcon_Exit:
  RTS
print pc
warnpc $82B90A


org $829475
  REP #$30
  LDA [$06]
  XBA
  STA $26
  INC $06
  INC $06
  LDA #$0000
  STA $0B
  LDA #$07F7
  STA $09
  LDA [$09]
  XBA
  STA $28
  INC $09
  INC $09
  LDY #$0000
  LDX #$0010

LoadMapTiles_Loop:
  ASL $28
  BCC LoadMapTiles_CheckMapCollected
  LDA [$00],y
  ASL $26
  BRA StoreMapTile
LoadMapTiles_CheckMapCollected:
  LDA #$00F0
  CPY #$0800
  BPL LoadMapTiles_Check
  LDA #$000F
LoadMapTiles_Check:
  AND $0789
  BNE LoadMapTiles_CheckMapStationBit
  ASL $26
  BRA LoadMapTiles_Blank
LoadMapTiles_CheckMapStationBit:
  LDA [$00],y
  ORA #$1C00
  ASL $26
  BCS StoreMapTile
LoadMapTiles_Blank:
  LDA #$001F
StoreMapTile:
  STA [$03],y
  DEX
  BNE LoadMapTile_Continue:
  LDX #$0010
  LDA [$06]
  XBA
  STA $26
  INC $06
  INC $06
  LDA [$09]
  XBA
  STA $28
  INC $09
  INC $09

LoadMapTile_Continue:
  INY
  INY
  CPY #$1000
  BMI LoadMapTiles_Loop
  PLP
  RTS
warnpc $829517

org $82962B
  JSR CopyNamePaletteTo0 ;LDA $079F
org $82963A
  AND #$E3FF ;NOP : NOP : NOP ;AND #$EFFF - force the area name to use palette 0

org $818D66 
  JSR LoadPauseScreenPalette_GameOver
org $81AFD5
  JSR LoadPauseScreenPalette_LoadGame

org $818E60
LoadPauseScreenPalette_GameOver:
  LDX #$0000
  BRA LoadPauseScreenPaletteLoop
;org $818E65
LoadPauseScreenPalette_LoadGame:
  LDX #$0020 ;don't copy over top of the first palette
LoadPauseScreenPaletteLoop:
  LDA $8EE400,x
  STA $7EC000,x
  INX
  INX
  CPX #$0200
  BMI LoadPauseScreenPaletteLoop
  RTS


org $829517
  SEP #$30
  LDA #$33
  STA $5D
  LDA #$13
  STA $69
  LDA #$D8
  STA $B3
  LDA #$FF
  STA $B4
  REP #$30
  PHK
  PLB
  LDA $079F
  CMP #$0007 ;SMART tries to update this so it needs to be here
  NOP : NOP
  NOP : NOP : NOP
  STA $12
  ASL
  CLC
  ADC $12
  TAX

  LDA $964A,x ;SMART tries to update this so it needs to be here
  STA $00
  LDA $964C,x ;SMART tries to update this so it needs to be here
  STA $02

  LDA #$3000
  STA $03
  LDA #$007E
  STA $05
  LDA $12
  ASL
  TAX
  LDA #$0082
  STA $08
  LDA $829717,x
  STA $06

  LDX $079F
  LDA $7ED908,x
  AND #$00FF
  STA $0789

  JSR $8FD4 ;load map palette
  JSR CopyNamePaletteTo0

  PEA.w LoadMapGraphicsReturn-1
  PHP
  JMP $9475; JSR $943D
LoadMapGraphicsReturn:

  REP #$30
  LDX $0330
  LDA #$1000
  STA $D0,x
  LDA #$3000
  STA $D2,x
  LDA #$007E
  STA $D4,x
  LDA $58
  AND #$00FC
  XBA
  STA $D5,x
  TXA
  CLC
  ADC #$0007
  STA $0330
  RTL

CopyNamePaletteTo0:
  LDY #$0010
  LDX #$0000
CopyPalette7To0Loop:
  LDA $B6F0E0,x
  STA $7EC000,x
  INX
  INX
  DEY
  BNE CopyPalette7To0Loop
  LDA $079F
  RTS
warnpc $829628

; activate map station
org $848C8F
  PHX
  JSR ActivateMapStation_ex
  ORA $0789
  STA $0789
  SEP #$20
  LDX $079F
  STA $7ED908,x
  REP #$20
  LDA #$0014
  JSL $858080
  PLX
  RTS

org $84EFD3
ActivateMapStation_ex:
  LDA #$FFFF
  STA $7EFB20
  LDA $1E15 ;assume map station is the first plm since this code is triggered by a bts spawned plm 
  RTS

org $84B19C
  LDA $0789
  AND $1DC7,y
  EOR $1DC7,y
  NOP
  BEQ $19

;Bank $8F.html-;;; $C90A: Setup ASM: set collected map ;;;
;Bank $8F.html-{
;Bank $8F.html-; Room $DAAE. Tourian -> Crateria
;Bank $8F.html-$8F:C90A C2 30       REP #$30
;Bank $8F.html-$8F:C90C AE 9F 07    LDX $079F  [$7E:079F]
;Bank $8F.html-$8F:C90F BF 08 D9 7E LDA $7ED908,x[$7E:D90D]
;Bank $8F.html-$8F:C913 09 01 00    ORA #$0001
;Bank $8F.html-$8F:C916 9F 08 D9 7E STA $7ED908,x[$7E:D90D]
;Bank $8F.html:$8F:C91A 8D 89 07    STA $0789  [$7E:0789]
;Bank $8F.html-$8F:C91D 60          RTS
;Bank $8F.html-}
org $8FC913
  ORA #$00FF


; Mini map
org $90A9F5
  ;LDX $32 ;X = [$32] (byte index of map co-ordinate of mini-map origin)
  ;LDY $34 ;Y = [$34] (bit subindex of column of mini-map origin * 2)
  JMP MaskOutMapStationBits
  NOP
MapStationBits_Continue:

org $90AA29
  ;JSR $AB75 ;Adjust map bits for map page spill
  JMP MaskOutMapStationBitsSplit
MaskOutMapStationBitsSplit_Continue:

org $90FE80 ;Free space
MaskOutMapStationBits:
  LDA $22 ;Map page of Samus position ([room X co-ordinate] + [Samus X position] / 100h & 20h)
  BNE MaskOutMapStationBits_Check
  LDA #$000F
MaskOutMapStationBits_Check:
  AND $0789
  BNE MaskOutMapStationBits_Exit
  STZ $26 ;Row 0 map bits
  STZ $28 ;Row 1 map bits
  STZ $2A ;Row 2 map bits
MaskOutMapStationBits_Exit:
  LDX $32 
  LDY $34
  JMP MapStationBits_Continue

MaskOutMapStationBitsSplit:
  JSR $AB75 ;Adjust map bits for map page spill
  LDA $22
  BNE MaskOutMapStationBitsSplit_Check
  LDA #$00F0
  AND $0789
  BNE MaskOutMapStationBitsSplit_Exit
  SEP #$20
  STZ $26 ;Row 0 map bits
  STZ $28 ;Row 1 map bits
  STZ $2A ;Row 2 map bits
  REP #$20
  BRA MaskOutMapStationBitsSplit_Exit
MaskOutMapStationBitsSplit_Check:
  LDA #$000F
  AND $0789
  BNE MaskOutMapStationBitsSplit_Exit
  SEP #$20
  STZ $27 ;Row 0 map bits
  STZ $29 ;Row 1 map bits
  STZ $2B ;Row 2 map bits
  REP #$20
MaskOutMapStationBitsSplit_Exit:
  JMP MaskOutMapStationBitsSplit_Continue


LoadMapBitsForX:
  CPX #$0020
  BPL LoadMapBitsForX_PageTwo
  LDA.b #$0F
  AND $0789
  BNE LoadMapBitsForX_Collected
  LDA.b #$00
  BRA LoadMapBitsForX_NotCollected
LoadMapBitsForX_PageTwo:
  LDA.b #$F0
  AND $0789
  BNE LoadMapBitsForX_Collected
  LDA.b #$00
  BRA LoadMapBitsForX_NotCollected
LoadMapBitsForX_Collected:
  LDA [$00],y
LoadMapBitsForX_NotCollected:
  PHY
  REP #$20
  AND #$00FF
  PHA
  LDA $00
  SEC
  SBC $06
  CLC
  ADC 3,S
  TAY
  PLA
  SEP #$20
  ORA $07F7,y
  PLY
  BIT $12
  RTL

LoadMapBitsForY:
  STZ $12
  LDA.b #$0F
  AND $0789
  BEQ LoadMapBitsForY_PageTwo
  LDA [$00],y
  STA $12

LoadMapBitsForY_PageTwo:
  LDA.b #$F0
  AND $0789
  BEQ LoadMapBitsForY_Continue
  LDA [$03],y
  ORA $12
  STA $12

LoadMapBitsForY_Continue:
  PHY
  REP #$20
  LDA $00
  SEC
  SBC $06
  CLC
  ADC 1,S
  TAY
  SEP #$20
  LDA $12
  ORA $07F7,y
  ORA $0877,y
  PLY
  BIT.b #$FF
  RTL

org $90AAA0
  ;NOP : NOP : NOP ;LDA $0789
  ;NOP ;PHP

org $90AAAA
  ;NOP ;PLP
  ;NOP ;PHP
  ;BRA $03

org $90AAD1
  ;NOP ;PLP
  ;NOP ;PHP
  ;BRA $03

org $90AB0E
  ;NOP ;PLP
  ;NOP ;PHP
  ;BRA $03

org $90AB49
  ;NOP ;PLP