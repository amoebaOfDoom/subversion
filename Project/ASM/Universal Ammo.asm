lorom

!PLMSecondaryJump = $7FFC00 ; - 7FFC50

org $90BE91 : ; Super shot
	JSR SuperCheck
	BMI $E7
org $90BEC4 : 
	JSR SuperDecrement

org $90C028 : ; PB shoot
	JSR PBCheck
	BMI $7A
	NOP
	JSR PBDecrement


org $90CC21
; SBA ammo costs
	DW $0000 ; 0: Power
	DW $000A ; 1: Wave
	DW $000A ; 2: Ice
	DW $0000 ; 3: Ice + wave
	DW $000A ; 4: Spazer
	DW $0000 ; 5: Spazer + wave
	DW $0000 ; 6: Spazer + ice
	DW $0000 ; 7: Spazer + ice + wave
	DW $000A ; 8: Plasma
	DW $0000 ; 9: Plasma + wave
	DW $0000 ; Ah: Plasma + ice
	DW $0000 ; Bh: Plasma + ice + wave

org $90CCC0
FireSBA:
	LDA $09D2    ;\                 
	CMP #$0003   ;} If [HUD item index] != power bombs:                 
	BEQ FireSBA_Continue 
FireSBA_ReturnFail:
	CLC          ;\                 
	RTS          ;} Return clear carry                 

FireSBA_Continue:	                    
	LDA $09A6    ;\                 
	AND #$000F   ;|                 
	ASL A        ;} X = ([equipped beams] & Fh) * 2                 
	TAX          ;/                 
	LDA $09C6    
	SEC          
	SBC $CC21,x  ; Test if enough ammo
	BCC FireSBA_ReturnFail             
	NOP : NOP    	                    
	STA $09C6           
	JSR PBCheck  ; Test if enough ammo still after using it           
	BCS FireSBA_Execute
	STZ $09D2    ; HUD item index = nothing                
	STZ $0A04    ; Auto-cancel HUD item index = nothing 
FireSBA_Execute:
	JSR ($CCF0,X); Execute [$CCF0 + [X]]  
	RTS             
warnpc $90CCF0


org $90D5D5 : CMP #$005A ; Crystal flash min number of missiles
org $90D5DD : CMP #$0000 ; Crystal flash min number of supers
org $90D5E5 : CMP #$0000 ; Crystal flash min number of pb

org $90D64B : LDA #$005A ; number of times to drain

org $90D6CE :  
	; Crystal Flash table override
	JSR $D729
	STZ $18A8
	STZ $18AA
	RTS

PBCheck:
	LDA $09C6
	CMP #$000A
	RTS

PBDecrement:
	LDA $09C6
	SEC 
	SBC #$000A
	STA $09C6
	RTS

SuperCheck:
	LDA $09C6
	CMP #$0005
	RTS

SuperDecrement:
	LDA $09C6
	SEC
	SBC #$0005
	STA $09C6
	RTS
warnpc $90D729

; Crystal Flash Update
org $90D729 : 
	LDA $05B6
	BIT #$0003 ; speed
	BNE $29 
org $90D731 : 
	DEC $09C6 ; drain one ammo
	LDA #$0011 ; give health
	JSL $91DF12


org $A2AAB2 ; ship refill before save
  LDA #$0002
  JSL $91DF80
  NOP : NOP : NOP ;LDA #$0002
  NOP : NOP : NOP : NOP ;JSL $91DFD3
  NOP : NOP : NOP ;LDA #$0002
  NOP : NOP : NOP : NOP ;JSL $91DFF0
  NOP : NOP : NOP : NOP : NOP : NOP : NOP : NOP ; LDA $09D6 : CMP $09D4 : BMI $4F
  LDA $09C2 : CMP $09C4 : BMI $47
  LDA $09C6 : CMP $09C8 : BMI $3F
  NOP : NOP : NOP : NOP : NOP : NOP : NOP : NOP ;LDA $09CA : CMP $09CC : BMI $37
  NOP : NOP : NOP : NOP : NOP : NOP : NOP : NOP ;LDA $09CE : CMP $09D0 : BMI $2F
  BRA $27

