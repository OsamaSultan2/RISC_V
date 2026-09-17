module data_mem (
  input clk,WE,
  input [31:0] A, WD,
  output reg [31:0] RD
);
  reg [31:0] mem [1023:0];
      integer i;
      initial begin
        for (i=0 ; i < 1024 ; i=i+1 ) begin
          mem[i]=0;
      end
      end
  // reading operation
  always @(*) begin
    RD = mem[A];
  end
  // writing operation (edge triggered)
  always @(posedge clk) begin 
    if (WE) 
    mem[A] <= WD;
  end
endmodule