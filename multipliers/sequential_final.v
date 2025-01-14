

module sequential_final (
input clk,
input rst,
input [31 : 0] in1,
input [31 : 0] in2,
output [63 : 0] OUT
);
wire [31 : 0]A;
wire [31 : 0]B;
wire [63 : 0]product;

Registers operand1_reg (clk, rst, in1, A);
Registers operand2_reg (clk,rst, in2, B);

sequential_multipier B1 ( A, B, product);

Registers_2 output_reg (clk,rst, product, OUT);

endmodule
