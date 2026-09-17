module register 
#(
  parameter WIDTH = 1;
)(
  input clk, rst,
  input [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 0;
    else
      q <= d;
  end
endmodule

module control_register(
  input        clk, rst,
  input        reg_Write_in, mem_write_in, jump_in,
  input        branch_in, ALU_src_in,branch_neq_in,
  input  [1:0] result_source_in,
  input  [1:0] imm_src_in,
  input  [2:0] ALU_control_in,
  output       reg_Write_out, mem_write_out, jump_out,
  output       branch_out, ALU_src_out,branch_neq_out,
  output [1:0] result_source_out,
  output [1:0] imm_src_out,
  output [2:0] ALU_control_out
);
always @(posedge clk or posedge rst) begin
  if (rst) begin
    reg_Write_out <= 0;
    mem_write_out <= 0;
    jump_out <= 0;
    branch_out <= 0;
    ALU_src_out <= 0;
    result_source_out <= 0;
    imm_src_out <= 0;
    ALU_control_out <= 0;
    branch_neq_out <= 0;
  end
  else begin
    reg_Write_out <= reg_Write_in;
    mem_write_out <= mem_write_in;
    jump_out <= jump_in;
    branch_out <= branch_in;
    ALU_src_out <= ALU_src_in;
    result_source_out <= result_source_in;
    imm_src_out <= imm_src_in;
    ALU_control_out <= ALU_control_in;
    branch_neq_out <= branch_neq_in;
  end
end
endmodule