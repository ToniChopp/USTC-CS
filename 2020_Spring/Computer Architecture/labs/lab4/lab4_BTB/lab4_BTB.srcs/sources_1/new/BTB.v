`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/08 23:01:43
// Design Name: 
// Module Name: BTB
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


module BTB (
    input clk, rst,
    input [31:0] pc_query,
    input [31:0] pc_update,
    input [31:0] data,
    input update,
    input br,
    output BTB_hit,
    output BTB_br,
    output [31:0] pc_predict    
    );
    localparam SET_ADDR_SIZE = 1 << 12;
    wire [11:0] query_addr, update_addr;
    wire [19:0] query_tag, update_tag;

    reg [19:0] TAG [SET_ADDR_SIZE-1:0];    // 存储高位地址
    reg [31:0] DATA [SET_ADDR_SIZE-1:0];   // 存储预测的 PC
    reg VALID [SET_ADDR_SIZE-1:0];         // 当前数组单元被更新则 VALID 为1，表示有效
    reg ISBR [SET_ADDR_SIZE-1:0];          // 是否是 BR 指令

    assign {query_tag, query_addr} = pc_query;
    assign {update_tag, update_addr} = pc_update;
    integer i;

    always @ (negedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < SET_ADDR_SIZE; i = i + 1)
            begin
                TAG[i] <= 0;
                DATA[i] <= 0;
                VALID[i] <= 0;
                ISBR[i] <= 0;
            end
        end
        else
        begin
            if (update)
            begin
                if (br)
                begin
                    TAG[update_addr] <= update_tag;
                    DATA[update_addr] <= data;
                    VALID[update_addr] <= 1'b1;
                    ISBR[update_addr] <= 1'b1;
                end
                else
                begin
                    TAG[update_addr] <= update_tag;
                    DATA[update_addr] <= data;
                    VALID[update_addr] <= 1'b1;
                    ISBR[update_addr] <= 1'b0;
                end
            end
        end
    end

    assign BTB_hit = ( (TAG[query_addr] == query_tag) && (VALID[query_addr] == 1'b1) )? 1'b1 : 1'b0;
    assign BTB_br =  ( (TAG[query_addr] == query_tag) && (VALID[query_addr] == 1'b1) && (ISBR[query_addr] == 1'b1) )? 1'b1 : 1'b0;
    assign pc_predict = DATA[query_addr];

endmodule