org $A9C4F9 ; something to do with auto-cancel
  NOP : NOP : NOP ;LDA $09CA
  NOP : NOP ;BEQ $20    [$C51E]
  NOP ;SEC
  NOP : NOP : NOP ;SBC $C544
  NOP : NOP : NOP ;CMP #$0001
  NOP : NOP ;BPL $14    [$C51B]
  NOP : NOP : NOP ;LDA $09D2
  NOP : NOP : NOP ;CMP #$0002
  NOP : NOP ;BNE $06    [$C515]
  NOP : NOP : NOP ;LDA #$0000
  NOP : NOP : NOP ;STA $09D2
  NOP : NOP : NOP ;LDA #$0000
  NOP : NOP : NOP ;STA $0A04
  NOP : NOP : NOP ;STA $09CA


; Ammo pickup override
org $86F0E8 : 
	LDA #$0002 ; missile
org $86F0F7 : 
	LDA #$0005 ; super
	JSL $91DF80
org $86F0D9 : 
	LDA #$000A ; pb
	JSL $91DF80


org $8489A9 : 
MissileAdd:
	INC $09CE
	JSR AddAmmo
	JSL $8099CF	; Handed by new HUD
	LDA #$0002
	BRA FinishItemWithFanfare

SuperAdd:
	INC $09CC  
	JSR AddAmmo
	JSL $809A0E	; Handed by new HUD
	LDA #$0003
	BRA FinishItemWithFanfare

PBAdd:
	INC $09D0 
	JSR AddAmmo
	JSL $809A1E	; Handed by new HUD
	LDA #$0004
	BRA FinishItemWithFanfare

AmmoTankAdd:
	JSR AddAmmo
	LDA #$0000
	JSR add_room_arg
	CMP #$000A
	BPL BigTankMsg
SmallTankMsg:
	LDA #$001E
	BRA FinishItem
BigTankMsg:
	LDA #$001F
	BRA FinishItem

FinishItemWithFanfare:
	PHA
	LDA #$0168
	JSL $82E118
	PLA
FinishItem:
	JSL $858080
	INY
	INY
	RTS

lda_item_index:
	LDA $1DC7,X    ; hijacked instruction: room call arg
	AND #$80FF     ; zero out the pickup collection size
	RTS
warnpc $848A24

!HPAdd = $8968

; HIJACK POINTS -------------------------------------------
org $84887D
	JSR lda_item_index ; "pickup collected?" PLM, 887C

org $84889A
	JSR lda_item_index ; "collect pickup" PLM, 8899


org $86F1B1 : ; super ammo drop from missle count
	LDY $09C6
	CPY $09C8
org $86F1C8 : ; pb ammo drop from missle count
	LDY $09C6
	CPY $09C8



; New PLM Headers - Bank 84
org $84EED7 : DW $EE4D, EtankData
org $84EEDB : DW $EE52, MissileData
org $84EEDF : DW $EE57, SuperData
org $84EEE3 : DW $EE5C, PBData
org $84EF2B : DW $EE4D, ChozoEtankData
org $84EF2F : DW $EE52, ChozoMissileData
org $84EF33 : DW $EE57, ChozoSuperData
org $84EF37 : DW $EE5C, ChozoPBData
org $84EF7F : DW $EE77, HiddenEtankData
org $84EF83 : DW $EE7C, HiddenMissileData
org $84EF87 : DW $EE81, HiddenSuperData
org $84EF8B : DW $EE86, HiddenPBData

!etankamount = $64
!missilemount = $0A
!superamount = $0A
!pbamount = $0A
!ammoamount = $01
!ammobigamount = $02

org $84E099 : 

; Common Normal Item PLM Code
NormalItemPLM:
	DW $887C, PLMKill 			; test if item already collected
	DW $8A24, PLMItemGet		; set Get pointer 
	DW $86C1, $DF89 			; set pre-PLM pointer
