# need to go retireve the last commit from project2.s
#x = id number 02865424 so N = 27 + (02865424 % 10) N = 27 + 4 N = 31
 .data
  inputIsLong:    .asciiz "Input is too long."
  inputIsEmpty:   .asciiz "Input is empty"
  inputFromUser:  .space 500
  inputIsInvalid: .asciiz "Invalid base-N number." #if N i soutside of the parameters 0-9 etc. 
.text
input_IsLong: 
 		la $a0, inputIsLong
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
main: 
    li $v0, 8
    la $a0, inputFromUser
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
  inputLength:
    addi $t0, $t0, 0 #  empty temp register $t0 makes emoty / gives null value
 	  addi $t1, $t1, 10
 	  add $t4, $t4, $a0
  iterateThroughLength:
    beqz $t2, foundLength
    beq $t2, $t1, foundLength
 	  addi $a0, $a0, 1
 	  addi $t0, $t0, 1
 	  j iterateThroughLength # jump to interate through the length funtion
  
  #after found length 
  foundLength:
 	  beqz $t0, input_IsEmpty #compares
    slti $t3, $t0, 5
 	  beqz $t3, input_IsEmpty
 	  move $a0, $t4
 	  j reviewString # jump
  reviewString:
 	  lb $t5, 0($a0)
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
 j exit
