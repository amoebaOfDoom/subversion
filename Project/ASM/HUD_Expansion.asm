lorom

; Set this to the relative path between the assembler and this file (eg. ROMProject/ASM)
; If the assembler is in the same directory, then leave it as '.'
!this_dir = ROMProject/Graphics

; This patch clears up tiles for additional map and hud graphics.
; In addition, the top row of the HUD is now editable.
;
; This is largely accomplished by doing 3 things:
;   1) The file select graphics are moved to a new location.
;      It can be changed to any free space at `FileSelect_BG1_GFX`
;   2) The FX graphics and message box letters are dynamically loaded
;      the bottom row of the HUD graphics. If more FX graphics types
;      are desired, the loading routines may need to be updated here.
;      Note: The bottom row of the HUD graphics is reserved. Do not 
;      use these tiles for the hud as they may be either the FX or the
;      message box letters.
;   3) The PB/CF HDMA are made more compact to allow more space for the
;      top row of the hud.
;
; Editing map graphics:
; - Graphics with an `O` are free on both the HUD and pause screen and
;   can thus be used as map tiles.
; - Graphics with an `X` can can be used but not for the map tiles.
; - The graphic tile with an '*' can only be used for message boxes.
; - Ensure that all map tiles line up on the HUD and Pause graphics
;
; Advanced map graphics editing:
; - Graphic tiles from 0x00-0xDF can all be used for map tiles if
;   they are free on both the HUD and Pause. More tiles can be made
;   available if some HUD elements are removed such as the reserve
;   AUTO and "energy" text tiles. The "%" and "x" tiles on the top
;   row are not used in vanilla and are safe to remove. 
; - Graphic tiles from 0xE0-0xFF are dynamically loaded for FX/Msg.
;   These can be completely replaced with different message box
;   graphics as long as message.ttb is updated appropriately.
; - HUD graphics 0x100-0x1FF is not normally loaded into VRAM. This
;   patch uses this space for the HUD dynamically loaded graphics.
;   If more FX graphics are added, this region is a perfect place to
;   add them.
; (Opaque Version)
; - If the text is not intended to be used on the HUD in any way and 
;   the extended message box tiles are not needed, then it should be 
;   possible to move the text tiles down over the extended tiles and 
;   move the associated pause screen tiles to a free location. The 
;   letters will only be loaded during message boxes, clearing up 32 
;   more tiles. This would require changing the many of the TTB 
;   included in this patch, including message.ttb and the pause screen 
;   ttb.
; (Transparent Version)
; - If the text is not intended to be used on the HUD in any way then
;   it should be safe to overwrite them first rows of opaque letters.
;   However to use them for map tiles, the tiles in the in the map
;   screen graphics will need to be moved elsewhere. Make sure to update
;   the area names appropriately.
;
; Free space used:
;   - Load_FX: Bank 89
;   - FileSelect_BG1_GFX: Any bank
;
; Since this patch includes many TTB and GFX data, if SMART is being
; used then the appropriate data should be added to the export directory
; and removed from this patch. Also be aware if any other patches used
; that edit any of the included TTB/GFX data.
;
; Known bugs
;  - The elevator map tile and left/right arrow are moved, so they will 
;    be the wrong tile in vanilla maps.
;  - The samus figure in the message box that appears in the Bomb item
;    message box is removed. (opaque version)
;
; This asm was written by TestRunner based on CleanHUD by BlackFalcon,
; which in turn based on the DC Map patch. The main changes in this 
; version is a couple more free tiles, almost all the extended message
; box graphics is available, and the patch is entirely in ASM for
; ease of editting.

;----------------------------
; Load GFX/TTB Data
;----------------------------

org $899800
    incbin !this_dir/pb_hdma.bin

org $81B14B
    incbin !this_dir/map_load_hud.ttb

org $82D521
    incbin !this_dir/samus_wireframe.ttb

org $85877F
    incbin !this_dir/messages.ttb

; FX tilemap
org $8A8000
    incbin !this_dir/FX_lava.ttb
    incbin !this_dir/FX_acid.ttb
    incbin !this_dir/FX_water.ttb
    incbin !this_dir/FX_spores.ttb
    incbin !this_dir/FX_rain.ttb
    incbin !this_dir/FX_fog.ttb
org $8AE980
SnowTTB:
    incbin !this_dir/FX_snow.ttb
StarsTTB:
    incbin !this_dir/FX_stars.ttb

