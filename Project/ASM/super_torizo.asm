lorom 

!enemy_index       = $0E54
!enemy_id          = $0F78
!enemy_X           = $0F7A
!enemy_X_sub       = $0F7C
!enemy_Y           = $0F7E
!enemy_Y_sub       = $0F80
!enemy_prop1       = $0F86
!enemy_param1      = $0FB4
!enemy_health      = $0F8C
!enemy_timer       = $0F90
!enemy_instruction = $0F92
!enemy_inst_timer  = $0F94
!enemy_palette     = $0F96
!enemy_tiles       = $0F98

!enemy_var0        = $0FA8
!enemy_var1        = $0FAA
!enemy_var2        = $0FAC
!enemy_var3        = $0FAE
!enemy_var4        = $0FB0
!enemy_exvar07     = $7E780E
!enemy_exvar30     = $7E8020
!enemy_exvar31     = $7E8022

!samus_x           = $0AF6
!samus_y           = $0AFA
!samus_pose        = $0A1C

!proj_index        = $1991
!proj_id           = $1997
!proj_var0         = $1AB7
!proj_var1         = $1ADB
!proj_var2         = $1AFF
!proj_var3         = $1B23
!proj_instruction  = $1B47
!proj_inst_timer   = $1B8F
!proj_x_sub        = $1A27
!proj_x            = $1A4B
!proj_y_sub        = $1A6F
!proj_y            = $1A93

!frame_count       = $05B6


org $86F5D0 ; freespace

; Enemy projectile - Homing Missile ;;;
Missile_Header:
    DW #Missile_Init
    DW #Missile_Main
    DW #MissileInst_Up ; initial inst
    DB $04 : DB $04 ; size
    DW $8096 ; prop
       ;  v & FFFh: Damage
       ; 8000h: Detect collisions with projectiles
       ; 4000h: Don't die on contact
       ; 2000h: Disable collisions with Samus
       ; 1000h: Priority
    DW $B2EF ; hit samus = ExplodeInstruction
    DW $B2EF ; shot      = ExplodeInstruction


Missile_Init:
    LDX !enemy_index
    LDA !enemy_X,X
    STA $12
    LDA !enemy_Y,X
    STA $14

    BIT !enemy_param1,X ; facing direction
    BMI +
    LDX #$0000
    BRA ++
+
    LDX #$0002
++

    LDA MissileOffset_X,X
    CLC : ADC $12
    STA !proj_x,Y
    LDA #$FFD8
    CLC : ADC $14
    STA !proj_y,Y

    JSL $808111
    AND #$01FF
    SEC : SBC #$0100
    CLC : ADC MissileSpeedInit_X,X
    STA !proj_var0,Y

    JSL $808111
    AND #$00FF
    SEC : SBC #$0380
    STA !proj_var1,Y

    LDA #$0000
    STA !proj_var3,Y

    TYX
    JSR DecellerateToStop
    RTS

MissileOffset_X:
    DW $FFE5, $001B
MissileSpeedInit_X:
    DW $FE00, $0200

print pc
DecellerateToStop:
    PHY
    LDA !proj_var0,X
    EOR #$FFFF
    INC
    STA $12
    LDA !proj_var1,X
    EOR #$FFFF
    INC
    STA $14
    JSL $A0C0AE ; get angle
    LDY !proj_index
    STA !proj_var2,Y
    ASL A
    TAX

    LDA $A0B443,x ; horizontal component
    LSR
    JSL $A0AFEA ; sign extend
    CLC : ADC !proj_var0,Y
    STA !proj_var0,Y

    LDA $A0B3C3,x ; vertical component
    LSR
    JSL $A0AFEA ; sign extend
    CLC : ADC !proj_var1,Y
    STA !proj_var1,Y

    ; check for stop
    LDA !proj_var0,Y
    JSL $A0B067 ; abs(A)
    CMP #$0090
    BPL +
    LDA !proj_var1,Y
    JSL $A0B067 ; abs(A)
    CMP #$0090
    BPL +
    LDA #$0001
    STA !proj_var3,Y ; change to accel to samus
+

    LDA !proj_var2,Y
    CLC : ADC #$0080
    AND #$00FF
    LSR : LSR : LSR : LSR : LSR : ASL
    TAX
    LDA MissileInstTable,X
    STA !proj_instruction,Y
    LDA #$0001
    STA !proj_inst_timer,Y

    TYX
    PLY
    RTS


AccellerateTowardsSamus:
    PHY
    LDA !samus_x
    SEC
    SBC !proj_x,x
    STA $12
    LDA !samus_y
    SEC
    SBC !proj_y,x
    STA $14
    JSL $A0C0AE ; get angle
    LDY !proj_index
    STA !proj_var2,Y
    ASL A
    TAX

    LDA #$0600
    STA $00
    LDA $A0B443,x ; horizontal component
    CLC : ADC !proj_var0,Y
    JSL ClampValue
    STA !proj_var0,Y

    LDA #$0600
    STA $00
    LDA $A0B3C3,x ; vertical component
    CLC : ADC !proj_var1,Y
    JSL ClampValue
    STA !proj_var1,Y

    LDA !proj_var2,Y
    LSR : LSR : LSR : LSR : LSR : ASL
    TAX
    LDA MissileInstTable,X
    STA !proj_instruction,Y
    LDA #$0001
    STA !proj_inst_timer,Y

    TYX
    PLY
    RTS

print pc
MoveProjectile:
    ; move X
    LDA !proj_var0,X
    XBA : AND #$FF00
    CLC : ADC !proj_x_sub,X
    STA !proj_x_sub,X
    LDA !proj_var0,X
    AND #$FF00
    XBA
    JSL $A0AFEA ; sign extend
    CLC : ADC !proj_x,X
    STA !proj_x,X

    ; move Y
    LDA !proj_var1,X
    XBA : AND #$FF00
    CLC : ADC !proj_y_sub,X
    STA !proj_y_sub,X
    LDA !proj_var1,X
    AND #$FF00
    XBA
    JSL $A0AFEA ; sign extend
    CLC : ADC !proj_y,X
    STA !proj_y,X

    ;LDA !proj_y,X
    LSR : LSR : LSR : LSR
    SEP #$20
    STA $4202
    LDA $07A5 ; room width
    STA $4203
    REP #$20
    LDA !proj_x,X
    LSR : LSR : LSR : LSR
    CLC
    ADC $4216
    ASL
    PHX
    TAX
    JSR $8886 ; check collision
    PLX
    BCC .return

    LDA #$B2EF ; ExplodeInstruction
    STA !proj_instruction,X
    LDA #$0001
    STA !proj_inst_timer,X

.return
    RTS


Missile_Main:
    LDA !frame_count
    AND #$0003
    BNE .return
    LDA !proj_var3,X
    BNE +
    JSR DecellerateToStop
    BRA .return
+
    JSR AccellerateTowardsSamus

.return
    JSR MoveProjectile
    RTS


MissileInstTable:
    DW #MissileInst_Up
    DW #MissileInst_UpRight
    DW #MissileInst_Right
    DW #MissileInst_DownRight
    DW #MissileInst_Down
    DW #MissileInst_DownLeft
    DW #MissileInst_Left
    DW #MissileInst_UpLeft


MissileInst_Up:
    DW $0002, #MissileOAM_Up
    DW $8159 ; sleep
MissileInst_UpRight:
    DW $0002, #MissileOAM_UpRight
    DW $8159 ; sleep
MissileInst_Right:
    DW $0002, #MissileOAM_Right
    DW $8159 ; sleep
MissileInst_DownRight:
    DW $0002, #MissileOAM_DownRight
    DW $8159 ; sleep
MissileInst_Down:
    DW $0002, #MissileOAM_Down
    DW $8159 ; sleep
MissileInst_DownLeft:
    DW $0002, #MissileOAM_DownLeft
    DW $8159 ; sleep
MissileInst_Left:
    DW $0002, #MissileOAM_Left
    DW $8159 ; sleep
MissileInst_UpLeft:
    DW $0002, #MissileOAM_UpLeft
    DW $8159 ; sleep


; ---------------------------------------


Hyper_Header:
    DW #Hyper_Init
    DW #Hyper_Main
    DW #HyperInst_DownLeft ; initial inst
    DB $08 : DB $08 ; size
    DW $512C ; prop
       ;  v & FFFh: Damage
       ; 8000h: Detect collisions with projectiles
       ; 4000h: Don't die on contact
       ; 2000h: Disable collisions with Samus
       ; 1000h: Priority
    DW $0000 ; hit samus = ExplodeInstruction
    DW $0000 ; shot      = ExplodeInstruction


Hyper_Init:
    LDX !enemy_index
    LDA !enemy_X,X
    STA $12
    LDA !enemy_Y,X
    STA $14

    BIT !enemy_param1,X ; facing direction
    BMI +
    LDX #$0000
    BRA ++
+
    LDX #$0002
++

    LDA HyperOffset_X,X
    CLC : ADC $12
    STA !proj_x,Y
    LDA #$FFE2
    CLC : ADC $14
    STA !proj_y,Y

    ; get angle
    LDA !samus_x
    SEC
    SBC !proj_x,Y
    STA $12
    LDA !samus_y
    SEC
    SBC !proj_y,Y
    STA $14
    JSL $A0C0AE ; get angle
    CLC : ADC #$0010
    LSR : LSR : LSR : LSR
    AND #$000E
    TAX

    LDA HyperInsts,X
    STA !proj_instruction,Y
    TXA : ASL : TAX
    LDA HyperSpeeds,X
    STA !proj_var2,Y ; speed
    LDA HyperSpeeds+2,X
    STA !proj_var3,Y ; speed

    LDA #$0060 ; room_width / speed
    STA !proj_var0,Y ; death timer
    LDA #$FFFE
    STA !proj_var1,Y ; palette index

    RTS


print pc
Hyper_Main:
    DEC !proj_var0,X
    BPL .no_delete
.delete
    STZ !proj_id,X ; delete
    RTS
