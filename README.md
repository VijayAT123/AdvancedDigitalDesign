# Overview
This three-stage RISC-V CPU utilizes different components manifested as different SystemVerilog modules.  These components include an instruction decoder, a control unit, a register file, an ALU, a hex-display driver, and various registers and MUXs within the CPU module.  This CPU can execute `R`, `I`, `U`, `B`, `csrrw`, `JAL`, and `JALR` type instructions.

## Instruction Decoder
The instruction decoder takes in a 32-bit wide RISC-V instruction, which comes from the instruction memory initialized with `readmemh` in an initial begin in the CPU module. The instruction decoder outputs various instruction fields, including the instruction type (determined by opcode), funct7, registers, immediate 12 and 20, and funct3, which passed to the control unit.
## Control Unit
Determines the ALU operation, an ALU source MUX select, a register MUX select, a register write-enable, and a GPIO write-enable.  Different MUXs for the design include:
* Register-source 2 uses alusrc_EX as a selector for a sign-extended imm12 field (alusrc == 1) or readdata2 (alusrc == 0).  
* Register file’s writedata uses regsel_WB for selecting between GPIO_in, imm20, or the ALU’s result
* `regsel_WB` is the result of a register with `regsel_EX` as an input to allow for a 1-cycle delay (from execute to write-back stage)

D flip-flops/registers are used to delay values for 1 cycle for proper implementation of the 3-stage pipeline.  These include:

* `readdata1_EX` becomes gpio_out with high activation of the GPIO write-enable
* Register file’s destination register
* Register file’s write-enable
* All inputs for Register-Select MUX
* `gpio_in`
* `imm20`
* ALU’s result
* selector (`regsel`)

## CPU Top-Level
The CPU module accepts a `clock`, `reset`, and `GPIO_in` (switch values) as input and outputs `GPIO_out`, which is used by the hex-display driver to show values on the hex-displays.  The CPU instantiates an instruction decoder, control unit, register file, and ALU.  Both MUXs are also in the CPU, inside an always_comb block.  All registers are inside individual `always_ff`, positive-clock edge activated blocks.

## Testing
The testbench is a simple end-to-end tester that compares the values of the switches to the resulting `GPIO_out`/hex-displays.  Two test-cases were chosen per switch; 38 cases in total.  Each case has the most-significant switch turned on, with a random combination of proceeding switches on.  The testbench is contained in the simtop module.  There is another testbench that compares regfile’s `mem[]` values to the expected register value from RARS’s register value table at specified program counter values.  This is equivalent to “Run one step at a time” in RARS and comparing the register values table at the corresponding clock cycle.  This testbench is manifested as a combinational always block in simtop.
