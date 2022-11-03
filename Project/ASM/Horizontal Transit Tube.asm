lorom

;The Maridia tube moves Samus horizontally instead of vertically.
;This also requires rotating the room.
;Use doorcode for leaving this room to enable controls (unchanged from vertical):
;    LDA #$0001
;    JSL $90F084
;    RTS
;Use doorcode when entering from the left (same as vertical top):
;    LDA #$0000
;    JSL $90F084 ;disable controls
;    LDA #$0100
;    STA $07E5 ;speed
;    LDA #$0040
;    STA $07E3 ;position
;    LDA #$0020
;    STA $07E7 ;acceleration
;    RTS
;Use doorcode when entering from the right (same as vertical bottom):
;    LDA #$0000
;    JSL $90F084 ;disable controls
;    LDA #$FF00
;    STA $07E5 ;speed
;    LDA #$09C0
;    STA $07E3 ;position = length of room in tiles - $40
;    LDA #$FFE0
;    STA $07E7 ;acceleration
;    RTS

;FX2 used from room that will move Samus according to the parameters set in the doorcode descrbed above
org $8FE2B6
LDA #$0080
RunTube:
STA $0AFA ;Samus's Y position in pixels
STZ $0AFC ;Samus's sub-pixel Y position

org $8FE2E5 
JSL $94971E

org $8FE2F1
ADC #$0A20
CMP #$1441

org $8FE2FA
SBC #$0A20
STA $07E5

org $8FE390
  LDA $07E5
  BMI GoingLeft

GoingRight:
  LDA $0AFA
  BIT #$FF00
  BNE Continue
  LDA $0AF6
  CMP #$0E00
  BMI Continue
  LDA #$0140
  STA $0AF6
  LDA #$0015
  STA $07A3
  LDA #$002E
  STA $07A1
  LDA #$0280
  JMP RunTube

GoingLeft:
  LDA $0AFA
  BIT #$FF00
  BEQ Continue
  LDA $0AF6
  CMP #$00C0
  BPL Continue
  LDA #$0DA8
  STA $0AF6
  LDA #$0017
  STA $07A3
  LDA #$0020
  STA $07A1
  LDA #$0040
  JMP RunTube 

Continue:
  LDA $0AFA
  AND #$FF00
  ORA #$0080
  JMP RunTube
