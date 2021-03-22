################################################################
# CS 224			                               # 
# Lab 03			                               #
# Preliminary Work Part 1	                               #
# Section 03			                               #
# Arda Icoz			                               #
# 21901443			                               #
# Subprogram to count the number of add and lw instructions.   #
################################################################		
	.text
main:
L1:
	# random lw and add instructions
	la	$t0, num1
	lw	$t1, 0($t0)
	add	$t1, $t0, $zero
	add	$t1, $t0, $zero
	add	$t1, $t0, $zero
	
	# loading the addresses of start and end label (main)	
	la	$a0, L1
	la	$a1, L2
	
	# calling the function for main
	jal	instructionCount
	
	# storing the results in $t6 and $t7
	move	$t6, $v0
	move	$t7, $v1
		
	# printing them as message
	la	$a0, countInMain
	li	$v0, 4
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	la	$a0, addNum
	li	$v0, 4
	syscall
	move	$a0, $t6	
	li	$v0, 1
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	la	$a0, lwNum
	li	$v0, 4
	syscall
	move	$a0, $t7	
	li	$v0, 1
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# loading the addresses of start and end label (subprogram)	
	la	$a0, L3
	la	$a1, L4
	
	# calling the function for subprogram
	jal	instructionCount
	
	# storing the results in $t6 and $t7
	move	$t6, $v0
	move	$t7, $v1
	
	# printing them as message
	la	$a0, countInSub
	li	$v0, 4
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	la	$a0, addNum
	li	$v0, 4
	syscall
	move	$a0, $t6	
	li	$v0, 1
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	la	$a0, lwNum
	li	$v0, 4
	syscall
	move	$a0, $t7	
	li	$v0, 1
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall
L2:
	
instructionCount:
L3:
	# saving values into stack
	addi	$sp, $sp, -24
	sw	$a0, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	instructionCountLoop:
		# this loop will search every address and it will end when the initial address is bigger than the last
		bgt	$a0, $a1, instructionCountEnd
	
		# putting the instruction value in $a0 to registers
		lw	$s0, 0($a0)	# s0 will represent R-type (function)
		lw	$s4, 0($a0)	# s4 will represent R-type (opcode)
		lw	$s1, 0($a0)	# s1 will represent I-type
	
		# "add" is a function so its in bits 5:0
		# we shift left and then right to get only the function value
		sll	$s0, $s0, 26
		srl	$s0, $s0, 26
		
		# also we need to check that add has opcode of 0
		srl	$s4, $s4, 26
	
		# "lw" is an opcode so its in bits 31:26
		# we shift right to get only the opcode value
		srl	$s1, $s1, 26
	
		# now its time to check this values
		beq	$s1, 35, lwInst		# if s1 equals to the opcode value of "lw"
		beq	$s0, 32, addInstOpcode 	# if s0 equals to the function value of "add"		
	
		addi	$a0, $a0, 4
		j	instructionCountLoop
	
		addInstOpcode:
			bne	$s4, 0, addInstWrong
			addi	$s2, $s2, 1
			addi	$a0, $a0, 4
			j	instructionCountLoop
		addInstWrong:
			addi	$a0, $a0, 4
			j	instructionCountLoop
		lwInst:
			addi	$s3, $s3, 1
			addi	$a0, $a0, 4
			j	instructionCountLoop
	
	instructionCountEnd:
		move	$v0, $s2	# move the number of add to v0
		move	$v1, $s3	# move the number of lw to v1
		
		lw	$s3, 0($sp)
		lw	$s2, 4($sp)
		lw	$s1, 8($sp)
		lw	$s0, 12($sp)
		lw	$a0, 16($sp)
		lw	$a1, 20($sp)
		addi	$sp, $sp, 24
		jr	$ra
L4:

	.data
endl:		.asciiz	"\n"
num1: 		.word	4 
num2:		.word	3
countInMain:	.asciiz	"Instructions in main:"
countInSub:	.asciiz	"Instructions in subprogram:"
addNum:		.asciiz "add: "
lwNum:		.asciiz "lw: "
	
