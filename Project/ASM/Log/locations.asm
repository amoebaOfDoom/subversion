namespace "locations_"

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
  DB !cB," LOCATIONS DATA  ",!cW,$0A
  DB "-----------------",$0A
  DB "INFORMATION ON POINTS OF INTEREST ENCOUNTERED.",$0A
  DB $0A
  DB "SUBCATEGORIES:",$0A
  DB "  - ",!cR,"NATURAL",!cW,$0A
  DB "  - ",!cG,"PIRATE",!cW,$0A
  DB "  - ",!cP,"CHOZO",!cW,$0A
  DB $0A
  DB !cP,"PRESS A TO SELECT",!cW,$00

; List of entries, null terminated
Entries:
  ; natural
  DW Entry_NATURAL
  DW Entry_TN578
    ; insert
  DW Entry_OCEANIA
  DW Entry_OCEAN_DEPTHS
  DW Entry_LOMYR_VALLEY
  DW Entry_VULNAR
  DW Entry_VULNAR_PEAKS
  DW Entry_SPORE_FIELD
  DW Entry_THE_HIVE
  DW Entry_MAGMA_LAKE
  DW Entry_VULNAR_ROOT
  DW Entry_SUZI_ISLAND

  ; pirate
  DW Entry_PIRATE
  DW Entry_SPACE_PORT
  DW Entry_CARGO_SHIP
  DW Entry_GFS_DAPHNE
  DW Entry_PIRATE_LAB_1
  DW Entry_PIRATE_LAB_2
    ; insert
  DW Entry_SERVICE_SECTOR
  DW Entry_CARGO_RAIL
  DW Entry_VERDITE_MINE
  DW Entry_ENERGY_PLANT

  ; chozo
  DW Entry_CHOZO
  DW Entry_WAR_TEMPLE
  DW Entry_LIFE_TEMPLE
  DW Entry_FIRE_TEMPLE
  DW Entry_SKY_TEMPLE
  DW Entry_SUZI_RUINS
  DW Entry_THUNDER_TEMPLE

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
;    Short sprite count
;    OAM data

Entry_NATURAL:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cR,"--NATURAL--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "NATURALLY FORMED FEATURES.",$00

Entry_PIRATE:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cG,"--PIRATE--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "SPACE PIRATE CONSTRUCTS.",$00

Entry_CHOZO:
  DW .Name, .Text, $0000, $0000
.Name
  DB !cP,"--CHOZO--",!cW,$00
.Text
  DB "SUBCATEGORY:",$0A
  DB "ANCIENT CHOZO TEMPLES.",$00

Entry_TN578:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "TN578",$00
.Text
  DB !cR,"TN578",!cW," IS A SUPERTERRAN CLASS PLANET WHICH WAS AN ANCIENT HOME FOR THE ",!cP,"CHOZO",!cW,". EVEN THOUGH IT HAS A BREATHABLE ATMOSPHERE AND ABUNDANT WATER, THE ",!cO,"INTENSE GRAVITY",!cW," PUTS IT ON THE EDGE OF HABITABILITY. IT'S UNCLEAR WHY THE ",!cG,"SPACE PIRATES",!cW," WOULD BE HERE.",$00
.Sprite
  %gfx3_entry(0)
  %pal_entry(5)
  DW $000E   ; oam
  DW $81FD : DB $00 : DW $3840
  DW $800D : DB $00 : DW $3842
  DW $801D : DB $00 : DW $3844
  DW $802D : DB $00 : DW $3846
  DW $803D : DB $00 : DW $3848
  DW $804D : DB $00 : DW $384A
  DW $805D : DB $00 : DW $384C
  DW $81FD : DB $10 : DW $3860
  DW $800D : DB $10 : DW $3862
  DW $801D : DB $10 : DW $3864
  DW $802D : DB $10 : DW $3866
  DW $803D : DB $10 : DW $3868
  DW $804D : DB $10 : DW $386A
  DW $805D : DB $10 : DW $386C

Entry_OCEAN_DEPTHS:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "OCEAN DEPTHS",$00
.Text
  DB "THE ",!cR,"OCEAN FLOOR",!cW," IS PERFORATED WITH A COMPLEX SUBMARINE CAVE SYSTEM. THE TUNNELS ARE FORMED FROM THE THERMAL VENTS AROUND VULNAR. SOME FORM OF ",!cO,"NIGHT VISION",!cW," IS RECOMMENDED TO EXPLORE THESE DARK TUNNELS.",$00
