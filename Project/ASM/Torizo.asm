lorom

org $AAC87F
SilverTorizoInitAI:
  LDY #$0000
  BRA TorizoInit_Main
GoldTorizoInitAI:
  LDY #$0002
  BRA TorizoInit_Main
SuperTorizoInitAI:
  LDY #$0004

TorizoInit_Main:
  LDX $0E54 ;Current Enemy Index
  TYA
  STA $0FAE,X
  LDA #$0004
  JSL $8081DC ;Check boss bits for the area (CLC if not set)
  BCC TorizoNotPreviouslyKilled
  LDA $0F86,X ;Property bits (Special from SMILE)
  ORA #$0200
  STA $0F86,X ;Property bits (Special from SMILE)
  RTL
TorizoNotPreviouslyKilled:
  ;LDY $079F ;Region Number
  LDA $0F86,X ;Property bits (Special from SMILE)
  ORA #$2800 ;RegionPropertyBitsExtraFlags,Y
  STA $0F86,X ;Property bits (Special from SMILE)
  LDA $0F88,X ;Extra property bits
  ORA #$0004 ;Extended tilemap format
  STA $0F88,X ;Extra property bits
  LDA #$0012 ;$C96F,Y ;(#$0012, #$0012)
  STA $0F82,X ;Collision radius width
  LDA.w InitialSizeY,Y ;($0030, $0029)
  STA $0F84,X ;Collision radius height
  LDA #$C6BF ;#FirstPhase ;#$C6BF
  STA $0FB0,X ;Phase pointer
  LDA #$0001
  STA $0F94,X ;Instruction delay counter
  STZ $0F90,X ;Loop counter

  LDA $0FB4,X
  STA $0F96,X ;Palette index
  STZ $0FB4,X

  LDA $0FB6,X
  STA $7E8000,X
  STZ $0FB6,X

  LDA #$C95E ;(RTS)
  STA $0FB2,X

  LDA $0F92,X ;Pointer to current instruction
  BNE SkipSetupNextInstructionPointer
  LDA.w InitialInstructions,Y ;($B879, $C9CB)
  STA $0F92,X ;Pointer to current instruction
SkipSetupNextInstructionPointer:
  LDA #$87D0
  STA $0F8E,X ;Pointer to main hitbox / graphics maps
  
  STZ $0FA8,X
  LDA #$0100
  STA $0FAA,X

  LDA $7E8000,X
  BIT #$0002
  BNE LoadTorizoPalette_1_2
  BIT #$0004
  BNE LoadTorizoPalette_1_4

  LDX #$001E
LoadTorizoPaletteLoop_1:
  LDA $8687,X
  STA $7EC360,X
  LDA $86A7,X
  STA $7EC3E0,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_1

  TYA ;LDA $079F ;Region Number
  BNE GoldTorizoExtraInit
LoadTorizoPalette_1_2:
  JSR LoadTorizoPalette_2
  JSR LoadInitPalette
  ;JSL $88DD32 ; Spawn Haze HDMA object
  RTL

LoadTorizoPalette_1_4:
  LDX #$001E
LoadTorizoPaletteLoop_1_4:
  LDA $7EC1A0,X
  STA $7EC1E0,X
  LDA $7EC3A0,X
  STA $7EC3E0,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_1_4
  JSR LoadTorizoPalette_3
  JSR LoadInitPalette
  RTL

GoldTorizoExtraInit:
  JSR LoadTorizoPalette_4
  JSR LoadInitPalette
  RTL

InitialInstructions:
  DW $B879, $C9CB, $C9CB
InitialSizeY:
  DW $0030, $0029, $0029


warnpc $AAC977

org $AAF7E0 ; free space
SpawnNext:
  JSL $81FAA5 ; Incremment kill count (challenges.asm)

  DEC $0E52 ;Number of enemies needed to clear current room.
  BEQ DoneSpawning
  BMI DoneSpawning
  PHX
  PHY
  INC $0E4E ; += (-1 + 2)
  LDX #SpawnData_Right
  JSL $A09275
  LDY $0E4A
  LDA #$001E
  STA $0F84,Y
  LDX #SpawnData_Left
  JSL $A09275

  LDX $0330
  LDA #$0400
  STA $D0,X
  LDA $A0EF35
  CLC
  ADC #$0600
  STA $D2,X
  LDA $A0EF37
  CLC
  ADC #$0000
  STA $D4,X
  LDA #$7300
  STA $D5,X

  LDA #$0800
  STA $D7,X
  LDA $A0EF35
  CLC
  ADC #$1800
  STA $D9,X
  LDA $A0EF37
  CLC
  ADC #$0000
  STA $DB,X
  LDA #$7C00
  STA $DC,X

  TXA
  CLC
  ADC #$000E
  STA $0330

  PLY
  PLX
