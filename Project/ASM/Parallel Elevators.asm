lorom

org $A39515
  JSR RunElevatorCheck
  NOP : NOP : NOP
  ;LDA $0E16 ;Interacting with elevator flag
  ;ORA $0E18 ;Elevator activation state
  ;If no, branch...

org $A3952F
  JSR RunElevatorCheck
  NOP : NOP : NOP
  ;LDA $0E16 ;Interacting with elevator flag
  ;ORA $0E18 ;Elevator activation state
  ;If no, branch...

org $A3F340 ;free space
RunElevatorCheck:
  LDX $0E54
  LDA $0F7A,X ;Elevator X position
  SEC
  SBC $0AF6 ;Samus' X position
  CMP #$0080;Is Samus nearby this elevator?
  BCC CheckElevatorFlags
  CMP #$FF80
  BCS CheckElevatorFlags
  LDA #$0000
  RTS

CheckElevatorFlags:
  LDA $0E16 ;Interacting with elevator flag
  ORA $0E18 ;Elevator activation state
  RTS