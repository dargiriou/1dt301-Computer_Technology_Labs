;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;		1DT301, Computer Technology I
;		Date: 08/09/2017
;		Authors: 
;				Alexander Risteski
;				Dimitrios Argyriou
;
;		Hardware: STK600, CPU ATmega2560
;
;		Function: Reads the switches and lights the corresponding LED.
;
;		Input ports: On-board switches connected to PORTA.
;		Output ports: On-board LEDs connected to PORTB.
;
;		Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

 .include "m2560def.inc"
 my_loop:
 .DEF mr = r16 ;defining register r16 as "mr"

	ldi mr, 0xff	;Set Data Direction Registers
	out DDRB,mr	;port B as outputs

	ldi mr,0x00 	;Load to r16 hex 00.
	out DDRA,mr	;port A as outputs

	in mr, PINA	;read portA as input
	out PORTB,mr	;output r16 to port B

	rjmp my_loop	;jump to my_loop
