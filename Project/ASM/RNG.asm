lorom

; 16bit xorshift rng using extra state
; good options for shift values and example code from https://b2d-f9r.blogspot.com/2010/08/16-bit-xorshift-rng-now-with-more.html
; asm based on total's from arcade

; const int A = 5;
; const int B = 3;
; const int C = 1;
;
; static ushort x = 1;
; static ushort y = 1;
;
; ushort rnd_xorshift_32()
; {
;   ushort t1 = (x ^ (x << A));
;   ushort t2 = (t1 ^ (t1 >> B));
;   x = y;
;   return y = (y ^ (y >> C)) ^ t2;
; }

org $808111
Generate:
  REP #$20 ; original function doesn't preserve P either and it seems to matter

  ; t1 = x ^ (x << A)
  LDA $1C21
  ASL : ASL : ASL : ASL : ASL
  EOR $1C21
  STA $3E

  ; t2 = t1 ^ (t1 >> B);
  LSR : LSR : LSR
  EOR $3E
  STA $3E

  ; x = y;
  LDA $05E5
  STA $1C21

  ; y = (y ^ (y >> C)) ^ t2;
  LSR
  EOR $05E5
  EOR $3E
  STA $05E5

  RTL

Init:
  LDA #$0001
  STA $05E5
  STA $1C21
  RTL

warnpc $808146

org $808534
  JSL Init
  NOP : NOP

;;; $B3B0: Pre-instruction: lava/acid BG3 Y scroll ;;;
org $88B44A
  JSL $808111
  NOP : NOP : NOP 
  ;LDA $05E5
  ;XBA
  ;STA $05E5

;;; $B570: Initialisation AI - enemy $D1FF
org $A2B58B
  NOP : NOP : NOP ;STA $05E5

;;; $A2D0: Main AI - enemy $D87F/$D8BF (roach) ;;;
org $A3A31B
  NOP : NOP : NOP ;STA $05E5
org $A3A325
  NOP : NOP : NOP ;STA $05E5

;;; $AB09: Initialisation AI - enemy $D93F/$D97F/$D9BF/$D9FF/$DA3F (sidehopper / desgeega / super-sidehopper / super-desgeega) ;;;
org $A3AB0F
  NOP : NOP : NOP ;STA $05E5

;;; $B776: Initialisation AI - enemy $E87F (beetom) ;;;
org $A8B79B
  NOP : NOP : NOP ;STA $05E5
