module ALU (
  input [31:0] rs1, rs2,
  input [2:0] op,
  output zero, 
  output reg [31:0] result
);
  always @(*) begin
    case (op)
      3'b000: result = rs1 + rs2;
      3'b001: result = rs1 - rs2;
      3'b010: result = rs1 & rs2;
      3'b011: result = rs1 | rs2;
      3'b100: result = rs1 ^ rs2;
      3'b101: result = (rs1 < rs2)? 32'b01 : 32'b0;
      3'b110: result = rs1 << rs2;
      3'b111: result = rs1 >> rs2; 
    endcase
  end
  assign zero = ~(|result);
endmodule