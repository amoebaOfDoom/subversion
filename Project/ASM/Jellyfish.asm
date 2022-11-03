lorom

org $A3FB70  ;free space
  LDX $0E54
  LDA #InstructionList
  JMP $8D33

;InstructionList:
;  DW $0002, SpriteMap_Brighness6_0
;  DW $0001, SpriteMap_Brighness6_1
;  DW $0002, SpriteMap_Brighness6_2
;  DW $0001, SpriteMap_Brighness6_1
;  DW $0002, SpriteMap_Brighness6_0
;  DW $0001, SpriteMap_Brighness6_1
;  DW $0002, SpriteMap_Brighness6_2
;  DW $0001, SpriteMap_Brighness6_1
;  DW $0002, SpriteMap_Brighness5_0
;  DW $0001, SpriteMap_Brighness5_1
;  DW $0002, SpriteMap_Brighness5_2
;  DW $0001, SpriteMap_Brighness5_1
;  DW $0002, SpriteMap_Brighness4_0
;  DW $0001, SpriteMap_Brighness4_1
;  DW $0002, SpriteMap_Brighness4_2
;  DW $0001, SpriteMap_Brighness4_1
;  DW $0002, SpriteMap_Brighness3_0
;  DW $0001, SpriteMap_Brighness3_1
;  DW $0002, SpriteMap_Brighness3_2
;  DW $0001, SpriteMap_Brighness3_1
;  DW $0002, SpriteMap_Brighness2_0
;  DW $0001, SpriteMap_Brighness2_1
;  DW $0002, SpriteMap_Brighness2_2
;  DW $0001, SpriteMap_Brighness2_1
;  DW $0002, SpriteMap_Brighness1_0
;  DW $0001, SpriteMap_Brighness1_1
;  DW $0002, SpriteMap_Brighness1_2
;  DW $0001, SpriteMap_Brighness1_1
;  DW $0002, SpriteMap_Brighness0_0
;  DW $0001, SpriteMap_Brighness0_1
;  DW $0002, SpriteMap_Brighness0_2
;  DW $0001, SpriteMap_Brighness0_1
;  DW $0002, SpriteMap_Brighness1_0
;  DW $0001, SpriteMap_Brighness1_1
;  DW $0002, SpriteMap_Brighness1_2
;  DW $0001, SpriteMap_Brighness1_1
;  DW $0002, SpriteMap_Brighness2_0
;  DW $0001, SpriteMap_Brighness2_1
;  DW $0002, SpriteMap_Brighness2_2
;  DW $0001, SpriteMap_Brighness2_1
;  DW $0002, SpriteMap_Brighness3_0
;  DW $0001, SpriteMap_Brighness3_1
;  DW $0002, SpriteMap_Brighness3_2
;  DW $0001, SpriteMap_Brighness3_1
;  DW $0002, SpriteMap_Brighness4_0
;  DW $0001, SpriteMap_Brighness4_1
;  DW $0002, SpriteMap_Brighness4_2
;  DW $0001, SpriteMap_Brighness4_1
;  DW $0002, SpriteMap_Brighness5_0
;  DW $0001, SpriteMap_Brighness5_1
;  DW $0002, SpriteMap_Brighness5_2
;  DW $0001, SpriteMap_Brighness5_1
;  DW $80ED, InstructionList

InstructionList:
  DW $0006, SpriteMap_Brighness6_0
  DW $0003, SpriteMap_Brighness6_1

  DW $0003, SpriteMap_Brighness5_1
  DW $0006, SpriteMap_Brighness5_2

  DW $0006, SpriteMap_Brighness4_1
  DW $0003, SpriteMap_Brighness4_0
  
  DW $0003, SpriteMap_Brighness3_0
  DW $0006, SpriteMap_Brighness3_1

  DW $0006, SpriteMap_Brighness2_2
  DW $0003, SpriteMap_Brighness2_1
  
  DW $0003, SpriteMap_Brighness1_1
  DW $0006, SpriteMap_Brighness1_0
  
  DW $0006, SpriteMap_Brighness0_1
  DW $0003, SpriteMap_Brighness0_2
  
  DW $0003, SpriteMap_Brighness1_2
  DW $0006, SpriteMap_Brighness1_1
  
  DW $0006, SpriteMap_Brighness2_0
  DW $0003, SpriteMap_Brighness2_1
  
  DW $0003, SpriteMap_Brighness3_1
  DW $0006, SpriteMap_Brighness3_2
  
  DW $0006, SpriteMap_Brighness4_1
  DW $0003, SpriteMap_Brighness4_0
  
  DW $0003, SpriteMap_Brighness5_0
  DW $0006, SpriteMap_Brighness5_1

  DW $0006, SpriteMap_Brighness6_2
  DW $0003, SpriteMap_Brighness6_1

  DW $0003, SpriteMap_Brighness5_1
  DW $0006, SpriteMap_Brighness5_0

  DW $0006, SpriteMap_Brighness4_1
  DW $0003, SpriteMap_Brighness4_2
  
  DW $0003, SpriteMap_Brighness3_2
  DW $0006, SpriteMap_Brighness3_1

  DW $0006, SpriteMap_Brighness2_0
  DW $0003, SpriteMap_Brighness2_1
  
  DW $0003, SpriteMap_Brighness1_1
  DW $0006, SpriteMap_Brighness1_2
  
  DW $0006, SpriteMap_Brighness0_1
  DW $0003, SpriteMap_Brighness0_0
  
  DW $0003, SpriteMap_Brighness1_0
  DW $0006, SpriteMap_Brighness1_1
  
  DW $0006, SpriteMap_Brighness2_2
  DW $0003, SpriteMap_Brighness2_1
  
  DW $0003, SpriteMap_Brighness3_1
  DW $0006, SpriteMap_Brighness3_0
  
  DW $0006, SpriteMap_Brighness4_1
  DW $0003, SpriteMap_Brighness4_2
  
  DW $0003, SpriteMap_Brighness5_2
  DW $0006, SpriteMap_Brighness5_1

  DW $80ED, InstructionList

