`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 15:15:32
// Design Name: 
// Module Name: EXE_MEM_Regs
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


module EXE_MEM_Regs(
    input wire clk,
    input wire rst_n,
    input wire pipeline_stop,
    input wire pipeline_flush,//清零信号
    input wire exe_have_inst,
	
    input wire [4:0]id_rd,
    //value
    input wire [31:0]alu_value,
    input wire [31:0]id_rs2_value,
    input wire [31:0]id_PC,
    
    //control unit signal in id/exe register
    input wire id_Memsel,
    input wire id_MemWrite,
    input wire id_RegWE,
    input wire id_WDataSel,
    
    //output
    output reg [31:0] exe_alu_value,
    output reg [31:0] exe_PC,
    output reg [31:0] exe_rs2_value,
    output reg [4:0]  exe_rd,
    
    //
    output reg  exe_Memsel,
    output reg  exe_MemWrite,
    output reg  exe_RegWE,
    output reg  exe_WDataSel,
	output reg  mem_have_inst
    );
    

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n  || pipeline_flush) begin //复位或者清零信号则内容清零
            exe_alu_value <= 32'b0;
            exe_PC <= 32'b0;
            exe_rs2_value <= 32'b0;
            exe_rd <= 5'b0;
            exe_Memsel <= 0;
            exe_MemWrite <= 0;
            exe_RegWE <= 0;
            exe_WDataSel <= 0;
			mem_have_inst <= 0;
        end
        else if(pipeline_stop) begin
            exe_alu_value <= exe_alu_value;
            exe_PC <= exe_PC;
            exe_rs2_value <=exe_rs2_value;
            exe_rd <= exe_rd;
            exe_Memsel <= exe_Memsel;
            exe_MemWrite <= exe_MemWrite;
            exe_RegWE <= exe_RegWE;
            exe_WDataSel <= exe_WDataSel;
			mem_have_inst <= mem_have_inst;
          end
         else begin
            exe_alu_value <= alu_value;
            exe_PC <= id_PC;
            exe_rs2_value <= id_rs2_value;
            exe_rd <= id_rd;
            exe_Memsel <= id_Memsel;
            exe_MemWrite <= id_MemWrite;
            exe_RegWE <= id_RegWE;
            exe_WDataSel <= id_WDataSel;
			mem_have_inst <= exe_have_inst;
        end
    end
endmodule