.Sprite
  %gfx1_entry(0)
  %pal_entry(0)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3A44
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3A60
  DW $8008 : DB $10 : DW $3A61
  DW $8018 : DB $10 : DW $3863
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_VULNAR:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "VULNAR",$00
.Text
  DB !cR,"VULNAR VOLCANO",!cW," IS A HOLY SITE TO THE ",!cP,"CHOZO",!cW," THAT LIVED HERE. MANY TEMPLES WERE BUILT HERE AND THE ",!cP,"CHOZO",!cW," WOULD PILGRIMAGE TO THE SUMMIT. WHILE THE VOLCANO HAS NOT ERUPTED IN MILLENNIA, THE REGION IS STILL ACTIVE. IT SEEMS THERE IS SOME ",!cO,"ARTIFICIAL SYSTEM",!cW," TO DISSIPATE THE BUILD UP.",$00
.Sprite
  %gfx1_entry(2)
  %pal_entry(4)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_WAR_TEMPLE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "WAR TEMPLE",$00
.Text
  DB "THESE RUINS USED TO HOUSE GREAT HEROES AS WELL AS TRAINING GROUNDS. WHILE THE ",!cP,"CHOZO",!cW," WERE A VERY SPIRITUAL PEOPLE, THEIR CULTURE HELD HIGH RESPECT FOR THE MARTIAL WAYS. AS ",!cR,"VULNAR",!cW," WAS CONSIDERED A HOLY PLACE, IT IS LIKELY THAT THESE RUINS WERE FOR THEIR WARRIOR MONK CLASS.",$00
.Sprite
  %gfx1_entry(15)
  %pal_entry(21)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $3A4A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3A66
  DW $8040 : DB $10 : DW $3A68
  DW $8050 : DB $10 : DW $3A6A

Entry_SPORE_FIELD:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPORE FIELD",$00
.Text
  DB "IN THESE DARK CAVERNS, PLANT BASED LIFE IS UNABLE TO SURVIVE WITH LIGHT. HOWEVER, FUNGAL LIFE IS ABLE TO FLOURISH THANKS TO THE WARM TEMPERATURES AND THE MINERAL RICH VOLCANIC ROCK.",$00
.Sprite
  %gfx1_entry(4)
  %pal_entry(8)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_CARGO_RAIL:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "CARGO RAIL",$00
.Text
  DB "THE ",!cG,"PIRATES",!cW," CONSTRUCTED A TRANSPORT CONDUIT OUT OF A NATURAL TUNNEL IN THE MOUNTAIN TO FACILITATE ",!cG,"LAB",!cW," RESEARCH. IT USES THE SAME ",!cG,"POWER SYSTEM",!cW," AS THE LAB. ANY ",!cP,"CHOZO",!cW," ARTIFACTS AND HISTORY THAT MAY HAVE BEEN HERE ARE LIKELY LOST.",$00
.Sprite
  %gfx1_entry(12)
  %pal_entry(17)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_THE_HIVE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "THE HIVE",$00
.Text
  DB "LIFE IN THESE CAVES HAS DEVELOPED A SYMBIOTIC RELATIONSHIP TO SURVIVE IN THESE EXTREME CONDITIONS. THE FUNGUS COVERING THE WALLS BREAKS SULFURIC ACID INTO SULFUR DIOXIDE, WHICH THE CREATURES HERE USE TO BREATHE. THIS MAKES THE AIR HERE VERY TOXIC.",$00
.Sprite
  %gfx1_entry(5)
  %pal_entry(9)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_FIRE_TEMPLE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "FIRE TEMPLE",$00
.Text
  DB "THE ",!cP,"FIRE TEMPLE",!cW," WAS BUILT TO APPEASE THE BURNING RAGE OF ",!cR,"VULNAR",!cW,". SINCE PARTS OF THE TEMPLE WERE ONCE EXPOSED TO THE SKY AND THE ARCHITECTURE IS DIFFERENT THAN THE OTHER TEMPLES, IT IS LIKELY THE OLDEST SURVIVING RUINS HERE.",$00
.Sprite
  %gfx2_entry(1)
  %pal_entry(26)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_VERDITE_MINE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "VERDITE MINE",$00
.Text
  DB "THE MINES HERE ARE RICH WITH ",!cG,"VERDITE",!cW,". THE VEIN IS NOT DEPLETED, SO IT IS LIKELY THAT THE MINE IS A FAIRLY RECENT DEVELOPMENT BY THE ",!cG,"SPACE PIRATES",!cW,". VERDITE IS STILL RADIOACTIVE IN THIS RAW MINERAL FORM WHICH ",!cO,"OVERLOADS",!cW," SOME SENSORS, BUT NOT DANGEROUS WITH CURRENT GEAR.",$00
