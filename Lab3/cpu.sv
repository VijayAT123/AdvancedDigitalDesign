module cpu (
    output
);

logic   [0: 0]  clk;
logic   [0: 0]  reset;
reg     [11:0]  prog_counter_fetch; //12 bit wide to match #rows in instruction_mem
logic   [31:0]  instruction_mem [4095:0]; //4096 x 32
logic   [2: 0]  inst_type;
logic   [31:0]  instruction_EX;



instruction_decode decoder (
    .inst(instruction_EX),
)

control_unit cu (
    .funct7(decoder.funct7),
)

regfile register (
    .clk(clk);
    .rst(reset),        /* reset */
	.we(),              /* write enable */
	.readaddr1(decoder.rs1),       /* read address 1 */
	.readaddr2(),		/* read address 2 */
	.writeaddr(),		/* write address */
	.writedata(),
)

initial 
    $readmemh("hexcode.txt", instruction_mem); //readmemh always in initial

always_ff @(posedge clk) begin
    if (rst)
        prog_counter <= 32'b0;
    else
        instruction_EX <= instruction_mem[prog_counter];
        prog_counter_fetch <= prog_counter_fetch + 12'b1;
endmodule