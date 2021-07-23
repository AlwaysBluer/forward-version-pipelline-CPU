`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 09:04:20
// Design Name: 
// Module Name: Top_PC
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


module Top_PC(
    input wire [1:0]PCsel, //����PC���£��ɿ��Ƶ�Ԫ����
    input wire [31:0] pc_from_exe,
    input wire selected_pc, //���ƴ���npc��pcֵ������ð�ռ�ⵥԪ����
    input wire pc_stop,
	input wire shield_pc_stop,
    input wire clk,
    input wire rst_n,
    input wire[31:0] Rs1_value, //ֱ�ӴӼĴ���RS1��������ֵ
    input wire[31:0] Imm, //��������Ԫ������ֵ
    output wire[31:0] PC_out //��ǰʱ���������ɵ�PC_out
    );
    wire [31:0]PC4;
    wire [31:0]PC_offset;
    wire [31:0]Rs1_offset;
    wire [31:0]PCC; 
    
    PC pc1(
    .clk(clk),
    .rst_n(rst_n),
    .PCsel(PCsel),
    .pc_stop(pc_stop),
	.shield_pc_stop(shield_pc_stop),
    .PC4(PC4),
    .PC_offset(PC_offset),
    .Rs1_offset(Rs1_offset),
    .PCC(PCC),
    .PC_out(PC_out)
    );
    
    NPC npc1(
    .cur_PC(PC_out), //�������ʵ�����ϸ�ʱ�����ڣ�PC������PC_out
    .pre_PC(pc_from_exe),
    .selected_pc(selected_pc),
    .Imm(Imm),
    .Rs1_value(Rs1_value),
    .PC4(PC4),
    .PC_offset(PC_offset),
    .Rs1_offset(Rs1_offset),
    .PCC(PCC)
    );
endmodule