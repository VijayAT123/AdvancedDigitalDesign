.text 
                li		s8, 429496730		#const for 0.1 into x21 (t4) (32,32)
                li		s9, 10
                li      s0, 225             #test value, result should be 15
                #csrrw	s0, 0xf00, zero		#actual value; read in from SW register (0xf00) and write to s0
                
                li      t0, 256             ##set initial guess to 256 
                slli    t0, t0, 14          #shift left 14 (14 frac bits in result)
                li 	    t1, 128             #initial step = 128
                slli 	t1, t1, 14          #shift left by 14

##guess squaring and shifting
loop:           mul	    t2, t0, t0          ##square guess, 32 lowest bits into t2
                mulhu	t3, t0, t0          ##square guess, 32 highest bits into t3
                srli	t2, t2, 14          ##shift t2 right 14 bits
                slli	t3, t3, 18          ##shift t3 left 18 bits
        
                or	    t4, t2, t3          ##bitwise or 18 upper and 14 lower
        
                beq	    s0, t4, result      ##if s0 (input #) == t4 (guess), print result
                bltu	t4, s0, less_than   ##if t4(guess) less than s0, add step value
                bgtu	t4, s0, greater_than##if t4(guess) greater than s0, subtract step value

less_than:      add	    t0, t0, t1          ##add step to guess and store in guess reg (t0)
	            srli	t1, t1, 2           ##divide step by 2
	            b 	    loop                ##end of loop iteration, go back to beginning of loop and compare t4 w s0
	
greater_than:   sub 	t0, t0, t1          ##subtract step from guess and update guess register (t0)
            	srli	t1, t1, 2           ##divide step by 2
                b	    loop                ##end of loop iteration, compare t4 and s0
	
result:
	# 8 iterations for 8 7-segs
	
	#HEX7
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	s2, s9, s1			#multiply lower 32 bits by 10 and store in t0; least significant digit (S2 will be register to hold final number)

	#HEX6
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 16th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit

	#HEX5
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 256th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit


	#HEX4
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX3
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			#shift left by 4 bits; moves least significant digit into 16th's place to make room to append next digit
	or		s2, s2, t0			#appends next digit


	#HEX2
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX1
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit


	#HEX0
	mul		s1, s8, s0			#multiply SW by 0.1 and store lower 32 in s1
	mulh	s0, s8, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
	mulhu	t0, s9, s1			#multiply lower 32 bits by 10 and store in t1; 2nd least sig digit

	slli	s2, s2, 4			
	or		s2, s2, t0			#appends next digit