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
			mov.b	#5,R4					; Straightforward addition of two
			mov.b	#2,R5					; numbers. 5+2 = 7, result is stored
			add.b	R4,R5					; to the destination (R5).

			mov.b	#-2,R6					; Same as -2 +5 or 5 + (-2)
			add.b	R5,R6					; hence R6 = 5

;-----------Above demonstrates byte addition with no carry-----------------------

			mov.b	#19,R5					; Check if half-carry affects carry
			add.b	#21,R5					; flag since 9+1 = 10 but 2+1+1 has
											; no carry. Carry is clreared after
											; execution, so half-carry does not
											; affect the carry flag.

			mov.b	#0FFH,R4				; If operation result value goes
			mov.b	#01H,R5					; over a byte's value (FF or 255)
			add.b	R4,R5					; then carry flag is set. Here,
											; FF + 01 = 00 but with a carry of 1
											; hence, carry and zero flag is set.

;-----------Above demonstrates byte addition with carry and zero flag setting-----

			mov.w	#0DECAH,R4				; DECA + 4 = DECE
			mov.w	#0004,R5				; Functions the same with byte adding
			add.w	R4,R5

			mov.w	#-0004,R5				; DECA + (-4) = DEC6
			add.w	R4,R5					; Also same with byte adding with
											; negative numbers

			mov.w	R4,R5					; Variables are words but operation is
			add.b	R4,R5					; in byte mode. Lower-bytes are only
											; considered and carry flag is still
											; affected, same with zero flag.
											; As, CA + CA = 94H with a carry of 1.

			mov.w	#0FFFFH,R4				; Like byte operation, when the word
			mov.w	#0001,R5				; additions value goes over a word
			add.w	R4,R5					; (FFFF or 65,535), it would set the
											; carry flag and clear when less.

;-----------Above demonstrates word addition and byte operation on words-----------

											; From FFFF + 1 = 0000 in words,
											; MSB is '0'. Remember that when MSB=0
											; number is considered positive while
											; MSB=1 number is negative. It is
											; true irregardless if the number is
											; truly positive or negative in decimal.

			mov.w	#0FFFFH,R4				; Same as 65,535 + (-1) in decimals,
			mov.w	#-0001,R5				; result is obviously would not be
			add.w	R4,R5					; negative number since it'll be 65,534
											; but negative flag will still be set.
											; As FFFE -> MSB = 1.

			add.w	#-0FFFDH,R5				; FFFFE + (-FFFFD) = 0001H
											; MSB = 0, negative flag clears (+)

											; Negative addends are in 2's CPL
											; so instead of subtraction it is
											; addition, so carry flag is affected
											; same as above where FFFE + 0003
											; = 0001H with a carry of 1.
											; With 0003H as 2's CPL of -FFFDH.

											; So far the limit on unsigned integers
											; is FFFF (16-bit) -> 65,535.
											; -32,768 to +32,767 for signed.
											; 8000H to 7FFFH signed HEX.

;----------Above demonstrates how the negative flag sets and clears-----------------

											; What if computation requires more than
											; the range value of 16-bits?

											; Registers are 16-bits but like the
											; byte operation on words is done, word
											; operations can be done sequentially on
											; data greater than 16-bits, but memory
											; is needed to be utilized or that.

											; Knowing if it is a per-byte operation
											; low-bytes are stored first then the
											; high-byte. Using the same concept on
											; words, the low-word is stored first
											; then the high-word next. The carry
											; from the low-word will be considered
											; on the operation on the high-word.

											; Same way in digital logic gates,
											; half-carry is consiered on the next
											; addition. In this case, half-carry
											; from the low-word.

			mov.w	#var1,R4				; Ex: 2147483647 + (-2147483648) = -1
			mov.w	#var2,R5				; 7FFFFFFF + 80000000 = FFFFFFFF

			mov.w	0(R4),R6				; Considering low-words first,
			mov.w	0(R5),R7				; FFFF + 0000 = FFFF carry 0
			add.w	R6,R7

			mov.w	2(R4),R8				; High-words,
			mov.w	2(R5),R9				; 7FFFF + 8000 = FFFF
			addc.w	R8,R9					; Overall FFFF FFFF (R7 R9)

			add.w	0(R4),R7				; FFFF + FFFF = FFFE carry 1
			addc.w	2(R4),R9				; 7FFF + FFFF + 1 = 7FFF carry 1
											; 33th = 1 (carry) & 32 zeroes.
											; Results are in R7 & R9 low-high
											; words, C=1 7FFF FFFE

											; With addc, it is easy to chain
											; or link calculations from lower
											; bits. This extends the limit
											; of 16-bit registers/memories to
											; to higher bits, such as 32, 64
											; even 128-bit value calculations
											; are possible as long as the carry
											; an the result of each word operation
											; are kept track of.

			jmp main
			NOP
                                            

;-------------------------------------------------------------------------------
; Data Memory
;-------------------------------------------------------------------------------
			.data
			.retain

var1:		.long	2147483647			; Positive signed integer in 32-bits
var2:		.long	-2147483648			; Negative signed integer in 32-bits

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
            
