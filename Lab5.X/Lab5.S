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
    
.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory

.text
in_string:  .asciiz "Here is a string with 1 number in it"
    
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
    
//************************
// REQUIRED: add your code here to create stack frame
// and save off argument registers
//************************
   
/*
     // My intial tests
    la s0, in_string		    // load address to in_string
    push zero			    // this is our 'stop now' on the stack
    outer_loop:
    lb t1, 0(t0)		    // load first character
	beqz t1, outer_done	    // if zero, done looping
	nop
    push t1
    sb t1, 0(s0)		    // store character to output
    j output_string		    // output string
    addiu s0, s0, 1		    // Move to next byte in array
    j outer_loop
    nop 	
outer_done:
 */

 //Lab 5/12
    //la t0, ACTUAL_NUMBER	// <-- ACTUAL_NUMBER (loading)
    lw s0, 0(t0)
    push zero			// this is our 'stop now' on the stack
    //Divide the contents of Reg.File[Rs] by Reg.File[Rt], 
    //treating both operands as unsigned values. Store the 
    //quotient in the LOW register, and store the remainder 
    //in the HIGH register. example: divu Rs, Rt
    li t1, 10
    divu s0, t1
    mflo t2
    mfhi t3
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
//************************
// REQUIRED: add your code here to create stack frame
// and save of argument registers
//************************
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
//************************
// REQUIRED: add your code here to remove stack frame and return
//************************
.end output_string 

.ent is_a_digit
is_a_digit:
     //int is_a_digit(char x)
    //{
    //if (x >= 0x30)
    //{
    //if (x <= 0x39)
    //{
    //// return binary value for ASCII character digit
    //return (x - 0x30);
    //}
    //}
    //return (0xffffffff);
    //}   
.end is_a_digit
    
.ent binary_to_asciidec
binary_to_asciidec:
    
.end binary_to_asciidec