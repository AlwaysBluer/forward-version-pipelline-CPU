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
    input wire pipeline_stop, //流水线暂停信号
    input wire pipeline_flush,
    
    input wire [31:0] inst,//传入if阶段获得的指令，当始终上升沿信号到来之后，更新寄存器的内容
    input wire [31:0] PC,//传入PC
    
    output reg [31:0] if_inst,
    output reg [31:0] if_PC,
	output reg id_have_inst
    );
    
	

    always@(posedge clk or negedge rst_n)begin
        if(~rst_n  || pipeline_flush) begin //复位或者清零信号则内容清零
            if_PC <= 32'b0;
            if_inst <= 32'b0;
			id_have_inst <= 0;
        end
        else if(pipeline_stop) begin //停顿信号，维持不更新
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

