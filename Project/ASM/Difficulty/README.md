#Selectable difficulty levels for Super Metroid

##About

This patch adds three selectable difficulty levels that follow the same rules as the GBA Metroid games. You can select the difficulty level inside the Special Settings menu before you start a new game (it can't be changed mid-game).

In order to increase compatibility with other hacks, there was care not to change any existing routines or values. In most cases an instruction is hijacked and the formula is recalculated according to difficulty. Very rarely are other instructions overwritten, and should not cause conflicts. However, for obvious reasons, this does not guarantee compatibility with every hack.

##Changes made by this patch

* Edit the Special Settings screen in order to turn the Item Cancel menu into a difficulty selection menu.
* Edit the File Select screen in order to display the selected difficulty level next to its corresponding file.
* Disable the Item Cancel functionality from the game (who uses this anyway?).
* Recalculate how the energy and reserve is displayed on the HUD, Status Screen and File Select screens (may conflict with other UI patches).
* Super Missile and Power Bomb tanks are now worth 2 units instead of 5.
* The threshold to get the worst ending is now 6 hours instead of 10.
* **Save a new flag in SRAM that corresponds to the selected difficulty.** This can be used to write other hacks that tweak other parts of the game.
* **Automatically add event 0x0F when a new game is started with Hard difficulty.** This can be used to create new room states.
* Change gameplay according to the selected difficulty level:

###Normal
* Nothing changes.

###Easy
* Samus receives half damage from all enemies.
* The Ceres and Mother Brain countdown timers have 30 extra seconds.
* Always get the worst ending, regardless of time.

###Hard
* Samus receives double damage from all enemies.
* Samus deals 75% damage to all enemies.
* Samus receives half energy and ammo from enemy drops.
* Drop rates that would yield nothing are doubled. Enemies that always dropped something now have 4% chance to drop nothing.
* Energy, Reserve, Missile, Super Missile and Power Bomb expansions only grant half their original amount.
* The Ceres and Mother Brain countdown timers have 30 less seconds.
* Some rooms and enemies have minor alterations.

##Configuration

The patch has been broken into several files to allow the user to easily exclude specific behaviour. The downside is that new instructions are broken into several banks, taking (a little) free space from them.

It is encouraged to edit [main.asm](/main.asm) and its [subfiles](/asm/) if you intend to use this with your hack.

##Usage

Use [xkas](http://www.romhacking.net/utilities/269/ "Romhacking.net") to patch **main.asm** into an **unheadered** Super Metroid ROM.

This was tested on a ROM with the following characteristics:
```
CRC32: D63ED5F8
MD5: 21F3E98DF4780EE1C667B84E57D88675
SHA-1: DA957F0D63D14CB441D215462904C4FA8519C613
SHA-256: 12B77C4BC9C1832CEE8881244659065EE1D84C70C3D29E6EAF92E6798CC2CA72
```

If applying to a modified ROM, make sure to check each source file and change whatever pointers may conflict with other hacks.

The files under the [samples](/sample/) folder are provided as a proof of concept of what can be extended from this hack. They will most likely not work with anything but the vanilla ROM, so don't forget to comment them out accordingly.

##Screenshots

![File Select screen](/screens/fileselect.PNG?raw=true "File Select screen")
![Special Setting screen](/screens/specialsetting.PNG?raw=true "Special Setting screen")
![Sample room edit](/screens/room.PNG?raw=true "Sample room edit")
