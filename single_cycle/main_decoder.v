module control_unit (
  input zero,
  input [6:0] op,
  input [2:0] funct3, // can be removed ??
  output reg  branch, jump,  memWrite, ALUSrc, RegWrite,
  output reg [1:0] immSrc,resultSrc, ALUControl
);
always @(*) begin
  casex (op)
    7'b011_0011:begin  // R-TYPE Instructions controls 
      branch     =    0;
      jump       =    0;
      ALUSrc     =    0;
      RegWrite   =    1;
      memWrite   =    0;
      resultSrc  =    0;
      immSrc     =    0;
      ALUControl = 'b11;
    end


    7'b00x_0011:begin  // I-TYPE Instructions controls 
      branch     =     0;
      jump       =     0;
      ALUSrc     =     1;
      if(op[4]) begin   // immediate A/L operation
        RegWrite   =    1;
        resultSrc  =    0;
        if (!(funct3)) begin
          ALUControl=  'b00;
        end
        else
          ALUControl = 'b11;
      end     
      else begin        // lw instruction
        RegWrite   =    0; 
        resultSrc  = 'b01;
        ALUControl = 'b00;
      end
      memWrite   =     0; 
      immSrc     =     0;
    end


    7'b010_0011:begin  // S-TYPE Instructions controls 
      branch     =    0;
      jump       =    0;
      ALUSrc     =    1;
      RegWrite   =    0;
      memWrite   =    1;
      resultSrc  =    0;
      immSrc     = 'b01;
      ALUControl = 'b00;
    end
    7'b110_0011:begin  // B-TYPE Instructions controls 
      if ( (funct3[0] & (~ zero)) | ( ~ funct3[0] & zero) )   // bne / beq instruction
      branch     =     1;
      else
      branch = 0;
      jump       =    0;
      ALUSrc     =    0;
      RegWrite   =    0;
      memWrite   =    0;
      resultSrc  =    0;
      immSrc     = 'b10;
      ALUControl = 'b01;
    end
    7'b110_1111:begin  // J-TYPE Instructions controls 
      branch     =    0;
      jump       =    1;
      ALUSrc     =    0;
      RegWrite   =    1;
      resultSrc  = 'b11;
      memWrite   =    0;
      immSrc     = 'b11;
      ALUControl = 'b00;
    end
    default: begin
      branch     =    0;
      jump       =    0;
      ALUSrc     =    0;
      RegWrite   =    1;
      memWrite   =    0;
      resultSrc  =    0;
      immSrc     =    0;
      ALUControl = 'b11;
    end
  endcase
end
endmodule