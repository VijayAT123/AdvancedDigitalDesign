module instruction_decode ( 
    input   logic   [31:0]  inst,
    input   logic   [31:0]  prog_counter,
    
    //still output funct7, imm, etc. and later choose to use field based on instruction type
    output	logic	[6:0]   funct7,
    output	logic	[4:0]   rs1,
    output  logic	[4:0]   rs2,
    output  logic	[4:0]   rd,
    output  logic	[2:0]   funct3,
    output	logic	[11:0]  immI,
    output  logic	[19:0]  immU,
    output  logic	[6:0]   opcode,
    output  logic   [11:0]  csr,
    output  logic   [12:0]  offsetB,
    output  logic   [31:0]  branch_addr,  //TODO confirm width; PC_EX is 32 bits long
    output  logic   [31:0]  jal_addr,
    output  logic   [31:0]  jalr_addr,
    output  logic	[2:0]   inst_type
);

    assign opcode = inst [6:0];

    //R-type
    assign funct7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign funct3 = inst[14:12];
    assign rd = inst[11:7];
    assign csr = inst[31:20];

    //I-type
    assign immI = inst[31:20]; //sign extension to 32 bits with leqading inst bit(bit 31) as sign bit

    //U-type
    assign immU = {inst[31:12]};

    //B-type
    assign offsetB = {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
    assign branch_addr = prog_counter + {offsetB[12], offsetB[12:2]};


    always_comb begin
        if (opcode == 7'b0110011) 
            inst_type = 3'b000; //R-type inst is 00
        else if (opcode == 7'b0010011)
            inst_type = 3'b001; //I-type inst is 01
        else if (opcode == 7'b0110111)
            inst_type = 3'b010; //U-type inst is 10
        else if (opcode == 7'b1110011)
            inst_type = 3'b011; //CSRRW inst is 11
        else if (opcode == 7'b1100011) //B-type inst is 100
            inst_type = 3'b100;
        else
            inst_type = 3'b111;
    end

endmodule
