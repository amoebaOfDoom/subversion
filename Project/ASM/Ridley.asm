lorom

org $A6A15C
  LDA $079F
  CMP #$0004

org $A6A369
  LDY $079F
  CPY #$0004

org $A6A424
  LDA $079F
  CMP #$0004

org $A6A469
  LDA $079F
  CMP #$0004

org $A6A478
  LDA $079F
  CMP #$0004

org $A6C369 
  LDA $079F
  CMP #$0006

org $A6D914 
  LDA $079F
  CMP #$0004

org $A6DF8A ; make Ceres Ridley use Norfair Ridley shot reaction
  LDA #$0004;$079F
  CMP #$0004

org $A6E4D2
  LDA $079F
  CMP #$0004

org $A6A170
  ;LDA #$00A0 ;starting X position
  LDA #$00D0 ;starting X position
  STA $0F7A
  LDA #$018A ;starting y position
  STA $0F7E

org $A6A19D
  LDA #$0040
  STA $7E8000 ;Upmost allowed Y position
  LDA #$01A0
  STA $7E8002 ;Downmost allowed Y position
  LDA #$0080 ;#$0040
  STA $7E8004 ;Leftmost allowed X position
  LDA #$0190 ;#$01D0 ;#$00E0
  STA $7E8006 ;Rightmost allowed X position

;Startup liftoff, facing right
org $A6B2F3
  LDX #$0080
  LDY #$0100

;Move to center side
org $A6B3FD
  LDX #$0140 ;#$00C0
org $A6B406
  LDX #$00E0 ;#$0060

;Fly to U swoop start
org $A6B455
  LDX #$0140 ;#$00C0
org $A6B45E
  LDX #$0080 ;#$0040

;Considering tailbouncing
org $A6B5E5
  ;LDA $7E7820 ;Facing direction. 0 = left, 1 = forward, 2 = right
  ;ASL A
  ;TAY
  ;LDA $B60D,y
;  NOP : NOP : NOP
;  JSR FindPlatform
;  ADC $B60D,y
org $A6B60D
  DW $0170, $0100, $0080
  ;DW $00C0, $0080, $0040

;Fly to start Tail bouncing
;org $A6B6AF
;  NOP : NOP : NOP
;  JSR FindPlatform
;  ADC $B6C8,y
org $A6B6C8
  DW $0150, $0100, $00B0
  ;DW $00B0, $0080, $0060

;Wait after dropping Samus
;org $A6BC33
;  NOP : NOP : NOP
;  JSR FindPlatform
;  ADC $BC62,y
org $A6BC62
  DW $0160, $0000, $0090
  ;DW $00B0, $0000, $0050 ;middle one doesn't happen

;Dodge a powerbomb
org $A6BD5A
  LDY #$0090 ;#$0050
  LDA $0CE2
  CMP #$0100
  BPL $03
  LDY #$0160 ;#$01B0

;Ridley in position to grab Samus, no powerbombs
;org $A6BB8F
;  NOP : NOP : NOP
;  JSR FindPlatform
;  ADC $BBEB,y
org $A6BBEB
  DW $0090, $0000, $0180
  ;DW $0040, $0000, $00D0 ;middle one doesn't happen

;Ridley death item drop routine
org $A0B9A8
  LDA #$0020 ;spawn more drops
org $A0B9B2
  ;AND #$01FF ;drops can spawn over more x range
  AND #$00FF
  CLC
  ADC #$0090

;Ridley death location
org $A6C601
  LDX #$0100 ;#$0080

;org $B4F1B2
;	DB $00 ;Power beam
;	DB $00 ;Wave beam
;	DB $00 ;Ice beam
;	DB $00 ;Ice + Wave beam
;	DB $00 ;Spazer beam
;	DB $00 ;Spazer + Wave beam
;	DB $00 ;Spazer + Ice beam
;	DB $00 ;Spazer + Wave + Ice beam
;	DB $00 ;Plasma beam
;	DB $00 ;Plasma + Wave beam
;	DB $00 ;Plasma + Ice beam
;	DB $00 ;Plasma + Wave + Ice beam
;	DB $00 ;Missiles
;	DB $00 ;Super missiles
;	DB $00 ;Bombs
;	DB $00 ;Power bombs
;	DB $00 ;Speedbooster
;	DB $00 ;Shinespark
;	DB $00 ;Screw Attack
;	DB $00 ;Charge beam
;	DB $00 ;Psuedo screw attack
;	DB $82 ;Hyper Beam

