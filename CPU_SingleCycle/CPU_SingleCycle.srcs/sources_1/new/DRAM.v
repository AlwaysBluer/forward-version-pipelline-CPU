`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 22:17:37
// Design Name: 
// Module Name: DRAM
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


module DRAM(
    input wire clk_i,//ʱ���źţ������
    input wire [31:0]addr_i,//��ַ��д����߶�����
    output wire [31:0]rd_data_o,//����������
    input wire memwr_i, //�ڴ�дʹ���ͺ�
    input wire[31:0]wr_data_i //Ҫд�������
    );
     
    //DRAM�������������ַ���ϸ���������
    //DRAMд�����������ַ���������ݺ�ʲôʱ��д������
    wire [31:0] waddr_tmp = addr_i - 16'h4000;
    dram U_dram(
    .clk(clk_i),
    .a(waddr_tmp[15:2]),
    .spo(rd_data_o),
    .we(memwr_i),
    .d(wr_data_i)
    );
endmodule
