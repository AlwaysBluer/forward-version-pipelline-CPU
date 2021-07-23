`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 14:36:39
// Design Name: 
// Module Name: RF
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

//寄存器模块，时序逻辑电路,含有32个32位寄存器
module RF(
    input wire clk,
    input wire rst_n,
    input wire [4:0]rd,
    input wire [4:0]rs1,
    input wire [4:0]rs2,
    input wire [31:0]PC, //传入的是PC_out,要更新为PC + 4
    input wire [31:0]DataIn,
    input wire WDataSel,//该信号用以选择写入rd的是PC+4还是ALU计算结果或者是Mem中读取的数据,控制单元生成
    input wire WEn,//写使能信号
    output reg [31:0]Data1,//对应于rs1读出的数据
    output reg [31:0]Data2, //对应于rs2读出的数据
	output wire [31:0]data_pass_in,
	output reg [31:0] value_from_reg19
    );

reg [31:0]DataReg[31:0];
wire [31:0]DataW;
integer i;
assign DataW = (WDataSel == 1)? DataIn : PC+4;
assign data_pass_in = DataW;
//没写入数据之前全部初始化为0


//上升沿PC更新，同时Data写入寄存器
always@(posedge clk or negedge rst_n)begin
	if(rst_n == 0) begin
        for (i = 0;i < 32;i = i + 1)
            DataReg[i] <= 32'b0;
    end
    else if(WEn == 1 && rd != 5'b0) //0寄存器不能修改
        DataReg[rd] <= DataW;
	else begin end
end


always@(*) begin   
        Data1 = (rs1 == 5'b0)? 32'b0: DataReg[rs1];
        Data2 = (rs2 == 5'b0)? 32'b0: DataReg[rs2];
        value_from_reg19 = DataReg[19];
end

endmodule