PLMItemLoop:
	DW $E04F					; wait 4 frames and draw 1
	DW $E067					; wait 4 frames and draw 2
	DW $8724, PLMItemLoop		; Goto Loop
PLMItemGet:
	DW $8899					; set item collection bit
	;DW $8BDD 					; play sound
	;	DB $02					;     #2
	DW ExecuteSecondaryJump
	DW ExecuteSecondaryJump
	DW $0001,$A2B5 				; draw air
PLMKill:
	DW $86BC		 			; destroy PLM	

;Energy Tank (EED7 --> EE4D, E099)
EtankData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, EtankGFX 			; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, ETankTypePickup
	DW $8724, NormalItemPLM

;Missile (EEDB --> EE52, E0BE)
MissileData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, MissileGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, MissileTypePickup
	DW $8724, NormalItemPLM

;Super Missile (EEDF --> EE57, E0E3)
SuperData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, SuperGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, SuperTypePickup
	DW $8724, NormalItemPLM

;Power Bomb (EEE3 --> EE5C, E108)
PBData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, PBGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, PBTypePickup
	DW $8724, NormalItemPLM

warnpc $84E12D

; Header Execution Calls
SetSecondaryJump:
	LDA $0000,Y
	STA !PLMSecondaryJump,X
	INY
	INY
	RTS

org $84E44A: 
ExecuteSecondaryJump:
	PHY
	PHX
	LDA !PLMSecondaryJump,X
	TAY
	LDA $0000,Y
	STA $12
	INY
	INY
	PEA.w ExecuteSecondaryJumpDone-1
	JMP ($0012)
ExecuteSecondaryJumpDone:
	; Function Call did not PLA
	TYA
	PLX
	PLY
	STA !PLMSecondaryJump,X
	RTS

; Common Chozo Item code
ChozoItemPLM:
	DW $887C, PLMKill 			; test if item already collected
	DW $8A2E, $DFAF 			; chozo ball loop
	DW $8A2E, $DFC7 			; chozo ball final
	DW $874E 					; set respawn counter
		DB $16         			;     $16 * 8 frames
	DW $86C1, $DF89 			; set pre-PLM pointer
	DW $8A24, PLMItemGet		; set Get pointer 
	DW $8724, PLMItemLoop

; Chozo Ball Energy Tank (EF2B --> EE4D, E44A)
ChozoEtankData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, EtankGFX 			; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, ETankTypePickup
	DW $8724, ChozoItemPLM

; Chozo Ball Missile (EF2F --> EE52, E47C)
ChozoMissileData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, MissileGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, MissileTypePickup
	DW $8724, ChozoItemPLM

; Chozo Ball Super Missile (EF33 --> EE57, E4AE)
ChozoSuperData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, SuperGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, SuperTypePickup
	DW $8724, ChozoItemPLM

; Chozo Ball Power Bombs (EF37 --> EE5C, E4E0)
ChozoPBData:
	DW $887C, PLMKill 			; test if item already collected
	DW $8764, PBGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, PBTypePickup
	DW $8724, ChozoItemPLM


AddAmmo:
	LDA $09C8  
	CLC
	JSR add_room_arg
	STA $09C8  
	LDA $09C6  
	CLC
	JSR add_room_arg
	STA $09C6  
	RTS

add_room_arg:
	STA $12         ; save value we're going to add to
	LDA $1DC7,X     ; get room call arg
	AND #$7F00      ; zero out returning bit & item index
	BEQ add_plm_arg ; not set: use PLM arg instead
	XBA             ; move pickup size to the bottom of A
final_add:
	CLC
	ADC $12         ; add original value to increase amount
	RTS
add_plm_arg:
	LDA $0000,Y     ; get PLM arg value
	BRA final_add   ; and add that
warnpc $84E512


org $84E911 : 
; Common Hidden Item Code
HiddenItemPLM:
	DW $86C1, $DFE6				; Set Wait for shot pre-PLM
	DW $86B4 					; Wait
	DW $86C1, $DF89 			; set pre-PLM pointer
	DW $874E 					; set respawn counter
		DB $16         			;     $16 * 8 frames
	DW $887C, HiddenItemEnd 	; test if item already collected
	DW $8A24, HiddenItemGet 	; set Get pointer 
