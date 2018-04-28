#include <xc.h>
// Use PIC32MX460F512L
 
// can use C-like macro define statements
// #define statements follow here
 
   
.global main
 
.data

   Hat: .word 0xffffffff
   MyArray: .space 16
   MyVar: .word 0x1234abcd
   MyByte: .byte 0xff
   //str: .byte 1,2,3,4,5,6,7,0
   //COUNT: .word 0
// stored in volatile RAM memory
// 
.text
//.macro push reg
//    addiu sp, sp, -4
//    sw  \reg, 0(sp)
//.endm
// 
//.macro pop reg
//    lw \reg, 0(sp)
//    addiu sp, sp, 4
//.endm
//
//   
// 
.set noreorder
//// text segment for instructions and CONSTANT READ-ONLY data follows here
//// stored in non-volatile flash memory
// 
//   
.ent main
main:
// 
//    // instructions go here
//    la	s1, str		    //Load addresses of pointers to array heads
//    la	s2, COUNT
//    lw s3, 0(s2)
loop_begin:
//    lb s4, 0(s1)
//
//    beqz s4, DONE 	// Go to DONE
//    nop
//
//    addu s3, s3, 1	    // value at s3 COUNT++
//    addiu s1, s1, 1	    //str[i++] one byte
//    j	loop_begin
//    nop
//
//DONE:
//    sw	s3, 0(s2)	    //Store value at COUNT
   bne t4, zero, loop_begin

endless:
       j endless
       nop
       
.end main
 
       
    // constants go here