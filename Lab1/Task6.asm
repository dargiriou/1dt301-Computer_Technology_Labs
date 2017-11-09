;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;		1DT301, Computer Technology I
;		Date: 08/09/2017
;		Authors: 
;				Alexander Risteski
;				Dimitrios Argyriou
;
;		Hardware: STK600, CPU ATmega2560
;
;		Function: This program creates a Johnson Counter in an infinite loop.
;
;		Output ports: On-board LEDs connected to PORTB.
;
;		Included files: m2560def.inc
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"
 ; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

.DEF mr = r16			; Assigning register r16 to mr.
.DEF mri = r17			; Assigning register r17 to mri.

ldi mr, 0xff			; Load 0b11111111 in R16.
out DDRB, mr			; Configure Port B as an Output port.

forward:
out PORTB, mr			; Write all 1's to the pins of PortA.
lsl mr					; Apply logical shift left.
call delay				; Calls delay subroutine.
cpi mr, 0b00000000		; Compares register to 0. 
brne forward			; If not equal branch to forward.
rjmp reset				; else relative jump to reset.

reset:
out PORTB,mr			; Outputs register r16 to Port B.

call delay				; Calls delay subroutine.

ldi mri,0b10000000		; Load 0b10000000 in R17.
rjmp backwards			; Relative jump to backwards.

 backwards:

 lsr mr					; Logic shift of register r16 right.
 add mr, mri			; Adds registers r16 and r17 and puts the result in the destination register.
 out PORTB,mr			; Outputs register r16 to Port B.
 
 call delay				; Calls delay subroutine.
 cpi mr, 0xFF			; Compares r16 to hex ff
 brne backwards			; Branches to backwards if not equal
rjmp forward			; Relative jump to forward.

delay:

    ldi  r18, 3
    ldi  r19, 138
    ldi  r20, 86
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1

	ret