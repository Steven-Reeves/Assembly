//******************************************************
//Author:	    Steven Reeves
//Filename:	    Lab6.S
//Date Created:	    6/2/2018
//Modifications:    6/2/2018 - created
//***********************************
#include <xc.h>
// Use PIC32MX460F512L

// can use C-like macro define statements
// #define statements follow here
#define var_guess 24(fp)
#define var_m 20(fp)
#define var_n 16(fp)

.macro pop dst
    lw \dst, 0(sp)	    //pull the 'top' of the stack into a register
    sw zero, 0(sp)	    //clear the value off the stack
    addiu sp, sp, 4	    //move the stack pointer
.endm

.macro push src
    addiu sp, sp, -4
    sw \src, 0(sp)
.endm

.global main
.global output_string
.global binary_to_asciidec
.global asciidec_to_Bin
.global Isqrt
.global is_a_digit

.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory
input_string:  .asciiz "253"
debug_string: .ascii "debug iteration: "
guess_string: .ascii " guess: "
// output strings
output_invalid: .asciiz "Invalid input. Program terminated! \r\n"
output_string_1: .ascii "The isqrt of "
output_string_2: .ascii " is "
output_string_3: .ascii ". Check: "
output_squared: .ascii "^2 = "
ender:	    .asciiz ".\r\n"

errno: .word 0
.text
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:
// Stack frame for main
    addiu sp, sp, -36		    // Allocate enough room for stack frame
    sw ra, 32(sp)		    // store ra
    sw fp, 28(sp)		    // store fp
    addu fp, zero, sp		    // move fp to sp

    //Stack frame
    //ra
    //fp
    //var_guess
    //var_m
    //var_n
    //a3
    //a2
    //a1
    //a0

// configure UART TX
    la t9, U1MODESET
    li t0,0x8000
    sw t0, 0(t9)
    la t9, U1STASET
    li t0, 0x1400
    sw t0, 0(t9)

// set variables to 0
    sw zero, var_guess
    sw zero, var_m
    sw zero, var_n

// Read ascii input, branch to endless if incorrect input.
    la a0, input_string		    // load address of input_string
    jal asciidec_to_Bin
    nop

    // check for bad input
    la t0, errno
    lw t0, 0(t0)
    li t1, 1
    beq t0, t1, error_message_out
    nop


    // Loop for debugging
endless:
    j endless
    nop

error_message_out:
    la a0, output_invalid
    jal output_string
    nop
    j endless
    nop

    addu sp, fp, zero		// unwind stack
    lw ra, 32(sp)		
    lw fp, 28(sp)
    addiu sp, sp, 36

    .end main

// Example output:
// debug iteration: 6 guess: 15
// The isqrt of 253 is 15. Check: 15^2 = 225, 16^2 = 256.

.ent output_string

output_string:
//room for fp, s0 - s2
addiu sp, sp, -16	    // save 4 things
sw fp, 12(sp)		    // store fp
addu fp, zero, sp	    // save frame pointer
sw a0, 16(fp)		    // preserve a0 register
sw s0, 0(fp)
sw s1, 4(fp)
sw s2, 8(fp)

get_byte:
    lb s0, 0(a0)
    beq s0, zero, done
    nop
send:
// send TX data
    la s2, U1TXREG
    sw s0, 0(s2)
    la s2, U1STA
wait_tx:
    lw s1, 0(s2)
    andi s1, s1, 0x100
    beq s1, zero, wait_tx
    nop
next:
    addu a0, a0, 1
    j get_byte
    nop
done:

lw s0, 0(fp)		// save s registers again
lw s1, 4(fp)
lw s2, 8(fp)
addu sp, fp, zero
lw fp, 12(sp)
addiu sp, sp, 16	// unwind stack

.end output_string 

.ent asciidec_to_Bin
asciidec_to_Bin:

// Stack frame for asciidec_to_Bin
    addiu sp, sp, -32		    // Allocate enough room for stack frame
    sw ra, 28(sp)		    // store ra-main
    sw fp, 24(sp)		    // store fp-main
    addu fp, zero, sp		    // move fp to sp
    sw a0, 32(fp)		    // we need this for calling is_a_digit
    sw s0, 16(fp)
    li t0, 1			    // WEIGHT to 1
    sw t0, 20(fp)
    addu s0, a0, zero
    //Stack frame
    //ra-main
    //fp-main
    //WEIGHT
    //a3
    //a2
    //a1
    //a0

    push zero			    //place zero onto the stack
    outer_loop_a2b:
	lb a0, 0(s0)		    //pull the current character out of the string
        beqz a0, done_looping_a2b   //if the current character is 0x00, stop looping
	nop
    // check is_a_digit	
	jal is_a_digit
	nop
	//if failure code: 0xFFFFFFFF fail
	li t0, 0xFFFFFFFF
	beq t0, v0, it_broke
	nop
	push v0			    //place a *not* NULL onto the stack
	addiu s0, s0, 1		    //move to the next byte in the string
	j outer_loop_a2b	    //if we got here, we didnt hit a NULL - loop again		    
	nop
    done_looping_a2b:
    addu v0, zero, zero
    start_calculating_a2b:
	pop t1
	beqz t1, totally_done
	nop
	lw t2, 20(fp)		    // <-- WEIGHT (loading)
	mul t3, t1, t2
	addu v0, v0, t3		    // <-- input number
	li t6, 10
	mul t2, t2, t6		    // weight = weight*10
	sw t2, 20(fp)		    // --> WEIGHT (storing)
	j start_calculating_a2b
	nop
    it_broke:
	la t0, errno
	li t1, 1
	sw t1, 0(t0)
    totally_done:

    //unwind stack frame
    addu sp, zero, fp
    lw s0, 16(fp)
    lw ra, 28(sp)
    lw fp, 24(sp)
    addiu sp, sp, 32

    jr ra
    nop
    
.end asciidec_to_Bin

.ent Isqrt
Isqrt:
    //Implement this
.end Isqrt

.ent binary_to_asciidec
binary_to_asciidec:
//room for fp and ra
    addiu sp, sp, -8	    
    sw ra, 4(sp)	    // store ra
    sw fp, 0(sp)	    // store fp
    addu fp, sp, zero	    // save frame pointer

    push zero
loop2:
    div a0, 10		    // MFLO is quotient
    MFHI t0
    addiu t0, t0, 48	    // Make it an ascii character
    push t0
    MFLO a0		    // push current remainder on stack
    bne a0, zero, loop2
    nop
loop3:
    pop t0
    sb t0, 0(a1)	    // Store first character in string buffer
    beqz t0, binary_to_ascii_end
    nop
    addiu a1, a1, 1
    j loop3
    nop

binary_to_ascii_end:

    addu sp, zero, fp
    lw fp, 0(sp)
    lw ra, 4(sp)
    addiu sp, sp, 8

    jr ra
    nop
    
.end binary_to_asciidec

.ent is_a_digit
is_a_digit:
addiu sp, sp, -4	    // save 1 thing
sw a0, 0(fp)
sw fp, 0(sp)		    // store fp
addu fp, zero, sp	    // save frame pointer

li t2, 0x30
blt a0, t2, not_a_digit
nop

li t1, 0x39
bgt a0, t1, not_a_digit
nop
// is a digit
addiu v0, a0, -48	// 48 is 0x30! Either one works.
j unwind_stack1
nop

not_a_digit:
li v0, 0xffffffff

unwind_stack1:
addu sp, fp, zero
lw fp, 0(sp)
addiu sp, sp, 4	// unwind stack

jr ra
nop

.end is_a_digit