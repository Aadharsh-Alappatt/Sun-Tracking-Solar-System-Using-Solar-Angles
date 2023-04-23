ORG 00H //Start the program
;angles
MOV R1,#18H   ;DECLINATION ANGLE WHEN THE DAY OF YEAR IS 103
MOV R6,#24H  ;zenith angle of 36 degree with the perpendicular as the reference at 10am
MOV R7,#46H    ;Azimuthal angle of 70 degree from north as point of reference

;hour angle calc
MOV R3,#0CH
MOV A,R3
SUBB A,#0CH
MOV B,#0CH
DIV AB
MOV R0,A  ;hour angle

;zenith angle calculation
MOV R3,#0DH   ;LATITUDE 13 degree for vellore
MOV A,R3
MOV B,R1
MUL AB
MOV R2,A
MOV A,#0DH
MOV B,R1
MUL AB
MOV B,R0
MUL AB
MOV R3,A
MOV A,R2
ADD A,R3
MOV R2,A
JMP ZEN

;azimuthal angle calculation
MOV R3,#0DH
MOV A,R3
MOV B,R1
MUL AB
MOV B,R0
MUL AB
MOV R4,A
MOV A,#0DH
MOV B,R1
MUL AB
ADD A,R4
MOV R4,A
JMP AZI


;Code to move motor for zenith angle
;The motor moves from 0 degree (start of day)
;to the calculated angle at 10am
;to 180 degree at the end of the day
;and this is repeated in a loop
ZEN:
MOV TMOD, #01H ;using Timer 0 in Mode 1
LCALL zero_degrees ;Function to move to position = 0 deg
LCALL delay ;Function to create a delay of 1 sec
LCALL req ;Function to move to the zenith angle  position of sun
LCALL delay
LCALL one_eighty_degrees ;Function to move to position = 180 deg
LCALL delay ;Function to create a delay of 1 sec
RET

zero_degrees: //To create a pulse of 1ms
MOV TH0, #0FCH //(FFFF - 03E7 + 1)H = (FC19)H 
MOV TL0, #19H //equal TO (1000)D = 1ms
SETB P2.0 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT1:JNB TF0, WAIT1 ;Wait till the TF0 flag is set 
CLR P2.0 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET

;a pulse of 1.2ms is required to move the servo motor to the zenith angle
req: //To create a pulse of 1.2ms
MOV TH0, #0FBH //(FFFF - 04B0 + 1)H = (FB51)H 
MOV TL0, #51H //equal TO (1200)D = 1.2ms
SETB P2.0 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT2:JNB TF0, WAIT2 ;Wait till the TF0 flag is set 
CLR P2.0 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET
one_eighty_degrees: //To create a pulse of 2ms 
MOV TH0, #0F8H //(FFFF - 07CF + 1)H = (F831)H 
MOV TL0, #31H //equal to (2000)D = 2ms
SETB P2.0 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT4:JNB TF0, WAIT4 ;Wait till the TF0 flag is set
CLR P2.0 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET 


delay: //To create a delay of 1sec 
MOV R4,#64H ;100us * 100us * 100us = 1s
LOOP1:MOV R3,#64H
LOOP2:MOV R2,#64H
LOOP3:DJNZ R2,LOOP3
DJNZ R3,LOOP2
DJNZ R4,LOOP1





;Code to move motor for azimuth angle
;The motor moves from 0 degree (start of day)
;to the calculated angle for day 103
;to 180 degree at the end of the day
;and this is repeated in a loop
AZI:
MOV TMOD, #01H ;using Timer 0 in Mode 1

LCALL zero_degrees1 ;Function to move to position = 0 deg
LCALL delay1 ;Function to create a delay of 1 sec
LCALL req1  ;Function to move to the azimuth angle of sun
LCALL delay1
LCALL one_eighty_degrees1 ;Function to move to position = 180 deg
LCALL delay1 ;Function to create a delay of 1 sec
RET

zero_degrees1: //To create a pulse of 1ms
MOV TH0, #0FCH //(FFFF - 03E7 + 1)H = (FC19)H 
MOV TL0, #19H //equal TO (1000)D = 1ms
SETB P2.1 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT11:JNB TF0, WAIT11 ;Wait till the TF0 flag is set 
CLR P2.1 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET

;a pulse of 1.39ms is required to move the servo motor to the azimuth angle
req1: //To create a pulse of 1.39ms
MOV TH0, #0FAH //(FFFF - 056E + 1)H = (FA93)H 
MOV TL0, #93H //equal TO (1390)D = 1.39ms
SETB P2.1 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT22:JNB TF0, WAIT22 ;Wait till the TF0 flag is set 
CLR P2.1 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET
one_eighty_degrees1: //To create a pulse of 2ms 
MOV TH0, #0F8H //(FFFF - 07CF + 1)H = (F831)H 
MOV TL0, #31H //equal to (2000)D = 2ms
SETB P2.1 ;Make P2.0 HIGH
SETB TR0 ;Start the timer 0
WAIT44:JNB TF0, WAIT44 ;Wait till the TF0 flag is set
CLR P2.1 ;Make P2.0 LOW 
CLR TF0 ;Clear the flag manually
CLR TR0 ;Stop the timer 0
RET 


delay1: //To create a delay of 1sec 
MOV R4,#64H ;100us * 100us * 100us = 1s
LOOP11:MOV R3,#64H
LOOP22:MOV R2,#64H
LOOP33:DJNZ R2,LOOP33
DJNZ R3,LOOP22
DJNZ R4,LOOP11
RET

END