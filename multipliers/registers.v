module Registers  (
    input clk,
    input rst,
    input [31:0] in,
    output reg [31:0]  out
);
  
always @(posedge clk )
begin

    if(rst == 1'b1)
    begin
        out=0;
    end
    else 
    begin
        out=in;
    end
end
endmodule