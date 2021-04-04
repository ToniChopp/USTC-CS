`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/04/18 15:19:49
// Design Name: 
// Module Name: VGA
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


module VGA_top(
    input [3:0]R,
    input [3:0]G,
    input [3:0]B,
    input draw,
    input up,
    input left,
    input right,
    input down,
    input clk,
    input rst,
    output [3:0]VGA_R,
    output [3:0]VGA_G,
    output [3:0]VGA_B,
    output VS,
    output HS
    );
    wire [15:0]a;
    wire [15:0]dpra;
    wire [11:0]d;
    wire [11:0]dpo;
    wire [3:0]R_in;
    wire [3:0]G_in;
    wire [3:0]B_in;
    wire [3:0]R_out;
    wire [3:0]G_out;
    wire [3:0]B_out;
    wire we;
    wire [7:0]x;
    wire [7:0]y;
    wire clk_50mhz;
    wire clk_5mhz;
    wire clk_5hz;
    wire locked;
    
    assign {R_in,G_in,B_in}=dpo;
    
    clk_wiz_0 U0(.clk_5mhz(clk_5mhz),.clk_50mhz(clk_50mhz),.reset(0),.locked(locked),.clk(clk));
    clk_div U1(.clk_in(clk_5mhz),.en(1),.rst(0),.clk_out(clk_5hz));
    PCU U2(.clk_5hz(clk_5hz),.rst(rst),.draw(draw),.up(up),.left(left),.right(right),.down(down),.R_in(R),.G_in(G),.B_in(B),.a(a),.data(d),.x(x),.y(y),.we(we));
    get_address_data U3(.clk_50mhz(clk_50mhz),.rst(rst),.dpra(dpra));
    VGA U4(.clk_50mhz(clk_50mhz),.R_in(R_in),.G_in(G_in),.B_in(B_in),.rst(rst),.R_out(R_out),.G_out(G_out),.B_out(B_out),.HS(HS),.VS(VS));
    Cross U5(.clk_50mhz(clk_50mhz),.rst(rst),.R_out(R_out),.G_out(G_out),.B_out(B_out),.x(x),.y(y),.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));
    
    dist_mem_gen_0 U6(
                     .a(a),
                     .d(d),
                     .dpra(dpra),
                     .clk(clk_5hz),
                     .we(we),
                     .dpo(dpo)
    );
endmodule
