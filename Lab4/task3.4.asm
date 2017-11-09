;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; 1DT301, Computer Technology I
; Authors:
; Alexander Risteski
; Dimitrios Argyriou
;
; Hardware: STK600, CPU ATmega2560
; Function: This program uses the serial communication port0(RS232).
; The program receives characters that are sent from the computer, and show the code onthe LEDs. Also the requirements for task 4 (creatibg an echo) is included.
;
; Input ports: The keyboard
; Output ports: On -board LEDs connected to PORTB.
;
; Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.equ UBRR_val = 12

.org 0x00
rjmp start

.org 0x30

start:
ldi r16, 0xFF
out DDRB, r16

ldi r16, 0x55
out PORTB, r16

ldi r16, UBRR_val
sts UBRR1L, r16

ldi r16, (1<<TXEN1) | (1<<RXEN1)
STS UCSR1B, r16

getChar:
lds r16, UCSR1A
sbrs r16, RXC1
rjmp GetChar
lds r17, UDR1

porOutput:
com r17
out PORTB, r17
com r17
;=======================================================
;================== FOR TASK 4 (echo) ==================
;=======================================================
putChar:
lds r16, UCSR1A
sbrs r16, UDRE1
rjmp PutChar
sts UDR1, r17
rjmp GetChar