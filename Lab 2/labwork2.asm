###########################################################
# CS 224			                          # 
# Lab 02			                          #
# Laboratory Work Part 2	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# Counting bit patterns                                   #
###########################################################
	.text
main:
	# determining the values with user input
	# number($a1)
	# getting the number
	la	$a0, inputNumber
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	
	# putting it to $a1
	move	$a1, $v0
	
	# pattern($a0)	
	# getting the pattern
	la	$a0, inputPattern
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	
	# putting it to $t0 before printing
	move	$t0, $v0
	
	# pattern lenght($a2)
	la	$a0, inputPatternLength
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	
	# putting it to $a2
	move	$a2, $v0
	
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# message for the number to be used
	la	$a0, number
	li	$v0, 4
	syscall
	
	move	$a0, $a1 
	li	$v0, 34
	syscall
	
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# message for pattern
	la	$a0, pattern
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	li	$v0, 34
	syscall
	
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# message for pattern length
	la	$a0, patternLength
	li	$v0, 4
	syscall
	
	move	$a0, $a2
	li	$v0, 1
	syscall
	
	la	$a0, endl
	li	$v0, 4
	syscall
	syscall
	
	# loading back $a0
	move	$a0, $t0
		
	# calling function
	jal	countPattern
	
	# saving return value $v0 before printing
	move	$t1, $v0
	
	# message for the result (no of occurences)
	la	$a0, patternMsg
	li	$v0, 4
	syscall
	
	move	$a0, $t1 
	li	$v0, 1
	syscall
	
	# resetting $t registers
	move	$t0, $zero
	move	$t1, $zero
	
	li	$v0, 10
	syscall

countPattern:
	addi	$sp, $sp, -32
	sw	$a2, 28($sp)
	sw	$a0, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	#s0: loop counter
	#s2: "anded" number
	#s1: patternCounter
	
	# loading number 32 into $s4
	li	$s4, 32
	
	# loop
	countPatternLoop:
		beq	$s0, 32, countPatternEnd
		
		countPatternAndLoop:
		beq	$s4, $a2, control
		and	$s2, $a1, $a0
		add	$s5, $s5
		sll	$a0, $a1
		
		control:
		beq	$s2, $a0, patternEqual
		bne	$s2, $a0, patternNotEqual
	
		patternEqual:
			sllv	$a2, $a2, $a2
			sllv	$a0, $a0, $a0
			add	$s0, $s0, $a2
			add	$s1, $s1, 1
			
			sub	$s3, $s4, $a2
			blt	$s3, $s0, countPatternEnd
			
			j	countPatternLoop
		patternNotEqual:
			sll	$a2, $a2, 1
			sll	$a0, $a0, 1
			addi	$s0, $s0, 1
			
			sub	$s3, $s4, $a2
			blt	$s3, $s0, countPatternEnd
			
			j	countPatternLoop
	
	countPatternEnd:
		move	$v0, $s1
		
		lw	$s0, 0($sp)
		lw	$s1, 4($sp)
		lw	$s2, 8($sp)
		lw	$s3, 12($sp)
		lw	$s4, 16($sp)
		lw	$a0, 20($sp)
		lw	$a2, 24($sp)
		addi	$sp, $sp, 28
		jr	$ra
	
	
	.data
patternMsg:	.asciiz	"Number of occurences: "
number:		.asciiz	"Number to be used: "
pattern:	.asciiz	"Pattern: "
patternLength:	.asciiz "Pattern length: "
endl:		.asciiz "\n"
inputNumber:	.asciiz "Please enter the number to be searched: "
inputPattern:	.asciiz "Please enter the pattern: "
inputPatternLength: 	.asciiz "Please enter the pattern length: "
