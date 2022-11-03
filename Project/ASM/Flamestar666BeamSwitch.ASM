lorom      ;Super Metroid (JU) unheadered
           ;Created March 29, 2010 by Flamestar666
           ;Metroidconstruction.com

;____INFORMATION____
;this pretty little asm file is my first real public release. Pretty much this modifies the 'Air
;fool X-ray block 07 and 08. 07 is the actual hyperbeam block, and 08 is a block that must surround the area, that resets and restores your normal beam.

;The 07 should be set up 3 tiles high at minumum, and have 08 on the exit area (above, below, to the sides, etc)
;____END OF INFO____


; Type Spike (A) with BTS 07 will also behave the same except it's solid to enemies and beams
org $949039
  DW #NewSpikeCollide
org $949B54
  DW #NewSpikeTouch

org $94DC00
NewSpikeCollide:
  LDA $09A2 ; equipped items
  BIT #$0010 ; metroid suit
  BEQ OldSpikeCollide
  PLA
  CLC
  RTS
OldSpikeCollide:
  JMP $8E83

NewSpikeTouch:
  LDX $0DC4  
  LDA $7F6402,x
  AND #$00FF
  CMP #$0007            
  BEQ OldSpikeTouch
  JMP $98DC
OldSpikeTouch:
  JMP $B700


;START OF BTS 07___________
org $9498BA    ;Hi-jack point for Air-Fool X-ray 07

  DW $B700  ;free space

org $94B700
  LDA $09A2 ; equipped items
  BIT #$0010 ; metroid suit
  BNE SuitOn_1
  JSR NoTimer
  RTS

SuitOn_1:
  STZ $0CD0  ;Disables charge beam (fixes lockup issue) (2 bytes)
  LDA $0B3F  ;Address for the speedboosters (2 bytes)
  BEQ CHECK  ;Branches to CHECK if the speedboosters is not active
  RTS

CHECK:       ;Check for the hyperbeam, if the hyperbeam is not active, continues to HYPER
  LDA #$0008  ;#$FFFF
  STA $7FFD70 ; Override the timed hyperbeam
  LDA $0A76  ;Hyperbeam address (2 bytes)
  BEQ HYPER  ;Branches to HYPER if = #$0000
  RTS

HYPER:         ;Hyperbeam activator
;  LDA $09A6    ;Load load current beams + chargebeam into accumulator (2 bytes)
;  STA $7EFA04  ;stores the accumulator into this ram address
  LDA #$3C08   ;load this into accumulator (needed for Hyperbeam to work)
  STA $0A76    ;Hyperbeam address (2 bytes)
  LDA #$8014
  STA $0B18  
;  LDA #$100B   ;Sets the correct value for the Hyperbeam (2 bytes)
;  STA $09A6    ;Current beam addresses (2 bytes)
;  JSR DELETE
;  JSR $90AC8D  ;Resets the beam graphics and palettes (used to set the correct beam/color)
  RTS
;END OF BTS 07_____________

;START OF BTS 08___________  
org $9498BC    ;Hi-jack point for Air-Fool X-ray 08

  DW $B800  ;free space

org $94B800
  
  LDA $7FFD70
  BMI NoTimer
  RTS
NoTimer:
  LDA $0A76  ;Hyperbeam address (2 bytes)
  BNE CLEAR  ;If not #$0000, jump to CLEAR
  RTS

CLEAR:    ;Resets Palette, charge beam
  LDA #$FFFF
  STA $7FFD70
;  LDA $7EFA04 ;Beam is stored here while hyperbeam is in use
;  STA $09A6   ;Restores stored current beam
  STZ $0A76   ;Disabled Hyperbeam
  STZ $0B62   ;Fixes pallete issue with charge beam (light samus)
  STZ $0CD0   ;disabled charge beam (charge beam bug)
  STZ $0A4A
  LDA #$0001
  STA $0B18   ;fixes yellow samus (charge beam bug)

;  JSR DELETE
;  JSR $90AC8D  ;Resets the beam graphics and palettes (used to set the correct beam/color)

  ;Reset Samus' palette
  PHP
  REP #$30
  PHB
  PEA $9B00
  PLB
  PLB

  PHY
  PHX

  LDX $7E0A74
  LDA $90F840,x ; suit palette array
  TAX
  JSL $97EAE9 ;ThermalVisor.asm => ReloadSamusPalette

  PLX
  PLY

  PLB
  PLP
  RTS
  
  ;END OF BTS 08_____________

DELETE: ;deletes every >beam< projectile onscreen to prevent cheating and glitching
  PHX
  PHA
  LDX #$0000
DELETENEXT:
  LDA $0C18,x
  BIT #$000F
  BEQ +
  BIT #$0020
  BNE +
  LDA $0C86,x
  BNE +
  JSL $90ADB7
+
  INX : INX : CPX #$000A : BNE DELETENEXT
  JSL $82BE17 ;clear sounds once
  PLA
  PLX
  RTS


org $809B4E 
  JSL HyperTimer ; LDA $09C0
  NOP : NOP      ; CMP #$0001

org $94B880
HyperTimer:
  LDA $0998
  CMP #$0008
  BEQ NormalGameMode

NormalGameMode:
  LDA $09A2 ; equipped items
  BIT #$0010 ; metroid suit
  BNE SuitOn_2
  STZ $7FFD70 ; clear the timer and remove hyperbeam if the suit was changed

SuitOn_2:
  LDA $7FFD70
  BMI HyperTimer_Return
  CMP #$0100
  BMI SaneValue
  LDA #$0000
SaneValue:
  DEC
  STA $7FFD70
  BMI Empty
  STZ $0CD0
  ;LDA $0A4A
  ;BNE PaletteOn
  ;LDA #$8000
  ;STA $0A4A
;PaletteOn:
  LDA $0A76
  BNE HyperTimer_Return
  JSR HYPER
  BRA HyperTimer_Return
Empty:
  JSR $B800
HyperTimer_Return:
  LDA #$0001 ; make reserve check fail as injection
  RTL