HiddenItemDraw:
	DW $E04F					; wait 4 frames and draw 1
	DW $E067					; wait 4 frames and draw 2
	DW $873F, HiddenItemDraw	; Decrement counter and Loop
	DW $8A2E, $E020				; Respawn block
	DW $8724, HiddenItemPLM		; Restart PLM
HiddenItemGet:
	DW $8899					; set item collection bit
	;DW $8BDD 					; play sound
	;	DB $02					;     #2
	DW ExecuteSecondaryJump
	DW ExecuteSecondaryJump
	;DW $0001,$A2B5 				; draw air
HiddenItemEnd:
	DW $8A2E, $E032 			; wait and then respawn block
	DW $8724, HiddenItemPLM		; Restart PLM

; Hidden Shotblock Energy Tank (EF7F --> EE77, E911)
HiddenEtankData:
	DW $887C, #HiddenEtankData+4 ; does nothing, but is used for SMART detecting item plms
	DW $8764, EtankGFX 			; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, ETankTypePickup
	DW $8724, HiddenItemPLM

; Hidden Shotblock Missile (EF83 --> EE7C, E949)
HiddenMissileData:
	DW $887C, #HiddenMissileData+4 ; does nothing, but is used for SMART detecting item plms
	DW $8764, MissileGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, MissileTypePickup
	DW $8724, HiddenItemPLM

; Hidden Shotblock Super Missile (EF87 --> EE81, E981)
HiddenSuperData:
	DW $887C, #HiddenSuperData+4 ; does nothing, but is used for SMART detecting item plms
	DW $8764, SuperGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, SuperTypePickup
	DW $8724, HiddenItemPLM

; Hidden Shotblock Power Bomb (EF8B --> EE86, E9B9)
HiddenPBData:
	DW $887C, #HiddenPBData+4 ; does nothing, but is used for SMART detecting item plms
	DW $8764, PBGFX 		; set graphics
		DB 0,0,0,0,0,0,0,0 		;     graphics palettes
	DW SetSecondaryJump, PBTypePickup
	DW $8724, HiddenItemPLM

; Item Type Code
ETankTypePickup:
	DW $8C07
		DB $2B
	DW !HPAdd, !etankamount		; hp add pointer, amount arg
MissileTypePickup:
	DW $8BDD
		DB $02
	DW MissileAdd, !missilemount; missile update pointer, amount arg
SuperTypePickup:
	DW $8BDD
		DB $02
	DW SuperAdd, !superamount	; super update pointer, amount arg
PBTypePickup:
	DW $8BDD
		DB $02
	DW PBAdd, !pbamount			; pb update pointer, amount arg
AmmoTypePickup:
	DW $8C07
		DB $2B
	DW AmmoTankAdd, !ammoamount	; missile update pointer, amount arg

warnpc $84E9F1


org $84F900 : 
; New PLM data - Bank 84
DW $EE52, AmmoData
DW $EE52, ChozoAmmoData
DW $EE7C, HiddenAmmoData

SetAmmoGFX:
	LDA $1DC7,X     			; get room call arg
	AND #$7F00      			; zero out returning bit & item index
	CMP #$0A00					
	BMI SetAmmoGFXSmall			; Draw small if amount < d10
	TYA
	CLC
	ADC #$000A					
	TAY							; skip first arguments
	JSR $8764					; load GFX
	RTS							; return
SetAmmoGFXSmall:
	JSR $8764
	TYA
	CLC
	ADC #$000A					; skip second arguments
	TAY							; load GFX
	RTS							; return


AmmoData:
	DW $887C, PLMKill		 	; test if item already collected
	DW SetAmmoGFX 				; set GFX
		DW AmmoSmallGFX 		; small GFX
		DB 1,1,1,1,1,1,1,1 		; small palette
		DW AmmoBigGFX 			; big GFX
		DB 1,1,1,1,1,1,1,1  	; big palette
	DW SetSecondaryJump, AmmoTypePickup
	DW $8724, NormalItemPLM

