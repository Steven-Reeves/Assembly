//******************************************************
//Author:	    Steven Reeves
//Filename:	    Lab5.S
//Date Created:	    5/18/2018
//Modifications:    5/18/2018 - created
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
.global is_a_digit
    
.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory
in_string:  .asciiz "string here"
string_buffer: .space 11

str_0:	    .asciiz "Number of 0's: "
str_1:	    .asciiz "Number of 1's: "
str_2:	    .asciiz "Number of 2's: "
str_3:	    .asciiz "Number of 3's: "
str_4:	    .asciiz "Number of 4's: "
str_5:	    .asciiz "Number of 5's: "
str_6:	    .asciiz "Number of 6's: "
str_7:	    .asciiz "Number of 7's: "
str_8:	    .asciiz "Number of 8's: "
str_9:	    .asciiz "Number of 9's: "
str_tl:	    .asciiz "Total number of digits: "
CR_LF:	    .asciiz "/r/n"

.text
 
.set noreorder
    
.ent main
main:

//////////////////////////////////////////////////////////////
// configure UART TX
 la t9, U1MODESET
 li t0,0x8000
 sw t0, 0(t9)
 la t9, U1STASET
 li t0, 0x1400
 sw t0, 0(t9)
////////////////////////////////////////////////////////////// 
    
// count_0 - count_9 and count_total local variables

    addiu sp, sp, -68		    // Allocate enough room for stack frame
    sw ra, 64(sp)		    // store ra
    sw fp, 60(sp)		    // store fp
    addu fp, zero, sp		    // move fp to sp

    
    la t0, in_string		    // load address of in_string
    lb a0, 0(t0)		    // load character
    jal is_a_digit
    nop
    
    // read a byte
    // determing if byte is a digit
    // if digit, which one? store in correct location in stack
    // traverse through string 

    la a0, 0(t0)
    // output string wants an ADDRESS
    jal output_string
    nop
   			    
    outer_loop:
	
    outer_done:


 //Lab 5/12
    //la t0, ACTUAL_NUMBER	// <-- ACTUAL_NUMBER (loading)
//    lw s0, 0(t0)
    //push zero			// this is our 'stop now' on the stack
    //Divide the contents of Reg.File[Rs] by Reg.File[Rt], 
    //treating both operands as unsigned values. Store the 
    //quotient in the LOW register, and store the remainder 
    //in the HIGH register. example: divu Rs, Rt
//    li t1, 10
//    divu s0, t1
//    mflo t2
//    mfhi t3
    //next;
    //push the digits onto the stack
    //add some logic for determining that you're done
    //output the result to the UART1  
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
addiu v0, a0, -30
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
    
.ent binary_to_asciidec
binary_to_asciidec:
    
.end binary_to_asciidec