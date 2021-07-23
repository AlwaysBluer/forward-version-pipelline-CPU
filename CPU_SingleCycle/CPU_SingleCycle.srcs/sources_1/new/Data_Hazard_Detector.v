`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 16:20:55
// Design Name: 
// Module Name: Data_Hazard_Detector
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

//����߼����ж��Ƿ��������ð���Լ���Щ��ˮ�߼Ĵ�����Ҫ��ͣ����ͣ��������
//ʵ�ַ����������ˮ�߼Ĵ��������ݣ�
//���磺���ΪA��ð�գ���id�׶η��ֺ�exe��rd��ͻ�����ź����ߣ�
//��һ��ʱ�������أ�pcά�ֲ���, rd,alu_valueд��exe/mem�Ĵ�����Ԫ�������id/exe�Ĵ���������
//���ʱexe��id��ð��������ת��Ϊmem��rd��id��ð��
//��һ��ʱ�������أ�pcά�ֲ��䣬rd��д��mem/wb�Ĵ�����exe/mem�������ת��Ϊwb��id��ð��
//��һ��ʱ�������أ�pcά�ֲ��䣬����д��RF�е�rd�Ĵ�����ð��������
//��ʱ������߼�������ð���ź����ͣ�PC���£�����ʵ����3�����ڵ���ͣ

//
module Data_Hazard_Detector(
    //����׶εõ�
    input wire [4:0] rs1,
    input wire [4:0] rs2,
	
    //�ɿ��Ƶ�Ԫ���������ź�
    input wire re1,
    input wire re2, 
	
	input wire Memsel_from_CTRL_Unit, //
	input wire Memsel_from_exe_mem,
	input wire Memsel_from_mem_wb,
    //����
	input wire exe_we,
	input wire mem_we,
	input wire wb_we,
	
    input wire [4:0] exe_rd,
    input wire [4:0] mem_rd,
    input wire [4:0] wb_rd,
	
	input wire [31:0] exe_value,
	input wire [31:0] mem_value,
	input wire [31:0] wb_value,
	input wire [31:0] dram_value_from_mem,
	input wire [31:0] dram_value_from_mem_wb,
    
    //output
    output reg if_id_stop,
    output reg id_exe_stop,
    output reg exe_mem_stop,
    output reg mem_wb_stop,
    output reg PC_stop ,// ����PC
    
    output reg if_id_flush,
    output reg id_exe_flush,
    output reg exe_mem_flush,
    output reg mem_wb_flush ,//��ˮ�߼Ĵ��������ź�
	
	output reg [31:0] data1_forward,//rs1_valueǰ������
	output reg [31:0] data2_forward,//rs2_valueǰ������
	
	output reg rs1_value_sel,
	output reg rs2_value_sel//ѡ���ź�
    );

	
	
    always@(*)begin //exe��ð���򴫻����ȼ����
		if((exe_rd != 5'b0)&&(re1 & exe_we & (rs1 == exe_rd))&&(Memsel_from_CTRL_Unit == 0)) begin  //��Ϊlwָ��
		//forwarding: rs1_value forwarding from exe_value
			data1_forward = exe_value;
			rs1_value_sel = 1;
        end
	    else if((exe_rd != 5'b0)&&(re1 & exe_we & (rs1 == exe_rd))&&(Memsel_from_CTRL_Unit == 1)) begin //��lwָ��
			data1_forward = 32'b0;
			rs1_value_sel = 0;
		end
        else if((mem_rd != 5'b0)&& (re1 & mem_we & (rs1 == mem_rd))) begin   
		//forwarding:rs2_value from mem_value
			data1_forward = (Memsel_from_exe_mem == 0)? mem_value : dram_value_from_mem;
			rs1_value_sel = 1;
			
        end
        
        else if((wb_rd != 5'b0)&&(re1 & wb_we & (rs1 == wb_rd))) begin 
		//forwarding: rs1_value forwarding from wb_value 
			data1_forward = (Memsel_from_mem_wb == 0)? wb_value : dram_value_from_mem_wb; 
			rs1_value_sel = 1; 
        end
        
        else begin   
		//forwarding
			data1_forward = 32'b0;
			rs1_value_sel =  0;
			
        end
    end
	
	always@(*)begin
        if((exe_rd != 5'b0)&&(re2 & exe_we & (rs2 == exe_rd))&&(Memsel_from_CTRL_Unit == 0)) begin	//��ʾ��ǰexe�׶εĲ���lwָ��
			data2_forward = exe_value;
			rs2_value_sel = 1;
        end
		else if((exe_rd != 5'b0)&&(re2 & exe_we & (rs2 == exe_rd))&&(Memsel_from_CTRL_Unit == 1)) begin //loadָ��
			data2_forward = 32'b0;
			rs2_value_sel = 0;
		end
		       
        else if((mem_rd != 5'b0)&&(re2 & mem_we & (rs2 == mem_rd))) begin
			data2_forward = (Memsel_from_exe_mem == 0)? mem_value : dram_value_from_mem;
			rs2_value_sel = 1;
        end
        
		else if((wb_rd != 5'b0)&&(re2 & wb_we & (rs2 == wb_rd))) begin //д�ؼĴ���Ϊx0�Ų�����
		//forwarding:rs2 forwarding from wb_value
			data2_forward = (Memsel_from_mem_wb == 0)? wb_value : dram_value_from_mem_wb;
            rs2_value_sel = 1;
        end
       
        else begin  
		//forwarding
			data2_forward = 32'b0;
			rs2_value_sel =  0;
			
        end
    end
	
	always@(*)begin
		if((exe_rd != 5'b0)&&((re1 & exe_we & (rs1 == exe_rd)) | (re2 & exe_we & (rs2 == exe_rd)))&& (Memsel_from_CTRL_Unit == 1)) begin
			PC_stop = 1'b1;
            if_id_stop = 1'b1;
            id_exe_stop = 1'b1;
            exe_mem_stop = 1'b0;
            mem_wb_stop = 1'b0;
            
            if_id_flush = 1'b0;
            id_exe_flush = 1'b1;//��rd���뵽exe/mem�Ĵ���,ת��ΪB��ð��
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;
		end
		else begin //û��ð�պ�pc��ʼ���£���ͣ��Ҳ������
            PC_stop = 1'b0;
            if_id_stop = 1'b0;
            id_exe_stop = 1'b0;
            exe_mem_stop = 1'b0;
            mem_wb_stop = 1'b0;
            
            if_id_flush = 1'b0;
            id_exe_flush = 1'b0;
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;
        end
	end
	
endmodule