.Sprite
  %gfx1_entry(13)
  %pal_entry(18)
  DW $000A   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3A42
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864

  DW $8038 : DB $10 : DW $3A47
  DW $8048 : DB $00 : DW $3849
  DW $8050 : DB $00 : DW $384A
  DW $8048 : DB $10 : DW $3869
  DW $8050 : DB $10 : DW $386A

Entry_MAGMA_LAKE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "MAGMA LAKE",$00
.Text
  DB "THE ",!cR,"MAGMA LAKE",!cW," IS A LARGE CAVERN THAT FILLS UP WITH MOLTEN ROCK OVER TIME. THE ",!cP,"CHOZO",!cW," BUILT A MECHANISM TO PUMP THE MAGMA OUT OF THIS CHAMBER TO SOMEWHERE ELSE ON THE SURFACE. THIS IS LIKELY WHAT HAS BEEN USED TO PREVENT ",!cR,"VULNAR",!cW," FROM ERUPTING SO THAT IT IS SAFE FOR THE ",!cP,"CHOZO",!cW," TO DWELL HERE.",$00
.Sprite
  %gfx1_entry(6)
  %pal_entry(10)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_VULNAR_ROOT:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "VULNAR ROOT",$00
.Text
  DB "IN THE DEEPEST PLACES BELOW ",!cR,"VULNAR",!cW,", THE CAVES ARE FILLED WITH MAGMA UNDER INTENSE PRESSURE. THE HEAT HERE IS USED AS THE ENERGY SOURCE FOR THE ",!cO,"GEOTHERMAL PLANT",!cW," ABOVE. IT IS UNKNOWN HOW ANY LIFEFORM IS ABLE TO SURVIVE IN THIS HOSTILE ENVIRONMENT.",$00
.Sprite
  %gfx1_entry(7)
  %pal_entry(11)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_ENERGY_PLANT:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "ENERGY PLANT",$00
.Text
  DB "HEAT PULLED UP FROM THE DEPTHS OF ",!cR,"VULNAR",!cW," IS USED TO GENERATE THE MASSIVE AMOUNTS OF ",!cO,"POWER",!cW," REQUIRED TO RUN THE LAB ON THE SURFACE. THE ",!cG,"SPACE PIRATES",!cW," ARE USING CONDUITS BUILT BY THE ",!cP,"CHOZO",!cW," TO EXCHANGE THE HEAT WITH THE ICY PEAKS.",$00
.Sprite
  %gfx1_entry(14)
  %pal_entry(19)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $3A4A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3A66
  DW $8040 : DB $10 : DW $3A68
  DW $8050 : DB $10 : DW $3A6A

Entry_PIRATE_LAB_1:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "PIRATE LAB 1",$00
.Text
  DB "THIS SPACE PIRATE HIGH ENERGY ",!cG,"LABORATORY",!cW," IS EXPERIMENTING WITH A LOCAL MINERAL CALLED ",!cG,"VERDITE",!cW,". IT SEEMS THAT A POWERFUL BEAM IS PRODUCED BY THE RESONANCE OF THE MINERAL WHEN REFINED. THERE MUST BE A NEARBY ",!cO,"POWER PLANT",!cW," TO SUSTAIN THIS LAB.",$00
.Sprite
  %gfx1_entry(11)
  %pal_entry(15)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864

  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $3A4A
  DW $8038 : DB $10 : DW $3A67

  DW $8048 : DB $10 : DW $3869
  DW $8050 : DB $10 : DW $386A

Entry_PIRATE_LAB_2:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "PIRATE LAB 2",$00
.Text
  DB "THE ",!cG,"VERDITE LASER",!cW," SEEMS TO BE ABLE TO CONTAIN METROIDS. THERE ARE TESTS BEING DONE WITH THE METROIDS AND VERDITE. THERE ARE ALSO ALLOYS BEING PRODUCED USING THE MINERAL. THEY ARE LIKELY BEING USED TO MAKE MILITARY GRADE ",!cO,"WEAPONS",!cW," AND ",!cO,"ARMOR",!cW,".",$00
.Sprite
  %gfx1_entry(11)
  %pal_entry(15)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864

  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $3A4A
  DW $8038 : DB $10 : DW $3A67

  DW $8048 : DB $10 : DW $3869
  DW $8050 : DB $10 : DW $386A

