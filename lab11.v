`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2023 08:23:25 PM
// Design Name: 
// Module Name: lab11
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


module bin2bcd(input [7:0] bin,output reg [11:0] bcd);
integer i;	
always @(bin) begin
    bcd=0;		 	
    for (i=0;i<8;i=i+1) begin					
        if (bcd[3:0] >= 5) bcd[3:0] = bcd[3:0] + 3;
	if (bcd[7:4] >= 5) bcd[7:4] = bcd[7:4] + 3;
	if (bcd[11:8] >= 5) bcd[11:8] = bcd[11:8] + 3;
	bcd = {bcd[11:0],bin[7-i]};			
    end
end
endmodule

module SQRTctrl (input clk , input clr , input lteflg , input go ,
    output reg ald , output reg sqld , output reg dld , output reg outld);
reg[1:0] present_state, next_state;
parameter start = 2'b00, test =2'b01, update = 2'b10, done = 2'b11;

always @(posedge clk or posedge clr) begin
    if (clr == 1)
        present_state <= start;
    else
        present_state <= next_state;
end
always @(*) begin
    case(present_state)
        start:
            if(go == 1)
                next_state = test;
            else
                next_state = start;
        test:
        if(lteflg == 1)
            next_state = update;
        else
            next_state = done;
        update: next_state = test;
        done: next_state = done;
        default next_state = start;
    endcase
end
always @(*) begin
    ald = 0; sqld = 0;
    dld = 0; outld = 0;
    case(present_state)
        start: ald = 1;
        test: ;
        update: begin
            sqld = 1; dld = 1;
        end
        done: outld = 1;
        default ;
    endcase
end

endmodule 


module SQRTpath (input clk, input reset, input ald, input sqld, input dld,
    input outld, input [7:0] sw, output reg lteflg, output [3:0] root
);
wire [7:0] a;
wire [8:0] sq, s;
wire [4:0] del, dp2;
wire [3:0] dm1;
assign s = sq + {4'b0000, del};
assign dp2 = del + 2;
assign dm1 = del[4:1] - 1;
always @(*)
begin
 if(sq <= {1'b0,a})
    lteflg <= 1;
 else
    lteflg <= 0;
end
regr2 #(8, 0, 0) aReg(ald, clk, reset, sw, a);
regr2 #(9, 1, 0) sqReg(sqld, clk, reset, s, sq); 
regr2 #(5, 1, 1) delReg(dld, clk, reset, dp2, del);
regr2 #(4, 0, 0) outReg(outld, clk,reset,dm1,root);
endmodule

module regr2
#(parameter N = 4, parameter BIT0 = 1, parameter BIT1 = 1)
(input load, input clk, input reset, input [N-1:0] d, output reg [N-1:0] q);
always @(posedge clk or posedge reset) begin
    if(reset == 1) begin
        q[N-1:2] <= 0;
        q[0] <= BIT0;
        q[1] <= BIT1;
    end
    else if(load == 1)
        q <= d;
end
endmodule

module sqrt (input clk, input clr, input go, input [7:0] sw,
    output done , output [3:0] root);
wire lteflg, ald, sqld, dld, outld;
assign done = outld;
SQRTctrl sqrt1 (clk, clr, lteflg, go, ald, sqld, dld, outld);
SQRTpath sqrt2 (clk, clr, ald, sqld, dld, outld, sw, lteflg, root);
endmodule 


module display (input clk, input clr, input go, input [7:0] bin, input load,
    output [6:0] CA, output [3:0] AN);
    wire done;
    wire [3:0] root;
    wire [7:0] root2;
    wire [11:0] bcdin;
    wire [11:0] bcdout;
    reg [3:0] dig1, dig2, dig3, dig4;
    initial begin
        dig1 = 0;
        dig2 = 0;
        dig3 = 0;
        dig4 = 0;
    end
    sqrt st(clk ,clr ,go, bin, done, root);
    bin2bcd inp(bin,bcdin);
    bin2bcd out(root2,bcdout);
    four_digit_seven_seg disp(clr,clk,dig1,dig2,dig3,dig4,AN,CA);
    always @(*) begin
        if(load) begin
            #100
            dig2 = bcdin[11:8];
            dig3 = bcdin[7:4];
            dig4 = bcdin[3:0];
        end
        if(done) begin
            #100
            dig2 = bcdout[11:8];
            dig3 = bcdout[7:4];
            dig4 = bcdout[3:0];
        end
    end
endmodule