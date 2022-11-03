LoRom

!DifficultyAddress = $7ED827 ;sram that stores difficulty used by game.
!DifficultyAddressIndex = $7FFE00 ;sram that stores difficulty used by game.
!DifficultyUnlockAddress = $7FFF00 ;sram that stores if hard mode is unlocked

!TempAddress = $7ED452 ;ram where some temporary values are stored.
!HardEventFlag = #$0038 ;event flag that indicates hard mode is activated.
;!EnergyPerTankAddress = $84E0B8 ;amount of energy given by an e-tank.
;!StartingEnergyAddress = $81B2CE ;amount of energy samus has when starting a new game.

{; Basic functionality, required by other files. =================
;incsrc ROMProject/ASM/Difficulty/asm/80-84-8B-core.asm
}

{; Scale values according to difficulty. =================
;incsrc ROMProject/ASM/Difficulty/asm/A0-armor-damage.asm
;incsrc ROMProject/ASM/Difficulty/asm/86-drop-refill.asm
;incsrc ROMProject/ASM/Difficulty/asm/84-expansion.asm
;incsrc ROMProject/ASM/Difficulty/asm/8B-ending-calculation.asm
incsrc ROMProject/ASM/Difficulty/asm/80-countdown-timer.asm
}

{; UI tweaks, these probably have more chance of conflict. =================
;incsrc ROMProject/ASM/Difficulty/asm/80-ui-hud.asm
incsrc ROMProject/ASM/Difficulty/asm/81-ui-file-select.asm
;incsrc ROMProject/ASM/Difficulty/asm/82-ui-status-screen.asm
incsrc ROMProject/ASM/Difficulty/asm/82-97-ui-settings-tilemaps.asm
}

{; Sample edits. Changes are too numerous, so it's only safe to apply on vanilla ROM. =================
;incsrc ROMProject/ASM/Difficulty/asm/sample/vanilla-adjustments.asm
;incsrc ROMProject/ASM/Difficulty/asm/sample/enemy-behavior.asm
;incsrc ROMProject/ASM/Difficulty/asm/sample/rooms.asm
}