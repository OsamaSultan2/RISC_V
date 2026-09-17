module mux_3x1 #(
  parameter WIDTH = 32
) ( 
  input [1:0] sel,
  input  [WIDTH-1 : 0] in0,in1,in2,
  output [WIDTH-1 : 0] out
);
assign out = (sel =='b0)? in0:(sel=='b01)?in1:in2;
endmodule