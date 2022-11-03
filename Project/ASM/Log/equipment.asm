namespace "equipment_"

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
  DB !cB," EQUIPMENT DATA  ",!cW,$0A
  DB "-----------------",$0A
  DB "INFORMATION ON EQUIPMENT SAMUS OBTAINED.",$0A
  DB $0A
  DB "SUBCATEGORIES:",$0A
  DB "  - ",!cO,"MOBILITY",!cW,$0A
  DB "  - ",!cO,"WEAPONS",!cW,$0A
  DB "  - ",!cO,"SUIT",!cW,$0A
  DB "  - ",!cO,"TANKS",!cW,$0A
  DB $0A
  DB !cP,"PRESS A TO SELECT",!cW,$00

; List of entries, null terminated
Entries:
  ; MOBILITY
  DW Entry_MOBILITY
  DW Entry_GRAVITY_BOOT
  DW Entry_HI_JUMP
  DW Entry_SPEED_BOOST
  DW Entry_SPACE_JUMP
  DW Entry_MORPH_BALL
  DW Entry_SPEED_BALL

  ; WEAPONS
  DW Entry_WEAPONS
  DW Entry_CHARGE_BEAM
  DW Entry_HYPERCHARGE
  DW Entry_WAVE_BEAM
  DW Entry_ICE_BEAM
  DW Entry_SPAZER_BEAM
  DW Entry_PLASMA_BEAM
  DW Entry_HYPER_BEAM
  DW Entry_GRAPPLE_BEAM
  DW Entry_MISSILE
  DW Entry_SUPERMISSILE
  DW Entry_BOMBS
  DW Entry_POWER_BOMB

  ; SUIT
  DW Entry_SUIT
  DW Entry_GRAVITY
  DW Entry_VARIA
  DW Entry_METROID
  DW Entry_SCREW_ATTACK
  DW Entry_DARK_VISOR
  DW Entry_X_RAY_SCOPE
  DW Entry_SCAN_DATA

  ; TANKS 
  DW Entry_TANKS
  DW Entry_ENERGY_TANK
  DW Entry_REFUEL_TANK
  DW Entry_AMMO_TANK
  DW Entry_ACCEL_CHARGE
  DW Entry_DAMAGE_AMP
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


Entry_MOBILITY:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cO,"--MOBILITY--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "ITEMS THAT FOCUS ON IMPROVING SAMUS'S ABILITY TO MOVE.",$00

Entry_WEAPONS:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cO,"--WEAPONS--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "ITEMS THAT ARE USED WITH SAMUS'S ARMCANNON.",$00

Entry_SUIT:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cO,"--SUIT--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "ITEMS THAT ENHANCE SAMUS'S POWER SUIT.",$00

Entry_TANKS:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cO,"--TANKS--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "ITEMS THAT CAN BE STACKED MULTIPLE TIMES.",$00


; MOBILITY  
Entry_GRAVITY_BOOT:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "GRAV BOOTS",$00
.Text
  DB "GRAVITY BOOTS CREATE AN ",!cB,"ARTIFICIAL GRAVITY",!cW," THAT ALLOW SAMUS TO ",!cO,"MOVE",!cW," IN ANY ENVIRONMENT AT ",!cR,"1G",!cW,".",$00
.Sprite
  %gfx2_entry(12)
  %pal_entry(43)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $384E

Entry_HI_JUMP:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "HI-JUMP",$00
.Text
  DB "HI-JUMP BOOTS ALLOW SAMUS TO ",!cO,"JUMP",!cW," TO GREATER ",!cB,"HEIGHTS",!cW,".",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3868

Entry_SPEED_BOOST:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPEED BOOST",$00
.Text
  DB "SPEED BOOSTER ALLOWS SAMUS TO ",!cO,"RUN",!cW," AT ",!cB,"HIGH SPEEDS",!cW,". PRESSING ",!cO,"DOWN",!cW," WHILE AT MAX SPEED ALLOWS SAMUS TO PERFORM A ",!cB,"SHINESPARK",!cW,".",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002   ; oam
  DW $8018 : DB $08 : DW $3846
  DW $8038 : DB $08 : DW $384A

Entry_SPACE_JUMP:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPACE JUMP",$00
.Text
  DB "SPACE JUMP ALLOWS SAMUS TO ",!cO,"JUMP",!cW," WHILE IN THE ",!cB,"AIR",!cW,". THE ",!cR,"NUMBER",!cW," OF TIMES THIS CAN BE USED CAN BE INCREASED WITH A ",!cP,"SPACE JUMP BOOST ITEM",!cW,".",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0002   ; oam
  DW $8018 : DB $08 : DW $386A
  DW $8038 : DB $08 : DW $3A6C

