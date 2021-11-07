.text
	csrrw	x1, 0xf00, x3	#(x21) <= SW
	csrrw	x20, 0xf02, x1	#