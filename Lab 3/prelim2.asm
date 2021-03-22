###########################################################
# CS 224			                          # 
# Lab 03			                          #
# Preliminary Work Part 2	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# Recursive division                                      #
###########################################################
	.text
main:
	# opening the program
	la	$a0, welcome
	li	$v0, 4
	syscall
	la	$a0, selection
	li	$v0, 4
	syscall
	la	$a0, choice
	li	$v0, 4
	syscall
	
	li	$v0, 5	# get input
	syscall
	
	bne	$v0, 0, program
	j	endProgram
program:
	# new line
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# get nominator
	la	$a0, nominator
	li	$v0, 4
	syscall
	
	li	$v0, 5		# get input
	syscall
	move	$t0, $v0	# store result
		
	# get denominator
	la	$a0, denominator
	li	$v0, 4
	syscall
	
	li	$v0, 5		# get input
	syscall
	move	$t1, $v0	# store result
	
	# call func
	move	$a0, $t0
	move	$a1, $t1
	jal	recursiveDiv
	
	# store result
	move	$t2, $v0
	
	#print result	
	la	$a0, result
	li	$v0, 4
	syscall
	
	move	$a0, $t2
	li	$v0, 1
	syscall
	
	la	$a0, endl
	li	$v0, 4
	syscall
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# ask the user again
	la	$a0, selectionExt
	li	$v0, 4
	syscall
	
	la	$a0, choice
	li	$v0, 4
	syscall
	
	li	$v0, 5	# get input
	syscall
	
	bne 	$v0, 0, program
endProgram:
	la	$a0, endl
	li	$v0, 4
	syscall
	
	la	$a0, goodbye
	li	$v0, 4
	syscall
	
	li	$v0, 10
	syscall
		
recursiveDiv:	
	# making room on stack
	addi	$sp, $sp, -16
	sw	$a0, 12($sp)	# $a0, nominator
	sw	$a1, 8($sp)	# $a1, denominator
	sw	$s0, 4($sp)
	sw	$ra, 0($sp)
	
	# if $a1(denominator) == 0
	beq	$a1, 0, divByZero
	
	# if $a0 - $a1 == 0
	sub	$s0, $a0, $a1
	beq	$s0, 0, divIsOne
	
	# if $a0 or $a1 is negative
	blt	$a0, 0, negativeNum
	blt	$a1, 0, negativeNum
	
	# if $a0 < $a1
	blt	$a0, $a1, floatingResult
		
	# else
	bgt	$a0, $a1, recursion
	
	divByZero:
		# print warning message and exit
		la	$a0, denomIsZero
		li	$v0, 4
		syscall
		
		# return 0
		addi	$v0, $zero, 0
		
		# restore used variables
		j 	divEnd
	
	divIsOne:
		# return 1
		addi	$v0, $zero, 1
		j 	divEnd
	
	floatingResult:
		# print warning message and exit
		la	$a0, intDiv
		li	$v0, 4
		syscall
		
		# return 0 (integer division)
		addi	$v0, $zero, 0
		j 	divEnd
		
	negativeNum:
		# print warning message and exit
		la	$a0, negative
		li	$v0, 4
		syscall
		
		# return 0
		addi	$v0, $zero, 0
		
		# restore used variables
		j 	divEnd
	
	recursion:
		# return (1 + recursiveDiv($a0-$a1, $a1))
		sub	$a0, $a0, $a1
		jal	recursiveDiv	# recursive call
		addi	$v0, $v0, 1
	
	divEnd:	
		# restoring values and stack
		lw	$ra, 0($sp)
		lw	$s0, 4($sp)
		lw	$a1, 8($sp)
		lw	$a0, 12($sp)
		addi	$sp, $sp, 16
		jr	$ra
				
	.data
denomIsZero:	.asciiz "Denominator is zero, can't divide. "
endl:		.asciiz "\n"
result:		.asciiz "Result: "
negative:	.asciiz "This program doesn't support dividing negative numbers. "
intDiv:		.asciiz "(integer division) "
welcome:	.asciiz "Welcome to the program! Please select an option.\n"
selection:	.asciiz "1. Enter program.\n0. Exit program.\n"
selectionExt:	.asciiz "1. Continue.\n0. Exit program.\n"
choice:		.asciiz "Choice: "
nominator:	.asciiz "Nominator: "
denominator:	.asciiz "Denominator: "
goodbye:	.asciiz "Goodbye!"