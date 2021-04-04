`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 08:39:10 PM
// Design Name: 
// Module Name: BHT
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


module BHT(
    input clk,
    input rst,
    input [31:0] pc_query,
    input [31:0] pc_update,
    input br,
    input update,
    output BHT_br
    );
    localparam SET_SIZE = 1 << 12;
    
    reg [3:0] STATE [SET_SIZE-1:0];
    wire [11:0] query_addr, update_addr;
    
    assign query_addr = pc_query[11:0];
    assign update_addr = pc_update[11:0];
    integer i;
    always @ (negedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < SET_SIZE; i = i + 1)
            begin
                STATE[i] <= 0;
            end
        end
        else
        begin
            if (update)
            begin
                if (br == 1)
                begin
                    if (STATE[update_addr] == 2'b00)
                    begin
                        STATE[update_addr] <= 2'b01;
                    end
                    else
                    begin
                        STATE[update_addr] <= 2'b11;
                    end
                end
                else
                begin
                    if (STATE[update_addr] == 2'b11)
                    begin
                        STATE[update_addr] <= 2'b10;
                    end
                    else
                    begin
                        STATE[update_addr] <= 2'b00;
                    end
                end
            end
        end
    end
    
    assign BHT_br = (STATE[query_addr] > 2'b01) ? 1'b1 : 1'b0;
endmodule
