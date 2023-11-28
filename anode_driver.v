`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2023 04:47:06 PM
// Design Name: 
// Module Name: anode_driver
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


module anode_driver(
 input wire clk_en,
 input wire clk,
 input wire clr,
 output reg [3:0] AN,
 output reg [1:0] S
    );
    always @(posedge clk_en or posedge clr) begin
    if(clr == 1) begin
    S <= 0;
    AN[3:0] <= 4'b1110;
    end
    else begin
    S <= S + 1;
    case(S)
      0: AN[3:0] <= 4'b1110;
      1: AN[3:0] <= 4'b1101;
      2: AN[3:0] <= 4'b1011;
      3: AN[3:0] <= 4'b0111;
    endcase
    end
    end
endmodule
