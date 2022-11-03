lorom

;energy tank
org $848975:
  NOP : NOP : NOP ;LDA #$0168
  NOP : NOP : NOP : NOP ;JSL $82E118

;reserve tank
org $848998:
  NOP : NOP : NOP ;LDA #$0168
  NOP : NOP : NOP : NOP ;JSL $82E118

org $84E43F
  DW $8C07 ;DW $8BDD
    DB $2B ;DB $02
org $84E904
  DW $8C07 ;DW $8BDD
    DB $2B ;DB $02
org $84EE3E
  DW $8C07 ;DW $8BDD
    DB $2B ;DB $02