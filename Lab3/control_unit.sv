//all combinational

module control_unit (
    input   [4:0]   rs1,
    input   [4:0]   rs2,
    input   [4:0]   rd,
    input   [2:0]   funct3,
    input   [11:0]  immI,
    input   [11:0]  immS,
    input   [19:0]  immU,
    input   [2:0]   inst_type,

    output  [0:0]   regwrite,
    output  [0:0]   regsel,
    output  [0:0]   aluop,
    output  [0:0]   gpio_we    
    
);