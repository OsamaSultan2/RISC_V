module instr_memory (
  input [31:0] pc,
  output reg [31:0] instr
);
  reg [7:0] mem [1023 :0];
  always @(*) begin
    instr = {mem[pc] ,mem[pc+1] ,mem[pc+2]  ,mem[pc+3] };
  end
endmodule