//all combinational
//TODO csrrw

module control_unit (
    input   [6:0]   funct7,
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

always_comb begin 
    regwrite = 1'b1;     //except for csrrw HEX
    gpio_we = 1'b0;      //except for csrrw HEX
    regsel = 2'b10;      //exceot fir csrrw and lui
    regwrite = 1'b1;     //except for csrrw HEX
    gpio_we = 1'b0;      //except for csrrw HEX

    //R-Type insts
    if(inst_type == 2'b00) begin 
        alusrc = 1'b0;
        //add
        if ((funct7 == 7'h0) && (funct3 == 3'b000))
            aluop = 4'b0011;
        //sub 
        else if ((funct7 == 7'h20) && (funct3 == 3'b000))
            aluop = 4'b0100;
        //mul
        else if ((funct7 == 7'h1) && (funct3 == 3'b000))
            aluop = 4'b0101;
        //mulh
        else if ((funct7 == 7'h1) && (funct3 == 3'b001))
            aluop = 4'b0110;
        //mulhu
        else if ((funct7 == 7'h1) && (funct3 == 3'b011))
            aluop = 4'b0111;
        //slt
        else if ((funct7 == 7'h0) && (funct3 == 3'b010))
            aluop = 4'b1100;
        //sltu
        else if ((funct7 == 7'h0) && (funct3 == 3'b011))
            aluop = ???????; 
            //TODO correct aluop
        //and
        else if ((funct7 == 7'h0) && (funct3 == 3'b111))
            aluop = 4'b0000;
        //or
        else if ((funct7 == 7'h0) && (funct3 == 3'b110))
            aluop = 4'b0001;
        //xor
        else if ((funct7 == 7'h0) && (funct3 == 3'b100))
            aluop = 4'b0010;
        //sll
        else if ((funct7 == 7'h0) && (funct3 == 3'b001))
            aluop = 4'b1000;
        //srl
        else if ((funct7 == 7'h0) && (funct3 == 3'b101))
            aluop = 4'b1000;
        //sra
        else if ((funct7 == 7'h20) && (funct3 == 3'b101))
            aluop = 4'b1000;
    end

    //csrrw
    else if (inst_type = 2'b11 && funct3 == 3'b001)
        //TODO aluop

    //I-type insts
    else if (inst_type == 01) begin
        alusrc = 1'b1;
        //addi
        if (funct3 == 3'b000)
            aluop = 4'b0011;
        //andi
        else if (funct3 == 3'b111)
            aluop = 4'b0000;
        //ori
        else if (funct3 == 3'b110)
            aluop = 4'b0001;
        //xori
        else if (funct3 == 3'b100)
            aluop = 4'b0010;
        //slli
        else if (funct3 == 3'b001)
            aluop = 4'b1000;
             //TODO handle shamt from imm12
        //srai
        else if (funct3 == 3'b101 && funct7 == 7'b0100000)
            aluop = 4'b1010;
            //TODO handle shamt from imm12
        //srli
        else if (funct3 == 3'b101 && funct7 == 7'b0000000)
            aluop = 4'b1001;
             //TODO handle shamt from imm12
    end

    //U-type insts
    else if (inst_type == 2'b10) begin
        regsel = 2'b01;
        //lui - bypasses ALU
    end
endmodule