; Chozo Ball Ammo 
ChozoAmmoData:
	DW $887C, PLMKill		 	; test if item already collected
	DW SetAmmoGFX 				; set GFX
		DW AmmoSmallGFX 		; small GFX
		DB 1,1,1,1,1,1,1,1 		; small palette
		DW AmmoBigGFX 			; big GFX
		DB 1,1,1,1,1,1,1,1  	; big palette
	DW SetSecondaryJump, AmmoTypePickup
	DW $8724, ChozoItemPLM

; Hidden Shotblock Ammo
HiddenAmmoData:
	DW $887C, #HiddenAmmoData+4 ; does nothing, but is used for SMART detecting item plms
	DW SetAmmoGFX 				; set GFX
		DW AmmoSmallGFX 		; small GFX
		DB 1,1,1,1,1,1,1,1 		; small palette
		DW AmmoBigGFX 			; big GFX
		DB 1,1,1,1,1,1,1,1  	; big palette
	DW SetSecondaryJump, AmmoTypePickup
	DW $8724, HiddenItemPLM


AddHP:
	CMP.w #1299 ; 12 etanks
	CLC
	BPL +
	ADC.w #100
	RTS
+
	ADC.w #50
	RTS

org $84896C
	JSR AddHP

; New GFX - Bank 89

org $899100 : 
EtankGFX:
	DB $3F, $3F, $50, $7F, $90, $FC, $3D, $D1, $1D, $91, $10, $90, $11, $91, $7D, $91, $30, $00, $70, $00, $F3, $03, $F3, $03, $F3, $03, $FF, $6F, $FF, $03, $F3, $03, $FC, $FC, $0A, $FE, $29, $3F, $FC, $EB, $18, $E9, $48, $49, $E8, $C9, $1E, $E9, $0C, $00, $0E, $00, $EF, $E0, $EF, $E0, $0F, $00, $FF, $D6, $FF, $C0, $0F, $00, $3C, $D0, $93, $FF, $5F, $7F, $3F, $3F, $0C, $0C, $08, $04, $66, $78, $66, $78, $F3, $03, $F3, $03, $70, $10, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $3C, $2B, $E9, $FF, $FA, $FE, $FC, $FC, $30, $30, $20, $10, $66, $1E, $66, $1E, $EF, $E0, $EF, $E0, $0E, $08, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80, $3F, $3F, $50, $7F, $90, $FF, $3D, $D3, $1D, $93, $10, $93, $11, $93, $7D, $93, $30, $00, $70, $00, $F0, $00, $F1, $01, $F1, $01, $FC, $6C, $FD, $01, $F1, $01, $FC, $FC, $0A, $FE, $29, $FF, $FC, $EB, $18, $E9, $48, $C9, $E8, $C9, $1E, $E9, $0C, $00, $0E, $00, $2F, $20, $EF, $E0, $0F, $00, $7F, $56, $FF, $C0, $0F, $00, $3C, $D3, $93, $FF, $5F, $7F, $3F, $3F, $0C, $0C, $08, $04, $64, $78, $64, $78, $F0, $00, $F3, $03, $70, $10, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $3C, $EB, $E9, $FF, $FA, $FE, $FC, $FC, $30, $30, $20, $10, $26, $1E, $26, $1E, $2F, $20, $EF, $E0, $0E, $08, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80