SkipSpawning:
  CLC
  RTS
DoneSpawning:
  DEC $0E4E ;Number of enemies in the room
  BEQ DoneSpawningContinue
  BRA SkipSpawning
DoneSpawningContinue:
  LDA #$0004 ;hijacked instructions
  JSL $8081A6 ;Set boss bits in A for current area
  SEC
  RTS

SpawnData_Right:
  DW $EEFF ;Enemy ID
  DW $0260 ;X position
  DW $0078 ;$01A0 ;Y position
  DW $B879;$CA1D;$C9EA;$B9C8;$B879 ;Pointer to current instruction
  DW $2800 ;Property bits (Special from SMILE)
  DW $0000 ;Extra property bits
  DW $0000 ;Speed from SMILE
  DW $0002 ;Speed2 from SMILE
SpawnData_Left:
  DW $EEFF ;Enemy ID
  DW $0130 ;X position
  DW $00C0;$018C ;Y position
  DW $BD0E ;$CA1D;$C9EA;$BE42;$B879 ;Pointer to current instruction
  DW $2800 ;Property bits (Special from SMILE)
  DW $0000 ;Extra property bits
  DW $0600 ;Speed from SMILE
  DW $0004 ;Speed2 from SMILE

FindChozoPLM:
  PHX
  LDX #$004E
FindChozoPLM_Loop:
  LDA $1C37,X ;PLM header table
  CMP #$D6EA ;Crumbling Chozo PLM
  BEQ FindChozoPLM_Found
  DEX
  DEX
  BPL FindChozoPLM_Loop
  PLX ;If the PLM wasn't found, continue waking up the statue
  SEC
  RTS
FindChozoPLM_Found:
  PLX
  CLC
  RTS

LoadEggs:
  DW $806B, $D5ED ; displaced
  DW $814B, $0600 : DL $AFE200 : DW $6D00
  DW $80ED, #LoadEggs_Return

LoadTorizoPaletteLoop_2:
  LDA $7E8000,X
  LDX #$001E
  BIT #$0004
  BNE LoadTorizoPaletteLoop_2_4
LoadTorizoPaletteLoop_2_0:
  LDA $86E7,X
  STA $7E8340,X
  LDA $86C7,X
  STA $7E8320,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_2_0
  RTS
LoadTorizoPaletteLoop_2_4:
  LDA $86C7,X
  STA $7E8360,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_2_4
  RTS

LoadTorizoPaletteLoop_3:
  LDA $7E8000,X
  LDX #$001E
  BIT #$0004
  BNE LoadTorizoPaletteLoop_3_4
LoadTorizoPaletteLoop_3_0:
  LDA $8727,X
  STA $7E8340,X
  LDA $8707,X
  STA $7E8320,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_3_0
  RTS
LoadTorizoPaletteLoop_3_4:
  LDA $8707,X
  STA $7E8360,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_3_4
  RTS

;LoadTorizoPaletteLoop_6:
;  LDA $7E8000,X
;  LDX #$001E
;  BIT #$0004
;  BNE LoadTorizoPaletteLoop_6_4
;LoadTorizoPaletteLoop_6_0:
;  LDA $8727,X
;  STA $7EC140,X
;  LDA $8707,X
;  STA $7EC120,X
;  DEX
;  DEX
;  BPL LoadTorizoPaletteLoop_6_0
;  RTS
;LoadTorizoPaletteLoop_6_4:
;  LDA $8707,X
;  STA $7EC160,X
;  DEX
;  DEX
;  BPL LoadTorizoPaletteLoop_6_4
;  RTS

;LoadTorizoPaletteLoop_7:
;  LDA $7E8000,X
;  LDX #$001E
;  BIT #$0004
;  BNE LoadTorizoPaletteLoop_7_4
;LoadTorizoPaletteLoop_7_0:
;  LDA #$7FFF
;  STA $7E8140,X
;  STA $7E8120,X
;  DEX
;  DEX
;  BPL LoadTorizoPaletteLoop_7_0
;  RTS
;LoadTorizoPaletteLoop_7_4:
;  LDA #$7FFF
;  STA $7E8160,X
;  DEX
;  DEX
;  BPL LoadTorizoPaletteLoop_7_4
;  RTS

LoadTorizoPaletteLoop_8:
  LDA $7E8000,X
  LDX #$001E
  BIT #$0004
  BNE LoadTorizoPaletteLoop_8_4
LoadTorizoPaletteLoop_8_0:
  LDA #$0000
  STA $7E8340,X
  STA $7E8320,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_8_0
  RTS
LoadTorizoPaletteLoop_8_4:
  LDA #$0000
  STA $7E8360,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_8_4
  RTS

LoadInitPalette:
  JSL $AAB271
  BCC LoadInitPalette
  RTS

ChestExplodeLoadPointer:
  LDA $7E8000,X
  BNE +
