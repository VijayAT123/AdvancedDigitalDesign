.text       
	    li      s5, 429496730		    #const for 0.1 into x21 (s5) (32,32)
	    li      s6, 10
            li      t2, 100000               #const for multiplying guess by 100000
            #addi    s0, zero, 100
            csrrw   s0, 0xf00, zero         #read in switches' value into s0

            slli    s0, s0, 14              #multiples input by 100,000

            li      s1 256                  #set initial guess to 256
            slli    s1, s1, 14              #shift guess left 14 so we hve 14 fractional bits
            li      s2 128                  #set initial step size to 128
            slli    s2, s2, 14              #shift step by 14 to have 14 fractional bits

#guess squarting and shifting
loop:       mul     s3, s1, s1              #square initial guess (256^2) and put lower bits in s3 
            mulhu   s4, s1, s1              #square initial guess (256^2) and place upper bits into s4
            srli    s3, s3, 14              #shift lower bits right by 14 (becomes 0, 32)
            slli    s4, s4, 18              #shift upper bits left 18 (becomes 32,0)
            or      s4, s3, s4              #bitwise OR upper and lower halves to place (32,32) result into s4

            beq     s4, s0, bin2dec          #if guess == switch value, proceed to binary2dec
            blt     s4, s0, Step_Up         #if guess < switch value, rewrite guess with guess + step and decrease step
            bgt     s4, s0, Step_Down       #if guess > switch value, rewrite guess with guess - step and decrease step

decrement:  srli    s2, s2, 1               #shifting step right by 2 = step/2
            beqz    s2, bin2dec              #if step == 0, proceed to binary2dec
            b loop                          #end of loop iteration

Step_Up:    add     s1, s1, s2              #rewrite guess with guess + step
            b decrement                     #decrease step

Step_Down:  sub     s1, s1, s2              #rewrite guess with guess + step
            b decrement                     #decrease step


bin2dec:     mv      a0, s1                  #move guess into a0 to use with binary2dec

#bin2dec

	        #li 	s0, 87654321		    #test value			
	        #csrrw	s0, 0xf00, zero		    #read in from SW register (0xf00) and write to s0
            mv      s0, a0                  #replace switch input with guess
            
            mul    t3, s0, t2              #multiply guess by 10E5 and store lower 32 bits in t3
            mulhu   t4, s0, t2              #multiply guess by 10E5 and store upper 32 bits in t4
            srli    t3, t3, 14              #shift lower 32 bits right by 14 (0,32)
            slli    t4, t4, 18              #shift upper 32 bits left by 18 (32,0)
            or      s0, t4, t3              #replace guess with bitwise OR upper 32 and lower 32 bits
            
            # 8 iterations for 8 7-segs
            
            #HEX7
            mul		s1, s5, s0			#multiply SW by 0.1 and store lower 32 in s1
            mulh	s0, s5, s0			#multiply SW by 0.1 and overwrite upper 32 in s0
            mulhu	s2, s6, s1			#multiply upper 32 bits by 10 and store in t0; least significant digit (S2 will be register to hold final number)

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
