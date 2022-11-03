lorom


;Makes charge beam attract item pickups, Prime style
;by Black_Falcon
;updated by ameobaOfDoom

;org $90B860 : DB $3C ;how long charge beam must be held down to fire a beam (default 3C)
;org $91D756 : DB $3C ;charge beam timer check for samus palette to change (should be equal to above value, default 3C)

org $86F057
  JSR CHECKCHARGE ;hijack point

org $86EF57 : JSR Init ; LDA #$0001
org $86EFCC : JSR Init ; LDA #$0001

org $86FBC0
Init:
  LDA #$0000
  STA $7EF3A4,x
  STA $7EF3EC,x
  LDA #$0001
  RTS

GTFO:
  PLY
  LDA $0AF6 : RTS ;go out
  
CHECKCHARGE:

  JSR ApplyVelocity;$92D6 ;Move enemy projectile according to enemy projectile velocity

  LDA $7EF3A4,x
  JSR ApplyFriction
  STA $7EF3A4,x

  LDA $7EF3EC,x
  JSR ApplyFriction
  STA $7EF3EC,x

  PHY
  LDA $0A76 ;load hyper beam state
  BNE GTFO ;don't let hyper attract pickups - it has strange interactions with charge

  LDA $7ED840
  AND #$0007
  ASL : ASL : ASL
  TAY

  LDA $0CD0 ;load charge value
  BEQ GTFO; optimization to skip routine entirely if there is no charge

  CMP AccelChargeTable+0,Y;#$0077 ;how long must the beam be charged to attract pickups (#$0001 to #$0078)
  BPL FULL:
  CMP AccelChargeTable+2,Y;#$0064 ;time when charge shots will be fired * 5/3
  BPL MEDIUM
  CMP AccelChargeTable+4,Y;#$0050 ;time when charge shots will be fired * 4/3
  BPL MEDIUM
  CMP AccelChargeTable+6,Y;#$003C ;time when charge shots will be fired * 1
  BMI GTFO

SLOW: ;1/4 speed
  LDA $05B6
  BIT #$0003
  BNE GTFO
  BRA FULL
MEDIUM: ;1/2 speed
  LDA $05B6
  BIT #$0001
  BNE GTFO
FULL: ;full speed

ComputeVectorToSamus:
  ; center x,y on Samus
  LDA $0AF6
  SEC
  SBC $1A4B,x
  STA $12
  LDA $0AFA
  SEC
  SBC $1A93,x
  STA $14

  JSL $A0C0AE ;compute angle
  ASL
  TXY
  TAX

  LDA $A0B443,x ;8-bit sine, sign-extended
  CLC
  BPL +
  SEC
+
  ROR
  STA $12
  LDA $A0B3C3,x ;8-bit negative cosine, sign-extended
  CLC
  BPL +
  SEC
+
  ROR
  STA $14

  TYX ;LDX $1991

  LDA $12
  CLC
  ADC $7EF3A4,x
  JSR ClampVelocity
  STA $7EF3A4,x

  LDA $14
  CLC
  ADC $7EF3EC,x
  JSR ClampVelocity
  STA $7EF3EC,x

DoneMoving:
  ; increase remaining lifetime for the pickup
  LDA $1B23,x
  CLC
  ADC #$000A
  CMP #$0200
  BMI NotAtMaxTime
  LDA #$0200
NotAtMaxTime:
  STA $1B23,x

  PLY
  LDA $0AF6
  RTS

AccelChargeTable:
  DW #$0077, #$0064, #$0050, #$003C
  DW #$0068, #$0041, #$0045, #$0034
  DW #$0059, #$0049, #$003A, #$002C
  DW #$004A, #$003D, #$0031, #$0025
  DW #$003B, #$0030, #$0026, #$001D
  DW #$002C, #$0025, #$001E, #$0016
  DW #$001D, #$0019, #$0014, #$000F
  DW #$000E, #$000C, #$0009, #$0006
  DW #$0001, #$0001, #$0001, #$0001

!maxVelocity = #$0400
!minVelocity = #$FC00
!friction = #$0018

ClampVelocity:
    BMI .negative
.positive
    CMP !maxVelocity
    BMI .return
    LDA !maxVelocity
    BRA .return

.negative
    CMP !minVelocity
    BPL .return
    LDA !minVelocity
    BRA .return

.return
    RTS

ApplyFriction:
  BMI .negative
  SEC
  SBC !friction
  BPL .return
  LDA #$0000
  RTS
.negative
  CLC
  ADC !friction
  BMI .return
  LDA #$0000
.return
  RTS

ApplyVelocity:
  LDA $7EF3A4,x
  SEP #$20
  CLC
  ADC $1A28,x
  STA $1A28,x
  REP #$20
  AND #$FF00
  XBA
  BPL +
  ORA #$FF00
+
  ADC $1A4B,x
  STA $1A4B,x

  LDA $7EF3EC,x
  SEP #$20
  CLC
  ADC $1A70,x
  STA $1A70,x
  REP #$20
  AND #$FF00
  XBA
  BPL +
  ORA #$FF00
+
  ADC $1A93,x
  STA $1A93,x
  RTS