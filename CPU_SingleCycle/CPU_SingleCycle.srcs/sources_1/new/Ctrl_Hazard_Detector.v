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

//组合逻辑,在if阶段通过得到的inst就可以判断是不是跳转指令，并且给出暂停信号
//控制冒险判断：条件跳转（beq,bge,blt），无条件跳转(jal, jalr)
//用静态分支预测实现：不需要暂停pc，直接先按顺序执行指令，然后等要跳转的pc传到PC模块后，如果需要跳转的话，(就是说pcsel不为00的时候)
//下一个时钟上升沿pc更新为待跳转的值，flush信号把if/id, id/ex（不需要执行的指令）寄存器内容清空，
//pcsel不为00有两种情况：b型指令（00/01）和jalr(11)一种，前两种要执行到exe阶段，并在下一个时钟上升沿更新后pc才得到正确值， jal一种(01)也是一样
module Ctrl_Hazard_Detector(
    input wire clk,
    input wire rst_n,
    
    input wire [1:0]pcsel,//如果传入的pcsel是00，就表示当前指令不需要跳转，继续执行就完事了，如果是别的就表示需要跳转，这个时候某些（if/id,id/ex）寄存器需要清零

    output reg select_pc, //该信号的作用是选择传入npc的pc是顺延的pc+4还是从id/exe寄存器传回的pc,只有要跳转的时候才不是pc+4
    
    output reg if_id_flush,
    output reg id_exe_flush,
    output reg exe_mem_flush,
    output reg mem_wb_flush, //流水线寄存器清空信号
//    output reg if_id_stop,
//    output reg id_exe_stop,
//    output reg exe_mem_stop,
//    output reg mem_wb_stop,
	output reg shield_pc_stop //当控制冒险单元决定需要跳转时，这个时候出现数据冒险会使pc暂停，这个时候跳转优先级更高，将pc_stop信号屏蔽
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
