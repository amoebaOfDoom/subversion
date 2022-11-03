lorom

; patches horizontal PLM updates to DMA tiles even when the PLM is above the screen if part of it is on the screen

org $848DA0
SkipEntry_Inject:
  JMP SkipEntry

;$84:8DE8 C5 1A       CMP $1A    [$7E:001A]  ;} If [PLM draw Y block] < [screen Y block]: return
org $848DEA
  BMI SkipEntry_Inject

;$84:8E10 C5 16       CMP $16    [$7E:0016]  ;} If [draw length] + [PLM draw X block] <= 0: return
org $848E12
SkipEntry_Inject_2:
  BEQ SkipEntry_Inject
SkipEntry_Inject_3:
  BMI SkipEntry_Inject

org $848E44
  BEQ SkipEntry_Inject_2

org $848E2D
  BMI SkipEntry_Inject_3
  NOP

org $84919A;918E
BRANCH_NEXT_DRAW_ENTRY:


org $84EFE8 ;free space
SkipEntry:
  LDA $0000,y
  ASL
  STA $14
  TYA
  CLC
  ADC #$0002
  ADC $14
  TAY
  JMP BRANCH_NEXT_DRAW_ENTRY