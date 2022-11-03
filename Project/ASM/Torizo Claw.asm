lorom

; ---------------------------------------------------------------------------------------------
; Allows multistate lava statues.
; To add more states:
;   - append to `ChozoStatueEnemyIntructionTable` with $E39D (it may need to be repointed)
;   - append to `LavaEvents` a new event ID
;   - append to `LavaHeights` a new lava height
;
; These events are cumulative, so setting any N events will set the lava to the N+1 height
; The set the chozo statue Speed2 value to the appropriate event entry ID
;   - '0' = Wrecked Ship
;   - '2X' = Lava event entry X-1
;
; Adding the PLM `D6D6` will set the liquid level to the appropriate height without the statue
;   - Set the PLM's roomarg to 8000+ (this will make it skip the normal statue checks)
; ----------------------------------------------------------------------------------------------


org $AAE755
  LDA ChozoStatueEnemyIntructionTable,y
org $AAE799
  LDA #$D6D6
  JSL $8484E7
  RTL

org $AAF7D8
ChozoStatueEnemyIntructionTable:
  DW $E457, $E39D, $E39D

org $AAE42F 
  LDA #$0080 ; Lava velocity (was $0040)
org $AAE439
  NOP : NOP : NOP ; STA $1978

org $84D6D6
ChozoHandPLMHeader:
  DW #ChozoHandInit, #ChozoHandInstuctionList 
ChozoHandTriggerPLMHeader:
  DW #ChozoHandTriggerSetup, $AAE3


org $84D0F6
ChozoHandPreInstruction:
  PHX
  PHY
  LDY $1C27      ; \
  LDX $1C87,Y    ; |
  LDA $7F0002,X  ; } Check is tile at the PLM is air
  CMP #$00FF     ; |
  BNE NotAirTile ; /
  LDA #$B083     ; \
  JSR SetupHandReaction
  LDX $1C27      ; |
  STZ $1C37,X    ; /
NotAirTile:
  PLY
  PLX
  RTS
warnpc $84D117

org $84D13F
LavaEvents:
  DW $0014, $0015
LavaHeights:
  DW $02C8, $04C8, $06C8

ChozoHandInit:
  LDA $1DC7,Y    ; \
  BMI ChozoHandInit_SkipEnemyTest ; } If roomarg is negative, skip enemy tests

  LDA $0FB4
  BEQ ChozoHandInit_Continue
  ; Already triggered, delete plm
  LDA #$0000    ;\
  STA $1C37,Y   ;} Delete PLM
  RTS
ChozoHandInit_Continue:

  LDA $0F7E   ;\
  LSR A       ;|
  LSR A       ;|
  LSR A       ;|
  LSR A       ;|
  DEC A       ;|
  SEP #$20    ;|
  STA $4202   ;|
  LDA $07A5   ;|
  STA $4203   ;|
  REP #$20    ;} PLM block index = [enemy0 Y position] / 10h * [room width] + [enemy0 X position] / 10h
  LDA $0F7A   ;|
  LSR A       ;|
  LSR A       ;|
  LSR A       ;|
  LSR A       ;|
  INC A       ;|
  INC A       ;|
  CLC         ;|
  ADC $4216   ;|
  ASL A       ;|
  STA $1C87,Y ;/
ChozoHandInit_SkipEnemyTest:
  ; Set instruction execution delay
  LDA #$0001
  TYX
  STA $7EDE1C,X
  RTS

ChozoHandSetLavaLevel:
  PHX
  PHY
  LDY #$0002 ; max event index 
  LDX #$0000
GetLavaEventLoop:  
  LDA.w LavaEvents,Y ; \
  JSL $808233      ; |
  BCC +            ; } X = number of set events * 2
  INX : INX        ; |
+                  ; |
  DEY : DEY        ; /
  BPL GetLavaEventLoop
  LDA.w LavaHeights+2,X
  STA $197A ; Set Lava Target Height (next)
  LDA.w LavaHeights,X

  JSL $89AF80 ; Set lava fade effect, address from Suits.asm

  PLY
  PLX
  RTS

ChozoHandInstuctionList:
  DW #ChozoHandSetLavaLevel
  DW #DeleteIfEventSet
  DW $86C1, #ChozoHandPreInstruction ; Set Pre-instruction code
  DW $86B4 ; sleep
  DW $86BC ; delete self

