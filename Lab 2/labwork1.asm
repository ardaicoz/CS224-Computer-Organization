###########################################################
# CS 224			                          # 
# Lab 02			                          #
# Laboratory Work Part 1	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# Using subprograms, with dynamically allocated array     #
###########################################################
	.text
main:	
	# opening the program
	la	$a0, welcome
	li	$v0, 4
	syscall
	
arrayZero:
	la	$a0, selection
	li	$v0, 4
	syscall
	la	$a0, choice
	li	$v0, 4
	syscall
	
	# getting input for interface and branching
	li	$v0, 5
	syscall
	
	beq	$v0, 1, getArrayFunc
	beq	$v0, 0, endProgram
	
	getArrayFunc:
		# new line
		la	$a0, endl
		li	$v0, 4
		syscall
	
		# calling the first function 
		jal	getArray
	
		# loading the array address($v0) and size($v1) to $t register in order to not lose them
		move	$t0, $v0
		move	$t1, $v1
	
		# after the func bringing the selection menu again
		la	$a0, selectionExtended
		li	$v0, 4
		syscall
		la	$a0, choice
		li	$v0, 4
		syscall
	
		# getting input for interface and branching
		li	$v0, 5
		syscall
	
		beq	$v0, 1, checkSymmetricFunc
		beq	$v0, 2, findMinMaxFunc
		beq	$v0, 3, getArrayFunc
		beq	$v0, 0, endProgram
	
	checkSymmetricFunc:
		# new line
		la	$a0, endl
		li	$v0, 4
		syscall
	
		# calling function
		move	$a0, $t0
		move	$a1, $t1
		jal	checkSymmetric
		
		# after the func bringing the selection menu again
		la	$a0, selectionExtended
		li	$v0, 4
		syscall
		la	$a0, choice
		li	$v0, 4
		syscall
	
		# getting input for interface and branching
		li	$v0, 5
		syscall
	
		beq	$v0, 1, checkSymmetricFunc
		beq	$v0, 2, findMinMaxFunc
		beq	$v0, 3, getArrayFunc
		beq	$v0, 0, endProgram
	
	findMinMaxFunc:
		# new line
		la	$a0, endl
		li	$v0, 4
		syscall
	
		# calling function
		move	$a0, $t0
		move	$a1, $t1
		jal	findMinMax
		
		# after the func bringing the selection menu again
		la	$a0, selectionExtended
		li	$v0, 4
		syscall
		la	$a0, choice
		li	$v0, 4
		syscall
	
		# getting input for interface and branching
		li	$v0, 5
		syscall
	
		beq	$v0, 1, checkSymmetricFunc
		beq	$v0, 2, findMinMaxFunc
		beq	$v0, 3, getArrayFunc
		beq	$v0, 0, endProgram

	endProgram:
		move 	$t0, $zero
		move 	$t1, $zero
	
		la	$a0, goodbye
		li	$v0, 4
		syscall

		li 	$v0, 10
		syscall
	
getArray:
	# allocating registers
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)	# we have to save the return address in order to return back to main
	sw	$s0, 12($sp)
	sw	$s1, 8($sp)
	sw	$s2, 4($sp)
	sw	$s3, 0($sp)

	# message to enter array size
	la	$a0, size
	li	$v0, 4
	syscall
	
	# read array size and put it to register $s1
	li 	$v0, 5
	syscall
	move	$s1, $v0
	
	beq	$s1, 0, arrayZero	
	
	# dynamically allocating array
	mul	$a0, $s1, 4	# converting this number to bytes and adding it to $a0
	li	$v0, 9		# syscall to dynamically allocate
	syscall
	add	$s0, $zero, $v0	# $s0 reg points to the beginning of the array.
	add	$s2, $zero, $v0 # $s2 will increase in loop to move around the index of array
	
	# printing get elements message
	la	$a0, elements
	li	$v0, 4
	syscall
	
	la	$a0, endl	# new line
	li	$v0, 4
	syscall
	
	# loop to get elements as input from the user
	getArrayElements:
		beq	$s3, $s1, getArrayEnd
		
		# read input and store it 
		li 	$v0, 5
    		syscall
    		sw 	$v0, 0($s2)
    		
    		# increment both counter and index
    		addi	$s3, $s3, 1	# counter
    		addi	$s2, $s2, 4	# index
    		j	getArrayElements
	
	getArrayEnd:
		# returning array address to $v0 and size to $v1
		move	$v0, $s0
		move	$v1, $s1
		
		# calling printArray func
		jal	printArray
		
		# deallocating
		lw	$s3, 0($sp)
		lw	$s2, 4($sp)
		lw	$s1, 8($sp)
		lw	$s0, 12($sp)
		lw	$ra, 16($sp)
		addi	$sp, $sp, 20
		jr	$ra
					
printArray:
	# allocating registers
	addi	$sp, $sp, -16
	sw	$v0, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$s6, 0($sp)
	
	# loading array address to $s4
	move	$s4, $v0
	
	# print array message
	la	$a0, arrayContents
	li	$v0, 4
	syscall
	
	printArrayLoop:
		# loop to print array elements
		beq	$s5, $v1, printArrayEnd
		lw	$s6, 0($s4)
	
		# printing value
    		li      $v0, 1      
    		move    $a0, $s6
    		syscall
    	
    		li      $a0, 32
    		li      $v0, 11  
    		syscall
    	
    		addi    $s4, $s4, 4
    		addi	$s5, $s5, 1
    		j	printArrayLoop
    	
    	printArrayEnd:
    		# deallocating	
		lw	$s6, 0($sp)
		lw	$s5, 4($sp)
		lw	$s4, 8($sp)
		lw	$v0, 12($sp)
		addi	$sp, $sp, 16
		jr	$ra
		
