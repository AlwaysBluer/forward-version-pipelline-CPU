`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/01 20:38:17
// Design Name: 
// Module Name: ImmGenerator
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

//���������ɵ�Ԫ������߼�ʵ��
module ImmGenerator(
    input wire[31:7] Inst,
    input wire[2:0] ImmSel,
    output reg[31:0] SelectedImm//����ImmSel�ź�ѡ������������������
    );

wire [31:0]i_Imm;
wire [31:0]i_Imm_1;
wire [31:0]i_Imm_2;
wire [31:0]s_Imm;
wire [31:0]u_Imm;
wire [31:0]b_Imm;
wire [31:0]j_Imm;

//I�����������ɣ�
assign i_Imm_1 = (Inst[31] == 1'b1)? {20'hfffff, Inst[31:20]} : {20'h00000,Inst[31:20]};
assign i_Imm_2 = {27'b0, Inst[24:20]};
assign i_Imm = (Inst[14:12] == 3'b101 && Inst[30] == 1'b1)? i_Imm_2 : i_Imm_1;
//s��������
assign s_Imm = (Inst[31] == 1'b1)? {20'hfffff, Inst[31:25], Inst[11:7]} : {20'h00000, Inst[31:25], Inst[11:7]};
//U��������
assign u_Imm = {Inst[31:12]  ,12'h000};
//b��������
assign b_Imm = (Inst[31] == 1'b1)? {20'hfffff, Inst[7], Inst[30:25], Inst[11:8],1'b0}:{20'h00000, Inst[7], Inst[30:25], Inst[11:8],1'b0};
//j
assign j_Imm =  (Inst[31] == 1'b1)? {12'hfff,Inst[19:12],Inst[20],Inst[30:21],1'b0}:{12'h000,Inst[19:12],Inst[20],Inst[30:21],1'b0};
//r_Imm

always@(*)begin
    case(ImmSel)
    3'b000: SelectedImm = i_Imm;
    3'b001: SelectedImm = s_Imm;
    3'b010: SelectedImm = u_Imm;
    3'b011: SelectedImm = b_Imm;
    3'b100: SelectedImm = j_Imm;
    default: SelectedImm = 32'h00000000;
    endcase
end

endmodule
