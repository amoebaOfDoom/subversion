namespace "beastiary_"

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
  DB !cB," BESTIARY DATA  ",!cW,$0A
  DB "-----------------",$0A
  DB "INFORMATION ON CREATURES SAMUS ENGAGED.",$0A
  DB $0A
  DB !cP,"PRESS A TO SELECT",!cW,$00

; List of entries, null terminated
Entries:
  DW Entry_TORIZO
  DW Entry_SPORE_SPAWN
  DW Entry_KRAID
  DW Entry_CROCOMIRE
  DW Entry_PHANTOON
  DW Entry_BOTWOON
  DW Entry_DRAYGON
  DW Entry_RIDLEY
  DW Entry_METROIDS
  DW Entry_AURORA_UNIT
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


Entry_TORIZO:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "TORIZO",$00
.Text
  DB "THE ",!cB,"TORIZO",!cW," ARE STATUES BUILT TO HONOR DEAD ",!cP,"CHOZO",!cW," HEROES. SOMETIMES THESE STATUES ARE MADE INTO COMBAT BOTS TO SPAR WITH THE DEPARTED LEGENDS. THE CHOZO HAVE A WEAKNESS IN THE ",!cR,"CHEST",!cW," AND THESE TORIZO ARE NO DIFFERENT.",$00
.Sprite
  %gfx2_entry(3)
  %pal_entry(29)
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

Entry_BOTWOON:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "BOTWOON",$00
.Text
  DB !cB,"BOTWOON",!cW," IS A BURROWING AQUATIC SNAKE. IT LIKES TO MAKE ITS HOME IN ROCK RIDDLED WITH HOLES AND IS VERY TERRITORIAL. ",!cB,"BOTWOON'S",!cW," BODY IS COVERED WITH A HARDENED ARMOR, BUT IT DOESN'T COVER THE ",!cR,"FACE",!cW,".",$00
.Sprite
  %gfx2_entry(8)
  %pal_entry(35)
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

Entry_DRAYGON:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "DRAYGON",$00
.Text
  DB !cB,"DRAYGON",!cW," IS A BEHEMOTH OF A CREATURE THAT RESEMBLES A DRAGON. IT LIVES DEEP IN MAGMA IN ORDER TO PROTECT THEIR YOUNG IN A RELATIVELY UNCONTESTED AREA. ",!cB,"DRAYGON",!cW," IS VERY STURDY IN ORDER TO SURVIVE IN ITS CLIMATE, BUT ITS ",!cR,"BELLY",!cW," IS SOFT FOR NURSING.",$00
.Sprite
  %gfx2_entry(9)
  %pal_entry(36)
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

Entry_RIDLEY:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "RIDLEY",$00
.Text
  DB !cB,"RIDLEY",!cW," IS THE LEADER OF THE ",!cG,"SPACE PIRATES",!cW,". SAMUS MAY HAVE DEFEATED ",!cB,"RIDLEY",!cW," IN THE PAST, BUT THEY SEEM MUCH MORE OF A THREAT NOW. ",!cB,"RIDLEY'S",!cW," BIOENGINEERED EXOSKELETON HAS BEEN MODIFIED USING SOME NEW ALLOY THAT MAKES IT ",!cR,"IMPERVIOUS",!cW," TO ALL KNOWN ",!cP,"CHOZO",!cW," AND ",!cP,"FEDERATION",!cW," WEAPONRY.",$00
.Sprite
  %gfx2_entry(10)
  %pal_entry(37)
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

Entry_KRAID:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "KRAID",$00
.Text
  DB !cB,"KRAID",!cW," LIKE TO BUILD THEIR NESTS IN THE SAND NEAR THE SHALLOWS OF THE OCEAN. WHEN THEY MATURE, THEIR TITANIC SIZE CAN BE QUITE INTIMIDATING. IT IS NOT UNCOMMON FOR KRAID TO BE RECRUITED BY THE ",!cG,"SPACE PIRATES",!cW,". THEIR SKIN IS QUITE THICK BUT DOESN'T PROTECT THE INSIDE OF THEIR ",!cR,"MOUTH",!cW,".",$00
