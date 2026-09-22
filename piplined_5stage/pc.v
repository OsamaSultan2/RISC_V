module program_counter (
  input clk , rst, pc_src,enable,
  input [31:0] pc_target,
  output reg [31:0] pc,
  output [31:0] pc_4
);
wire [31:0] branch_pc, pc_next;
// ========= PC register ==================
always @(posedge clk, posedge rst) begin
  if (rst) begin
    pc <= 0;
  end
  else if (enable) begin
    pc <= pc_next;
  end
end
assign pc_4 = pc + 4 ;
//====> branching mux
mux_2x1 branch_mux (.sel(pc_src),.in0(pc_4),.in1(pc_target),.out(pc_next));
//====> jumping  mux

endmodule