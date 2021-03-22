###############################################################
# CS 224			                              #  
# Lab 01			                              #
# Laboratory Work Part 2	                              #
# Section 03			                              #
# Arda Icoz			                              #
# 21901443			                              #
# This program calcutes the given equation, provided by a UI. #
###############################################################

	.text
printInputs:
	# printing calculation and request
	la	$a0, calculation
    	li      $v0, 4
    	syscall
    	
    	la	$a0, request
    	li      $v0, 4
    	syscall
    	
    	# getting input B and putting it to $t0
	la	$a0, inputB
    	li      $v0, 4
    	syscall
    	
    	li $v0, 5
    	syscall
    	move $t0, $v0
    	
    	# getting input C and putting it to $t1
	la	$a0, inputC
    	li      $v0, 4
    	syscall
    	
    	li $v0, 5
    	syscall
    	move $t1, $v0
    	
    	# getting input D and putting it to $t2
	la	$a0, inputD
    	li      $v0, 4
    	syscall
    	
    	li $v0, 5
    	syscall
    	move $t2, $v0
    	
calculate:
	# calculating (D / C)
	div	$t2, $t2, $t1	# final result stored in $t2 
	
	# calculating C * (D / C)
	mul	$t2, $t1, $t2	# final result stored in $t2
	
	# calculating B + (C * (D / C))
	add	$t2, $t0, $t2	# final result stored in $t2	
	
	#calculating (B + (C * (D / C)) % B
	div	$t2, $t0 	# after using 2-parameter div function, remainder will be in "hi" register
	mfhi	$s0		# so, we move that remainder from hi to "$s0" register

printResult:
	# printing the result
	la	$a0, result
    	li      $v0, 4
    	syscall
    	
    	move 	$a0, $s0
    	li	$v0, 1
    	syscall
	
		
	.data
calculation:	.asciiz	"Calculcating: A = (B + C * (D/C)) % B \n"
request:	.asciiz "Please enter inputs shown below: \n"
inputB:		.asciiz	"Enter input B: "
inputC:		.asciiz	"Enter input C: "
inputD:		.asciiz	"Enter input D: "
result:		.asciiz "Result: A = "