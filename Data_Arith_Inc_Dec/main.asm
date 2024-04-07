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

main:										; DEC emulates SUB destination by 1.
			mov.w	#0F00FH,R4				; Hence affects registers as SUB.
											; As long as decrmiment does not
											; need borrow, C=1. Notice that
											; if there are points where carry
											; becomes zero then to 1, it crossed
											; the boundary to being negative, i.e.
											; 1-1 --> 0-1 --> -1-1 (FFFFh)-->FFFE
											; C=1     C=0       C=1

decri:		dec		R4						; Decriments the whole register R4.
											; Considers upper and lower bytes.

			dec.b	R4						; Considers only the low-byte of R4.
			dec.w	R4						; Same as only DEC, upper and lower.


			mov.w	#0F00Fh,R4
incri:		inc		R4						; Emulates destination + 1. Affects
			inc.b	R4						; Carry flag as ADD. INC is the same
			inc.w	R4						; as INC.W, considers low and high
											; bytes while INC.B only the low byte

											; DEC and INC double commands work
											; in the same manner but only -2 or +2
											; Affects flags same as their SUB and
											; ADD commands.
			jmp		main
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
            
