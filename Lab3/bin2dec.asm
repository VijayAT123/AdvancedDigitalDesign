.text 
	li 	s5, 429496730	#const for 0.1 into x21 (s5) (32,32)
	li	s6, 10		#constant factor
	
	csrrw	s0, 0xf00, zero	#read in from SW register (0xf00) and write to s0
	mulh	t0, s5, s0	#multiplies SW's value by 0.1 and stores upper 32 bits in t0
	mul	t1, s5, s0	#stores lower 32, fractional bits of SW x s5 in t1
	mul
	
	


