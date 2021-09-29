/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk; //defaulted to 1 bit 
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;
	logic counter [15:0]; //logic data type, 16 bit wide
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

// your code here
	
	initial begin
		clk = 0;
		counter = 16'b0;
	end

	//on a board, this explicitly says combinational logic instead of clocked
	always begin 
		//clk has a period of 10 sim time units
		clk = 1; #10; clk = 0; #10; //delay for 10 time units; defines minimum granularity of sim
	end

	always  @(posedge clk) begin  //on positive clock edge, do this
		counter <= counter + 16'b1; //16 bit 
		$display("counter=%x\n", counter); //printf
	end

	always @(negedge clk) begin
		for (int i = 0; i < 16; i++) begin
			if (i == 0) begin //HEX0 should display 7'b1000000 for 0
				if(HEX0 != 7'b1000000) begin
					$display("HEX0 should display a 0 (7'b1000000)");
				end
			end else if ((i != 0) && (i != 15)) begin  // HEX0 only on for counter = 0 and counter = 15
				if(HEX0 != 7'b1111111) begin
					$display("HEX0 should have all segs turned off for values 1-14");
				end
			end else if (i == 15) begin //switches 0-3 turned on; HEX0 should display a 1
				if(HEX0 != 7'b1111001) begin
					$display("HEX0 should display a 1 (7'b1111001)");
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

