`timescale 1ns / 1ps

//Converts a hexidecimal input to the seven segment cathodes necessary
//0 bits in output indicate which cathodes are illuminated

module hex2sevseg(
input wire [3:0] x,
output reg [6:0] ca
    );
always @(x)
    case (x)
        0: ca[6:0] <= 7'b0000001;
        1: ca[6:0] <= 7'b1001111;
        2: ca[6:0] <= 7'b0010010; 
        3: ca[6:0] <= 7'b0000110; 
        4: ca[6:0] <= 7'b1001100; 
        5: ca[6:0] <= 7'b0100100; 
        6: ca[6:0] <= 7'b0100000; 
        7: ca[6:0] <= 7'b0001111; 
        8: ca[6:0] <= 7'b0000000; 
        9: ca[6:0] <= 7'b0000100; 
        10: ca[6:0] <= 7'b0001000; 
        11: ca[6:0] <= 7'b1100000;
        12: ca[6:0] <= 7'b0110001; 
        13: ca[6:0] <= 7'b1000010; 
        14: ca[6:0] <= 7'b0110000; 
        15: ca[6:0] <= 7'b0111000; 
     endcase
endmodule
