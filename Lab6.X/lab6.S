//******************************************************
//Author:	    Steven Reeves
//Filename:	    Lab5.S
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
