module SingleRisc (
input clk,rst
output reg [31:0] data_out
);
//=========== signals decleration ==================
wire        branch_d, jump_d,  memWrite_d, ALUSrc_d, RegWrite_d, branch_neq , zero;
wire [1:0]  immSrc_d, resultSrc_d, 
wire [2:0]  ALUControl_d;
wire [2:0]  ALU_ctrl;
wire [31:0] pc, pc_4, instruction, RD1, RD2, WD3, source2, imm_out;
wire [31:0] ALU_out,mem_out,target_pc;

//=========== components decleration ===============
assign target_pc = imm_out + pc;  
assign data_out  = WD3;
assign branch_eq = branch_e & zero;
assign branch2   = branch_neq_e & (~ zero);
assign PCSrc     = jump_e | branch_eq | branch2;
//=====> pc_logic needs revising !!!!!!!!
program_counter pr_counter (
  .clk(clk),
  .rst(rst),
  .pc_src(PCSrc),
  .pc_target(target_pc),
  .pc(pc),
  .pc_4(pc_4)   
  );
instr_memory instruction_mem (
.pc(pc),
.instr(instruction)
);
/////////////////////////////////////////////////////////////////
//// CONTROL LOGIC PIPELINEING
/////////////////////////////////////////////////////////////////
control_unit ctrl_unit (
  .branch_neq(branch_neq),
  .branch(branch_d),
  .jump(jump_d),
  .memWrite(memWrite_d),
  .ALUSrc(ALUSrc_d),
  .RegWrite(RegWrite_d),
  .immSrc(immSrc_d),
  .resultSrc(resultSrc_d),
  .ALUControl(ALUControl_d),
  .op(instruction[6:0]),
  .funct3(instruction[14:12])
);
//=============> EXCUTE STAGE 
wire        branch_e, jump_e,  memWrite_e, ALUSrc_e, RegWrite_e, branch_neq_e;
wire [1:0]  immSrc_e,resultSrc_e, 
wire [2:0]  ALUControl_e;
control_register control_e (
  .clk(clk),
  .rst(rst),
  .reg_Write_in(RegWrite_d),
  .mem_write_in(memWrite_d),
  .jump_in(jump_d),
  .branch_in(branch_d),
  .ALU_src_in(ALUSrc_d),
  .result_source_in(resultSrc_d),
  .imm_src_in(immSrc_d),
  .ALU_control_in(ALUControl_d),
  .reg_Write_out(RegWrite_e),
  .mem_write_out(memWrite_e),
  .jump_out(jump_e),
  .branch_out(branch_e),
  .ALU_src_out(ALUSrc_e),
  .result_source_out(resultSrc_e),
  .imm_src_out(immSrc_e),
  .ALU_control_out(ALUControl_e),
  .branch_neq_out(branch_neq_e)
);

//=============> MEMORY STAGE
wire        branch_m, jump_m,  memWrite_m, ALUSrc_m, RegWrite_m;
wire [1:0]  immSrc_m,resultSrc_m,
wire [2:0]  ALUControl_m;
control_register control_m (
  .clk(clk),
  .rst(rst),
  .reg_Write_in(RegWrite_e),
  .mem_write_in(memWrite_e),
  .jump_in(jump_e),
  .branch_in(branch_e),
  .ALU_src_in(ALUSrc_e),
  .result_source_in(resultSrc_e),
  .imm_src_in(immSrc_e),
  .ALU_control_in(ALUControl_e),
  .reg_Write_out(RegWrite_m),
  .mem_write_out(memWrite_m),
  .jump_out(jump_m),
  .branch_out(branch_m),
  .ALU_src_out(ALUSrc_m),
  .result_source_out(resultSrc_m),
  .imm_src_out(immSrc_m),
  .ALU_control_out(ALUControl_m)
);
// =====================> WRITE BACK STAGE
wire        branch_w, jump_w,  memWrite_w, ALUSrc_w, RegWrite_w;
wire [1:0]  immSrc_w,resultSrc_w,
wire [2:0]  ALUControl_w;
control_register control_w (
  .clk(clk),
  .rst(rst),
  .reg_Write_in(RegWrite_m),
  .mem_write_in(memWrite_m),
  .jump_in(jump_m),
  .branch_in(branch_m),
  .ALU_src_in(ALUSrc_m),
  .result_source_in(resultSrc_m),
  .imm_src_in(immSrc_m),
  .ALU_control_in(ALUControl_m),
  .reg_Write_out(RegWrite_w),
  .mem_write_out(memWrite_w),
  .jump_out(jump_w),
  .branch_out(branch_w),
  .ALU_src_out(ALUSrc_w),
  .result_source_out(resultSrc_w),
  .imm_src_out(immSrc_w),
  .ALU_control_out(ALUControl_w)
);
//////////////////////////////////////////////////////////////////////////////

register_file reg_file(
  .clk(clk),
  .WE3(RegWrite_w),
  .A1(instruction[19:15]),
  .A2(instruction[24:20]),
  .A3(instruction[11:7]),
  .RD1(RD1),
  .RD2(RD2),
  .WD3(WD3)
);

mux_2x1 ALUSrc_mux (
  .sel(ALUSrc_e),
  .in0(RD2),
  .in1(imm_out),
  .out(source2)
);

ALU_decoder ALU_decoder(
  .funct3(instruction[14:12]),
  .ALUop(ALUControl_e),
  .funct7_5(instruction[30]),
  .ALU_ctrl(ALU_ctrl)
);


imm_ext extend (
.instr(instruction),
.immediate(imm_out),
.immSrc(immSrc_d)
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
  .WE(memWrite_m),
  .A(ALU_out),
  .WD(RD2),
  .RD(mem_out)
);

mux_3x1 data_mux (
.sel(resultSrc_w),
.in0(ALU_out),
.in1(mem_out),
.in2(pc_4),
.out(WD3)
);

endmodule