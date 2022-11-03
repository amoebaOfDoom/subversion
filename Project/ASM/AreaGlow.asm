lorom

org $89AC62
  JSR GetTilesetIndex ;LDA $079F
  ASL A
  TAY
  LDA GlowTypeTable,Y ;DB is $83

org $89AC98
  JSR GetTilesetIndex ;LDA $079F
  ASL A
  TAY
  LDA AnimationTypeTable,Y

org $89AF60 ;free space
GetTilesetIndex:
  PHX
  LDX $07BB
  LDA $8F0003,X
  PLX
  AND #$00FF
  RTS

org $83B950 ;free space
GlowTypeTable:
  DW $AC66;, $AC66 ;Crateria Surface
  DW $AC86 ;Jungle
  DW $AC66;, $AC66 ;Inner Crateria
  DW $AC86 ;Jungle
  DW $ACC6, $ACC6 ;Wrecked Ship ;$8257, $8251, $8275 (81E1), $827B (81F7), $826F (81CB), $824B, $824B, $824B
  DW $AC86, $AC86 ;Brinstar
  DW $AC66 ;Tourian Statues Access
  DW $ACA6, $ACA6 ;Norfair
  DW $ACE6, $ACE6 ;Maridia
  DW $AD06, $AD06 ;Tourian
  DW $AD26, $AD26, $AD26, $AD26, $AD26, $AD26 ;Ceres
  DW $AC66, $AC66, $AC66, $AC66, $AC66 ;Utility Rooms
  DW $AC86 ;Kraid
  DW $ACA6 ;Crocomire
  DW $ACE6 ;Peaks
  DW $ACA6 ;Norfair
  DW $AC66 ;Crateria - island
  DW $ACA6 ;Draygon
  ;20
  DW $AD46 ;Phantoon
  DW $ACA6 ;Generator
  DW $AD06 ;Tourian - right ship
  DW $AD26 ;Tourian - right ship
  DW $AD06 ;Tourian - left ship
  DW $ACA6 ;Norfair - left ship
  DW $ACE6 ;Maridia - station
  DW $AC66 ;Crateria - outside + ships
  DW $AD06 ;Tourian - wrecked right ship
  DW $ACE6 ;Maridia - ice2
  DW $AC66 ;Crateria Surface
  DW $AD06 ;Tourian - wrecked left ship
  DW $AD06 ;Tourian - wrecked left ship
  DW $AC66 ;Utility Rooms
  DW $ACE6 ;Maridia - island
  DW $ACE6 ;Maridia - island
  DW $ACE6 ;Maridia - island
  DW $ACE6 ;Maridia - island


AnimationTypeTable:
  DW $AC76;, $AC76 ;Crateria Surface
  DW $AC96 ;Jungle
  DW $AC76;, $AC76 ;Inner Crateria
  DW $AC96 ;Jungle
  DW $ACD6, $ACD6 ;Wrecked Ship
  DW $AC96, $AC96 ;Brinstar
  DW $AC76 ;Tourian Statues Access
  DW $ACB6, $ACB6 ;Norfair
  DW $ACF6, $ACF6 ;Maridia
  DW $AD16, $AD16 ;Tourian
  DW $AD36, $AD36, $AD36, $AD36, $AD36, $AD36 ;Ceres
  DW $AC76, $AC76, $AC76, $AC76, $AC76 ;Utility Rooms
  DW $AC96 ;Kraid
  DW $ACB6 ;Crocomire
  DW $ACF6 ;Maridia
  DW $ACB6 ;Norfair
  DW $AC76 ;Crateria - island
  DW $ACA6 ;Draygon
  ;20
  DW $AD56 ;Phantoon
  DW $ACB6 ;Generator
  DW $AD06 ;Tourian - right ship
  DW $AD26 ;Ceres - right ship
  DW $AD06 ;Tourian - left ship
  DW $ACB6 ;Norfair - left ship
  DW $ACF6 ;Maridia - station
  DW $AC76 ;Crateria - outside + ships
  DW $AD16 ;Tourian - wrecked right ship
  DW $ACF6 ;Maridia - ice2
  DW $AC76 ;Crateria Surface
  DW $AD06 ;Tourian - wrecked left ship
  DW $AD06 ;Tourian - wrecked left ship
  DW $AC76 ;Utility Rooms
  DW $ACF6 ;Maridia - island
  DW $ACF6 ;Maridia - island
  DW $ACF6 ;Maridia - island
  DW $ACF6 ;Maridia - island

org $83AC86 ;Brinstar palette glow object list
  DW $F775, $F77D, $F781, $F779, $F761, $F745, $F745, $F745

; Maridia animated tiles object list
org $83ACF6
  DW $8257, $8251, $8287, $828D, CurrentAnimation, $824B, $825D, $824B