.no_delete

    ; move
    LDA !proj_x,X
    CLC : ADC !proj_var2,X
    STA !proj_x,X
    ; delete
    BMI .delete
    CMP #$0200
    BPL .delete

    LDA !proj_y,X
    CLC : ADC !proj_var3,X
    STA !proj_y,X
    ; delete
    BMI .delete
    CMP #$0200
    BPL .delete


    ; palette
    LDA !proj_var1,X
    INC : INC
    STA !proj_var1,X
    TAY
    LDA HyperPalettes,Y
    BNE +
    STZ !proj_var1,X
    LDA HyperPalettes
+ 
    TAY

    PHB
    PEA.w $8D8D
    PLB : PLB
    LDA #$0009
    LDX #$0162
    JSL $A9D2E4 ; load palette
    PLB

    RTS


ClampValue:
    BMI .negative
.positive
    CMP $00
    BMI .return
    LDA $00
    BRA .return

.negative
    PHA
    LDA $00
    EOR #$FFFF : INC
    STA $00
    PLA
    CMP $00
    BPL .return
    LDA $00
    BRA .return

.return
    RTL


HyperOffset_X:
    DW $FFEC, $0014
HyperInsts:
    DW #HyperInst_DownUp, #HyperInst_DownLeft, #HyperInst_LeftRight, #HyperInst_DownRight
    DW #HyperInst_DownUp, #HyperInst_DownLeft, #HyperInst_LeftRight, #HyperInst_DownRight
HyperSpeeds:
    DW $0000, $FFFB
    DW $0003, $FFFD
    DW $0005, $0000
    DW $0003, $0003
    DW $0000, $0005
    DW $FFFD, $0003
    DW $FFFB, $0000
    DW $FFFD, $FFFD


HyperPalettes:
    DW $D906, $D91A, $D92E, $D942, $D956, $D96A, $D97E, $D992
    DW $D9A6, $D9BA, $0000, $0000, $0000, $0000, $0000, $0000

HyperInst_DownLeft:
    DW $0001, #HyperOAM_DownLeft_00
    DW $0001, #HyperOAM_DownLeft_01
    DW $0001, #HyperOAM_DownLeft_02
    DW $0001, #HyperOAM_DownLeft_03
    DW $8298 : DB $0C, $0C ; set size
    DW $0001, #HyperOAM_DownLeft_04
    DW $0001, #HyperOAM_DownLeft_05
HyperInst_DownLeft_Loop:
    DW $8298 : DB $0C, $0C ; set size
    DW $0001, #HyperOAM_DownLeft_06
    DW $0001, #HyperOAM_DownLeft_07
    DW $8298 : DB $10, $10 ; set size
    DW $0001, #HyperOAM_DownLeft_08
    DW $0001, #HyperOAM_DownLeft_09
    DW $8298 : DB $11, $11 ; set size
    DW $0001, #HyperOAM_DownLeft_10
    DW $0001, #HyperOAM_DownLeft_11
    DW $8298 : DB $14, $14 ; set size
    DW $0001, #HyperOAM_DownLeft_12
    DW $0001, #HyperOAM_DownLeft_13
    DW $8298 : DB $18, $18 ; set size
    DW $0001, #HyperOAM_DownLeft_14
    DW $0001, #HyperOAM_DownLeft_15
    DW $8298 : DB $14, $14 ; set size
    DW $0001, #HyperOAM_DownLeft_12
    DW $0001, #HyperOAM_DownLeft_13
    DW $8298 : DB $11, $11 ; set size
    DW $0001, #HyperOAM_DownLeft_10
    DW $0001, #HyperOAM_DownLeft_11
    DW $8298 : DB $10, $10 ; set size
    DW $0001, #HyperOAM_DownLeft_08
    DW $0001, #HyperOAM_DownLeft_09
    DW $81AB, #HyperInst_DownLeft_Loop ; loop

HyperInst_DownRight:
    DW $0001, #HyperOAM_DownRight_00
    DW $0001, #HyperOAM_DownRight_01
    DW $0001, #HyperOAM_DownRight_02
    DW $0001, #HyperOAM_DownRight_03
    DW $8298 : DB $0C, $0C ; set size
    DW $0001, #HyperOAM_DownRight_04
    DW $0001, #HyperOAM_DownRight_05
HyperInst_DownRight_Loop:
    DW $8298 : DB $0C, $0C ; set size
    DW $0001, #HyperOAM_DownRight_06
    DW $0001, #HyperOAM_DownRight_07
    DW $8298 : DB $10, $10 ; set size
    DW $0001, #HyperOAM_DownRight_08
    DW $0001, #HyperOAM_DownRight_09
    DW $8298 : DB $11, $11 ; set size
    DW $0001, #HyperOAM_DownRight_10
    DW $0001, #HyperOAM_DownRight_11
    DW $8298 : DB $14, $14 ; set size
    DW $0001, #HyperOAM_DownRight_12
    DW $0001, #HyperOAM_DownRight_13
    DW $8298 : DB $18, $18 ; set size
    DW $0001, #HyperOAM_DownRight_14
    DW $0001, #HyperOAM_DownRight_15
    DW $8298 : DB $14, $14 ; set size
    DW $0001, #HyperOAM_DownRight_12
    DW $0001, #HyperOAM_DownRight_13
    DW $8298 : DB $11, $11 ; set size
    DW $0001, #HyperOAM_DownRight_10
    DW $0001, #HyperOAM_DownRight_11
    DW $8298 : DB $10, $10 ; set size
    DW $0001, #HyperOAM_DownRight_08
    DW $0001, #HyperOAM_DownRight_09
    DW $81AB, #HyperInst_DownRight_Loop ; loop

HyperInst_LeftRight:
    DW $8298 : DB $08, $0C ; set size
    DW $0001, #HyperOAM_LeftRight_00
    DW $0001, #HyperOAM_LeftRight_01
    DW $0001, #HyperOAM_LeftRight_02
    DW $0001, #HyperOAM_LeftRight_03
    DW $8298 : DB $18, $0C ; set size
    DW $0001, #HyperOAM_LeftRight_04
    DW $0001, #HyperOAM_LeftRight_05
HyperInst_LeftRight_Loop:
    DW $8298 : DB $1C, $0C ; set size
    DW $0001, #HyperOAM_LeftRight_06
    DW $0001, #HyperOAM_LeftRight_07
    DW $0001, #HyperOAM_LeftRight_08
    DW $0001, #HyperOAM_LeftRight_09
    DW $8298 : DB $1C, $11 ; set size
    DW $0001, #HyperOAM_LeftRight_10
    DW $0001, #HyperOAM_LeftRight_11
    DW $8298 : DB $1C, $13 ; set size
    DW $0001, #HyperOAM_LeftRight_12
    DW $0001, #HyperOAM_LeftRight_13
    DW $8298 : DB $1C, $14 ; set size
    DW $0001, #HyperOAM_LeftRight_14
    DW $0001, #HyperOAM_LeftRight_15
    DW $8298 : DB $1C, $13 ; set size
    DW $0001, #HyperOAM_LeftRight_12
    DW $0001, #HyperOAM_LeftRight_13
    DW $8298 : DB $1C, $11 ; set size
    DW $0001, #HyperOAM_LeftRight_10
    DW $0001, #HyperOAM_LeftRight_11
    DW $8298 : DB $1C, $0C ; set size
    DW $0001, #HyperOAM_LeftRight_08
    DW $0001, #HyperOAM_LeftRight_09
    DW $81AB, #HyperInst_LeftRight_Loop ; loop

HyperInst_DownUp:
    DW $8298 : DB $0C, $08 ; set size
    DW $0001, #HyperOAM_DownUp_00
    DW $0001, #HyperOAM_DownUp_01
    DW $0001, #HyperOAM_DownUp_02
    DW $0001, #HyperOAM_DownUp_03
    DW $8298 : DB $0C, $18 ; set size
    DW $0001, #HyperOAM_DownUp_04
    DW $0001, #HyperOAM_DownUp_05
HyperInst_DownUp_Loop:
    DW $8298 : DB $0C, $1E ; set size
    DW $0001, #HyperOAM_DownUp_06
    DW $0001, #HyperOAM_DownUp_07
    DW $0001, #HyperOAM_DownUp_08
    DW $0001, #HyperOAM_DownUp_09
    DW $8298 : DB $11, $1E ; set size
    DW $0001, #HyperOAM_DownUp_10
    DW $0001, #HyperOAM_DownUp_11
    DW $8298 : DB $13, $1E ; set size
    DW $0001, #HyperOAM_DownUp_12
    DW $0001, #HyperOAM_DownUp_13
    DW $8298 : DB $14, $1E ; set size
    DW $0001, #HyperOAM_DownUp_14
    DW $0001, #HyperOAM_DownUp_15
    DW $8298 : DB $13, $1E ; set size
    DW $0001, #HyperOAM_DownUp_12
    DW $0001, #HyperOAM_DownUp_13
    DW $8298 : DB $11, $1E ; set size
    DW $0001, #HyperOAM_DownUp_10
    DW $0001, #HyperOAM_DownUp_11
    DW $8298 : DB $0C, $1E ; set size
    DW $0001, #HyperOAM_DownUp_08
    DW $0001, #HyperOAM_DownUp_09
    DW $81AB, #HyperInst_DownUp_Loop ; loop

warnpc $870000


org $85E000 ; free space

HyperOAM_DownLeft_00: 
    DW $0002
        DW $01F8 : DB $FC : DW $66F2
        DW $0000 : DB $FC : DW $66F1
HyperOAM_DownLeft_01: 
    DW $0002
        DW $01FC : DB $F8 : DW $66F6
        DW $01FC : DB $00 : DW $A6F6
HyperOAM_DownLeft_02: 
    DW $0004
        DW $01F4 : DB $00 : DW $66F2
        DW $01FC : DB $00 : DW $66F1
        DW $01FC : DB $F8 : DW $66F2
        DW $0004 : DB $F8 : DW $66F1
HyperOAM_DownLeft_03: 
    DW $0004
        DW $01F8 : DB $04 : DW $A6F6
        DW $01F8 : DB $FC : DW $A6F5
        DW $0000 : DB $F4 : DW $66F6
        DW $0000 : DB $FC : DW $66F5
