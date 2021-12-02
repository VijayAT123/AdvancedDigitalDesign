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
	assign	HEX = 	gpio_out;


	// top dut
	// (
	// 	//////////// CLOCK //////////
	// 	.CLOCK_50(clock),
	// 	.CLOCK2_50(),
	//  	.CLOCK3_50(),

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
	//);

   cpu cpu (
		.clk(clock),
		.reset(reset),
		.gpio_in({14'b0, SW}),
		.gpio_out(gpio_out)
    );

hexdriver hex7(.val(gpio_out[ 3: 0]), .HEX(HEX7[6:0])); 
hexdriver hex6(.val(gpio_out[ 7: 4]), .HEX(HEX6[6:0])); 
hexdriver hex5(.val(gpio_out[11: 8]), .HEX(HEX5[6:0])); 
hexdriver hex4(.val(gpio_out[15:12]), .HEX(HEX4[6:0])); 
hexdriver hex3(.val(gpio_out[19:16]), .HEX(HEX3[6:0]));
hexdriver hex2(.val(gpio_out[23:20]), .HEX(HEX2[6:0]));
hexdriver hex1(.val(gpio_out[27:24]), .HEX(HEX1[6:0]));
hexdriver hex0(.val(gpio_out[31:28]), .HEX(HEX0[6:0]));

always begin
	clock = 1; #10; clock = 0; #10;
end

initial begin
	reset = 1; #20; reset = 0;
	clock = 0;
	
	SW <= 18'b111111111111111111; #1000; //262143

	reset = 1; #20; reset = 0;

	for (int i = 1; i <= 18'b111111111111111111; ++i) begin
		SW <= i;
		#980;
		reset = 1; # 20;
		reset = 0;
	end
end

//testing for lab4 needs to make sure insts are executed in:
//0, 1, 2, 3, 4, 8, 9, 10, 9, 10, 11, 12, 13

always_comb begin
	////SW <= 18'b0; #1000; //0
	if ((SW ==  18'b0) && (((HEX7!= 7'b1000000) || (HEX6 != 7'b100000) || (HEX5!= 7'b1000000) || (HEX4!= 7'b1000000)|| (HEX3!= 7'b1000000)|| (HEX2!= 7'b1000000) || (HEX1!= 7'b1000000) || (HEX0!= 7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1000000, HEX0 should display a 7'b1000000", SW);
end
	//SW <= 18'b1; #1000;
 	else if ((SW ==  18'b1) && ( ((HEX0 != 7'b1111001) || (HEX1 != 7'b1000000) || (HEX2!= 7'b1000000) || (HEX3!= 7'b1000000)|| (HEX4!= 7'b1000000)|| (HEX5!= 7'b1000000) || (HEX6!= 7'b1000000) || (HEX7!= 7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1000000, HEX0 should display a 7'b1000000", SW);

end

	//SW <= 18'b10; #1000;
 else if ((SW == 18'b10) && ( ((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1000000) || (HEX0 !=  7'b0100100)))) begin
	$error("%d HEX7 should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1000000, HEX0 should display a 7'b0100100", SW);

end
	//SW <= 18'b11; #1000;
 else if ((SW ==   18'b11) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1000000) || (HEX0 !=  7'b0110000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1000000, HEX0 should display a 7'b0110000", SW);

end
	//SW <= 18'b101; #1000;
 else if ((SW ==  18'b101) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1000000) || (HEX0 !=  7'b0010010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1000000, HEX0 should display a 7'b0010010", SW);

end
	//SW <= 18'b1011; #1000;
 else if((SW ==  18'b1011) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1111001) || (HEX0 !=  7'b1111001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1111001, HEX0 should display a 7'b1111001", SW);

end
//SW <= 18'b1010; #1000;
 else if ((SW ==  18'b1010) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1111001) || (HEX0 !=  7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1111001, HEX0 should display a 7'b1000000", SW);

end
//SW <= 18'b10010; #1000;
 else if ((SW ==  18'b10010) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b1111001) || (HEX0 !=  7'b0)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b1111001, HEX0 should display a 7'b0", SW);

end

//SW <= 18'b10110; #1000;
 else if ((SW ==  18'b10110) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b0100100) || (HEX0 !=  7'b0100100)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b0100100, HEX0 should display a 7'b0100100", SW);

end

//SW <= 18'b111001; #1000;
 else if ((SW ==  18'b111001) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b0010010) || (HEX0 !=  7'b1111000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b0010010, HEX0 should display a 7'b1111000", SW);

end

//SW <= 18'b101000;  #1000;
//TODO change HEX7!=  7'b1000010 to HEX7!=  7'b1000000
 else if ((SW ==  18'b100000) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b0011001) || (HEX0 !=  7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b0011001, HEX0 should display a 7'b1000000", SW);

end

//SW <= 18'b1010101; #1000;
 else if ((SW ==  18'b1010101) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1000000) || (HEX1!=  7'b0) || (HEX0 !=  7'b0010010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1000000, HEX1 should display a 7'b0, HEX0 should display a 7'b0010010", SW);

end

//SW <= 18'b1101000; #1000;
 else if ((SW ==  18'b1101000) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1111001) || (HEX1!=  7'b1000000) || (HEX0 !=   7'b0011001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1111001, HEX1 should display a 7'b1000000, HEX0 should display a  7'b0011001", SW);

end
//SW <= 18'b11010010; #1000;
 else if ((SW ==  18'b11010010) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0100100) || (HEX1!=  7'b1111001) || (HEX0 !=   7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0100100, HEX1 should display a 7'b1111001, HEX0 should display a  7'b1000000", SW);

end

//SW <= 18'b10011100; #1000;
 else if ((SW ==  18'b10011100) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b1111001) || (HEX1!=  7'b0010010) || (HEX0 !=   7'b0000010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b1111001, HEX1 should display a 7'b0010010, HEX0 should display a  7'b0000010", SW);

end
//SW <= 18'b101101001; #1000;
 else if ((SW ==  18'b101101001) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0000010) || (HEX0 !=   7'b1111001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0000010, HEX0 should display a  7'b1111001", SW);

end

//SW <= 18'b101110001; #1000;
 else if ((SW ==  18'b101110001) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0000010) || (HEX0 !=   7'b0010000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0000010, HEX0 should display a  7'b0010000", SW);

end
//SW <= 18'b1000110111; #1000;
 else if ((SW ==  18'b1000110111) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0010010) || (HEX1!=  7'b0000010) || (HEX0 !=   7'b1111000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0010010, HEX1 should display a 7'b0000010, HEX0 should display a  7'b1111000", SW);

end
//SW <= 18'b1100110011; #1000;
 else if ((SW ==  18'b1100110011) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0) || (HEX1!=  7'b1111001) || (HEX0 !=   7'b0010000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0, HEX1 should display a 7'b1111001, HEX0 should display a  7'b0010000", SW);

end
//SW <= 18'b10101010101; #1000;
 else if ((SW ==  18'b10101010101) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1111001)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0000010) || (HEX0 !=   7'b0010010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1111001, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0000010, HEX0 should display a  7'b0010010", SW);

end
//SW <= 18'b11100110001; #1000;
 else if ((SW ==  18'b11100110001) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1111001)|| (HEX2!=  7'b0) || (HEX1!=  7'b0011001) || (HEX0 !=   7'b1111001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1111001, HEX2 should display a 7'b0, HEX1 should display a 7'b0011001, HEX0 should display a  7'b1111001", SW);

end
//SW <= 18'b110101111000; #1000;
 else if ((SW ==  18'b110101111000) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b0110000)|| (HEX2!=  7'b0011001) || (HEX1!=  7'b0011001) || (HEX0 !=   7'b0)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b0110000, HEX2 should display a 7'b0011001, HEX1 should display a 7'b0011001, HEX0 should display a  7'b0", SW);

end
//SW <= 18'b100011011101;  #1000;
 else if ((SW ==  18'b100011011101) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b0100100)|| (HEX2!=  7'b0100100) || (HEX1!=  7'b0000010) || (HEX0 !=   7'b0010000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b0100100, HEX2 should display a 7'b0100100, HEX1 should display a 7'b0000010, HEX0 should display a  7'b0010000", SW);
end
//SW <= 18'b1010010111011; #1000;
 else if ((SW ==  18'b1010010111011) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b0010010)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b1000000) || (HEX0 !=   7'b1111000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b0010010, HEX2 should display a 7'b0110000, HEX1 should display a 7'b1000000, HEX0 should display a  7'b1111000", SW);

end
//SW <= 18'b1110011010111; #1000;
 else if ((SW ==  18'b1110011010111) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1000000)|| (HEX3!=  7'b1111000)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0) || (HEX0 !=   7'b0110000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1000000, HEX3 should display a 7'b1111000, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0, HEX0 should display a  7'b0110000", SW);

end
//SW <= 18'b10100010010001; #1000;
 else if ((SW ==  18'b10100010010001) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1111001)|| (HEX3!=  7'b1000000)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0) || (HEX0 !=   7'b0010010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1111001, HEX3 should display a 7'b1000000, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0, HEX0 should display a  7'b0010010", SW);

end
//SW <= 18'b10110001110110; #1000;
 else if ((SW ==  18'b10110001110110) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1111001)|| (HEX3!=  7'b1111001)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b0) || (HEX0 !=   7'b0100100)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1111001, HEX3 should display a 7'b1111001, HEX2 should display a 7'b0110000, HEX1 should display a 7'b0, HEX0 should display a  7'b0100100", SW);

end
//SW <= 18'b101101001110100; #1000;
 else if ((SW ==  18'b101101001110100) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b0100100)|| (HEX3!=  7'b0110000)|| (HEX2!=  7'b1111001) || (HEX1!=  7'b0010010) || (HEX0 !=   7'b0000010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b0100100, HEX3 should display a 7'b0110000, HEX2 should display a 7'b1111001, HEX1 should display a 7'b0010010, HEX0 should display a  7'b0000010", SW);

end
//SW <= 18'b100101110101110; #1000;
 else if ((SW ==  18'b100101110101110) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b1111001)|| (HEX3!=  7'b0010000)|| (HEX2!=  7'b0110000) || (HEX1!=  7'b1111000) || (HEX0 !=   7'b0011001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b1111001, HEX3 should display a 7'b0010000, HEX2 should display a 7'b0110000, HEX1 should display a 7'b1111000, HEX0 should display a  7'b0011001", SW);

end
//SW <= 18'b1011101000101100; #1000;
 else if ((SW ==  18'b1011101000101100) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b0011001)|| (HEX3!=  7'b1111000)|| (HEX2!=   7'b0000010) || (HEX1!=   7'b0000010) || (HEX0 !=  7'b1000000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b0011001, HEX3 should display a 7'b1111000, HEX2 should display a  7'b0000010, HEX1 should display a  7'b0000010, HEX0 should display a  7'b1000000", SW);

end
//SW <= 18'b1011011101010110; #1000;
 else if ((SW ==  18'b1011011101010110) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b0011001)|| (HEX3!=  7'b0000010)|| (HEX2!=   7'b0010000) || (HEX1!=   7'b0110000) || (HEX0 !=  7'b0011001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b0011001, HEX3 should display a 7'b0000010, HEX2 should display a  7'b0010000, HEX1 should display a  7'b0110000, HEX0 should display a  7'b0011001", SW);

end
//SW <= 18'b10101110101000111; #1000;
 else if ((SW ==  18'b10101110101000111) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1000000) || (HEX4!=  7'b0)|| (HEX3!=  7'b0010000)|| (HEX2!=   7'b0011001) || (HEX1!=   7'b1111001) || (HEX0 !=  7'b0010010)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1000000, HEX4 should display a 7'b0, HEX3 should display a 7'b0010000, HEX2 should display a  7'b0011001, HEX1 should display a  7'b1111001, HEX0 should display a  7'b0010010", SW);

end
//SW <= 18'b11101101010011010; #1000;
 else if ((SW ==  18'b11101101010011010) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1111001) || (HEX4!=  7'b0100100)|| (HEX3!=  7'b1111001)|| (HEX2!=   7'b0011001) || (HEX1!=   7'b0010000) || (HEX0 !=  7'b0)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1111001, HEX4 should display a 7'b0100100, HEX3 should display a 7'b1111001, HEX2 should display a  7'b0011001, HEX1 should display a  7'b0010000, HEX0 should display a  7'b0", SW);

end
//SW <= 18'b100101110010100111; #1000;
 else if ((SW ==  18'b100101110010100111) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b1111001) || (HEX4!=  7'b0010010)|| (HEX3!=  7'b0011001)|| (HEX2!=   7'b1111000) || (HEX1!=   7'b0010000) || (HEX0 !=  7'b1111001)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b1111001, HEX4 should display a 7'b0010010, HEX3 should display a 7'b0011001, HEX2 should display a 7'b1111000, HEX1 should display a  7'b0010000, HEX0 should display a  7'b1111001", SW);

end
//SW <= 18'b111111111111111111; #1000;
 else if ((SW ==  18'b111111111111111111) && (((HEX7!=  7'b1000000) || (HEX6 !=  7'b1000000) || (HEX5!=  7'b0100100) || (HEX4!=  7'b0000010)|| (HEX3!=  7'b0100100)|| (HEX2!=   7'b1111001) || (HEX1!=   7'b0011001) || (HEX0 !=  7'b0110000)))) begin
	$error("%d HEX7should display a 7'b1000000, HEX6 should display a 7'b1000000,HEX5 should display a 7'b0100100, HEX4 should display a 7'b0000010, HEX3 should display a 7'b0100100, HEX2 should display a 7'b1111001, HEX1 should display a  7'b0011001, HEX0 should display a  7'b0110000", SW);
end
end


// always @ (posedge clock) begin
// 	#450 //takes 450 ns to reach csrrw inst (from ModelSim wave)


// end

endmodule
