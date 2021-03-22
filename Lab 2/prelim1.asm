###########################################################
# CS 224			                          # 
# Lab 02			                          #
# Preliminary Work Part 1	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# Using subprograms, an array example                     #
###########################################################
	.text	
main:	
	# loading the address of the array to register $a0
	# and loading the arraySize value to register $a1
	la	$a0, array
	lw	$a1, arraySize
	
	# if the size of array is 0 jump to "sizeZero" label
	beq	$a1, 0, sizeZero
	
	# starting with first and second subprograms
	jal	printArray
	jal	checkSymmetric
	
	# result of checkSymmetric
	# if $v0 equals to 1, array is symmetric
	bne	$v0, 1, mainNotSymmetric
	la	$a0, symmetric
    	li      $v0, 4
    	syscall
    	j 	continue
    	
    	mainNotSymmetric:
    		la	$a0, notSymmetric
    		li      $v0, 4
    		syscall

continue:
    	# restoring the value of $a0 and going to subprogram findMinMax
    	la	$a0, array
    	jal 	findMinMax
    	
    	# storing the min($v0) and max($v1) values in registers $t0 and $t1 to not lose them
	move	$t0, $v0
	move	$t1, $v1
	
	# printing
	# min
	la	$a0, min
	li	$v0, 4
	syscall
	
	move 	$a0, $t0
	li	$v0, 1
	syscall
	
	# printing space between numbers
	li $a0, 32
	li $v0, 11  
	syscall
	
	# max
	la	$a0, max
	li	$v0, 4
	syscall
	
	move 	$a0, $t1
	li	$v0, 1
	syscall
	
	# resetting $t0 and $t1
	move 	$t0, $zero
	move 	$t1, $zero

	# exiting program
	li	$v0, 10
	syscall

sizeZero:
	# printing message
	la	$a0, zero
	li	$v0, 4
	syscall
	
	# exiting program
	li	$v0, 10
	syscall
	
printArray:
	# allocating 5 registers in stack
	addi	$sp, $sp, -20	
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	
	# storing the value in $a0 to $s0, otherwise we would lose the value when printing
	# and we will use this register $s0 later on this subprogram
	move	$s0, $a0
	
	# printing the array message first
	la	$a0, arrayContents
    	li      $v0, 4
    	syscall
	
	# restoring the value of $a0
	move 	$a0, $s0
	
	printArrayLoop:	
		# let $s2 be our counter register
		# while $s2 doesn't equal to $a1(size of array), continue the program 
		# since $a1 will not be changed, we can use the actual register of it
		beq     $s2, $a1, printArrayEnd
		
		# add the value to $s3 then move on to the next index
		lw	$s3, 0($s0)
		addi	$s0, $s0, 4
	
		# storing the value inside $a0 to register $s4. Reason: We want to print the values and a space
		# between them, but we can only print strings with $a0. So, not to lose the value in $a0, we 
		# first store it to $s4 and then put this value back to it.
		move 	$s4, $a0
		
		# printing the value and a space
   		move    $a0, $s3
   		li      $v0, 1
   		syscall
   		
   		li      $a0, 32
    		li      $v0, 11  
    		syscall
    	
    		# restoring the value back to $a0
    		move	$a0, $s4
    		
    		#incrementing counter register $s2
    		addi    $s2, $s2, 1
    		j      printArrayLoop
    	
	printArrayEnd:
		# deallocating the registers we have used
    		lw	$s4, 0($sp)
    		lw	$s3, 4($sp)
    		lw	$s2, 8($sp)
		lw	$s1, 12($sp)
		lw	$s0, 16($sp)
		addi	$sp, $sp, 20
		jr	$ra

checkSymmetric:
	# allocating 6 registers in stack
	addi	$sp, $sp, -24
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
		la	$s1, 0($s0)	# now, $s0 adresses to the last index so we can put this address $s1
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
	
		# loop1 will start from the front, loop2 from the bottom and they will move to the middle of the array
		loop1:
			lw	$s3, 0($s0)
			add	$s0, $s0, 4
		loop2:
			lw	$s4, 0($s1)
			sub	$s1, $s1, 4
		result:
			bne	$s3, $s4, dontHaveSymmetry	# if numbers are not equal this array is not symmetric
			addi	$s5, $s5, 1			# else lets add 1 to counter and continue with "symmetry" label
			j	symmetry
		
	haveSymmetry:
		addi	$v0, $zero, 1 
    		j	symmetryEnd

	dontHaveSymmetry:
		add	$v0, $zero, $zero
    		j	symmetryEnd
	
	symmetryEnd:
		# deallocating the registers we have used
    		lw	$s5, 0($sp)
    		lw	$s4, 4($sp)
    		lw	$s3, 8($sp)
    		lw	$s2, 12($sp)
		lw	$s1, 16($sp)
		lw	$s0, 20($sp)
		addi	$sp, $sp, 24
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
		move 	$v0, $s1
		
		# Max
		move	$v1, $s2
		
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
array:		.word 	1, 2, 3, 2, 1
arraySize:	.word 	5
arrayContents:	.asciiz "Array: "
symmetric:	.asciiz	"\nThe above array is symmetric.\n"
notSymmetric:	.asciiz "\nThe above array is not symmetric.\n"
max:		.asciiz	"Max: "
min:		.asciiz "Min: "
zero:		.asciiz "The given array has size 0. Featured function cannot be performed on 0-size array."
