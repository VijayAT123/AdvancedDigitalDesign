	.data
prompt:	.asciz "Enter a number  betwen 0 and 4294967295 (input mult. by 2^14)\n"
confirm:.asciz "Number entered: "
output1:.asciz "Square root of "
output2:.asciz " is "

	.text
	
##prompt for input
la 	a1, prompt
li	a7, 4
add	a0, a1, zero
ecall
##ask for inputs
li	a7, 5
add	a0, zero, zero
ecall
##store input val into s0
add 	s0, a0, zero
##print confirmation
la	a1, confirm
li	a7, 4
add	a0, a1, zero
ecall
li	a7, 1
add	a0, s0, zero
ecall


##set initial guess to 256 and shift left 14 (14 frac bits in result)
li 	s1, 256
slli	s1, s1, 14
##set initial step to 128 and shift left by 14
li 	s2, 128
slli 	s2, s2, 14
	
loop:
	##guess squaring and shifting
	##square guess, 32 lowest bits into s3
	mul	s3, s1, s1
	##square guess, 32 highest bits into s4
	mulhu	s4, s1, s1
	##shift s3 right 14 bits
	srli	s3, s3, 14
	##shift s4 left 18 bits
	slli	s4, s4, 18
	##bitwise or 18 upper and 14 lower
	or	s5, s3, s4

	#if s0 (input #) == s5 (guess), print result
	beq	s0, s5, result
	##if s5(guess) less than s0, add step value
	bltu	s5, s0, less_than
	##if s5(guess) greater than s0, subtract step value
	bgtu	s5,s0, greater_than
	
less_than:
	##add step to guess and store in guess reg (s1)
	add	s1, s1, s2
	##divide step by 2
	srli	s2, s2, 2
	##end of loop iteration, go back to beginning of loop and compare s5 w s0
	b 	loop
	
greater_than:
	##subtract step from guess and update guess register (s1)
	sub 	s1, s1, s2
	##divide step by 2
	srli	s2, s2, 2
	##end of loop iteration, compare s5 and s0
	b	loop

result:
	##output
	la 	a1, output1
	li	a7, 4
	add	a0, a1, zero
	ecall
	li	a7, 1
	add	a0, s0, zero
	ecall
	la 	a1, output2
	li	a7, 4
	add	a0, a1, zero
	ecall
	j exit
exit: 
	li a7, 10
	ecall