org $899200 : 
MissileGFX:
	DB $04, $04, $13, $13, $2D, $2D, $13, $12, $56, $54, $27, $24, $25, $26, $26, $24, $07, $00, $1F, $00, $3D, $00, $32, $01, $75, $03, $64, $03, $64, $00, $67, $01, $E0, $20, $F8, $C8, $BC, $B4, $CC, $48, $EE, $2A, $E6, $24, $26, $E4, $E6, $A4, $E0, $00, $F8, $00, $BC, $00, $4C, $80, $2E, $C0, $26, $C0, $26, $00, $E6, $00, $26, $27, $24, $26, $24, $26, $26, $27, $22, $24, $3A, $34, $7C, $3F, $1C, $60, $67, $00, $67, $01, $67, $01, $6F, $08, $6F, $01, $7F, $01, $7F, $00, $7F, $00, $66, $E4, $A6, $64, $A6, $64, $66, $E4, $96, $E4, $BE, $CC, $3C, $FE, $38, $06, $E6, $00, $E6, $00, $E6, $00, $F6, $00, $F6, $00, $FE, $00, $FE, $00, $FE, $00, $04, $04, $13, $13, $2D, $2D, $13, $12, $56, $54, $27, $24, $25, $26, $24, $24, $07, $03, $1F, $0C, $3D, $10, $32, $21, $75, $23, $64, $43, $64, $40, $67, $41, $20, $20, $C8, $C8, $B4, $B4, $C8, $48, $EA, $2A, $E4, $24, $24, $E4, $A4, $A4, $E0, $00, $F8, $00, $BC, $00, $4C, $80, $2E, $C0, $26, $C0, $26, $00, $E6, $00, $27, $26, $26, $24, $26, $24, $26, $27, $24, $20, $34, $30, $3F, $3C, $70, $00, $67, $40, $67, $41, $67, $41, $6F, $48, $6F, $49, $7F, $41, $7F, $00, $7F, $00, $E4, $64, $64, $24, $64, $24, $64, $E4, $E4, $84, $CC, $8C, $FE, $3C, $0E, $00, $E6, $00, $E6, $00, $E6, $00, $F6, $10, $F6, $00, $FE, $00, $FE, $00, $FE, $00

org $899300 : 
SuperGFX:
	DB $18, $18, $27, $27, $5C, $5C, $50, $50, $27, $27, $2A, $2C, $2F, $2F, $32, $34, $1F, $00, $3F, $00, $7C, $03, $71, $07, $67, $00, $6F, $00, $6F, $00, $7F, $00, $FC, $1C, $FE, $E6, $1E, $1A, $0E, $0A, $E6, $E4, $56, $34, $F6, $F4, $4E, $2C, $FC, $00, $FE, $00, $1E, $C0, $8E, $E0, $E6, $00, $F6, $80, $F6, $00, $FE, $80, $32, $34, $29, $2E, $27, $27, $24, $26, $27, $27, $A7, $A4, $FF, $BF, $9C, $E0, $7F, $08, $6F, $00, $67, $00, $67, $00, $67, $00, $E7, $00, $FF, $00, $FF, $00, $4E, $2C, $96, $74, $E6, $E4, $26, $64, $E6, $E4, $27, $65, $FD, $FF, $39, $07, $FE, $90, $F6, $00, $E6, $00, $E6, $80, $E6, $00, $E7, $00, $FF, $00, $FF, $00, $18, $18, $27, $27, $58, $58, $50, $50, $27, $27, $2C, $28, $2F, $2F, $34, $30, $1F, $07, $3F, $18, $78, $23, $71, $27, $67, $40, $6F, $40, $6F, $40, $7F, $48, $18, $18, $E4, $E4, $1A, $1A, $0A, $0A, $E4, $E4, $34, $14, $F4, $F4, $2C, $0C, $F8, $00, $FC, $00, $1E, $C0, $8E, $E0, $E6, $00, $F6, $80, $F6, $00, $FE, $90, $34, $30, $2E, $28, $27, $27, $26, $24, $27, $27, $26, $24, $FF, $FF, $E0, $80, $7F, $48, $6F, $40, $67, $40, $67, $40, $67, $00, $67, $00, $FF, $00, $FF, $03, $2C, $0C, $74, $14, $E4, $E4, $64, $24, $E4, $E4, $64, $24, $FF, $FF, $07, $01, $FE, $90, $F6, $00, $E6, $00, $E6, $80, $E6, $00, $E6, $80, $FF, $00, $FF, $C0