-
  LDA #$B0E5
  RTS
+
  LDA $0E4E
  CMP #$0001
  BEQ -
  LDA #ChestExplodeNoDMA
  RTS

HeadExplodeLoadPointer:
  LDA $7E8000,X
  BNE +
-
  LDA #$B155
  RTS
+
  LDA $0E4E
  CMP #$0001
  BEQ -
  LDA #HeadExplodeNoDMA
  RTS

ChestExplodeNoDMA:
  DW $B09C, $C6AB                         ; Enemy $0FB0 = $C6AB
  DW $C2C9                                ; Enemy $7E:7808 = 7777h
  DW $C303, $0000                         ; Spawn 5 Bomb Torizo low-health explosion enemy projectiles with parameter $0000 and sleep for 28h i-frames
  DW $B11D                                ; Spawn 6 Bomb Torizo low-health continuous drool enemy projectiles
  DW $B09C, $C6FF                         ; Enemy $0FB0 = $C6FF
  DW $C2D1                                ; Enemy $7E:7808 = 0
  DW $C2FD                                ; Go to [enemy $7E:7800]

HeadExplodeNoDMA:
  DW $B09C, $C6AB                          ; Enemy $0FB0 = $C6AB
  DW $C2C9                                 ; Enemy $7E:7808 = 7777h
  DW $C303, $0006                          ; Spawn 5 Bomb Torizo low-health explosion enemy projectiles with parameter 6 and sleep for 28h i-frames
  DW $B1BE                                 ; Enemy $0FB6 |= 4000h
  DW $813A, $0001                          ; Wait 1 frame
  DW $B09C, $C6FF                          ; Enemy $0FB0 = $C6FF
  DW $C2D1                                 ; Enemy $7E:7808 = 0
  DW $C2F7                                 ; Go to [enemy $7E:7800]

ResetSize:
  PHX
  LDX $0E54
  LDA #$0030
  STA $0F84,X
  PLX
  RTL

print pc
LoadPalette_Start_GT:
  LDX $0E54 ; enemy_index
  LDY $0FAE,X ; enemy_var3
  LDA.w PaletteOffsets_Start-2,Y
  TAY
  LDX #$001E
-
  LDA $0000,Y
  STA $7E8320,X
  LDA $0020,Y
  STA $7E8340,X
  DEY
  DEY
  DEX
  DEX
  BPL -
  RTS

PaletteOffsets_Start:
  DW $8787+$1E, #ST_Palette_1+$1E

ST_Palette_1:
    DW $3800, $4BD3, $0325, $0103, $0000, $1746, $02C2, $0243, $01A2, $73E0, $4F20, $2A20, $03FF, $037B, $025F, $0043
ST_Palette_2:
    DW $3800, $372E, $0264, $0042, $0000, $02A1, $0222, $01A2, $0103, $4B40, $25E0, $00E0, $0339, $02B5, $01D9, $0000

ReloadGraphics:
  JSL ReloadGraphicsLong
  RTL

org $A0FFB0
ReloadGraphicsLong:
  JSL $A0814B ; setup D0 table
  PHY : PHX
  LDA $0330
  SEC : SBC #$0007
  TAY
  LDX $0F78 ; enemy_ID
  LDA $A00036,X ; graphics
  CLC 
  ADC $00D2,Y
  STA $00D2,Y
  SEP #$20
  LDA $A00038,X ; graphics bank
  ADC $00D4,Y
  STA $00D4,Y
  REP #$20
  PLX : PLY
  RTL


org $AAD0D1
  DW ReloadGraphics, $0040 : DL $000600 : DW $7300 ; Transfer 0040h bytes from $AFC800 to VRAM $7300
  DW ReloadGraphics, $0040 : DL $000800 : DW $7400 ; Transfer 0040h bytes from $AFCA00 to VRAM $7400


org $AAC2E0
  LDA $0FAE ;LDA $079F


org $AAB24D
DeadTorizo:
  JSR SpawnNext
  BCC DeadTorizoExit_2
  ;LDA #$0004
  ;JSL $8081A6 ;Set boss bits in A for current area
  LDA $B09A
  JSL $808FC1 ;Changes music song/instruments or music track to A, with an 8-frame delay.
  PHY
  PHX
  PHP
  LDA $0FAE ;LDA $079F
  BNE GoldTorizoDead
  JSL $A0BAA4
  BRA DeadTorizoExit
GoldTorizoDead:
  JSL $A0BAD7
DeadTorizoExit:
  PLP
  PLX
  PLY
DeadTorizoExit_2:
  RTL
warnpc $AAB272

org $AAC250
LoadTorizoPalette_2:
  PHX
  LDX $0E54
  JSR LoadTorizoPaletteLoop_2
  PLX
  RTS

