.data
FNAME_BUFF: .space 20
LNAME_BUFF: .space 20

prompt_1: .asciiz "How Many Letters In Your First Name? "
prompt_2: .asciiz "Please Enter Your First Name: "

prompt_3: .asciiz "How Many Letters In Your Last Name? "
prompt_4: .asciiz "Please Enter Your Last Name: "

.text
.global main

main:
	li $v0, 4
	la $a0, prompt_1
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $v0, 4
	la $a0, prompt_2
	syscall
	
	li $v0, 8
	la $a0, FNAME_BUFF
	move $a1, $s0
	addi $a1, $a1, 1
	syscall
	
	li $v0, 4
	la $a0, prompt_3
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	li $v0, 4
	la $a0, prompt_4
	syscall
	
	li $v0, 8
	la $a0, LNAME_BUFF
	move $a1, $s0
	addi $a1, $a1, 1
	syscall
	
	li $v0, 10
	syscall
	
	
	