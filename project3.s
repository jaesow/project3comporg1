# need to ask the user for their input,(check) take that input and pass it to input is long, input is empty, input is invalid
# test for a character that is longer than 4, invalid, and an empty string 
#x = id number 02865424 so N = 27 + (02865424 % 10) N = 27 + 4 N = 31
.data
	newline:	.asciiz "\n"
	inputIsLong:    .asciiz "Input is too long." #issue is that its counting the characters in this string
	inputIsEmpty:   .asciiz "Input is empty"
	inputFromUser:  .asciiz "Enter characters with max value of 4: "
	#.space 500 #take the value from the user and compare it with the space, if they match then its a space, if they dont match go tot the next condition
	inputIsInvalid: .asciiz "Invalid base-N number." #if N i soutside of the parameters 0-9 etc. 
	

.text # build functions if statements in the main
	main:	
		input_FromUser:
			la $a0, inputFromUser #takes "Enter characters with max value of 4: " and out it into $a0
			li $v0, 4 # displays "Enter characters with max value of 4: "
			syscall
			# Get the user's input
    			li $v0, 5
			syscall
			# Move the users input to $t0
    			move $t0, $v0
    			# move the users input from $t0 to register $a0 and prints it 
			li $v0, 1
			la $v0, newline
			move $a0, $t0 # u5ser input is in register $a0

    			
		input_IsLong: 
			la $a0, inputIsLong #value from the user input if its greater than 4 characters, than call the data inputIsLong
			li $v0, 4
			syscall
			j exit
			
			
		input_IsEmpty:
			la $a0, inputIsEmpty
			li $v0, 4
			syscall
			j exit
		input_IsInvalid:
			la $a0, inputIsInvalid
			li $v0, 4
			syscall
			j exit
		exit:
			li $v0, 10
			syscall
		
		li $v0, 8
		# logic from inputfromuser.asm, gets input from user, store it into a register, and then check that registers value into  each of the fucntions 
		#la $a0, inputFromUser
		#if its empty prints "input is empty", if etc... logic, goes through with the function 
	li $a1, 250
	syscall
delete_FirstCharacter:
	addi $a0, $a0, 1 # adds 1 to register $a0
	j delete_LeftPadding # calls delete left paddding function 
delete_LeftPadding:
	li $t8, 32
	lb $t9, 0($a0)
	beq $t8, $t9, delete_FirstCharacter
	move $t9, $a0
	j inputLength # jump to and run to inputLength function 
inputLength: #counts what the user has bc if its more than 4, then its too long 
	addi $t0, $t0, 0 #  empty temp register $t0 makes emoty / gives null value
	addi $t1, $t1, 10
	add $t4, $t4, $a0
iterateThroughLength: 
	lb $t2, 0($a0) # takes memory from $t2 and stores in $a0 
	beqz $t2, foundLength #compares register 2 with the foundlength 
	beq $t2, $t1, foundLength
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j iterateThroughLength # jump to interate through the length funtion
#after found length 
foundLength:
	beqz $t0, input_IsEmpty #compares, if statement in assembly (compare input is empty to tempary register, checking to see if t0 has a value) , if t0 is empty goes on to next line
	slti $t3, $t0, 5
	beqz $t3, input_IsEmpty
	move $a0, $t4
	j reviewString # jump 
reviewString:
	lb $t5, 0($a0)
	beqz $t5, prepForConvo 
	beq $t5, $t1, prepForConvo # compares if equal 
	slti $t6, $t5, 48
	bne $t6, $zero, input_IsInvalid
	slti $t6, $t5, 58
	bne $t6, $zero, moveCharForward
	slti $t6, $t5, 65
	bne $t6, $zero, input_IsInvalid
	slti $t6, $t5, 86                 
	bne $t6, $zero, moveCharForward
	slti $t6, $t5, 97
	bne $t6, $zero, input_IsInvalid	
	slti $t6, $t5, 118 
	bne $t6, $zero, moveCharForward
	bgt $t5, 119, input_IsInvalid   
moveCharForward:
	addi $a0, $a0, 1
	j reviewString # jump tp reviewString function 
# function thats prepares for conversion 
prepForConvo:
	move $a0, $t4
	addi $t7, $t7, 0
	add $s0, $s0, $t0
	addi $s0, $s0, -1	
	li $s3, 3
	li $s2, 2
	li $s1, 1
	li $s5, 0
convertInput:
	lb $s4, 0($a0)
	beqz $s4, print
	beq $s4, $t1, print # compares the registries
	slti $t6, $s4, 58
	bne $t6, $zero, baseTen
	slti $t6, $s4, 88
	bne $t6, $zero,upperBase33
	slti $t6, $s4, 120
	bne $t6, $zero, lowerBase33
baseTen:
	addi $s4, $s4, -48
	j serialize #  jump to serlialze function 
#calculates conversions 
upperBase33:
	addi $s4, $s4, -55
	j serialize
lowerBase33:
	addi $s4, $s4, -87
serialize:
	beq $s0, $s3, digitOne # beq = branch if equal so checking to see if the value stored in $s0 is equal to the value in $3
	beq $s0, $s2, digitTwo
	beq $s0, $s1, digitThree
	beq $s0, $s5, digitFour
digitOne:
	li $s6, 29791 
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
	addi $s0, $s0, -1
	addi $a0, $a0, 1
	j convertInput
digitTwo:
	li $s6, 961
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
	addi $s0, $s0, -1
	addi $a0, $a0, 1
	j convertInput
digitThree:
	li $s6, 31 #
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
	addi $s0, $s0, -1
	addi $a0, $a0, 1
	j convertInput # jump to convertInput base function 
digitFour:
	li $s6, 1
	mult $s4, $s6
	mflo $s7
	add $t7, $t7, $s7
print:
	li $v0, 1
	move $a0, $t7
	syscall
j exit
