namespace "mission_"

!cR = $82
!cB = $83
!cG = $84
!cO = $85
!cP = $86
!cW = $87

; Description text to display for category.
; See text format description below
Description:
     ;-----------------; box width
  DB !cB,"  MISSION DATA   ",!cW,$0A
  DB "-----------------",$0A
  DB "HINT INFORMATION ON WHERE MISSION PROGRESS MIGHT BE FOUND.",$0A
  DB $0A
  DB !cP,"PRESS A TO SELECT",!cW,$00

; List of entries, null terminated
Entries:
  DW Entry_HINT_OCEAN
  DW Entry_HINT_CAVE1
  DW Entry_HINT_CAVE2
  DW Entry_HINT_LAB
  DW Entry_HINT_DEPTH1
  DW Entry_HINT_CAVE3
  DW Entry_HINT_LOMYR
  DW Entry_HINT_NOROK
  DW Entry_HINT_RIDLEY
  DW Entry_HINT_DEPTH2
  DW Entry_HINT_DEPTH3
  DW Entry_HINT_DAPHNE
  DW $0000

; EntryFormat:
;    DW .Name, .Text, .Sprite
;.Name
;       The entry label to be displayed in the list.
;       Format same as Text, but should be one line.
;.Text
;       Text to be displayed as in the main text box.
;       Format is null terminated ASCII, with a few special escape codes.
;
;       Escape Codes:
;         0x00      - Terminate Text
;         0x01 XXXX - If event XXXX is set then continue, otherwise terminate
;         0x0A      - New Line
;         0xFF XXXX - Draw Tile XXXX
;         0x8X      - Change color to palette X
;                        2 = Red
;                        3 = Blue
;                        4 = Green
;                        5 = Orange
;                        6 = Purple
;                        7 = Grey (default)
;.Sprite
;    This section can be skipped with a 0000 value.
;
;    Long pointer to graphics (0x400 bytes, 64 tiles)
;    Long pointer to palette  (0x40 bytes, 2 palette lines)
;    Long pointer to OAM data (palette 1)
;      Byte X position
;      Byte Y position
;    Long pointer to OAM data (palette 2) [optional]
;      Byte X position
;      Byte Y position
;    0000

Entry_HINT_CAVE1:
  DW .Name, .Text, $0000, $01E2
.Name
  DB "TIGHT SPACES",$00
.Text
  DB "IN THE EAST OF THE VULNAR CAVERNS, THERE IS A FLOODED ROOM THAT NEEDS SOME ABILITIES THAT CAN BE USED IN TIGHT PLACES."
  DB $0A,$0A,!cB
  DB $01 : DW $01E2
  DB !cB,"WAS ABLE TO PROGRESS USING BOMBS AND SPEEDBALL."
  DB $02 : DW $01E2
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_OCEAN:
  DW .Name, .Text, $0000, $01E1
.Name
  DB "WATER",$00
.Text
  DB "IN THE OCEAN THERE ARE SOME PLACES THAT REQUIRE MOBILITY IN WATER."
  DB $0A,$0A,!cB
  DB $01 : DW $01E1
  DB !cB,"WAS ABLE TO PROGRESS USING GRAVITY SUIT."
  DB $02 : DW $01E1
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_CAVE2:
  DW .Name, .Text, $0000, $01E3
.Name
  DB "INVISIBLE",$00
.Text
  DB "IN THE EAST OF THE VULNAR CAVERNS, THERE IS A DIM ROOM THAT HAD SOME INVISIBLE OBSTACLES."
  DB $0A,$0A,!cB
  DB $01 : DW $01E3
  DB !cB,"WAS ABLE TO PROGRESS USING DARK VISOR."
  DB $02 : DW $01E3
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_CAVE3:
  DW .Name, .Text, $0000, $01E6
.Name
  DB "WEAPONS",$00
.Text
  DB "IN THE EAST OF THE DARK CAVERNS, THERE IS A PATH THAT REQUIRES NEW WEAPONS."
  DB $0A,$0A,!cB
  DB $01 : DW $01E6
  DB !cB,"WAS ABLE TO PROGRESS USING SUPER MISSILES AND WAVE BEAM."
  DB $02 : DW $01E6
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_LOMYR:
  DW .Name, .Text, $0000, $01E7
