`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2023 06:16:30 PM
// Design Name: 
// Module Name: four_digit_seven_seg
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


module four_digit_seven_seg(
   input clr, clk,
   input wire [3:0] dig1,
   input wire [3:0] dig2,
   input wire [3:0] dig3,
   input wire [3:0] dig4,
   output reg [3:0] AN,
   output reg [6:0] CA
    );
    wire [6:0] CA = 0;
    wire [3:0] AN = 0;
    wire clk_en = 0;
    wire [1:0] S;
    reg [3:0] x = 0;
    clk_enable c_en(clk,clr,clk_en);
    anode_driver anode(clk_en,clk,clr,AN,S);
    hex2sevseg sevseg(x,CA);
    always @(*)
        case (S)
            0: x <= dig1;
            1: x <= dig2;
            2: x <= dig3;
            3: x <= dig4;
        endcase
endmodule
