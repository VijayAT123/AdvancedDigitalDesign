module hexdriver (input [3:0] val, output logic [6:0] HEX);

	/* your code here */

	//could also use assign instead of always begin (followed by nester ternaries)
	always begin //begin called sensitivity from always sensitivity list
		if (val == 4'h0) begin //if all 4 switches off 
// input [3:0] 4 bits; val comparison should match bit width (always specify to debug errors)
			HEX = 7'b1000000; //all segments except segment 6, diplays a 0
		end else if (val == 4'hf) begin //if all switches on
			HEX = 7'b1111001; // all segments turned off except 1 and 2 (HEXs in active low); displays a 1
		end else begin
			HEX = 7'b1111111; //all segments turned off
		end
		
	end

endmodule
