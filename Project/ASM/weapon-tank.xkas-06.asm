; Copyright 2015 Adam <https://github.com/n00btube>
; MIT license (this file).

lorom

; --------------------------------------------------------------
; Most of our work here will be in bank $84, the PLM bank.
; This first routine is the code behind our new PLM instruction to handle
; the item pickup.  This address (F070) is just "somewhere in free space."
; Be careful adding code, not to overwrite the PLM data at F0A0...
; this code is 34 ($22) bytes, leaving 14 ($0E) more.
org $84F080
	; PLM arguments:
	; Value (2 bytes), unused since the math is too hard for me yet
	; Message box (1 byte)

tank_collect:
	LDA $09D8   ; load current number of tanks
	INC         ; add hardcoded "one tank"
	STA $09D8   ; save tank number

	;LDA #$0168  ; frame delay for music/messagebox
	;JSL $82E118 ; do music

	LDA $0002,Y ; grab message box arg
	AND #$00FF  ; convert to byte
	JSL $858080 ; display message box

	INY         ; advance past our args, to next instruction
	INY
	INY
	RTS         ; return to PLM loop


; --------------------------------------------------------------
; Item definition, referenced by the files in the PLMs directory.
org $84F0A0
	; item header: EE64 for a pickup
	DW $EE64,item_data

item_data:
	DW $8764,$9400 ; custom graphics: reserve tank
		DB 0,0,0,0,0,0,0,0  ; graphics palettes
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
;	DW $8BDD
;		DB $02       ; play track 02 (item collect)
	DW $8C07
		DB $2B
	DW tank_collect,$0000 ; item type + value (the latter unused)
		DB $1D       ; msgbox identifier, I think $1D may be the first free msgbox?
	DW $0001,$A2B5 ; schedule block redraw & graphics update after 1 frame delay

end_plm:
	DW $86BC       ; done: delete PLM



; --------------------------------------------------------------
; missile pickup (item drop) optimization
; as in, I didn't want it overwriting weapon tanks w/ reserve missiles,
; so I rewrote it entirely.  I made it smaller, so no free space used.
org $91DF80
	PHP        ; save flags
	PHB        ; save data bank
	PHK        ; set data bank to code bank ($91)
	PLB
	REP #$30   ; set 16-bit modes

	CLC        ; add pickup size (in A) to current value
	ADC $09C6
	STA $09C6
	CMP $09C8  ; check for overfill
	BMI missiles_done

	; originally, the reserve-missile code was in here.
	; but we just want to set current=max and get on our way.
	LDA $09C8
	STA $09C6

missiles_done:
	PLB        ; restore data bank
	PLP        ; restore flags
	RTL


; --------------------------------------------------------------
; damage calculation hijack point
; this is the obvious point: the LDA instruction that gets the base damage value.
; which is why this conflicts with other damage-modifying patches
org $93803C
	JSR damage_hijack

; routine for boosting the damage calculation
; movable anywhere in bank $93 free space.  79 ($4F) bytes in size.
org $93F620
damage_hijack:
	LDA $09D8     ; load number of weapon tanks
	AND #$000F    ; limit to (hopefully sane) maximum value: 15 tanks
	BNE do_tanks  ; skip calculations if no tanks

no_boost:
	LDA $0000,y   ; original damage value
	RTS

do_tanks:
; #################### OPTIONAL: AVOID BOOSTING BEAMS ####################
; Delete this section if you want beams to be boosted. (saves 14/$E bytes)
; Default is to only boost missiles/supers.
	LDA $0C18,X      ; get projectile type
	BIT #$0F00       ; check for beam type
	BNE no_boost     ; beam: disable boost
	LDA $09D8        ; reload our number of tanks ofter the beam check
	AND #$000F
; ######################### END OPTIONAL SECTION #########################

	PHX
	PHY
	; (32 + (n_tanks * per_tank_32nds)) * base_damage / 32 = effective_damage
	; BTW: 32 was chosen to give a good combo of precision and upper limit.
	; Both should be effectively insane, I hope.
	TAX           ; n_tanks
	LDA #$0020    ; 32 (1x Samus' original base damage) plus...
	CLC
nk_multiply:
; ########################## DAMAGE BOOST VALUE ##########################
	; The following ADC value is the damage per tank, in 32nds ($20ths).
	; Examples:
	; $0010: half of base damage per tank. 1x, 1.5x, 2x, 2.5x, ...
	; $0015: two-thirds, approx. 1x, 1.66x, 2.33x, 2.99x, ...
	; $0040: double. 1x, 3x, 5x, 7x, ...
	; But be careful not to overflow 7FFF (32767) damage total.
	ADC #$0010    ; per_tank value in 32nds
	DEX           ; used tank
	BNE nk_multiply ; loop until all tanks used

	TAX           ; temporary storage of damage multiplier
	LDA $0000,y   ; load base damage from pointer
	TXY           ; damage multiplier to parameter for multiplication
	JSL $8082D6   ; multiply A*Y -> 32-bits starting at $05F1
	LDX #$0005    ; number of shifts (5 == divide by 2^5 == 32)
div_shift:
	ROR $05F3     ; rotate a bit from hi to lo damage
	ROR $05F1
	DEX           ; bit shifted
	BNE div_shift ; loop until all bits shifted

	; first overflow check is just added safety, so that $12000 causes a crash,
	; even though $2000 is acceptable value for lo damage.
	LDA $05F3     ; load hi damage
	AND #$07FF    ; clear fractional bits that were rotated in
	BNE damage_overflow ; not zero: too much damage

	LDA $05F1     ; load lo damage
	BMI damage_overflow ; redundant check -> obvious crash point
	PLY
	PLX
	RTS

damage_overflow:
	JMP damage_overflow ; freeze here so failure is obvious in the debugger