SpriteMap_Brighness6_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $3120
  DW $0004 : DB $F4 : DW $7120
  DW $01F4 : DB $04 : DW $3130
  DW $0004 : DB $04 : DW $7130

  DW $01FC : DB $F0 : DW $3121
  DW $01F2 : DB $FC : DW $3131
  DW $0006 : DB $FC : DW $7131

  DW $81F8 : DB $F6 : DW $3100
SpriteMap_Brighness6_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $3122
  DW $0004 : DB $F4 : DW $7122
  DW $01F4 : DB $04 : DW $3132
  DW $0004 : DB $04 : DW $7132

  DW $01FC : DB $F0 : DW $3123
  DW $01F2 : DB $FC : DW $3133
  DW $0006 : DB $FC : DW $7133

  DW $81F8 : DB $F6 : DW $3100
SpriteMap_Brighness6_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $3124
  DW $0004 : DB $F4 : DW $7124
  DW $01F4 : DB $04 : DW $3134
  DW $0004 : DB $04 : DW $7134

  DW $01FC : DB $F0 : DW $3125
  DW $01F2 : DB $FC : DW $3135
  DW $0006 : DB $FC : DW $7135

  DW $81F8 : DB $F6 : DW $3100
SpriteMap_Brighness5_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $3120
  DW $0004 : DB $F4 : DW $7120
  DW $01F4 : DB $04 : DW $3130
  DW $0004 : DB $04 : DW $7130

  DW $01FC : DB $F0 : DW $3121
  DW $01F2 : DB $FC : DW $3131
  DW $0006 : DB $FC : DW $7131

  DW $81F8 : DB $F6 : DW $3102
SpriteMap_Brighness5_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $3122
  DW $0004 : DB $F4 : DW $7122
  DW $01F4 : DB $04 : DW $3132
  DW $0004 : DB $04 : DW $7132

  DW $01FC : DB $F0 : DW $3123
  DW $01F2 : DB $FC : DW $3133
  DW $0006 : DB $FC : DW $7133

  DW $81F8 : DB $F6 : DW $3102
SpriteMap_Brighness5_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $3124
  DW $0004 : DB $F4 : DW $7124
  DW $01F4 : DB $04 : DW $3134
  DW $0004 : DB $04 : DW $7134

  DW $01FC : DB $F0 : DW $3125
  DW $01F2 : DB $FC : DW $3135
  DW $0006 : DB $FC : DW $7135

  DW $81F8 : DB $F6 : DW $3102
SpriteMap_Brighness4_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $3126
  DW $0004 : DB $F4 : DW $7126
  DW $01F4 : DB $04 : DW $3136
  DW $0004 : DB $04 : DW $7136

  DW $01FC : DB $F0 : DW $3127
  DW $01F2 : DB $FC : DW $3137
  DW $0006 : DB $FC : DW $7137

  DW $81F8 : DB $F6 : DW $3104
SpriteMap_Brighness4_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $3128
  DW $0004 : DB $F4 : DW $7128
  DW $01F4 : DB $04 : DW $3138
  DW $0004 : DB $04 : DW $7138

  DW $01FC : DB $F0 : DW $3129
  DW $01F2 : DB $FC : DW $3139
  DW $0006 : DB $FC : DW $7139

  DW $81F8 : DB $F6 : DW $3104
SpriteMap_Brighness4_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $312A
  DW $0004 : DB $F4 : DW $712A
  DW $01F4 : DB $04 : DW $313A
  DW $0004 : DB $04 : DW $713A

  DW $01FC : DB $F0 : DW $312B
  DW $01F2 : DB $FC : DW $313B
  DW $0006 : DB $FC : DW $713B

  DW $81F8 : DB $F6 : DW $3104
