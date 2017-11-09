;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Date: 07/10 Date: 07/10 /2017
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program  simulates the rear lights on a car.
; It has 3 states and changes between them by calling interrupt_0 and _1
; ON (Leds 7,8 & 0,1).
;Turn right :Leds 6 – 7 on, led 0 –3 blinking as RING counter.
;Turn left :led 0 – 1 on, led 4 – 7 blinking as RING counter.
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

.org 0x72

start:

ldi mr, 0b00000011
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

.DEF mr = r16
.DEF mri = r17
.DEF flag1 = r22
.DEF flag2 = r23
;=========================== ON ===============================
; Fillng up the flags1,2 so that it can branch to one of the states
; and when branches clear the appropriate flag so that it can branch here again.
on:
ser flag1
ser flag2
  ldi mr,0xFF
  out DDRB, mr
  ldi r16, 0b00111100
  out PORTB, mr
  rjmp on

;=================== RIGHT TURN ===============================
  ; Initialize SP, Stack Pointer
turnRight:
clr flag1 // clear the flag1
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

;=================== LEFT TURN ===============================
	 ; Initialize SP, Stack Pointer
turnLeft:
clr flag2 // clear the flag2
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

========================= INTERRUPT SUBROUTINES ==============================
interrupt_0:
sei // set interrupt enabled
cpi flag1, 0xff
breq turnRight
brne on

interrupt_1:
sei // set interrupt enabled
cpi flag2, 0xff
breq turnLeft
brne on

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
