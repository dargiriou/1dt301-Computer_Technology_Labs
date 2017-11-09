;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;		1DT301, Computer Technology I
;		Date: 08/09/2017
;		Authors: 
;				Alexander Risteski
;				Dimitrios Argyriou
;
;		Hardware: STK600, CPU ATmega2560
;
;		Function: This program creates a Ring Counter and displays the values with the LEDs by using Shift instructions(lsl/lsr) 
;					 with a delay of approximately 0.5 sec in between each count.
;
;		Output ports: On-board LEDs connected to PORTB.
;
;		Subroutines: A delay of 0.5 seconds at 1 MHz clock frequency.
;
;		Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
 ; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

; Delay NaN cycles
; at 8.0 MHz
.DEF mr = r16			; Assigning register r16 onto mr

start:
ldi mr, 0b00000001		; Make the lower 1 bit output
out DDRB, mr			;	for Port B.
rcall delay				; Relative call on delay subroutine

myloop:
lsl mr					; Logical shift of register r16 left.
out DDRB, mr			; Make the lower 1 bit output for Port B.

cpi mr, 0b00000000		; Compare register r16 to 0
breq equal				; and if equal, branch to equal
rcall delay				; Relative call to delay subroutine
rjmp myloop				;Relative jump to start

equal:
rjmp start				; Relative jump to start

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