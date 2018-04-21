#include <xc.h>
// Use PIC32MX460F512L
 
// can use C-like macro define statements
// #define statements follow here
 
   
.global main
 
.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory
 
EXPR:  .word  3
            .word  4
            .word  0x80000000 + '*'
            .word  5
            .word  6
            .word  0x80000000 + '-'
            .word  0x80000000 + '+'
            .word  0x80000000 + '='
 
.text
.macro push reg
    addiu sp, sp, -4
    sw  \reg, 0(sp)
.endm
 
.macro pop reg
    lw \reg, 0(sp)
    addiu sp, sp, 4
.endm
 
// After all code in the .text segment (bottom of file)
MULT_OP:  .word 0x80000000 + '*'
ADD_OP:   .word 0x80000000 + '+'
SUB_OP:   .word 0x80000000 + '-'
EQU_OP:   .word 0x80000000 + '='
   
 
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory
 
   
.ent main
main:
 
    // instructions go here
    la s0, EXPR
    lw t0, 0(s0)
    lw t1, 4(s0)
    lw t2, 8(s0)
    lw t3, 12(s0)
    lw t4, 16(s0)
   
    push t0
    push t1
    push t2
    push t3
    push t4
   
    endless:
       j endless
       nop
       
.end main
 
       
    // constants go here