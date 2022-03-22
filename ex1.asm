.data 0x10000000 ##!
  display: 		.space 65536
  			.align 2
  redPrompt:		.asciiz "Enter a RED color value for the background (integer in range 0-255):\n"
  greenPrompt:		.asciiz "Enter a GREEN color value for the background (integer in range 0-255):\n"
  bluePrompt:		.asciiz "Enter a BLUE color value for the background (integer in range 0-255):\n"
  redSquarePrompt:	.asciiz "Enter a RED color value for the squares (integer in range 0-255):\n"
  greenSquarePrompt:	.asciiz "Enter a GREEN color value for the squares (integer in range 0-255):\n"
  blueSquarePrompt:	.asciiz "Enter a BLUE color value for the squares (integer in range 0-255):\n"
  sizePrompt:		.asciiz "Enter the width in pixels of the first square (Integer power of 2 in the set {1, 2, 4, 8, 16, 32, 64):\n"
 
  	addi $sp, $sp, -8	#allocate space
	sw $ra, 4($sp)		#save $ra
	sw $fp, 0 ($sp)		#save $fp
	addi $fp, $sp, 4		#set $fp
	
	addi $sp, $fp, 4		#Restore $sp
 	lw $ra, 0($fp)		#Restore $ra
 	lw $fp, -4($fp)		#restore $fp 


.text 0x00400000 ##!
main:

	addi	$v0, $0, 4  			# system call 4 is for printing a string
	la 	$a0, redPrompt 			# address of redPrompt is in $a0
	syscall           			# print the string
	# read in the R value
	addi	$v0, $0, 5			# system call 5 is for reading an integer
	syscall 				# integer value read is in $v0
 	add	$s0, $0, $v0			# copy N into $s0
 	
 	
 	
 	addi	$v0, $0, 4  			# system call 4 is for printing a string
	la 	$a0, greenPrompt 		# address of greenPrompt is in $a0
	syscall           			# print the string
	# read in the G value
	addi	$v0, $0, 5			# system call 5 is for reading an integer
	syscall 				# integer value read is in $v0
 	add	$s1, $0, $v0			# copy N into $s1
 	
 	
 	
 	addi	$v0, $0, 4  			# system call 4 is for printing a string
	la 	$a0, bluePrompt 		# address of bluePrompt is in $a0
	syscall           			# print the string
	# read in the B value
	addi	$v0, $0, 5			# system call 5 is for reading an integer
	syscall 				# integer value read is in $v0
 	add	$s2, $0, $v0			# copy N into $s2
 	
 	
 	
 	
 	#############################################
	## Calculate square color and put in       ##
	## appropriate register                    ##
	#############################################
	
	
	li $t6, 0
	li $t5, 0x00000000		#set to 0
	or $t5, $t5, $s0			#add the R value into the register
	sll $t5, $t5, 16			#shift by 16 bits
	li $t6, 0x00000000		#reset register to 0
	or $t6, $t6, $s1			#put the G value into the register
	sll $t6, $t6, 8			#shift 8 bits to place into the correct spot
	add $t5, $t5, $t6		#combine to get the RG together in the same spot
	li $t6, 0x00000000		#reset to 0
	or $t6, $t6, $s2			#place the B value in the register
	add $t5, $t5, $t6		#place the B value to get the complete RGB value
	add $t1, $t5, $0
	li $s3, 16384
	
	j drawDisplay
	
# Exit from the program
exit:
  ori $v0, $0, 10       		# system call code 10 for exit
  syscall               		# exit the program
	
drawDisplay:
	mul $t3, $t0, 4
	sw $t1, display($t3)
	addi $t0, $t0, 1
	bne $t0, $s3, drawDisplay
	
	
