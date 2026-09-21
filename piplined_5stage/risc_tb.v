module RiscV_tb ();
reg clk,rst;
integer i;
//============= clock generation ===============
initial begin
  clk=0;
  forever begin
    #5 clk= ~clk;
  end
end
//============= dut init. ======================
RISCV_pipelined dut (.clk(clk), .rst(rst));
//==============================================
initial begin
  $readmemh("mem.dat", dut.instruction_mem.mem);
  rst=1;
  #100;
  rst=0;
  #600;
  $stop;
end
endmodule