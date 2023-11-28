`timescale 1ns / 1ps

// Anode driver is used to select which part of seven segment display will be illuminated.
// Anode is incremented on clock enable. Anode is changed at rate fast enough that outputs appear to be display simultaneously.

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
