`timescale 1ns / 1ps

// Simulation source to test outputs of floating point adder

module lab12_tb();
    reg clk = 0, clr = 0, go = 0;
    reg [7:0] a = 0, b = 0;
    wire done;
    wire [7:0] sum;
    
    FPA uut(clk,clr,go,a,b,done,sum);
    
    initial begin
        clr = 1;
        #10 clr = 0;
        #50 clr = 1; #10 clr = 0; a = 8'b01011010; b = 8'b00101110; go = 1; #10 go = 0;
        #200 clr = 1; #10 clr = 0; a = 8'b00111010; b = 8'b10110110; go = 1; #10 go = 0;
        #200 clr = 1; #10 clr = 0; a = 8'b10011000; b = 8'b00010011; go = 1; #10 go = 0;
        #200 clr = 1; #10 clr = 0; a = 8'b00111101; b = 8'b00110100; go = 1; #10 go = 0;
        #200 $finish;
    end
    
    always begin
        #1 clk = !clk;
    end
endmodule
