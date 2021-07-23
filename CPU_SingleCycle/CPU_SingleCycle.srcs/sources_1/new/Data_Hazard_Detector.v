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

//组合逻辑，判断是否存在数据冒险以及哪些流水线寄存器需要暂停和暂停几个周期
//实现方法：清除流水线寄存器的内容，
//例如：如果为A类冒险，在id阶段发现和exe的rd冲突，险信号拉高，
//下一个时钟上升沿，pc维持不变, rd,alu_value写入exe/mem寄存器单元，清除掉id/exe寄存器的内容
//则此时exe与id的冒险消除，转化为mem的rd与id的冒险
//下一个时钟上升沿，pc维持不变，rd再写入mem/wb寄存器，exe/mem清除，则转化为wb与id的冒险
//下一个时钟上升沿，pc维持不变，数据写入RF中的rd寄存器，冒险消除，
//此时，组合逻辑产生的冒险信号拉低，PC更新，变相实现了3个周期的暂停

//
module Data_Hazard_Detector(
    //译码阶段得到
    input wire [4:0] rs1,
    input wire [4:0] rs2,
	
    //由控制单元产生控制信号
    input wire re1,
    input wire re2, 
	
	input wire Memsel_from_CTRL_Unit, //
	input wire Memsel_from_exe_mem,
	input wire Memsel_from_mem_wb,
    //传回
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
    output reg PC_stop ,// 更新PC
    
    output reg if_id_flush,
    output reg id_exe_flush,
    output reg exe_mem_flush,
    output reg mem_wb_flush ,//流水线寄存器清零信号
	
	output reg [31:0] data1_forward,//rs1_value前递数据
	output reg [31:0] data2_forward,//rs2_value前递数据
	
	output reg rs1_value_sel,
	output reg rs2_value_sel//选择信号
    );

	
	
    always@(*)begin //exe有冒险则传回优先级最高
		if((exe_rd != 5'b0)&&(re1 & exe_we & (rs1 == exe_rd))&&(Memsel_from_CTRL_Unit == 0)) begin  //不为lw指令
		//forwarding: rs1_value forwarding from exe_value
			data1_forward = exe_value;
			rs1_value_sel = 1;
        end
	    else if((exe_rd != 5'b0)&&(re1 & exe_we & (rs1 == exe_rd))&&(Memsel_from_CTRL_Unit == 1)) begin //是lw指令
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
        if((exe_rd != 5'b0)&&(re2 & exe_we & (rs2 == exe_rd))&&(Memsel_from_CTRL_Unit == 0)) begin	//表示当前exe阶段的不是lw指令
			data2_forward = exe_value;
			rs2_value_sel = 1;
        end
		else if((exe_rd != 5'b0)&&(re2 & exe_we & (rs2 == exe_rd))&&(Memsel_from_CTRL_Unit == 1)) begin //load指令
			data2_forward = 32'b0;
			rs2_value_sel = 0;
		end
		       
        else if((mem_rd != 5'b0)&&(re2 & mem_we & (rs2 == mem_rd))) begin
			data2_forward = (Memsel_from_exe_mem == 0)? mem_value : dram_value_from_mem;
			rs2_value_sel = 1;
        end
        
		else if((wb_rd != 5'b0)&&(re2 & wb_we & (rs2 == wb_rd))) begin //写回寄存器为x0号不考虑
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
            id_exe_flush = 1'b1;//将rd传入到exe/mem寄存器,转化为B类冒险
            exe_mem_flush = 1'b0;
            mem_wb_flush = 1'b0;
		end
		else begin //没有冒险后，pc开始更新，不停顿也不清零
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
