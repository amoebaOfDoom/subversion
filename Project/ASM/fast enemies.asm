lorom

org $A0908E
	LDA $1784
	PHA
	JSR ProcessAI
	PLA
	STA $1784
	BCS +

    LDA #$0038 ;hard mode
    JSL $808233
    BCC +

	LDX $0E54 
	LDA $0F78,X ; id
	BEQ +

	TAX
	LDA $A00016,X
	BNE +
	LDX $0E54 

	LDA $05B6 ; framecount
	AND #$0001
	BNE +
	JSR ProcessAI
+
	BRA ProcessDone

warnpc $A090EF

org $A090EF
ProcessDone:

org $A0FF40 ; free space
ExecuteMainAI:
	LDX $0E54  
	LDA $0FA6,x
	STA $1786  
	XBA
	PHA
	PLB
	PLB
	JML [$1784]

ProcessAI:
	PHB
	JSL ExecuteMainAI      ; Execute enemy AI pointer in enemy bank
	PLB

	LDA $0A78              ;\
	ORA $185E              ;} If time is not frozen and enemy time is not frozen:
	BNE .checkDeath
	LDX $0E54              ;\
	INC $0FA4,x            ;} Increment enemy frame counter
	LDA $0F86,x            ;\
	BIT #$2000             ;} If enemy processes instructions:
	BEQ .checkDeath
	LDA #$0002             ;\
	STA $7EF378            ;} Enemy processing stage = 2
	JSR $C26A              ; Process enemy instructions

.checkDeath
	LDX $0E54              ;\
	LDA $0F88,x            ;|
	BIT #$0001             ;} If enemy AI is enabled: go to BRANCH_KILL_ENEMY_END
	BEQ .finish
	LDA $0F9C,x            ;\
	CMP #$0001             ;} If [enemy flash timer] != 1:
	BEQ .kill
	LDA $0F9E,x            ;\
	CMP #$0001             ;} If [enemy frozen timer] != 1: go to BRANCH_KILL_ENEMY_END
	BNE .finish

.kill
; So apparently enemies die when their enemy AI is disabled (due to grapple?) and ([enemy flash timer] = 1 or [enemy frozen timer] = 1)
	LDA #$0000             ;\
	STA $7E7002,x          ;} Enemy $7E:7002 = 0
	LDA #$0000             ; A = 0
	JSL $A0A3AF            ; Death animation
	SEC
	RTS

.finish
	CLC
    RTS


org $868104
	PHP
	PHB
	PHK                    ;\
	PLB                    ;} DB = $86

    JSR ProcessEnemyProj
    LDA #$0038 ;hard mode
    JSL $808233
    BCC +
	LDA $05B6 ; framecount
	AND #$0001
	BNE +
    JSR ProcessEnemyProj
+
	PLB
	PLP
	RTL
warnpc $868125

org $86FD40 ; free space
ProcessEnemyProj:
	BIT $198D              ;\
	BPL .return            ;} If enemy projectiles not enabled: return
	LDX #$0022             ; X = 22h (enemy projectile index)

-
	STX $1991              ; Enemy projectile index = [X]
	LDA $1997,x            ;\
	BEQ +                  ;} If [enemy projectile ID] != 0:
	JSR $8125              ; Process enemy projectile
	LDX $1991              ; X = [enemy projectile index]
+
	DEX                    ;\
	DEX                    ;} X -= 2
	BPL -                  ; If [X] >= 0: go to LOOP
.return
	RTS

