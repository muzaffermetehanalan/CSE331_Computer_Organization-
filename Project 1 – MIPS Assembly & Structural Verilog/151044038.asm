	.data #variable declarations 

int1: .word 0 #Integer part of first number

int2: .word 0 #Integer part of second number
  
float1: .word 0 #Floating part of first number

float2: .word 0 #Floating part of second number

operand: .byte 0 #Operand 

sum1: .word 0 #Integer part of summation

sum2: .word 0 #Floating part of summation

maxDigits: .word 0 #Max Digits of numbers 

invalid: .asciiz "You entered invalid operand\n" #It is an error message

	.text  #instructions follow this line
main:

	li $v0 5 #System call for read integer 
   	syscall #systemcall
	sw $v0 int1 #store contents of  register v0 into int1
	li $v0 5 #System call for read integer
	syscall #systemcall
	sw $v0 float1 #store contents of register v0 into float1
	li $v0 12 #Systemcall for read character
	syscall #systemcall
	sw $v0 operand #store contents of register v0 into operand
 
	li $v0 12 #Read enter character for flush the buffer
	syscall #systemcall

	li $v0 5 #System call for read integer
	syscall #systemcall
	sw $v0 int2 #store contents of register v0 into int2
	li $v0 5 #Systemcall for read integer
	syscall #systemcall
	sw $v0 float2 #store contents of register v0 into float2

	lb $t2 operand #load byte at operand into register t2

	li $t0 '+' # load '+' character into t0 register
	li $t1 '-' # load '-' character into t1 register
	li $t3 '*' # load '*' character into t2 register

	beq $t2 $t0 opAdd #branch to opAdd if $t0 = $t2
	beq $t2 $t1 opSub #branch to opAdd if $t1 = $t2
	beq $t2 $t3 opMul #branch to opAdd if $t3 = $t2

	li	$v0, 4	#System call for print string	
	la	$a0, invalid #load address of string to be printed into $a0
	syscall	#Systemcall
	li $v0 10 #System call code for exit
	syscall #Systemcall

	opAdd:
		jal addInts #jump addInts and link
		jal addFloats #jump addFloats and link 
		jr calculateSumForAdd #jump calculateSumForAdd

	opSub:
		li $t3 -1 #Load -1 into register t3
		lw $t4 int2 #load word at int2 into register t4
		mult $t3 $t4 #multiply t3 and t4 and store in LO/Hİ registers
		mflo $t3 #load word at register LO into register t3
		sw $t3 int2 #store word at register t3 into int2 
		jal addInts # jump addInts and link
		sw $t4 int2 # store word at register t4 into int2
		jal addFloats #jump addFloats and link
		jr calculateSumForAdd #jump calculateSumForAdd

	opMul:
		jal multDigits # jump multDigits and link
		jr calculateSum # jump calculateSum
		
	calculateSum:
		lw $a0 sum1 #load word at sum1 into register a0
		li $v0 1  #load appropriate system call code into register $v0
		syscall #Systemcall

		li $a0 '.' #load byte at sum1 into register a0
		li $v0 11  #load appropriate system call code into register $v0
		syscall #Systemcall

		lw $a0 sum2 #load word at sum1 into register a0
		li $v0 1  #load appropriate system call code into register $v0
		syscall #Systemcall

		li $v0 10  #load appropriate system call code into register $v0
		syscall #Systemcall

	calculateSumForAdd:
		lw $t0 maxDigits #load word at maxDigits into register t0
		lw $t1 sum2 #load word at sum2 into regsiter t1
		move $a2 $t1 # a2=t1
		jal numberOfDigits # jump numberOfDigits and link
		move $t2 $a3 # t2=a3
		sub $t0 $t0 $t2 #sub t0 and t2 into t0

		lw $a0 sum1 #load word at sum1 into register a0
		li $v0 1 #load appropriate system call code into register $v0
		syscall #Systemcall

		li $a0 '.' #load '.' character into register a0
		li $v0 11 #load appropriate system call code into register $v0
		syscall #Systemcall

		li $t4 0 #load value 0 into register t4

		bgt $t0 $t4 printZerosLoop #branch printZerosLoop if t0>t4
		jr ignoreZeros #jump ignoreZeros
		printZerosLoop:
			li $a0 0 #load value 0 into register a0
			li $v0 1 #load appropriate system call code into register $v0
			syscall #Systemcall
			addi $t4 $t4 #add t1 and 1 load into t1
			bgt $t0 $t4 printZerosLoop #branch printZerosLoop if t0>t4

			
		ignoreZeros:

		lw $a0 sum2 #load word at sum2 into register a0
		li $v0 1 #load appropriate system call code into register $v0
		syscall #Systemcall

		li $v0 10 #load appropriate system call code into register $v0
		syscall #Systemcall

