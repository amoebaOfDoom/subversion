lorom

;org $B4F1C8: ; Vuln table
;    DB $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $82, $82, $80, $80, $80, $80, $80, $02, $80, $02

;0xEC7F
;0xEC3F

org $86BE89:
    ; turret X positions
    ;DW $0398, $0348, $0328, $02D8, $0288, $0268, $0218, $01C8, $01A8, $0158, $0108, $00E8
    DW $0398, $0348, $0328, $02D8, $0288, $0268, $0218, $01C8, $0378, $0238, $0108, $00E8
    ; turret Y positions
    ;DW $0030, $0040, $0040, $0030, $0040, $0040, $0030, $0040, $0040, $0030, $0040, $0040
    DW $0030, $0040, $0040, $0030, $0040, $0040, $0030, $0040, $00C0, $00C0, $0050, $0040

 org $86BEE1:
    ; turret initial directions
    ;DW $0003, $0004, $0002, $0003, $0004, $0002, $0003, $0004, $0002, $0003, $0004, $0001
    DW $0003, $0004, $0002, $0003, $0004, $0002, $0003, $0004, $0006, $0006, $0004, $0001


org $86BF39:
    DB $00, $00, $00, $00, $01, $01, $01, $01
org $86BF41:
    DB $00, $00, $00, $00, $01, $01, $01, $01
org $86BF49:
    DB $00, $00, $01, $01, $01, $00, $00, $00

org $86C194
    DW $4001 ; turret shot damage

org $A986EB
    JSR BodyInitCheckPhase1Destroyed
    BCC +
    RTL
    NOP
+
    ;LDA #$0001
    ;JSL $89AB02

org $A9888F:
    NOP : NOP : NOP : NOP ;JSL $89AB02

org $ADE3BE
    JSL $8483D7
        DB $0F, $05
        DW $B673
    NOP : NOP : NOP : NOP ;JSL $8483D7
    NOP : NOP ;DB $0F, $09
    NOP : NOP ;DW $B673  

org $8494A3:
    DW $8005, $8B0F, $8B0F, $8AE8, $82E8, $830F
    DW $0000

;             dx 8002, 8340, 830F
;                        00, FF
;                        8001, 8B0F
;                        0000

org $A987F7
     NOP : NOP ;BPL $1F ; branch if Samus isn't on screen 0

org $A987FE
    LDA #$0001
    STA $7E783A ; Causes turrets to be deleted
    STA $7E7800 ; Mother Brain form = fake death
    LDA #$881D
    STA $0FA8
    LDA #$001B
    JSL $8081FA
    NOP : NOP
    ;JSL $90A7E2 ; Disable mini-map and mark boss room map tiles as explored
    ;LDA #$0006
    ;JSL $808FC1 ; Queue song 1 music track
    ;JSL $ADE396 ; Seal Mother Brain's wall, function = $881D

org $ADE3CE
    RTL
    ;LDA #$881D
    ;STA $0FA8 ; Mother Brain' body function = $881D
    ;RTL

org $A98832
    NOP : NOP : NOP : NOP ;JSL $90F084 ; Lock Samus

org $A9883D
    NOP : NOP : NOP : NOP ;STA $7ECD20 ; Scroll 1 = red

org $A98852
    LDA $0E52
    NOP : NOP : NOP : NOP ;JSL $808FC1 ; Queue music track 0
    STA $0E50 ;LDA #$FF21
    NOP : NOP : NOP : NOP ;JSL $808FC1 ; Queue Mother Brain music data

org $A98874 
    NOP : NOP : NOP : NOP ;JSL $90F084 ; Unlock Samus

org $A98C0C
    STZ $18B6 ;STZ $18B4 ; Disable HDMA object 0
    STZ $18B8 ;STZ $18B6 ; Disable HDMA object 1

org $A98D49
    ;LDA #$001C
    ;STA $1982 ; Default layer blending configuration = 34h (disables colour math on BG2/BG3)

org $A98C2A
    LDA #$8C9D ;LDA #$8C87
    STA $0FA8 ; Mother Brain's body function = $8C87

