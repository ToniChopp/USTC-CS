`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/16 23:37:46
// Design Name: 
// Module Name: seg_ctrl
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


module seg_ctrl(
    input clk,
    input rst,
    input mem,
    input [31:0]mem_data,
    input [31:0]reg_data,
    output reg [7:0]an,
    output reg [7:0]seg
);
wire [31:0]out;
reg [31:0]cnt;
reg [3:0]data;
always @(posedge clk or posedge rst)
begin
if(rst)
    cnt<=0;
 else if(cnt<32'h 1000_0000)
 cnt<=cnt+1;
 else cnt<=0;
end
always@(*)
case(cnt[16:14])
3'b000:begin  an=8'b1111_1110; data=out[3:0]; end
3'b001:begin an=8'b1111_1101; data=out[7:4]; end
3'b010:begin an=8'b1111_1011; data=out[11:8]; end
3'b011:begin an=8'b1111_0111; data=out[15:12]; end
3'b100:begin an=8'b1110_1111; data=out[19:16]; end
3'b101:begin an=8'b1101_1111; data=out[23:20]; end
3'b110:begin an=8'b1011_1111; data=out[27:24]; end
3'b111:begin an=8'b0111_1111; data=out[31:28]; end
endcase
assign out=mem==1? mem_data:reg_data;
always@(*)
case(data)
0: seg= 8'b 1100_0000; 
1: seg= 8'b 1111_1001; 
2: seg= 8'b 1010_0100; 
3: seg= 8'b 1011_0000;
4: seg= 8'b 1001_1001; 
5: seg= 8'b 1001_0010;
6: seg= 8'b 1000_0010;
7: seg= 8'b 1111_1000; 
8: seg= 8'b 1000_0000; 
9: seg= 8'b 1001_0000; 
10:seg= 8'b 1000_1000;
11:seg= 8'b 1000_0011;
12:seg= 8'b 1100_0110;
13:seg= 8'b 1010_0001;
14:seg= 8'b 1000_0110;
15:seg= 8'b 1000_1110;
endcase
endmodule
