###########################################################
# CS 224			                          # 
# Lab 01			                          #
# Laboratory Work Part 1	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# This program displays the values in an array with their #
# address values and calculates min, max, average values. #
###########################################################

	.text
	# printing the display
	la	$a0, display
    	li      $v0, 4
    	syscall	
	
	# loading the address of the array to register $t0
	la	$t0, array
	
	# setting max and min values to the first element of array
	lw	$t1, 0($t0) # $t1: min value
	lw	$t2, 0($t0) # $t2: max value
	
	# setting the loop limit by using register $t3
	lw 	$t3, arraySize
		
loop:	
	# let $t4 be our counter register
	# loop will continue until it will be equal to the array size
	beq	$t4, $t3, exit
	lw 	$t5, 0($t0)	# register $t5 will hold the values in that index
		
	# checking if the value is lesser or greater
	blt	$t5, $t1, setMin
	bgt	$t5, $t2, setMax
	
	# printing
	# printing the memory adress
	li $v0, 34	
	add $a0, $zero, $t0
	syscall
	
	# printing spaces
	la	$a0, space
    	li      $v0, 4
    	syscall
    	
    	# printing the value
    	move 	$a0, $t5
    	li	$v0, 1
    	syscall
    	
    	# printing end line
    	la $a0, endl
    	li $v0, 4
    	syscall   		
	
	# incrementing the counter and the index by adding 4 to the address (integers allocate 4 byte)
	# also declaring $t6 to sum all elements in the array
	addi	$t0, $t0, 4
	addi 	$t4, $t4, 1
	add	$t6, $t6, $t5
	j 	loop

setMin:
	move	$t1, $t5
	j loop
setMax:
	move	$t2, $t5
	j loop
exit:
	# dividing sum to array size to find average	
	div	$t6, $t6, $t3
	
	# Average
	la	$a0, average
    	li      $v0, 4
    	syscall
    	
    	move 	$a0, $t6
    	li	$v0, 1
    	syscall
    	
    	la $a0, endl
    	li $v0, 4
    	syscall
	
	# Min
	la	$a0, min
    	li      $v0, 4
    	syscall
    	
    	move 	$a0, $t1
    	li	$v0, 1
    	syscall
    	
    	la $a0, endl
    	li $v0, 4
    	syscall
	
	# Max
	la	$a0, max
    	li      $v0, 4
    	syscall
    	
    	move 	$a0, $t2
    	li	$v0, 1
    	syscall
    	
    	la $a0, endl
    	li $v0, 4
    	syscall
	
	.data
array:		.word	10, 26, 14, 56, 9, 37, 78, 45, 61
arraySize:	.word 	9
max:		.asciiz	"Max: "
min:		.asciiz "Min: "
average:	.asciiz "Average: "
display:	.asciiz "Memory Address   Array Elements\nPosition(hex)    Value(int)\n=============    =============\n"
space: 		.asciiz "       "
endl:		.asciiz "\n"
