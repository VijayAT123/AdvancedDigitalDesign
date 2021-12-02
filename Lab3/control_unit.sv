//all combinational

//TODO determine branch conditions
module control_unit (
    input   logic	[6:0]   funct7,
    input	logic	[2:0]   funct3,
    input   logic	[11:0]  immI,
    input  	logic	[19:0]  immU,
    input   logic           stall_EX,
    input  	logic	[2:0]   inst_type,
    input   logic   [31:0]  aluR,
    input   logic           zero,

    output 	logic	[3:0]   aluop,
    output	logic	[0:0]   alusrc,
    output 	logic	[1:0]   regsel,
    output 	logic	[0:0]   regwrite,
    output 	logic	[0:0]   gpio_we,
    output  logic   [2:0]   pc_src,
    output  logic           stall_F
);

always_comb begin

    if (stall_EX) begin
        gpio_we = 0;
        regwrite = 0;
        stall_F = 0;
    end

    else begin
        regwrite = 1'b1;     //except for csrrw HEX
        gpio_we = 1'b0;      //except for csrrw HEX
        regsel = 2'b10;      //exceot fir csrrw, lui, JAL, and JALR

        //R-Type insts
        if(inst_type == 3'b000) begin 
            alusrc = 1'b0;
            pc_src = 3'b000;
            stall_F = 0;
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
                aluop = 4'b1110;
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
                aluop = 4'b1001;
            //sra
            else if ((funct7 == 7'h20) && (funct3 == 3'b101))
                aluop = 4'b1010;
            else
                aluop = 4'b1101;
        end

        //csrrw
        else if (inst_type == 3'b011) begin
            alusrc = 1'b0;
            aluop = 4'b1101;
            pc_src = 3'b000;
            stall_F = 0;
            if(immI == 12'hf00) begin //switches
                regsel = 2'b00;
            end
            else if (immI == 12'hf02) begin
                gpio_we = 1'b1;
                regsel = 2'b00;
                regwrite = 1'b0;
            end
            else
                aluop = 4'b1101;
        end

        //I-type insts
        else if (inst_type == 3'b001) begin
            alusrc = 1'b1;
            pc_src = 3'b000;
           // stall_F = 0;
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
            //srai
            else if (funct3 == 3'b101 && funct7 == 7'b0100000)
                aluop = 4'b1011;
            //srli
            else if (funct3 == 3'b101 && funct7 == 7'b0000000)
                aluop = 4'b1001;
            else
                aluop = 4'b1101;
        end

        //U-type insts
        else if (inst_type == 3'b010) begin
            alusrc = 1'b0;
            aluop = 4'b1101;
            regsel = 2'b01;
            pc_src = 3'b000;
            stall_F = 0;
            //lui - bypasses ALU
        end

        //B-type insts
        else if (inst_type == 3'b100) begin
            //TODO alusrc
            //TODO regsel
            //TODO regwrite
            //pc_src = 3'b001;
            //beq
            stall_F = 0;
            if (funct3 == 3'b000) begin
                aluop = 4'b0100;
                if(aluR == 32'b0) begin
                    stall_F = 1;
                    pc_src = 3'b001;
                end
            end
            //bne
            else if (funct3 == 3'b001) begin
                aluop = 4'b0100; 
                if(aluR != 0) begin
                     stall_F = 1;
                     pc_src = 3'b001;
                end
            end
            //bge
            else if (funct3 == 3'b101) begin
                aluop = 4'b1100;
                stall_F = 1;
                if(aluR == 32'b0) begin
                    stall_F = 1;
                    pc_src = 3'b001;
                end
            end
            //bgeu
            else if (funct3 == 3'b111) begin
                aluop = 4'b1110;
                stall_F = 1;
                if(aluR == 32'b0) begin
                    stall_F = 1;
                    pc_src = 3'b001;
                end
            end
            //blt
            else if (funct3 == 3'b100) begin
                aluop = 4'b1100;
                stall_F = 1;
                if(aluR == 32'b1 ) begin
                    stall_F = 1;
                    pc_src = 3'b001;
                end
            end
            //bltu
            else if (funct3 == 3'b110) begin
                aluop = 4'b1110;
                stall_F = 1;
                if(aluR == 32'b1) begin
                    stall_F = 1;
                    pc_src = 3'b001;
                end
            end
            
            else
                aluop = 4'b1101;
        end

        //JAL
        else if (inst_type == 3'b101) begin
            pc_src = 2'b10;
            //TODO does regsel need to select for JAL 
            regsel = 2'b11;
            stall_F = 1;
        end

        //JALR
        else if (inst_type == 3'b110) begin
            pc_src = 2'b11;
            //TODO figure out writing PC_F to x1 
            regsel = 2'b11;
            stall_F = 1;
        end

        else begin
            aluop = 4'b1101;
            alusrc = 1'b0;
        end
    end
end

endmodule