org $899500 : 
PBGFX:
	DB $00, $00, $03, $03, $0F, $0E, $1F, $1F, $3E, $32, $27, $33, $26, $32, $3F, $33, $00, $00, $03, $00, $0E, $00, $13, $00, $23, $01, $2B, $08, $2B, $09, $23, $00, $00, $00, $C0, $C0, $F0, $70, $F8, $F8, $7C, $4C, $EC, $C4, $6C, $44, $FC, $CC, $00, $00, $C0, $00, $70, $00, $C8, $00, $C4, $80, $D4, $10, $D4, $90, $C4, $00, $3F, $3E, $3F, $37, $3F, $3A, $1F, $1F, $0F, $0E, $1F, $0F, $6F, $73, $48, $70, $3A, $00, $27, $00, $3A, $00, $13, $00, $0E, $00, $1F, $0E, $7F, $01, $7F, $01, $FC, $7C, $FC, $EC, $FC, $5C, $F8, $F8, $F0, $70, $F8, $F0, $F6, $CE, $12, $0E, $5C, $00, $E4, $00, $5C, $00, $C8, $00, $70, $00, $F8, $70, $FE, $80, $FE, $80, $00, $00, $03, $03, $0E, $0F, $13, $1F, $32, $3F, $23, $3F, $22, $3F, $33, $3F, $00, $00, $02, $02, $02, $02, $02, $02, $00, $00, $00, $00, $00, $00, $20, $20, $00, $00, $C0, $C0, $70, $F0, $C8, $F8, $4C, $FC, $C4, $FC, $44, $FC, $CC, $FC, $00, $00, $40, $40, $40, $40, $40, $40, $00, $00, $00, $00, $00, $00, $00, $00, $3E, $3F, $27, $3F, $32, $3F, $13, $1F, $0E, $0F, $0F, $0F, $63, $73, $40, $70, $10, $10, $00, $00, $00, $00, $02, $02, $02, $02, $1E, $0E, $7F, $01, $7F, $01, $7C, $FC, $E4, $FC, $4C, $FC, $C8, $F8, $70, $F0, $F0, $F0, $C6, $CE, $02, $0E, $08, $08, $00, $00, $00, $00, $40, $40, $40, $40, $78, $70, $FE, $80, $FE, $80

org $899600 : 
AmmoBigGFX:
	DB $3F, $3F, $50, $7F, $90, $FC, $3B, $D3, $1B, $92, $10, $90, $13, $93, $7B, $92, $30, $00, $70, $00, $F3, $03, $F7, $07, $F6, $06, $FF, $6F, $FF, $07, $F6, $06, $FC, $FC, $0A, $FE, $49, $7F, $BC, $AB, $B8, $29, $28, $29, $A8, $A9, $BE, $29, $0C, $00, $0E, $00, $CF, $C0, $EF, $E0, $6F, $60, $FF, $F6, $FF, $E0, $6F, $60, $3B, $D2, $96, $FF, $5F, $7F, $3F, $3F, $0C, $0C, $08, $04, $66, $78, $66, $78, $F6, $06, $F6, $06, $70, $10, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $BC, $2B, $69, $FF, $FA, $FE, $FC, $FC, $30, $30, $20, $10, $66, $1E, $66, $1E, $6F, $60, $6F, $60, $0E, $08, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80, $3F, $3F, $50, $7F, $90, $FF, $3B, $D7, $1B, $96, $10, $97, $13, $97, $7B, $96, $30, $00, $70, $00, $F0, $00, $F3, $03, $F2, $02, $F8, $68, $FB, $03, $F2, $02, $FC, $FC, $0A, $FE, $49, $FF, $BC, $EB, $B8, $69, $28, $E9, $A8, $E9, $BE, $69, $0C, $00, $0E, $00, $4F, $40, $AF, $A0, $2F, $20, $3F, $36, $BF, $A0, $2F, $20, $3B, $D6, $96, $FF, $5F, $7F, $3F, $3F, $0C, $0C, $08, $04, $66, $78, $66, $78, $F2, $02, $F6, $06, $70, $10, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $BC, $6B, $69, $FF, $FA, $FE, $FC, $FC, $30, $30, $20, $10, $66, $1E, $66, $1E, $2F, $20, $6F, $60, $0E, $08, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80