; Line 0: Room background (BG1/2 palette 3 colours 4..Fh)
; Line 1: Room level graphics (BG1/2 palette 5/7 colours 3..Eh)
org $A9D082
    DW $4A16, $3991, $2D2C, $1CA7, $20E5, $18A4, $1083, $0841, $7FFF, $0000, $02DF, $0000
    DW $0802, $5294, $39CE, $2108, $1084, $0019, $0012, $5C00, $4000, $1084, $197F, $7FFF
org $A9D0B2
    DW $4A36, $39B2, $2D4D, $20C8, $2506, $1CC5, $14A4, $0C62, $7FFF, $0421, $06DF, $0421
    DW $254C, $3DEF, $2D6B, $18C6, $0C63, $0013, $000E, $4400, $3000, $0C63, $1517, $5EF7
org $A9D0E2
    DW $4A37, $3DB2, $314D, $20E9, $2527, $1CE6, $14C5, $0C83, $7FFF, $0442, $06FF, $0442
    DW $3EB5, $294A, $1CE7, $1084, $0842, $000D, $0009, $3000, $2000, $0842, $0CD0, $4210
org $A9D112
    DW $4A57, $3DD3, $316E, $250A, $2948, $2107, $18E6, $10A4, $7FFF, $0863, $0AFF, $0863
    DW $5BFF, $14A5, $1084, $0842, $0421, $0006, $0005, $1800, $1000, $0421, $0868, $2108



org $A9870E
    LDA.w #100
;$A9:870E A9 B8 0B    LDA #$0BB8             ;\
;$A9:8711 8D CC 0F    STA $0FCC  [$7E:0FCC]  ;} Mother Brain's brain health = 3000

;$A9:8D67 A9 50 46    LDA #$4650             ;\
;$A9:8D6A 8D CC 0F    STA $0FCC  [$7E:0FCC]  ;} Mother Brain's brain health = 18,000

;$A9:BFB0 A9 A0 8C    LDA #$8CA0
;$A9:BFB3 8D CC 0F    STA $0FCC  [$7E:0FCC]

org $A9B2C2
    LDY #$B2F9 ;LDY #$B2D1
org $A9B2CA
    LDY #$B2F9

