;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Date: 07/10 Date: 07/10 /2017
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program switches from ring counter to Johnson counter
; by calling interrupt (INT0addr) on switch 0
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



.org 0x72

start:

ldi mr, 0b00000011
out EIMSK, mr

ldi mr, 0b00001000
sts EICRA, mr

ldi mr , 0x00
out DDRD, mr

sei


ldi r20, HIGH(RAMEND)			; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)			; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
; Assigning names to the registers
.DEF mr = r16
.DEF mri = r17
.DEF flag =r23
;======================Johnson counter=============================

; Here a Johnson counter starts and in each of its subroutines a call to the
;subroutine switch1 happens in order to verify if a switch has been pressed,
;so that it will change to the Ring Counter.

JohnsonCounter:
ser flag
ldi mr, 0xff
out DDRB, mr

forward:

out PORTB, mr
lsl mr
call delay
cpi mr, 0b00000000
brne forward
rjmp reset

reset:
out PORTB,mr
call delay
ldi mri,0b10000000
rjmp backwards

backwards:

lsr mr
add mr, mri
out PORTB,mr
call delay
cpi mr, 0xFF
brne backwards

rjmp JohnsonCounter

;======================= RING COUNTER ================================
;Similarly in Ring counter the switch1 is called in �myloop� to check if a switch is pressed, so that it changes back to Johnson counter.

RingCounter:
clr flag
start1:
ldi mr, 0x01
com mr		; complements the rergister so that it will be showed correctly
out PORTB, mr
com mr		;complements again to return to its original form
rcall delay

myloop:


lsl mr
com mr
out PORTB, mr
com mr

cpi mr, 0b00000000
breq equal
rcall delay
rjmp myloop

equal:
rjmp RingCounter


interrupt_0:

ldi r22,200
delay_int:
	dec r22
	cpi r22,0
	brne delay_int
	sei
cpi flag, 0xff
breq RingCounter
brne JohnsonCounter




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
