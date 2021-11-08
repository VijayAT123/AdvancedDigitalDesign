.text 
	li		s5, 429496730		#const for 0.1 into x21 (s5) (32,32)
	li		s6, 10

	#li 		s0, 87654321		#test value			
	csrrw	s0, 0xf00, zero		#read in from SW register (0xf00) and write to s0

	# 8 iterations for 8 7-segs
	
	#HEX7
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	s2, s6, s1			#multiply lower 32 bits by 10 and store in t0; least significant digit (S2 will be register to hold final number)

	#HEX6
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 16th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit

	#HEX5
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 256th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit


	#HEX4
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX3
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 16th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit


	#HEX2
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX1
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX0
	mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s6, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	csrrw	x0, 0xf02, s2		#writes decimal number held in s2 to io2(HEX CSR)
