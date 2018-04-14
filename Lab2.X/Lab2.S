//******************************************************
//Author:	    Steven Reeves
//Filename:	    Lab2.S
//Date Created:	    4/12/2018
//Modifications:    4/12/2018 - created
//******************************************************

#include <xc.h>
// Use PIC32MX460F512L
// #define statements follow here

.global main

.data
			    // Part 1 here:
    X: .word 8,2,3	    // array of 3 for testing
    Y: .word 1,2,3	    // TODO: Check if better way to initialize array 
    MAC_ACC: .word 0	    // Should be result of addition	
    N: .word 3		    // Number of elements in array
    //offset: .word 0
.text
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:
			    // Loop N times
    //la	t0, offset 
    //lw	t7, 0(t0)
    la	t1, N
    lw	t2, 0(t1)
    la	s1, X		    //Load addresses of pointers to array heads
    la	s2, Y
    la	s3, MAC_ACC
    lw	s4, 0(s3)	    //Load value of MAC_ACC, 0 to begin with
outer_loop_begin:
    beqz t2, outer_loop_end //if t2 (or N) is 0, skip to end
    nop

    lw	s5, 0(s2)	    //Load contents of Y[i]
inner_loop_begin:
    beqz s5, inner_loop_end //if s5 (or Y[i]) is 0, skip to end   
    nop
    lw	s6, 0(s1)	    //Load contents of X[i]
    beqz s6, inner_loop_end //if s6 (or X[i]) is 0, skip to end   
    nop
    add t9, t9, s6	    //t9 = t9 + X
    addiu s5, s5, -1	    // Y--
    j	inner_loop_begin
    nop
    
inner_loop_end:
    add s4, s4, t9	    //Add result to s4
    li	t9, 0		    //Clear t9 for next inner loop
    // TODO: increase offset
    //addiu t7, t7, 32
    addiu t2, t2, -1	    // N--
    j	outer_loop_begin
    nop

outer_loop_end:
    sw	s4, 0(s3)	    //store s4 in s3 for result
			    // Complete   
endless:		    // Terminate in infinite loop
    j endless
    nop
    
.end main

	// constants go here


