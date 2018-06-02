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
test_string:  .asciiz "Mic check 1, 2..."

.text
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:

// TODO: Stack FRAME

// configure UART TX
 la t9, U1MODESET
 li t0,0x8000
 sw t0, 0(t9)
 la t9, U1STASET
 li t0, 0x1400
 sw t0, 0(t9)

    la a0, test_string
    jal output_string
    nop


// TODO: Stack FRAME unwind

    // Loop for debugging
    endless:
    j endless
    nop

    .end main

	// constants go here

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
    //Implement this from lab 4
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

// in class example
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