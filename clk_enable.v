`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2023 04:28:45 PM
// Design Name: 
// Module Name: clk_enable
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
