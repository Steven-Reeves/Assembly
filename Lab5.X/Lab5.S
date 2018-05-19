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

.global main

.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory

.text
    // string stored here
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:

// count_0 - count_9 and count_total local variables
    
    // Main stack frame creation...
    
//////////////////////////////////////////////////////////////
// configure UART TX
la t9, U1MODESET
li t0,0x8000
sw t0, 0(t9)
la t9, U1STASET
li t0, 0x1400
sw t0, 0(t9)
//////////////////////////////////////////////////////////////
    
    

    

   
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