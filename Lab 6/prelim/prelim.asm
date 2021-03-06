################################################################
# CS 224			                               # 
# Lab 06			                               #
# Laboratory Work Part 4	                               #
# Section 03			                               #
# Arda Icoz			                               #
# 21901443			                               #
# Creating matrix and finding its average with two ways        #
# saving matrix N size in $t1                                  #
# saving the address of the array in $t0                       #
################################################################		
	
	.text
dimensionReading:
	# reading the dimension value
	la	$a0, askDimension
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	
	move	$t1, $v0	#saving matrix N size in $t1
	
	#check if the size is zero
	bne	$v0, $zero, notZero
	
	#if it equals to 0 print error
	la	$a0, zeroError
	li	$v0, 4
	syscall
	
	li	$v0, 4	#print new line
	la	$a0, endl
	syscall
	j	dimensionReading	#and jump to the beginning

notZero:
	#creating the matrix
	mul	$a0, $v0, $v0
	sll	$a0, $a0, 2 # multiplying number of elements by 2^2 = 4 (int is 4 bytes)
	li	$v0, 9
	syscall
	move	$t0, $v0 # saving the address of the array in $t0
	
	#initializing matrix
	jal	initiliazeMatrix
	
menu:
	#selection menu
	la	$a0, selection
	li	$v0, 4
	syscall	
	
	la	$a0, choice
	li	$v0, 4
	syscall
	
	# getting input for interface and branching
	li	$v0, 5
	syscall
	
	beq	$v0, 1, getElementJump
	beq	$v0, 2, rowMajorAverageJump
	beq	$v0, 3, columnMajorAverageJump
	beq	$v0, 0, endProgram
	
getElementJump:
	la	$t2, menu
	la	$t3, getElement
	jalr	$t2, $t3
	
rowMajorAverageJump:
	la	$t2, menu
	la	$t3, rowMajorAverage
	jalr	$t2, $t3

columnMajorAverageJump:
	la	$t2, menu
	la	$t3, columnMajorAverage
	jalr	$t2, $t3
	
endProgram:
	la	$a0, thanks
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall

########################################################################
			
initiliazeMatrix:
	addi	$sp, $sp, -16
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)
	
	mul	$s0, $t1, $t1	# saving matrix size($t1) to $s0
	addi	$s0, $s0, 1	# otherwise loop ends one early
	addi	$s1, $0, 1	# counter
	move 	$s2, $t0	# saving address of matrix ($t0) to $s2

initializeLoop:
	# putting consecutive values
	beq	$s1, $s0, initiliazeEnd
	sw	$s1, 0($s2)
	addi	$s2, $s2, 4
	addi	$s1, $s1, 1
	j	initializeLoop

initiliazeEnd:	
	lw	$s3, 0($sp)
	lw	$s2, 4($sp)
	lw	$s1, 8($sp)
	lw	$s0, 12($sp)
	addi	$sp, $sp, 16
	jr	$ra
	
##############################################################################
		
getElement:
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$a0, 4($sp)
	sw	$v0, 0($sp)
	
	#put matrix size to $s2
	move	$s2, $t1
	
	#put matrix addres to $s3
	move	$s3, $t0 
	
	# get row and put it to $s0
	la	$a0, getElementRow
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$s0, $v0
	
	# get column and put it to $s1
	la	$a0, getElementColumn
	li	$v0, 4
	syscall
	
	li	$v0, 5
	syscall
	move	$s1, $v0
	
	#print msg
	la	$a0, getElementShow1
	li	$v0, 4
	syscall
	
	move	$a0, $s0 # print row
	li	$v0, 1
	syscall
	
	li      $a0, 32	# print space
    	li      $v0, 11  
    	syscall
    	
    	move	$a0, $s1 # print column
	li	$v0, 1
	syscall
	
	la	$a0, getElementShow2
	li	$v0, 4
	syscall
	
	#calculate displacement
	subi	$s0, $s0, 1
	mul	$s0, $s0, $s2
	mul	$s0, $s0, 4
	
	subi	$s1, $s1, 1
	mul	$s1, $s1, 4
	
	add	$s0, $s0, $s1	# saving displacement to $s0
	
	#printing result
	add	$s3, $s3, $s0	# increment the address by displacement
	lw	$s1, 0($s3)	
	
	move	$a0, $s1
	li	$v0, 1
	syscall
	
	li	$v0, 4	#print new line
	la	$a0, endl
	syscall	
	
	lw	$v0, 0($sp)
	lw	$a0, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	jr	$ra
	
########################################################################################

