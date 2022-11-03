lorom

; PLM D70C (Maridia Tube) Header
org $84D70C
    ;DW $D6CC, #TubeInstructions

; PLM D70C (Maridia Tube) Instruction List
org $84D4D4
    ;DW $FFFF,; $882D, $000B, $D521 ; Go to $D521 if the event 000Bh is set 
TubeInstructions:
    DW #TestEventTriggered, #TriggerTube
    DW $8A24, #TriggerPowerBomb ; Link instruction = $D4E8
    DW $86C1, $BD26        ; Pre-instruction = go to link instruction if shot with a power bomb
    DW $0001, $98D1  
    DW $86B4               ; Sleep

TriggerPowerBomb:   
;    DW $8A24, #TriggerMoved; Link instruction = $D4F2
;    DW $86C1, $D4BF        ; Pre-instruction = wake PLM if A/X/B/Y/left/right pressed
;    DW $86B4               ; Sleep

TriggerMoved:
;    DW $86CA               ; Clear pre-instruction
;    DW $D5E6               ; Disable Samus' controls
    DW $D52C               ; Spawn tube crack enemy projectile
    DW $0030, $98D7  
    DW $0001, $9991  
    DW $0001, $99E5  
    DW $8C10 : DB $1A      ; Queue sound 1Ah, sound library 2, max queued sounds allowed = 6
    DW $D543               ; Spawn ten tube shards and six tube released air bubbles
    DW $D536               ; 40h-frame 1-pixel BG1/BG2 diagonal earthquake
    DW $0060, $98DD  
    DW #SetPLMArgEvent

TriggerTube:
    DW $D525               ; Enable water physics
;    DW $D5EE               ; Enable Samus' controls
    DW $86BC               ; Delete

TestEventTriggered:
    LDA $1DC7,X
    JSL $808233
    BCC TestEventTriggered_Return
    JMP $8724
TestEventTriggered_Return:
    INY : INY
    RTS

warnpc $84D526


org $84DB1E
EventPLMSetup:
    LDX $1DC7,Y
    LDA #EventPLMSetup_PreInstruction
    STA $1CD7,Y
    RTS

EventPLMSetup_PreInstruction:
    LDA $0E50
    CMP $0E52
    BCC SetPLMArgEvent_Return
SetPLMArgEvent: 
    LDA $1DC7,X
    JSL $8081FA
SetPLMArgEvent_Return:
    RTS

warnpc $84DB43
