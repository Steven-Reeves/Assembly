#include <xc.h>
// Use PIC32MX460F512L

// Make sure to use this one: C:\Users\Steven\Desktop\Assembly\Repo\Assembly\Lab1.X\Lab1.S
    
// can use C-like macro define statements
// #define statements follow here

.global main

.data

.text
.set noreorder
    	X: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	Y: .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
	MAC_ACC: .word 0    // Should be result of addition	
	N: .word 20	    // Number of elements in array

.ent main
main:

    la t0, N		    //Load adddress of N
    lw t1, 0(t0)	    //Load contents of t0 to t1
    beqz t1, outer_loop_end //if t1 is 0, skip to end
    nop
    la t1, X		    //Load adddress of X
    lw t2, 0(t1)	    //Load contents of t1 to t2
    beqz t2, inner_loop_end //if t2 is 0, skip inner
    nop
    la t3, Y
    lw t4, 0(t3)
    beqz t4, inner_loop_end //if t4 is 0, skip inner
    nop    

    //inner loop
    //X + itself Y times.

    inner_loop_end:
    // Add for debugging
    addu t4, t1, t3
    
    outer_loop_end:

endless:		    // Added for debugging
    j endless
    nop
    
.end main

	// constants go here


