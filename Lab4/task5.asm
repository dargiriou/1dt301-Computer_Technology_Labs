;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program works simillarly with task 4 plus it uses interrupt instead of polling.
;
; Input ports: Computer keyboard
; Output ports: On -board LEDs connected to PORTB.
;
; Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
.def temp = r17
.def char = r16
.equ speed = 12

.org 0x00
rjmp start
.org URXC1addr
rjmp getChar

.org 0x50

;============= Initializing stack====================
start:
ldi temp, HIGH(RAMEND)
out SPH, temp
ldi r20, LOW(RAMEND)
out SPL, temp

ldi temp, 0xFF
out DDRB, temp

ldi temp, 0x55
out PORTB, temp
ldi temp, 50
sts UBRR1L, temp

ldi temp, speed
sts UBRR1L, temp

ldi temp, 0b10011000
sts UCSR1B, temp
sei

loop:
nop
rjmp loop

getChar:
lds r20, UCSR1A
lds char, UDR1

porOutput:
com char
out PORTB, char
com char

putChar:
lds r20, UCSR1A
sts UDR1, char
reti