HyperOAM_DownLeft_04: 
    DW $0008
        DW $01EC : DB $08 : DW $66F2
        DW $01F4 : DB $08 : DW $66F1
        DW $01F4 : DB $00 : DW $66F2
        DW $01FC : DB $00 : DW $66F1
        DW $01FC : DB $F8 : DW $66F2
        DW $0004 : DB $F8 : DW $66F1
        DW $0004 : DB $F0 : DW $66F2
        DW $000C : DB $F0 : DW $66F1
HyperOAM_DownLeft_05: 
    DW $0008
        DW $01F0 : DB $04 : DW $A6F5
        DW $0000 : DB $F4 : DW $A6F5
        DW $01F8 : DB $FC : DW $A6F5
        DW $01F0 : DB $0C : DW $A6F6
        DW $0008 : DB $EC : DW $66F6
        DW $01F8 : DB $04 : DW $66F5
        DW $0000 : DB $FC : DW $66F5
        DW $0008 : DB $F4 : DW $66F5
HyperOAM_DownLeft_06: 
    DW $000A
        DW $0008 : DB $EC : DW $66F2
        DW $0010 : DB $EC : DW $66F1
        DW $01E8 : DB $0C : DW $66F2
        DW $01F0 : DB $0C : DW $66F1
        DW $01F0 : DB $04 : DW $66F2
        DW $01F8 : DB $04 : DW $66F1
        DW $0000 : DB $F4 : DW $66F2
        DW $0008 : DB $F4 : DW $66F1
        DW $01F8 : DB $FC : DW $66F2
        DW $0000 : DB $FC : DW $66F1
HyperOAM_DownLeft_07: 
    DW $000C
        DW $01E8 : DB $14 : DW $A6F6
        DW $0010 : DB $E4 : DW $66F6
        DW $01E8 : DB $0C : DW $A6F5
        DW $01F0 : DB $04 : DW $A6F5
        DW $01F8 : DB $FC : DW $A6F5
        DW $0000 : DB $F4 : DW $A6F5
        DW $0008 : DB $EC : DW $A6F5
        DW $0010 : DB $EC : DW $66F5
        DW $01F0 : DB $0C : DW $66F5
        DW $01F8 : DB $04 : DW $66F5
        DW $0008 : DB $F4 : DW $66F5
        DW $0000 : DB $FC : DW $66F5
HyperOAM_DownLeft_08: 
    DW $0014
        DW $0001 : DB $E6 : DW $66F2
        DW $0009 : DB $E6 : DW $66F1
        DW $000E : DB $F2 : DW $66F2
        DW $0016 : DB $F2 : DW $66F1
        DW $01EE : DB $12 : DW $66F2
        DW $01F6 : DB $12 : DW $66F1
        DW $01E1 : DB $06 : DW $66F2
        DW $01E9 : DB $06 : DW $66F1
        DW $01E9 : DB $FE : DW $66F2
        DW $01F1 : DB $FE : DW $66F1
        DW $01F9 : DB $EE : DW $66F2
        DW $0001 : DB $EE : DW $66F1
        DW $01F1 : DB $F6 : DW $66F2
        DW $01F9 : DB $F6 : DW $66F1
        DW $01F6 : DB $0A : DW $66F2
        DW $01FE : DB $0A : DW $66F1
        DW $0006 : DB $FA : DW $66F2
        DW $000E : DB $FA : DW $66F1
        DW $01FE : DB $02 : DW $66F2
        DW $0006 : DB $02 : DW $66F1
HyperOAM_DownLeft_09: 
    DW $0018
        DW $01EE : DB $1A : DW $A6F6
        DW $01E1 : DB $0E : DW $A6F6
        DW $0016 : DB $EA : DW $66F6
        DW $0009 : DB $DE : DW $66F6
        DW $0001 : DB $E6 : DW $A6F5
        DW $01F9 : DB $EE : DW $A6F5
        DW $01F1 : DB $F6 : DW $A6F5
        DW $01E9 : DB $FE : DW $A6F5
        DW $01E1 : DB $06 : DW $A6F5
        DW $01EE : DB $12 : DW $A6F5
        DW $01F6 : DB $0A : DW $A6F5
        DW $01FE : DB $02 : DW $A6F5
        DW $0006 : DB $FA : DW $A6F5
        DW $000E : DB $F2 : DW $A6F5
        DW $0009 : DB $E6 : DW $66F5
        DW $0016 : DB $F2 : DW $66F5
        DW $01F6 : DB $12 : DW $66F5
        DW $01E9 : DB $06 : DW $66F5
        DW $01F1 : DB $FE : DW $66F5
        DW $0001 : DB $EE : DW $66F5
        DW $01F9 : DB $F6 : DW $66F5
        DW $01FE : DB $0A : DW $66F5
        DW $000E : DB $FA : DW $66F5
        DW $0006 : DB $02 : DW $66F5
HyperOAM_DownLeft_10: 
    DW $0014
        DW $01FE : DB $E3 : DW $66F2
        DW $0006 : DB $E3 : DW $66F1
        DW $01DE : DB $03 : DW $66F2
        DW $01E6 : DB $03 : DW $66F1
        DW $0011 : DB $F5 : DW $66F2
        DW $0019 : DB $F5 : DW $66F1
        DW $01F1 : DB $15 : DW $66F2
        DW $01F9 : DB $15 : DW $66F1
        DW $01E6 : DB $FB : DW $66F2
        DW $01EE : DB $FB : DW $66F1
        DW $01F6 : DB $EB : DW $66F2
        DW $01FE : DB $EB : DW $66F1
        DW $01EE : DB $F3 : DW $66F2
        DW $01F6 : DB $F3 : DW $66F1
        DW $01F9 : DB $0D : DW $66F2
        DW $0001 : DB $0D : DW $66F1
        DW $0009 : DB $FD : DW $66F2
        DW $0011 : DB $FD : DW $66F1
        DW $0001 : DB $05 : DW $66F2
        DW $0009 : DB $05 : DW $66F1
HyperOAM_DownLeft_11: 
    DW $0018
        DW $0019 : DB $ED : DW $66F6
        DW $0006 : DB $DB : DW $66F6
        DW $01F1 : DB $1D : DW $A6F6
        DW $01DE : DB $0B : DW $A6F6
        DW $01FE : DB $E3 : DW $A6F5
        DW $01F6 : DB $EB : DW $A6F5
        DW $01EE : DB $F3 : DW $A6F5
        DW $01E6 : DB $FB : DW $A6F5
        DW $01DE : DB $03 : DW $A6F5
        DW $01F1 : DB $15 : DW $A6F5
        DW $01F9 : DB $0D : DW $A6F5
        DW $0001 : DB $05 : DW $A6F5
        DW $0009 : DB $FD : DW $A6F5
        DW $0011 : DB $F5 : DW $A6F5
        DW $0006 : DB $E3 : DW $66F5
        DW $01E6 : DB $03 : DW $66F5
        DW $0019 : DB $F5 : DW $66F5
        DW $01F9 : DB $15 : DW $66F5
        DW $01EE : DB $FB : DW $66F5
        DW $01FE : DB $EB : DW $66F5
        DW $01F6 : DB $F3 : DW $66F5
        DW $0001 : DB $0D : DW $66F5
        DW $0011 : DB $FD : DW $66F5
        DW $0009 : DB $05 : DW $66F5
HyperOAM_DownLeft_12: 
    DW $0014
        DW $0013 : DB $F7 : DW $66F2
        DW $001B : DB $F7 : DW $66F1
        DW $01FC : DB $E1 : DW $66F2
        DW $0004 : DB $E1 : DW $66F1
        DW $01F3 : DB $17 : DW $66F2
        DW $01FB : DB $17 : DW $66F1
        DW $01DD : DB $00 : DW $66F2
        DW $01E5 : DB $00 : DW $66F1
        DW $01E4 : DB $F9 : DW $66F2
        DW $01EC : DB $F9 : DW $66F1
        DW $01F4 : DB $E9 : DW $66F2
        DW $01FC : DB $E9 : DW $66F1
        DW $01EC : DB $F1 : DW $66F2
        DW $01F4 : DB $F1 : DW $66F1
        DW $01FB : DB $0F : DW $66F2
        DW $0003 : DB $0F : DW $66F1
        DW $000B : DB $FF : DW $66F2
        DW $0013 : DB $FF : DW $66F1
        DW $0003 : DB $07 : DW $66F2
        DW $000B : DB $07 : DW $66F1
HyperOAM_DownLeft_13: 
    DW $0018
        DW $001B : DB $EF : DW $66F6
        DW $0004 : DB $D9 : DW $66F6
        DW $01F3 : DB $1F : DW $A6F6
        DW $01DD : DB $08 : DW $A6F6
        DW $01FC : DB $E1 : DW $A6F5
        DW $01F4 : DB $E9 : DW $A6F5
        DW $01EC : DB $F1 : DW $A6F5
        DW $01E4 : DB $F9 : DW $A6F5
        DW $01DD : DB $00 : DW $A6F5
        DW $01F3 : DB $17 : DW $A6F5
        DW $01FB : DB $0F : DW $A6F5
        DW $0003 : DB $07 : DW $A6F5
        DW $000B : DB $FF : DW $A6F5
        DW $0013 : DB $F7 : DW $A6F5
        DW $001B : DB $F7 : DW $66F5
        DW $0004 : DB $E1 : DW $66F5
        DW $01FB : DB $17 : DW $66F5
        DW $01E5 : DB $00 : DW $66F5
        DW $01EC : DB $F9 : DW $66F5
        DW $01FC : DB $E9 : DW $66F5
        DW $01F4 : DB $F1 : DW $66F5
        DW $0003 : DB $0F : DW $66F5
        DW $0013 : DB $FF : DW $66F5
        DW $000B : DB $07 : DW $66F5
