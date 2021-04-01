`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 15:21:47
// Design Name: 
// Module Name: Register_file
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/11 15:13:14
// Design Name: 
// Module Name: register
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
    input [3:0]x,
    input [7:0]seg_sel,
    output reg [6:0]seg,
    output [7:0]an
    );
    assign an=seg_sel;
    always @(x)
    begin
    case(x)
    4'b0000:seg = 7'b1000000;
    4'b0001:seg = 7'b1111001;
    4'b0010:seg = 7'b0100100;
    4'b0011:seg = 7'b0110000;
    4'b0100:seg = 7'b0011001;
    4'b0101:seg = 7'b0010010;
    4'b0110:seg = 7'b0000010;
    4'b0111:seg = 7'b1111000;
    4'b1000:seg = 7'b0000000;
    4'b1001:seg = 7'b0010000;
    default:seg = 7'b1111111;
    endcase                                        
    end
endmodule  

module Register_file(
    input [3:0]ra0,
    input [3:0]ra1,
    input [3:0]wa,
    input [3:0]wd,
    input we,
    input we_l,
    input rst,
    input clk,
    output reg [3:0]rd0,
    output reg [3:0]rd1,
    output [6:0]seg,
    output [7:0]an,
    input [3:0]hptr,
    input [3:0]tptr,
    output reg dp
    );
    reg [3:0]register[15:0];
    integer i;
    reg clk1;
    always @(posedge clk)
    begin
        if (rst)
        begin 
            register[0]<=0;
            register[1]<=0;
            register[2]<=0;
            register[3]<=0;
            register[4]<=0;
            register[5]<=0;
            register[6]<=0;
            register[7]<=0;                                                                                    
        end
        else
        begin
            if (we && !we_l)
            begin
                register[wa]<=wd;
            end
            else
            begin
                rd0=register[ra0];
                rd1=register[ra1];
            end            
        end
    end
    reg [3:0]seg_in;
    reg [7:0]seg_sel;
    seg_ctrl seg_ctrl(seg_in,seg_sel,seg,an);
    reg [23:0]cnt;
    always @(posedge clk)
    begin        
        if (cnt==24'd4999999) 
        begin 
            cnt=0;
            clk1=~clk1;
        end
        else 
        begin
            cnt=cnt+1;
            dp=1;
            if(hptr==tptr)
            begin
                seg_sel<=8'b01111111;
                dp=0;
                seg_in<=4'b1111;
            end
            else
            begin
                case(cnt[15:13])
        3'b000:
        if ((hptr<=tptr & (7<hptr | 7>=tptr))|(hptr>tptr &(tptr<=7 & 7<hptr))) seg_sel<=8'b11111111;else                
        begin 
            if (hptr==7) dp=0;         
            seg_sel<=8'b11111110;
            seg_in<=register[7];
        end
        3'b001:
        if ((hptr<=tptr & (6<hptr | 6>=tptr))|(hptr>tptr &(tptr<=6 & 6<hptr))) seg_sel<=8'b11111111;else                                    
        begin
            if (hptr==6) dp=0;                             
            seg_sel<=8'b11111101;
            seg_in<=register[6];
        end            
        3'b010:
        if ((hptr<=tptr & (5<hptr | 5>=tptr))|(hptr>tptr &(tptr<=5 & 5<hptr))) seg_sel<=8'b11111111;else                                
        begin
            if (hptr==5) dp=0;                             
            seg_sel<=8'b11111011;
            seg_in<=register[5];        
        end
        3'b011:
        if ((hptr<=tptr & (4<hptr | 4>=tptr))|(hptr>tptr &(tptr<=4 & 4<hptr))) seg_sel<=8'b11111111;else                                
        begin
            if (hptr==4) dp=0;                             
            seg_sel<=8'b11110111;
            seg_in<=register[4];        
        end
        3'b100:
        if ((hptr<=tptr & (3<hptr | 3>=tptr))|(hptr>tptr &(tptr<=3 & 3<hptr))) seg_sel<=8'b11111111;else                                                
        begin
            if (hptr==3) dp=0;                             
            seg_sel<=8'b11101111;
            seg_in<=register[3];
        end
        3'b101:
        if ((hptr<=tptr & (2<hptr | 2>=tptr))|(hptr>tptr &(tptr<=2 & 2<hptr))) seg_sel<=8'b11111111;else                                
        begin
            if (hptr==2) dp=0;                             
            seg_sel<=8'b11011111;
            seg_in<=register[2];
        end            
        3'b110:
        if ((hptr<=tptr & (1<hptr | 1>=tptr))|(hptr>tptr &(tptr<=1 & 1<hptr))) seg_sel<=8'b11111111;else                                
        begin
            if (hptr==1) dp=0;                             
            seg_sel<=8'b10111111;
            seg_in<=register[1];        
        end
        3'b111:
        if ((hptr<=tptr & (0<hptr | 0>=tptr))|(hptr>tptr &(tptr<=0 & 0<hptr))) seg_sel<=8'b11111111;else                
        begin
            if (hptr==0) dp=0;                             
            seg_sel<=8'b01111111;
            seg_in<=register[0];        
        end          
        endcase
            end
        
        end        
    end    
endmodule
