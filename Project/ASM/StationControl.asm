lorom

;;;
; Room arg fmmm mmmm eeeee eeee
; if e = 0 ignore all event bit checks and don't set event bits but otherwise run
; m = message box to show
; e = event bit to check/set
; if f = 0, we're setting the event bit
; if f = 1, we're unsetting the event bit

org $949199
  DW #RightPort, #LeftPort

org $84F2C0
  DW #Setup, $AD62

Setup:
  LDX $1C87,Y
  LDA $7F0002,X
  AND #$0FFF
  ORA #$8000
  STA $7F0002,X

  LDA $1DC7,Y
  AND #$00FF
  BEQ Setup_EventZero
  JSL $808233
  BCS Setup_EventSet
  LDA $1DC7,Y
  BMI Setup_Cancel
Setup_EventZero:

  LDX $1C87,Y
  INX
  INX
  LDA #$B030
  JSR $82B4
  LDX $1C87,Y
  DEX
  DEX
  DEX
  DEX
  LDA #$B031
  JSR $82B4
  RTS

Setup_EventSet:
  LDA $1DC7,Y
  BMI Setup_EventZero:

Setup_Cancel:
  LDA #$AD76
  STA $1D27,Y
  RTS


RightPort:
  DW $B1C8, #RightPort_InstructionList
LeftPort:
  DW $B1F0, #LeftPort_InstructionList

RightPort_InstructionList:
  DW $8C10
  	DB $37 ; Queue sound 37h, sound library 2, max queued sounds allowed = 6 (refill/map station engaged)
  DW $0006, $9F49
  DW $0060, $9F55
  DW #ActivateRight ;$883E 
  DW $0006, $9F55
  DW $8C10
  	DB $38 ; Queue sound 38h, sound library 2, max queued sounds allowed = 6 (refill/map station disengaged)
  DW $0006, $9F55
  DW $D5EE ; Unlock controls
  DW $0006, $9F49
  DW $86BC ; Delete

LeftPort_InstructionList:
  DW $8C10
    DB $37 ; Queue sound 37h, sound library 2, max queued sounds allowed = 6 (refill/map station engaged)
  DW $0006, $9F5B
  DW $0060, $9F67
  DW #ActivateLeft ;$883E 
  DW $0006, $9F67
  DW $8C10
    DB $38 ; Queue sound 38h, sound library 2, max queued sounds allowed = 6 (refill/map station disengaged)
  DW $0006, $9F67
  DW $D5EE ; Unlock controls
  DW $0006, $9F5B
  DW $86BC ; Delete

org $84F720
ActivateRight:
  PHX
  LDA #$FFFF
  STA $7EFB20 ; invalidate minimap
  LDA $1C87,X
  DEC
  DEC
  BRA Activate_Search
ActivateLeft:
  PHX
  LDA #$FFFF
  STA $7EFB20 ; invalidate minimap
  LDA $1C87,X
  INC
  INC
  INC
  INC
Activate_Search:
  LDX #$004E
Activate_Search_Loop:
  CMP $1C87,X
  BEQ Activate_Search_Continue
  DEX
  DEX
  BRA Activate_Search_Loop
Activate_Search_Continue:

  LDA $1DC7,X
  XBA
  AND #$007F
  JSL $858080
  LDA $05F9
  BNE Activate_EventZero

  LDA $1DC7,X
  BMI Activate_EventUnset
  AND #$00FF
  BEQ Activate_EventZero
  JSL $8081FA
Activate_EventZero:
  PLX
  RTS

Activate_EventUnset:
  AND #$00FF
  JSL $808212
  PLX
  RTS
