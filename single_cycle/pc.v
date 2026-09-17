module program_counter (
  input clk , rst, jump, branch,
  input [31:0] Jaddr,Baddr,
  output reg [31:0] pc,
  output [31:0] pc_4
);
wire [31:0] branch_pc, pc_next;
// ========= PC register ==================
always @(posedge clk, posedge rst) begin
  if (rst) begin
    pc <= 0;
  end
  else 
  pc <= pc_next;
end
assign pc_4 = pc + 4 ;
//====> branching mux
mux_2x1 branch_mux (.sel(branch),.in0(pc_4),.in1(Baddr),.out(branch_pc));
//====> jumping  mux
mux_2x1 jump_mux  (.sel(jump),.in0(branch_pc),.in1(Jaddr),.out(pc_next));
endmodule