HyperOAM_DownLeft_14: 
    DW $0014
        DW $0014 : DB $F8 : DW $66F2
        DW $001C : DB $F8 : DW $66F1
        DW $01FB : DB $E0 : DW $66F2
        DW $0003 : DB $E0 : DW $66F1
        DW $01F4 : DB $18 : DW $66F2
        DW $01FC : DB $18 : DW $66F1
        DW $01DB : DB $00 : DW $66F2
        DW $01E3 : DB $00 : DW $66F1
        DW $01E3 : DB $F8 : DW $66F2
        DW $01EB : DB $F8 : DW $66F1
        DW $01F3 : DB $E8 : DW $66F2
        DW $01FB : DB $E8 : DW $66F1
        DW $01EB : DB $F0 : DW $66F2
        DW $01F3 : DB $F0 : DW $66F1
        DW $01FC : DB $10 : DW $66F2
        DW $0004 : DB $10 : DW $66F1
        DW $000C : DB $00 : DW $66F2
        DW $0014 : DB $00 : DW $66F1
        DW $0004 : DB $08 : DW $66F2
        DW $000C : DB $08 : DW $66F1
HyperOAM_DownLeft_15: 
    DW $0018
        DW $01F4 : DB $20 : DW $A6F6
        DW $01DB : DB $08 : DW $A6F6
        DW $001C : DB $F0 : DW $66F6
        DW $0003 : DB $D8 : DW $66F6
        DW $0014 : DB $F8 : DW $A6F5
        DW $000C : DB $00 : DW $A6F5
        DW $0004 : DB $08 : DW $A6F5
        DW $01FC : DB $10 : DW $A6F5
        DW $01F4 : DB $18 : DW $A6F5
        DW $01DB : DB $00 : DW $A6F5
        DW $01E3 : DB $F8 : DW $A6F5
        DW $01EB : DB $F0 : DW $A6F5
        DW $01F3 : DB $E8 : DW $A6F5
        DW $01FB : DB $E0 : DW $A6F5
        DW $001C : DB $F8 : DW $66F5
        DW $0003 : DB $E0 : DW $66F5
        DW $01FC : DB $18 : DW $66F5
        DW $01E3 : DB $00 : DW $66F5
        DW $01EB : DB $F8 : DW $66F5
        DW $01FB : DB $E8 : DW $66F5
        DW $01F3 : DB $F0 : DW $66F5
        DW $0004 : DB $10 : DW $66F5
        DW $0014 : DB $00 : DW $66F5
        DW $000C : DB $08 : DW $66F5

HyperOAM_DownRight_00: 
    DW $0002
        DW $0000 : DB $FC : DW $26F2
        DW $01F8 : DB $FC : DW $26F1
HyperOAM_DownRight_01: 
    DW $0002
        DW $01FC : DB $F8 : DW $26F6
        DW $01FC : DB $00 : DW $E6F6
HyperOAM_DownRight_02:
    DW $0004
        DW $0004 : DB $00 : DW $26F2
        DW $01FC : DB $00 : DW $26F1
        DW $01FC : DB $F8 : DW $26F2
        DW $01F4 : DB $F8 : DW $26F1
HyperOAM_DownRight_03:
    DW $0004
        DW $0000 : DB $04 : DW $E6F6
        DW $0000 : DB $FC : DW $E6F5
        DW $01F8 : DB $F4 : DW $26F6
        DW $01F8 : DB $FC : DW $26F5
HyperOAM_DownRight_04:
    DW $0008
        DW $000C : DB $08 : DW $26F2
        DW $0004 : DB $08 : DW $26F1
        DW $0004 : DB $00 : DW $26F2
        DW $01FC : DB $00 : DW $26F1
        DW $01FC : DB $F8 : DW $26F2
        DW $01F4 : DB $F8 : DW $26F1
        DW $01F4 : DB $F0 : DW $26F2
        DW $01EC : DB $F0 : DW $26F1
HyperOAM_DownRight_05:
    DW $0008
        DW $0008 : DB $04 : DW $E6F5
        DW $01F8 : DB $F4 : DW $E6F5
        DW $0000 : DB $FC : DW $E6F5
        DW $0008 : DB $0C : DW $E6F6
        DW $01F0 : DB $EC : DW $26F6
        DW $0000 : DB $04 : DW $26F5
        DW $01F8 : DB $FC : DW $26F5
        DW $01F0 : DB $F4 : DW $26F5
HyperOAM_DownRight_06:
    DW $000A
        DW $01F0 : DB $EC : DW $26F2
        DW $01E8 : DB $EC : DW $26F1
        DW $0010 : DB $0C : DW $26F2
        DW $0008 : DB $0C : DW $26F1
        DW $0008 : DB $04 : DW $26F2
        DW $0000 : DB $04 : DW $26F1
        DW $01F8 : DB $F4 : DW $26F2
        DW $01F0 : DB $F4 : DW $26F1
        DW $0000 : DB $FC : DW $26F2
        DW $01F8 : DB $FC : DW $26F1
HyperOAM_DownRight_07:
    DW $000C
        DW $0010 : DB $14 : DW $E6F6
        DW $01E8 : DB $E4 : DW $26F6
        DW $0010 : DB $0C : DW $E6F5
        DW $0008 : DB $04 : DW $E6F5
        DW $0000 : DB $FC : DW $E6F5
        DW $01F8 : DB $F4 : DW $E6F5
        DW $01F0 : DB $EC : DW $E6F5
        DW $01E8 : DB $EC : DW $26F5
        DW $0008 : DB $0C : DW $26F5
        DW $0000 : DB $04 : DW $26F5
        DW $01F0 : DB $F4 : DW $26F5
        DW $01F8 : DB $FC : DW $26F5
HyperOAM_DownRight_08:
    DW $0014
        DW $01F7 : DB $E6 : DW $26F2
        DW $01EF : DB $E6 : DW $26F1
        DW $01EA : DB $F2 : DW $26F2
        DW $01E2 : DB $F2 : DW $26F1
        DW $000A : DB $12 : DW $26F2
        DW $0002 : DB $12 : DW $26F1
        DW $0017 : DB $06 : DW $26F2
        DW $000F : DB $06 : DW $26F1
        DW $000F : DB $FE : DW $26F2
        DW $0007 : DB $FE : DW $26F1
        DW $01FF : DB $EE : DW $26F2
        DW $01F7 : DB $EE : DW $26F1
        DW $0007 : DB $F6 : DW $26F2
        DW $01FF : DB $F6 : DW $26F1
        DW $0002 : DB $0A : DW $26F2
        DW $01FA : DB $0A : DW $26F1
        DW $01F2 : DB $FA : DW $26F2
        DW $01EA : DB $FA : DW $26F1
        DW $01FA : DB $02 : DW $26F2
        DW $01F2 : DB $02 : DW $26F1
HyperOAM_DownRight_09:
    DW $0018
        DW $000A : DB $1A : DW $E6F6
        DW $0017 : DB $0E : DW $E6F6
        DW $01E2 : DB $EA : DW $26F6
        DW $01EF : DB $DE : DW $26F6
        DW $01F7 : DB $E6 : DW $E6F5
        DW $01FF : DB $EE : DW $E6F5
        DW $0007 : DB $F6 : DW $E6F5
        DW $000F : DB $FE : DW $E6F5
        DW $0017 : DB $06 : DW $E6F5
        DW $000A : DB $12 : DW $E6F5
        DW $0002 : DB $0A : DW $E6F5
        DW $01FA : DB $02 : DW $E6F5
        DW $01F2 : DB $FA : DW $E6F5
        DW $01EA : DB $F2 : DW $E6F5
        DW $01EF : DB $E6 : DW $26F5
        DW $01E2 : DB $F2 : DW $26F5
        DW $0002 : DB $12 : DW $26F5
        DW $000F : DB $06 : DW $26F5
        DW $0007 : DB $FE : DW $26F5
        DW $01F7 : DB $EE : DW $26F5
        DW $01FF : DB $F6 : DW $26F5
        DW $01FA : DB $0A : DW $26F5
        DW $01EA : DB $FA : DW $26F5
        DW $01F2 : DB $02 : DW $26F5
HyperOAM_DownRight_10:
    DW $0014
        DW $01FA : DB $E3 : DW $26F2
        DW $01F2 : DB $E3 : DW $26F1
        DW $001A : DB $03 : DW $26F2
        DW $0012 : DB $03 : DW $26F1
        DW $01E7 : DB $F5 : DW $26F2
        DW $01DF : DB $F5 : DW $26F1
        DW $0007 : DB $15 : DW $26F2
        DW $01FF : DB $15 : DW $26F1
        DW $0012 : DB $FB : DW $26F2
        DW $000A : DB $FB : DW $26F1
        DW $0002 : DB $EB : DW $26F2
        DW $01FA : DB $EB : DW $26F1
        DW $000A : DB $F3 : DW $26F2
        DW $0002 : DB $F3 : DW $26F1
        DW $01FF : DB $0D : DW $26F2
        DW $01F7 : DB $0D : DW $26F1
        DW $01EF : DB $FD : DW $26F2
        DW $01E7 : DB $FD : DW $26F1
        DW $01F7 : DB $05 : DW $26F2
        DW $01EF : DB $05 : DW $26F1
HyperOAM_DownRight_11:
    DW $0018
        DW $01DF : DB $ED : DW $26F6
        DW $01F2 : DB $DB : DW $26F6
        DW $0007 : DB $1D : DW $E6F6
        DW $001A : DB $0B : DW $E6F6
        DW $01FA : DB $E3 : DW $E6F5
        DW $0002 : DB $EB : DW $E6F5
        DW $000A : DB $F3 : DW $E6F5
        DW $0012 : DB $FB : DW $E6F5
        DW $001A : DB $03 : DW $E6F5
        DW $0007 : DB $15 : DW $E6F5
        DW $01FF : DB $0D : DW $E6F5
        DW $01F7 : DB $05 : DW $E6F5
        DW $01EF : DB $FD : DW $E6F5
        DW $01E7 : DB $F5 : DW $E6F5
        DW $01F2 : DB $E3 : DW $26F5
        DW $0012 : DB $03 : DW $26F5
        DW $01DF : DB $F5 : DW $26F5
        DW $01FF : DB $15 : DW $26F5
        DW $000A : DB $FB : DW $26F5
        DW $01FA : DB $EB : DW $26F5
        DW $0002 : DB $F3 : DW $26F5
        DW $01F7 : DB $0D : DW $26F5
        DW $01E7 : DB $FD : DW $26F5
        DW $01EF : DB $05 : DW $26F5