Entry_MORPH_BALL:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "MORPH BALL",$00
.Text
  DB "PRESSING ",!cO,"DOWN",!cW," WHILE CROUCHED WILL MAKE SAMUS ROLL INTO A ",!cB,"BALL",!cW,". SAMUS CAN FIT IN SMALL SPACES WHEN IN BALL FORM.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3860

Entry_SPEED_BALL:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPEED BALL",$00
.Text
  DB "SAMUS CAN ",!cO,"ROLL",!cW," MUCH ",!cB,"FASTER",!cW," AND ",!cO,"JUMP",!cW," WHILE IN BALL FORM.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3864

; WEAPONS   
Entry_CHARGE_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "CHARGE BEAM",$00
.Text
  DB "HOLDING THE ",!cO,"SHOOT",!cW," BUTTON DOWN WILL BUILD UP A ",!cB,"CHARGE SHOT",!cW,". A FULLY CHARGED SHOT WILL DEAL ",!cR,"TRIPLE",!cW," BEAM DAMAGE AND CAN PENETRATE SOME ARMOR. THIS WILL ALSO ATTRACT REFILL DROPS WHILE CHARGING.",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3840

Entry_HYPERCHARGE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "HYPERCHARGE",$00
.Text
  DB !cO,"CHARGED SHOTS",!cW," ARE MORE ",!cR,"POWERFUL",!cW,". THEY NOW FIRE A ",!cB,"HYPER BEAM",!cW,". IN ADDITION, HYPER BEAM DAMAGE IS INCREASED.",$00
.Sprite
  %gfx2_entry(12)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $386C

Entry_WAVE_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "WAVE BEAM",$00
.Text
  DB "WAVE BEAM ALLOWS SHOTS TO TRAVEL ",!cB,"THROUGH TERRAIN",!cW,". INCREASES BEAM DAMAGE BY ",!cR,"10",!cW,".",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(42)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3844

Entry_ICE_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "ICE BEAM",$00
.Text
  DB "ICE BEAM ALLOWS SHOTS TO ",!cB,"FREEZE",!cW," SOME ENEMIES. SOME ENEMIES CAN ONLY BE DESTROYED BY AN EXPLOSIVE IMPACT AFTER BEING FROZEN. INCREASES BEAM DAMAGE BY ",!cR,"10",!cW,".",$00
.Sprite
  %gfx2_entry(15)
  %pal_entry(43)
  DW $0005   ; oam
  DW $8010 : DB $08 : DW $3840

  DW $8030 : DB $00 : DW $3A4C
  DW $8040 : DB $00 : DW $3A4E
  DW $8030 : DB $10 : DW $3A6C
  DW $8040 : DB $10 : DW $3A6E

Entry_SPAZER_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPAZER BEAM",$00
.Text
  DB "SPAZER BEAM INCREASES THE BEAM ",!cB,"SIZE",!cW," AND CAN DESTROY SOME TERRAIN. INCREASES BEAM DAMAGE BY ",!cR,"10",!cW,".",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002   ; oam
  DW $8018 : DB $08 : DW $3842
  DW $8038 : DB $08 : DW $384E

Entry_PLASMA_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "PLASMA BEAM",$00
.Text
  DB "PLASMA BEAM ",!cB,"MELTS",!cW," SOME ICY TERRAIN AND ",!cB,"PIERCES",!cW," MOST ENEMIES. INCREASES BEAM DAMAGE BY ",!cR,"10",!cW,".",$00
.Sprite
  %gfx2_entry(15)
  %pal_entry(45)
  DW $0005   ; oam
  DW $8010 : DB $08 : DW $3A42

  DW $8030 : DB $00 : DW $3848
  DW $8040 : DB $00 : DW $384A
  DW $8030 : DB $10 : DW $3868
  DW $8040 : DB $10 : DW $386A

Entry_HYPER_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "HYPER BEAM",$00
.Text
  DB "WHILE TOUCHING A ",!cG,"VERDITE LASER",!cW," OR AN ELECTRIC SPARK WITH THE ",!cP,"METROID SUIT",!cW," EQUIPPED, SAMUS CAN CHANNEL THE ENERGY INTO HER ARMCANNON AND ",!cO,"FIRE",!cW," THE ",!cB,"HYPER BEAM",!cW,".",$00
