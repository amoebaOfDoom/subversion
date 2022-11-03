lorom

org $84B76F
  DW $B5EE, $AFE8

org $84AFE8
Save_Start:
  DW $0001, $9A3F ; draw save station
  DW $86B4 ; Sleep
  DW SaveDialogBox, NoSave ; Activate save station and exit if [save confirmation selection] = no, otherwise save the game and continue
  DW ExecuteSave
  DW $B00E ; Place Samus on save station
  DW $8C07 ; Queue save station sound fx
    DB $2E
  DW $874E
    DB $15 ; init loop counter = $15
SaveFX_Loop:
  DW $8724, SaveFX
SaveFX_LoopCheck:
  DW $873F, SaveFX_Loop ; Decerement loop counter and loop
Save_Exit:
  DW $B024 ; Display game saved message box
  DW $B030 ; Enable movement and set save station used
  DW $8724, Save_Start ; Reset save station

org $848CF1
SaveDialogBox:
  LDA $1DC7,x
  BIT #$8000
  BEQ +
  LDA $09A4
  BIT #$0001
  BNE +
  LDA #$002C
  BRA ++
+
  LDA #$0017
++
  JSL $858080 ; Display save confirmation message box
  CMP #$0002
  BEQ SaveDialogBox_Cancel ; Exit if canceling save
  PHX
  PHY
  LDX $1C27
  LDY #$E6D2
  JSL $868097 ; Spawn save station electricity enemy projectile
  PLY
  PLX
  INY
  INY
  RTS
SaveDialogBox_Cancel:
  LDA $0000,y
  TAY
  RTS

ExecuteSave:
  PHX
  PHY
  JSL ExecuteSave_2
  PLY
  PLX
  RTS
warnpc $848D41

org $84B024
  PHX
  PHY
  JSL CheckYesNo ;LDA #$0018
  ;JSL $858080
  PLY
  PLX
  RTS

org $84F008 ; free space
SaveFX:
  DW $0001, $9A9F
  DW HealSamus
  DW $0001, $9A9F
  DW HealSamus
  DW $0001, $9A9F
  DW HealSamus
  DW $0001, $9A9F
  DW HealSamus

  DW $0001, $9A6F
  DW HealSamus
  DW $0001, $9A6F
  DW HealSamus
  DW $0001, $9A6F
  DW HealSamus
  DW $0001, $9A6F
  DW HealSamus
  DW $8724, SaveFX_LoopCheck

org $84FBC0
NoSave:
  DW $B00E ; Place Samus on save station
  DW $874E
    DB $2A ; init loop counter = $15
NoSaveFX_Loop:
  DW HealSamus
  DW HealSamus
  DW HealSamus
  DW HealSamus
  DW $0001, $9A6F
  DW $873F, NoSaveFX_Loop
  DW $8724, Save_Exit

HealSamus:
  PHX : PHY
  LDA $09D4 ; Reserve Count
  LDY.w #100
  JSL $8082D6
  LDA $05F1
  CLC
  ADC.w #99
  STA $05F1

  LDA $09C2 ; Current Health
  CMP $05F1
  BCS Return ; If Health >= Reserve Max then return

  LDA $09D4 ; Reserve Count
  INC
  CLC
  ADC $09C2 ; + Current Health
  CMP $05F1
  BCC CheckMaxHealth ; If not Health + Increment < Reserve Max then set to max reserve
  LDA $05F1 ; Max Reserve

CheckMaxHealth:
  CMP $09C4 ; Max Health
  BCC SetHealth ; If not Health + Increment <  Max Health then set to max health
  LDA $09C4
SetHealth:
  STA $09C2 ; Current Health
Return:
  PLY : PLX
  RTS

org $94DE80
ExecuteSave_2:
  LDA $09D4 ; Reserve Count
  LDY.w #100
  JSL $8082D6
  LDA $05F1
  CLC
  ADC.w #99
  STA $05F1

  LDA $09C2
  PHA
  CMP $05F1
  BCS +
  LDA $05F1
+
  CMP $09C4
  BCC +
  LDA $09C4
+
  STA $09C2

  LDA $1DC7,x
  AND #$00FF
  STA $078B ; Load station index
  JSL $80818E
  LDA $079F ; Area index
  ASL
  TAX
  LDA $7ED8F8,x
  ORA $05E7
  STA $7ED8F8,x ; Set save station [load station index] in current area
  LDA $0952
  JSL $818000 ; Save current save slot to SRAM

  PLA
  STA $09C2
  RTL

CheckYesNo:
  LDA $05F9
  CMP #$0002
  BEQ +
  LDA #$0018
  JSL $858080
  RTL
+
  LDA #$001B
  JSL $858080
  RTL