checkSymmetric:
	# allocating 6 registers in stack
	addi	$sp, $sp, -28
	sw	$a0, 24($sp)
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$s5, 0($sp)
	
	init:
		# loading the first index of the array to $s0
		move	$s0, $a0
	
		# loading the last index of the array to $s1
		add	$s2, $a1, 0	# getting the address of the last address
		sub	$s2 , $s2, 1  	
		mul	$s2, $s2, 4	# multiplying by 4 because every int allocates 4 bytes of memory 
		add	$s0, $s0, $s2	# add this number(address), which is stored in $s2, to $s0 
		la	$s1, 0($s0)	# now, $s0 adresses to the last index so we can put this address to $s1
		move	$s0, $a0	# resetting register $s0 to the array again
	
		# if the array is 1 size long, it is already symmetrical
		move 	$s2, $a1
		beq	$s2, 1, haveSymmetry


		# program will run for the half size of the array (declaring outside "symmetry" label, otherwise 
		# it will do this calculation everytime it jumps to "symmetry" label)
		move	$s2, $a1
		div 	$s2, $s2, 2
	symmetry:
		# let $s5 be our counter register
		# while $s5 doesn't equal to $s2, continue the program
		beq	$s5, $s2, haveSymmetry	
	
		# loop1 will start from the front, loop2 from the back and they will move to the middle of the array
		loop1:
			lw	$s3, 0($s0)
			addi	$s0, $s0, 4
		loop2:
			lw	$s4, 0($s1)
			subi	$s1, $s1, 4
		result:
			bne	$s3, $s4, dontHaveSymmetry	# if numbers are not equal this array is not symmetric
			addi	$s5, $s5, 1			# else lets add 1 to counter and continue with "symmetry" label
			j	symmetry
		
	haveSymmetry:
		la	$a0, symmetric
		li	$v0, 4
		syscall 
    		j	symmetryEnd

	dontHaveSymmetry:
		la	$a0, notSymmetric
		li	$v0, 4
		syscall 
    		j	symmetryEnd
	
	symmetryEnd:
		# deallocating the registers we have used
    		lw	$s5, 0($sp)
    		lw	$s4, 4($sp)
    		lw	$s3, 8($sp)
    		lw	$s2, 12($sp)
		lw	$s1, 16($sp)
		lw	$s0, 20($sp)
		lw	$a0, 24($sp)
		addi	$sp, $sp, 28
		jr	$ra
	
findMinMax:
	# allocating 4 registers in stack
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$s5, 0($sp)
	
	# loading the address of the array to register $s0
	move	$s0, $a0
	move	$s3, $a1
	
	# setting max and min values to the first element of array
	lw	$s1, 0($s0) # $s1: min value
	lw	$s2, 0($s0) # $s2: max value
	
	findMinMaxLoop:
		# let $s4 be our counter register
		# loop will continue until it will be equal to the array size
		bge	$s4, $s3, findMinMaxEnd
		lw 	$s5, 0($s0)	# register $s3 will hold the values in that index
		
		# checking if the value is lesser or greater
		blt	$s5, $s1, setMin
		bgt	$s5, $s2, setMax
		
		# incrementing the counter and the index by adding 4 to the address (integers allocate 4 byte)
		# also declaring $t6 to sum all elements in the array
		addi	$s0, $s0, 4
		addi 	$s4, $s4, 1
		j 	findMinMaxLoop
	
	setMin:
		move	$s1, $s5
		j 	findMinMaxLoop
	setMax:
		move	$s2, $s5
		j 	findMinMaxLoop
		
	findMinMaxEnd:
		# Min
		li 	$v0, 4
		la	$a0, min
		syscall
		
		li 	$v0, 1
		move	$a0, $s1
		syscall
		
		li 	$v0, 11
		li	$a0, 32
		syscall
		  
		
		# Max
		li 	$v0, 4
		la	$a0, max
		syscall
		
		li 	$v0, 1
		move	$a0, $s2
		syscall
		
		# deallocating the registers we have used
		lw	$s5, 0($sp)
		lw	$s4, 4($sp)
		lw	$s3, 8($sp)
		lw	$s2, 12($sp)
		lw	$s1, 16($sp)
		lw	$s0, 20($sp)
		addi	$sp, $sp, 24
		jr	$ra



	.data
size:			.asciiz "Enter array size: "
elements:		.asciiz "Enter the array elements:"
endl:			.asciiz "\n"
arrayContents:		.asciiz "Array: "
symmetric:		.asciiz	"\nThe above array is symmetric.\n"
notSymmetric:		.asciiz "\nThe above array is not symmetric.\n"
max:			.asciiz	"Max: "
min:			.asciiz "Min: "
welcome:		.asciiz "Welcome to the program! Please select an option.\n"
choice:			.asciiz "Choice: "
selection:		.asciiz "1. Enter the array.\n0. Exit program.\n"
selectionExtended:	.asciiz "\n\n1. Check the symmetry of array.\n2. Find the min and max values.\n3. Enter new array.\n0. Exit program.\n"
goodbye:		.asciiz "\nThanks for using. Bye!"
