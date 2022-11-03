lorom

org $808294
      LDA $7FFF02
      BNE SetExtendedDemos
      PLX
      RTL

org $8082A5
SetExtendedDemos:


!pH = $7E339A
!pL = $7E33DA

;;; $E627: Item percentage count ;;;
org $8BE627
  PHP
  PHB
  PHK     
  PLB     
  REP #$30
  PHX
  PHY

  LDX #$0000
  STZ $12
-
  LDA $7ED868,x
  AND #$00FF
  CLC
  ADC $12
  STA $12
  INX
  CPX #$0008
  BMI -

  LDA $94DC40 ; item total count in EquipmentScreen.asm
  STA $14
  
  STZ $16

  LDX #$0000
  LDA $12
  CMP $14
  BMI .skip100

  LDA #$3861 : STA !pH-2
  LDA #$3871 : STA !pL-2
  LDA #$1800
  STA $16
  LDA $12

.skip100
  JSR Mult10

  LDA $4216
  JSR Mult10

  LDA #$205A : ORA $16 : STA !pL,X ; decimal
  INX : INX

  LDA $4216
  JSR Mult10

  LDA #$206A : ORA $16 : STA !pH,X ; percent
  LDA #$207A : ORA $16 : STA !pL,X
  PLY
  PLX
  PLB
  PLP
  RTS

Mult10:
  ASL
  STA $12
  ASL
  ASL
  CLC
  ADC $12
  STA $4204
  SEP #$20 : LDA $14 : STA $4206
  PHA : PLA : PHA : PLA : REP #$20
  LDA $4214

  CMP #$000A
  BMI +
  LDA #$0000
+
  ASL A
  TAY

  LDA.w Numbers_High,Y : ORA $16 : STA !pH,X ; 10s
  LDA.w Numbers_Low,Y : ORA $16 : STA !pL,X  
  INX : INX  
  RTS

Numbers_High:
  DW $2060, $2061, $2062, $2063, $2064, $2065, $2066, $2067, $2068, $2069
Numbers_Low:
  DW $2070, $2071, $2072, $2073, $2074, $2075, $2076, $2077, $2078, $2079

warnpc $8BE76A


; game time test
; "hard"
org $8BE00D : CMP #$0005 ; #$0003
org $8BE1E3 : CMP #$0005 ; #$0003
org $8BE279 : CMP #$0005 ; #$0003
org $8BE2E7 : CMP #$0005 ; #$0003
org $8BE328 : CMP #$0005 ; #$0003
org $8BE36F : CMP #$0005 ; #$0003

; "medium"
org $8BE1E8 : CMP #$000C ; #$000A
org $8BE2EC : CMP #$000C ; #$000A
org $8BE374 : CMP #$000C ; #$000A
org $8BF558 : CMP #$000C ; #$000A
org $8BF59A : CMP #$000C ; #$000A
org $8BF5BD : CMP #$000C ; #$000A
