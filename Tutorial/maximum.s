#PURPOSE:	This program finds the maximum number from a set
#		of data items

#VARIABLES:	Registers and their usage
#	%edi -	Holds the current Index value
#	%eax -	Stores the current value at %edi location
#	%ebx -	Stores the maximum numbers

# Memory Locations:

# data_items - 	Contains integers. Terminated by a 0

.section .data

data_items:
.long 3, 69, 73, 75, 78, 69, 222, 84, 18, 22, 33, 11, 66, 0

.section .text

.globl _start
_start:
	movl $0, %edi			# Index starting at 0
	movl data_items(,%edi,4), %eax	# Store the current index value
	movl %eax, %ebx			# First one is the large one

start_loop:
	cmpl $0, %eax			# Compare if current == 0
	je loop_exit			# If curr==0, jump to the
					# loop_exit
	incl %edi			# index++ , increasing index value
	movl data_items(,%edi,4), %eax	# Load Current value
	cmpl %ebx, %eax			# Compare max(*ebx, *eax)
	jle start_loop			# if new(right) value is less, go to						# loop start
	movl %eax, %ebx			# else if new is greater, swap max
	jmp start_loop			# Jump to beginning

loop_exit:
	# With status code 1 for exit, %ebx is the return value with
	# The maximum from the list
	# Executed when current value == 0

	movl $1, %eax			# 1 as the exit system call
	int $0x80			# Interrut signal with hex code