;org $A6FEC0 ;free space
;FindPlatform:
;  LDA $7E7820 ;Facing direction. 0 = left, 1 = forward, 2 = right
;  ASL A
;  TAY
;  LDA $0AF6 ;Samus's X position in pixels
;  AND #$0100
;  CLC
;  ;ADC $????,y
;  RTS

org $A6A4EB ;colors for bg row 7 (only colors 1-E)
;DW $A50B, $A527, $A543, $A55F, $A57B, $A597, $A5B3, $A5CF, $A5EB, $A607, $A623, $A63F, $A65B, $A677, $A693, $0000
DW #BG7_COLOR_FADE_IN_0, #BG7_COLOR_FADE_IN_1, #BG7_COLOR_FADE_IN_2, #BG7_COLOR_FADE_IN_3, #BG7_COLOR_FADE_IN_4, #BG7_COLOR_FADE_IN_5, #BG7_COLOR_FADE_IN_6, #BG7_COLOR_FADE_IN_7
DW #BG7_COLOR_FADE_IN_8, #BG7_COLOR_FADE_IN_9, #BG7_COLOR_FADE_IN_A, #BG7_COLOR_FADE_IN_B, #BG7_COLOR_FADE_IN_C, #BG7_COLOR_FADE_IN_D, #BG7_COLOR_FADE_IN_E, $0000

BG7_COLOR_FADE_IN_0:
DW $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
BG7_COLOR_FADE_IN_1:
DW $0822, $0421, $0401, $0821, $0421, $0421, $0400, $0842, $0841, $0841, $0821, $0421, $0421, $0000
BG7_COLOR_FADE_IN_2:
DW $1044, $0C23, $0822, $1063, $0C42, $0822, $0821, $1084, $1083, $1062, $1041, $0842, $0421, $0421
BG7_COLOR_FADE_IN_3:
DW $1466, $1044, $0C43, $1484, $1063, $0C42, $0822, $1CC6, $1CC4, $1CA3, $1862, $0C42, $0842, $0821
BG7_COLOR_FADE_IN_4:
DW $1C67, $1465, $1044, $1CA5, $1484, $1063, $0C42, $2528, $2505, $24E3, $24A3, $1063, $0C42, $0821
BG7_COLOR_FADE_IN_5:
DW $2489, $1C67, $1445, $24E7, $1CA5, $1484, $1042, $2D6A, $2D46, $2D24, $2CC3, $1484, $1063, $0821
BG7_COLOR_FADE_IN_6:
DW $2CAB, $2088, $1866, $2D08, $20C6, $1885, $1463, $35AC, $3588, $3545, $34E4, $18A5, $1063, $0C42
BG7_COLOR_FADE_IN_7:
DW $30CD, $288A, $2087, $314A, $28E7, $20A6, $1864, $41EE, $41E9, $4186, $3D04, $20C6, $1484, $1042
BG7_COLOR_FADE_IN_8:
DW $38EF, $2CAB, $2488, $396B, $2D08, $24C6, $1864, $4A2F, $4A2A, $49C7, $4525, $24C6, $18A5, $1042
BG7_COLOR_FADE_IN_9:
DW $4111, $30CC, $2889, $418C, $3129, $28C7, $1C84, $5271, $526C, $51E8, $4D46, $28E7, $18A5, $1063
BG7_COLOR_FADE_IN_A:
DW $4933, $38CE, $2CAA, $49CE, $394A, $2CE8, $2085, $5AB3, $5AAD, $5A29, $5566, $2D08, $1CC6, $1463
BG7_COLOR_FADE_IN_B:
DW $5134, $3CEF, $30CB, $51EF, $3D6B, $3109, $24A6, $6315, $62EE, $6269, $61A7, $3129, $20C6, $1863
BG7_COLOR_FADE_IN_C:
DW $5556, $4110, $34CC, $5610, $418C, $3529, $24A6, $6F57, $6F2F, $6EAA, $69C8, $3529, $24E7, $1863
BG7_COLOR_FADE_IN_D:
DW $5D78, $4912, $38CD, $5E52, $49AD, $392A, $28C6, $7799, $7771, $76CB, $71E8, $394A, $24E7, $1884
BG7_COLOR_FADE_IN_E:
DW $659A, $4D33, $3CEE, $6673, $4DCE, $3D4B, $2CC7, $7FDB, $7FB2, $7F0C, $7A09, $3D6B, $2908, $1C84

org $88D90C
  DW #SetupRidleyHdma ;$D916