org $8E8000
    incbin !this_dir/file_select_BG2.GFX

org $B6E000
    incbin !this_dir/pause_BG2.ttb
    incbin !this_dir/equipment.ttb

; free space
org $87CF40
FileSelect_BG1_GFX:
    incbin !this_dir/file_select_BG1.GFX

org $87C970
SnowAnimation:
    DW #TestSporeHeatFlag, $82ED
SnowAnimationLoop:
    DW $000A, #SnowGFX+$000
    DW $000A, #SnowGFX+$030
    DW $000A, #SnowGFX+$060
    DW $000A, #SnowGFX+$090
    DW $000A, #SnowGFX+$0C0
    DW $000A, #SnowGFX+$0F0
    DW $000A, #SnowGFX+$120
    DW $000A, #SnowGFX+$150
    DW $000A, #SnowGFX+$180
    DW $000A, #SnowGFX+$1B0
    DW $80B7, #SnowAnimationLoop ; Go to LOOP

SnowGFX:
    incbin !this_dir/FX_snow.gfx

TestSporeHeatFlag:
    LDA $197E  ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
    BIT #$0002 ; Check for 'heat' bit
    BNE TestSporeHeatFlag_End
    LDA $0000,y ; Take Branch
    TAY
    RTS
TestSporeHeatFlag_End:
    INY : INY
    RTS

StarsAnimationHeader:
    DW #StarsAnimationLoop, $0040, $4700

StarsAnimationLoop:
    DW $000A, #StarsGFX+$000
    DW $000A, #StarsGFX+$200
    DW $000A, #StarsGFX+$240
    DW $000A, #StarsGFX+$280
    DW $000A, #StarsGFX+$2C0
    ;DW $000A, #StarsGFX+$280
    ;DW $000A, #StarsGFX+$240
    ;DW $000A, #StarsGFX+$200
    DW $80B7, #StarsAnimationLoop ; Go to LOOP

warnpc $87CC00
org $87CC00 ; needs to be 256 byte aligned
StarsGFX:
    incbin !this_dir/FX_stars.gfx

org $88DB62
    ADC $1978 ; surface start = fog y-scroll speed
org $88DB82
    ADC $197A ; surface new = fog x-scroll speed

org $83ABFE
  DW #StarsTTB
org $83AC26
  DW #StarsFXInit

org $88EE32 ;free space
StarsFXInit:
    SEP #$20
    LDA #$5C ; set BG3 to 32x32 and set base address to FX tilemap (not hud)
    STA $5B
    REP #$20
    JSL $88D865
    LDY #StarsAnimationHeader
    JSL $878027
    JSL $888435 ; Spawn HDMA object
        DB $40, $32 ; (indirect table + 8-bit transfer), (Color math subscreen backdrop color)
        DW StarsHazeHdmaObject
    LDA #StarsHazeHdmaTable
    STA $1974
    RTL

StarsHazeHdmaObject:
    DW $8655 ; HDMA table bank = $88
        DB $88
    DW $866A ; Indirect HDMA data bank = $7E
        DB $7E
    DW $8570 ; Pre-instruction
        DL #StarsHazePreInstruction
    DW $0001, $DF02 ; empty table
StarsHazeLoop:
    DW $7777, #StarsHazeHdmaTable ; standard haze table
    DW $85EC, #StarsHazeLoop

StarsHazePreInstruction:
    LDA #$0060
    JMP $DE18

StarsHazeHdmaTable:
    DB $80
        DW $9D00
    DB $0B
        DW $9D01
    DB $0A
        DW $9D02
    DB $09
        DW $9D03
    DB $08
        DW $9D04
    DB $07
        DW $9D05
    DB $07
        DW $9D06
    DB $06
        DW $9D07
    DB $06
        DW $9D08
    DB $06
        DW $9D09
    DB $05
        DW $9D0A
    DB $05
        DW $9D0B
    DB $05
        DW $9D0C
    DB $04
        DW $9D0D
    DB $04
        DW $9D0E
    DB $04
        DW $9D0F
    DB $00

StarsWithPB:
    STZ $60
    STZ $61

    LDA #$80
    STA $62
    LDA #$12
    STA $6E

    LDA #$37
    STA $71
    STZ $6C
    LDA #$04
    STA $6D

    LDA #$17
    STA $69
    STZ $6B
    RTS