org $899700 : 
AmmoSmallGFX:
	DB $3F, $3F, $40, $7F, $80, $FC, $3B, $DB, $1B, $92, $10, $90, $13, $93, $7B, $92, $3F, $00, $7F, $00, $FF, $03, $FF, $07, $F6, $06, $FF, $6F, $FF, $07, $F6, $06, $FC, $FC, $02, $FE, $41, $7F, $BC, $BB, $B8, $29, $28, $29, $A8, $A9, $BE, $29, $FC, $00, $FE, $00, $FF, $C0, $FF, $E0, $6F, $60, $FF, $F6, $FF, $E0, $6F, $60, $3B, $DB, $86, $FF, $40, $7F, $3F, $3F, $0C, $0C, $08, $04, $66, $78, $66, $78, $FF, $06, $FF, $06, $7F, $00, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $BC, $BB, $61, $FF, $02, $FE, $FC, $FC, $30, $30, $20, $10, $66, $1E, $66, $1E, $FF, $60, $FF, $60, $FE, $00, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80, $3F, $3F, $40, $7F, $80, $FF, $3B, $DF, $1B, $96, $10, $97, $13, $97, $7B, $96, $3F, $00, $7F, $00, $FC, $00, $FB, $03, $F2, $02, $F8, $68, $FB, $03, $F2, $02, $FC, $FC, $02, $FE, $41, $FF, $BC, $FB, $B8, $69, $28, $E9, $A8, $E9, $BE, $69, $FC, $00, $FE, $00, $7F, $40, $BF, $A0, $2F, $20, $3F, $36, $BF, $A0, $2F, $20, $3B, $DF, $86, $FF, $40, $7F, $3F, $3F, $0C, $0C, $08, $04, $66, $78, $66, $78, $FB, $02, $FF, $06, $7F, $00, $3F, $00, $0C, $00, $0C, $00, $7F, $01, $7F, $01, $BC, $FB, $61, $FF, $02, $FE, $FC, $FC, $30, $30, $20, $10, $66, $1E, $66, $1E, $BF, $20, $FF, $60, $FE, $00, $FC, $00, $30, $00, $30, $00, $FE, $80, $FE, $80


org $8DBF14
SuperDropFrame1:
DW $0004
	DW $01FB : DB $F8 : DW $3A59
	DW $01FB : DB $00 : DW $3A5A
	DW $01FF : DB $F6 : DW $3A59
	DW $01FF : DB $FE : DW $3A5A
SuperDropFrame2:
DW $0004
	DW $01FB : DB $F8 : DW $3059
	DW $01FB : DB $00 : DW $305A
	DW $01FF : DB $F6 : DW $3059
	DW $01FF : DB $FE : DW $305A

PBDropFrame1:
DW $0006
	DW $01FD : DB $F5 : DW $3A59
	DW $01FD : DB $FD : DW $3A5A
	DW $01FA : DB $F9 : DW $3A59
	DW $01FA : DB $01 : DW $3A5A
	DW $0000 : DB $F9 : DW $3A59
	DW $0000 : DB $01 : DW $3A5A
PBDropFrame2:
DW $0006
	DW $01FD : DB $F5 : DW $3059
	DW $01FD : DB $FD : DW $305A
	DW $01FA : DB $F9 : DW $3059
	DW $01FA : DB $01 : DW $305A
	DW $0000 : DB $F9 : DW $3059
	DW $0000 : DB $01 : DW $305A
warnpc $8DC064

;;; $EDEB: Instruction list - pickup - power bombs ;;;
org $86EDEB
PBDropInstList:
	DW $0005, #PBDropFrame1
	DW $0005, #PBDropFrame2
	DW $81AB, #PBDropInstList ; go to
	DW $8159 ; Sleep

;;; $EDDD: Instruction list - pickup - super missiles ;;;
org $86EDDD
SuperDropInstList:
	DW $0005, #SuperDropFrame1
	DW $0005, #SuperDropFrame2
	DW $81AB, #SuperDropInstList ; go to
	DW $8159 ; Sleep