Entry_LOMYR_VALLEY:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "LOMYR VALLEY",$00
.Text
  DB "APART FROM THE TEMPLES BUILT ON ",!cR,"VULNAR",!cW,", THE ",!cP,"CHOZO",!cW," LET MOST OF THE SURROUNDING LANDS GROW FALLOW. THEY MAY HAVE WANTED TO ENSURE THAT THE LIFE AND LAND AROUND THE HOLY SITE REMAINED UNTOUCHED AS AN ACT OF RESPECT OR PRESERVATION.",$00
.Sprite
  %gfx1_entry(1)
  %pal_entry(2)
  DW $000A   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862

  DW $8028 : DB $00 : DW $3A45
  DW $8028 : DB $10 : DW $3A65

  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_LIFE_TEMPLE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "LIFE TEMPLE",$00
.Text
  DB "PLANTS HERE CAN THRIVE USING THE NUTRIENTS LEFT BY ERUPTIONS FROM ",!cR,"VULNAR",!cW," LONG AGO. THE TEMPLE BUILT HERE REPRESENTS THE ELEMENTS OF ",!cR,"VULNAR",!cW,"--WHICH SUSTAINS LIFE. INTERESTINGLY, FIRE REPRESENTS ",!cP,"LIFE",!cW,", INSTEAD OF ",!cP,"DEATH",!cW," THAT THE ERUPTIONS HAD CAUSED PRIOR.",$00
.Sprite
  %gfx2_entry(0)
  %pal_entry(24)
  DW $000E   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $3A4A

  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864

  DW $8030 : DB $08 : DW $3856
  DW $0030 : DB $18 : DW $3A76
  DW $0038 : DB $18 : DW $3A77

  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_VULNAR_PEAKS:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "VULNAR PEAKS",$00
.Text
  DB !cP,"CHOZO",!cW," PILGRIMS WOULD TREK UP TO THESE FRIGID HEIGHTS BY CLIMBING THE CLIFFS OF ",!cR,"VULNAR",!cW,". THE ELEVATOR USED WAS LIKELY BUILT LATER ON FOR MAINTENANCE OF SOME ",!cO,"MACHINERY",!cW," IN THE AREA.",$00
.Sprite
  %gfx1_entry(3)
  %pal_entry(6)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3A60
  DW $8010 : DB $10 : DW $3A62
  DW $8020 : DB $10 : DW $3A64
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_SKY_TEMPLE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SKY TEMPLE",$00
.Text
  DB "THE ",!cP,"SKY TEMPLE",!cW," APPEARS TO HAVE A DUALITY TO IT THAT REFLECTS THE BALANCE OF LIGHT AND DARK, DAY AND NIGHT. TO THE ",!cP,"CHOZO",!cW,", NOTHING WAS ABSOLUTELY GOOD OR EVIL, BUT WAS INSTEAD SOMEWHERE IN BETWEEN. THE SKY REVEALS A FULL SPECTRUM ACROSS THESE TWO.",$00
.Sprite
  %gfx2_entry(2)
  %pal_entry(27)
  DW $000F   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8008 : DB $00 : DW $3841
  DW $8000 : DB $10 : DW $3860
  DW $8008 : DB $10 : DW $3861

  DW $8018 : DB $00 : DW $3A43
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3A46
  DW $8018 : DB $10 : DW $3A63
  DW $8020 : DB $10 : DW $3A64

  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_SPACE_PORT:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPACE PORT",$00
.Text
  DB "THIS SPACE STATION IS OF ",!cG,"SPACE PIRATE",!cW," DESIGN. IT ORBITS AT LOW ALTITUDE, SO THAT IT CAN BE USED AS A TRANSIT POINT BETWEEN SPACE SHIPS AND THE PLANET BELOW. IT SEEMS TO BE EQUIPPED WITH A MASS CANNON LINK TO BE USED AS A ",!cO,"SPACE ELEVATOR",!cW," TO A FACILITY BELOW WHEN THE STATION ALIGNS OVERHEAD.",$00
.Sprite
  %gfx1_entry(8)
  %pal_entry(12)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_CARGO_SHIP:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "CARGO SHIP",$00
.Text
  DB "THIS ",!cG,"PIRATE CARGO SHIP",!cW," SEEMS TO HAVE BEEN MODIFIED TO CARRY SOME SPECIAL INVENTORY. IT LIKELY HAS BEEN RETROFITTED SPECIFICALLY FOR MISSIONS DEALING WITH THIS PLANET, SO IT IS LIKELY CARRYING ",!cO,"RESEARCH MATERIALS",!cW," AND OTHER INFORMATION RELATED WITH THE PLANET SURFACE.",$00
