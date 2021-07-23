`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 15:14:45
// Design Name: 
// Module Name: IF_ID_Regs
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


module IF_ID_Regs(
    input wire clk,
    input wire rst_n,
    input wire pipeline_stop, //��ˮ����ͣ�ź�
    input wire pipeline_flush,
    
    input wire [31:0] inst,//����if�׶λ�õ�ָ���ʼ���������źŵ���֮�󣬸��¼Ĵ���������
    input wire [31:0] PC,//����PC
    
    output reg [31:0] if_inst,
    output reg [31:0] if_PC,
	output reg id_have_inst
    );
    
	

    always@(posedge clk or negedge rst_n)begin
        if(~rst_n  || pipeline_flush) begin //��λ���������ź�����������
            if_PC <= 32'b0;
            if_inst <= 32'b0;
			id_have_inst <= 0;
        end
        else if(pipeline_stop) begin //ͣ���źţ�ά�ֲ�����
            if_PC <= if_PC;
            if_inst <= if_inst;
			id_have_inst <= id_have_inst;
        end
        else begin
            if_inst <= inst;
            if_PC <= PC;
			id_have_inst <= 1;
        end
    end
endmodule

