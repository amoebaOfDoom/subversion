lorom

; Sound 51h: Shot Wrecked Ship ghost
; change instrument
;$41EE:           dw 41F2, 4207
;$41F2:           db 19,60,0A,A4,13, 19,50,0A,A4,13, 19,30,0A,A4,13, 19,10,0A,A4,13, FF
;$4207:           db 19,60,0A,9F,16, 19,50,0A,9F,16, 19,30,0A,9F,16, 19,10,0A,9F,16, FF


; make super invis
org $A89AF4 : ORA #$2580
org $A89BC3 : AND #$FE7F
org $A89C58 : AND #$FE7F
org $A89C7D : ORA #$0180
