/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop();

	logic	clock;
	logic	reset;
	logic	[31:0]	HEX;
	logic	[6: 0]	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic	[17:0]	SW;
    logic	[31:0]	gpio_out;


	// top dut
	// (
	// 	//////////// CLOCK //////////
	// 	.CLOCK_50(clock),
	// 	.CLOCK2_50(),
	//  .CLOCK3_50(),

	// 	//////////// LED //////////
	// 	.LEDG(),
	// 	.LEDR(),

	// 	//////////// KEY //////////
	// 	.KEY(),

	// 	//////////// SW //////////
	// 	.SW(SW),

	// 	//////////// SEG7 //////////
	// 	.HEX(HEX),
	// 	.HEX0(HEX0),
	// 	.HEX1(HEX1),
	// 	.HEX2(HEX2),
	// 	.HEX3(HEX3),
	// 	.HEX4(HEX4),
	// 	.HEX5(HEX5),
	// 	.HEX6(HEX6),
	// 	.HEX7(HEX7)
	// );

   cpu cpu (
		.clk(clock),
		.reset(reset),
		.gpio_in({14'b0, SW}),
		.gpio_out(gpio_out)
    );

// your code here

initial begin
	reset = 1; #20; reset = 0;
	clock = 0;
	SW <= 18'b111111111111111111; //262143
	if((HEX0 !== 7'b0110000) || (HEX1 !== 7'b0011001) || (HEX2 !== 7'b1111001) 
		|| (HEX3 !== 7'b0100100) || (HEX4 !== 7'b0000010) || (HEX5 !== 7'b0100100)
		|| (HEX6 !== 7'b1000000) || (HEX7 !== 7'b1000000)) begin
			$error("262143 should be displayed");
	end

end

always begin
	clock = 1; #10; clock = 0; #10;
end

// always @ (posedge clock) begin
// 	#450 //takes 450 ns to reach csrrw inst (from ModelSim wave)
// 	for(int i = 18'b0; i < 18'b111111111111111111; ++i) begin
// 		SW <= i;
// 		#10;
// 	end
// end

endmodule