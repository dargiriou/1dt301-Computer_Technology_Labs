;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;		1DT301, Computer Technology I
;		Date: 08/09/2017
;		Authors: 
;				Alexander Risteski
;				Dimitrios Argyriou
;
;		Hardware: STK600, CPU ATmega2560
;
;		Function: Reads the switches and when we press SW5, LED0 lights up.
;
;		Input ports: On-board switches connected to PORTA.
;		Output ports: On-board LEDs connected to PORTB.
;
;		Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"
 
 .DEF mr = r16				; Assigning register r16 as mr.
 .DEF mr2 = r17				; Assigning register r17 as mr2.

	ldi mr,0xff				; Load register r16 with 0xff hex.
	out DDRB,mr				; Sets the direction of port b according to the r16 value.
	

my_loop:
	in mr2, PINA			; Read port a as input.
	out PORTB,mr			; Output r16 to port b

	cpi mr2,0b11011111		; Compare register r17 with 0b11011111
	breq equal				; Branch if registers equal
	brne notEqual			; Branch if registers not equal jump to notEquals

	rjmp my_loop			; Relative jump to my_loop

	equal:

	ldi mr,0b11111110		; Make the lower 1 bit output
	out PORTB,mr			;	for port b.
	rjmp my_loop			; Relative jump to my_loop

	notEqual:
	ldi mr,0xff				; Load register r16 with 0xff hex.
	out PORTB, mr			; Output r16 to port b
	rjmp my_loop			; Relative jump to my_loop
