`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/30 18:41:54
// Design Name: 
// Module Name: display
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


module display(
    input clk,
    input [31:0]data,
    output reg [7:0]an,
    output reg [7:0]seg
    );
    reg [3:0]num;
    reg [31:0]cnt;
    always@(posedge clk)
    begin
        if(cnt<32'h FFFF_FFFF)
        cnt=cnt+1;
        else cnt=0;
    end
    always@(*)
    begin
        case(cnt[17:15])
        3'b000:begin an=8'b1111_1110; num=data[3:0];   end
        3'b001:begin an=8'b1111_1101; num=data[7:4];   end
        3'b010:begin an=8'b1111_1011; num=data[11:8]; end
        3'b011:begin an=8'b1111_0111; num=data[15:12]; end
        3'b100:begin an=8'b1110_1111; num=data[19:16]; end
        3'b101:begin an=8'b1101_1111; num=data[23:20]; end
        3'b110:begin an=8'b1011_1111; num=data[28:25]; end
        3'b111:begin an=8'b0111_1111; num=data[31:29]; end
        endcase
    end
    always@(*)
    case(num)
    0: seg= 8'b 1100_0000; 
    1: seg= 8'b 1111_1001; 
    2:seg= 8'b 1010_0100; 
    3: seg= 8'b 1011_0000;
    4: seg= 8'b 1001_1001; 
    5: seg= 8'b 1001_0010;
    6: seg= 8'b 1000_0010;
    7: seg= 8'b 1111_1000; 
    8: seg= 8'b 1000_0000; 
    9:seg= 8'b 1001_0000; 
    10: seg=8'b 1000_1000;
    11:seg=8'b 1000_0011;
    12:seg=8'b 1100_0110;
    13:seg=8'b 1010_0001;
    14:seg=8'b 1000_0110;
    15:seg=8'b 1000_1110;
    endcase
endmodule
