lorom

!hyper_active = $7FFD72

org $90BD3B
	NOP : NOP : NOP
	NOP : NOP : NOP
	; LDA #$8014
	; STA $0B18

org $90B9B4 : JSR CheckOvercharge ;JSR $BA56

org $90B88F
	JSR CheckCanFire_Hyper ; JSR $AC39

;;; $EF5E: Unused. Fire unknown projectile 8027h ;;;
org $90EF5E
CheckCanFire_Hyper:
	JSL CheckActiveHyper
	BCC +
	CLC
	RTS
+
	JMP $AC39

CheckOvercharge:
	; REPLACE CHECK WITH NEW ITEM
  	LDA $09A6 ; equipped beams
  	BIT #$2000 ; overcharge
  	BEQ +
  	PLA
  	PEA.w $BCEE-1 
 +
  	JSR $BA56 ; displaced
	RTS	
warnpc $90EFD3

org $90BD5C
	;LDA #$8000
	;STA $0CD0 
	JSL FireHyper
	NOP : NOP

org $90B159
	JSL HyperbeamMain
    RTS
WaveBeamMovement:
	PHB : PHK : PLB : PHX
	JSR $B103 ; move projectile (wave)
	PLX : PLB
	RTL
print pc
warnpc $90B16B

org $91D7C3
DrawSamusHyperGlow_Continue:
org $91D7D0
	JSR ResetSamusHyperGlow
	BRA DrawSamusHyperGlow_Continue
	; STZ $0B18
	; SEC
	; RTS

org $91FFEE
ResetSamusHyperGlow:
	LDA #$8014
	STA $0B18
	AND #$001E
	RTS

org $80D800
CheckActiveHyper:
; BRANCH_FIRE
	LDA !hyper_active
	BEQ .not_found

	LDX #$0008    ; X = 0 (projectile index)
-
	LDA $0C2C,x  ;\
	CMP.w #1000
	BPL .found
	DEX : DEX
	BPL -
	LDA #$0000
	STA !hyper_active

    LDA $0998
    CMP #$0027 ; check demo state
    BMI +
	JSL $90AC8D ; reload graphics
+

.not_found
	CLC : RTL
.found
	SEC : RTL

FireHyper:
	LDA $09A6
	PHA
	LDA #$0008
	STA $09A6	
	JSL $90AC8D ; reload graphics
	PLA
	STA $09A6

	LDA #$0001
	STA !hyper_active

	LDA #$8000
	STA $0CD0 

	LDA $0A76
	BNE +
	LDA #$0004
	STA $0B18 
	LDA #$0000
	STA $0CD0 
+

	;displaced code
	LDA #$000A
	STA $18AC
	RTL


HyperbeamMain:
	PHB : PHK : PLB

	LDA $0C04,x
	AND #$00F0
	BEQ .paletteGlow
.dead
	JSL $90ADB7 ; delete proj
.dead_reload
	JSL CheckActiveHyper
	BCS +
	JSL $90AC8D ; reload graphics
+
	PLB : SEC
	RTL

.paletteGlow
	JSL WaveBeamMovement ; move projectile (wave)
	BCS .dead_reload ; moved off screen

	LDA $0C7C,X
	BIT #$0001             ;} If [charged shot glow timer] & 1 = 0:
	BNE .return
	AND #$001E             ;\

	TAY

	LDA #$8D00 ; palette bank
	STA $01

	LDA.w HyperPalettes,Y
	BNE +
	; reset cycle
	LDY #$0000
	STZ $0C7C,X
	LDA.w HyperPalettes,Y
+
	DEC : DEC
	STA $00 ; palette pointer
	PHX
	JSL $97EBF4 ; reload beam palette from ThermalVisor.asm
	PLX

.return
	INC $0C7C,X
	PLB : CLC
	RTL

HyperPalettes:
	DW $D906, $D91A, $D92E, $D942, $D956, $D96A, $D97E, $D992
	DW $D9A6, $D9BA, $0000, $0000, $0000, $0000, $0000, $0000




; Item definition, referenced by the files in the PLMs directory.
org $84F780
	; item header: EE64 for a pickup
	DW $EE64,item_data

item_data:
	DW $8764,PLM_Graphics ; custom graphics: reserve tank
		DB 0,0,0,0,1,1,1,1  ; graphics palettes
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
	DW $8C07
		DB $2B
	DW $88B0,$2000 ; collect beam : value 
		DB $3A       ; msgbox identifier, I think $1D may be the first free msgbox?
	DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
	DW $86BC       ; done: delete PLM

org $89B140 ; graphics
;org $89B000 ; graphics
PLM_Graphics:
	incbin ROMProject/Graphics/overcharge.gfx
