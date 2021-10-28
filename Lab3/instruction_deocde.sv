module instruction_decode ( 
    input [31:0] inst, 
    
    //still output funct7, imm, etc. and later choose to use field based on instruction type
    output  [6:0]   funct7,
    output  [4:0]   rs1,
    output  [4:0]   rs2,
    output  [4:0]   rd,
    output  [2:0]   funct3,
    output  [11:0]  immI,
    output  [19:0]  immU,
    output  [6:0]   opcode,

    output  [2:0]   inst_type
);

    assign opcode = inst [6:0];

    //R-type
    assign funct7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign funct3 = inst[14:12];
    assign rd = [11:7];

    //I-type
    assign immI = {inst[31:25], inst[11:7]}; //sign extension to 32 bits with leqading inst bit(bit 31) as sign bit

    //U-type
    assign immU = {inst[31:12]}; 

    always_comb begin
        if (opcode == 7'b0110011) 
            inst_type = 2'b00; //R-type inst is 00
        else if (opcode == 7'b0010011)
            inst_type = 2'b01; //I-type inst is 01
        else if (opcode == 7'b0110111)
            inst_type = 2'b10; //U-type inst is 10
        else if (opcode == 7'b1110011)
            inst_type = 2'b11; //CSRRW inst is 11
    end

endmodule
