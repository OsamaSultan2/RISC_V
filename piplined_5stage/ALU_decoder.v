module ALU_decoder (
input [1:0] ALUop,
input [2:0] funct3,
input funct7_5,
output reg [2:0] ALU_ctrl
);
  always @(*) begin
    case (ALUop)
      2'b00: ALU_ctrl = 3'b000; //  addition    for lw,sw
      2'b01: ALU_ctrl = 3'b001; //  subtraction for beq
      default:begin           //  R-type operations
        case (funct3)
          3'b000: if(funct7_5)
            ALU_ctrl = 3'b001;  //  subtraction
          else
            ALU_ctrl = 3'b000;  //  addition 
          
          3'b001:  ALU_ctrl = 3'b110; // shift left logic operation  
          3'b010:  ALU_ctrl = 3'b101; // set on less than  
          3'b100:  ALU_ctrl = 3'b100; // xor operation  
          3'b101:  ALU_ctrl = 3'b111; // shift right logic operation   
          3'b110:  ALU_ctrl = 3'b011; // or operation 
          3'b111:  ALU_ctrl = 3'b010; // and operation
          default: ALU_ctrl = 3'B000;
        endcase 
      end
    endcase
  end
endmodule