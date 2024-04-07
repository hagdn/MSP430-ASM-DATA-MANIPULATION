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
			mov.b	#11111111B,R4			; Reset bit #3. Notice the trick is
			and.b	#11110111B,R4			; to use '1' for bits to be kept.
											; Say if original is a '1' but mask
											; is '0', AND would result to zero.
											; Can't do the reverse since 0->1=0
											; Can't set bits with AND, only reset.

			mov.b	#11111111B,R4			; Set bit #3 again. Keep the other 0's
			or.b	#00001000B,R4			; for bits that need no touching and
                                            ; '1' for setting. Can't reset with OR
											; since 1->0=1.

											; For the two masking operations flags
											; are still affected.

											; There are built-in commands for
											; bit set/reset that do not affect
											; flags. Essential when Jumps will
											; be used in which jumps rely on
											; flag statuses.

			bic.b	#00001000B,R4			; Clear bit #3 with the '1' at the source
											; operand indicating the bit#.
			bis.b	#00001000B,R4			; Set bit #3 again.

			bic.b	#10010110B,R4			; First operand can be modified to set
											; or clear multiple bits, same with
											; just the AND or OR instruction.

			bis.b	#10010110B,R4			; Set back the cleared bits.

			bic.b	#BIT3,R4				; There is a definition for nth bit
			bis.b	#BIT3,R4				; can be used instead of directly
											; writing the binary. But cant be
											; used for setting multiple bits.

			bit.b	#BIT3,R4				; There is also a bit test instruction
			bic.b	#BIT3,R4				; Tests if bit# is set or clear at
			bit.b	#BIT3,R4				; the Zero flag. C != Z.
			bis.b	#BIT3,R4

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
            
