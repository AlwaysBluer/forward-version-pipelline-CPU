`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 22:17:37
// Design Name: 
// Module Name: DRAM
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


module DRAM(
    input wire clk_i,//时钟信号？干嘛的
    input wire [31:0]addr_i,//地址（写入或者读出）
    output wire [31:0]rd_data_o,//读出的数据
    input wire memwr_i, //内存写使能型号
    input wire[31:0]wr_data_i //要写入的数据
    );
     
    //DRAM读数据是输入地址马上给出数据吗
    //DRAM写数据是输入地址，输入数据后，什么时候写入数据
    wire [31:0] waddr_tmp = addr_i - 16'h4000;
    dram U_dram(
    .clk(clk_i),
    .a(waddr_tmp[15:2]),
    .spo(rd_data_o),
    .we(memwr_i),
    .d(wr_data_i)
    );
endmodule
