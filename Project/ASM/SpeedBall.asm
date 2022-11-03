lorom

org $90854D
    AND #$000F

org $909774
    AND #$000F

org $9085B0
  LDA $0A1F ;LDA $0B3E
  AND #$00FF ;AND #$FF00
  JSR GetDelay : NOP ;ORA $91B61F,X
  ;STA $0B3E

; morph ball animation is a bit less than half the frames of the normal running animation
org $90F81A
GetDelay:
  ;LDA $0A1F
  ;AND #$00FF
  CMP #$0001
  BEQ +
  LDA $0B3E
  AND #$FF00
  ORA SpeedBallDelayTable,X
  RTS
+
  LDA $0B3E
  AND #$FF00
  ORA $91B61F,X
  RTS

SpeedBallDelayTable:
  DW 0002, 0002, 0003, 0002, 0004


org $84E294 : DW #CollectSpring ; $88F3 collected equipment
org $84E6E8 : DW #CollectSpring ; $88F3 collected equipment
org $84EBEC : DW #CollectSpring ; $88F3 collected equipment

org $84FDEF
CollectSpring:
  PHP
  SEP #$20
  LDA $0A1C ; Samus pose
  CMP #$1D ; Facing right - morph ball - no springball - on ground
  BNE +
  LDA #$79 ; Facing right - morph ball - spring ball - on ground
+
  CMP #$41 ; Facing left  - morph ball - no springball - on ground
  BNE +
  LDA #$7A ; Facing left  - morph ball - spring ball - on ground
+
  CMP #$1E ; Moving right - morph ball - no springball - on ground
  BNE +
  LDA #$7B ; Moving right - morph ball - spring ball - on ground
+
  CMP #$1F ; Moving left  - morph ball - no springball - on ground
  BNE +
  LDA #$7C ; Moving left  - morph ball - spring ball - on ground
+
  CMP #$31 ; Facing right - morph ball - no springball - in air
  BNE +
  LDA #$7F ; Facing right - morph ball - spring ball - in air
+
  CMP #$32 ; Facing left  - morph ball - no springball - in air
  BNE +
  LDA #$80 ; Facing left  - morph ball - spring ball - in air
+
  STA $0A1C ; Samus pose
  PLP
  JMP $88F3 ; collected equipment



