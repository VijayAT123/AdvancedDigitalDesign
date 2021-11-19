

module cpu (
    input   logic   [0: 0]  clk,
    input   logic   [0: 0]  reset,
    input   logic   [31:0]  gpio_in,  //switches; upper 14 bits should be 0
    output  logic   [31:0]  gpio_out
);


////////CPU////////

logic   [11:0]  prog_counter_F; //12 bit wide to match #rows in instruction_mem
logic   [11:0]  prog_counter_EX;
logic   [2: 0]  inst_type;
logic   [31:0]  instruction_EX;
logic   [31:0]  instruction_mem [63:0]; //4096 x 32
logic   [4: 0]  regdest_WB;
logic   [31:0]  writedata_WB;
logic   [31:0]  gpio_in_WB;

///////DECODER//////
logic   [6: 0]  funct7_EX;
logic   [4: 0]  rs1_EX;
logic   [4: 0]  rs2_EX;
logic   [4: 0]  rd_EX;
logic   [2: 0]  funct3_EX;
logic   [11:0]  imm12_EX;
logic   [19:0]  imm20_EX;
logic   [19:0]  imm20_WB;
logic   [6: 0]  opcode_EX;
logic   [11:0]  csr;
logic   [12:0]  offsetB_EX;
logic   [31:0]  branch_addr_EX;
logic   [31:0]  jal_addr_EX,  //TODO determine width
logic   [31:0]  jalr_addr_EX, //TODO determine width


///////CONTROL UNIT//////
logic   [3: 0]   aluop;
logic   [0: 0]   alusrc_EX;
logic   [1: 0]   regsel_EX;
logic   [1: 0]   regsel_WB;
logic   [0: 0]   regwrite_EX;
logic   [0: 0]   gpio_we; 
logic            stall_EX;  //TODO determine width
logic            stall_F;   //TODO determine width
logic   [2: 0]    pc_src_EX;


///////REGISTER///////
logic   [0: 0]   we;
logic   [31:0]   readdata1_EX;
logic   [31:0]   readdata2_EX;


///////ALU///////
logic   [31:0]   a_EX;
logic   [31:0]   b_EX;
logic	[31:0]	 r_EX;
logic	[31:0]	 r_WB;
assign  a_EX =   readdata1_EX;



instruction_decode decoder (
    .inst           (instruction_EX),
    .prog_counter   (prog_counter_EX),
    .funct7         (funct7_EX),
    .rs1            (rs1_EX),
    .rs2            (rs2_EX),
    .rd             (rd_EX),
    .csr            (csr),
    .funct3         (funct3_EX),
    .immI           (imm12_EX),
    .immU           (imm20_EX),
    .opcode         (opcode_EX),
    .offsetB        (offsetB_EX),
    .branch_addr    (branch_addr_EX),
    .jal_addr       (jal_addr_EX),
    .jalr_addr      (jal_addr_EX),
    .inst_type      (inst_type)
);

control_unit cu (
    .funct7     (funct7_EX),
    .funct3     (funct3_EX),
    .immI       (imm12_EX),
    .immU       (imm20_EX),
    .stall_EX   (stall_EX),
    .stall_F    (stall_F),
    .inst_type  (inst_type),
    .aluop      (aluop),
    .alusrc     (alusrc_EX),
    .regsel     (regsel_EX),
    .regwrite   (regwrite_EX),
    .gpio_we    (gpio_we),
    .pc_src     (pc_src_EX)
);

regfile register (
	.clk        (clk),
	.rst        (reset),        /* reset */
	.we         (we),           /* write enable */
	.readaddr1  (rs1_EX),       /* read address 1 */
	.readaddr2  (rs2_EX),		/* read address 2 */
	.writeaddr  (regdest_WB),	/* write address */
	.writedata  (writedata_WB),
	.readdata1  (readdata1_EX),
	.readdata2  (readdata2_EX)
);

alu alu (
    .A          (a_EX),
	.B          (b_EX),
	.op         (aluop),
	.R          (r_EX)
);

initial begin
    $readmemh("bin2dec.txt", instruction_mem); //readmemh always in initial
end

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        instruction_EX <= 32'b0;
        prog_counter_F <= 32'b0;
    end
    else begin
        instruction_EX <= instruction_mem[prog_counter_F];
        prog_counter_F <= prog_counter_F + 1'b1;
    end
end

//TODO make sure correct
//PC MUX with pc_src_EX as selector
always_comb begin
    if(pc_src_EX == 000)
        //TODO PC_F or PC_EX
    else if (pc_src_EX == 001)
        prog_counter_EX = branch_addr_EX;
    else if (pc_src_EX == 010)
        prog_counter_EX = jal_addr_EX;
    else if (pc_src_EX == 011)
        prog_counter_EX = jalr_addr_EX;
    else
    
        prog_counter_EX = 1'b0;
end


//writedata MUX
always_comb begin
    if (regsel_WB == 2'b00)
        writedata_WB <= gpio_in_WB;
    else if(regsel_WB == 2'b01)
        writedata_WB <= {imm20_WB, 12'b0}; //cat 12 0s to make 32 bits in length
    else if(regsel_WB == 2'b10)
        writedata_WB <= r_WB;
    else 
        writedata_WB <= 1'b0;
end

//rs2 MUX
always_comb 
    b_EX = alusrc_EX?{{20{imm12_EX[11]}}, imm12_EX}:readdata2_EX; //sign extension; add 20 leading bits (bit 31 is sign bit)

//regsel register 
always_ff @ (posedge clk)
    regsel_WB <= regsel_EX;

//gpio_out register w enable
always_ff @ (posedge clk) 
    if (gpio_we) gpio_out <= readdata1_EX;

//gpio_in register
always_ff @ (posedge clk) begin
    gpio_in_WB <= gpio_in;
end

//regwrite register
always_ff @ (posedge clk) begin
    we <= regwrite_EX;
end

//imm20 register
always_ff @ (posedge clk) begin
    imm20_WB <= imm20_EX;
end

//r_ex -> r_wb register
always_ff @ (posedge clk) begin
    r_WB <= r_EX;
end

//regdest_wb register
always_ff @ (posedge clk) begin
    regdest_WB <= rd_EX; 
end

//stall_EX <= stall_F register
always @ (posedge clk) begin
    stall_EX <= stall_F;
end

endmodule
