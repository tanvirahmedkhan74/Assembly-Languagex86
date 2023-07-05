#PURPOSE:		Finding out the min value from a set of values

#VARIABLES:

#	%eax - Holds the current value
#	%ebx - Holds the minimum value
#	%edi - Holds the Index Number

# MEMORY
# data_items - Set of long values[10]

.section .data

data_items:
.long 9,5,2,4,18,27,192,88,93,12

.section .text

.globl _start

_start:
	movl $0, %edi				# initializing index to 0
	movl data_items(,%edi,4), %eax		# Loading the first value
	movl %eax, %ebx				# First is the minimum one

start_loop:
	cmpl $9, %edi				# if(index==9) break
	je loop_exit				# Cause we have 0 based 10 val
	
	incl %edi				# index += 1
	movl data_items(,%edi,4), %eax		# *eax=*(data_items + 4*(*edi))
	
	cmpl %ebx, %eax				# If *eax >= *ebx: continue
	jge start_loop			

	movl %eax, %ebx				# else %ebx = min(ebx, eax)
	jmp start_loop				# Again Start the loop
	
loop_exit:
	movl $1, %eax				# Exit status code 1
	int $0x80				# Kernel Interrup Call