.Sprite
  %gfx2_entry(15)
  %pal_entry(41)
  DW $0009   ; oam
  DW $8010 : DB $08 : DW $3A46
  
  DW $0028 : DB $00 : DW $3844
  DW $0030 : DB $00 : DW $3845
  DW $8028 : DB $08 : DW $3864
  
  DW $0038 : DB $08 : DW $3866
  DW $0038 : DB $10 : DW $3876

  DW $8040 : DB $08 : DW $F864
  DW $0040 : DB $18 : DW $3844
  DW $0048 : DB $18 : DW $3845

Entry_GRAPPLE_BEAM:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "GRAPPLE BEAM",$00
.Text
  DB "AFTER ",!cO,"SELECTING",!cW," GRAPPLE BEAM ON THE HUD, ",!cO,"SHOOTING",!cW," WILL FIRE A ",!cB,"MAGNETIC BEAM",!cW," WHICH ALLOWS SAMUS TO SWING ON CERTAIN TERRAIN. SOME GRAPPLE POINTS CAN ACT AS ",!cG,"SWITCHES",!cW," WHEN INTERFACED WITH.",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002
  DW $8018 : DB $08 : DW $3866
  DW $8038 : DB $08 : DW $386E

Entry_MISSILE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "MISSILE",$00
.Text
  DB "AFTER ",!cO,"SELECTING",!cW," MISSILES ON THE HUD, ",!cO,"SHOOTING",!cW," WILL FIRE A ",!cB,"MISSILE",!cW,". THIS DOES ",!cR,"100",!cW," DAMAGE AND CONSUMES ",!cR,"1",!cW," AMMO.",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3860

Entry_SUPERMISSILE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "S. MISSILE",$00
.Text
  DB "AFTER ",!cO,"SELECTING",!cW," SUPER MISSILES ON THE HUD, ",!cO,"SHOOTING",!cW," WILL FIRE A MORE POWERFUL ",!cB,"SUPER MISSILE",!cW,". THIS DOES ",!cR,"300",!cW," DAMAGE AND CONSUMES ",!cR,"5",!cW," AMMO.",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002
  DW $8018 : DB $08 : DW $3862
  DW $8038 : DB $08 : DW $386A

Entry_BOMBS:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "BOMBS",$00
.Text
  DB "PRESSING ",!cO,"SHOOT",!cW," WHILE IN BALL FORM WILL LAY A ",!cB,"BOMB",!cW,". THE BOMB EXPLOSION LAUNCHES SAMUS UPWARDS AND CAN DESTROY SOME TERRAIN THAT OTHER WEAPONS CANNOT.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0002
  DW $8018 : DB $08 : DW $3862
  DW $8038 : DB $08 : DW $386E

Entry_POWER_BOMB:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "POWER BOMB",$00
.Text
  DB "AFTER ",!cO,"SELECTING",!cW," POWER BOMBS IN THE HUD, PLACING A ",!cO,"BOMB",!cW," WILL INSTEAD PLACE A MUCH MORE ",!cB,"POWERFUL BOMB",!cW,". THIS DOES ",!cR,"300",!cW," DAMAGE AND CONSUMES ",!cR,"10",!cW," AMMO.",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002
  DW $8018 : DB $08 : DW $3864
  DW $8038 : DB $08 : DW $386C

; SUIT  
Entry_GRAVITY:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "AQUA SUIT",$00
.Text
  DB "AQUA SUIT ALLOWS SAMUS TO ",!cO,"MOVE",!cW," IN ",!cB,"LIQUIDS",!cW," AS IF THEY WERE AIR. REDUCES DAMAGE BY ",!cR,"25%",!cW,".",$00
.Sprite
  %gfx2_entry(12)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $386E

Entry_VARIA:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "VARIA SUIT",$00
.Text
  DB "VARIA SUIT SIGNIFICANTLY REDUCES DAMAGE FROM ",!cB,"EXTREME TEMPERATURES",!cW,". REDUCES DAMAGE BY ",!cR,"25%",!cW,".",$00
.Sprite
  %gfx2_entry(15)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3860

