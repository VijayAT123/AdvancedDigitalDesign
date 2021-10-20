/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk; //defaulted to 1 bit 
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;
	reg counter [15:0]; //logic data type, 16 bit wide
	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);

	//one time initial conditions	
	initial begin
		clk = 0;
		SW <= 18'b000000000000000000; //initializes all switches to off
		if((HEX0 !== 7'b1000000) || (HEX1 !== 7'b1000000) || (HEX2 !== 7'b1000000) 
		|| (HEX3 !== 7'b1000000) || (HEX4 !== 7'b1000000) || (HEX5 !== 7'b1000000)
		|| (HEX6 !== 7'b1000000) || (HEX7 !== 7'b1000000)) begin //automatic test case; all switches off so all displays should show 0
			$error("All 7 segs should display a 0 (7'b1000000)");
		end
	end

	//no sensitivity list (posedge/negedge clk/reset); continuoulsy triggers
	//not synthesizable, only in simulation
	always begin 
		//clk has a period of 10 sim time units
		clk = 1; #10; clk = 0; #10; //delay for 10 time units; defines minimum granularity of sim
		//time delay not allowed on hardware
	end

	/*always @ (posedge clk) begin 
		counter <= counter + 16'b1; //<= is non blocking assignment (used for sequential logic)
		//use non blocking (<=) for sequential, blocking (=) for combinational
	*/
	always @(posedge clk) begin
		SW <= 18'b1;
		if (HEX0 !== 7'b11111001) //1 for 1st group of SWs
			$error ("HEX0 should display a 1 (7'b11111001)");
		#10;

		SW <= 18'b1111; //15 for 1st group of SWs
		if(HEX0 != 7'b0001110)
			$error("HEX0 should display F (7'b0001110)");
		#10;
		
		SW <= 18'b01010000; //5 for 2nd group of SWs
		if(HEX1 != 7'b0010010)
			$error("HEX1 should display a 5 (7'b0010010)");
		#10;
		
		SW <= 18'b11000000; //C for 2nd group of SWs
		if(HEX1 != 7'b1000110)
			$error("HEX1 should display a C (7'b1000110)");
		#10;
		
		SW <= 18'b110100000000; //D for 3rd group of SWs
		if(HEX2 != 7'b0100100)
			$error("HEX2 should display a 2 (7'b0100100");
		#10;
		
		SW <= 18'b010000000000; //4 for 3rd group of SWs
		if(HEX2 != 7'b0011001)
			$error("HEX2 should display a 4 (7'b0011001)");
		#10;
		
		SW <= 18'b1000000000000000; //8 for 4th group of SWs
		if(HEX3 != 7'b0)
			$error("HEX3 should display a 8 (7'b0000000");
		#10;
		
		SW = 18'b1010000000000000; //A for 4th group of SWs
		if(HEX3 != 7'b0001000)
			$error("HEX3 should display a A (7'b0001000");
		#10;
		
		SW <= 18'b00110000000000000000; //3 for 5th group of SWs
		if(HEX4 != 7'b0110000)
			$error("HEX4 should display a 3 (7'b0110000)");
		#10;
		
		SW <= 18'b01000000000000000000; //2 for 5th group of SWs
		if(HEX4 != 7'b0100100)
			$error("HEX4 should display a 2 (7'b0100100");
		#10;
		
	end
endmodule

