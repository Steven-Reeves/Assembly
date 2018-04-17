#include <xc.h>
// Use PIC32MX460F512L

// Make sure to use this one: C:\Users\Steven\Desktop\Assembly\Repo\Assembly\Lab1.X\Lab1.S
    
// can use C-like macro define statements
// #define statements follow here

.global main

.data
// Make sure variables are HERE!
A:  .space 4		    // preallocated 4 BYTES
FOO: .space 4
BAR: .word  0xA, 0x4	    // allocated 1 word (32bytes) and put stuff in it
			    // "0x" means HEX
			    // 'F' is char
			    // 0b101 is binary
			    // 12 is decimal
// Window -> Pic Memory views -> Executon memory
.text
.set noreorder

.ent main
main:

//3C09A000
//
//Break into binary and look up (85 ish)
//Book downloaded

la t1, FOO
li  t2, 5
sw  t2, 0(t1)		//sw SOURCE, TARGET

			    
endless:		    // Added for debugging
   j endless
    nop
    
.end main

	// constants go here