Entry_METROID:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "METROID",$00
.Text
  DB "MADE USING A ",!cG,"VERDITE ALLOY",!cW,", THE METROID SUIT PREVENTS DAMAGE FROM THE MOST INTENSE HEAT, BUT AT THE COST OF VULNERABILITY TO THE COLD. IN ADDITION, SAMUS CAN ABSORB THE ENERGY FROM ",!cG,"VERDITE LASERS",!cW,". REDUCES DAMAGE BY ",!cR,"25%",!cW,".",$00
.Sprite
  %gfx2_entry(15)
  %pal_entry(41)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3862

Entry_SCREW_ATTACK:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SCREW ATTACK",$00
.Text
  DB "SCREW ATTACK WILL MAKE A ",!cO,"SPIN JUMP",!cW," DEAL ",!cR,"MASSIVE",!cW," DAMAGE TO MOST ENEMIES ON ",!cB,"CONTACT",!cW,".",$00
.Sprite
  %gfx2_entry(13)
  %pal_entry(40)
  DW $0002
  DW $8018 : DB $08 : DW $3848
  DW $8038 : DB $08 : DW $384C

Entry_DARK_VISOR:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "DARK VISOR",$00
.Text
  DB "DARK VISOR CAN BE USED TO ",!cO,"VIEW",!cW," ENERGY INTENSITY. THIS ALLOWS SAMUS TO SEE THINGS THAT MAY BE ",!cB,"INVISIBLE",!cW," WITH THE NAKED EYE. NOT COMPATIBLE WITH OTHER VISOR AUGMENTS.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(46)
  DW $0004   ; oam
  DW $8008 : DB $08 : DW $3848
  DW $8020 : DB $08 : DW $3A4A
  DW $8034 : DB $08 : DW $3A4C
  DW $8048 : DB $08 : DW $384E

Entry_X_RAY_SCOPE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "X-RAY SCOPE",$00
.Text
  DB "X-RAY SCOPE CAN BE USED TO ",!cO,"VIEW",!cW," THE MATERIAL MAKEUP OF TERRAIN. THIS CAN PROVIDE DATA ON TERRAIN THAT MAY BE ",!cB,"DESTRUCTIBLE",!cW,". NOT COMPATIBLE WITH OTHER VISOR AUGMENTS.",$00
.Sprite
  %gfx2_entry(12)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $384C

Entry_SCAN_DATA:
  DW .Name, .Text, $0000, $0000
.Name
  DB "SCAN DATA",$00
.Text
  DB "THE ORBITAL SCAN DATA DOWNLOADED FROM THE CARGO SHIP CONTAINS LOCATIONS OF VARIOUS ENERGY SIGNATURES THAT MATCH ",!cP,"CHOZO EQUIPMENT",!cW,".",$00


; TANKS 
Entry_ENERGY_TANK:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "ENERGY TANK",$00
.Text
  DB "EACH ENERGY TANK INCREASES SAMUS'S MAX ",!cB,"ENERGY",!cW,". BY ",!cR,"100",!cW,". AT HIGH MAX ENERGY, TANKS WILL INSTEAD ONLY INCREASE BY 50. SAMUS WILL DIE WHEN ENERGY FALLS TO 0.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3840

Entry_REFUEL_TANK:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "REFUEL TANK",$00
.Text
  DB "USING A ",!cO,"SAVE STATION",!cW," WILL REFILL UP TO 99 ENERGY. EACH REFUEL TANK RECHARGES ",!cR,"1",!cW," ADDITIONAL ENERGY TANK DURING THIS PROCESS.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3842

Entry_AMMO_TANK:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "AMMO TANK",$00
.Text
  DB "AMMO TANKS INCREASE SAMUS'S MAXIMUM ",!cB,"AMMO",!cW," CAPACITY. THEY CAN COME IN ",!cR,"DIFFERENT SIZES",!cW,".",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(41)
  DW $0002
  DW $8018 : DB $08 : DW $3844
  DW $8038 : DB $08 : DW $3846

Entry_ACCEL_CHARGE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "ACCEL CHARGE",$00
.Text
  DB "EACH ACCEL CHARGE REDUCES ",!cB,"CHARGE TIME",!cW," BY ",!cR,"0.25",!cW," SECONDS.",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3866

Entry_DAMAGE_AMP:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "DAMAGE AMP",$00
.Text
  DB "EACH DAMAGE AMP INCREASES SAMUS'S ",!cB,"BEAM DAMAGE",!cW," BY ",!cR,"50%",!cW,".",$00
.Sprite
  %gfx2_entry(14)
  %pal_entry(40)
  DW $0001   ; oam
  DW $8028 : DB $08 : DW $3868