org $88F880 ;free space
SetupRidleyHdma:
  LDA #$0009
  STA $07EB
  STA $56
  STA $07EC
  RTS


org $94C000
UnsetEnemiesKilled:
  JSL $A0A3AF ; kill enemy
  LDA $7ED842
  DEC
  STA $7ED842
  RTL

SetEnemyKilled:
  JSL $81FAA5 ; Incremment kill count (challenges.asm)
  
  ; displaced
  STZ $0FAA
  STZ $0FAC
  RTL

org $A6C90E : JML UnsetEnemiesKilled ; JMP $A0A3AF
org $A6C59F
  JSL SetEnemyKilled
  NOP : NOP
  ;STZ $0FAA
  ;STZ $0FAC

; don't draw baby metroid canister
org $A6A264
  LDA #$0000 ;LDA #$BF31
org $A6A26B
  LDA #$0000 ;LDA #$0001

org $A6C129
  STZ $0943
  ;STA $0943


org $A6C2AC
  JSR RidleyDrawText

org $A6FEC0 ;free space
RidleyDrawText:
  LDA $1842
  BIT #$0001
  BNE +
  INC $0AFA
+
;  LDA #$0002
;  STA $7ECD20

  LDA #$007F
  SEC
  SBC $B3
  STA $0FBE
  CLC
  LDA #$0010
  STA $0FBA

  JSR $C2B1
  BCC +

  LDA $0AFA
  CMP #$0100
  BMI RidleyDrawText_Wait 
  JSL Defenestration
+
  RTS

RidleyDrawText_Wait:
  LDA #$0012
  STA $183E
  LDA #$0010
  STA $1840
  INC $0AFA
  CLC
  RTS

org $90E119
  PHP
  PHB
  PHK
  PLB
  REP #$30
  LDA #$E90E
  STA $0A58 ; $0A58 = RTS
  LDA #$0000
  JSL $90F084 ; disable controls

  STZ $0AFA
  LDA #$0100
  STA $0AF6

  LDA #$0000
  STA $0A1C
  JSL $91F433
  JSL $91FB08
  LDA $0A20
  STA $0A24
  LDA $0A22
  STA $0A26
  LDA $0A1C
  STA $0A20
  LDA $0A1E
  STA $0A22
  STZ $0B2E
  STZ $0B2C
  STZ $0A56

  PLB
  PLP
  RTL

Defenestration:
  PHP
  PHB
  PHK
  PLB
  REP #$30

  LDA #$007F
  STA $0FBE
  LDA #$0010
  STA $0FBA

  LDA #$00E8
  STA $0AFA
  LDA #$0080
  STA $0AF6

  LDA #$A337
  STA $0A58 ; Normal
  LDA #$0001
  JSL $90F084 ; enable controls

  LDA #$0002
  STA $0A1C
  JSL $91F433
  JSL $91FB08
  LDA $0A20
  STA $0A24
  LDA $0A22
  STA $0A26
  LDA $0A1C
  STA $0A20
  LDA $0A1E
  STA $0A22
  STZ $0B2E
  STZ $0B2C
  STZ $0A56

  LDA #$E17D
  STA $099C
  LDA #$0001
  STA $078F ; Set room out door #

  ASL
  ADC $07B5
  TAX
  LDA $8F0000,x
  TAX
  LDA $830000,x
  STX $078D ; Set door transition door header pointer

  LDA #$0009
  STA $0998

  STZ $093F

  PLB
  PLP
  RTL
warnpc $90E23B