HyperOAM_DownRight_12:
    DW $0014
        DW $01E5 : DB $F7 : DW $26F2
        DW $01DD : DB $F7 : DW $26F1
        DW $01FC : DB $E1 : DW $26F2
        DW $01F4 : DB $E1 : DW $26F1
        DW $0005 : DB $17 : DW $26F2
        DW $01FD : DB $17 : DW $26F1
        DW $001B : DB $00 : DW $26F2
        DW $0013 : DB $00 : DW $26F1
        DW $0014 : DB $F9 : DW $26F2
        DW $000C : DB $F9 : DW $26F1
        DW $0004 : DB $E9 : DW $26F2
        DW $01FC : DB $E9 : DW $26F1
        DW $000C : DB $F1 : DW $26F2
        DW $0004 : DB $F1 : DW $26F1
        DW $01FD : DB $0F : DW $26F2
        DW $01F5 : DB $0F : DW $26F1
        DW $01ED : DB $FF : DW $26F2
        DW $01E5 : DB $FF : DW $26F1
        DW $01F5 : DB $07 : DW $26F2
        DW $01ED : DB $07 : DW $26F1
HyperOAM_DownRight_13:
    DW $0018
        DW $01DD : DB $EF : DW $26F6
        DW $01F4 : DB $D9 : DW $26F6
        DW $0005 : DB $1F : DW $E6F6
        DW $001B : DB $08 : DW $E6F6
        DW $01FC : DB $E1 : DW $E6F5
        DW $0004 : DB $E9 : DW $E6F5
        DW $000C : DB $F1 : DW $E6F5
        DW $0014 : DB $F9 : DW $E6F5
        DW $001B : DB $00 : DW $E6F5
        DW $0005 : DB $17 : DW $E6F5
        DW $01FD : DB $0F : DW $E6F5
        DW $01F5 : DB $07 : DW $E6F5
        DW $01ED : DB $FF : DW $E6F5
        DW $01E5 : DB $F7 : DW $E6F5
        DW $01DD : DB $F7 : DW $26F5
        DW $01F4 : DB $E1 : DW $26F5
        DW $01FD : DB $17 : DW $26F5
        DW $0013 : DB $00 : DW $26F5
        DW $000C : DB $F9 : DW $26F5
        DW $01FC : DB $E9 : DW $26F5
        DW $0004 : DB $F1 : DW $26F5
        DW $01F5 : DB $0F : DW $26F5
        DW $01E5 : DB $FF : DW $26F5
        DW $01ED : DB $07 : DW $26F5
HyperOAM_DownRight_14:
    DW $0014
        DW $01E4 : DB $F8 : DW $26F2
        DW $01DC : DB $F8 : DW $26F1
        DW $01FD : DB $E0 : DW $26F2
        DW $01F5 : DB $E0 : DW $26F1
        DW $0004 : DB $18 : DW $26F2
        DW $01FC : DB $18 : DW $26F1
        DW $001D : DB $00 : DW $26F2
        DW $0015 : DB $00 : DW $26F1
        DW $0015 : DB $F8 : DW $26F2
        DW $000D : DB $F8 : DW $26F1
        DW $0005 : DB $E8 : DW $26F2
        DW $01FD : DB $E8 : DW $26F1
        DW $000D : DB $F0 : DW $26F2
        DW $0005 : DB $F0 : DW $26F1
        DW $01FC : DB $10 : DW $26F2
        DW $01F4 : DB $10 : DW $26F1
        DW $01EC : DB $00 : DW $26F2
        DW $01E4 : DB $00 : DW $26F1
        DW $01F4 : DB $08 : DW $26F2
        DW $01EC : DB $08 : DW $26F1
HyperOAM_DownRight_15:
    DW $0018
        DW $0004 : DB $20 : DW $E6F6
        DW $001D : DB $08 : DW $E6F6
        DW $01DC : DB $F0 : DW $26F6
        DW $01F5 : DB $D8 : DW $26F6
        DW $01E4 : DB $F8 : DW $E6F5
        DW $01EC : DB $00 : DW $E6F5
        DW $01F4 : DB $08 : DW $E6F5
        DW $01FC : DB $10 : DW $E6F5
        DW $0004 : DB $18 : DW $E6F5
        DW $001D : DB $00 : DW $E6F5
        DW $0015 : DB $F8 : DW $E6F5
        DW $000D : DB $F0 : DW $E6F5
        DW $0005 : DB $E8 : DW $E6F5
        DW $01FD : DB $E0 : DW $E6F5
        DW $01DC : DB $F8 : DW $26F5
        DW $01F5 : DB $E0 : DW $26F5
        DW $01FC : DB $18 : DW $26F5
        DW $0015 : DB $00 : DW $26F5
        DW $000D : DB $F8 : DW $26F5
        DW $01FD : DB $E8 : DW $26F5
        DW $0005 : DB $F0 : DW $26F5
        DW $01F4 : DB $10 : DW $26F5
        DW $01E4 : DB $00 : DW $26F5
        DW $01EC : DB $08 : DW $26F5

HyperOAM_LeftRight_00:
    DW $0001 
        DW $01FC : DB $FC : DW $26F0
HyperOAM_LeftRight_01:
    DW $0001 
        DW $01FC : DB $FC : DW $26F4
HyperOAM_LeftRight_02:
    DW $0003 
        DW $01F4 : DB $FC : DW $26F0
        DW $01FC : DB $FC : DW $26F0
        DW $0004 : DB $FC : DW $26F0
HyperOAM_LeftRight_03:
    DW $0003 
        DW $0004 : DB $FC : DW $26F4
        DW $01FC : DB $FC : DW $26F4
        DW $01F4 : DB $FC : DW $26F4
HyperOAM_LeftRight_04:
    DW $0006 
        DW $0010 : DB $FC : DW $26F0
        DW $0008 : DB $FC : DW $26F0
        DW $0000 : DB $FC : DW $26F0
        DW $01F8 : DB $FC : DW $26F0
        DW $01F0 : DB $FC : DW $26F0
        DW $01E8 : DB $FC : DW $26F0
HyperOAM_LeftRight_05:
    DW $0006 
        DW $0010 : DB $FC : DW $26F4
        DW $0008 : DB $FC : DW $26F4
        DW $0000 : DB $FC : DW $26F4
        DW $01F8 : DB $FC : DW $26F4
        DW $01F0 : DB $FC : DW $26F4
        DW $01E8 : DB $FC : DW $26F4
HyperOAM_LeftRight_06:
    DW $0007 
        DW $0014 : DB $FC : DW $26F0
        DW $01E4 : DB $FC : DW $26F0
        DW $000C : DB $FC : DW $26F0
        DW $0004 : DB $FC : DW $26F0
        DW $01FC : DB $FC : DW $26F0
        DW $01F4 : DB $FC : DW $26F0
        DW $01EC : DB $FC : DW $26F0
HyperOAM_LeftRight_07:
    DW $0007 
        DW $0014 : DB $FC : DW $26F4
        DW $01E4 : DB $FC : DW $26F4
        DW $000C : DB $FC : DW $26F4
        DW $0004 : DB $FC : DW $26F4
        DW $01FC : DB $FC : DW $26F4
        DW $01F4 : DB $FC : DW $26F4
        DW $01EC : DB $FC : DW $26F4
HyperOAM_LeftRight_08:
    DW $000E 
        DW $0014 : DB $04 : DW $26F0
        DW $0014 : DB $F4 : DW $26F0
        DW $000C : DB $04 : DW $26F0
        DW $01E4 : DB $04 : DW $26F0
        DW $01E4 : DB $F4 : DW $26F0
        DW $000C : DB $F4 : DW $26F0
        DW $0004 : DB $04 : DW $26F0
        DW $01FC : DB $04 : DW $26F0
        DW $01F4 : DB $04 : DW $26F0
        DW $01EC : DB $04 : DW $26F0
        DW $0004 : DB $F4 : DW $26F0
        DW $01FC : DB $F4 : DW $26F0
        DW $01F4 : DB $F4 : DW $26F0
        DW $01EC : DB $F4 : DW $26F0
HyperOAM_LeftRight_09:
    DW $000E 
        DW $0014 : DB $04 : DW $26F4
        DW $0014 : DB $F4 : DW $26F4
        DW $000C : DB $04 : DW $26F4
        DW $01E4 : DB $04 : DW $26F4
        DW $01E4 : DB $F4 : DW $26F4
        DW $000C : DB $F4 : DW $26F4
        DW $0004 : DB $04 : DW $26F4
        DW $01FC : DB $04 : DW $26F4
        DW $01F4 : DB $04 : DW $26F4
        DW $01EC : DB $04 : DW $26F4
        DW $0004 : DB $F4 : DW $26F4
        DW $01FC : DB $F4 : DW $26F4
        DW $01F4 : DB $F4 : DW $26F4
        DW $01EC : DB $F4 : DW $26F4
HyperOAM_LeftRight_10:
    DW $000E 
        DW $0014 : DB $09 : DW $26F0
        DW $0014 : DB $EF : DW $26F0
        DW $000C : DB $09 : DW $26F0
        DW $01E4 : DB $09 : DW $26F0
        DW $01E4 : DB $EF : DW $26F0
        DW $000C : DB $EF : DW $26F0
        DW $0004 : DB $09 : DW $26F0
        DW $01FC : DB $09 : DW $26F0
        DW $01F4 : DB $09 : DW $26F0
        DW $01EC : DB $09 : DW $26F0
        DW $0004 : DB $EF : DW $26F0
        DW $01FC : DB $EF : DW $26F0
        DW $01F4 : DB $EF : DW $26F0
        DW $01EC : DB $EF : DW $26F0
