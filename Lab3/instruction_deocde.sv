module instruction_decode (
    input [31:0] inst, 
    
    //still output funct7, imm, etc. and later choose to use field based on instruction type
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [2:0] funct3,

    output inst_type) {

    assign opcode = inst [6:0];

    always_comb begin
        if (opcode == 0b0110011) 
            inst_type = "R";
}