multDigits:
	move $s0 $ra  #s0 =ra
	lw $t0 float1 #load word at float1 into register t0
	lw $t1 float2 #load word at float2 into register t1

	move $a2 $t0 $a2=t0
	jal numberOfDigits #jump numberOfDigits and link
	move $t2 $a3 #t2=a3

	move $a2 $t1 #a2 = t1
	jal numberOfDigits #jump numberOfDigits and link
	move $t3 $a3 #t3=a3
	li $t6 10 #load value 10 into t6
	li $t8 1 #load value 1 into t8
	li $t9 0 #load value 0 into t9
	loopmul0 :
		mult $t8 $t6 #multiply t8 and t7
		mflo $t8 #load word at LO into t8
		addi $t9 $t9 1 #add t9 and value 1 into t9
		bgt $t2 $t9 loopmul0 #branch if t2>t9 

	lw $t6 int1 #load word at int1 into t6
	mult $t6 $t8 #multiply t6 and t8
	mflo $t6 #load word ad LO into t6
	add $t0 $t6 $t0 #add t6 and t0 into t0

	li $t6 10 #load value 10 into t6
	li $t8 1 #load value 1 into t8
	li $t9 0 #load value 0 into t9
	loopmul1:
		mult $t8 $t6 #multiply t8 and t7
		mflo $t8  #load word at LO into t8
		addi $t9 $t9 1 #add t9 and value 1 into t9
		bgt $t3 $t9 loopmul1 #branch if t2>t9 

	lw $t6 int2 #load word at int2 into t6
	mult $t6 $t8 #multiply t6 and t8
	mflo $t6 #load word ad LO into t6
	add $t1 $t6 $t1 #add t6 and t1 into t0


	mult $t0 $t1 #multiply t0 and t1
	mflo $t0 #load word ad LO into t0
	add $t2 $t2 $t3 #add t2 and t3 into t2

	li $t6 10 #add t6 and t1 into t0
	li $t8 1 #load value 1 into t8
	li $t9 0 #load value 0 into t9
	loopmul2:
		mult $t8 $t6 #multiply t8 and t7
		mflo $t8 #load word at LO into t8
		addi $t9 $t9 1 #add t9 and value 1 into t9
		bgt $t2 $t9 loopmul2 #branch if t2>t9 


	div $t0 $t8 #divide t0 to t8
	mfhi $t0 # t0=t0/t8
	mflo $t1 # t1 = t0 mod t8

	sw $t1 sum1 #save word at t1 into sum1
	sw $t0 sum2 #save word at t0 into sum2
	jr $s0 #jump address of s0 register

addInts:
	lw $t0 int1 #load word at int1 into t0
	lw $t1 int2 #load word at in2 into t1
	add $t0 $t0 $t1 #add t9 and value 1 into t9
	sw $t0 sum1 #save word at t0 into sum1
	jr  $ra #jump ra register

