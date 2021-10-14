module hexdriver (input [3:0] val, output logic [6:0] HEX);

	// input [3:0] 4 bits; val comparison should match bit width (always specify to debug errors)
	//could also use assign instead of always begin (followed by nester ternaries)
	always_comb begin //begin called sensitivity from always sensitivity list
		if (val == 4'b0) //if all 4 switches off 
			HEX = 7'0b100000; //all segments except segment 6, diplays a 0
		else if (val == 4'b1) //if first switch on
			HEX = 7'b1111001; // all segments turned off except 1 and 2 (HEXs in active low); displays a 1
		else if (val == 4'b10) //if second switch on
			HEX = 7'b0100100;
		else if (val == 4'b11) //if first 2 switches on; 3
			HEX = 7'b0110000;
		else if (val == 4'b100) // 3rd switch on; 4
		
	end

endmodule
