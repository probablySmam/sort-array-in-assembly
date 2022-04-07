# Sam Schaeffler

.data 					#change read/write data but not executable

getZeroA:   .asciiz "Enter 0 to sort in descending order. \n"
getZeroB:	.asciiz "Any number different than 0 will sort in ascending order. \n"
before: 	.asciiz "Before Sort:\n"
after: 		.asciiz "After Sort:\n"
list:		.word 7, 9, 4, 3, 8, 1, 6, 2, 5
newLine:	.asciiz	"\n"

.text 					#contains readable and executable data -> instructions

.globl main 			#this is where the code starts
main: 
###### Initilize important values for program #####################################
	li $s0 9 			#length of array
	la $s1 list 		#address for array
	#  $s2 =if(0) 		->ascend/descend

###### PRINT FIRST MESSAGE -> "enter 0 to sort in decending order"  ################
# display prompt message
	li	$v0, 4			# code for print_string
	la	$a0, getZeroA	# point $a0 to prompt string
	syscall				# print the prompt

###### PRINT SECOND MESSAGE -> "if(input != 0){ sort ls in ascending order." ######
# display prompt message
	li	$v0, 4			# code for print_string
	la	$a0, getZeroB	# point $a0 to prompt string
	syscall				# print the prompt

###### GET A NUMBER FROM THE USER #################################################
# get an integer from the user
	li	$v0, 5			# 5= read_int
	syscall				# get an int from user --> returned in $v0
	move $s2, $v0		# move the resulting int to $s2

###### MESSAGE TO PRINT ORIGINAL LIST #############################################
# display prompt message
	li	$v0, 4			# $v0- what action to take ->code for print_string
	la	$a0, before		# $a0 - param of that action -> to prompt string
	syscall				# alert kernal and execute code

# ###### PRINT ENTIRE INITIAL LIST ################################################
	jal printArray 		#go to function for printing array

###### COMPARE PREVIOUS INPUT AND THEN SORT ACCORINGLY ############################

	bne $s2, $zero, ascend #if(input != 0) {go-to ascending ordering)

###### DESCENDING ORDER ###########################################################

	#start at beginning of the list[0]

	li $t0 1 			#counter for array
	   	add $t1 $s1 $zero	#copy &list[0] ($s1=&list[0])
loop2:

    lw $t2 0($t1)       #$t3= current element
    lw $t3 4($t1)       #$t4= next element

	slt $t4, $t2, $t3   #if($t2<$t3) {$t4=1} else {$t4=0}
	bne $t4, $zero, swap #if($t4!=0) -> if($t2>$t3) {go-to swap}

	addi $t1, $t1, 4	#iterate to next element in list
	addi $t0, $t0, 1	#iterate counter

	slt $t5, $t0, $s0	#$t3=(t < &array[size] ->(check to see if at end of ls)
	bne $t5, $zero, loop2 #if(t < &array[size]) {go-to loop}

###################################################################################

	jal afterSort

###### ASCENDING ORDER ###########################################################

ascend:
	#start at beginning of the list[0]

	li $t0 1 			#counter for array
	   	add $t1 $s1 $zero	#copy &list[0] ($s1=&list[0])
loop3:

    lw $t2 0($t1)       #$t3= current element
    lw $t3 4($t1)       #$t4= next element

	slt $t4, $t2, $t3   #if($t2<$t3) {$t4=1} else {$t4=0}
	beq $t4, $zero, swap #if($t4!=0) -> if($t2>$t3) {go-to swap}

	addi $t1, $t1, 4	#iterate to next element in list
	addi $t0, $t0, 1	#iterate counter

	slt $t5, $t0, $s0	#$t3=(t < &array[size] ->(check to see if at end of ls)
	bne $t5, $zero, loop3 #if(t < &array[size]) {go-to loop}

###################################################################################
#jump here after descension to skip ascending sort
afterSort:



###### MESSAGE TO PRINT SORTED LIST ###############################################
# display prompt message
	li	$v0, 4			# $v0- what action to take ->code for print_string
	la	$a0, after		# $a0 - param of that action -> to prompt string
	syscall				# alert kernal and execute code

# ###### PRINT ENTIRE SORTED LIST #################################################
	jal printArray 		#go to function for printing array

############ END PROGRAM ################################
li    $v0,10	#$v0-what action to take, call exit: 10  #
syscall			#alert kernal and execute code           #
#########################################################


## 		F U N C T I O N S 		##
###################################################################################
###### PRINT ENTIRE INITIAL LIST ##################################################
printArray:

	#s0=9
	#s1 = &list[0]
	li $t0 0 			#counter for array
	add $t1 $s1 $zero	#copy &list[0] ($s1=&list[0])
	#	$s1 = 9 		-> list length
loop:
	lw $t2, 0($t1)		#get the current word(int) from list(array)
	addi $t1, $t1, 4	#iterate to next element in list

	#PINT ARRAY
	li $v0, 1			# 1=print_int
	move $a0, $t2		# get current int to print (from $t2)
	syscall				#get kernal's attention to print

	addi $t0, $t0, 1 	#iterate counter
	#if(t0>=$s0) {go-to exit}  ->(counter >= 9)
	slt $t2, $t0, $s0	#$t3=(t < &array[size] ->(check to see if at end of ls)
	bne $t2, $zero, loop #if(t < &array[size]) {go-to loop}
	#loopover

	# print /n for newline after array is printed!
	li	$v0, 4			# code for print_string
	la	$a0, newLine	# point $a0 to prompt string
	syscall				# print the prompt

    jr $ra 				#go back to where function was called (main)

###################################################################################
###### SWAP FUNCTION ##############################################################
swap:
    lw $t3 0($t1)       #$t3= current element
    lw $t4 4($t1)       #$t5= next element

    sw $t4 0($t1)       #move 2nd ele into 1st #bad
    sw $t3 4($t1)       #move 1st into 2nd

	jr $ra 				#go back to where function was called (ascend/descend)

##################################################################################