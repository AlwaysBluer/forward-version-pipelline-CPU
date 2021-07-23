`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/02 15:47:18
// Design Name: 
// Module Name: ALU
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

//ALU单元，组合逻辑实现
module ALU(
    input wire[31:0] A,
    input wire[31:0] PC_out,//PC传过来的信号
    input wire Asel,//A多路选择信号
    input wire[31:0] B,
    input wire[31:0] Imm,
    input wire Bsel,//B多路选择信号
    input wire [4:0] ALUop,
    output reg[31:0]value,
    output reg Branch, //分支判断信号
    output reg zero
    );
    
   wire [31:0]op_A;
   wire [31:0]op_B;
   wire [31:0]temp;
   assign op_A = (Asel == 1)? A: PC_out; //A的选择信号为1的时候，操作数为A,否则为NPC
   assign op_B = (Bsel == 1)? B: Imm; //B的选择信号为1的时候，操作数为B，否则为立即数Imm
   assign temp = op_A - op_B;

    //比较型指令的设计分为BranchCompare 和计算模块，前一个模块的作用是比较计算的结果并且更新相应的符号位，计算模块就是算跳转的地址
    always@(*)begin
        case(ALUop)
        5'b00000: begin value <= op_A + op_B;  Branch <= 0; end// 加法 add
        5'b00001: begin value <= op_A - op_B; Branch <= 0; end //减法 sub
        5'b00010: begin value <= op_A << op_B[4:0]; Branch <= 0; end //左移运算
        5'b00011: begin value <= op_A >> op_B[4:0]; Branch <= 0; end//右移运算，算数
        5'b00100: begin value <= op_A|op_B; Branch <= 0;  end  //或运算
        5'b00101: begin value <= op_A & op_B; Branch <= 0; end //与运算
        5'b00110: begin value <= op_A ^ op_B; Branch <= 0;  end //异或运算
        5'b00111: begin value <= ($signed(op_A)) >>> op_B[4:0]; Branch <= 0;  end
        5'b01000: Branch <= (op_A == op_B)? 1 : 0;//beq
        5'b01001: Branch <= (op_A != op_B)? 1 : 0;//bne
        5'b01010: Branch <= (temp[31] == 1'b1)? 1'b1 : 1'b0;               // (op_A < op_B)? 1 : 0;//blt
        5'b01011: Branch <= (temp[31] == 1'b0)? 1'b1 : 1'b0;//bge branch为1，则输出到控制单元生成事中控制信号的时候就必须要注意关于PCSel的生成
        5'b01100: begin value <= op_B; Branch <= 0;  end //lui指令，直接把生成的u型立即数写入到寄存器文件中
        default:  begin value <= 0; Branch <= 0;  end
        endcase
    end
endmodule
