//all combinational

module control_unit (
    input   [6:0]   funct7
    input   [4:0]   rs1,
    input   [4:0]   rs2,
    input   [4:0]   rd,
    input   [2:0]   funct3,
    input   [11:0]  immI,
    input   [11:0]  immS,
    input   [19:0]  immU,
    input   [2:0]   inst_type,

    output  [3:0]   aluop,
    output  [0:0]   alusrc,
    output  [1:0]   regsel,
    output  [0:0]   regwrite,
    output  [0:0]   gpio_we    
);

//migjt get moved to CPU module
instruction_decode decoder (
    .funct7     (funct7),
    .rs1        (rs1),
    .rs2        (rs2),
    .rd         (rd),
    .funct3     (funct3),
    .immI       (immI),
    .immS       (immS),
    .immU       (immU),
    .opcode     (opcode)
    .inst_type  (inst_type)
)

always_comb begin 
    assign regwrite = 1'b1; //except for csrrw HEX
    assign gpio_we = 1'b0; //except for csrrw HEX

    //add
    if ((inst_type == 2'b00) && (funct7 == 7'h0) && (funct3 == 3'b0) && ((immI === 12'bX)|| (immS === 12'bX)|| (immU=== 12'bX)) && (opcode == 7'h33)) begin
        assign aluop = 4'b0011;
        assign alusrc = 1'b0;
        assign regsel = 2'b10;

    //sub 
    else if ((inst_type == 2'b00) && (funct7 == 7'h20) && (funct3 == 3'b0) && ((immI === 12'bX)|| (immS === 12'bX)|| (immU=== 12'bX)) && (opcode == 7'h33)) begin
        assign aluop = 4'b0011;
        assign alusrc = 1'b0;
        assign regsel = 2'b10;
