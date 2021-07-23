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

//�Ĵ���ģ�飬ʱ���߼���·,����32��32λ�Ĵ���
module RF(
    input wire clk,
    input wire rst_n,
    input wire [4:0]rd,
    input wire [4:0]rs1,
    input wire [4:0]rs2,
    input wire [31:0]PC, //�������PC_out,Ҫ����ΪPC + 4
    input wire [31:0]DataIn,
    input wire WDataSel,//���ź�����ѡ��д��rd����PC+4����ALU������������Mem�ж�ȡ������,���Ƶ�Ԫ����
    input wire WEn,//дʹ���ź�
    output reg [31:0]Data1,//��Ӧ��rs1����������
    output reg [31:0]Data2, //��Ӧ��rs2����������
	output wire [31:0]data_pass_in,
	output reg [31:0] value_from_reg19
    );

reg [31:0]DataReg[31:0];
wire [31:0]DataW;
integer i;
assign DataW = (WDataSel == 1)? DataIn : PC+4;
assign data_pass_in = DataW;
//ûд������֮ǰȫ����ʼ��Ϊ0


//������PC���£�ͬʱDataд��Ĵ���
always@(posedge clk or negedge rst_n)begin
	if(rst_n == 0) begin
        for (i = 0;i < 32;i = i + 1)
            DataReg[i] <= 32'b0;
    end
    else if(WEn == 1 && rd != 5'b0) //0�Ĵ��������޸�
        DataReg[rd] <= DataW;
	else begin end
end


always@(*) begin   
        Data1 = (rs1 == 5'b0)? 32'b0: DataReg[rs1];
        Data2 = (rs2 == 5'b0)? 32'b0: DataReg[rs2];
        value_from_reg19 = DataReg[19];
end

endmodule