;;; $C450: Typewriter text - Ceres escape timer ;;;
{
org $A6C450
  DW $0001, $0002
  DW $000D, $5105
  DB "FUEL PORT AIRLOCK OPEN"
  DW $000D, $5145
  DB "DECOMPRESSION ALARM"
  DW $000D, $5185
  DB "EVACUATE IMMEDIATELY"
  DW $000D, $5205
  DB "PERSONNEL OVERBOARD"
  DW $0000



!enemy_Y           = $0F7E
!enemy_X           = $0F7A
!enemy_var0        = $0FA8
!enemy_var1        = $0FAA
!enemy_var2        = $0FAC
!enemy_instruction = $0F92
!enemy_inst_timer  = $0F94
!samus_X           = $0AF6
!samus_Y           = $0AFA
!enemy_prop1       = $0F86
!enemy_index       = $0E54

org $AB8000
Main:
  LDX !enemy_index
  JSR (!enemy_var0,X)
  RTL

Init:
  LDA #$0000 ; disable samus movement
  JSL $90F084          

  LDX !enemy_index
  LDA #$0080
  STA !enemy_Y,X
  LDA #$FF80
  STA !enemy_X,X
  LDA #Main_Wait
  STA !enemy_var0,X
  LDA #$0100
  STA !enemy_var1,X
  LDA #$0400
  STA !enemy_var2,X
  LDA #inst_list
  STA !enemy_instruction,X
  LDA #$0001
  STA !enemy_inst_timer,X
  RTL

Main_Wait:
  DEC !enemy_var1,X
  BPL +
  LDA #Main_Move
  STA !enemy_var0,X
  LDA #$001D
  STA !enemy_var1,X
+
  JSR Move_Samus
  RTS

Main_Move:
  DEC !enemy_var1,X
  BPL +
  LDA #$0001 ; enable samus movement
  JSL $90F084
  LDA #Main_Leave
  STA !enemy_var0,X
  LDA #$001D
  STA !enemy_var1,X
+
  JSR Move_enemy
  JSR Move_Samus
  RTS

print pc
Move_enemy:
  LDA !enemy_X,X
  CLC : ADC #$0008
  STA !enemy_X,X

  LDA !enemy_var2,X
  SEC : SBC #$0040
  STA !enemy_var2,X
  XBA
  AND #$00FF
  JSL $A0AFEA
  CLC : ADC !enemy_Y,X
  STA !enemy_Y,X
  RTS


Move_Samus:
  LDA !enemy_X,X
  CLC : ADC #$000C
  STA !samus_X
  LDA !enemy_Y,X
  CLC : ADC #$0023
  STA !samus_Y
  RTS

Main_Leave:
  DEC !enemy_var1,X
  BPL +
  LDA !enemy_prop1,X
  ORA #$0200 ; kill
  STA !enemy_prop1,X
+
  JSR Move_enemy
  RTS

Inst_Sleep:
  DEY
  DEY
  TYA
  STA $0F92,x
  PLA
  PEA $C2AE
  RTL

inst_list:
  DW $000C, #tilemaps
  DW #Inst_Sleep ; Sleep

; Ridley facing right
tilemaps:           
DW $0004
  DW $FFF1, $0016, #oam1, #hitbox1 
  DW $0008, $0007, #oam2, #hitbox2 
  DW $FFF0, $0000, #oam3, #hitbox3 
  DW $0003, $FFE8, #oam4, #hitbox4

hitbox1:
DW $0001
  DW $FFF6, $FFF6, $0011, $0002, $8023, $802D
hitbox2:
DW $0001
  DW $0001, $FFFE, $000E, $0009, $8023, $802D
hitbox3:
DW $0001
  DW $FFF3, $FFEA, $000E, $0015, $8023, $802D
hitbox4:
DW $0002
  DW $FFF4, $FFE7, $000B, $000D, $8023, $802D
  DW $000C, $0005, $0018, $0014, $8023, $802D

oam1:
DW $0007
  DW $81F6 : DB $FF : DW $71AE
  DW $8006 : DB $FF : DW $71AC
  DW $01F0 : DB $F8 : DW $71BA
  DW $01F8 : DB $F8 : DW $71B9
  DW $01F0 : DB $F0 : DW $71AA
  DW $01F8 : DB $F0 : DW $71A9
  DW $8000 : DB $F0 : DW $71A7
oam2:
DW $0001
  DW $8000 : DB $FC : DW $7140
oam3:
DW $0006
  DW $8008 : DB $03 : DW $71CC
  DW $8000 : DB $F8 : DW $7120
  DW $81F0 : DB $F8 : DW $7122
  DW $81F2 : DB $06 : DW $7122
  DW $81F0 : DB $E8 : DW $7102
  DW $8000 : DB $E8 : DW $7100
oam4:
DW $000C
  DW $0014 : DB $12 : DW $7154
  DW $01F4 : DB $0A : DW $7159
  DW $01F4 : DB $02 : DW $7149
  DW $01FC : DB $0A : DW $717B
  DW $0004 : DB $0A : DW $717A
  DW $01FC : DB $02 : DW $716B
  DW $0004 : DB $02 : DW $716A
  DW $800C : DB $02 : DW $7168
  DW $81F4 : DB $F2 : DW $7166
  DW $8004 : DB $F2 : DW $7164
  DW $81EC : DB $E2 : DW $7162
  DW $81FC : DB $E2 : DW $7160
