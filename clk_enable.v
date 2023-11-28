`timescale 1ns / 1ps

//Clock enable is used to send out pulses less frequently, after a certain number of clock pulses

module clk_enable(
input clk,
input clr,
output reg clk_en
    );
integer count = 0;    
always @(posedge clk)begin
if(count == 99999999) begin
count <= 0;
clk_en <= 1;
end else begin
count <= count + 1;
clk_en <= 0;
end
end
endmodule