SpriteMap_Brighness3_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $3126
  DW $0004 : DB $F4 : DW $7126
  DW $01F4 : DB $04 : DW $3136
  DW $0004 : DB $04 : DW $7136

  DW $01FC : DB $F0 : DW $3127
  DW $01F2 : DB $FC : DW $3137
  DW $0006 : DB $FC : DW $7137

  DW $81F8 : DB $F6 : DW $3106
SpriteMap_Brighness3_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $3128
  DW $0004 : DB $F4 : DW $7128
  DW $01F4 : DB $04 : DW $3138
  DW $0004 : DB $04 : DW $7138

  DW $01FC : DB $F0 : DW $3129
  DW $01F2 : DB $FC : DW $3139
  DW $0006 : DB $FC : DW $7139

  DW $81F8 : DB $F6 : DW $3106
SpriteMap_Brighness3_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $312A
  DW $0004 : DB $F4 : DW $712A
  DW $01F4 : DB $04 : DW $313A
  DW $0004 : DB $04 : DW $713A

  DW $01FC : DB $F0 : DW $312B
  DW $01F2 : DB $FC : DW $313B
  DW $0006 : DB $FC : DW $713B

  DW $81F8 : DB $F6 : DW $3106
SpriteMap_Brighness2_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $3126
  DW $0004 : DB $F4 : DW $7126
  DW $01F4 : DB $04 : DW $3136
  DW $0004 : DB $04 : DW $7136

  DW $01FC : DB $F0 : DW $3127
  DW $01F2 : DB $FC : DW $3137
  DW $0006 : DB $FC : DW $7137

  DW $81F8 : DB $F6 : DW $3108
SpriteMap_Brighness2_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $3128
  DW $0004 : DB $F4 : DW $7128
  DW $01F4 : DB $04 : DW $3138
  DW $0004 : DB $04 : DW $7138

  DW $01FC : DB $F0 : DW $3129
  DW $01F2 : DB $FC : DW $3139
  DW $0006 : DB $FC : DW $7139

  DW $81F8 : DB $F6 : DW $3108
SpriteMap_Brighness2_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $312A
  DW $0004 : DB $F4 : DW $712A
  DW $01F4 : DB $04 : DW $313A
  DW $0004 : DB $04 : DW $713A

  DW $01FC : DB $F0 : DW $312B
  DW $01F2 : DB $FC : DW $313B
  DW $0006 : DB $FC : DW $713B

  DW $81F8 : DB $F6 : DW $3108
SpriteMap_Brighness1_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $312C
  DW $0004 : DB $F4 : DW $712C
  DW $01F4 : DB $04 : DW $313C
  DW $0004 : DB $04 : DW $713C

  DW $01FC : DB $F0 : DW $312D
  DW $01F2 : DB $FC : DW $313D
  DW $0006 : DB $FC : DW $713D

  DW $81F8 : DB $F6 : DW $310A
SpriteMap_Brighness1_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $312E
  DW $0004 : DB $F4 : DW $712E
  DW $01F4 : DB $04 : DW $313E
  DW $0004 : DB $04 : DW $713E

  DW $01FC : DB $F0 : DW $312F
  DW $01F2 : DB $FC : DW $313F
  DW $0006 : DB $FC : DW $713F

  DW $81F8 : DB $F6 : DW $310A
SpriteMap_Brighness1_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $310E
  DW $0004 : DB $F4 : DW $710E
  DW $01F4 : DB $04 : DW $311E
  DW $0004 : DB $04 : DW $711E

  DW $01FC : DB $F0 : DW $310F
  DW $01F2 : DB $FC : DW $311F
  DW $0006 : DB $FC : DW $711F

  DW $81F8 : DB $F6 : DW $310A
SpriteMap_Brighness0_0:
  DW $0008
  DW $01F4 : DB $F4 : DW $312C
  DW $0004 : DB $F4 : DW $712C
  DW $01F4 : DB $04 : DW $313C
  DW $0004 : DB $04 : DW $713C

  DW $01FC : DB $F0 : DW $312D
  DW $01F2 : DB $FC : DW $313D
  DW $0006 : DB $FC : DW $713D

  DW $81F8 : DB $F6 : DW $310C
SpriteMap_Brighness0_1:
  DW $0008
  DW $01F4 : DB $F4 : DW $312E
  DW $0004 : DB $F4 : DW $712E
  DW $01F4 : DB $04 : DW $313E
  DW $0004 : DB $04 : DW $713E

  DW $01FC : DB $F0 : DW $312F
  DW $01F2 : DB $FC : DW $313F
  DW $0006 : DB $FC : DW $713F

  DW $81F8 : DB $F6 : DW $310C
SpriteMap_Brighness0_2:
  DW $0008
  DW $01F4 : DB $F4 : DW $310E
  DW $0004 : DB $F4 : DW $710E
  DW $01F4 : DB $04 : DW $311E
  DW $0004 : DB $04 : DW $711E

  DW $01FC : DB $F0 : DW $310F
  DW $01F2 : DB $FC : DW $311F
  DW $0006 : DB $FC : DW $711F

  DW $81F8 : DB $F6 : DW $310C

warnpc $A48000