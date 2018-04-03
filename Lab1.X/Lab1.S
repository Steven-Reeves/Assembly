#include <xc.h>
// Use PIC32MX460F512L

// Make sure to use this one: C:\Users\Steven\Desktop\Assembly\Repo\Assembly\Lab1.X\Lab1.S
    
// can use C-like macro define statements
// #define statements follow here

.global main

.data
// data segment for READ/WRITE data follows here
// stored in volatile RAM memory

.text
.set noreorder
// text segment for instructions and CONSTANT READ-ONLY data follows here
// stored in non-volatile flash memory

.ent main
main:

	// instructions go here

.end main

	// constants go here