HazePreInstructionWithPB:
    LDA $0A78
    BIT #$0001
    BNE HazePreInstructionWithXray_Active
    LDA $0CEE
    BEQ HazePreInstructionWithPB_Inactive
    LDA $0592
    BIT #$8000
    BNE HazePreInstructionWithPB_Active
HazePreInstructionWithPB_Inactive:
    LDA $1974
    STA $18D8,X
    RTS
HazePreInstructionWithXray_Active:
    LDA #$0027
    STA $74
    LDA #$0047
    STA $75
    LDA #$0087
    STA $76
HazePreInstructionWithPB_Active:
    LDA #$DF02
    STA $18D8,X
    RTS

HazePreInstructionInit_2:
    LDA #$DF03
    STA $1974
    LDA #$0001
    RTS

StarsWithXray:
    LDA #$13
    STA $69
    LDA $196E
    CMP #$0E
    BEQ StarsWithXray_Stars
    LDA #$04
    RTS
StarsWithXray_Stars:
    LDA #$A4
    STA $71
    LDA #$00
    RTS

org $888187
    JSR StarsWithXray
    STA $6B
    STA $6D
    LDA #$03
    STA $6C
    LDA #$22
    STA $6E
    LDA $71
    AND #$80
    ORA #$73
    STA $71
    RTS

org $8881AE
    JSR StarsWithXray
    STA $6B
    STA $6D
    BNE +
    LDA #$17
    STA $69
+
    LDA #$03
    STA $6C
    LDA #$22
    STA $6E
    LDA $71
    AND #$80
    ORA #$61
    STA $71
    RTS

; Layer blending configuration 1C - normally unused
org $8880E8
    LDA #$17
    STA $69 ; Main screen layers = BG1/BG2/BG3/sprites
    ;LDA #$00
    STZ $6B ; Subscreen layers = None
    LDA #$24
    STA $71 ; Enable colour math on BG3/backdrop in additive mode
    LDY #$02
    RTS

org $88DDC7
    JSR HazePreInstructionInit_2;LDA #$0001

org $88DE39
    JSR HazePreInstructionWithPB
    ;NOP : NOP : NOP ;LDA #$002C
    NOP : NOP : NOP ;STA $1986

org $88DE83
    JSR HazePreInstructionWithPB
    ;NOP : NOP : NOP ;LDA #$002C
    NOP : NOP : NOP ;STA $1986

org $88DEA5
    JSR HazePreInstructionWithPB
    ;NOP : NOP : NOP ;LDA #$002C
    NOP : NOP : NOP ;STA $1986

org $8880F5
    LDY #$00 ;LDY #$02

org $888211
    DW $8219, StarsWithPB, $823E, $8263

;------------------------------------
; Allow top row of HUD to be edited
;------------------------------------

org $809632
; allow doing the door transition DMA without forcing blanking of layers
ExecuteTransitionDMAWithBlank:
    XBA
    SEP #$20
    CLV
    STA $2100 ; sets the screen to be blacked. A = 0x80
ExecuteTransitionDMAWithoutBlank:

org $809661
    ; skip reverting screen visibility if wasn't blacked
    STZ $05BD
    BVS $07

; previously loaded to check if transition DMA should happen
; but since the value (0x80) matches the screen blank value,
; we pass this into the JSR to save a few bytes of code
org $80978E
    LDA $05BC ; load to A instead of X
org $80980A
    LDA $05BC ; load to A instead of X

; load top row in init
org $809AA3
    LDA $988B,X ; 98CB
    STA $7EC5C8,X ; 7EC608
    INX
    INX
    CPX #$0100   ; 00C0

; add top hud row to d table transfer
org $809CAD
    LDA #$0100 ; #$00C0
    STA $D0,x
    INX
    INX
    LDA #$C5C8  ; C608
org $809CC1
    LDA #$5800 ; 5820

org $80A0ED
    ; add an injection to run the transition DMA at gameplay load
    JSR TransitionDMA_CalculateLayer2XPos ; A2F9

; clear layer 3
; This is rewritten to make it free up some space for the next function
org $80A29C
    PHP
    LDX #$0002
ClearLayer3_Loop:
    REP #$20
    LDA #$5880
    STA $2116 ; DMA VRAM address
    LDA.w ClearLayer3_DMA_Params,X
    STA $4310 ; DMA Parameter/VRAM Address
    LDA.w ClearLayer3_WRAM_Address,X
    STA $4312 ; DMA WRAM Address
    LDA #$0080
    STA $4314 ; DMA WRAM Bank
    LDA #$0780
    STA $4315 ; DMA Bytes
    SEP #$20
    LDA.w ClearLayer3_VRAM_Inc_Value,X
    STA $2115 ; VRAM Adress Increment Value
    LDA #$02
    STA $420B ; Start DMA
    DEX
    DEX
    BPL ClearLayer3_Loop
    PLP
    RTL

