###########################################################
# CS 224			                          # 
# Lab 02			                          #
# Preliminary Work Part 2	                          #
# Section 03			                          #
# Arda Icoz			                          #
# 21901443			                          #
# Reversing the bits of a number by using subprogram      #
###########################################################
	.text
main:	
	# printing the number in binary and hexadecimal forms
	# before message
	li	$v0, 4
	la	$a0, before
	syscall
	
	la	$a0, endl
	syscall
	
	# binary 
	la	$a0, binary
	li	$v0, 4
	syscall
	
	lw	$a0, number
	li	$v0, 35
	syscall
	
	# newline
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# hexadecimal
	la	$a0, hex
	li	$v0, 4
	syscall
	
	lw	$a0, number
	li	$v0, 34
	syscall
	
	# newline
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# adding the number to argument $a0 to send it to function
	lw	$a0, number
	
	# performing the function
	jal	reverse
	
	# saving the value in $v0 to $t0 because we will use $v0 when printing 
	move	$t0, $v0
	
	# after message
	li	$v0, 4
	la	$a0, after
	syscall
	
	la	$a0, endl
	syscall
	
	# binary 
	la	$a0, binary
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	li	$v0, 35
	syscall
	
	# newline
	la	$a0, endl
	li	$v0, 4
	syscall
	
	# hexadecimal
	la	$a0, hex
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	li	$v0, 34
	syscall
	
	li	$v0, 10
	syscall
	
reverse:
	# allocating 6 registers in stack
	addi	$sp, $sp, -24	
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$s5, 0($sp)
	
	# loading the number address to $s0
	move	$s0, $a0
	
	# creating the mask
	addi	$s1, $s1, 1 
	
	# What will this register do? After doing the and operator between the number and mask, we will have another number.
	# This number will actually represent the value in that specific index. So, to reverse the number, we have to shift this 
	# bit value to the left of the number (for the first half), then to the right (for the second half). This value in $s4
	# will determine how much index it should be shifted.
	addi	$s4, $s4, 31
	
	reverseLoop:
		beq	$s2, 16, reverseSecondLoop	# $s2 is a counter register
		and	$s3, $s0, $s1	# bitwise and operator between mask($s1) and number($s0), adding it to reg $s3
		sllv	$s3, $s3, $s4	# shifting "anded" number LEFT according to $s4
		add	$s5, $s5, $s3	# addding this added number to $s5 (this sum will construct our reversed number)
		
		sll	$s1, $s1, 1	# the 1 on our mask moves left
		subi	$s4, $s4, 2	# next time "anded" number will be shifted 2 less the value of index counter
		addi 	$s2, $s2, 1	# incrementing the counter
		j	reverseLoop
		
		# We decrement or increment the $s4 by 2 because we can only put it next to already-shifted value by shifting with 2 less or 2 more.
		
	reverseSecondLoop:
		beq	$s2, 31, reverseEnd	# $s2 is a counter register
		and	$s3, $s0, $s1	# bitwise and operator between mask($s1) and number($s0), adding it to reg $s3
		srlv	$s3, $s3, $s4	# shifting "anded" number RIGHT according to $s4
		add	$s5, $s5, $s3	# addding this added number to $s5 (this sum will continue constructing our reversed number)
		
		sll	$s1, $s1, 1	# the 1 on our mask moves left
		addi	$s4, $s4, 2	# next time "anded" number will be shifted 2 more the value of index counter
		addi 	$s2, $s2, 1	# incrementing the counter
		j	reverseSecondLoop
		
	reverseEnd:
		# putting the value in return register $v0
		move	$v0, $s5
		
		# deallocating
		lw	$s5, 0($sp)
		lw	$s4, 4($sp)
    		lw	$s3, 8($sp)
    		lw	$s2, 12($sp)
		lw	$s1, 16($sp)
		lw	$s0, 20($sp)
		addi	$sp, $sp, 24
		jr	$ra
		
	.data
number:	.word 	1500
binary:	.asciiz "Binary: "
hex:	.asciiz "Hexadecimal "
endl:	.asciiz "\n"
before:	.asciiz "Before reverse"
after:	.asciiz "After reverse"