org $AAC268
LoadTorizoPalette_3:
  PHX
  LDX $0E54
  JSR LoadTorizoPaletteLoop_3
  PLX
  RTS

org $AAC280
LoadTorizoPalette_4:
  PHX
  LDX #$001E
LoadTorizoPaletteLoop_4:
  LDA $8767,X
  STA $7E8340,X
  LDA $8747,X
  STA $7E8320,X
  DEX
  DEX
  BPL LoadTorizoPaletteLoop_4
  PLX
  RTS

org $AAC298
LoadTorizoPalette_5:
  PHX : PHY
  JSR LoadPalette_Start_GT
  PLY : PLX
  RTS


org $AAC2B0
LoadTorizoPalette_6:
;  PHX
;  LDX $0E54
;  JSR LoadTorizoPaletteLoop_6
;  PLX
;  RTS

org $AAB238
  PHX
  LDX $0E54
  JSR LoadTorizoPaletteLoop_8
  PLX
  RTL
warnpc $AAB24E

; alternate instruction test for GT/headless
org $AAC620
  LDA $0FAE ;LDA $079F ;Region Number

org $AAC6C6
Thing_3:
  LDA $0F86,X ;Property bits (Special from SMILE)
  ORA #$0400 ;Non-responsive enable
  STA $0F86,X
  JSR FindChozoPLM
  BCC SkipThing_3
  LDA $0E4E
  CMP #$0002
  BCS Thing_3_SecondWave
;  PHX
;  LDX #$004E
;Thing_3_Loop:
;  LDA $1C37,X ;PLM header table
;  CMP #$D6EA ;Crumbling Chozo PLM
;  BEQ SkipThing_3
;  DEX
;  DEX
;  BPL Thing_3_Loop
;  PLX ;If the PLM wasn't found, continue waking up the statue
  LDA $B096
  JSL $808FC1 ;Changes music song/instruments or music track to A, with an 8-frame delay.
Thing_3_SecondWave:
  LDA $0F86,X ;Property bits (Special from SMILE)
  AND #$FBFF ;Non-responsive disable
  STA $0F86,X
  INC $0F92,X
  INC $0F92,X
  LDA #$0001
  STA $0F94,X
  RTS
SkipThing_3:
  ;PLX
  RTS


;SilverTorizoShotAI
org $AAC97C
  LDA $0FAE ;LDA $079F


; BT Item drop count
org $A0BAA7
  LDA #$0020

org $A0BAB1
; BT Item drop X position
  AND #$00FF
  CLC
  ADC #$0160

org $A0BABD
  ; BT Item drop Y position
  AND #$7F00
  XBA
  CLC
  ADC #$0120


; GT Init Instruction list
org $AAC9CB
  DW $814B, $0200 : DL $AFE600 : DW $6F00  ; Transfer 0600h bytes from $AFE200 to VRAM $6D00

org $AAD031
  DW $80ED, #LoadEggs
  ; DW $806B, $D5ED ; Enemy enemy_var5_main2= $D5ED
LoadEggs_Return:

; Take one of two branches but also grab a third branch that could be triggered by jump collision code
org $AAD526
  TYA
  INC
  INC
  INC
  INC
  STA $7E7800,X ;store reaction instruction list pointer as third option

  LDA $05E5
  BMI SpawnOrbs
NoSpawnOrbs:
  INY
  INY
SpawnOrbs:
  LDA $0000,Y
  TAY
  RTL
warnpc $AAD54D

org $AAC716
  JSR ChestExplodeLoadPointer ;LDA #$B0E5
org $AAC741
  JSR HeadExplodeLoadPointer ;LDA #$B155

org $AAB8FF
  DW ResetSize
  DW $0030, $AA12
  DW $C3CC, $0000
  DW $0010, $AA1C
  DW $C3CC, $0002
  DW $0008, $AA26
  DW $C3CC, $0004
  DW $0008, $AA30
  DW $C3CC, $0006
  DW $0008, $AA3A
  DW $C3CC, $0008
  DW $0008, $AA4C
  DW $C3CC, $000A
  DW $B94D
  DW $8123, $0010
  DW $0004, $AA5E
  DW $B271
  DW $8110, $B937
  ;DW $C2C8
  DW $C2D1
  DW $B951
  DW $0010, $AA5E
  DW $80ED, $B9B6


org $86AE41
  SEC ;CLC
  SBC #$0018 ;ADC #$FFE0

org $86AE58
  CLC
  ADC #$0018



; crumbling torizo plm
org $84D33B
  LDA $1C85
  CMP $1D77,X ;check if target plm is deleted
  ;LDA $09A4
  ;AND #$1000 check if has bombs

org $84D606
  JSR StoreTargetPLM

org $84FF60
StoreTargetPLM:
  LDA $1C85
  STA $1D77,Y ;store first plm ID
  LDA #$0004
  RTS
