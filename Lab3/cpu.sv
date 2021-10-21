module cpu (
    output
);

logic   [0:0 ]  clk;
reg     [11:0]  prog_counter; //12 bit wide to match #rows in instruction_mem
logic   [31:0]  instruction_mem [4095:0];


instruction_decode decoder ()

control_unit cu (
    .rs1(decoder.rs1)
)

initial 
    $readmemh("hexcode.txt", instruction_mem);

always @(posedge clk, posedge rst) begin
    if (rst)
        prog_counter <= 32'b0;
    else
        instruction_EX <= instruction_mem[prog_counter];
        prog_counter <= prog_counter + 12'b1;

endmodule