.Sprite
  %gfx2_entry(5)
  %pal_entry(31)
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

Entry_CROCOMIRE:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "CROCOMIRE",$00
.Text
  DB !cB,"CROCOMIRE",!cW," CREATES A VERY CAUSTIC ACID AS A WASTE PRODUCT. THEY ARE GENERALLY PRETTY SEDENTARY, SO THE ACID INEVITABLY POOLS AROUND THEM. IT IS LIKELY THAT A ",!cR,"HIGH SPEED IMPACT",!cW," COULD KNOCK IT INTO ONE OF THESE ACID POOLS.",$00
.Sprite
  %gfx2_entry(6)
  %pal_entry(32)
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

Entry_PHANTOON:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "PHANTOON",$00
.Text
  DB "IT IS NOT CLEAR WHAT KIND OF SPECIES ",!cB,"PHANTOON",!cW," IS, BUT SOME BELIEVE IT TO BE AN EVIL SPIRIT. THE ",!cP,"CHOZO",!cW," DON'T MENTION THEM IN THEIR RECORDS, SO IT IS LIKELY ALIEN TO THIS PLANET. ",!cB,"PHANTOON",!cW," CAN CLOAK ITSELF, BUT IT MAY BE VISIBLE WITH OTHER ",!cR,"VISORS",!cW,".",$00
.Sprite
  %gfx2_entry(7)
  %pal_entry(33)
  DW $000C   ; oam
  DW $8000 : DB $00 : DW $3A40
  DW $8010 : DB $00 : DW $3842
  DW $8020 : DB $00 : DW $3844
  DW $8030 : DB $00 : DW $3846
  DW $8040 : DB $00 : DW $3848
  DW $8050 : DB $00 : DW $3A4A
  DW $8000 : DB $10 : DW $3A60
  DW $8010 : DB $10 : DW $3862
  DW $8020 : DB $10 : DW $3864
  DW $8030 : DB $10 : DW $3866
  DW $8040 : DB $10 : DW $3868
  DW $8050 : DB $10 : DW $3A6A

Entry_SPORE_SPAWN:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "SPORE SPAWN",$00
.Text
  DB "IN THE CENTER OF THE SPORE FIELD CAVES, ",!cB,"SPORE SPAWN",!cW," IS THE SOURCE OF THE FUNGAL GROWTH IN THIS REGION. IT'S SURPRISINGLY MOBILE FOR A FUNGUS AND CAN CHANGE THE STRUCTURE OF THE ROOM AT WILL. USING QUICK MOVEMENT, DESTROY THE ",!cR,"CORE",!cW," AND IT WILL PERISH.",$00
.Sprite
  %gfx2_entry(4)
  %pal_entry(30)
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

Entry_AURORA_UNIT:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "AURORA UNIT",$00
.Text
  DB "THE ",!cP,"FEDERATION",!cW," USE A BIOLOGICAL COMPUTER CALLED AN ",!cB,"AURORA UNIT",!cW,". IN THE PAST, THE ",!cG,"SPACE PIRATES",!cW," COMMANDEERED THESE AND BUILT THEM INTO MECHS. THIS ",!cB,"AURORA UNIT",!cW," HAS NOT BEEN CONVERTED YET, SO IT SHOULD NOT BE MUCH OF A THREAT.",$00
.Sprite
  %gfx2_entry(12)
  %pal_entry(39)
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

Entry_METROIDS:
  DW .Name, .Text, .Sprite, $0000
.Name
  DB "METROIDS",$00
.Text
  DB !cB,"METROIDS",!cW," WERE ORIGINALLY CREATED BY THE ",!cP,"CHOZO",!cW," TO FIGHT THE PARASITE X. THEY ARE A GALACTIC THREAT, CAPABLE OF DRAINING ENERGY FROM ALMOST ANY LIFEFORM WHILE BEING NEARLY INVULNERABLE. THEIR ONLY KNOWN WEAKNESS IS THE ",!cR,"COLD",!cR,".",$00
.Sprite
  %gfx2_entry(11)
  %pal_entry(38)
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

