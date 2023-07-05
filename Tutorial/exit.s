#PURPOSE:	Simple Program that exits and returs a status code back to the
#	 	Linux Kernel

#INPUT:		none

#OUTPUT:	returns a status code. Can be viewed by echo $?

#VARIABLES:	%eax - system call number
#		%ebx - return status holder

.section .data

.section .text

.globl _start
_start:
movl $1, %eax	# linux kernel command number for
		# exiting a program

movl $69, %ebx	# status number returing to the
		# operating system

int $0x80	# wakes up the kernel to run the exit command
