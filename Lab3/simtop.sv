/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clock;
	logic reset;
	logic [31:0] HEX;
	logic [6: 0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [17:0] SW;


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
	cpu cpu (
		.clk(clk),
		.reset(reset),
		.gpio_in({14'b0, SW}),
		.gpio_out(HEX)
	);

initial
	reset = 1; #10; reset = 0;

always
	clock = 1; #10; clock = 0; #10;

always @ (posedge clock) begin
	for(int i = 5'b0; i < 5'b10010; ++i) {
		SW <= i;
	}
end

endmodule

