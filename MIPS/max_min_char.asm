.data
NAME_BUFF: .space 50		# Allcation of 50 bytes for the name storing

prompt_1: .asciiz "How Many Letters In Your First Name? "
prompt_2: .asciiz "How Many Letters In Your Last Name? "
prompt_3: .asciiz "Please Enter Your First & Last Name: "
prompt_4: .asciiz "Maximum ASCII Value: "
prompt_5: .asciiz "Maximum Character  : "
prompt_6: .asciiz "Minimum ASCII Value: "
prompt_7: .asciiz "Minimum Character  : "


.text
.global _start

_start:
	addi $s0, $zero, 2				# s0 = len(string) including space and null char
PROMPT:
	li $v0, 4						# Loading 4 for print_str syscall
	la $a0, prompt_1				# Argument in a0
	syscall
	
	li $v0, 5						# Loading 5 for read_int syscall
	syscall			
	add $s0, $s0, $v0				# s0 += v0, v0 stores the integer input
	
	li 	$v0, 4						# Loading 4 for print_str syscall
	la 	$a0, prompt_2				# Argument in a0
	syscall
	
	li 	$v0, 5						# Loading 5 for read_int syscall
	syscall			
	add $s0, $s0, $v0				# s0 += v0, v0 stores the integer input
	
	li 	$v0, 4						# Loading 4 for print_str syscall
	la 	$a0, prompt_3				# Argument in a0
	syscall
	
	li 	$v0, 8						# Loading 8 for read_str syscall
	la 	$a0, NAME_BUFF				# Buffer address in a0
	add $a1, $zero, $s0				# String input length in a1
	syscall

	jal MAX_MIN_CHAR				# Procedure Calling	
	
	add $s1, $zero, $v0				# s1 = returned max char
	add $s2, $zero, $v1				# s2 = returned min char
	
	li $v0, 4						# Loading 4 for print_str syscall
	la $a0, prompt_4				# Max ASCII prompt
	syscall
	
	li $v0, 1						# Loading 1 for print_int syscall
	add $a0, $zero, $s1
	syscall
	
	li $v0, 11						# Newline Char Print Syscall
	li $a0, 10
	syscall
	
	li $v0, 4						# Loading 4 for print_str syscall
	la $a0, prompt_5				# MAX Char prompt
	syscall
	
	li $v0, 11						# Loading 11 for printing char
	add $a0, $zero, $s1
	syscall
	
	li $v0, 11						# Newline Char Print Syscall
	li $a0, 10
	syscall
	
	li $v0, 4						# Loading 4 for print_str syscall
	la $a0, prompt_6				# Min ASCII prompt
	syscall
	
	li $v0, 1						# Loading 1 for print_int syscall
	add $a0, $zero, $s2
	syscall
	
	li $v0, 11						# Newline Char Print Syscall
	li $a0, 10
	syscall
	
	li $v0, 4						# Loading 4 for print_str syscall
	la $a0, prompt_7				# MIN Char prompt
	syscall
	
	li $v0, 11						# Loading 11 for printing char
	add $a0, $zero, $s2
	syscall
	
	li $v0, 10						# Loading 10 for Exit syscall
	syscall
	
MAX_MIN_CHAR:
	#addi $sp, $sp, -4				# Allocating one word inside the stack
	# sw   $ra, 4($sp)				# Storing the return address in stack
	#sw 	 $s0, 0($sp)			# Storing the length value(s0) into stack
	
	# v0 = the maximum ascii value
	# v1 = the minimum ascii value
	
	la  $s0, NAME_BUFF
	lb  $v0, 0($s0)			        # v0 = ascii value of the first byte/char
	lb  $v1, 0($s0)					# v1 = ascii value of the first byte/char
	
	addi $t5, $zero, 32				# t5 = ASCII value of space
	addi $t2, $zero, 1				# t2 = 1 ; loop iterator
	
LOOP:
	add $t3, $s0, $t2				# t3 = s3 + t2; Address of the present char
	lb  $t3, 0($t3)					# t3 = NAME[i]
	
	beq $t3, $zero, EXIT			# if name[i] == '\0', exit
	beq $t3, $t5, CONTINUE			# if name[i] == ' ' , continue
	
MAX_COMPARISON:
	slt $t4, $v0, $t3				# if MAX (v0) < Name[i] (t3), t4 = 1
	beq $t4, $zero, MIN_COMPARISON	# if t4 == 0, go to MIN_COMPARISON
	
	add $v0, $t3, $zero				# MAX = Name]i] | Value swap
	
MIN_COMPARISON:
	slt $t4, $t3, $v1				# if Name[i] (t3) < MIN (v1), t4 = 1
	beq $t4, $zero, CONTINUE		# if t4 == 0, continue
	
	add $v1, $zero, $t3				# else v1 = name[i] | Value Swap
	
CONTINUE:
	addi $t2, $t2, 1				# t2 += 1 | Increamanting loop counter
	j LOOP							# Jump back to loop!
	
EXIT:
	#lw   $s0, 0($sp)				# restoring data from stack
	#addi $sp, $sp, 4				# restoring stack to the prev addr
	
	jr $ra 							# return v0, v1