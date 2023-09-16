# MIPS program for calculating the sum of an array
.data
ARRAY: .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21
N: .word 11
RESULT: .asciiz "The total is: "

.text
.global main
main:
	jal sum_array
	add $s5, $zero, $v0
	
	li  $v0, 4
	la  $a0, RESULT
	syscall
	
	li  $v0, 1
	add $a0, $zero, $s5
	syscall
	
	li $v0, 10
	syscall
	
sum_array:
	la 	$s1, ARRAY				# t1 = Address of Array
	lw 	$s2, N					# s2 = N or 11
	add $v0, $zero, $zero 		# sum(v0) = 0
	add $s3, $zero, $zero 		# s3 = 0 (Iterator Counter)
	
loop:
	sll  $t1, $s3, 2			# t1 = s3 * (2^2) (Offset)
	add  $t1, $t1, $s1			# t1 = t1 + s1 (array address + offset)
	lw   $t1, 0($t1)			# t1 = array[i]
	
	add  $v0, $v0, $t1			# v0 += t1 (res += array[i])
	addi $s3, $s3, 1			# s3 += 1
	bne  $s3, $s2, loop			# if s3 != s2, keep looping!
	
	jr $ra