addFloats:
	move $s1 $ra # s1 = ra
	lw $t0 float1 #load word at float1 into t0
	lw $t1 float2 #load word at float2 into t1
	move $a2 $t0 #a2=t0
	jal numberOfDigits #jump numberOfDigits and link
	move $t8 $a3 #t8=a3 #load word at int1 into t0

	move $a2 $t1 #a2=t1
	jal numberOfDigits #jump numberOfDigits and link
	move $t9 $a3 # t9=a3

	li $t5 0 #load value 0 into t5
	li $t6 10 #load value 10 into t6

	beq $t8 $t9 firstEqSec #load word at int1 into t0

	bgt $t8 $t9 firstBSecond  #load word at int1 into t0
	move $s2 $t9  #add t6 and t1 into t0 
	sw $s2 maxDigits  #add t6 and t1 into t0 
	sub $t8 $t9 $t8 #load word at int1 into t0
	loop0:
		mult $t0 $t6 #load word at int1 into t0
		mflo $t0 #add t6 and t1 into t0 
		addi $t5 $t5 1 #add t6 and t1 into t0 
		bgt $t8 $t5 loop0 #load word at int1 into t0
		jr exit0 #add t6 and t1 into t0 

	firstBSecond:
		move $s2 $t8 #load word at int1 into t0
		sw $s2 maxDigits #add t6 and t1 into t0 
		sub $t9 $t8 $t9 #load word at int1 into t0
		loop1:
			mult $t1 $t6 #add t6 and t1 into t0 
			mflo $t1 #load word at int1 into t0
			addi $t5 $t5 1 #add t6 and t1 into t0 
			bgt $t9 $t5 loop1 #load word at int1 into t0
			jr exit0


	exit0:
		lb $t2 operand #add t6 and t1 into t0 
		li $t7 '-' #load word at int1 into t0
		beq $t2 $t7 goForSub #add t6 and t1 into t0 
		add $t0 $t0 $t1 #add t9 and value 1 into t9
		li $t1 1 #save word at t1 into sum1
		li $t9 0 #load word at int1 into t0
		loop :
			mult $t1 $t6 #load word at int1 into t0
			mflo $t1 #add t6 and t1 into t0 
			addi $t9 $t9 1 #load word at int1 into t0
			bgt $s2 $t9 loop

		sub $s2 $t0 $t1 #load word at int1 into t0
		bge $t0 $t1 sumApp #add t6 and t1 into t0 
		sw $t0 sum2 #load word at int1 into t0
		jr lastExit #save word at t1 into sum1

		sumApp:
			lw $t5 sum1#save word at t1 into sum1
			addi $t5 $t5 1 #add t6 and t1 into t0 
			sw $t5 sum1 #add t6 and t1 into t0 
			sw $s2 sum2 #load word at int1 into t0
			jr lastExit #save word at t1 into sum1


	firstEqSec:
		move $s2 $t9 #load word at int1 into t0
		sw $s2 maxDigits #load word at int1 into t0
		jr exit0 #save word at t1 into sum1

	goForSub:
		lw $s3 int1
		lw $s4 int2 #add t6 and t1 into t0 
		ble $s3 $s4 negSum #add t6 and t1 into t0 
		bge $t0 $t1 FbS
		li $t4 1
		li $t9 0
		subloop :
			mult $t4 $t6 #add t6 and t1 into t0 
			mflo $t4 #add t6 and t1 into t0 
			addi $t9 $t9 1
			bgt $s2 $t9 subloop #load word at int1 into t0
		add $t0 $t0 $t4 #add t9 and value 1 into t9
		sub $t0 $t0 $t1
		sw $t0 sum2
		lw $t5 sum1
		addi $t5 $t5 -1 #add t6 and t1 into t0 
		sw $t5 sum1
		jr lastExit #add t6 and t1 into t0 
		FbS:
			sub $t0 $t0 $t1 #add t6 and t1 into t0 
			sw $t0 sum2
			jr lastExit

		negSum:
			bge $t1 $t0 negSum2 #add t6 and t1 into t0 
			li $t4 1
			li $t9 0
			subloop2 :
			mult $t4 $t6 #add t6 and t1 into t0 
			mflo $t4 #add t6 and t1 into t0 
			addi $t9 $t9 1 #add t6 and t1 into t0 
			bgt $s2 $t9 subloop2
			lw $t3 sum1
			addi $t3 $t3 1
			sw $t3 sum1
			add $t1 $t1 $t4 #add t9 and value 1 into t9
			sub $t1 $t1 $t0 #add t9 and value 1 into t9
			sw $t1 sum2 #add t6 and t1 into t0 
			jr lastExit #add t6 and t1 into t0 

			negSum2:
				sub $t1 $t1 $t0 #sub t1 and t0 into t1
				sw $t1 sum2 #save word at t1 into sum2
				jr lastExit #jump lastExit

	lastExit:
		jr $s1 #jump s1

numberOfDigits:
	li $a3 0 #load value 0 into a3
	li $t6 10 #load value 10 into t6
	li $t5 0 #load value 0 into t5
	loop2:
		beq $a2 $t5 exit1 #branch if a2=t5
		addi $a3 $a3 1 #add a3 and value 1 into a3
		div $a2 $t6 # a2/a6
		mflo $a2 #a2 = a2/a6
		jr loop2 #jump loop2

	exit1:
		jr $ra #jump ra register











