lorom

; The pixel (but not sub-pixel) value for every gravity mode is always $0000.
; Free up the instructions that are loading that and use the space to check for gravity boots.
org $909C5B
  LDA $09A2 ; load equipped items
  BIT #$0020 ; gravity suit
  BNE Branch_Air
  LDA $197E ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
  BIT #$0004 ; Check for water disable flag set
  BNE Branch_Air
  JSL $90EC3E ;??? guess is that it sets $12 to Samus' feet Y position
  LDA $195E ; Actual FX3 height
  BMI Branch_2
  CMP $12
  BMI Branch_Water
  BRA Branch_Air
Branch_2:
  LDA $1962 ; Something to do with FX3 height. Referred to if 195E is negative. Used by lava?
  BMI Branch_Air
  CMP $12
  BMI Branch_Lava
Branch_Air:
  LDA $9EA1 ;vertical acceleration modifier (planet's gravity) in sub-pixels in air - this could have been LDA #$1C00
  ;STA $0B32
  ;LDA $9EA7 ;vertical acceleration modifier (planet's gravity) in pixels in air - this could have been LDA #$0000
  ;STA $0B34
  BRA Exit
Branch_Water:
  LDA $9EA3 ;vertical acceleration modifier (planet's gravity) in sub-pixels in water (no gravity suit) - this could have been LDA #$0800
  ;STA $0B32
  ;LDA $9EA9 ;vertical acceleration modifier (planet's gravity) in pixels in water (no gravity suit) - this could have been LDA #$0000
  ;STA $0B34
  BRA Exit
Branch_Lava:
  LDA $9EA5 ;vertical acceleration modifier (planet's gravity) in sub-pixels in lava/acid (no gravity suit) - this could have been LDA #$0900
  ;STA $0B32
  ;LDA $9EAB ;vertical acceleration modifier (planet's gravity) in pixels in lava/acid (no gravity suit) - this could have been LDA #$0000
  ;STA $0B34
Exit:
  STA $0B32
  STZ $0B34
  LDA $09A2 ; load equipped items
  BIT #$0400 ; gravity boots
  BNE HasGravityBoots
  JSR ApplyNoGravityBootsModifier
HasGravityBoots:
  RTS
PadByte $FF : Pad $909CAB

org $90910C
  JSR MaxFall
  NOP : NOP : NOP
  ;LDA $0B2E
  ;CMP #$0005

org $90F760
MaxFall:
  LDA $09A2 ; load equipped items
  BIT #$0400 ; gravity boots
  BNE MaxFallWithGravityBoots
  LDA $079F
  CMP #$0006 ; Ceres Station
  BEQ MaxFallInSpace
  LDA $0B2E
  CMP #$0006 ; increase max fall speed
  RTS
MaxFallInSpace:
  LDA $0B2E
  CMP #$0004 ; decrease max fall speed
  RTS
MaxFallWithGravityBoots:
  LDA $0B2E
  CMP #$0005 ; normal physics max fall speed
  RTS

ApplyNoGravityBootsModifier:
  LDA $079F
  CMP #$0006 ; Ceres Station
  BEQ SpaceModifier
  ; Gravity * 8
  LDA $0B32
  ASL : ASL : ASL
  STA $0B32
  RTS
SpaceModifier:
  ; Gravity * 3/4
  LDA $0B32
  LSR
  STA $0B32
  LSR
  CLC
  ADC $0B32
  STA $0B32
  RTS
print pc

; --------------------------------------------------------------
; Item definition, referenced by the files in the PLMs directory.
org $89B440 ; graphics
PLM_Graphics:
  incbin ROMProject/Graphics/boots.gfx

org $84FD40
  ; item header: EE64 for a pickup
  DW $EE64,item_data

item_data:
  DW $8764,PLM_Graphics
    DB 3,3,3,3,3,3,3,3  ; make it blue
  DW $887C,end_plm ; if item has been picked up, delete PLM
  DW $8A2E,$DFAF ; chozo ball stuff (x2)
  DW $8A2E,$DFC7
  DW $8A24,pickup_plm ; save address of 'pickup triggered' PLM routine
  DW $86C1,$DF89 ; set pre-PLM instruction
  DW $874E       ; store $16 to 1D77,X (the 'variable use PLM value')
    DB $16         ; no idea why, but Chaos Arms did it, and taking it out crashes.

gfx_plm:
  DW $E04F       ; graphics/pickup stuff
  DW $E067       ; flashing animation
  DW $8724,gfx_plm ; use graphics stuff as next (frame's?) PLM instruction

pickup_plm:
  DW $8899       ; mark PLM as picked up
  DW $8BDD
    DB $02       ; play track 02 (item collect)
  DW GravityBootsCollect,$0000 ; item type + value (the latter unused)
    DB $22       ; msgbox identifier, I think $1D may be the first free msgbox?
  DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
  DW $86BC       ; done: delete PLM

; PLM arguments:
; Value (2 bytes), unused since the math is too hard for me yet
; Message box (1 byte)

GravityBootsCollect:
  LDA $09A4 ; collected items
  ORA #$0400 ; gravity boots
  STA $09A4

  LDA $09A2 ; load equipped items
  ORA #$0400 ; gravity boots
  STA $09A2

  LDA #$0168  ; frame delay for music/messagebox
  JSL $82E118 ; do music

  LDA $0002,Y ; grab message box arg
  AND #$00FF  ; convert to byte
  JSL $858080 ; display message box

  INY         ; advance past our args, to next instruction
  INY
  INY
  RTS         ; return to PLM loop

org $A7E999
  ADC $909EA1 ; ADC $000B32
org $A7E9A3 
  ADC #$0000 : NOP ; ADC $000B34

org $A7F810
  ADC $909EA1 ;ADC $000B32
org $A7F81A 
  ADC #$0000 : NOP ;ADC $000B34

org $A7F939
  ADC $909EA1 ;ADC $000B32
org $A7F945
  ADC #$0000 : NOP ;ADC $000B34