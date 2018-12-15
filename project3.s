# need to go retireve the last commit from project2.s
#x = id number 02865424 so N = 27 + (02865424 % 10) N = 27 + 4 N = 31
.data
  #newline:	.asciiz "\n"
	 inputIsEmpty:   .asciiz "Input is empty."
	 inputIsInvalid: .asciiz "Invalid base-31 number."
	 inputIsLong:    .asciiz "Input is too long."
	 inputFromUserSpace:    .space  512
	 inputFromUser: .asciiz  "Enter string up to 4 characters: "
 
.text
	input_FromUser:
		
		li $v0, 4
		la $a0, inputFromUser #takes the value of users input puts into register a0
		syscall
		
		# Get the user's input
    		li $v0, 8
   		syscall
   		
   		# Move the result to $t0
    		#move $t0, $v0
   	
    		# Display
    		#li $v0, 4 # prints string to the screen
    		#la $a0, newline
    		#la $a0,($t0)# load the address of $v0 into $a0, which will now hold the user input
    		
    		la $a0,($v0) #load the address of $t0 into $a0, which will now hold the user input
    		syscall 
    			
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

	input_IsLong:
		la $a0, inputIsLong
		li $v0, 4
		syscall
		j exit
main: 
    li $v0, 8
    la $a0, inputFromUser  # load adress is taking the adress of inputFromUser and loading it into $a0
    li $a1, 100
    syscall
    
delete_LeftPadding:
	li $t8, 32 # space
	lb $t9, 0($a0)
	beq $t8, $t9, delete_FirstCharacter
	move $t9, $a0
	j inputLength

delete_FirstCharacter:
	addi $a0, $a0, 1
	j delete_LeftPadding

inputLength:
	addi $t0, $t0, 0
	addi $t1, $t1, 10
	add $t4, $t4, $a0

iterateThroughLength:
	lb $t2, 0($a0) # loads a sign-extended version of the byte into a 32-bit value. I.e. the most significant bit (msb) is copied into the upper 24 bits.
	beqz $t2, after_length_is_found
	beq $t2, $t1, after_length_is_found
	addi $a0, $a0, 1
	addi $t0, $t0, 1
	j iterateThroughLength

after_length_is_found:
	beqz $t0, input_IsEmpty
	slti $t3, $t0, 5
	beqz $t3, input_IsLong
	move $a0, $t4
	j reviewString

reviewString:
	lb $t5, 0($a0)
	beqz $t5, prepare_for_conversion
	beq $t5, $t1, prepare_for_conversion
	slti $t6, $t5, 48                 #  condtional: input < ascii(48) aka 0 input is invalid
	bne $t6, $zero, err_invalid_input
	slti $t6, $t5, 58                 # conditional: input  < ascii(58) aka 9,  input is valid,( 0 - 9 restriction) 
	bne $t6, $zero,  moveCharForward
	slti $t6, $t5, 65                 # conditional: input < ascii(65) aka A,  input is invalid 
	bne $t6, $zero, err_invalid_input
	slti $t6, $t5, 85                 # conditional: input < ascii(85) aka U input is valid
	bne $t6, $zero,  moveCharForward
	slti $t6, $t5, 97                 # conditional: input < ascii(97) aka a input invalid
	bne $t6, $zero, err_invalid_input
	slti $t6, $t5, 117               # conditional: input < ascii(117) aka u input is valid
	bne $t6, $zero,  moveCharForward
	bgt $t5, 118, err_invalid_input   # conditional: input > ascii(118) aka v is input invalid
 
 #Spacing:
            		#lb $t0, 0($t2) #load address in $t2 to $t0
            		#addi $t2, $t2, 1 #increment pointer
            		#addi $t1, $t1, 1 #increment counter
            		#beq $t0, 32, spcaing #jump to spacing
            		#beq $t0, 10, err_empty_input 
            		#beq $t0, $0, err_empty_input 
			#j check_str
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
    beq $s0, $s3, digitOne
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
	exit:
		li $v0, 10
		syscall
 j exit
