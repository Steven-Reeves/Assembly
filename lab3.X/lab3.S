//******************************************************
//Author:	    Steven Reeves
//Filename:	    Lab3.S
//Date Created:	    4/16/2018
//Modifications:    4/16/2018 - created
//		    4/21/2018 - added macros    
//******************************************************
#include <xc.h>
// Use PIC32MX460F512L

// #define statements follow here

.global main



.data
// Expression for (3*4) + (5-6) = 
// RPN: 3 4 * 5 6 - + =
EXPR:	.word  3
            .word  4
            .word  0x80000000 + '*'
            .word  5
            .word  6
            .word  0x80000000 + '-'
            .word  0x80000000 + '+'
            .word  0x80000000 + '='
RESULT:	    .word 0	    // Should be result of entire expression 


.text

.macro push reg
    addiu sp, sp, -4	    // Move stack pointer "up" one.
    sw	\reg, 0(sp)	    // Store "reg" at new location
.endm

.macro pop reg
    lw  \reg, 0(sp)	    // Get value from sp
    addiu sp, sp, 4	    // Move sp
.endm

ADD_OP:   .word 0x80000000 + '+'
SUB_OP:   .word 0x80000000 + '-'
MULT_OP:  .word 0x80000000 + '*'
EQU_OP:   .word 0x80000000 + '='

.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:
    // Load operators for comparison
    la	t0, ADD_OP		// Load value of ADD_OP
    lw	s1, 0(t0)
    la	t1, SUB_OP		// Load value of SUB_OP
    lw	s2, 0(t1)
    la	t2, MULT_OP		// Load value of MULT_OP
    lw	s3, 0(t2)
    la	t3, EQU_OP		// Load value of EQU_OP
    lw	s4, 0(t3)

    la	s5, RESULT		// Load value of RESULT

   // Read EXPR
    la	s0, EXPR
loop_begin:
    lw	s7, 0(s0)		// Load value of EXPR[i] into s7

    beq s7, s1, ADD_THINGS	// Go to ADD_THINGS
    nop

    beq s7, s2, SUB_THINGS	// Go to SUB_THINGS
    nop

    beq s7, s3, MULT_THINGS	// Go to MULT_THINGS
    nop

    beq s7, s4, EQUALS		// Go to EQUALS
    nop

    push s7			// Not expression, push stuff on
    addiu s0, s0, 4		// EXPR[i++]

    j	loop_begin
    nop
    // if digit, push
	// Add 4 bytes to EXPR
	// Jump to read EXPR
    // if expressionn not equal
	// Pop 2 values from stack and do stuff
	// Add 4 bytes to EXPR
	// Jump to read EXPR
    // if '=' pop last thing off and store


ADD_THINGS:
    pop t0
    pop t1
    addu t3, t1, t0
    push t3

    addiu s0, s0, 4		// EXPR[i++]
    j	loop_begin
    nop

SUB_THINGS:
    pop t0
    pop t1
    subu t3, t1, t0
    push t3

    addiu s0, s0, 4		// EXPR[i++]
    j	loop_begin
    nop

MULT_THINGS:
    pop t0
    pop t1
    //check to see if X or Y are zero, if so, run away.
    beqz t0, inner_loop_end //if X is zero
    nop
    beqz t1, inner_loop_end //if Y is zero
    nop
    addu t9, zero, zero //clear the temp
inner_loop:
    addu t9, t9, t0  //temp = temp + X
    addiu t1, t1, -1  //y--
//if y == 0, then the multiplication operation is complete
    bnez t1, inner_loop
    nop
inner_loop_end:

    push t9
    addiu s0, s0, 4		// EXPR[i++]
    j	loop_begin
    nop

EQUALS:	
    pop t0
    sw t0, 0(s5)	    // Put value at t0 into address at s5 (RESULT)
    j endless
    nop

endless:		    // Terminate in infinite loop
    j endless
    nop

.end main

	// constants go here


