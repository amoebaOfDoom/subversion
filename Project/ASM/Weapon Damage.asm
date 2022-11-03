lorom

; Beam Damage = (30 + 10*beam_count)*(1 + (damage_amp / 0.5))

org $91DF61
	REP 5 : NOP ; CMP #$012C : BEQ $17 ; If samus takes 300 damage then do 0

org $938431
;;; $8431: Projectile data table ;;;
;         ________________________________________________________________ Damage
;        |      __________________________________________________________ Up, facing right
;        |     |      ____________________________________________________ Up-right
;        |     |     |      ______________________________________________ Right
;        |     |     |     |      ________________________________________ Down-right
;        |     |     |     |     |      __________________________________ Down, facing right
;        |     |     |     |     |     |      ____________________________ Down, facing left
;        |     |     |     |     |     |     |      ______________________ Down-left
;        |     |     |     |     |     |     |     |      ________________ Left
;        |     |     |     |     |     |     |     |     |      __________ Up-left
;        |     |     |     |     |     |     |     |     |     |      ____ Up, facing left
;        |     |     |     |     |     |     |     |     |     |     |
; Uncharged beams 
	DW #0030,$86DB,$86E7,$86F3,$86FF,$870B,$870B,$8717,$8723,$872F,$86DB ; Power
	DW #0040,$8977,$8993,$89AF,$89CB,$89E7,$89E7,$8A03,$8A1F,$8A3B,$8977 ; Spazer
	DW #0050,$8977,$8993,$89AF,$89CB,$89E7,$89E7,$8A03,$8A1F,$8A3B,$8977 ; Spazer + ice
	DW #0060,$8A57,$8AAB,$8AFF,$8B53,$8BA7,$8BA7,$8BFB,$8C4F,$8CA3,$8A57 ; Spazer + ice + wave
	DW #0060,$8D47,$8D93,$8DDF,$8E2B,$8D47,$8D47,$8D93,$8DDF,$8E2B,$8D47 ; Plasma + ice + wave
	DW #0040,$8953,$8953,$8953,$8953,$8953,$8953,$8953,$8953,$8953,$8953 ; Ice
	DW #0040,$873B,$87C7,$884B,$88CF,$8743,$8743,$87C7,$884B,$88CF,$873B ; Wave
	DW #0040,$8CF7,$8D0B,$8D1F,$8D33,$8CF7,$8CF7,$8D0B,$8D1F,$8D33,$8CF7 ; Plasma
	DW #0050,$873B,$87C7,$884B,$88CF,$8743,$8743,$87C7,$884B,$88CF,$873B ; Ice + wave
	DW #0050,$8A57,$8AAB,$8AFF,$8B53,$8BA7,$8BA7,$8BFB,$8C4F,$8CA3,$8A57 ; Spazer + wave
	DW #0050,$8D4F,$8D9B,$8DDF,$8E33,$8D4F,$8D4F,$8D9B,$8DDF,$8E33,$8D4F ; Plasma + wave
	DW #0050,$8CF7,$8D0B,$8D1F,$8D33,$8CF7,$8CF7,$8D0B,$8D1F,$8D33,$8CF7 ; Plasma + ice

; Charged beams
	DW #0090,$8E77,$8E8B,$8E9F,$8EB3,$8EC7,$8EC7,$8EDB,$8EEF,$8F03,$8E77 ; Power
	DW #0120,$936B,$93BF,$9413,$9467,$936B,$936B,$93BF,$9413,$9467,$936B ; Spazer
	DW #0150,$936B,$93BF,$9413,$9467,$936B,$936B,$93BF,$9413,$9467,$936B ; Spazer + ice
	DW #0180,$94BB,$957F,$9643,$9707,$97CB,$97CB,$988F,$9953,$9A17,$94BB ; Spazer + ice + wave
	DW #0180,$9BEB,$9C9F,$9D53,$9E07,$9BEB,$9BEB,$9C9F,$9D53,$9E07,$9BEB ; Plasma + ice + wave
	DW #0120,$912F,$912F,$912F,$912F,$912F,$912F,$912F,$912F,$912F,$912F ; Ice
	DW #0120,$9ADB,$9B1F,$9B63,$9BA7,$9ADB,$9ADB,$9B1F,$9B63,$9BA7,$9ADB ; Plasma
	DW #0120,$8F17,$8FA3,$9027,$90AB,$8F1F,$8F1F,$8FA3,$9027,$90AB,$8F17 ; Wave
	DW #0150,$9153,$91DF,$9263,$92E7,$915B,$915B,$91DF,$9263,$92E7,$9153 ; Ice + wave
	DW #0150,$94BB,$957F,$9643,$9707,$97CB,$97CB,$988F,$9953,$9A17,$94BB ; Spazer + wave
	DW #0150,$9ADB,$9B1F,$9B63,$9BA7,$9ADB,$9ADB,$9B1F,$9B63,$9BA7,$9ADB ; Plasma + ice
	DW #0150,$9BEB,$9C9F,$9D53,$9E07,$9BEB,$9BEB,$9C9F,$9D53,$9E07,$9BEB ; Plasma + wave

; Non-beam projectiles
	DW $0064,$9EBB,$9EC7,$9ED3,$9EDF,$9EEB,$9EEB,$9EF7,$9F03,$9F0F,$9EBB ; Missiles
	DW $012C,$9F1B,$9F27,$9F33,$9F3F,$9F4B,$9F4B,$9F57,$9F63,$9F6F,$9F1B ; Super missile
	DW $012C,$9F7B
	DW $00C8,$9F87 ; Power bomb
	DW $001E,$9FBF ; Bomb
	DW $0008,$A007 ; Dead beam
	DW $0008,$A039 ; Dead (super) missile
	DW $0000,$A06B
	DW $012C,$A095 ; Plasma SBA
	DW $012C,$A159 ; Wave SBA
	DW $012C,$8977
	DW $0008,$A0C1

	DW $F000,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3,$A0F3

	DW $012C,$A13D; Spazer SBA

	DW $A13D,$A13D,$A13D,$A13D,$A13D,$A13D,$A13D,$A13D,$A13D

	DW $1000,$A119; Shinespark echoes

	DW $A119,$A119,$A119,$A119,$A119,$A119,$A119,$A119,$A119,$0000,$A16D