.Sprite
  %gfx1_entry(9)
  %pal_entry(13)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_GFS_DAPHNE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "GFS DAPHNE",$00
.Text
  DB !cP,"GFS DAPHNE",!cW," IS A STOLEN FEDERATION CRUISER IN THE HANDS OF THE ",!cG,"SPACE PIRATES",!cW,". AS WITH OTHER SHIPS OF THIS CLASS, IT IS EQUIPPED WITH AN ",!cO,"AURORA UNIT",!cW," AND ",!cO,"ANTIMATTER WARHEADS",!cW,". THIS BEING IN THE HANDS OF THE PIRATES IS VERY CONCERNING.",$00
.Sprite
  %gfx1_entry(10)
  %pal_entry(14)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_SUZI_ISLAND:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SUZI ISLAND",$00
.Text
  DB !cR,"SUZI ISLAND",!cW," IS A REMOTE LOCATION FAR AWAY FROM THE OTHER ",!cP,"CHOZO",!cW," CULTURAL AND RESIDENTIAL AREAS. THE RICH NATURAL ",!cG,"MINERALS",!cW," WERE LIKELY BEING USED FOR ",!cO,"WEAPON RESEARCH",!cW,".",$00
.Sprite
  %gfx3_entry(1)
  %pal_entry(49)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_SUZI_RUINS:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SUZI RUINS",$00
.Text
  DB "THESE ",!cP,"RUINS",!cW," ARE NOT VERY OLD BUT THE FLOODED TUNNELS CAUSED EXPEDIATED DETERIORATION. THERE ARE BOTH ",!cO,"MINING AND MANUFACTURING",!cW," FACILITIES. THE SURFACE SECTION IS SEALED BY A ",!cR,"COMPLEX CIPHER",!cW,".",$00
.Sprite
  %gfx3_entry(2)
  %pal_entry(48)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_THUNDER_TEMPLE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "THUNDER LAB",$00
.Text
  DB "TO THE ",!cP,"CHOZO",!cW,", LIGHTNING IS THE SYMBOL OF TECHNOLOGY. THE REMOTE LOCATION AND ADVANCE SEAL PREVENTED THE ",!cG,"SPACE PIRATES",!cW," FROM REACHING THESE GROUNDS. THERE ARE LIKELY FUNCTIONAL ",!cO,"WEAPON SYSTEMS",!cW," STILL ACTIVE.",$00
.Sprite
  %gfx3_entry(3)
  %pal_entry(50)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3A48
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3A60
  DW $8010 : DB $10 : DW $3A62
  DW $8020 : DB $10 : DW $3A64
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_OCEANIA:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "OCEANIA",$00
.Text
  DB "THE MOST PROMINANT FEATURE OF ",!cR,"OCEANIA",!cW," IS THE MASSIVE CRATER. COASTAL WATERS FILL THE CRATER FORMING A GULF. THERE ARE NUMEROUS SMALLER CRATERS ALONG THE FACE OF ",!cR,"VULNAR VOLCANO",!cW,", MAKING THE IMPACT GEOLOGICALLY RECENT.",$00
.Sprite
  %gfx3_entry(4)
  %pal_entry(52)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3840
  DW $8010 : DB $00 : DW $3A42
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $384A
  DW $8000 : DB $10 : DW $3860
  DW $8010 : DB $10 : DW $3A62
  DW $8020 : DB $10 : DW $3A64
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $386A

Entry_SERVICE_SECTOR:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SERVICE SEC",$00
.Text
  DB "THE ",!cO,"SERVICE SECTOR",!cW," IS AN ONGOING CONSTRUCTION PROJECT BY THE ",!cG,"SPACE PIRATES",!cW,". ONCE COMPLETED, THIS EXPANSION WOULD INCREASE THE RESEARCH CAPACITY OF THE ",!cG,"LABORATORY",!cW," AND PROVIDE DEEPER ACCESS TO ",!cR,"THE DEPTHS",!cW,".",$00
.Sprite
  %gfx3_entry(5)
  %pal_entry(54)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3A44
  DW $8030 : DB $00 : DW $3A46
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $3A4A
  DW $8000 : DB $10 : DW $3A60
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3A64
  DW $8030 : DB $10 : DW $3A66
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $3A6A
