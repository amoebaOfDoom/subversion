lorom

!visible = $1050

!enemy_prop1 = $0F86
!layer1_X = $0911
!enemy_X = $0F7A
!enemy_var0 = $0FA8
!enemy_var5 = $0FB2
!equipped_items = $09A2

org $A7CECD
  LDA !layer1_X 
  SEC          
  SBC !enemy_X,x
  SEC          
  SBC #$FFD8   
  STA $B5      
  JSL SetVisibility
  NOP
  ; This address is always set to zero, so the check is unneeded
  ; LDA enemy_param1[1]
  ; BNE $1A


org $A7D763 : JSR SetRandomVisibility ; STA enemy_var5,x ;} Next state is $D767
org $A7D726 : JSR SetRandomVisibility ; STA enemy_var5,x ;} Next state is $D72D
org $A7D86A : JSR SetRandomVisibility ; STA enemy_var5,x ;} Next state is $D874

org $A7D0DB
  STZ !enemy_var5+$40
  BRA Pattern8EndReturn

warnpc $A7D0E8
org $A7D0E7
Pattern8EndReturn:

org $A7D82A
  LDA #$000C             ;\
  JSR $D464              ;} Fade-out
  JSR $D0F1              ; Adjust Phantoon speed and move Phantoon in figure-8

  LDA !enemy_var5+$40 ;} Check fade complete flag
  BEQ .return
  STZ !enemy_var0+$80    ; Clear swooping flag
  LDA #$D7F7             ;\
  STA !enemy_var5,x      ;} Next state is $D73F
.return
  RTS

SetRandomVisibility:
  STA !enemy_var5,x
  JSL $808111 ; Generate random number
  AND #$0800
  STA !visible
  RTS
warnpc $A7D85C


org $A7D508
SpinningFlamesStage:
  DEC $0FB0,X ; Phase timer
  BEQ SetupSpiralingFlames
  BPL ExitSpinningFlames
SetupSpiralingFlames:
  LDA #$004C
  STA $0FB0,X ;Phase timer
  LDA #SpiralingFlames
  STA $0FB2,X ;Current phase

  LDA !equipped_items
  AND #$0800
  STA !visible

ExitSpinningFlames:
  RTS

SpiralingFlames:
  JSL SpiralingFlames_2
  LDA !equipped_items
  AND #$0800
  EOR !visible
  BEQ ExitSpiralingFlames
  JSL SetupShowPhantoon_2
ExitSpiralingFlames:
  RTS
warnpc $A7D54A

; free space
org $88F320
SetVisibility:
  LDA !equipped_items
  EOR !visible
  AND #$0800
  BNE .return

.invisible
  LDA #$00F0
  STA $B5 ; scroll phantoon off screen

.return
  RTL


SpiralingFlames_2:
  DEC $0FB0,X ;Phase timer
  BEQ ContinueSpiralingFlames_2
  BPL ExitSpiralingFlames_2
ContinueSpiralingFlames_2:
  JSL $808111 ;Random number generator
  AND #$00FF
  ORA #$0200
  LDY #$9C29
  JSL $868027 ;spawns enemy specific projectiles
  LDA #$001D
  JSL $80914D ;Play sound from Library 3
  LDA #$001E
  STA $0FB0,X ;Phase timer
ExitSpiralingFlames_2:
  RTL

SetupShowPhantoon_2:
  STZ $0FAA,X
  LDA $1988
  ORA #$4000
  STA $1988
  LDA #$D54A ; ShowPhantoonPhase
  STA $0FB2,X ; Current phase
  LDA #$8001
  STA $1074
  LDA #$0010 ;LDA #$0078
  STA $0FB0,X ; Phase timer
  LDA $CDA3
  STA $16
  ;LDA #$0002
  ;JSL $88E487 ; activate ripple effect
  LDA $CD9D
  STA $106E
  STZ $0FF2 ; $0FB2 for enemy $01 - activate visability?
  LDA #$0005
  JSL $808FC1
  RTL

SetKillCount:
  JSL $81FAA5 ; Incremment kill count (challenges.asm)
  LDA $7ED828,x ; displaced
  RTL

org $A7DB7E
  JSL SetKillCount ; LDA $7ED828,x
  ORA #$0002 ;Phantoon sets miniboss area bit
  ;ORA #$0001

