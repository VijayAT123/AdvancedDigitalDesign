module hexdriver (input [3:0] val, output logic [6:0] HEX);

	// input [3:0] 4 bits; val comparison should match bit width (always specify to debug errors)
	//could also use assign instead of always begin (followed by nester ternaries)
	always begin //begin called sensitivity from always sensitivity list
		if (val == 4'b0) //if all 4 switches off 
			HEX = 7'b1000000; //all segments except segment 6, diplays a 0
		else if (val == 4'b1) //if first switch on
			HEX = 7'b1111001; // all segments turned off except 1 and 2 (HEXs in active low); displays a 1
		else if (val == 4'b0010) //if second switch on; 2
			HEX = 7'b0100100;
		else if (val == 4'b0011) //if first 2 switches on; 3
			HEX = 7'b0110000;
		else if (val == 4'b0100) // 3rd switch on; 4
			HEX = 7'b0011001;
		else if (val == 4'b0101) //3rd and 1st switch on; 5
			HEX = 7'b0010010;
		else if (val == 4'b0110) //3rd and 2nd switch on; 6
			HEX = 7'b0000010;
		else if (val == 4'b0111) //3rd 2nd and 1st switch on; 7
			HEX = 7'b1111000;
		else if (val == 4'b1000) //4th switch on; 8
			HEX = 7'b0; //all segments on
		else if (val == 4'b1001) //4th and 1st switch on; 9
			HEX = 7'b0010000;
		else if (val == 4'b1010) //4th and 2nd switch on; A
			HEX = 7'b0001000;
		else if (val == 4'b1011) //4th 2nd and 1st switch on; b
			HEX = 7'b0000011;
		else if (val == 4'b1100) //4th and 3rd switch on; C
			HEX = 7'b1000110;
		else if (val == 4'b1101) //4th 3rd and 1st switch on; d
			HEX = 7'b0100001;
		else if (val == 4'b1110) //4th 3rd and 2nd switches on; e
			HEX = 7'b0000110;
		else if (val == 4'b1111) //all switches on; f
			HEX = 7'b0001110;
	end

endmodule 