ClearLayer3_DMA_Params:
    DW $1908, $1808
ClearLayer3_WRAM_Address:
    DW #ClearLayer3_ClearTile+1, #ClearLayer3_ClearTile+0
ClearLayer3_VRAM_Inc_Value:
    DW $0080, $0000
ClearLayer3_ClearTile:
    DW $180F

; Added function
TransitionDMA_CalculateLayer2XPos:
    ; New entry point into 'Calculate layer 2 X position'
    ; Executes the transition DMA prior to the normal call
    PHP
    LDX $05BC
    BPL $05
    SEP #$60
    JSR ExecuteTransitionDMAWithoutBlank
    PLP

warnpc $80A2F9 : padbyte $FF : pad $80A2F9


;---------------------------------------
; Dynamically load FX/Message Graphics
;---------------------------------------

org $85808D
    JSR ClearLayer3ForMessageOpen ; 81F3 Clear message box BG3 tilemap
    NOP : NOP : NOP
org $8580AA
    JSR ClearLayer3ForMessageClose ; 81F3 Clear message box BG3 tilemap
org $8580E8
    JSR ClearLayer3ForMessageClose ; 81F3 Clear message box BG3 tilemap


org $859650
; Instead of always clearing the screen, it swaps the bottom rows
; of the graphics with the textbox letters with the FX graphics
ClearLayer3ForMessageClose:
    LDA $196E ; FX type
    BEQ ClearLayer3_Return ; FX type = 0x00 (none)
    CMP #$0026
    BEQ ClearLayer3_WaterAddress ; FX type = 0x26 (golden statues room)
    CMP #$000C
    BEQ ClearLayer3_FogAddress ; FX type = 0x0C (fog)
    CMP #$000E
    BEQ ClearLayer3_StarsAddress ; FX type = 0x0E (stars)
    BCS ClearLayer3_Return  ; FX type > 0x0C (ceres/haze)
    CMP #$0006
    BEQ ClearLayer3_WaterAddress ; FX type = 0x06 (water)
    LDX $1F17 ; pointer to ram address to dma
    DEX
    DEX
    LDA $870000,X
    STA $4302 ; set dma ram address
    LDX $1F3B ; X = dma size
    CLC
    BRA ClearLayer3_ContinueDMA
ClearLayer3ForMessageOpen:
    JSR $8136 ; wait frame
    REP #$20
    JSR $81B7 ; backup BG3

    JSR $81F3 ; clear BG3
    JSR $8143 ; setup PPU
    LDX #$C000 ; DMA ram address size
    SEC
    BRA ClearLayer3_WriteDMAAddress
ClearLayer3_FogAddress:
    LDX #$C400 ; DMA ram address size
    BRA ClearLayer3_WriteDMAAddress
ClearLayer3_StarsAddress:
    LDX #StarsGFX
    CLC
    BRA ClearLayer3_WriteDMAAddress
ClearLayer3_WaterAddress:   
    LDX #$C200 ; DMA ram address size
ClearLayer3_WriteDMAAddress:
    STX $4302 ; set DMA ram address
    LDX #$0200 ; X = dma size
ClearLayer3_ContinueDMA:
    STX $4305 ; set DMA size
    LDX #$4700
    STX $2116 ; set dma VRAM address
    LDX #$1801
    STX $4300 ; set dma mode/address
    SEP #$20

    LDA #$9A
    BCS ClearLayer3_SetBank
    LDA #$87
ClearLayer3_SetBank:
    STA $4304 ; set dma ram bank (9A on open, 87 on close)

    LDA #$80
    STA $2115 ; VRAM address increment value
    LDA #$01
    STA $420B ; start DMA (channel 0)
ClearLayer3_Return:
    RTS


org $8581B5 ; Don't backup BG3 after the tilemap is cleared
    BRA InitPPU_Return ; REP #$20
org $8581EA
InitPPU_Return:

org $858651 ; restore BG3 and PPU on the same frame
    NOP : NOP : NOP ; JSR $8136 ; Wait for lag frame

