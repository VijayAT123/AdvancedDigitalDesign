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
		counter = 16'b0;
		SW <= 18'b1; //initializes all switches to off
		if(HEX0 !== 7'b1000000) begin //automatic test case; all switches off so all displays should show 0
			$error("HEX0 should display a 0 (7'b1000000)");
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
	always @(negedge clk) begin
		for (int i = 0; i < 16; i++) begin
			$display("counter=%x\n", i);
			// ===, !==, etc. is == for nonsynthesizable testbenches
			//allows for X and Z comparison for logic data types
			if ((i !== 0) && (i !== 15)) begin  // HEX0 only on for counter = 0 and counter = 15
				if(HEX0 !=+ 7'b1111111) begin
					$error("Value: %d HEX0 should have all segs turned off for values 1-14", i);
				end
			end else if (i == 15) begin //switches 0-3 turned on; HEX0 should display a 1
				if(HEX0 !== 7'b1111001) begin
					$error("HEX0 should display a 1 (7'b1111001) for test case %d", i);
				end
			end
		end
	end
		
		/*
		if(counter == 16'b11110000) //switches 4-7 turned on; HEX1 should be 7'b1111001
if(counter == 16'd0) begin //all switches turned off, all hexes should be 7'b1000000
			if(HEX0 == 7'b1111001) //correct case
				$display("HEX0 correctly shows a 0 for test case 0");
			end
		end else if(counter == 16'd1) begin
			if(HEX0 != 7'b1111111) begin
				$display("HEX0 should have all segs turned off");
				num_errors = num_errors + 16'd1;
			end
		end else if(counter == 16'd2) begin
				$display("HEX0 should have all segs turned off");
				num_errors = num_errors + 16'd1;
			end
		end else if(counter == 16'd3) begin
				$display("HEX0 should have all segs turned off");
				num_errors = num_errors + 16'd1;
			end
		end else if(counter == 16'd4) begin
			if(HEX0 != 7'b1111111) begin
				$display("HEX0 should have all segs turned off");
				num_errors = num_errors + 16'd1;
			end	
*/

endmodule

