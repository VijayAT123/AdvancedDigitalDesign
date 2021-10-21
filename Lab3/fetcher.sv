module fetcher (
    input   [0:0]   clk,
    input   [0:0]   rst,

    output  [31:0]  prog_counter
)

always @(posedge clk, posedge rst) begin
    if (rst)
        prog_counter <= 32'b0;
    else
        prog_counter <= prog_counter + 1'b1;
    