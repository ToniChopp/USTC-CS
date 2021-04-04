`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 21:42:15
// Design Name: 
// Module Name: FIFO
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


module FIFO(
    input [3:0]in,
    input en_in,
    input en_out,
    input clk,
    input rst,
    output reg [3:0]out,
    output wire [7:0]an,
    output wire [6:0]seg,
    output wire dp,
    output wire empty,
    output wire full
    );
    reg [3:0]hptr;    //头指针 wa
    reg [3:0]tptr;    //尾指针  ra0
    reg [3:0]wd;
    wire [3:0]rd0;
    reg en_in_l;
    reg en_out_l;
    
    assign empty=(hptr==tptr);
    assign full=((tptr+1)%8==hptr);
    
    always @(posedge clk)   //输出时序
    begin
        en_in_l<=en_in;
        en_out_l<=en_out;
        if(rst)
        begin
            out<=0;
            hptr=0;
            tptr=0;
        end
        else if(!empty && en_out && !en_out_l)
        begin
            out<=rd0;
            hptr=(hptr+1)%8;  //队首读出
        end
        else if(!full && en_in && !en_in_l)
        begin
            wd<=in;
            tptr=(tptr+1)%8;  //队尾写入
        end
    end
    
    Register_file FIFO(.clk(clk),.we(en_in),.we_l(en_in_l),.rst(rst),.ra0(hptr),.hptr(hptr),.tptr(tptr),.wa(tptr),.wd(wd),.rd0(rd0),.seg(seg),.an(an),.dp(dp));
    
endmodule
