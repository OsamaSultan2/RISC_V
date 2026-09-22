module register_file (
  input              clk, WE3,rst,
  input       [4:0]  A1 , A2, A3,
  input       [31:0] WD3,
  output  reg [31:0] RD1, RD2
);
  reg [31:0] reg_file [31:0];
      integer i;
      initial begin
        for (i=0 ; i < 32 ; i=i+1 ) begin
          reg_file[i]=0;
      end
      end
  always @(negedge clk) begin 
    if (WE3) begin
      reg_file[A3] <= WD3;
    end
  end
  always @(posedge clk or posedge rst ) begin
    if (rst) begin
      RD1 <= 0;
      RD2 <= 0;
    end
    else begin
      RD1 <= reg_file[A1];
      RD2 <= reg_file[A2];
    end
  end
endmodule