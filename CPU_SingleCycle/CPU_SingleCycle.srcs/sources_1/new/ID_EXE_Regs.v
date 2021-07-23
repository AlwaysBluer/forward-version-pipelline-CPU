`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 15:15:08
// Design Name: 
// Module Name: ID_EXE_Regs
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


module ID_EXE_Regs(
    input wire clk,
    input wire rst_n,
    input wire pipeline_stop,
    input wire pipeline_flush,
    input wire id_have_inst,
	
    //CTRL单元产生的控制信号
    input wire Memsel, //选择传入rf的是ALU_value还是Mem_value
    input wire [1:0]PCsel,
    input wire [4:0]ALUop,
    input wire RegWE,
    input wire WDataSel, //控制写入RF的是PC+4还是MemSel选择后的信号
    input wire MemWriteEn,
    //寄存器值和相关信息
    input wire [4:0] rs1,
    input wire [4:0] rs2,//读取数据的寄存器号，不需要输出，在id阶段判断是否存在数据冒险,
    input wire [4:0] rd, //计算结果写入的寄存器号
    input wire [31:0] rs1_value, //寄存器值
    input wire [31:0] rs2_value, 
    //操作数控制和传入
    input wire Asel,
    input wire Bsel,  
    input wire [31:0]PC,
    input wire [31:0]Imm,
    
    //output
    output reg id_Memsel,
    output reg [1:0]id_PCsel,
    output reg [4:0]id_ALUop,
    output reg id_RegWE,
    output reg id_WDataSel,
    output reg id_MemWriteEn,
    
    output reg [4:0] id_rd,
    output reg [31:0] id_rs1_value,
    output reg [31:0] id_rs2_value,
    
    output reg id_Asel,
    output reg id_Bsel,
    output reg [31:0] id_PC,
    output reg [31:0] id_Imm,
	output reg exe_have_inst
    );
	

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n  || pipeline_flush) begin //复位或者清零信号则内容清零
            id_Memsel <= 0;
            id_PCsel <= 2'b00;
            id_ALUop <= 5'b0;
            id_RegWE <= 0;
            id_WDataSel <= 0;
            id_MemWriteEn <= 0;
            id_rd <= 5'b0;
            id_rs1_value <= 32'b0;
            id_rs2_value <= 32'b0;
            id_Asel <= 0;
            id_Bsel <= 0;
            id_PC <= 32'b0;
            id_Imm <= 32'b0;
			exe_have_inst <= 0;
        end
        else if(pipeline_stop) begin//流水线暂停
            id_Memsel <= id_Memsel;
            id_PCsel <= id_PCsel;
            id_ALUop <= id_ALUop;
            id_RegWE <= id_RegWE;
            id_WDataSel <= id_WDataSel;
            id_MemWriteEn <= id_MemWriteEn;
            id_rd <= id_rd;
            id_rs1_value <= id_rs1_value;
            id_rs2_value <= id_rs2_value;
            id_Asel <= id_Asel;
            id_Bsel <= id_Bsel;
            id_PC <= id_PC;
            id_Imm <= id_Imm;
			exe_have_inst <= exe_have_inst;
        end
        else begin
            id_Memsel <= Memsel;
            id_PCsel <= PCsel;
            id_ALUop <= ALUop;
            id_RegWE <= RegWE;
            id_WDataSel <= WDataSel;
            id_MemWriteEn <= MemWriteEn;
            id_rd <= rd;
            id_rs1_value <= rs1_value;
            id_rs2_value <= rs2_value;
            id_Asel <= Asel;
            id_Bsel <= Bsel;
            id_PC <= PC;
            id_Imm <= Imm;
			exe_have_inst <= id_have_inst;
        end
    end
endmodule
