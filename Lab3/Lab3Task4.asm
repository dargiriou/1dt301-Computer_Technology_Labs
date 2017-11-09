;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Date: 07/10 Date: 07/10 /2017
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program  simulates the rear lights on a car from task3 plus
; introducing more states for breaking.
; Breaking : all LEDS on
; Breaking and turning right :LED 4 – 7 on, LED 0 – 3 blinking as RING counter..
; Breaking and turning left :LED 0 – 1 on, led 4 – 7 blinking as RING counter.
;
; Input ports: On-board switches connected to PORTD.
; Output ports: On -board LEDs connected to PORTB.
;
; Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00
rjmp start

.org INT0addr
rjmp interrupt_0

.org INT1addr
rjmp interrupt_1

.org INT2addr
rjmp interrupt_2

.org 0x72

start:

ldi mr, 0b00000111
out EIMSK, mr

ldi mr, 0b00001000
sts EICRA, mr

ldi mr , 0x00
out DDRD, mr

sei



ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

;======================== DEFINING REGISTERS ===============================
.DEF mr = r16
.DEF mri = r17
.DEF flag1 = r22
.DEF flag2 = r23
.DEF flag3 = r24
.DEF flag4 = r25
;==================================== ON ======================================
;============= Filling up flags1,2,3 with 0xff ================================
on:
ser flag1
ser flag2
ser flag3
clr flag4 // clear flag4

;============== ON state (Leds 7,8,0,1 are on)=================================
  ldi mr,0xFF
  out DDRB, mr
  ldi r16, 0b00111100
  out PORTB, mr
  rjmp on

;============================== RIGHT TURN ====================================
  ; Initialize SP, Stack Pointer
turnRight:
clr flag1
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

ldi mr , 0xFF
out DDRB, mr

RingCounter:

start1:
	ldi mri, 0b00110111
	out PORTB, mri
	rcall delay
		ldi mr,	 0b0000_1100
myloop:
	eor mri, mr
	out PORTB,mri
	lsr mr

	cpi mri, 0b0011_1111
	breq RingCounter
	rcall delay
	rjmp myloop

;============================== LEFT TURN =====================================
	 ; Initialize SP, Stack Pointer
turnLeft:
clr flag2
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi mr , 0xFF
out DDRB, mr

RingCounter2:

start2:
	ldi mri, 0b1110_1100
	out PORTB, mri
	rcall delay
	ldi mr,	 0b0011_0000
myloop2:
	eor mri, mr
	out PORTB,mri
	lsl mr

	cpi mri, 0b1111_1100
	breq RingCounter2
	rcall delay
	rjmp myloop2
;======================== Helper subroutines for branching=====================
	turnRightBridge:
	rjmp turnRight
	turnLeftBridge:
	rjmp turnLeft
	turnOnBridge:
	rjmp on
;========================== BREAK =============================================
;======== When breaks is on, all lights are on ================================
breakWhenOn:
clr flag3 // Clearing flag3
ser flag4 // Filling flag4 to xFF
  ldi mr,0xFF
  out DDRB, mr
  ldi r16, 0x00
  out PORTB, mr
  rjmp breakWhenOn

;========================= BREAK LEFT==========================================
turnLeftBreak:
clr flag4 //claring flag4
 ; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi mr , 0xFF
out DDRB, mr
RingWithBreak1:
start3:
	ldi mri, 0b1110_0000


	out PORTB, mri
	rcall delay
	ldi mr,	 0b0011_0000
myloop3:
	eor mri, mr
	out PORTB,mri
	lsl mr
	cpi mri, 0b1111_0000
	breq RingWithBreak1
	rcall delay
	rjmp myloop3


;========================= BREAK RIGHT =====================================
turnRightBreak:
clr flag4 //Clearing flag4
 ; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20
.DEF mr = r16
	.DEF mri = r17
ldi mr , 0xFF
out DDRB, mr

RingWithBreak2:
start4:
	ldi mri, 0b0000_0111 ;OBS!!! ob1110_0000 for task 4 break 00000111
	out PORTB, mri
	rcall delay
	ldi mr,	 0b0000_1100
myloop4:
	eor mri, mr
	out PORTB,mri
	lsr mr

	cpi mri, 0b0000_1111
	breq RingWithBreak2
	rcall delay
	rjmp myloop4

;========================== INTERRUPT SUBROUTINES =============================
interrupt_0:
sei
cpi flag4, 0xff
breq turnRightBreak
cpi flag1, 0xff
breq turnRightBridge
brne turnOnBridge

interrupt_1:
sei
cpi flag4, 0xff//0x00
breq turnLeftBreak
cpi flag2, 0xff
breq turnLeftBridge
brne turnOnBridge

interrupt_2:
sei
cpi flag3 ,0xff
breq breakWhenOn
brne turnOnBridge

;=============================== DELAY SUBROUTINE =============================
delay:
ldi  r18, 5
ldi  r19, 15
ldi  r20, 242
L1: dec  r20
brne L1
dec  r19
brne L1
dec  r18
brne L1

ret
