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
    X: .word 1,2,3	    // array of 3 for testing
    Y: .word 1,2,3	    // TODO: Check if better way to initialize array 
    MAC_ACC: .word 0	    // Should be result of addition	
    N: .word 3		    // Number of elements in array
.text
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:
			    // Loop N times

    li	t0, 0
    la	t1, N
    lw	t2, 0(t1)
    la	s1, X		    //Load addresses of pointers to array heads
    la	s2, Y
    la	s3, MAC_ACC
    lw	s4, 0(s3)	    //Load value of MAC_ACC, 0 to begin with
outer_loop_begin:
    beqz t2, outer_loop_end //if t2 (or N) is 0, skip to end
    nop
    // TODO: Inner loop here
    
    
inner_loop_end:  
    addiu t2, t2, -1	    // N--
    j outer_loop_begin
    nop

outer_loop_end:
			    // Complete   
endless:		    // Terminate in infinite loop
    j endless
    nop
    
.end main

	// constants go here