org $A9B2F9
    JSL $A9B346 ; Generate escape door explosion
    DEC $0FB2   ; Decrement Mother Brain's body function timer
    BPL .return ; If [Mother Brain's body function timer] >= 0: return
    JSL $81FAA5 ; Incremment kill count (challenges.asm)
    ;LDA #$000F
    ;JSL $90F084 ; Setup timer
    LDA #$8000
    TRB $0943 ; run Zebes escape timer
    JSR EraseLayer3Timer
    LDA #$0002
    JSL $8081A6
    STA $7ECADE ; BG3 Y position (except during HUD drawing)
    ;LDA #$000E
    ;JSL $8081FA ; set event bit E
    LDA #$B32A
    STA $0FA8
    LDA #$0000
    STA $0FF0
    STA $0FF2
.return    
    RTS
warnpc $A9B32B

org $A9B60A
    LDA #$C1CF ;#$B8EB
    STA $0FA8
    JMP Phase3Init ;$B8EB

org $A98750
    LDA #$A900
    STA $0605
    LDA #UnpauseHook
    STA $0604
    RTL

org $A9B4BB
    JMP BrainCollisionHit;CMP #$0004
BrainCollisionHit_Next:

org $A9FB70: ; free space
BodyInitCheckPhase1Destroyed:
    STZ $16BA
    LDA #$0038 ;hard mode
    JSL $808233
    BCC +
    INC $16BA
+
    STZ $16BC

    LDA #$001B
    JSL $808233
    BCC BodyInitCheckPhase1Destroyed_Exit

    LDA #$0001
    STA $7E783A ; Causes turrets to be deleted
    STA $7E7800 ; Mother Brain form = fake death

    LDA #$0007
    JSL $ADEEDE ; load grey palette

    LDA #BodyInitCheckPhase1Destroyed_2
    STA $0FA8

BodyInitCheckPhase2_Ready:
    LDA #$000E
    JSL $808233
    BCC BodyInitCheckPhase1Destroyed_Exit

    LDA #BodyInitCheckPhase2_Ready_2
    STA $0FA8
    SEC


BodyInitCheckPhase1Destroyed_Exit:
    RTS

BodyInitCheckPhase1Destroyed_2:
    LDA #$00C4
    STA $0FBE ; Mother Brain's brain Y position = C4h
    LDA #$003B
    STA $0F7A ; Mother Brain's body X position = 3Bh
    LDA #$0117
    STA $0F7E ; Mother Brain's body Y position = 117h
    JSR $903F ; Execute $903F
    LDA #$8C9D
    STA $0FA8
    RTS

BodyInitCheckPhase2_Ready_2:
    JSR BodyInitCheckPhase1Destroyed_2
    LDA #BodyInitCheckPhase2_Ready_3
    STA $0FA8
    RTS

BodyInitCheckPhase2_Ready_3:
    LDA $0AF6
    CMP #$00EC
    BPL BodyInitCheckPhase2_Ready_3_Exit
    JSL $90A7E2 ; Disable mini-map and mark boss room map tiles as explored
    LDA #$0006
    JSL $808FC1 ; Queue song 1 music track
    JSL $ADE396 ; Seal Mother Brain's wall, function = $881D
    LDA #$0000
    JSL $90F084 ; Lock Samus
    LDA #$0001
    STA $7ECD20 ; Scroll 1 = red
    LDA #$0000
    JSL $808FC1 ; Queue music track 0
    LDA #$FF21
    JSL $808FC1 ; Queue Mother Brain music data
    JSL $8882AC ; Delete HDMA objects
    JSL $878016 ; Clear animated tiles objects
    STZ $196E ; FX Type
    LDA $0FC6 ;Properties (Special in SMILE) for brain
    AND #$7FFF
    STA $0FC6
    LDA #$003C
    STA $0FB2
    LDA #BodyInitCheckPhase2_Ready_4
    STA $0FA8
BodyInitCheckPhase2_Ready_3_Exit:
    RTS

BodyInitCheckPhase2_Ready_4:
    DEC $0FB2
    BPL BodyInitCheckPhase2_Ready_4_Exit
    LDA #$0001
    JSL $90F084 ; Unlock Samus
    ;LDA #$000F
    ;STA $196E ; FX Type
    LDA #BodyInitCheckPhase2_Ready_5
    STA $0FA8
BodyInitCheckPhase2_Ready_4_Exit:
    RTS

BodyInitCheckPhase2_Ready_5:
    LDX #TimerTilesTransferEntries
    JSR $C5BE
    BCC BodyInitCheckPhase2_Ready_5_Exit
    LDA #$0044
    STA $7ECADC ; BG3 X position (except during HUD drawing)
    LDA #$00FF
    STA $7ECADE ; BG3 Y position (except during HUD drawing)
    JSL $88D865 ; Spawn BG3 scroll HDMA object
    LDA #$0003
    LDY #ColorsForLayer3Timer
    LDX #$0002 ;LDX #$0032
    JSL $A9D2E4
    LDA #$8000
    TSB $0943
    LDA #$0034
    STA $1982
    LDA #$8C87
    STA $0FA8
    INC $16BC
BodyInitCheckPhase2_Ready_5_Exit:
    RTS

ReloadTimer:
    PHB
    PHK
    PLB
    PHX
    PHY
ReloadTimer_Loop:
    LDX #TimerTilesTransferEntries
    JSR $C5BE
    BCC ReloadTimer_Loop
    PLY
    PLX
    PLB
    RTL

UnpauseHook:
    LDA $7E7844
    BEQ +
    JSL $A98763
+
    LDA $0943
    BPL +
    JSL ReloadTimer
+
    RTL

EraseLayer3Timer:
    LDX #EraseTimerTilesTransferEntries
    JSR $C5BE
    BCC EraseLayer3Timer
    RTS

ColorsForLayer3Timer:
    DW #$7F5A, #$033B, #$2484

TimerTilesTransferEntries:
;       ___________________________ Size. Zero terminator
;      |           ________________ Source address
;      |          |             ___ VRAM address
;      |          |            |
    DW $0190 : DL #TimerGraphics : DW $4700 ; Timer number tiles

    ; Clear layer 3 tilemap with transparent
    DW $0200 : DL #ClearLayer3Tilemap : DW $5C00
    DW $0200 : DL #ClearLayer3Tilemap : DW $5D00
    DW $0200 : DL #ClearLayer3Tilemap : DW $5E00
    DW $0200 : DL #ClearLayer3Tilemap : DW $5F00

    DW $0006 : DL #TimeLayer3Tilemap : DW $5C80
    DW $0010 : DL #TickMarksLayer3Tilemap : DW $5CA0

    DW $0000

EraseTimerTilesTransferEntries:
    DW $0200 : DL #ClearLayer3Tilemap : DW $5C00
    DW $0000

BrainCollisionHit:
    PHA
    LDA $0FC6 ;Properties (Special in SMILE) for brain
    BMI BrainCollisionHit_Solid
    PLA
    CMP #$0004
    LDA #$0004
    JMP BrainCollisionHit_Next
BrainCollisionHit_Solid:
    PLA
    LDA #$0040
    STA $0E54
    JSL $A08028
    STZ $0E54
    SEC
    RTS

Phase3Init:
    JSR $D1F8 ; Set up Mother Brain's brain normal palette
    JSR $BCCE ; Write Mother Brain default palette
    LDX #$8FC7
    JSR $C5BE
    LDA #$0000
    STA $7E802E
    LDA #$0000
    STA $7E7854
    LDA #$8CA0
    STA $0FCC ; set MB3 health

    STZ $0FDC
    LDA #$0001
    STA $7E7860 ; enable palette processing for head
    STA $7E7862 ; enable health based palette for body
    LDA #$0000
    STA $7E8004
    LDA #$0002
    STA $7E783E

    LDA #$000C
    STA $00
    LDA #$0042
    STA $02
    JSL ActivateLaser

    ;JSL $ADF24B
    ;LDA #$0003
    ;JSL $91E4AD

    RTS

ActivateLaser:
    PHX
    PHY
    LDX $02
    INC $1D77,X

    LDA $07A5
    LDY #$000D
    JSL $8082D6
    LDA $05F1
    CLC
    ADC $00
    ASL
    TAX
    LDA #$0000
    STA $7F0002,X
    LDA $7F6402,X
    AND #$FF00
    STA $7F6402,X

    LDA $07A5
    LDY #$0002
    JSL $8082D6
    LDA $05F1
    CLC
    ADC $00
    ASL
    TAX
    LDA #$0000
    STA $7F0002,X
    LDA $7F6402,X
    AND #$FF00
    STA $7F6402,X

    LDA #$00D8
    STA $14
    LDA #$00C8
    STA $12
    LDA $00
    LDY #$E509
    JSL $868097

    LDA #$0028
    STA $14
    LDA #$00C8
    STA $12
    LDA $00
    LDY #$E509
    JSL $868097

    PLY
    PLX
    RTL

Ketchup3:
    LDA $0FCC
    BNE $07
    LDA #$AEE1
    STA $0FA8
    RTS

    JSR $B87D
    LDA $0FA8
    CMP #$B605
    LDA #Ketchup3
    BEQ Ketchup3_Exit
    LDA #$C209
Ketchup3_Exit:
    STA $0FA8
    RTS

Ketchup3_Test:
    LDA $05E5
    AND #$0F00
    CMP #$05FF
    LDY $0A76
    BEQ +
    CMP #$02FF
+
    BCC Ketchup3_Test_Normal
    LDA #Ketchup3
    STA $0FA8
    RTS
Ketchup3_Test_Normal:
    LDY #$9F00
    JMP $C22F

CheckHyper:
    LDA $0C2C,y  ;\
    CMP.w #1000
    BMI .return
    PLA
    LDA #$0004
    RTS
.return
    LDA $0C19,y
    RTS


org $A9C22C
    JMP Ketchup3_Test;LDY #$9F00
    ;LDA $05E5
    ;AND #$00FF
    ;CMP #$0080
    ;BCC $03
    ;LDY #$9DBB

org $A9B569
    NOP : NOP ; BNE $0B
    JSR $B58E              ;\
    CMP #$0004 ; #$0002    ;} If shot with beam:
org $A9B593
    JSR CheckHyper ; LDA projectile_type+1,y

org $B0EE00
TimerGraphics:
    incbin ROMProject/Graphics/Layer3Timer.gfx
TimeLayer3Tilemap:
    DW #$20F6, #$20F7, #$20F8
TickMarksLayer3Tilemap:
    DW #$200E, #$200E, #$20F4, #$200E, #$200E, #$20F5, #$200E, #$200E
ClearLayer3Tilemap:
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E
    DW #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E, #$000E

org $809E14
    LDA #$0003 ;LDA #$8003
    ;STA $0943
org $809E27
    LDA #$0003 ;LDA #$8003
    ;STA $0943

org $809F6C
DrawTimer:
    PHB
    PHK
    PLB
    PHY
    LDA $0943
    BMI +
    JSR DrawTimerSprites
    BRA DrawTimer_Exit
+
    JSR DrawTimerTilemap
DrawTimer_Exit:
    PLY
    PLB
    RTL

org $80CDC0 ; free space
DrawTimerSprites:
    LDY #$A060
    LDA #$0000
    JSR $9FB3 ; Draw TIME
    LDA $0947
    LDX #$FFE4
    JSR $9F95 ; Draw minutes
    LDA $0946
    LDX #$FFFC
    JSR $9F95 ; Draw seconds
    LDA $0945
    LDX #$0014
    JSR $9F95 ; Draw centiseconds
    RTS
DrawTimerTilemap:
    LDA $16BC
    BEQ +
    LDA $16BA
    BNE +
    LDA $0946
    CMP #$0726
    BPL +
    INC $16BA
    LDA #$000E
    STA $00
    LDA #$0044
    STA $02
    JSL ActivateLaser
+
    LDA $0947
    LDX #$0000
    JSR DrawTwoDigits ; Draw minutes
    LDA $0946
    LDX #$0006
    JSR DrawTwoDigits ; Draw seconds
    LDA $0945
    LDX #$000C
    JSR DrawTwoDigits ; Draw centiseconds
    LDA #$20F4
    STA $16FE ; Draw '
    LDA #$20F5
    STA $1704 ; Draw "
    LDA #$200E
    STA $171E ; Blank
    STA $1724 ; Blank

    ; Setup DMA to update the layer 3 tilemap during NMI
    LDX $0330
    LDA #$0010 ;Graphics copy size 0
    STA $D0,x
    STA $D7,x
    LDA #$16FA
    STA $D2,x ;Graphics copy source address 0
    LDA #$171A
    STA $D9,x ;Graphics copy source address 1
    SEP #$20
    LDA #$7E
    STA $D4,x ;Graphics copy source bank 0
    STA $DB,x ;Graphics copy source bank 1
    REP #$20
    LDA #$5CA0
    STA $D5,x ;Graphics copy target address 0
    LDA #$5CC0
    STA $DC,x ;Graphics copy target address 1

    TXA
    CLC
    ADC #$000E
    STA $0330
    RTS
DrawTwoDigits:
    PHA
    AND #$00F0
    LSR
    LSR
    LSR
    LSR
    TAY
    CLC
    ADC #$20E0 ; tile for 0 top
    STA $16FA,x
    TYA
    CLC
    ADC #$20EA ; tile for 0 bottom
    STA $171A,x
    PLA
    AND #$000F
    TAY
    CLC
    ADC #$20E0 ; tile for 0 top
    STA $16FC,x
    TYA
    CLC
    ADC #$20EA ; tile for 0 bottom
    STA $171C,x
    RTS


org $888153
    JMP LayerBlend34
    ;LDY #$06
    ;RTS
org $88F890 ; free space
LayerBlend34:
    LDY #$06
    LDA #$17
    STA $69
    STZ $6B
    RTS

org $90E8DC
    PHP
    PHB
    PHK
    PLB
    REP #$30
    JSR HandleSamusLocked
    PLB
    PLP
    RTL

org $90FFA0 ;free space
HandleSamusLocked:
    STZ $0A6E
    JSL $90A91B
    LDA $0A5A
    CMP #$E09B
    BEQ HandleSamusLocked_Timer
    CMP #$E0C5
    BEQ HandleSamusLocked_Timer
    CMP #$E0E6
    BEQ HandleSamusLocked_Timer
    CMP #$E114
    BEQ HandleSamusLocked_Timer
    RTS
HandleSamusLocked_Timer:
    JSR $E097
    RTS

;Zebetite (enemy version) configuration
org $A6FC03
;      None   1      2      1+2
    DW $0000, $0000, $0000, $8000 ; $0FB2
    DW $0000, $0000, $0000, $0008 ; Height
    DW $0000, $0000, $0000, $FDEA ; Instruction pointer
    DW $0000, $0000, $0000, $0278 ; X position
    DW $0000, $0000, $0000, $0047 ; Y position - enemy Speed = 0
    DW $0000, $0000, $0000, $0097 ; Y position - enemy Speed != 0

org $A6FD5E
    LDA $7EC400
    BNE ZebititeColor_Exit
    LDX $0E54
    LDA $0FB4,X
    BNE ZebititeColor_Exit
    LDA $7EC2F2
    STA $00
    LDA $7EC2F0
    STA $02
    LDY #$0000
    LDX #$0158 ; Sprite palette 2 color C
    LDA #$0002 ; 2 colors
    JSL $A9D2E4 ; write colors
ZebititeColor_Exit:
    RTS


org $A6FBA5
    LDA #$0003
    JSL $808233
    BCC +
    JMP $FBCC
+
    LDA #$0003
    JMP $FBD6

org $A6FC75 ; Zebetite enemy doens't gain HP
    NOP ;CLC
    NOP : NOP : NOP ;ADC #$0001

org $A6FC9F : JSR NoMarkKill ; LDA #$0000

org $A6FFE8
NoMarkKill:
    LDA $7ED842
    DEC : DEC
    STA $7ED842
    LDA #$0000 ; displaced
    RTS

org $84FF08
    DW $C7B1, ZebetiteInstructionList

ZebetiteInstructionList:
    DW $8A72, ZebetiteDelete; if door bit go to
    DW $8A24, ZebetiteHit_1 ; Link instruction
    DW $86C1, $BD50 ; Pre-instruction = go to link instruction if shot with a (super) missile
    DW $0001, ZebetiteTileMap_1
    DW $86B4 ; Sleep

org $84F9A0
ZebetiteHit_1:
    DW ZebetiteHitCounter ;$8A91
        DB $03
        DW Zebetite_2 ; Increment door hit counter; go to if [door hit counter] >= set hits
    DW $8C19
        DB $09 ; Queue sound 9, sound library 3, max queued sounds allowed = 6 (missile door shot with missile)
    DW $0003, ZebetiteTileMap_1F
    DW $0004, ZebetiteTileMap_1
    DW $0003, ZebetiteTileMap_1F
    DW $0004, ZebetiteTileMap_1
    DW $0003, ZebetiteTileMap_1F
    DW $0004, ZebetiteTileMap_1
    DW $86B4

Zebetite_2:
    DW $8A24, ZebetiteHit_2 ; Link instruction
    DW $0001, ZebetiteTileMap_2
    DW $86B4
ZebetiteHit_2:
    DW ZebetiteHitCounter
        DB $06
        DW Zebetite_3
    DW $8C19
        DB $09
    DW $0003, ZebetiteTileMap_2F
    DW $0004, ZebetiteTileMap_2
    DW $0003, ZebetiteTileMap_2F
    DW $0004, ZebetiteTileMap_2
    DW $0003, ZebetiteTileMap_2F
    DW $0004, ZebetiteTileMap_2
    DW $86B4

Zebetite_3:
    DW $8A24, ZebetiteHit_3
    DW $0001, ZebetiteTileMap_3
    DW $86B4
ZebetiteHit_3:
    DW ZebetiteHitCounter
        DB $09
        DW Zebetite_4
    DW $8C19
        DB $09
    DW $0003, ZebetiteTileMap_3F
    DW $0004, ZebetiteTileMap_3
    DW $0003, ZebetiteTileMap_3F
    DW $0004, ZebetiteTileMap_3
    DW $0003, ZebetiteTileMap_3F
    DW $0004, ZebetiteTileMap_3
    DW $86B4

Zebetite_4:
    DW $8A24, ZebetiteHit_4 ; Link instruction
    DW $0001, ZebetiteTileMap_4
    DW $86B4
ZebetiteHit_4:
    DW $8A91 ;Increment door hit counter; Set room argument door and go to if [door hit counter] >= set hits
        DB $0C
        DW ZebetiteDestroy
    DW $8C19
        DB $09
    DW $0003, ZebetiteTileMap_4F
    DW $0004, ZebetiteTileMap_4
    DW $0003, ZebetiteTileMap_4F
    DW $0004, ZebetiteTileMap_4
    DW $0003, ZebetiteTileMap_4F
    DW $0004, ZebetiteTileMap_4
    DW $86B4

ZebetiteDestroy:
    DW $8C10
        DB $24 ; Queue sound 24, sound library 2, max queued sounds allowed = 6
    DW ZebetiteExplode
ZebetiteDelete:
    DW $0001, ZebetiteTileMap_5
    DW $86BC ; Delete

ZebetiteTileMap_1:
    DW $8003, $C045, $D045, $D045, $0000
ZebetiteTileMap_1F:
    DW $8003, $C049, $D049, $D049, $0000
ZebetiteTileMap_2:
    DW $8003, $C046, $D046, $D046, $0000
ZebetiteTileMap_2F:
    DW $8003, $C04A, $D04A, $D04A, $0000
ZebetiteTileMap_3:
    DW $8003, $C047, $D047, $D047, $0000
ZebetiteTileMap_3F:
    DW $8003, $C04C, $D04C, $D04C, $0000
ZebetiteTileMap_4:
    DW $8003, $C048, $D048, $D048, $0000
ZebetiteTileMap_4F:
    DW $8003, $C04D, $D04D, $D04D, $0000
ZebetiteTileMap_5:
    DW $8003, $00FF, $00FF, $00FF, $0000

ZebetiteHitCounter:
    LDA $7EDF0C,X
    INC
    STA $7EDF0C,X ; Increment PLM hit counter
    SEP #$20
    CMP $0000,Y
    REP #$20
    BCS ZebetiteHitEnough ; branch if hit enought times
    INY
    INY
    INY
    RTS
ZebetiteHitEnough:
    INY
    JMP $8724  ; Instruction - go to [[Y] + 1]

ZebetiteExplode:
    PHY
    PHX
    JSL $848290
    LDA $1C2B ; Y
    INC
    ASL
    INC
    ASL
    ASL
    ASL
    STA $14
    LDA $1C29 ; X
    ASL
    INC
    ASL
    ASL
    ASL
    STA $12
    LDA #$000C
    LDY #$E509
    JSL $868097
    PLX
    PLY
    RTS

HitBySupers:
    STA $7EDF0C,X
    JMP $BD62
warnpc $84FCBF

org $84BD7F
    LDA $7EDF0C,X
    INC
    INC
    JMP HitBySupers
    ;LDA #$0077
    ;STA $7EDF0C,X
    ;BRA $DA


;org $A0D245
;    DW $0004 ;rinka contact damage

;org $B4F374
;    DB $10, $40, $7F, $00, $30, $00

org $A2B960
    JSR RinkaShot ; LDA $0F8C,x

org $A2F580
RinkaShot:
    PHX
    PHY
    LDX $0E54
    LDA $0F8C,X
    BNE RinkaShot_Exit

    JSL $81FAA5 ; Incremment kill count (challenges.asm)

    LDA $0FB4,X
    BEQ RinkaShot_Exit
    LDA $0F7A,X
    STA $12
    LDA $0F7E,X
    STA $14
    LDA #$D23F
    JSL $A0920E

RinkaShot_Exit:
    PLY
    PLX
    LDA $0F8C,x ; displaced
    RTS


; glass tank skip area boss dead check
org $84D6E0
    DW $D207
