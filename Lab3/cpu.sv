module cpu ();

logic   clk;
reg     [31:0]  prog_counter;

instruction_decode decoder ()

control_unit cu (
    .rs1(decoder.rs1)
)
always @(posedge clk, posedge rst) begin
    if (rst)
        prog_counter <= 32'b0;
    else
        prog_counter <= prog_counter + 1'b1;

endmodule