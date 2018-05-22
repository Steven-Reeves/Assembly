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
// Define count variables
#define count_total 60(fp)
#define count_9 56(fp)    
#define count_8 52(fp)
#define count_7 48(fp)
#define count_6 44(fp)
#define count_5 40(fp)
#define count_4 36(fp)
#define count_3 32(fp)
#define count_2 28(fp)
#define count_1 24(fp)
#define count_0 20(fp)
#define param_4 12(fp)
#define param_3 8(fp)
#define param_2 4(fp)
#define param_1 0(fp)

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
.global binary_to_asciidec
    
.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory
in_string:  .asciiz "1234567899999999999999990r"
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
CR_LF:	    .asciiz "\r\n"

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

    addiu sp, sp, -72		    // Allocate enough room for stack frame
    sw ra, 68(sp)		    // store ra
    sw fp, 64(sp)		    // store fp
    addu fp, zero, sp		    // move fp to sp
    sw s0, 16(fp)		    // store s0 register for string

    addu t0, zero, zero		    // make sure all variables are 0
    sw t0, count_0
    sw t0, count_1
    sw t0, count_2
    sw t0, count_3
    sw t0, count_4
    sw t0, count_5
    sw t0, count_6
    sw t0, count_7
    sw t0, count_8
    sw t0, count_9
    sw t0, count_total


    la s0, in_string		    // load address of in_string
string_loop:
    lb a0, 0(s0)		    // load character
    beqz a0, string_done	    // if character == 0, string is over
    nop
    jal is_a_digit		    // determine if byte is a digit
    nop
    beq v0, 0xffffffff, digit_end   // if not digit, skip to end.
    nop
		    // if digit, which one? store in correct location in stack
    addu t0, zero, zero		    // set t0 to 0
    beq v0, t0, digit_0		    // if 0, add to stack frame and move on
    nop
    beq v0, 0x00000001, digit_1	    // if 1, add to stack frame and move on
    nop
    beq v0, 0x00000002, digit_2	    // if 2, add to stack frame and move on
    nop
    beq v0, 0x00000003, digit_3	    // if 3, add to stack frame and move on
    nop
    beq v0, 0x00000004, digit_4	    // if 4, add to stack frame and move on
    nop
    beq v0, 0x00000005, digit_5	    // if 5, add to stack frame and move on
    nop
    beq v0, 0x00000006, digit_6	    // if 6, add to stack frame and move on
    nop
    beq v0, 0x00000007, digit_7    // if 7, add to stack frame and move on
    nop
    beq v0, 0x00000008, digit_8	    // if 8, add to stack frame and move on
    nop
    beq v0, 0x00000009, digit_9	    // if 9, add to stack frame and move on
    nop
				    // TODO: increment total count for ANY number
digit_0:
    lw t7, count_0		    // load value at count_0
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_0		    // store value at count_0
    j digit_end			    // jump to end
    nop
digit_1:
    lw t7, count_1		    // load value at count_1
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_1		    // store value at count_1
    j digit_end			    // jump to end
    nop
digit_2:
    lw t7, count_2		    // load value at count_2
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_2		    // store value at count_2
    j digit_end			    // jump to end
    nop
digit_3:
    lw t7, count_3		    // load value at count_3
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_3		    // store value at count_3
    j digit_end			    // jump to end
    nop
digit_4:
    lw t7, count_4		    // load value at count_4
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_4		    // store value at count_4
    j digit_end			    // jump to end
    nop
digit_5:
    lw t7, count_5		    // load value at count_5
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_5		    // store value at count_5
    j digit_end			    // jump to end
    nop
digit_6:
    lw t7, count_6		    // load value at count_6
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_6		    // store value at count_6
    j digit_end			    // jump to end
    nop
digit_7:
    lw t7, count_7		    // load value at count_7
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_7		    // store value at count_7
    j digit_end			    // jump to end
    nop
digit_8:
    lw t7, count_8		    // load value at count_8
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_8		    // store value at count_8
    j digit_end			    // jump to end
    nop
digit_9:
    lw t7, count_9		    // load value at count_9
    addiu t7, t7, 1		    // add 1 to value
    sw t7, count_9		    // store value at count_9
    j digit_end			    // jump to end
    nop
digit_end:
    addiu s0, s0, 1		    //increment pointer to s0
    jal string_loop
    nop
    
    
string_done:
    lw a0, count_9		    // load number of 9's
    la a1, string_buffer	    // load string for output
    jal binary_to_asciidec
    nop
   
    la a0, str_9
    jal output_string		// output string wants an ADDRESS
    nop

    la a0, string_buffer
    jal output_string		// output string wants an ADDRESS
    nop
   
    la a0, CR_LF
    jal output_string
    nop

    // TODO: Clear buffer and loop for each number...
    //TOOO: 3 here...
    

    // TODO: Unwind stack frame here

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
//value_loop:
//    lw s0, 0(a0)		// crash here
//    li t5, 0
//    push t5			// this is our 'stop now' on the stack
//    //Divide the contents of Reg.File[Rs] by Reg.File[Rt], 
//    //treating both operands as unsigned values. Store the 
//    //quotient in the LOW register, and store the remainder 
//    //in the HIGH register. example: divu Rs, Rt
//    li t1, 10
//    divu s0, t1
//    mflo t2			    // quotient
//    mfhi t3			    // remainder <- digit to write
//    addiu t3, t3, 48		    // add 0x30 to t3
//    push t3			    // push to bottom 
//    addu a0, t2, zero		    // put quotient in a0
//    bnez a0, value_loop		    // if quotient != 0, keep looping
//    nop
//
//string_loop1:    
//    lw s1, 0(a1)		    // Crash here
//    pop s1			    // pop number onto string
//    beqz s1, string_done	    // if null terminator, we're done
//    nop
//    sw s1, 0(a1)		    // store ascii char in string
//    addiu a1, 1			    // move to next byte
//    j string_loop1
//    nop
    
//    lw s0, 0(fp)		// save s registers again
//    lw s1, 4(fp)
//    addu sp, fp, zero
//    lw fp, 12(sp)
//    addiu sp, sp, 16	// unwind stack
// 
.end binary_to_asciidec