rowMajorAverage:
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	mul	$s0, $t1, $t1	# saving matrix size($t1) to $s0
	move 	$s1, $t0	# saving address of matrix ($t0) to $s2

rowMajorLoop:
	#iterating every element, very similar to initiliazing
	beq	$s2, $s0, rowMajorEnd
	addi	$s2, $s2, 1
	lw	$s3, 0($s1)
	add	$s4, $s4, $s3	# get the values to $s3 and sum them in $s4
	addi	$s1, $s1, 4	# go to the next value
	j	rowMajorLoop

rowMajorEnd:		
	div	$s4, $s4, $s0	#perform divison
	
	# after row-major, print results
	la	$a0, rowMajorAverageResult
	li	$v0, 4
	syscall
	
	move	$a0, $s4
	li	$v0, 1
	syscall
	
	li	$v0, 4	#print new line
	la	$a0, endl
	syscall
	
	move	$v0, $s4	# returning value to $v0
	
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
#########################################################################################	

columnMajorAverage:
	addi	$sp, $sp, -32
	sw	$s0, 28($sp)
	sw	$s1, 24($sp)
	sw	$s2, 20($sp)
	sw	$s3, 16($sp)
	sw	$s4, 12($sp)
	sw	$s5, 8($sp)
	sw	$s6, 4($sp)
	sw	$s7, 0($sp)
	
	#condition of outer loop
	add	$s1, $s1, $t1
	addi	$s1, $s1, -1	# iterate N-1 columns, more info below
	
	#condiion of inner loop
	add	$s3, $s3, $t1
	
	#saving matrix address to $s4 and to $s7
	move	$s4, $t0
	move	$s7, $t0
	
	# decreasing outer loop variables
	# at the very first they also get computed without getting into the inner loop so we try to avoid that
	addi	$s0, $s0, -1
	addi	$s7, $s7, -4
	
	# this loop points to the start of the every column, when inner loop ends we will come here and get the address
	# of the next column and continue iterating in the inner loop
	# also it will iterate N-1 columns
columnOuterLoop:
	beq	$s0, $s1, columnMajorEnd	# $s0 is counter for outer loop
	addi	$s0, $s0, 1			# this and below code are the reason for decreasing them before starting
	addi	$s7, $s7, 4
	move	$s4, $s7			# $s4 will now point to the beginning of the next column
	move	$s2, $zero			# resetting the counter
	
	#this loop will iterate according to the 4*N value end add values to $s5
	columnInnerLoop:
		beq	$s2, $s3, columnOuterLoop	# $s2 is counter for inner loop
		addi	$s2, $s2, 1			# increment counter
		lw	$s5, 0($s4)			# add the value at that address to $s5
		add	$s6, $s6, $s5			# calculate the sum
		
		mul	$s5, $s3, 4	# it will iterate 4*N bytes ($s5 is used because we are out of registers :( )
		add	$s4, $s4, $s5	# iterating, putting the next address in $s5 to $s4
		j	columnInnerLoop

columnMajorEnd:
	move	$s1, $t1
	mul	$s1, $s1, $s1	# calculating the total matrix size
	
	div	$s6, $s6, $s1	# dividing the sum $s6 to matrix size $s1

	# after column-major, print results
	la	$a0, columnMajorAverageResult
	li	$v0, 4
	syscall
	
	move	$a0, $s6
	li	$v0, 1
	syscall
	
	li	$v0, 4	#print new line
	la	$a0, endl
	syscall

	move	$v0, $s6	# return value to $v0

	lw	$s7, 0($sp)
	lw	$s6, 4($sp)
	lw	$s5, 8($sp)
	lw	$s4, 12($sp)
	lw	$s3, 16($sp)
	lw	$s2, 20($sp)
	lw	$s1, 24($sp)
	lw	$s0, 28($sp)
	addi	$sp, $sp, 32
	jr	$ra
	
############################################################################################

	.data
askDimension:		.asciiz "Please enter the dimension: "
zeroError:		.asciiz "Can't create an array with 0 size."
endl:			.asciiz "\n"
selection:		.asciiz "\n1. Display desired element. \n2. Row-major average. \n3. Column-major average. \n0. End program.\n"
choice:			.asciiz "Choice: "
getElementRow:		.asciiz "\nEnter row: "
getElementColumn:	.asciiz "Enter column: "
getElementShow1:	.asciiz "Element in ("
getElementShow2:	.asciiz ") is: "
rowMajorAverageResult:	.asciiz "\nRow-major average: "
columnMajorAverageResult: .asciiz "\nColumn-major average: "
thanks:			.asciiz "\nThanks for using!"

