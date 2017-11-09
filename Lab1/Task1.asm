 ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;		1DT301, Computer Technology I
;		Date: 08/09/2017
;		Authors: 
;				Alexander Risteski
;				Dimitrios Argyriou
;
;		Hardware: STK600, CPU ATmega2560
;
;		Function: This program lights LED 2 
. 
;		Output ports: On-board LEDs connected to PORTB.
;
;		Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

 .include "m2560def.inc" 
 .DEF mr = r16
ldi mr,0b00000100 		;load 1111 1011 to register r16
out DDRB, mr 			;write 1111 1011 to port B output resister