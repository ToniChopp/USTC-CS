`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/10 23:00:51
// Design Name: 
// Module Name: PredictionMod
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


module PredictionMod(
    input clk,
    input rst,
    input [31:0] pc_query,   // PC_IF
    input [31:0] pc_update,  // PC_EX-4
    input [31:0] pc_target,  // br_target
    input update,
    input br,
    output reg br_predict_miss,
    output reg [31:0] NPC,
    output  br_predict_result
    );

    wire BTB_hit;
    wire BTB_br;
    wire [31:0] pc_predict;
    wire [31:0] pc_next;

    assign pc_next = pc_query + 4;
    
    wire br_predict_in, br_predict_out;
    wire [31:0] pc_out;

    assign br_predict_in = BTB_br;
    assign br_predict_result = br_predict_in;

    always @ (*)
    begin
        if (update)
        begin
            if (br_predict_out == br)       // 成功预测
            begin
                NPC = br_predict_in? pc_predict : pc_next;
                br_predict_miss = 0;
            end
            else
            begin
                NPC = br? pc_target : pc_out;         // EX 段发现预测失败，所以要回溯到两个周期前，pc_out 应为 EX 时的 pc+4
                br_predict_miss = 1;
            end
        end
        else
        begin     // 不是 br 指令
            NPC = br_predict_in? pc_predict : pc_next;
            br_predict_miss = 0;
        end
    end

    BranchHistory BranchHistory(
        .clk(clk),
        .rst(rst),
        .br_predict_in(br_predict_in),
        .pc_in(pc_next),
        .br_predict_out(br_predict_out),
        .pc_out(pc_out)
    );

    BTB BTB(
        .clk(clk),
        .rst(rst),
        .pc_query(pc_query),
        .pc_update(pc_update),
        .data(pc_target),
        .update(update),
        .br(br),
        .BTB_hit(BTB_hit),
        .BTB_br(BTB_br),
        .pc_predict(pc_predict)
    );

endmodule