HyperOAM_LeftRight_11:
    DW $000E 
        DW $0014 : DB $09 : DW $26F4
        DW $0014 : DB $EF : DW $26F4
        DW $000C : DB $09 : DW $26F4
        DW $01E4 : DB $09 : DW $26F4
        DW $01E4 : DB $EF : DW $26F4
        DW $000C : DB $EF : DW $26F4
        DW $0004 : DB $09 : DW $26F4
        DW $01FC : DB $09 : DW $26F4
        DW $01F4 : DB $09 : DW $26F4
        DW $01EC : DB $09 : DW $26F4
        DW $0004 : DB $EF : DW $26F4
        DW $01FC : DB $EF : DW $26F4
        DW $01F4 : DB $EF : DW $26F4
        DW $01EC : DB $EF : DW $26F4
HyperOAM_LeftRight_12:
    DW $000E 
        DW $0014 : DB $0B : DW $26F0
        DW $0014 : DB $ED : DW $26F0
        DW $000C : DB $0B : DW $26F0
        DW $01E4 : DB $0B : DW $26F0
        DW $01E4 : DB $ED : DW $26F0
        DW $000C : DB $ED : DW $26F0
        DW $0004 : DB $0B : DW $26F0
        DW $01FC : DB $0B : DW $26F0
        DW $01F4 : DB $0B : DW $26F0
        DW $01EC : DB $0B : DW $26F0
        DW $0004 : DB $ED : DW $26F0
        DW $01FC : DB $ED : DW $26F0
        DW $01F4 : DB $ED : DW $26F0
        DW $01EC : DB $ED : DW $26F0
HyperOAM_LeftRight_13:
    DW $000E 
        DW $0014 : DB $0B : DW $26F4
        DW $0014 : DB $ED : DW $26F4
        DW $000C : DB $0B : DW $26F4
        DW $01E4 : DB $0B : DW $26F4
        DW $01E4 : DB $ED : DW $26F4
        DW $000C : DB $ED : DW $26F4
        DW $0004 : DB $0B : DW $26F4
        DW $01FC : DB $0B : DW $26F4
        DW $01F4 : DB $0B : DW $26F4
        DW $01EC : DB $0B : DW $26F4
        DW $0004 : DB $ED : DW $26F4
        DW $01FC : DB $ED : DW $26F4
        DW $01F4 : DB $ED : DW $26F4
        DW $01EC : DB $ED : DW $26F4
HyperOAM_LeftRight_14:
    DW $000E 
        DW $0014 : DB $0C : DW $26F0
        DW $0014 : DB $EC : DW $26F0
        DW $000C : DB $0C : DW $26F0
        DW $01E4 : DB $0C : DW $26F0
        DW $01E4 : DB $EC : DW $26F0
        DW $000C : DB $EC : DW $26F0
        DW $0004 : DB $0C : DW $26F0
        DW $01FC : DB $0C : DW $26F0
        DW $01F4 : DB $0C : DW $26F0
        DW $01EC : DB $0C : DW $26F0
        DW $0004 : DB $EC : DW $26F0
        DW $01FC : DB $EC : DW $26F0
        DW $01F4 : DB $EC : DW $26F0
        DW $01EC : DB $EC : DW $26F0
HyperOAM_LeftRight_15:
    DW $000E 
        DW $0014 : DB $0C : DW $26F4
        DW $0014 : DB $EC : DW $26F4
        DW $000C : DB $0C : DW $26F4
        DW $01E4 : DB $0C : DW $26F4
        DW $01E4 : DB $EC : DW $26F4
        DW $000C : DB $EC : DW $26F4
        DW $0004 : DB $0C : DW $26F4
        DW $01FC : DB $0C : DW $26F4
        DW $01F4 : DB $0C : DW $26F4
        DW $01EC : DB $0C : DW $26F4
        DW $0004 : DB $EC : DW $26F4
        DW $01FC : DB $EC : DW $26F4
        DW $01F4 : DB $EC : DW $26F4
        DW $01EC : DB $EC : DW $26F4

HyperOAM_DownUp_00:   
    DW $0001 
        DW $01FC : DB $FC : DW $26F3
HyperOAM_DownUp_01:   
    DW $0001 
        DW $01FC : DB $FC : DW $26F7
HyperOAM_DownUp_02:   
    DW $0003 
        DW $01FC : DB $04 : DW $26F3
        DW $01FC : DB $FC : DW $26F3
        DW $01FC : DB $F4 : DW $26F3
HyperOAM_DownUp_03:   
    DW $0003 
        DW $01FC : DB $04 : DW $26F7
        DW $01FC : DB $FC : DW $26F7
        DW $01FC : DB $F4 : DW $26F7
HyperOAM_DownUp_04:   
    DW $0006 
        DW $01FC : DB $10 : DW $26F3
        DW $01FC : DB $08 : DW $26F3
        DW $01FC : DB $00 : DW $26F3
        DW $01FC : DB $F8 : DW $26F3
        DW $01FC : DB $F0 : DW $26F3
        DW $01FC : DB $E8 : DW $26F3
HyperOAM_DownUp_05:   
    DW $0006 
        DW $01FC : DB $10 : DW $26F7
        DW $01FC : DB $08 : DW $26F7
        DW $01FC : DB $00 : DW $26F7
        DW $01FC : DB $F8 : DW $26F7
        DW $01FC : DB $F0 : DW $26F7
        DW $01FC : DB $E8 : DW $26F7
HyperOAM_DownUp_06:   
    DW $0007 
        DW $01FC : DB $14 : DW $26F3
        DW $01FC : DB $0C : DW $26F3
        DW $01FC : DB $E4 : DW $26F3
        DW $01FC : DB $04 : DW $26F3
        DW $01FC : DB $FC : DW $26F3
        DW $01FC : DB $EC : DW $26F3
        DW $01FC : DB $F4 : DW $26F3
HyperOAM_DownUp_07:   
    DW $0007 
        DW $01FC : DB $14 : DW $26F7
        DW $01FC : DB $0C : DW $26F7
        DW $01FC : DB $E4 : DW $26F7
        DW $01FC : DB $04 : DW $26F7
        DW $01FC : DB $FC : DW $26F7
        DW $01FC : DB $EC : DW $26F7
        DW $01FC : DB $F4 : DW $26F7
HyperOAM_DownUp_08:   
    DW $000E 
        DW $0004 : DB $14 : DW $26F3
        DW $0004 : DB $0C : DW $26F3
        DW $01F5 : DB $14 : DW $26F3
        DW $01F5 : DB $0C : DW $26F3
        DW $01F5 : DB $E4 : DW $26F3
        DW $0004 : DB $E4 : DW $26F3
        DW $0004 : DB $04 : DW $26F3
        DW $0004 : DB $FC : DW $26F3
        DW $0004 : DB $EC : DW $26F3
        DW $0004 : DB $F4 : DW $26F3
        DW $01F5 : DB $04 : DW $26F3
        DW $01F5 : DB $FC : DW $26F3
        DW $01F5 : DB $EC : DW $26F3
        DW $01F5 : DB $F4 : DW $26F3
HyperOAM_DownUp_09:   
    DW $000E 
        DW $0004 : DB $14 : DW $26F7
        DW $0004 : DB $0C : DW $26F7
        DW $01F5 : DB $14 : DW $26F7
        DW $01F5 : DB $0C : DW $26F7
        DW $01F5 : DB $E4 : DW $26F7
        DW $0004 : DB $E4 : DW $26F7
        DW $0004 : DB $04 : DW $26F7
        DW $0004 : DB $FC : DW $26F7
        DW $0004 : DB $EC : DW $26F7
        DW $0004 : DB $F4 : DW $26F7
        DW $01F5 : DB $04 : DW $26F7
        DW $01F5 : DB $FC : DW $26F7
        DW $01F5 : DB $EC : DW $26F7
        DW $01F5 : DB $F4 : DW $26F7
HyperOAM_DownUp_10:   
    DW $000E 
        DW $01EF : DB $14 : DW $26F3
        DW $01EF : DB $0C : DW $26F3
        DW $0009 : DB $14 : DW $26F3
        DW $0009 : DB $0C : DW $26F3
        DW $0009 : DB $E4 : DW $26F3
        DW $01EF : DB $E4 : DW $26F3
        DW $0009 : DB $04 : DW $26F3
        DW $0009 : DB $FC : DW $26F3
        DW $0009 : DB $EC : DW $26F3
        DW $0009 : DB $F4 : DW $26F3
        DW $01EF : DB $04 : DW $26F3
        DW $01EF : DB $FC : DW $26F3
        DW $01EF : DB $EC : DW $26F3
        DW $01EF : DB $F4 : DW $26F3
HyperOAM_DownUp_11:   
    DW $000E 
        DW $01EF : DB $14 : DW $26F7
        DW $01EF : DB $0C : DW $26F7
        DW $0009 : DB $14 : DW $26F7
        DW $0009 : DB $0C : DW $26F7
        DW $0009 : DB $E4 : DW $26F7
        DW $01EF : DB $E4 : DW $26F7
        DW $0009 : DB $04 : DW $26F7
        DW $0009 : DB $FC : DW $26F7
        DW $0009 : DB $EC : DW $26F7
        DW $0009 : DB $F4 : DW $26F7
        DW $01EF : DB $04 : DW $26F7
        DW $01EF : DB $FC : DW $26F7
        DW $01EF : DB $EC : DW $26F7
        DW $01EF : DB $F4 : DW $26F7
HyperOAM_DownUp_12:   
    DW $000E 
        DW $01EE : DB $14 : DW $26F3
        DW $01EE : DB $0C : DW $26F3
        DW $000B : DB $14 : DW $26F3
        DW $000B : DB $0C : DW $26F3
        DW $000B : DB $E4 : DW $26F3
        DW $01EE : DB $E4 : DW $26F3
        DW $000B : DB $04 : DW $26F3
        DW $000B : DB $FC : DW $26F3
        DW $000B : DB $EC : DW $26F3
        DW $000B : DB $F4 : DW $26F3
        DW $01EE : DB $04 : DW $26F3
        DW $01EE : DB $FC : DW $26F3
        DW $01EE : DB $EC : DW $26F3
        DW $01EE : DB $F4 : DW $26F3