.Name
  DB "SPEED",$00
.Text
  DB "ABOVE THE PIRATE LAB, THERE IS A BLOCKADE THAT REQUIRES MORE SPEED."
  DB $0A,$0A,!cB
  DB $01 : DW $01E7
  DB !cB,"WAS ABLE TO PROGRESS USING SPEED BOOSTER."
  DB $02 : DW $01E7
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_DEPTH1:
  DW .Name, .Text, $0000, $01E5
.Name
  DB "HEAT",$00
.Text
  DB "BENEATH VULNAR, THERE IS AN AREA THAT REQUIRES HEAT PROTECTION."
  DB $0A,$0A,!cB
  DB $01 : DW $01E5
  DB !cB,"WAS ABLE TO PROGRESS USING VARIA SUIT."
  DB $02 : DW $01E5
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_DEPTH2:
  DW .Name, .Text, $0000, $01EA
.Name
  DB "MORE WEAPONS",$00
.Text
  DB "IN THE MIDDLE OF THE VULNAR DEPTHS, THERE IS A PATH THAT REQUIRES NEW WEAPONS."
  DB $0A,$0A,!cB
  DB $01 : DW $01EA
  DB !cB,"WAS ABLE TO PROGRESS USING POWER BOMBS AND ICE BEAM."
  DB $02 : DW $01EA
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_LAB:
  DW .Name, .Text, $0000, $01E4
.Name
  DB "LASER",$00
.Text
  DB "IN THE PIRATE LAB, THERE IS A PATH THAT IS BLOCKED BY AN ENERGY LASER."
  DB $0A,$0A,!cB
  DB $01 : DW $01E4
  DB !cB,"WAS ABLE TO PROGRESS BE TURNING THE POWER OFF."
  DB $02 : DW $01E4
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_DEPTH3:
  DW .Name, .Text, $0000, $01EB
.Name
  DB "LAVA",$00
.Text
  DB "DEEP IN THE VULNAR DEPTHS, THERE ARE ROOMS FULL OF LAVA."
  DB $0A,$0A,!cB
  DB $01 : DW $01EB
  DB !cB,"WAS ABLE TO PROGRESS USING METROID SUIT."
  DB $02 : DW $01EB
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_NOROK:
  DW .Name, .Text, $0000, $01E8
.Name
  DB "MORE LASERS",$00
.Text
  DB "IN EASTERN LOMYR VALLEY, THERE IS A PATH THAT IS BLOCKED BY AN ENERGY LASER."
  DB $0A,$0A,!cB
  DB $01 : DW $01E8
  DB !cB,"WAS ABLE TO PROGRESS BY TURNING THE POWER ON AND USING METROID SUIT."
  DB $02 : DW $01E8
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_RIDLEY:
  DW .Name, .Text, $0000, $01EC
.Name
  DB "IMPERVIOUS",$00
.Text
  DB "IN THE SKY TEMPLE, RIDLEY IS IMPERVIOUS TO ALL WEAPONRY."
  DB $01 : DW $01E9
  DB $0A,$0A,!cB
  DB !cB,"WAS ABLE TO AVOID FIGHTING RIDLEY USING A HIDDEN PATH."
  DB $01 : DW $01EC
  DB $0A,$0A,!cB
  DB !cB,"WAS ABLE TO DEFEAT RIDLEY USING HYPER BEAM."
  DB $02 : DW $01EC
  DB $0A,$0A,!cB
  DB !cR,"[UNSOLVED]",$00

Entry_HINT_DAPHNE:
  DW .Name, .Text, $0000, $01ED
.Name
  DB "GATE",$00
.Text
  DB "THE ENTRANCE TO THE GFS DAPHNE WRECKAGE IS BLOCKED BY A BROKEN GATE."
  DB $0A,$0A,!cB
  DB $01 : DW $01ED
  DB !cB,"WAS ABLE TO PROGRESS BY USING SCREW ATTACK."
  DB $02 : DW $01ED
  DB !cR,"[UNSOLVED]",$00
