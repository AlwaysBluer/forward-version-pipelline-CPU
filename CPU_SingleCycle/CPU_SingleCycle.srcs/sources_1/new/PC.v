`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:26:34
// Design Name: 
// Module Name: PC
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

//时序逻辑部件PC
module PC(
    input wire clk,
    input wire rst_n,
    input wire[1:0]PCsel,
    input wire pc_stop,
	input wire shield_pc_stop,
    input wire [31:0]PC4, // PC <= PC + 4
    input wire [31:0]PC_offset,// PC <= PC + offset
    input wire [31:0]Rs1_offset,// PC <= (rs1) + offset
    input wire [31:0]PCC, //用于jalr指令
    output wire [31:0]PC_out
    );
    reg [31:0]PC;
    assign PC_out = PC;
    
  
    
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 0)//低电平复位
            PC <= 32'b0;
        else if(pc_stop & ~shield_pc_stop) begin //stop信号为1且屏蔽信号为0的时候，不更新
            PC <= PC;
        end
        else begin
            case(PCsel)
            2'b00: PC <= PC4;
            2'b01: PC <= PC_offset;
            2'b10: PC <= Rs1_offset;
            2'b11: PC <= PCC;
            default: PC <= PC4;
            endcase
        end
    end
endmodule