HyperOAM_DownUp_13:   
    DW $000E 
        DW $01EE : DB $14 : DW $26F7
        DW $01EE : DB $0C : DW $26F7
        DW $000B : DB $14 : DW $26F7
        DW $000B : DB $0C : DW $26F7
        DW $000B : DB $E4 : DW $26F7
        DW $01EE : DB $E4 : DW $26F7
        DW $000B : DB $04 : DW $26F7
        DW $000B : DB $FC : DW $26F7
        DW $000B : DB $EC : DW $26F7
        DW $000B : DB $F4 : DW $26F7
        DW $01EE : DB $04 : DW $26F7
        DW $01EE : DB $FC : DW $26F7
        DW $01EE : DB $EC : DW $26F7
        DW $01EE : DB $F4 : DW $26F7
HyperOAM_DownUp_14:   
    DW $000E 
        DW $01ED : DB $14 : DW $26F3
        DW $01ED : DB $0C : DW $26F3
        DW $000C : DB $14 : DW $26F3
        DW $000C : DB $0C : DW $26F3
        DW $000C : DB $E4 : DW $26F3
        DW $01ED : DB $E4 : DW $26F3
        DW $000C : DB $04 : DW $26F3
        DW $000C : DB $FC : DW $26F3
        DW $000C : DB $EC : DW $26F3
        DW $000C : DB $F4 : DW $26F3
        DW $01ED : DB $04 : DW $26F3
        DW $01ED : DB $FC : DW $26F3
        DW $01ED : DB $EC : DW $26F3
        DW $01ED : DB $F4 : DW $26F3
HyperOAM_DownUp_15:   
    DW $000E 
        DW $01ED : DB $14 : DW $26F7
        DW $01ED : DB $0C : DW $26F7
        DW $000C : DB $14 : DW $26F7
        DW $000C : DB $0C : DW $26F7
        DW $000C : DB $E4 : DW $26F7
        DW $01ED : DB $E4 : DW $26F7
        DW $000C : DB $04 : DW $26F7
        DW $000C : DB $FC : DW $26F7
        DW $000C : DB $EC : DW $26F7
        DW $000C : DB $F4 : DW $26F7
        DW $01ED : DB $04 : DW $26F7
        DW $01ED : DB $FC : DW $26F7
        DW $01ED : DB $EC : DW $26F7
        DW $01ED : DB $F4 : DW $26F7

warnpc $860000


org $8DA9C5 ; 
MissileOAM_Up:
DW $0002
   DW $01FC : DB $F7 : DW $2A59
   DW $01FC : DB $FF : DW $2A5A
MissileOAM_UpRight:
DW $0003
   DW $0000 : DB $F5 : DW $6A56
   DW $01F8 : DB $FD : DW $6A58
   DW $0000 : DB $FD : DW $6A57
MissileOAM_Right:
DW $0002
   DW $01F9 : DB $FC : DW $6A55
   DW $0001 : DB $FC : DW $6A54
MissileOAM_DownRight:
DW $0003
   DW $0000 : DB $03 : DW $EA56
   DW $01F8 : DB $FB : DW $EA58
   DW $0000 : DB $FB : DW $EA57
MissileOAM_Down:
DW $0002
   DW $01FD : DB $01 : DW $AA59
   DW $01FD : DB $F9 : DW $AA5A
MissileOAM_DownLeft:
DW $0003
   DW $01F8 : DB $03 : DW $AA56
   DW $0000 : DB $FB : DW $AA58
   DW $01F8 : DB $FB : DW $AA57
MissileOAM_Left:
DW $0002
   DW $01FF : DB $FC : DW $2A55
   DW $01F7 : DB $FC : DW $2A54
MissileOAM_UpLeft:
DW $0003
   DW $01F8 : DB $F5 : DW $2A56
   DW $0000 : DB $FD : DW $2A58
   DW $01F8 : DB $FD : DW $2A57

warnpc $8DAAB9


org $AAFA54 ; free space

print "egg shield init"
print pc
EggShieldInit:
    LDX !enemy_index
    
    LDA !enemy_exvar30
    INC
    STA !enemy_exvar30

    JSL $808111   ; rng       
    AND #$000C
    STA !enemy_var0,X ; target node

    JSL $808111   ; rng       
    AND #$000F
    CLC : ADC #$0020
    STA !enemy_var1,X

    LDY #$0000
    LDA !enemy_param1
    BMI +
    LDY #$0002
+

    JSL $808111   ; rng       
    AND #$00FF
    SEC : SBC #$0080
    CLC : ADC.w EggShield_InitialSpeed,Y
    STA !enemy_var2,X

    JSL $808111   ; rng       
    AND #$01FF
    SEC : SBC #$0100
    STA !enemy_var3,X

    LDA !enemy_X
    CLC : ADC.w EggShield_InitialPos,Y
    STA !enemy_X,X
    LDA !enemy_Y
    CLC : ADC.w #$FFFF
    STA !enemy_Y,X

    LDA #EggShield_Inst0
    STA !enemy_instruction,X
    STA !enemy_var4,X
    LDA #$0001
    STA !enemy_inst_timer,X

    STZ !enemy_tiles,X
    LDA #$0A00
    STA !enemy_palette,X

    RTL

print "egg shield main"
print pc
EggShieldMain:
    LDX !enemy_index

    LDA !enemy_id
    BNE +
    JSL $A0A3AF ; kill
    RTL
+

    DEC !enemy_var1,X
    BNE +
-
    JSL $808111   ; rng       
    AND #$000C
    CMP !enemy_var0,X
    BEQ -
    STA !enemy_var0,X ; target node

    JSL $808111   ; rng       
    AND #$000F
    CLC : ADC #$0020
    STA !enemy_var1,X
+

    LDA !frame_count
    AND #$0003
    BNE .no_accel
    
    LDY !enemy_var0,X

    LDA.w EggShield_Nodes,Y
    SEC
    SBC !enemy_X,X
    STA $12

    LDA.w EggShield_Nodes+2,Y
    SEC
    SBC !enemy_Y,X
    STA $14

    PHX
    JSL $A0C0AE ; get angle
    ASL A
    TXY
    TAX

    ; accellerate
    LDA #$0200
    STA $00
    LDA $A0B443,x ; horizontal component
    LSR
    JSL $A0AFEA ; sign extend
    CLC : ADC !enemy_var2,Y
    JSL ClampValue
    STA !enemy_var2,Y

    LDA #$0200
    STA $00
    LDA $A0B3C3,x ; vertical component
    LSR
    JSL $A0AFEA ; sign extend
    CLC : ADC !enemy_var3,Y
    JSL ClampValue
    STA !enemy_var3,Y

    PLX
    
.no_accel
    ; move X
    LDA !enemy_var2,X
    XBA : AND #$FF00
    CLC : ADC !enemy_X_sub,X
    STA !enemy_X_sub,X
    LDA !enemy_var2,X
    AND #$FF00
    XBA
    JSL $A0AFEA ; sign extend
    CLC : ADC !enemy_X,X
    STA !enemy_X,X

    ; move Y
    LDA !enemy_var3,X
    XBA : AND #$FF00
    CLC : ADC !enemy_Y_sub,X
    STA !enemy_Y_sub,X
    LDA !enemy_var3,X
    AND #$FF00
    XBA
    JSL $A0AFEA ; sign extend
    CLC : ADC !enemy_Y,X
    STA !enemy_Y,X


    LDA !enemy_health+1,X
    AND #$0006
    TAY
    LDA.w EggShield_Insts,Y
    CMP !enemy_var4,X
    BEQ +
    STA !enemy_instruction,X
    STA !enemy_var4,X
    LDA #$0001
    STA !enemy_inst_timer,X
+

    RTL
    
print "egg shield shot"
print pc
EggShieldShot:
    JSL $A0A63D
    LDA !enemy_health,X
    BNE +
    JSR DecrementShieldCount
+
    RTL

print "egg shield touch"
print pc
EggShieldTouch:
    JSL $A0A477
    LDA !enemy_health,X
    BNE +
    JSR DecrementShieldCount
+
    RTL

print "egg shield pb"
print pc
EggShieldPB:
    JSL $A0A597
    LDA !enemy_health,X
    BNE +
    JSR DecrementShieldCount
+
    RTL

DecrementShieldCount:
    LDA !enemy_exvar30
    DEC
    STA !enemy_exvar30
    LDA #$0300
    STA !enemy_exvar31
    RTS



EggShield_InitialSpeed:
    DW $FF00, $0100

EggShield_InitialPos:
    DW $FFF0, $0010

EggShield_Nodes:
        ; X     Y
    DW $00C0, $00E0
    DW $0140, $00E0
    DW $0080, $0180
    DW $0180, $0180

EggShield_Insts:
    DW #EggShield_Inst2, #EggShield_Inst1, #EggShield_Inst0, #EggShield_Inst0

EggShield_Inst0:
    DW $0001, #EggShield_OAM0
    DW $812F ; sleep
EggShield_Inst1:
    DW $0001, #EggShield_OAM1
    DW $812F ; sleep
EggShield_Inst2:
    DW $0001, #EggShield_OAM2
    DW $812F ; sleep

EggShield_OAM0:
    DW $0001
        DW $81F8 : DB $F8 : DW $3104
EggShield_OAM1:
    DW $0001
        DW $81F8 : DB $F8 : DW $318C
EggShield_OAM2:
    DW $0001
        DW $81F8 : DB $F8 : DW $31CC


SpawnChozoOrbs:
    LDX !enemy_index
    LDY !enemy_var3,X
    LDA.w ChozoOrbAttacks-2,Y
    TAY
    JSL $868027
    RTL

ChozoOrbAttacks:
    DW $AD7A, #Missile_Header

SpawnEyeLaser:
    LDX !enemy_index
    LDY !enemy_var3,X
    CPY #$0004
    BNE +
    LDA #$0001
    STA !enemy_timer,X
