lorom

org $A6FF05
Right_Locking_Inst:
    DW $F68B        ; Set enemy to ignore Samus/projectiles
    DW $F6A6        ; Set enemy to invisible
    DW $0002,$FAA7
    DW $F695        ; Set enemy to not ignore Samus/projectiles
    DW $F6B3        ; Set enemy to visible
    DW $0002,$FAA7
    DW $0002,$FA87
    DW $0002,$FA67
    DW $0002,$FA3D
    DW $F695        ; Set enemy to not ignore Samus/projectiles
    DW $F6B3        ; Set enemy to visible
.closed
    DW $0002,$FA13
    DW $80ED,.closed


Left_Locking_Inst:
    DW $F68B        ; Set enemy to ignore Samus/projectiles
    DW $F6A6        ; Set enemy to invisible
    DW $0002,$F9F3
    DW $F695        ; Set enemy to not ignore Samus/projectiles
    DW $F6B3        ; Set enemy to visible
    DW $0002,$F9F3
    DW $0002,$F9D3
    DW $0002,$F9B3
    DW $0002,$F989
    DW $F695        ; Set enemy to not ignore Samus/projectiles
    DW $F6B3        ; Set enemy to visible
.closed                    
    DW $0002,$F95F
    DW $80ED,.closed

; Instruction pointers, indexed by [enemy parameter 1]
Inst_Table:            
    DW $F56C, $F5BE, $F610, $F53A, $F61A, $F62A, $F634
    DW #Right_Locking_Inst, #Left_Locking_Inst

; Function pointers, indexed by [enemy parameter 1]
ASM_Table:          
    DW $F76B, $F76B, $F7BD, $F770, $F76B, $F7A5, $F7A5
    DW $F76B, $F76B
warnpc $A6FFFF

org $A6F6E5 : LDA.w ASM_Table,Y
org $A6F6EB : LDA.w Inst_Table,Y