; load FX
org $89AC31
    JSR Load_FX ; LDA $ABF0,y FX tilemap pointer = [$ABF0 + [FX type]]

; free space in Bank 89
org $89AF00 ; A = FX type
Load_FX:
    CMP #$0026
    BEQ LoadFX_Water ; type = golden statues
    CMP #$000E
    BEQ LoadFX_Stars ; type = stars
    CMP #$000C
    BEQ LoadFX_Fog ; type = fog
    CMP #$0006
    BEQ LoadFX_Water ; type = water
    BRA LoadFX_Return ; else
LoadFX_Stars:
    LDA #$87CC
    BRA LoadFX_Continue
LoadFX_Fog:
    LDA #$9AC4
    BRA LoadFX_Continue
LoadFX_Water:
    LDA #$9AC2
LoadFX_Continue:
    STA $05C1 ; dma ram address
    LDA #$0047
    STA $05BF ; dma vram address
    LDA #$0200
    STA $05C3 ; dma size
    LDA #$0080
    STA $05BD ; queue transition dma

LoadFX_Return:
    CPY #$0008
    BNE GetNormalFXTilemapPointer
    LDA $197E  ; FX3 'C'. Bitflags: $01 = FX3 flows left, $02 = bg heat effect, $04 = 'line shift'? (Water does not affect Samus), $08 = unknown, $20 = Big FX3 tide, $40 = Small FX3 tide (priority over 6)
    BIT #$0002 ; Check for 'heat' bit
    BEQ GetNormalFXTilemapPointer

GetSnowFXTilemapPointer:
    LDA #SnowTTB
    RTS

GetNormalFXTilemapPointer:
    LDA $ABF0,y
    RTS


;----------------------------
; Repoint Data
;----------------------------

; move titlescreen gfx data
org $818E34
    DL FileSelect_BG1_GFX ;B6C000

; Change Graphics DMA size to not get the bottom row of 1 screen
org $828ED1
    DW $0E00   ; 2000

; animated tile object for FX
; modify the VRAM destination to match the rearranged tilemap (bottom row)
org $8782AF ; lava
    DW $4700 ; 4280
org $8782CD ; acid
    DW $4700 ; 4280
org $8782EB ; rain
    DW $4700 ; 4280
org $878301 ; spores
    DW $4700 ; 4280

org $8782FD ; spores
    DW #SnowAnimation, $0030, $4700

; The PB/CF HDMA tables are shortened in order to make more space in WRAM
; for the added row of the HUD tilemap.
org $888B18 ; pb explosion 
    STA $7EC5C6 ; 7EC606
    LDA #$00
    STA $7EC5C7 ; 7EC607
org $88A2E8 ; crystal flash
    STA $7EC5C6 ; 7EC606
    LDA #$00
    STA $7EC5C7 ; 7EC607

;----------------------------
; Rearranged tiles
;----------------------------

; 'blank' tile when clearing layer 3 during pause
org $80A214
    LDA #$180F ; 184E


; 'blank' tile when clearing layer 3
org $81A7AE
    LDA #$280F ; 2801

; 'blank' tile for load map
org $829580
    ;LDA #$000E ; 000F

; 'blank' tile for clearing layer 3 (BG Data Instruction)
org $82E569
    LDA #$180F ; 184E

; 'blank' tile when clearing layer 3 (message box)
org $85823F
    DW $1C0F ; $000E


; Message box button text table
org $858426
    DW $28C0 ;$28E0, ; A
    DW $28C1 ;$3CE1, ; B
    DW $28D7 ;$2CF7, ; X
    DW $28D8 ;$38F8, ; Y
    DW $28FA ;$38D0, ; Select
    DW $28CB ;$38EB, ; L
    DW $28D1 ;$38F1, ; R
    DW $280F ;$284E  ; Blank

; Digit tilemap on HUD because the numbers are moved
org $809DBF
; Health
    DW $3C00, $3C01, $3C02, $3C03, $3C04, $3C05, $3C06, $3C07, $3C08, $3C09
; Ammo
    DW $3C00, $3C01, $3C02, $3C03, $3C04, $3C05, $3C06, $3C07, $3C08, $3C09

;org $858000
;    ; large message box border
;    DW $000E, $000E, $000E, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F
;    DW $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $000E, $000E, $000E
;    ; small message box border
;    DW $000E, $000E, $000E, $000E, $000E, $000E, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F
;    DW $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $2C0F, $000E, $000E, $000E, $000E, $000E, $000E, $000E