+
    LDA.w EyeLaserAttacks-2,Y
    TAY
    JSL $868027
    RTL

EyeLaserAttacks:
    DW $B428, #Hyper_Header


SpawnShieldEgg_Inst:
    DW $D38F          ; play sfx
    DW SpawnEggAttack ; spawn egg
    DW $813A, $0020   ; Wait frames
    DW $8110, #SpawnShieldEgg_Inst ; for loop
    DW $80ED, #DoneSpawningInst    ; jmp


SpawnEggAttack:
    PHY : PHX
    LDX.w #EggShieldInstance
    JSL $A09275 ; spawn enemy
    PLX : PLY
    RTL

CheckShield:
    LDX !enemy_index
    LDA #$0006
    STA !enemy_timer,X

    LDA !enemy_exvar30,X
    BNE +
    LDA !enemy_exvar31,X
    BNE +
    LDA !enemy_var3,X
    CMP #$0004
    BNE +
    LDA #$0003
    STA !enemy_timer,X
    JMP $80ED ; goto [Y]
+
    INY : INY
    RTL

EggAttacks:
    DW $B1C0, $FDC0

EggShieldInstance:
    DW $FDC0 ;Enemy ID
    DW $0000 ;X position
    DW $0000 ;Y position
    DW $0000 ;instruction
    DW $2800 ;prop1
    DW $0000 ;prop2
    DW $0000 ;param1
    DW $0000 ;param2


LoadHPPalettes:
    PHX
    PHY
    PHB
    PHK         ;\
    PLB         ;} DB = $84
    XBA         ; A /= 100h
    AND #$0078  ; A &= 78h (round down to multiple of 8)
    BIT #$0040  ;\
    BEQ $03     ;} A = min(38h, [A])
    LDA #$0038  ;/

    ASL A       ;\
    ASL A       ;|
    ORA #$001E  ;} Y = [A] / 8 * 20h + 1Eh

    ; offset for ST
    LDX !enemy_index
    LDY !enemy_var3,X
    CLC : ADC PaletteOffsets-2,Y
    PHA
    LDA PaletteBanks-2,Y
    PHA : PLB : PLB
    PLY

    LDX #$001E  ; X = 1Eh
    JML $84801A ; copy palette colors

PaletteOffsets:
    DW $8032, ST_Palettes_1
PaletteBanks:
    DW $8484, $AAAA

ST_Palettes_1:
    DW $1000, $56BA, $41B2, $1447, $0403, $4E15, $3570, $24CB, $1868, $6F7F, $51F8, $410E, $031F, $01DA, $00F5, $0C63
    DW $1400, $56D9, $39F0, $1066, $0403, $4633, $2DAE, $210A, $1487, $6F9B, $5215, $3D2C, $033F, $021A, $0136, $0C63
    DW $1C00, $5318, $2E0E, $1086, $0402, $3E71, $25CC, $1929, $10C6, $6F96, $5251, $396A, $035F, $025A, $0158, $0863
    DW $2000, $5337, $264C, $0CA5, $0402, $368F, $1E0A, $1568, $0CE5, $6FB2, $526E, $3588, $037F, $029A, $0199, $0863
    DW $2800, $4F56, $1E8B, $08A5, $0001, $2ECC, $1A28, $11A6, $0D25, $73AD, $4EAA, $35A6, $039F, $02BB, $01BB, $0443
    DW $2C00, $4F75, $16C9, $04C4, $0001, $26EA, $1266, $0DE5, $0944, $73C9, $4EC7, $31C4, $03BF, $02FB, $01FC, $0443
    DW $3400, $4BB4, $0AE7, $04E4, $0000, $1F28, $0A84, $0604, $0583, $73C4, $4F03, $2E02, $03DF, $033B, $021E, $0043
    DW $3800, $4BD3, $0325, $0103, $0000, $1746, $02C2, $0243, $01A2, $73E0, $4F20, $2A20, $03FF, $037B, $025F, $0043

ST_Palettes_2:
    DW $1000, $4215, $2D0D, $0002, $0000, $3970, $20CB, $0C26, $0403, $463A, $28B3, $1809, $6F7F, $51FD, $4113, $0C63
    DW $1400, $4234, $254C, $0002, $0000, $318E, $1D0A, $0C65, $0423, $4656, $28D0, $1428, $5F7E, $461C, $3934, $0C63
    DW $1C00, $3E73, $216A, $0022, $0000, $29CC, $1928, $0885, $0443, $4693, $290E, $1046, $4F5D, $3A3B, $2D55, $0842
    DW $2000, $3E92, $19A9, $0022, $0000, $21EA, $1567, $08C4, $0463, $46AF, $292B, $0C65, $3F5C, $2E5A, $2576, $0842
    DW $2800, $3AB1, $15C8, $0022, $0000, $1A27, $0D86, $0504, $00A3, $4ACB, $2568, $0C84, $335C, $2658, $1D76, $0421
    DW $2C00, $3AD0, $0E07, $0022, $0000, $1245, $09C5, $0543, $00C3, $4AE7, $2585, $08A3, $235B, $1A77, $1597, $0421
    DW $3400, $370F, $0A25, $0042, $0000, $0A83, $05E3, $0163, $00E3, $4B24, $25C3, $04C1, $133A, $0E96, $09B8, $0000
    DW $3800, $372E, $0264, $0042, $0000, $02A1, $0222, $01A2, $0103, $4B40, $25E0, $00E0, $0339, $02B5, $01D9, $0000


print "super torizo main"
print pc
SuperTorizo_Main:
    LDX !enemy_index

    LDA !enemy_exvar30,X
    BEQ .visible
    LDA !frame_count
    BIT #$0001
    BEQ .visible
.invisible
    LDA !enemy_prop1
    ORA #$0080 ; super invis
    STA !enemy_prop1
    BRA .continue
.visible
    LDA !enemy_prop1
    AND #$FF7F ; visible
    STA !enemy_prop1
.continue

    LDA !enemy_exvar31,X
    BEQ +
    DEC
    STA !enemy_exvar31,X
+

    LDA !samus_pose
    CMP #$001B
    BEQ .space_jump
    CMP #$001C
    BEQ .space_jump
    LDA #$0000
    STA !enemy_exvar07,x
    BRA .return

.space_jump
    LDA !enemy_exvar07,x    
    INC A
    STA !enemy_exvar07,x    

.return
    JSR (!enemy_var4,x)     
    RTL


AddSpriteMapToOAM1:
    PHB
    LDA !proj_id,X
    CMP #Hyper_Header
    BNE +
    PEA.w $8585 : PLB : PLB
+
    JSL $818C0A ;} Add spritemap to OAM with base tile number
    PLB
    RTL

AddSpriteMapToOAM2:
    LDA !proj_id,X
    CMP #Hyper_Header
    BEQ +
    JSL $818C7F ;} Add spritemap to OAM with base tile number offscreen
+
    RTL

HandleDamageInvuln:
    LDA !enemy_exvar30,X
    BEQ .vulnerable
.invulnerable
    PHX : PHP
    LDA $18A6   ;\
    ASL A       ;|
    TAX         ;|
    LDA $0C04,x ;} Flag projectile for deletion
    ORA #$0010  ;|
    STA $0C04,x ;/
    LDA $0B64,x ;\
    STA $12     ;|
    LDA $0B78,x ;|
    STA $14     ;|
    LDA #$0006  ;} Create sprite object 6 at projectile position
    STA $16     ;|
    STZ $18     ;|
    JSL $B4BC26 ;/
    LDA #$003D  ;\
    JSL $809035 ;} Queue sound 3Dh, sound library 1, max queued sounds allowed = 3 (dud shot)
    PLP : PLX
    BRA .return
.vulnerable
    JSL $A0A6A7
.return
    RTL


TestHyperBeam:
    LDA !enemy_var3,X
    CMP #$0004
    BNE +
    PLA : PEA.w TestHyperBeam_SkipDistanceCheck-1
+
    LDA #$0020 ; displaced
    RTS


SuperReaction:
    LDA !enemy_var3,X
    CMP #$0004
    BNE .normalTorizo

    PHX : PHY
    LDY #$0022
-
    LDA !proj_id,Y
    CMP.w #Hyper_Header
    BEQ +
    DEY : DEY
    BPL -

    JSL SpawnEyeLaser
+
    PLY : PLX
    LDA #$8000
    RTS

.normalTorizo
    JSR $D3A7 ; IsSamusInFront, displaced
    RTS    

warnpc $AB8000

org $AAD45C
TestHyperBeam_SkipDistanceCheck:

org $84801A : LDA.w $0100,Y ; LDA $8132,y
org $848021 : LDA.w $0000,Y ; LDA $8032,y
org $868410 : JSL AddSpriteMapToOAM1 ; JSL $818C0A ;} Add spritemap to OAM with base tile number
org $868421 : JSL AddSpriteMapToOAM2 ; JSL $818C7F ;} Add spritemap to OAM with base tile number offscreen
org $AAD3B5 : JSL LoadHPPalettes ; JSL $848000  
org $AAD43D : JSL SpawnEyeLaser ; JSL $868097            ;} Spawn Golden Torizo eye beam enemy 
org $AAD4F7 : JSL SpawnChozoOrbs ; JSL $868027            ;} Spawn Golden Torizo's chozo orbs enemy projectile
org $AAD6A6 : JSL HandleDamageInvuln ; JSL $A0A6A7           ; handle damage
org $AAD44A : JSR TestHyperBeam ; LDA #$0020
org $AAD6F7 : JSR SuperReaction ; JSR $D3A7 ; IsSamusInFront            


; low health egg attack threashold
org $AAD474 : LDA #$1800 ; #$0788

;$AA:D49B A9 30 2A    LDA #$2A30

org $AAD077
    DW #CheckShield, #SpawnShieldEgg_Inst
    ;DW $8123, $0006   ; Timer = 0006h
org $AAD087
DoneSpawningInst:


org $AFE600
    incbin ROMProject/Graphics/hyperbeam.gfx

