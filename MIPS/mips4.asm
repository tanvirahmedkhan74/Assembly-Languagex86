.data
NAME_BUFF: .space 50		# Allcation of 50 bytes for the name storing

prompt_1: .asciiz "How Many Letters In Your First Name? "
prompt_2: .asciiz "How Many Letters In Your Last Name? "

prompt_3: .asciiz "Please Enter Your First & Last Name: "

.text
.global _start

_start:
	addi $s0, $zero, 2				# s0 = len(string) including space and null char
PROMPT:
	li $v0, 4					# Loading 4 for print_str syscall
	la $a0, prompt_1				# Argument in a0
	syscall
	
	li $v0, 5					# Loading 5 for read_int syscall
	syscall			
	add $s0, $s0, $v0				# s0 += v0, v0 stores the integer input
	
	li 	$v0, 4					# Loading 4 for print_str syscall
	la 	$a0, prompt_2				# Argument in a0
	syscall
	
	li 	$v0, 5					# Loading 5 for read_int syscall
	syscall			
	add $s0, $s0, $v0				# s0 += v0, v0 stores the integer input
	
	li 	$v0, 4					# Loading 4 for print_str syscall
	la 	$a0, prompt_3				# Argument in a0
	syscall
	
	li 	$v0, 8					# Loading 8 for read_str syscall
	la 	$a0, NAME_BUFF				# Buffer address in a0
	add  $a1, $zero, $s0				# String input length in a1
	syscall
	
	li $v0, 4
	la $a0, NAME_BUFF
	syscall
EXIT:
	li $v0, 10					# Loading 10 for Exit syscall
	syscall