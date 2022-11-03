lorom

; Fix shaktool death handling to load the primary index before calling the damage routine
; The damage routine clears the enemy data so the index needs to be retrieved first
; This takes advantage that the index is in Y initially and the damage routine has it in X after

org $AADF34
Shot:
	LDA $0FB0,Y ; A = [enemy primary piece enemy index]
	PHA
	JSL $A0A63D ; Normal enemy shot AI
	PLY
	LDA $0F8C,x
	BNE ShotReturn
	NOP
org $AADF5B
ShotReturn:
