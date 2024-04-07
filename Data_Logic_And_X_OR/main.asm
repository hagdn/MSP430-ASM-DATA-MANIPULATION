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

			clrc							; Word and byte access affect the
			clrn							; the result of the logic operation.
			clrz							; As always, byte access results to
			mov.w	#6969H,R4				; only the low-byte being altered.
			and		#09696H,R4

			clrc							; Zero flag sets if the result of
			clrn							; the logic operation is zero.
			clrz
			mov.w	#6969H,R4				; The effect of each logic operation
			and.b	#09696H,R4				; to other flags are vague, even in
											; the documentation/datasheet.
			clrc							; But the overall behavior of flags
			clrn							; Seems to hold, N sets if MSB=1.
			clrz							; Carry is the inverse of Zero flag.
			mov.w	#6969H,R4
			and.w	#09696H,R4

			clrc
			clrn
			clrz
			mov.w	#6969H,R4
			or		#09696H,R4

			clrc
			clrn
			clrz
			mov.w	#6969H,R4
			or.b	#09696H,R4

			clrc
			clrn
			clrz
			mov.w	#6969H,R4
			or.w	#09696H,R4


			clrc
			clrn
			clrz
			mov.w	#0FF00H,R4
			or.b	#0000H,R4

			clrc
			clrn
			clrz
			mov.w	#0FF00H,R4
			xor.w	#0000H,R4

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
            
