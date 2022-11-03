lorom

org $88B4E1
  LDA $197E
  BIT #$0026
  BNE $08
;No_Flags:
  LDX $18B2
  JSR $B51D
  BRA ContinueProcessing
Check_Flags:
  BIT #$0022
  BNE HeatBitSet
  LDX $18B2
  JSR $B53B
  BRA ContinueProcessing
HeatBitSet:
  ;LDX $18B2
  ;JSR $B5A9
  JSR HeatBit
  NOP : NOP : NOP
ContinueProcessing:

org $88F140 ; free space
HeatBit:
  BIT #$0020
  BNE ToxicGasBit
  LDX $18B2
  JSR $B5A9
  RTS

ToxicGasBit:
  LDX $18B2

  SEP #$20
  LDY $18C0,x
  LDA #$0F ; PPU $21XX register to affect
  STA $4301,y
  ;LDA #$22 ; mosaic size & layer
  ;STA $0057
  REP #$20

  DEC $1920,x
  BNE Branch_2
  LDA #$0008 ; frame delay
  STA $1920,x
  LDA $1914,x
  DEC A
  DEC A
  AND #$001E
  STA $1914,x
Branch_2:
  PHX
  LDA $B5
  AND #$000F
  ASL A
  PHA
  CLC
  ADC $1914,x
  AND #$001E
  TAY
  PLA
  CLC
  ADC #$001E
  AND #$001E
  TAX

  LDA #$000F
  STA $12
Loop_2:
  LDA $B5
  CLC
  ADC WaveTable,y
  AND #$01FF
  STA $7E9C46,x
  TXA
  DEC A
  DEC A
  AND #$001E
  TAX
  TYA
  DEC A
  DEC A
  AND #$001E
  TAY

  DEC $12
  BPL Loop_2
  PLX

  RTS

WaveTable:
  DW $0000, $0001, $0001, $0000, $0000, $FFFF, $FFFF, $0000, $0000, $0001, $0001, $0000, $0000, $FFFF, $FFFF, $0000


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Use as the Main ASM pointer for a room to make cold damage and effects
; FF00
;

!BitSuit1 = #$0020 ; aqua suit
!BitSuit2 = #$0001 ; varia suit
!BitSuit3 = #$0010 ; metroid suit

ColdRoomEffect:
  LDA #$003A ;easy mode
  JSL $808233
  BCS IceEffect_return

  LDA $0E18
  BNE IceEffect_return

  LDX #$0000
  LDA $09A2
  BIT !BitSuit3
  BEQ IceEffect_nometroidsuit
  LDX #$0002
IceEffect_nometroidsuit:

  LDA $09A2
  BIT !BitSuit2
  BEQ IceEffect_novariasuit
  INX
IceEffect_novariasuit:

  CPX #$0001
  BEQ IceEffect_nobeep
  LDA $09DA
  BIT #$0007  ; If [in-game time frames] % 8 = 0:
  BNE IceEffect_nobeep
  LDA $09C2
  CMP #$0047  ; If [Samus' health] >= 71:
  BMI IceEffect_nobeep
  PHX
  LDA #$002D
  JSL $809139 ; Queue sound 2Dh, sound library 3, max queued sounds allowed = 3
  PLX
IceEffect_nobeep:

  TXA
  ASL
  ASL
  TAX

  LDA $0A4E
  CLC
  ADC IceDamage+2,x
  STA $0A4E
  LDA $0A50
  ADC IceDamage+0,x
  STA $0A50
IceEffect_return:
  RTL

IceDamage: 
  DW $0000, $0C00 ; no suit
  DW $0000, $0000 ; varia
  DW $0001, $8000 ; metroid
  DW $0000, $8000 ; metroid + varia

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Use as the Main ASM pointer to make the FX3 surface cycle between the
; start and end values instead of stopping when reaching the end
; FF05
;

HugeWaveFX3:
  LDX $1966 ;Direct pointer to room's FX1 entry

  LDA $830002,X ;surface start
  DEC
  CMP $1978 ;FX3 height (average of tide)
  BEQ AtSurfaceStart
  INC
  INC
  CMP $1978 ;FX3 height (average of tide)
  BEQ AtSurfaceStart

  LDA $830004,X ;surface end height
  DEC
  CMP $1978 ;FX3 height (average of tide)
  BEQ AtSurfaceEnd
  INC
  INC
  CMP $1978 ;FX3 height (average of tide)
  BEQ AtSurfaceEnd
  RTL

AtSurfaceStart:
  LDA $830004,X ;surface end height
  STA $197A ;FX3 height to go to
  CMP $830002,X ;surface start
  BMI MakeNegativeSurfaceSpeed

MakePositiveSurfaceSpeed:
  LDA $830006,X ;surface speed
  BPL SetSpeed
  BRA SetNegativeSpeed

AtSurfaceEnd:
  LDA $830002,X ;surface start
  STA $197A ;FX3 height to go to
  CMP $830004,X ;surface end height
  BPL MakePositiveSurfaceSpeed

MakeNegativeSurfaceSpeed:
  LDA $830006,X ;surface speed
  BMI SetSpeed

SetNegativeSpeed:
  LDA #$0000
  CLC
  SBC $830006,X ;surface speed
SetSpeed:
  STA $197C ;FX3 height adjustment speed (signed)
  RTL

org $8FFF00
  JSL ColdRoomEffect
  RTS
;org $8FFF05
  JSL HugeWaveFX3
  RTS