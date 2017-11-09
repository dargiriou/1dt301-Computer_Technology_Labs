
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Date: 07/10 Date: 07/10 /2017
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program lights on when off and off when on
;  led 0 when interrupt is called.
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
  ; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

ldi r16, 0x00
out DDRD,r16

ldi r16, 0x01
out DDRB, r16

ldi r16, 0b00000001
out EIMSK, r16

ldi r16, 0b00000100
sts EICRA, r16

sei

;main program
ldi r16, 1
main_program:
nop
rjmp main_program

interrupt_0:
com  r16
out PORTB, r16

ldi r22, 200
delay_int:
dec r22
cpi r22,0
brne delay_int

reti