org $8781BA ;Animate tiles in wrecked ship?
  ;LDA #$0001
  ;JSL $8081DC
  ;BCS $07
  ;PLA
  ;LDA #$0001
  ;STA $1F19,x
  RTS ;Always animate

org $948E83 ;Spike (BTS 0) remove Wrecked Ship check
  BRA SpikeDamage : NOP ;AD 9F 07    LDA $079F  [$7E:079F]
  NOP : NOP : NOP       ;C9 03 00    CMP #$0003
  NOP : NOP             ;D0 09       BNE $09    [$8E94]
  NOP : NOP : NOP       ;A9 01 00    LDA #$0001
  NOP : NOP : NOP : NOP ;22 DC 81 80 JSL $8081DC[$80:81DC]
  NOP : NOP             ;90 3A       BCC $3A    [$8ECE]
SpikeDamage:


org $87827B ;
  DW $81F7, $0020, $18F0 ;Wrecked Ship treadmill (Left) use a free tile so we can have both animations at the same time

org $87AD80 ; free space
CurrentAnimation:
  DW CurrentAnimation_InstructionList, $0100, $1E00
CurrentAnimation_InstructionList:
  DW $0004, CurrentAnimation_Tiles+$000
  DW $0004, CurrentAnimation_Tiles+$100
  DW $0004, CurrentAnimation_Tiles+$200
  DW $0004, CurrentAnimation_Tiles+$300
  DW $0004, CurrentAnimation_Tiles+$400
  DW $0004, CurrentAnimation_Tiles+$500
  DW $0004, CurrentAnimation_Tiles+$600
  DW $0004, CurrentAnimation_Tiles+$700
  DW $0004, CurrentAnimation_Tiles+$800
  DW $0004, CurrentAnimation_Tiles+$900
  DW $0004, CurrentAnimation_Tiles+$A00
  DW $0004, CurrentAnimation_Tiles+$B00
  DW $0004, CurrentAnimation_Tiles+$C00
  DW $0004, CurrentAnimation_Tiles+$D00
  DW $0004, CurrentAnimation_Tiles+$E00
  DW $0004, CurrentAnimation_Tiles+$F00
  DW $80B7, CurrentAnimation_InstructionList
CurrentAnimation_Tiles:
  incbin ROMProject/Graphics/Current.gfx

  ;touch negative
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B633, $B633, $D030, $D034, $D03C, $D040, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $D6DA, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $D6F2, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B72B, $B72B, $B72B, $B737, $B73B, $B73F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F

  ;collide negative
  ;DW $B70F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B6CB, $B6CF, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B653, $B657, $B65B, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B713, $B713, $B713, $B71F, $B723, $B727, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B70F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F

  ;touch positive
  ;DW $D044, $D048, $D04C, $D050, $D054, $D058, $D05C, $D060, $F580, $B62F, $B62F, $B62F, $B62F, $B62F, $D038, $D040
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $C83E, $EED3, $B6FF, $B6D7, $B6DB, $B6E3, $B6E7, $B6EF, $B6F3, $B76B, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B633, $B633, $D030, $D034, $D03C, $D040, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B62F, $B62F, $B62F, $D6DA, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F

  ;collide positive
  ;DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98EA, $9910, $9936, $9946, $98E3, $98E3, $98E3, $98E3
  ;DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3
  ;DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3
  ;DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3
  ;DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $9956, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98E3
  ;DW $B70F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B6CB, $B6CF, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F
  ;DW $B653, $B657, $B65B, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F

;treadmill BTS values:
; ... (nothing)
;06 = treadmill right except in WShip when phantoon is dead
;07 = treadmill left except in WShip when phantoon is dead
;08 = treadmill right
;09 = treadmill left
;0A = treadmill right
;0B = treadmill left
; ... (nothing?)
;80 = quicksand
;81 = quicksand (duplicate unused)
;82 = quicksand (duplicate unused)
;83 = heavy falling sand
;84 = ???
;85 = light falling sand
; ... (nothing)
;8E = floor gaping maw from red brinstar
;8F = ceiling gaping maw from red brinstar

org $9491D9 ;touch negative
  DW $B72B, $B72B, $B72B, $B737, $B73B, $B73F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B633, $B633
org $949A06 ;collide negative
  DW $B713, $B713, $B713, $B71F, $B723, $B727, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B62F, $B6CB, $B6CF
org $949966 ;collide positive
  DW $98E3, $98E3, $98E3, $98E3, $98E3, $98E3, $98EA, $9910, $98FB, $9921, $9936, $9946, $98E3, $98E3, $98E3, $98E3

org $94908C ;touch
  LDA #$0000 ;LDA $079F
org $94909D ;touch
  JMP $906F
org $949B2F ;collide
  LDA #$0000 ;LDA $079F

org $8DEC59
  ;LDA $0AFA
  ;CMP #$0380
  ;BCS +
  ;LDA #$0001
  ;STA $1ECD,x
  ;LDA #$EB43
  ;STA $1EBD,x
;+
  RTS