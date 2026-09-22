module RISCV_pipelined (
input clk,rst,
output [31:0] data_out
);
//=========== signals decleration ==================
wire        branch_d, jump_d,  memWrite_d, ALUSrc_d, RegWrite_d, branch_eq, branch_neq , zero;
wire        branch_w, jump_w,  memWrite_w, ALUSrc_w, RegWrite_w;            
wire        stallD,   stallF,  flushE, flushD; 
wire        branch_m, jump_m,  memWrite_m, ALUSrc_m, RegWrite_m;
wire        PCSrc;    
wire [1:0]  immSrc_m,resultSrc_m;
wire [1:0]  ALUControl_m;
wire [1:0]  immSrc_d, resultSrc_d;
wire [1:0]  ALUControl_d;
wire [1:0]  forwardAE, forwardBE;
wire [2:0]  ALU_ctrl;
wire [4:0]  RdM;
wire [31:0] RD1, RD2;
wire [31:0] pc, pc_4, instruction, WD3, source2, imm_out;
wire [31:0] ALUResultM, WriteDataM, PCplus4M;
wire [31:0] source1, source2_in;
wire [31:0] ALU_out,mem_out,target_pc;
wire [31:0] ALUResultW, ReadDataW, PCplus4W;
wire [4:0]  RdW;


//=========== components decleration ===============
assign data_out  = WD3;
//TODO: pc_logic needs revising !!!!!!!!
program_counter pr_counter (
  .clk(clk),
  .rst(rst),
  .enable(~stallF),
  .pc_src(PCSrc),
  .pc_target(target_pc),
  .pc(pc),
  .pc_4(pc_4)   
  );
instr_memory instruction_mem (
.pc(pc),
.instr(instruction)
);
//==========================================
// DECODE STAGE
//==========================================
  wire [31:0] instrD, PCD, PCplus4D;
  register #(.WIDTH(32)) instrD_reg (
    .clk(clk),
    .rst(rst),
    .d(instruction),
    .q(instrD),
    .enable(~stallD),
    .clr(flushD)
  );
  
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
    .op(instrD[6:0]),
    .funct3(instrD[14:12])
  );

  register #(.WIDTH(32)) PCD_reg (
    .clk(clk),
    .rst(rst),
    .d(pc),
    .q(PCD),
    .enable(~stallD),
    .clr(flushD)
  );

  register #(.WIDTH(32)) PCplus4D_reg (
    .clk(clk),
    .rst(rst),
    .d(pc_4),
    .q(PCplus4D),
    .enable(~stallD),
    .clr(flushD)
  );
   
  register_file reg_file(
    .clk(clk),
    .rst(rst),
    .WE3(RegWrite_w),
    .A1(instrD[19:15]),
    .A2(instrD[24:20]),
    .A3(RdW),
    .RD1(RD1),
    .RD2(RD2),
    .WD3(WD3)
  );

  
  imm_ext extend (
    .instr(instrD),
    .immediate(imm_out),
    .immSrc(immSrc_d)
  );
  
