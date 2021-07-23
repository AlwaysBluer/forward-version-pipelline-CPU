`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 16:21:38
// Design Name: 
// Module Name: Ctrl_Hazard_Detector
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

//����߼�,��if�׶�ͨ���õ���inst�Ϳ����ж��ǲ�����תָ����Ҹ�����ͣ�ź�
//����ð���жϣ�������ת��beq,bge,blt������������ת(jal, jalr)
//�þ�̬��֧Ԥ��ʵ�֣�����Ҫ��ͣpc��ֱ���Ȱ�˳��ִ��ָ�Ȼ���Ҫ��ת��pc����PCģ��������Ҫ��ת�Ļ���(����˵pcsel��Ϊ00��ʱ��)
//��һ��ʱ��������pc����Ϊ����ת��ֵ��flush�źŰ�if/id, id/ex������Ҫִ�е�ָ��Ĵ���������գ�
//pcsel��Ϊ00�����������b��ָ�00/01����jalr(11)һ�֣�ǰ����Ҫִ�е�exe�׶Σ�������һ��ʱ�������ظ��º�pc�ŵõ���ȷֵ�� jalһ��(01)Ҳ��һ��
module Ctrl_Hazard_Detector(
    input wire clk,
    input wire rst_n,
    
    input wire [1:0]pcsel,//��������pcsel��00���ͱ�ʾ��ǰָ���Ҫ��ת������ִ�о������ˣ�����Ǳ�ľͱ�ʾ��Ҫ��ת�����ʱ��ĳЩ��if/id,id/ex���Ĵ�����Ҫ����

    output reg select_pc, //���źŵ�������ѡ����npc��pc��˳�ӵ�pc+4���Ǵ�id/exe�Ĵ������ص�pc,ֻ��Ҫ��ת��ʱ��Ų���pc+4
    
    output reg if_id_flush,
    output reg id_exe_flush,
    output reg exe_mem_flush,
    output reg mem_wb_flush, //��ˮ�߼Ĵ�������ź�
//    output reg if_id_stop,
//    output reg id_exe_stop,
//    output reg exe_mem_stop,
//    output reg mem_wb_stop,
	output reg shield_pc_stop //������ð�յ�Ԫ������Ҫ��תʱ�����ʱ���������ð�ջ�ʹpc��ͣ�����ʱ����ת���ȼ����ߣ���pc_stop�ź�����
    );
    always@(*)begin
        if(~rst_n)begin
            select_pc = 1'b0; //0 for current pc,1 for previous pc
            if_id_flush = 1'b0;
            id_exe_flush = 1'b0;
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;//do not clear the content
			shield_pc_stop = 1'b0;
        end
        else if(pcsel == 2'b00) begin //no need for jump, keep the pipeline
            select_pc = 1'b0;
            if_id_flush = 1'b0;
            id_exe_flush = 1'b0;
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;
			shield_pc_stop = 1'b0;
        end
        else if(pcsel == 2'b01 || pcsel == 2'b10 || pcsel == 2'b11) begin
            select_pc = 1'b1;
            if_id_flush = 1'b1;
            id_exe_flush = 1'b1;
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;
			shield_pc_stop = 1'b1;
        end
		else begin
			select_pc = 1'b0;
			if_id_flush = 1'b0;
			id_exe_flush = 1'b0;
			exe_mem_flush = 1'b0;
			mem_wb_flush = 1'b0;
			shield_pc_stop = 1'b0;
		end
    end
    
endmodule
