.data
P1: .asciiz "Enter Triangle Sides: "
P2: .asciiz "Invalid Side Lengths!"
P3: .asciiz "Triangle's Perimeter: "
P4: .asciiz "Triangle's Area: "
P5: .asciiz "\n"

.text
.global _start
_start:
	li   $sp, 0x7ffffffc				# Setting the stack to highest stk address
INPUT_PROMPT:
	li $v0, 4							# Input Prompt
	la $a0, P1
	syscall
	
	li $v0, 5
	syscall
	add $s0, $zero, $v0					# s0 = A
	
	li $v0, 5
	syscall
	add $s1, $zero, $v0					# s1 = B
	
	li $v0, 5
	syscall
	add $s2, $zero, $v0					# s2 = C
	
	
INPUT_VALIDATION:
	add $t0, $s0, $s1					# t0 = A + B
	blt $t0, $s2, INVALID_TRIANGLE		# If A + B <= C, Invalid
	beq $t0, $s2, INVALID_TRIANGLE
	
	add $t0, $s1, $s2					# t0 = B + C
	blt $t0, $s0, INVALID_TRIANGLE		# if B + C <= A, Invalid
	beq $t0, $s0, INVALID_TRIANGLE
	
	add $t0, $s0, $s2					# t0 = A + C
	blt $t0, $s1, INVALID_TRIANGLE		# if A + C <= B, Invalid
	beq $t0, $s1, INVALID_TRIANGLE		
	
	j PERIMETER_CALC
	
INVALID_TRIANGLE:
	li $v0, 4
	la $a0, P2
	syscall
	
	j EXIT

PERIMETER_CALC:
	add $t1, $t0, $s1					# t0 = (A + C) + B
	
	li $v0, 4							# Printing Perimeter Prompt
	la $a0, P3
	syscall
	
	li $v0, 1							# Perimeter Output
	add $a0, $zero, $t1
	syscall
	
	li $v0, 4
	la $a0, P5
	syscall

AREA_CALC:
	add  $s3, $zero, $t1				# S (s3) = a  + b + c
	add  $a0, $zero, $s3				# A = S
	addi $a1, $zero, 2					# B = 2
	
	jal DIVISON							# Divison(S/2)
	add $s3, $zero, $v0					# S = (a + b + c) / 2
	
	sub $s0, $s3, $s0					# s0 = s - a
	sub $s1, $s3, $s1					# s1 = s - b
	sub $s2, $s3, $s2					# s2 = s - c
	
	add $a0, $s3, $zero					# A = s
	add $a1, $s0, $zero					# B = s - a
	jal MULTIPLY
	
	add $s3, $zero, $v0					# s3 = s*(s-a)
	
	add $a0, $s3, $zero					# A = s*(s-a)
	add $a1, $s1, $zero					# B = s - b
	jal MULTIPLY
	
	add $s3, $zero, $v0					# s3 = s*(s-a)*(s-b)
	
	add $a0, $s3, $zero					# A = s*(s-a)*(s-b)
	add $a1, $s2, $zero					# B = s-c
	jal MULTIPLY
	
	add $s3, $zero, $v0					# s3 = s*(s-a)*(s-b)*(s-c)
	
	add $a0, $s3, $zero					# A = n (s3)
	jal SQUARE_ROOT
	
	add $s3, $zero, $v0					# s3 = sqroot(s*(s-a)*(s-b)*(s-c))
	# PRINT AREA
	li $v0, 4
	la $a0, P4
	syscall
	
	li $v0, 1							# Area Output
	add $a0, $zero, $s3
	syscall
	
	j EXIT
	
SQUARE_ROOT:

	# res = n
	# while(i < n/2)
	# res = (res + n / res) / 2;
	
	addi $sp, $sp, -20
	sw   $ra, 16($sp)				# Saving the return address into stack
	sw   $s3, 12($sp)				# Saving other register values
	sw	 $s2,  8($sp)
	sw   $s1,  4($sp)
	sw   $s0,  0($sp)
	
	add  $s3, $zero, $a0			# s3 = n
	add  $s0, $zero, $a0			# res = n
	
	addi $a1, $zero, 2				# A = N, B = 2
	jal DIVISON						# Divison(n, 2)
	
	add $s1, $zero, $v0				# s1 = n / 2
	addi $s2, $zero, 0				# idx (s2) = 0
	
SQUARE_ROOT_LOOP:
	beq  $s1, $s2, EXIT_SQUARE_ROOT	# if (idx == n/2) break
	add $a0, $s3, $zero				# A = n
	add $a1, $s0, $zero				# B = res
	jal DIVISON						# Divison(n, res)
	
	add  $s0, $s0, $v0				# res = res + (n/res)
	add  $a0, $zero, $s0			# A = res + (n/res)
	addi $a1, $zero, 2				# B = 2
	
	jal DIVISON						# Divison((res + (n / res), 2)
	add  $s0, $zero, $v0			# res = res + (n / res) / 2
	
	addi $s2, $s2, 1				# idx++
	j SQUARE_ROOT_LOOP
	
EXIT_SQUARE_ROOT:		
	lw $s0, 0($sp)					# Retrieving data stored in stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)					# Retrieving Return Address
	
	addi $sp, $sp, 20				# Reseting stack pointer 
	jr $ra								

DIVISON:
	# While (A >= B) A -= B; result++
	add  $sp, $sp, -12				# Allocating Stack Memory
	sw   $s2, 8($sp)				# Storing register values
	sw   $s1, 4($sp)				
	sw   $s0, 0($sp)
	
	addi $s0, $zero, 0				# result (s0) = 0
	add  $s1, $zero, $a0			# s1 = A
	add  $s2, $zero, $a1			# s2 = B
DIV_LOOP:
	blt  $s1, $s2, EXIT_DIV			# If (A < B) break
	sub  $s1, $s1, $s2				# A -= B
	addi $s0, $s0, 1				# result++
	j DIV_LOOP
EXIT_DIV:
	add $v0, $zero, $s0				# v0 = result
	
	lw   $s2, 8($sp)				# restoring register values
	lw   $s1, 4($sp)				
	lw   $s0, 0($sp)
	addi $sp, $sp, 12				# restoring stack pointer
	
	jr $ra
	
MULTIPLY:
	# While (idx < b) result += A
	
	add $sp, $sp, -16				# Allocating Stack Memory
	sw  $s3, 12($sp)				# Storing register values
	sw  $s2,  8($sp)
	sw  $s1,  4($sp)
	sw  $s0,  0($sp)
	
	add  $s0, $zero, $zero			# Result = 0
	addi $s1, $zero, 0				# idx (t0) = 0
	add  $s2, $zero, $a0			# s2 = A
	add  $s3, $zero, $a1			# s3 = B
MULTIPLY_LOOP:
	beq  $s3, $s1, EXIT_MULTIPLY	# if (idx == b) Break
	add  $s0, $s0, $s2				# result += A
	addi $s1, $s1, 1				# idx++
	j MULTIPLY_LOOP
EXIT_MULTIPLY:
	add $v0, $zero, $s0				# v0 = Result
		
	lw  $s3, 12($sp)				# restoring register values
	lw  $s2,  8($sp)
	lw  $s1,  4($sp)
	lw  $s0,  0($sp)
	
	add $sp, $sp, 16				# restoring stack pointer
	jr   $ra

EXIT:
	li  $v0, 10
	syscall
	