;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program program creates a square wave and you can change the duty cycle up and down by 5% with the use of switches 1 & 2.
;
; Input ports: On-board switches connected to PORTD.
; Output ports: On -board LEDs connected to PORTB.
;
; Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.def ledCounter = r17
.def counter = r18
.def temp = r16
.def LEDstate = r22
.def switch0 = r23
.def switch1 = r24

.org 0x0000
rjmp start

.org INT1addr
rjmp buttonIncrement

.org INT2addr
rjmp buttonDecrement

.org OVF0addr
jmp timer0_int

.org 0x72

start:
	ldi temp, HIGH(RAMEND) ; initialize SP, Stackpointer
	out SPH, temp
	ldi temp, LOW(RAMEND)
	out SPL, temp

	ldi temp, 0xff ; led0 as output
	out DDRB, temp
	out PORTB, temp

	ldi temp, 0x05 ; prescaler value to TCCR0
	out TCCR0B, temp ; CS2 - CS2 = 101, osc.clock / 1024

	ldi temp, (1<<TOIE0) ; Timer 0 enable flag, TOIE0
	sts TIMSK0, temp ; to register TIMSK

	ldi temp, 207 ; starting value for counter
	out TCNT0, temp ; counter register

	ldi temp, 0x06
	out EIMSK, temp

	ldi temp, 0x3C
	sts EICRA, temp
	sei ; enable global interrupt

	clr counter
	ldi ledCounter,10

loop:
nop
rjmp loop ; main loop


buttonIncrement:
	cpi ledCounter,19
	breq continueInc
	inc ledCounter
	continueInc:
	nop
	reti

buttonDecrement:
	cpi ledCounter,1
	breq continueDec
	dec ledCounter
	continueDec:
	nop
	reti

timer0_int:
	push temp ; timer interrupt routine
	in temp, SREG ; save SREG on stack
	push temp

	; additional code to create the square output
	ldi temp, 207 ; starting value for counter
	out TCNT0, temp

	inc counter

	cp ledCounter, counter
	brge turn_off
	clr temp
	out PORTB, temp

	rjmp end_light

	turn_off:
	ser temp
	out PORTB, temp
	
	end_light:
	cpi counter,20
	brne continue
	clr counter

	continue:
	pop temp ; restore SREG
	out SREG, temp
	pop temp ; restore register

		
reti