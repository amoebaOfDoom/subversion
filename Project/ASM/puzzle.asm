lorom 

org $84FFE0
Header:
    DW $C7B1, #InstructionList, $C1E4

InstructionList:
    DW $8A72, $C4E2 ; Go to $C4E2 if the room argument door is set
    DW $8A24, $C20D ; Link instruction = $C20D
    DW $86C1, $BD88 ; Pre-instruction = go to link instruction if shot with a super missile
    DW $86B4        ; Sleep
warnpc $84FFFF

org $A8972C
    JSR InitShotReact
    ; STZ enemy_var4,x

org $A8FB00
ShotReact:
    LDX $0E54
    LDA $7E7802,X
    BNE +
    LDA #$0001
    STA $7E7802,X

    LDA $18A6 ; projectile index
    ASL A
    TAX
    LDA $0C18,X ; projectile type
    AND #$000F ; beam types
    CMP #$0002 ; ice
    BNE +

    LDA #$0312
    STA $0DC4 ; plm position
    LDA #CrumbleLeftPLM
    JSL $8484E7

    ; quake
    LDA #$0090
    STA $1840
    LDA #$0012
    STA $183E

+
    JSL $A0A63D
    RTL

InitShotReact:
    LDA #$0000
    STA $7E7802,X
    STZ $0FB0,X
    RTS


org $B3EAA4
    DW #CheckOffScreen,$EA80

org $B3ED77
CheckOffScreen:
    LDX $0E54
    LDA $0F7A,X
    CMP #$0380
    BMI +

    LDA $7FFF06
    CMP #$0001
    BEQ .second_hint
.first_hint
    LDA #$0001
    STA $7FFF04
    LDA #$002D
    BRA .message

.second_hint
    LDA #$0002
    STA $7FFF04
    LDA #$0030

.message
    JSL $858080 ; Display message box

    LDA #$0001
    STA $7FFF02
    JSL $81EF20 ; save global sram

    LDA $0F86,X
    ORA #$0200
    STA $0F86,X
+
    JMP $80ED


org $84F380
OrbItemHeader:
    DW $EE64, OrbItem_Inst

OrbItem_Inst:
    DW OrbTest
    DW $86C1, $DF89             ; set pre-PLM pointer
    DW $8A24, OrbItem_Get       ; set Get pointer 

OrbItem_Loop:
    DW $0014, OrbItem_Frame1
    DW $000A, OrbItem_Frame2
    DW $0014, OrbItem_Frame3
    DW $000A, OrbItem_Frame2
    DW $8724, OrbItem_Loop   ; Go to loop

OrbItem_Get:
    ;DW $8BDD                   ; play sound
    ;   DB $02                  ;     #2
    DW OrbGet
    DW $0001, $A2B5             ; draw air

OrbItem_Kill:
    DW $86BC

OrbGet:
    LDA $7FFF00
    ORA #$0004
    STA $7FFF00
    JSL $81EF20 ; save global sram
    LDA #$002F
    JSL $858080 ; Display message box
    RTS

OrbTest:
    LDA $7FFF00
    BIT #$0004
    BEQ +
    LDY.w #OrbItem_Kill
+
    RTS


OrbItem_Frame1:
    DW $0001, $B072
    DW $0000
OrbItem_Frame2:
    DW $0001, $B073
    DW $0000
OrbItem_Frame3:
    DW $0001, $B074
    DW $0000


CrumbleLeftPLM:
    DW $B3C1, CrumbleLeftPLM_Inst

CrumbleLeftPLM_Inst:
    DW $874E : DB $03     ; Timer = 0Bh
CrumbleLeftPLM_Loop:
    DW $0008, $A345       ;Animation for breaking block
    DW $0008, $A34B
    DW $0008, $A351
    DW $0020, $A357
    DW MoveLeft
    DW $873F, CrumbleLeftPLM_Loop  ; Decrement timer and go to $ABAC if non-zero
    DW $86BC              ; Delete

MoveLeft:
    DEC $1C87,x
    DEC $1C87,x
    RTS

warnpc $84FFFF


org $8FFF10
StateTestDemo:
    LDA $0998
    CMP #$0027
    BMI StateTest_Fail
StateTest_Pass:
    LDA $0000,X
    TAX
    JMP $E5E6
StateTest_Fail:
    INX
    INX
    RTS

print pc
StateTestPuzzle:
    LDA $7FFF04
    CMP #$0001
    BEQ StateTest_Fail
    BRA StateTest_Pass

warnpc $8FFFFF