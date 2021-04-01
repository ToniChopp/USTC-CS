`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 14:22:58
// Design Name: 
// Module Name: ddu
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
    4'b1010:seg = 7'b0001000;
    4'b1011:seg = 7'b0000011;
    4'b1100:seg = 7'b1000110;
    4'b1101:seg = 7'b0100001;
    4'b1110:seg = 7'b0000110;
    4'b1111:seg = 7'b0001110;                            
    default:seg = 7'b1111111;
    endcase                                        
    end
endmodule  

module ddu(
    input cont,
    input clk,
    input rst,
    input en,
    input [5:0]sw,
    output reg[15:0]led,
    output [6:0]seg,
    //output [31:0] data,        
    output [7:0]an
    //output reg dp
    );
    wire step;
    wire mem;
    wire inc;
    wire dec;
    wire run;
    reg clk_en;
    reg [7:0] addr=0;
    wire [7:0]addr0;
    assign addr0 = 1;
    wire [31:0] data; 
    wire [7:0] pc;
    reg inc_sig=0;
    reg dec_sig=0;
    reg step_sig=0;

    always @(posedge clk,posedge rst)    
    begin
        if (rst) addr<=0;
        else
        begin
            if (inc & ~inc_sig) 
            begin
                addr<=addr+1;                                                                                                                                                                                                                                                                                                                                                                                                                               
                inc_sig=1;                     
            end
            if (~inc) inc_sig=0;            
            if (dec & ~dec_sig) 
            begin
                addr<=addr-1;
                dec_sig=1;                     
            end
            if (~dec) dec_sig=0;
        end
    end
    
    reg [3:0]seg_in;
    reg [7:0]seg_sel;
    seg_ctrl seg_ctrl(seg_in,seg_sel,seg,an);
    reg [23:0]cnt;
    always @(posedge clk,posedge rst)
    begin
        if (rst)
        begin
            seg_in<=0;
            seg_sel<=8'b11111111;
        end
        else
        begin
            if (cont) clk_en=1;
            else
            begin
                if (step & ~step_sig) 
                begin
                    clk_en=1;
                    step_sig=1;
                end
                else clk_en=0;
                if (~step) step_sig=0;
            end
            led <= 0;
            if (cnt==24'd4999999) begin cnt=0;end
            else
            begin
                cnt=cnt+1;
                case(cnt[15:13])
                    3'b000:
                    begin
                        seg_sel<=8'b11111110;
                        seg_in<=data[3:0];
                    end
                    3'b001:
                    begin
                        seg_sel<=8'b11111101;
                        seg_in<=data[7:4];
                    end            
                    3'b010:
                    begin
                        seg_sel<=8'b11111011;
                        seg_in<=data[11:8];        
                    end
                    3'b011:
                    begin
                        seg_sel<=8'b11110111;
                        seg_in<=data[15:12];        
                    end
                    3'b100:
                    begin
                        seg_sel<=8'b11101111;
                        seg_in<=data[19:16];
                    end
                    3'b101:
                    begin
                        seg_sel<=8'b11011111;
                        seg_in<=data[23:20];
                    end            
                    3'b110:
                    begin
                        seg_sel<=8'b10111111;
                        seg_in<=data[27:24];        
                    end
                    3'b111:
                    begin
                        seg_sel<=8'b01111111;
                        seg_in<=data[31:28];        
                    end                     
                    endcase
            end
        end
    end

    Cpu cpu(clk_en,clk,rst,1,addr0,data,pc,sw);

endmodule