DeleteIfEventSet:
  LDA $1DC7,X    ; \
  BMI EventSet ; } If roomarg is negative, then delete
  JSR GetEventID  ; \
  JSL $808233     ; } If the event is set, then delete
  BCC EventNotSet ; /
EventSet:
  STZ $1C37,x  ;} Delete PLM 
EventNotSet:
  RTS

GetEventID:
  ; returns event ID for this room arg
  PHY
  LDY $0FB6
  LDA.w LavaEvents-2,Y
  PLY
  RTS

SetupHandReaction:
  DEX : DEX
  JSR $82B4      ; } Set the tile to chozo hand react BTS and delete self
  INX : INX
  LDA #$0000
  JSR $82B4
  RTS
warnpc $84D1E6

org $84F270
ChozoHandTriggerSetup:
  LDA $0B02     ;\
  AND #$000F    ;|
  CMP #$0003    ;} If [collision direction] != below: go to BRACH_RETURN
  BNE ChozoHandTriggerSetupReturn
  LDA $0A1C     ;\
  CMP #$001D    ;} If [Samus' pose] != facing right - morph ball - no springball - on ground:
  BEQ ChozoHandTriggerSetupActivate
  CMP #$0079    ;\
  BEQ ChozoHandTriggerSetupActivate
  CMP #$007A    ;} If Samus is not in morph ball with spring ball on ground: go to BRANCH_RETURN
  BNE ChozoHandTriggerSetupReturn
ChozoHandTriggerSetupActivate:
  JSR GetEventID;\
  JSL $8081FA   ;} Set Lower Norfair chozo event
  LDA #$0001    ;\
  STA $0FB4     ;} Enemy 0 Speed = 1
  LDX $1C87,y   ;\
  LDA $7F0002,x ;|
  AND #$0FFF    ;} Make PLM block air
  STA $7F0002,x ;/
  LDA #$0000    ;\
  JSL $90F084   ;} Disable Samus' controls

ChozoHandTriggerSetupReturn:
  LDA #$0000    ;\
  STA $1C37,y   ;} Delete PLM
  SEC
  RTS

;;; Wreaked ship torizo

org $AAE7BA ; ignore boss dead flag
  NOP : NOP ;BEQ $1D 

org $84D627 ; ignore boss dead flag
  NOP : NOP ;BCC $4E

org $949279 ; add claw reaction BTS to area 5
  DW $D6F2

org $AAE77F
  DB $27, $1D
org $AAE711
  DB $27, $1D
org $84D673
  DB $27, $1D

org $84D3D8
  LDX #$1628 ;tilenumber * 2
org $84D3E1
  LDX #$162A
org $84D3F5
  LDX #$1628 
org $84D3FE
  LDX #$162A

org $AAE4BD
  DW $8123, $000E ; walking animation cycle count

org $84D64C
  LDA #$0202
  JSL UpdateScrolls_1
  LDA #$0101
  JSL UpdateScrolls_2

org $AAE6F7
  LDA #$0000
  STA $7ECD26
  STA $7ECD28
  STA $7ECD29
  LDA #$0101
  JSL UpdateScrolls_2

org $8AB500
UpdateScrolls_1:
  STA $7ECD27
  STA $7ECD28
  RTL

UpdateScrolls_2:
  STA $7ECD2D
  STA $7ECD2E
  RTL

org $AAE5C3
  NOP : NOP : NOP : NOP ;JSL $8484E7

org $849CC5
  DW $000E
    DW $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $0056, $1056
  DB $00, $05
  DW $0009
    DW $0144, $0143, $0142, $0522, $0143, $0108, $0108, $0108, $1167
  DB $05, $06
  DW $0002
    DW $0542, $0164
  DB $05, $07
  DW $0001
    DW $0503
  DB $05, $08
  DW $0001
    DW $1520
  DW $0000

org $849D0F
  DW $000E
    DW $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $A056, $8056
  DB $00, $05
  DW $0009
    DW $8144, $8143, $8142, $8522, $8143, $8108, $8108, $8108, $8167
  DB $05, $06
  DW $0002
    DW $8542, $8164
  DB $05, $07
  DW $0001
    DW $8503
  DB $05, $08
  DW $0001
    DW $8520
  DW $0000