###########################################################
# CS 224			                          # 
# Lab 01			                          #
# Preliminary Work Part 1	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# This program checks if given array is symmetric or not. #
###########################################################
	
	.text
printArray:
	la	$t0, list
	lw	$t1, listSize
	
	# printing the array message first
	la	$a0, array
    	li      $v0, 4
    	syscall
	
	printLoop:
		# let $t2 be our counter register
		# while $t2 doesn't equal to $t1(size of array), continue the program 
		beq     $t2, $t1, init
		
		# add the value to $t3 then move on to the next index
		lw	$t3, 0($t0)
		addi	$t0, $t0, 4
		
		# printing the value and a space
   		move    $a0, $t3
   		li      $v0, 1
   		syscall
   		
   		li      $a0, 32
    		li      $v0, 11  
    		syscall
    		
    		#incrementing counter register $t2
    		addi    $t2, $t2, 1
    		j      printLoop	
	
init:
	# loading the first index of the array to $t0
	la	$t0, list
	
	# loading the last index of the array to $t1
	lw	$t2, listSize	# getting the address of the last address
	sub	$t2 , $t2, 1  	
	mul	$t2, $t2, 4	# multiplying by 4 because every int allocates 4 bytes of memory 
	add	$t0, $t0, $t2	# add this number(address), which is stored in $t2, to $t0 
	la	$t1, 0($t0)	# now, $t0 adresses to the last index so we can put this address $t1
	la	$t0, list	# resetting register $t0 to the list again
	
	# if the array is 1 size long, it is already symmetrical
	lw 	$t2, listSize
	beq	$t2, 1, haveSymmetry


	# program will run for the half size of the array (declaring outside "symmetry" label, otherwise 
	# it will do this calculation everytime it jumps to "symmetry" label)
	lw 	$t2, listSize
	div 	$t2, $t2, 2
symmetry:
	# let $t7 be our counter register
	# while $t7 doesn't equal to $t2, continue the program
	beq	$t7, $t2, haveSymmetry	
	
	# loop1 will start from the front, loop2 from the bottom and they will move to the middle of the array
	loop1:
		lw	$t3, 0($t0)
		add	$t0, $t0, 4
	loop2:
		lw	$t4, 0($t1)
		sub	$t1, $t1, 4
	result:
		bne	$t3, $t4, dontHaveSymmetry	# if numbers are not equal this array is not symmetric
		addi	$t7, $t7, 1			# else lets add 1 to counter and continue with "symmetry" label
		j	symmetry
		
haveSymmetry:
	# printing the string
    	la	$a0, symmetric
    	li      $v0, 4
    	syscall
    	
    	# stop execution
    	li	$v0, 10
	syscall

dontHaveSymmetry:
	# printing the string
	la	$a0, notSymmetric
    	li      $v0, 4
    	syscall
	
	# stop execution
	li	$v0, 10	
	syscall


	.data
list:		.word 	1, 2, 3, 4, 3, 2, 1
listSize:	.word 	7
lastIndex:	.space 	4
symmetric:	.asciiz	"\nThe above array is symmetric."
notSymmetric:	.asciiz "\nThe above array is not symmetric."
array:		.asciiz "Array: "
