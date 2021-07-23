`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 15:15:50
// Design Name: 
// Module Name: MEM_WB_Regs
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


module MEM_WB_Regs(
    input wire clk,
    input wire rst_n,
    input wire pipeline_stop,
    input wire pipeline_flush,
    input wire mem_have_inst,
    //value
    input wire [31:0] exe_alu_value,
    input wire [31:0] dram_value ,//DataRam读取的数据
    input wire [31:0] exe_PC,
    input wire [4:0]  exe_rd,
    
    //signal
    input wire exe_Memsel,
    input wire exe_RegWE,
    input wire exe_WDataSel,
    
    //output 
    output reg [31:0] mem_alu_value,
    output reg [31:0] mem_dram_value,
    output reg [31:0] mem_PC,
    output reg [4:0] mem_rd,
    output reg mem_Memsel,
    output reg mem_RegWE,
    output reg mem_WDataSel,
	output reg wb_have_inst
    );
    

    always@(posedge clk or negedge rst_n)begin
        if(~rst_n  || pipeline_flush) begin //复位或者清零信号则内容清零
            mem_alu_value <= 32'b0;
            mem_dram_value <= 32'b0;
            mem_PC <= 32'b0;
            mem_rd <= 5'b0;
            mem_Memsel <= 0;
            mem_RegWE <= 0;
            mem_WDataSel <= 0;
			wb_have_inst <= 0;
        end
        else if(pipeline_stop)begin
            mem_alu_value <=  mem_alu_value;
            mem_dram_value <= mem_dram_value;
            mem_PC <= mem_PC;
            mem_rd <= mem_rd;
            mem_Memsel <= mem_Memsel;
            mem_RegWE <= mem_RegWE;
            mem_WDataSel <= mem_WDataSel;
			wb_have_inst <= wb_have_inst;
        end
        else begin
            mem_alu_value <= exe_alu_value;
            mem_dram_value <= dram_value;
            mem_PC <= exe_PC;
            mem_rd <= exe_rd;
            mem_Memsel <= exe_Memsel;
            mem_RegWE <= exe_RegWE;
            mem_WDataSel <= exe_WDataSel;
			wb_have_inst <= mem_have_inst;
        end
    end
endmodule