readSquareColors:
	addi	$v0, $0, 4  	
	la 	$a0, redSquarePrompt 
	syscall           	
	# read in the R value
	addi	$v0, $0, 5	
	syscall 		
 	add	$s0, $0, $v0	
 	
 	
 	
 	addi	$v0, $0, 4  			
	la 	$a0, greenSquarePrompt 		
	syscall           			
	# read in the G value
	addi	$v0, $0, 5			
	syscall 				
 	add	$s1, $0, $v0			
 	
 	
 	
 	addi	$v0, $0, 4  		
	la 	$a0, blueSquarePrompt 	
	syscall           		
	# read in the B value
	addi	$v0, $0, 5		
	syscall 			
 	add	$s2, $0, $v0	
 	
 	#############################################
	## Calculate square color and put in       ##
	## appropriate register                    ##
	#############################################
	li $t6, 0
	li $t5, 0
	li $t5, 0x00000000		#set to 0
	or $t5, $t5, $s0			#add the R value into the register
	sll $t5, $t5, 16			#shift by 16 bits
	li $t6, 0x00000000		#reset register to 0
	or $t6, $t6, $s1			#put the G value into the register
	sll $t6, $t6, 8			#shift 8 bits to place into the correct spot
	add $t5, $t5, $t6		#combine to get the RG together in the same spot
	li $t6, 0x00000000		#reset to 0
	or $t6, $t6, $s2			#place the B value in the register
	add $t5, $t5, $t6		#place the B value to get the complete RGB value
	add $s1, $t5, $0
	
readSize:
	addi	$v0, $0, 4  	
	la 	$a0, sizePrompt
	syscall           	
	addi	$v0, $0, 5	
	syscall 		
 	add	$s0, $0, $v0	
 	
	add $a0, $s0, $0		# place the width into $a0
	li $a1, 64		# loading the base case starting X
	li $a2, 64		# loading the base case starting Y
	li $s7, 0		# reset to 0
	
	jal drawSquare
	
	j exit
	
drawSquare: # Do not change this label
	
	li $t1, 0		# reset to 0
	slti $t1, $a0, 2		# checking for case where initial width is 1
	beq $t1, 1, single	# if the above was less than 2 jump to the case where initial width is 1
	li $t1, 0		# reset register to 0
	
	beq $a0, 1, restore	# if width gets set to 0, return
	
	mul $t9, $a0, $a0	# width squared in $t9 to tell when the square has been drawn
	beq $s7, 1, jumper	# jump down if $s7 is 1 which is set after the first square is drawn
	div $t4, $a0, 2		# width/2 in t4
	sub $a1, $a1, $t4	# width/2 plus starting X to calculate the starting X for the first square
	sub $a2, $a2, $t4	# width/2 plus starting Y to calculate the starting Y for the first square
jumper:
	mul $t0, $a2, 128	#multiplu y by 128
	add $t0, $t0, $a1	#add X
	li $t7, 0		#reset to 0
	li $t8, 0		#reset to 0
	
drawing:
 	beq $t8, $a0, reset	#jump to reset if the counter(t8) is equal to the width, meaning it got to the end of the line
 	mul $t3, $t0, 4		#multiply by four to get the pixel
	sw $s1, display($t3)	#place the correct RGB value at that pixel
	addi $t0, $t0, 1		#current pixel plus 1
	addi $t8, $t8, 1		#line counter to check if it is at end of line for the square
	addi $t7, $t7, 1		#total pixel counter incremented to signify if it is done
	bne $t7, $t9, drawing	#branch to the beginning if total counter does not equal 
	
	