//==========================================
// EXECUTE STAGE
//==========================================
  wire        branch_e, jump_e,  memWrite_e, ALUSrc_e, RegWrite_e, branch_neq_e;
  wire [1:0]  immSrc_e,resultSrc_e;
  wire [1:0]  ALUControl_e;
  wire [31:0] PCE, RD1E, RD2E, immextE, PCplus4E;
  wire [4:0]  Rs1E, Rs2E, RdE;

  control_register control_e (
    .clk(clk),
    .rst(rst),
    .reg_Write_in(RegWrite_d),
    .mem_write_in(memWrite_d),
    .jump_in(jump_d),
    .branch_in(branch_d),
    .branch_neq_in(branch_neq),
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
    .branch_neq_out(branch_neq_e),
    .enable(1),
    .clr(flushE)
  );
  
  register #(.WIDTH(32)) PCE_reg (
    .clk(clk),
    .rst(rst),
    .d(PCD),
    .q(PCE),
    .enable(1),
    .clr(flushE)
  );

  register #(.WIDTH(32)) RD1E_reg (
    .clk(clk),
    .rst(rst),
    .d(RD1),
    .q(RD1E),
    .enable(1),
    .clr(flushE)
  );
  
  register #(.WIDTH(32)) RD2E_reg (
    .clk(clk),
    .rst(rst),
    .d(RD2),
    .q(RD2E),
    .enable(1),
    .clr(flushE)
  );

  register #(.WIDTH(5)) RdE_reg (
    .clk(clk),
    .rst(rst),
    .d(instrD[11:7]),
    .q(RdE),
    .enable(1),
    .clr(flushE)
  );
  register #(.WIDTH(5)) Rs1E_reg (
    .clk(clk),
    .rst(rst),
    .d(instrD[19:15]),
    .q(Rs1E),
    .enable(1),
    .clr(flushE)
  );
  register #(.WIDTH(5)) Rs2E_reg (
    .clk(clk),
    .rst(rst),
    .d(instrD[24:20]),
    .q(Rs2E),
    .enable(1),
    .clr(flushE)
  );

  register #(.WIDTH(32)) PCplus4E_reg (
    .clk(clk),
    .rst(rst),
    .d(PCplus4D),
    .q(PCplus4E),
    .enable(1),
    .clr(flushE)
  );

  register #(.WIDTH(32)) immextE_reg (
    .clk(clk),
    .rst(rst),
    .d(imm_out),
    .q(immextE),
    .enable(1),
    .clr(flushE)
  );

  ALU_decoder ALU_decoder(
    .funct3(instrD[14:12]),
    .ALUop(ALUControl_e),
    .funct7_5(instrD[30]),
    .ALU_ctrl(ALU_ctrl)
  );
  mux_3x1 forwardA_mux (
    .sel(forwardAE),
    .in0(RD1E),
    .in1(WD3),
    .in2(ALUResultM),
    .out(source1) //todo: declare source1
  );
  mux_3x1 forwardB_mux (
    .sel(forwardBE),
    .in0(RD2E),
    .in1(WD3),
    .in2(ALUResultM),
    .out(source2_in)
  );

  ALU ALU (
    .rs1(source1),
    .rs2(source2),
    .zero(zero),
    .result(ALU_out),
    .op(ALU_ctrl)
  );

  mux_2x1 ALUSrc_mux (
    .sel(ALUSrc_e),
    .in0(source2_in),
    .in1(immextE),
    .out(source2)
  );

  assign target_pc = PCE + immextE;  
  assign branch_eq = branch_e & zero;
  assign branch2   = branch_neq_e & (~ zero);
  assign PCSrc     = jump_e | branch_eq | branch2;

//===========================================
// MEMORY STAGE
//===========================================
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
    .ALU_control_out(ALUControl_m),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) ALUResultM_reg (
    .clk(clk),
    .rst(rst),
    .d(ALU_out),
    .q(ALUResultM),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) WriteDataM_reg (
    .clk(clk),
    .rst(rst),
    .d(RD2E),
    .q(WriteDataM),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(5)) RdM_reg (
    .clk(clk),
    .rst(rst),
    .d(RdE),
    .q(RdM),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) PCplus4M_reg (
    .clk(clk),
    .rst(rst),
    .d(PCplus4E),
    .q(PCplus4M),
    .enable(1),
    .clr(0)
  );

  data_mem data_memory (
    .clk(clk),
    .WE(memWrite_m),
    .A(ALUResultM),
    .WD(WriteDataM),
    .RD(mem_out)
  );

//============================================
// WRITE BACK STAGE
//============================================
  wire [1:0]  immSrc_w,resultSrc_w;
  wire [1:0]  ALUControl_w;

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
    .ALU_control_out(ALUControl_w),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) ALUResultW_reg (
    .clk(clk),
    .rst(rst),
    .d(ALUResultM),
    .q(ALUResultW),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) ReadDataW_reg (
    .clk(clk),
    .rst(rst),
    .d(mem_out),
    .q(ReadDataW),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(5)) RdW_reg (
    .clk(clk),
    .rst(rst),
    .d(RdM),
    .q(RdW),
    .enable(1),
    .clr(0)
  );

  register #(.WIDTH(32)) PCplus4W_reg (
    .clk(clk),
    .rst(rst),
    .d(PCplus4M),
    .q(PCplus4W),
    .enable(1),
    .clr(0)
  );

  
  mux_3x1 data_mux (
    .sel(resultSrc_w),
    .in0(ALUResultW),
    .in1(ReadDataW),
    .in2(PCplus4W),
    .out(WD3)
  );

///////////////////////////////////////////////////////////////////////
/// HAZARD UNIT 
///////////////////////////////////////////////////////////////////////
  Hazard_unit hazard_u (
    .regWriteM(RegWrite_m),
    .regWriteW(RegWrite_w),
    .resultSrcE(resultSrc_e[0]),
    .PCsrcE(PCSrc),
    .Rs1D(instrD[19:15]),
    .Rs2D(instrD[24:20]),
    .Rs1E(Rs1E),
    .Rs2E(Rs2E),
    .RdE(RdE),
    .RdM(RdM),
    .RdW(RdW),
    .stallD(stallD),
    .stallF(stallF),
    .flushE(flushE),
    .flushD(flushD),
    .forwardAE(forwardAE),
    .forwardBE(forwardBE)
  );
endmodule