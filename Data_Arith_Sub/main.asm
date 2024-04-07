;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:
			mov.b	#10,R4					; Results to FCH, this indicates
			mov.b	#6,R5					; that it is done with R5 - R4
			sub.b	R4,R5					; 6 - 10 = 06 + F6 = FC
											; NOTE results are still stored
											; at destination, this case, R5.
											; Same manner of operation when
											; having addends with negative sign.

											; Interestingly, the negative flag
											; is set in the case above as MSB=1.
											; Flags: N=1, C=0, Z=0

			mov.b	#6,R5					; Set R5's value back to 6.
			sub.b	R5,R4					; 10 - 6 = 0A + FA = 04 carry 1.
											; Hence the carry flag is set.

											; OBSERVATION: Carry flag is opposite
											; in perspective with add and subtract
											; when there is a borrow, it is cleared
											; when there is no borrow it is set.

			mov.b	#-1,R4
			mov.b	#-1,R5
			sub.b	R4,R5					; -1 - (-1) = -1+1 = FF + 1 = 0

			sub.b	#1,R5					; 0 - 1 = 0 + FF = FF, carry = 0 since
											; need a borrow.

;-----------Above studies sub and how carry flag is interpreted in subtraction-----

			mov.w	#0531H,R4
			mov.w	#0FFFFH,R5
			sub.w	R4,R5

			mov.w	#0FFFFH,R4				; -FFFF -FFFF = 0001 + 0001 = 0002H = 2
			mov.w	#-0FFFFH,R5				; -65,535 -65,535 = -131,070 in decimal
			sub.w	R4,R5					; Mismatch in decimal equivalent
											; Overflow bit is not set since the
											; 2H = 2 decimal does not exceed signed
											; integer range.
											; REASON: -65535 is not representable
											; through 16-bits.

			mov.w	#-8000H,R4				; 8000(R5) + 8000(R4) = 0000 carry 1
			mov.w	#-8000H,R5
			sub.w	R4,R5

			jmp main
			NOP
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
