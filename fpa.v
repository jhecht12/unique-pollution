`timescale 1ns / 1ps

// Finite state machine implementation of 8 bit floating point adder
// FPApath controls the data path and performs addition on the loaded values
// FPActrl maintains the state of the machine.
// Numbers are initially loaded in, then added and normalized
// After normalization, sum is output

module FPApath(input clk, input [1:0] state, input [7:0] a, input [7:0] b, output reg [7:0] sum, output reg norm);
    reg sign_gt,sign_ls,sign_ans;
    reg [3:0] exp_gt, exp_ls, exp_ans;
    reg [4:0] mant_gt, mant_ls, mant_ans;
    always @(negedge clk) begin
        case(state)
            0: begin
                if(a[6:0]>b[6:0]) begin
                    sign_gt = a[7]; sign_ls = b[7];
                    exp_gt = a[6:3]; exp_ls = b[6:3];
                    mant_gt = {2'b01, a[2:0]}; mant_ls = {2'b01, b[2:0]};
                    sign_ans = a[7];
                    exp_ans = a[6:3];
                end
                else begin
                    sign_gt = b[7]; sign_ls = a[7];
                    exp_gt = b[6:3]; exp_ls = a[6:3];
                    mant_gt = {2'b01, b[2:0]}; mant_ls = {2'b01, a[2:0]};
                    sign_ans = b[7];
                    exp_ans = b[6:3];
                end
            end
            1: begin
                mant_ls = mant_ls >> (exp_gt - exp_ls);
                if(sign_gt == sign_ls)
                    mant_ans = mant_gt + mant_ls;
                else
                    mant_ans = mant_gt - mant_ls;
            end
            2: begin
                norm = 0;
                if(mant_ans[4] == 1) begin
                    mant_ans = mant_ans >> 1;
                    exp_ans = exp_ans + 1;
                end
                else if(mant_ans[4:3] == 0) begin
                    mant_ans = mant_ans << 1;
                    exp_ans = exp_ans - 1;
                end
                else
                    norm = 1;
            end
            3: sum = {sign_ans, exp_ans, mant_ans[2:0]};
        endcase
    end
endmodule

module FPActrl (input clk, input clr, input go, input normal, output reg [1:0] present_state, output reg fin);
reg[1:0] next_state;
parameter load = 2'b00, add =2'b01, norm = 2'b10, done = 2'b11;

always @(posedge clk or posedge clr) begin
    if (clr == 1) begin
        present_state <= load;
        fin = 0;
    end
    else
        present_state <= next_state;
end
always @(*) begin
    case(present_state)
        load:
            if(go == 1)
                next_state = add;
            else
                next_state = load;
        add: next_state = norm;
        norm:
            if(normal)
                next_state = done;
            else
                next_state = norm;
        done: begin 
            next_state = done;
            fin = 1;
        end
        default next_state = load;
    endcase
end
endmodule 

module FPA (input clk, input clr, input go, input [7:0] a, input [7:0] b, output done, output [7:0] sum);
    wire normal;
    wire [1:0] state;
    FPActrl cont(clk,clr,go,normal,state,done);
    FPApath path(clk,state,a,b,sum,normal);
endmodule
