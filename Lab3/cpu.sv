module cpu ();
//todo regsel_EX MUX -> output into regsel_WB
//todo GPIO register
//todo imm20 register
//todo r_ex register -> output into r_wb
//todo rd register -> output into regdest_WB



///////DECODER//////
logic   [6: 0]  funct7_EX
logic   [4: 0]  rs1_EX;
logic   [4: 0]  rs2_EX;
logic   [4: 0]  rd_EX;
logic   [2: 0]  funct3_EX;
logic   [11:0]  imm12_EX;
assign  imm12_EX = {20{inst[31], imm12_EX}; //sign extension; add 20 leading bits (bit 31 is sign bit)
logic   [19:0]  imm20_EX;
assign  imm20_EX = {imm20_EX, 12'b0};
logic   [6: 0]  opcode_EX;

///////CONTROL UNIT//////
logic   [3: 0]   aluop;
logic   [0: 0]   alusrc_EX;
logic   [1: 0]   regsel_EX;
logic   [1: 0]   regsel_WB;
logic   [0: 0]   regwrite_EX;
logic   [0: 0]   we;
logic   [0: 0]   gpio_we; 
logic   [32:0]   gpio_out;

///////ALU///////
logic   [31:0]   a_EX;
logic   [31:0]   b_EX;
assign  a_EX =   readdata1_EX;

///////REGISTER///////
logic   [31:0]   readdata1_EX;
logic   [31:0]   readdata2_EX;


////////CPU////////
logic   [0: 0]  clk;
logic   [0: 0]  reset;
reg     [11:0]  prog_counter_fetch; //12 bit wide to match #rows in instruction_mem
logic   [31:0]  instruction_mem [4095:0]; //4096 x 32
logic   [2: 0]  inst_type;
logic   [31:0]  instruction_EX;



instruction_decode decoder (
    .inst       (instruction_EX),
    .funct7     (funct7_EX),
    .rs1        (rs1_EX),
    .rs2        (rs2_EX),
    .rd         (rd_EX),
    .funct3     (funct3_EX),
    .immI       (imm12_EX),
    .immS       (imm12_EX),
    .immU       (imm20_EX),
    .opcode     (opcode_EX),
    .inst_type  (inst_type)
);

control_unit cu (
    .funct7     (funct7_EX),
    .rs1        (rs1_EX),
    .rs2        (rs2_EX),
    .rd         (rd_EX),
    .funct3     (funct3_EX),
    .immI       (imm12_EX),
    .immS       (imm12_EX),
    .immU       (imm20_EX),
    .opcode     (opcode_EX),
    .inst_type  (inst_type),

    .aluop      (aluop),
    .alusrc     (alusrc_EX),
    .regsel     (regsel_EX),
    .regwrit    (regwrite_EX),
    .gpio_we    (gpio_we)
);

regfile register (
    .clk        (clk);
    .rst        (reset),        /* reset */
	.we         (we),           /* write enable */
	.readaddr1  (rs1_EX),       /* read address 1 */
	.readaddr2  (rs2_EX),		/* read address 2 */
	.writeaddr  (rd_EX),		/* write address */
	.writedata  (),
    .readdata1  (readdata1_EX),
    .readdata2  (readdata2_EX)
)

alu alu (
    .A          (a_EX),
	.B          (b_EX),
	.op         (opcode_EX),
	.R          (r_EX),
	output logic zero
)

initial 
    $readmemh("hexcode.txt", instruction_mem); //readmemh always in initial

always_ff @(posedge clk) begin
    if (rst)
        prog_counter <= 32'b0;
    else
        instruction_EX <= instruction_mem[prog_counter];
        prog_counter_fetch <= prog_counter_fetch + 12'b1;
end

//regsel MUX 
always_ff @(posedge clk) begin
    regsel_WB <= regsel_EX;

    if (regsel_WB == 2'b00)
        writedata <= //todo GPIO_in register
    else if(regsel_WB == 2'b01)
        writedata <= 
end

//rs2 MUX
always_comb begin 
    b = alusrc_EX?imm12_EX:readdata2_EX;
end 

//GPIO_in register
always_ff @ (posedge clk)
    gpioin

//GPIO MUX
always_comb begin
    gpio_out = gpio_we?//todo what is output when enable is off?
end

//regwrite register
always_ff @ (posedge clk)
    we <= regwrite_EX;
endmodule

//imm20 register
always_ff @ (posedge clk) begin
    