reset:
 	sub $t0, $t0, $a0	#subtract the x value to go back to the starting x point
 	addi $t0, $t0, 128	#add 128 to go down 1 y coordinate
 	li $t8, 0		#reset counter to 0
 	bne $t7, $t9, drawing	#if the counter doesnt equal the total pixels go back

 	beq $a0, 2, restore	#if the width is already 2, dont keeping on going further and return
 	
	addi $sp, $sp, -8	#allocate space
	sw $ra, 4($sp)		#save $ra
	sw $fp, 0 ($sp)		#save $fp
	addi $fp, $sp, 4		#set $fp
	addi $sp, $sp, -12	#allocate space
	sw $a0, 8($sp)		#save $a0
	sw $a1, 4($sp)		#save $a1
	sw $a2, 0($sp)		#save $a2
	
	li $t7, 0		#reset to 0
 	div $t2, $a0, 4		#calc width/4 and put in t2
 	sub $a2, $a2, $t2	#width/4 plus starting Y to calculate new Y for the top left square
 	div $t2, $a0, 2		#calc width/2
 	add $a0, $t2, $0		#replace width with width/2
 	li $s7, 1		#make $s7 1 for the jumper function
	
	jal drawSquare		#Top Left
	lw $a0, -8($fp)		#restore $a0
	lw $a1, -12($fp)		#restore $a1
	lw $a2, -16($fp)		#restore $a2
	
	addi $sp, $fp, 4		#Restore $sp
 	lw $ra, 0($fp)		#Restore $ra
 	lw $fp, -4($fp)		#restore $fp 
	
	addi $sp, $sp, -8	#allocate space
	sw $ra, 4($sp)		#save $ra
	sw $fp, 0 ($sp)		#save $fp
	addi $fp, $sp, 4		#set $fp
	addi $sp, $sp, -12	#allocate space
	sw $a0, 8($sp)		#save $a0
	sw $a1, 4($sp)		#save $a1
	sw $a2, 0($sp)		#save $a2
	
	li $t7, 0		#reset to 0
	li $t8, 0		#reset to 0
	add $t8, $a1, $a0	# tl + width
	div $t7, $a0, 4		# width /4
	sub $a1, $t8, $t7	# (t1 + width) - width/4 to calculate the X coordinate
	li $s7, 1		#set $s7 to 1
	div $a0, $a0, 2		# $a0 = width/2
	
	jal drawSquare		#Top Right
	
	lw $a0, -8($fp)		#restore $a0
	lw $a1, -12($fp)		#restore $a1
	lw $a2, -16($fp)		#restore $a2
	addi $sp, $fp, 4		#Restore $sp
 	lw $ra, 0($fp)		#Restore $ra
 	lw $fp, -4($fp)		#restore $fp 
	
	addi $sp, $sp, -8	# allocate space
	sw $ra, 4($sp)		# save $ra
	sw $fp, 0 ($sp)		# save $fp
	addi $fp, $sp, 4		# set $fp
	addi $sp, $sp, -12	# allocate space
	sw $a0, 8($sp)		# save $a0
	sw $a1, 4($sp)		# save $a1
	sw $a2, 0($sp)		# save $a2
	
	li $t7, 0		# reset to 0
	li $t8, 0		# reset to 0
	div $t7, $a0, 2		# width/2 in $t7
	add $a1,$a1,$t7		# X coordinate = $a1 + width/2
	div $t8, $a0, 4		# width/4 in $t8
	mul $t8, $t8, 3		# $t8 = 3*width/4
	add $a2, $a2, $t8	# Y coordinate = Y + 3*width/4
	div $a0, $a0, 2		# width/2

	jal drawSquare		#Bottom Right
	
	lw $a0, -8($fp)		#restore $a0
	lw $a1, -12($fp)		#restore $a1
	lw $a2, -16($fp)		#restore $a2
	addi $sp, $fp, 4		#Restore $sp
 	lw $ra, 0($fp)		#Restore $ra
 	lw $fp, -4($fp)		#restore $fp 
	
	addi $sp, $sp, -8	#allocate space
	sw $ra, 4($sp)		#save $ra
	sw $fp, 0 ($sp)		#save $fp
	addi $fp, $sp, 4		#set $fp
	addi $sp, $sp, -12	#allocate space
	sw $a0, 8($sp)		#save $a0
	sw $a1, 4($sp)		#save $a1
	sw $a2, 0($sp)		#save $a2
	
	li $t7, 0		# reset to 0
	li $t8, 0		# reset to 0
	div $t7, $a0, 4		# width/4
	sub $a1, $a1, $t7	# X = X - width/4
	div $t8, $a0, 2		# width/2 in $t8
	add $a2, $a2, $t8	# Y = Y + width/2
	div $a0, $a0, 2		# width/2 in $a0
	
	jal drawSquare		# Bottom Left
	
	lw $a0, -8($fp)		#restore $a0
	lw $a1, -12($fp)		#restore $a1
	lw $a2, -16($fp)		#restore $a2
	addi $sp, $fp, 4		#Restore $sp
 	lw $ra, 0($fp)		#Restore $ra
 	lw $fp, -4($fp)		#restore $fp 
	
restore:
 	jr $ra			# return

single:
	li $a1, 63		#for a width of 1 starting X is 63
	li $a2, 63		#for a width of 1 starting Y is 63
	mul $t0, $a2, 128	#multiplu y by 128
	add $t0, $t0, $a1	#add X
	mul $t3, $t0, 4		#multiply by four to get the pixel
	sw $s1, display($t3)	#place the correct RGB value at that pixel
	jr $ra			#return
	
