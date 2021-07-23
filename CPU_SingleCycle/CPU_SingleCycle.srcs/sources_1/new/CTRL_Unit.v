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

//控制单元，组合逻辑实现
module CTRL_Unit(
    input wire[6:0] opcode,
    input wire[4:0] rs1,
    input wire[4:0] rs2,
    input wire[2:0] func3,
    input wire[6:0] func7,
//    input wire Branch, //分支判断信号，处理
    output reg re1,
    output reg re2, //传入数据冒险检测单元的信号，用来判断rs1，rs2号寄存器是否在当前指令中有读的操作
    output reg[2:0] ImmSel,//立即数输出选择信号,对应I, S，U, B
    output reg op_A_sel,// A路输入信号选择，0为PC，1为rs1
    output reg op_B_sel,// B路输入信号选择，0为立即数，1为rs2
    output reg[4:0] ALUop, //ALU控制信号
    output reg WDataSel,//控制写入rd的是PC+4 还是 ALU_value / Mem_data 选择输出值
    output reg MemSel,  //控制输出为ALU_value-0 / Mem_data-1中的一个
    output reg MemWriteEn, //写入Mem的使能信号 
    output reg RegWriteEn, //寄存器写使能信号
    output reg[1:0]PCSel
    );
    
    always@(*) begin
        case(opcode)
        //R型指令
        7'b0110011:
             begin
               
                if(func3 == 3'b000 && func7 == 7'b0000000) begin//add
                    ALUop <= 5'b00000;
					ImmSel <= 3'b000; //不涉及立即数操作，所以无所谓
					op_A_sel <= 1;
					op_B_sel <= 1;//全部为寄存器操作数
					re1 <= 1;
					re2 <= 1;
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b000 && func7 == 7'b0100000) begin//sub
                    ALUop <= 5'b00001;
					ImmSel <= 3'b000; //不涉及立即数操作，所以无所谓
					op_A_sel <= 1;
					op_B_sel <= 1;//全部为寄存器操作数
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b111 && func7 == 7'b0000000) begin//and
                    ALUop <= 5'b00101;
					ImmSel <= 3'b000; //不涉及立即数操作，所以无所谓
					op_A_sel <= 1;
					op_B_sel <= 1;//全部为寄存器操作数
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b110 && func7 == 7'b0000000) begin//or
                    ALUop <= 5'b00100;
					ImmSel <= 3'b000; //不涉及立即数操作，所以无所谓
					op_A_sel <= 1;
					op_B_sel <= 1;//全部为寄存器操作数
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b100 && func7 == 7'b0000000) begin//xor
                    ALUop <= 5'b00110;
					ImmSel <= 3'b000; //不涉及立即数操作，所以无所谓
					op_A_sel <= 1;
					op_B_sel <= 1;//全部为寄存器操作数
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//sll
                    ALUop <= 5'b00010;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;//寄存器rs2所在的5位当成立即数进行进行移位运算
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srl
                    ALUop <= 5'b00011;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;///寄存器rs2所在的5位当成立即数进行进行移位运算
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//算数右移sra
                    ALUop <= 5'b00111;
					ImmSel <= 3'b000;
					op_A_sel <= 1;
					op_B_sel <= 1;///寄存器rs2所在的5位当成立即数进行进行移位运算
					re1 <= 1;
					re2 <= 1;//两个寄存器读出来的数都需要参与alu计算
					WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
					MemSel <= 0; //控制输出为ALU_value-0 
					MemWriteEn <= 0;//不写入内存
					RegWriteEn <= 1;//存入rd
					PCSel <= 2'b00;//PC = PC + 4
				end
             end
         //I型指令
         7'b0010011:
            begin
                if(func3 == 3'b000) begin//addi
                    ALUop <= 5'b00000;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b111) begin//andi
                    ALUop <= 5'b00101;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b110) begin//ori
                    ALUop <= 5'b00100;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b100) begin//xori
                    ALUop <= 5'b00110;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b001 && func7 == 7'b0000000) begin//slli
                    ALUop <= 5'b00010;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                 end
                else if(func3 == 3'b101 && func7 == 7'b0000000) begin//srli
                    ALUop <= 5'b00011;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
                else if(func3 == 3'b101 && func7 == 7'b0100000) begin//srai
                    ALUop <= 5'b00111;
                    ImmSel <= 3'b000;
                    op_A_sel <= 1; //A为寄存器操作数
                    op_B_sel <= 0; //B为立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 0; //控制输出为ALU_value-0 
                    MemWriteEn <= 0;//不写入内存
                    RegWriteEn <= 1;//存入rd
                    PCSel <= 2'b00;//PC = PC + 4
                end
       
             else begin end
            end
            
         7'b0000011:begin//lw
                    ALUop <= 5'b00000; 
                    ImmSel <= 3'b000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;//立即数
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 1;//写入数据为DataIn  ALU_value / Mem_data 选择输出值
                    MemSel <= 1;//选择Mem_data
                    MemWriteEn <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b00;// PC = PC + 4；
         end
         
         7'b1100111:begin //jalr
                    ImmSel <= 3'b000;
                    ALUop <= 5'b00000;
                    op_A_sel <= 1;
                    op_B_sel <= 0;
                    re1 <= 1;
                    re2 <= 0; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                    WDataSel <= 0; //写入rd的为PC+4
                    MemSel <= 0;
                    MemWriteEn <= 0;
                    RegWriteEn <= 1;
                    PCSel <= 2'b11; //写入PC的为PCC
         end
         
         7'b0100011: begin //S型指令 sw：将寄存器rs2存入内存地址(rs1)+sext(offset),这个指令通过ALU计算地址，不需要写入寄存器中
            if(func3 == 3'b010) begin
                ImmSel <= 3'b001;//S型立即数
                ALUop <= 5'b00000;//add操作
                op_A_sel <= 1;//rs1
                op_B_sel <= 0;//立即数
                re1 <= 1;
                re2 <= 1; //因为是立即数，所以rs2寄存器内容不参与alu运算，因此不会因为这个寄存器产生冒险
                WDataSel <= 1;
                MemSel <= 1;//这两个信号其实没什么用？
                MemWriteEn <= 1;
                RegWriteEn <= 0;
                PCSel <= 2'b00;// PC = PC + 4；
            end
            else  begin end
            end
         7'b1100011:begin//B型指令
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
                PCSel <= 2'b00; //branch为1的话PC为PC+立即数，否则为PC+4
                                //branch信号的产生在下一个阶段，因此把PCsel最终生成的信号和Branch有关，在下一个阶段
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
         
         7'b0110111:begin//U型指令
         //lui:将符号扩展的20位立即数逻辑左移12位，结果写入寄存器rd。
                ImmSel <= 3'b010;
                ALUop <=  5'b01100;
                op_A_sel <= 1;
                op_B_sel <= 0; //立即数
                re1 <= 0;
                re2 <= 0; //不涉及寄存器操作数
                WDataSel <= 1;
                MemSel <= 0;
                MemWriteEn <= 0;
                RegWriteEn <= 1;
                PCSel <= 2'b00;
         end
         
         7'b1101111:begin//j型指令     
                ImmSel <= 3'b100;
                ALUop <= 5'b00000;
                op_A_sel <= 1;
                op_B_sel <= 0;
                re1 <= 0;
                re2 <= 0; //不涉及寄存器操作数
                WDataSel <= 0;//写入pc+4
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
            re2 <= 0; //不涉及寄存器操作数
            WDataSel <= 1;
            MemSel <= 0;
            MemWriteEn <= 0;
            RegWriteEn <= 0;
            PCSel <= 2'b00;
         end
        endcase
    end
    
    
endmodule