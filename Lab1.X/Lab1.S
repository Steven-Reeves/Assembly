#include <xc.h>
// Use PIC32MX460F512L
 
// can use C-like macro define statements
// #define statements follow here
 
   
.global main
 
.data

   Hat: .word ':'
   MyArray: .space 16
   MyVar: .word 0x1234abcd
   MyByte: .byte 0xff
   //str: .byte 1,2,3,4,5,6,7,0
   //COUNT: .word 0
// stored in volatile RAM memory
// 
.text
.macro push2 reg, reg1
    addiu sp, sp, -8
    sw \reg, 4(sp)
    sw  \reg1, 0(sp)
.endm
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

la t0, Hat
lw t1, 0(t0)
//andi t2, t1, 0x00000008
//li t2, 0x00000040	//Question 3
//li t1, 0x00000208	//Quesion 4
//xor t3, t1, t2
//bnez t2, TURN
//nop
//sw t3, 0(t0)

DIGIT_CHECK:
li t3, 0x30
sltu t5, t3, t1
beqz t5, FAIL
nop
li t2, 0x39
sltu t5, t2, t1
bnez t5, FAIL
nop


TURN:
    addi t1, t1, 0

FAIL:
push2 t1,t2
// fail stuff here
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
   //bne t4, zero, loop_begin

endless:
       j endless
       nop
       
.end main
 
       
    // constants go here