lorom

;9D5B solid
;9D59 air

org $B*2+$94A175
  DW CrumbleShotReaction
org $B*2+$94A195
  DW CrumbleShotReaction

org $B*2+$94A83B
  DW CrumbleGrappleReaction

org $94B200
CrumbleShotReaction:
  LDX $0DC4
  LDA $7F6402,X
  AND #$00FF
  CMP #$000B
  BNE +
  JMP $9D59
+
  JMP $9D5B

CrumbleGrappleReaction:
  LDX $0DC4
  LDA $7F6402,X
  AND #$00FF
  CMP #$000B
  BNE +
  JMP $A7C9
+
  JMP $A7CD
