module SingleRisc (
input clk,rst
output reg [31:0] data_out
);
//=========== signals decleration ==================
wire branch, jump,  memWrite, ALUSrc, RegWrite, zero;
wire [1:0] immSrc,resultSrc, ALUControl;
wire [2:0] ALU_ctrl;
wire [31:0] pc, pc_4, instruction, RD1, RD2, WD3, source2, imm_out;
wire [31:0] ALU_out,mem_out,Baddr,Jaddr;

//=========== components decleration ===============
assign Baddr = imm_out + pc; 
assign Jaddr = imm_out + pc; 
assign data_out = WD3;
program_counter pr_counter (
  .clk(clk),
  .rst(rst),
  .branch(branch),
  .jump(jump),
  .Jaddr(Jaddr),
  .Baddr(Baddr),
  .pc(pc),
  .pc_4(pc_4)   
  );

instr_memory instruction_mem (
.pc(pc),
.instr(instruction)
);


control_unit ctrl_unit (
  .zero(zero),
  .branch(branch),
  .jump(jump),
  .memWrite(memWrite),
  .ALUSrc(ALUSrc),
  .RegWrite(RegWrite),
  .immSrc(immSrc),
  .resultSrc(resultSrc),
  .ALUControl(ALUControl),
  .op(instruction[6:0]),
  .funct3(instruction[14:12])
);

register_file reg_file(
  .clk(clk),
  .WE3(RegWrite),
  .A1(instruction[19:15]),
  .A2(instruction[24:20]),
  .A3(instruction[11:7]),
  .RD1(RD1),
  .RD2(RD2),
  .WD3(WD3)
);

mux_2x1 ALUSrc_mux (
  .sel(ALUSrc),
  .in0(RD2),
  .in1(imm_out),
  .out(source2)
);

ALU_decoder ALU_decoder(
  .funct3(instruction[14:12]),
  .ALUop(ALUControl),
  .funct7_5(instruction[30]),
  .ALU_ctrl(ALU_ctrl)
);


imm_ext extend (
.instr(instruction),
.immediate(imm_out),
.immSrc(immSrc)
);

ALU ALU (
.rs1(RD1),
.rs2(source2),
.zero(zero),
.result(ALU_out),
.op(ALU_ctrl)
);

data_mem data_memory (
  .clk(clk),
  .WE(memWrite),
  .A(ALU_out),
  .WD(RD2),
  .RD(mem_out)
);

mux_3x1 data_mux (
.sel(resultSrc),
.in0(ALU_out),
.in1(mem_out),
.in2(pc_4),
.out(WD3)
);

endmodule