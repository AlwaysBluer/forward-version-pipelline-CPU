`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/06 10:21:44
// Design Name: 
// Module Name: CTRL_Unit
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

//���Ƶ�Ԫ������߼�ʵ��
module CTRL_Unit(
    input wire[6:0] opcode,
    input wire[4:0] rs1,
    input wire[4:0] rs2,
    input wire[2:0] func3,
    input wire[6:0] func7,
//    input wire Branch, //��֧�ж��źţ�����
    output reg re1,
    output reg re2, //��������ð�ռ�ⵥԪ���źţ������ж�rs1��rs2�żĴ����Ƿ��ڵ�ǰָ�����ж��Ĳ���
    output reg[2:0] ImmSel,//���������ѡ���ź�,��ӦI, S��U, B
    output reg op_A_sel,// A·�����ź�ѡ��0ΪPC��1Ϊrs1
    output reg op_B_sel,// B·�����ź�ѡ��0Ϊ��������1Ϊrs2
    output reg[4:0] ALUop, //ALU�����ź�
    output reg WDataSel,//����д��rd����PC+4 ���� ALU_value / Mem_data ѡ�����ֵ
    output reg MemSel,  //�������ΪALU_value-0 / Mem_data-1�е�һ��
    output reg MemWriteEn, //д��Mem��ʹ���ź� 
    output reg RegWriteEn, //�Ĵ���дʹ���ź�
    output reg[1:0]PCSel
    );
    
    always@(*) begin
        case(opcode)
        //R��ָ��
        7'b0110011:
             begin
               
                if(func3 == 3'b000 && func7 == 7'b0000000) begin//add
                    ALUop <= 5'b00000;
					ImmSel <= 3'b000; //���漰��������������������ν
					op_A_sel <= 1;
					op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
					re1 <= 1;
					re2 <= 1;
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b000 && func7 == 7'b0100000) begin//sub
                    ALUop <= 5'b00001;
					ImmSel <= 3'b000; //���漰��������������������ν
					op_A_sel <= 1;
					op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b111 && func7 == 7'b0000000) begin//and
                    ALUop <= 5'b00101;
					ImmSel <= 3'b000; //���漰��������������������ν
					op_A_sel <= 1;
					op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b110 && func7 == 7'b0000000) begin//or
                    ALUop <= 5'b00100;
					ImmSel <= 3'b000; //���漰��������������������ν
					op_A_sel <= 1;
					op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b100 && func7 == 7'b0000000) begin//xor
                    ALUop <= 5'b00110;
					ImmSel <= 3'b000; //���漰��������������������ν
					op_A_sel <= 1;
					op_B_sel <= 1;//ȫ��Ϊ�Ĵ���������
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//sll
                    ALUop <= 5'b00010;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;//�Ĵ���rs2���ڵ�5λ�������������н�����λ����
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srl
                    ALUop <= 5'b00011;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;///�Ĵ���rs2���ڵ�5λ�������������н�����λ����
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//��������sra
                    ALUop <= 5'b00111;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;///�Ĵ���rs2���ڵ�5λ�������������н�����λ����
					re1 <= 1;
					re2 <= 1;//�����Ĵ�����������������Ҫ����alu����
					WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
					MemSel <= 0; //�������ΪALU_value-0 
					MemWriteEn <= 0;//��д���ڴ�
					RegWriteEn <= 1;//����rd
					PCSel <= 2'b00;//PC = PC + 4
				end
             end
         //I��ָ��
         7'b0010011:
            begin
                if(func3 == 3'b000) begin//addi
                    ALUop <= 5'b00000;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b111) begin//andi
                    ALUop <= 5'b00101;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b110) begin//ori
                    ALUop <= 5'b00100;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b100) begin//xori
                    ALUop <= 5'b00110;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//slli
                    ALUop <= 5'b00010;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srli
                    ALUop <= 5'b00011;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//srai
                    ALUop <= 5'b00111;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //AΪ�Ĵ���������
                    op_B_sel <= 0; //BΪ������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 0; //�������ΪALU_value-0 
                    MemWriteEn <= 0;//��д���ڴ�
                    RegWriteEn <= 1;//����rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
       
             else begin end
            end
            
         7'b0000011:begin//lw
                    ALUop <= 5'b00000; 
                    ImmSel <= 3'b000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;//������
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 1;//д������ΪDataIn  ALU_value / Mem_data ѡ�����ֵ
                    MemSel <= 1;//ѡ��Mem_data
                    MemWriteEn <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b00;// PC = PC + 4��
         end
         
         7'b1100111:begin //jalr
                    ImmSel <= 3'b000;
                    ALUop <= 5'b00000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;
                    re1 <= 1;
                    re2 <= 0; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                    WDataSel <= 0; //д��rd��ΪPC+4
                    MemSel <= 0;
                    MemWriteEn <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b11; //д��PC��ΪPCC
         end
         
         7'b0100011: begin //S��ָ�� sw�����Ĵ���rs2�����ڴ��ַ(rs1)+sext(offset),���ָ��ͨ��ALU�����ַ������Ҫд��Ĵ�����
            if(func3 == 3'b010) begin
                ImmSel <= 3'b001;//S��������
                ALUop <= 5'b00000;//add����
                op_A_sel <= 1;//rs1
                op_B_sel <= 0;//������
                re1 <= 1;
                re2 <= 1; //��Ϊ��������������rs2�Ĵ������ݲ�����alu���㣬��˲�����Ϊ����Ĵ�������ð��
                WDataSel <= 1;
                MemSel <= 1;//�������ź���ʵûʲô�ã�
                MemWriteEn <= 1;
                RegWriteEn <= 0;
                PCSel <= 2'b00;// PC = PC + 4��
            end
            else  begin end
            end
         7'b1100011:begin//B��ָ��
           if(func3 == 3'b000)  begin//beq
                ImmSel <= 3'b011;
                ALUop <= 5'b01000;
                op_A_sel <= 1;
                op_B_sel <= 1;
                re1 <= 1;
                re2 <= 1;
                WDataSel <= 0;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 0;
                PCSel <= 2'b00; //branchΪ1�Ļ�PCΪPC+������������ΪPC+4
                                //branch�źŵĲ�������һ���׶Σ���˰�PCsel�������ɵ��źź�Branch�йأ�����һ���׶�
           end
           else if(func3 == 3'b001) begin//bne
                ImmSel <= 3'b011;
                ALUop <= 5'b01001;
                op_A_sel <= 1;
                op_B_sel <= 1;
                re1 <= 1;
                re2 <= 1;
                WDataSel <= 0;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 0;
                PCSel <=  2'b00;
           end
           else if(func3 == 3'b100) begin//blt
                ImmSel <= 3'b011;
                ALUop <= 5'b01010;
                op_A_sel <= 1;
                op_B_sel <= 1;
                re1 <= 1;
                re2 <= 1;
                WDataSel <= 0;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 0;
                PCSel <=  2'b00;
           end
           else if(func3 == 3'b101)begin//bge
                ImmSel <= 3'b011;
                ALUop <= 5'b01011;
                op_A_sel <= 1;
                op_B_sel <= 1;
                re1 <= 1;
                re2 <= 1;
                WDataSel <= 0;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 0;
                PCSel <=  2'b00;
           end
           else begin end
         end
         
         7'b0110111:begin//U��ָ��
         //lui:��������չ��20λ�������߼�����12λ�����д��Ĵ���rd��
                ImmSel <= 3'b010;
                ALUop <=  5'b01100;
                op_A_sel <= 1;
                op_B_sel <= 0; //������
                re1 <= 0;
                re2 <= 0; //���漰�Ĵ���������
                WDataSel <= 1;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 1;
                PCSel <= 2'b00;
         end
         
         7'b1101111:begin//j��ָ��     
                ImmSel <= 3'b100;
                ALUop <= 5'b00000;
                op_A_sel <= 1;
                op_B_sel <= 0;
                re1 <= 0;
                re2 <= 0; //���漰�Ĵ���������
                WDataSel <= 0;//д��pc+4
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 1;
                PCSel <= 2'b01;       
         end
         
         default:begin
            ImmSel <= 3'b000;
            ALUop <= 5'b00000;
            op_A_sel <= 1;
            op_B_sel <= 1;
            re1 <= 0;
            re2 <= 0; //���漰�Ĵ���������
            WDataSel <= 1;
            MemSel <= 0;
            MemWriteEn <= 0;
            RegWriteEn <= 0;
            PCSel <= 2'b00;
         end
        endcase
    end
    
    
endmodule