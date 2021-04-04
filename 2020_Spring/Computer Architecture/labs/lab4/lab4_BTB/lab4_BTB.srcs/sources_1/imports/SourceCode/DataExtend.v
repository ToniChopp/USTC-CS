`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Data Extend
// Tool Versions: Vivado 2017.4.1
// Description: Data Extension module
// 
//////////////////////////////////////////////////////////////////////////////////

//  ����˵��
    //  ��Cache��Load��������չ��32λ
// ����
    // data              cache����������
    // addr              �ֽڵ�ַ
    // load_type         load������
    // ALU_func          ��������
// ���
    // dealt_data        ��չ�������
// ʵ��Ҫ��
    // ��ȫģ��


`include "Parameters.v"

module DataExtend(
    input wire [31:0] data,
    input wire [1:0] addr,
    input wire [2:0] load_type,
    output reg [31:0] dealt_data
    );
    // finished
    // TODO: Complete this module
    
    always @ (*)
    begin
        if (load_type == `NOREGWRITE)
        begin
            dealt_data = data;
        end
        else if (load_type == `LB)
        begin
            case(addr)
                2'b00: dealt_data = {{24{data[7]}}, data[7:0]};
                2'b01: dealt_data = {{24{data[15]}}, data[15:8]};
                2'b10: dealt_data = {{24{data[23]}}, data[23:16]};
                2'b11: dealt_data = {{24{data[31]}}, data[31:24]};
                default: dealt_data = 32'b0;
            endcase
        end
        else if (load_type == `LH)
        begin
            case(addr)
                2'b00: dealt_data = {{16{data[15]}}, data[15:0]};
                2'b10: dealt_data = {{16{data[31]}}, data[31:16]};
                default : dealt_data = 32'b0;
            endcase
        end
        else if (load_type == `LBU)
        begin
            case(addr)
                2'b00: dealt_data = {24'b0, data[7:0]};
                2'b01: dealt_data = {24'b0, data[15:8]};
                2'b10: dealt_data = {24'b0, data[23:16]};
                2'b11: dealt_data = {24'b0, data[31:24]};
                default: dealt_data = 32'b0;
            endcase
        end
        else if (load_type == `LHU)
        begin
            case(addr)
                2'b00: dealt_data = {16'b0, data[15:0]};
                2'b10: dealt_data = {16'b0, data[31:16]};
                default : dealt_data = 32'b0;
            endcase
        end
        else if (load_type == `LW)
        begin
            dealt_data = data;
        end
        else
        begin
            dealt_data = 32'b0;
        end

    end

endmodule