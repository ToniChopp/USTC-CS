`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/29 21:26:44
// Design Name: 
// Module Name: pinpeline_tb
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


module pinpeline_tb(

    );
    reg clk;
    reg rst;
    reg [1:0]choose;
    reg [9:0]address;
    wire [11:0]led;
    wire stallD,stallF,flushE,flushD;
    wire [7:0]seg;
    wire [7:0]an;
    reg step;
    reg stop;
    wire io;

   integer k;
   pipeline DUT(clk,rst,choose,address,led,stallD,stallF,flushD,flushE,seg,an,step,stop,io);
initial
begin
    #2000 $finish;
end
 initial begin
     clk=0; rst=0; stop=0; step=0;
   for(k=0;k<200;k=k+1)
   begin
   #10 step=~step;
   if(k==1||k==6)
       rst=~rst;
    end
 end
endmodule
