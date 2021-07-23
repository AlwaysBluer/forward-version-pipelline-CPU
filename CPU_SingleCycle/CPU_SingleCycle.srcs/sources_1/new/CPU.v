
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/17 23:30:48
// Design Name: 
// Module Name: CPU
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


module CPU(
    input wire clk,
    input wire rst_n,
    output wire [31:0] value_from_reg19
//	output        debug_wb_have_inst,   // WB阶段是否有指�?(对单周期CPU，此flag恒为1)
//    output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意��?
//    output        debug_wb_ena,         // WB阶段的寄存器写使�?(若wb_have_inst=0，此项可为任意��?
//    output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器�?(若wb_ena或wb_have_inst=0，此项可为任意��?
//    output [31:0] debug_wb_value        // WB阶段写入寄存器的�?(若wb_ena或wb_have_inst=0，此项可为任意��?
    );
    wire selected_pc;
    wire if_id_flush_from_CHD;
    wire id_exe_flush_from_CHD;
    wire exe_mem_flush_from_CHD;
    wire mem_wb_flush_from_CHD;
    
    wire pc_stop;
	wire shield_pc_stop;
	
	wire if_id_stop_temp;
    wire id_exe_stop_temp;
    wire exe_mem_stop_temp;
    wire mem_wb_stop_temp;
	
    wire if_id_stop = if_id_stop_temp & ~if_id_flush_from_CHD;
    wire id_exe_stop = id_exe_stop_temp & ~if_id_flush_from_CHD;
    wire exe_mem_stop = exe_mem_stop_temp & ~if_id_flush_from_CHD;
    wire mem_wb_stop = mem_wb_stop_temp & ~if_id_flush_from_CHD;
	
	wire if_id_flush_from_DHD_temp;
    wire id_exe_flush_from_DHD_temp;
    wire exe_mem_flush_from_DHD_temp;
    wire mem_wb_flush_from_DHD_temp;
	
    wire if_id_flush_from_DHD = if_id_flush_from_DHD_temp & ~if_id_flush_from_CHD;
    wire id_exe_flush_from_DHD = id_exe_flush_from_DHD_temp & ~if_id_flush_from_CHD;
    wire exe_mem_flush_from_DHD = exe_mem_flush_from_DHD_temp & ~if_id_flush_from_CHD;
    wire mem_wb_flush_from_DHD = mem_wb_flush_from_DHD_temp & ~if_id_flush_from_CHD;
    
    wire[31:0] pc_from_id_exe;
    wire[31:0] Imm_from_id_exe;
    wire[31:0] rs1_value_from_id_exe;
    wire[1:0] PCsel_final;
    
    wire [31:0] alu_value_from_mem_wb;
    wire [31:0] dram_value_from_mem_wb;
    wire [31:0]pc_from_mem_wb;
    wire [4:0]rd_from_mem_wb;
    wire Memsel_from_mem_wb;
    wire RegWE_from_mem_wb;
    wire WDataSel_from_mem_wb;
    
    wire [31:0] pc_from_pc;//��pcģ�鴫����pc�ź�
    wire [31:0] instruction; //ָ��
	wire id_have_inst;
	wire exe_have_inst;
	wire mem_have_inst;
	wire wb_have_inst;
	wire [31:0] data;

	assign data = (Memsel_from_mem_wb == 0)? alu_value_from_mem_wb: dram_value_from_mem_wb;
	
//	assign debug_wb_have_inst = wb_have_inst;
//	assign debug_wb_pc = pc_from_mem_wb;
//	assign debug_wb_ena = RegWE_from_mem_wb;
//	assign debug_wb_reg = rd_from_mem_wb;
//	assign debug_wb_value = (WDataSel_from_mem_wb == 1)? data : pc_from_mem_wb + 4;
	
	wire [31:0] data1_forward;
	wire rs1_value_sel;
	wire [31:0] data2_forward; //signal of forwarding	
	wire rs2_value_sel;
	
    Top_PC module_pc(
    .PCsel(PCsel_final),
    .pc_from_exe(pc_from_id_exe),
    .selected_pc(selected_pc),
    .pc_stop(pc_stop),
	.shield_pc_stop(shield_pc_stop),
    .clk(clk),
    .rst_n(rst_n),
    .Rs1_value(rs1_value_from_id_exe),
    .Imm(Imm_from_id_exe),
    //output
    .PC_out(pc_from_pc) //��pc������pc�ź�
    );
    
//	inst_mem imem(
//    .a(pc_from_pc[15:2]),
//    .spo(instruction)
//    );
   
   IROM irom(
   .PC(pc_from_pc),
   .instruction(instruction)
   );
    
    wire [31:0] inst_from_if_id;
    wire [31:0] pc_from_if_id;
    IF_ID_Regs if_id_regs(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop(if_id_stop),
    .pipeline_flush((if_id_flush_from_DHD | if_id_flush_from_CHD)),
    .inst(instruction),
    .PC(pc_from_pc),
    //output
    .if_inst(inst_from_if_id),
    .if_PC(pc_from_if_id),
	.id_have_inst(id_have_inst)
    );
    
    wire [31:0] rs1_value;
    wire [31:0] rs2_value;
    wire [4:0]rs1;
    wire [4:0]rs2;
    wire [4:0]rd;
    wire [6:0]opcode;
    
    assign rs1 = inst_from_if_id[19:15];
    assign rs2 = inst_from_if_id[24:20];
    assign rd = inst_from_if_id[11:7];
    assign opcode = inst_from_if_id[6:0];
    wire [31:0] data_pass_in;
	
    RF regfile(
    .clk(clk),
    .rst_n(rst_n),
    .rd(rd_from_mem_wb),
    .rs1(rs1),
    .rs2(rs2),
    .PC(pc_from_mem_wb),
    .DataIn(data),
    .WDataSel(WDataSel_from_mem_wb),
    .WEn(RegWE_from_mem_wb),
    //output
    .Data1(rs1_value),
    .Data2(rs2_value),
	.data_pass_in(data_pass_in),
	.value_from_reg19(value_from_reg19)
    );
    
    wire re1;
    wire re2;
    wire [2:0]ImmSel;
    wire op_A_sel;
    wire op_B_sel;
    wire [4:0]ALUop;
    wire WDataSel;
    wire MemSel;
    wire MemWriteEn;
    wire RegWriteEn;
    wire [1:0]PCSel;
    wire [2:0]func3;
    wire [6:0]func7;
    assign func3 = inst_from_if_id[14:12];
    assign func7 = inst_from_if_id[31:25];
    
    CTRL_Unit ctrl_unit(
    .opcode(opcode),
    .rs1(rs1),
    .rs2(rs2),
    .func3(func3),
    .func7(func7),
    //output
    .re1(re1),
    .re2(re2),
    .ImmSel(ImmSel),
    .op_A_sel(op_A_sel),
    .op_B_sel(op_B_sel),
    .ALUop(ALUop),
    .WDataSel(WDataSel),
    .MemSel(MemSel),
    .MemWriteEn(MemWriteEn),
    .RegWriteEn(RegWriteEn),
    .PCSel(PCSel)
    );
    
    wire [31:0] Imm;
    ImmGenerator immgenerator(
    .Inst(inst_from_if_id[31:7]),
    .ImmSel(ImmSel),
    //output
    .SelectedImm(Imm)
    );
    
   
    wire Memsel_from_id_exe;
    wire[1:0] PCsel_from_id_exe;
    wire[4:0] ALUop_from_id_exe;
    wire RegWE_from_id_exe;
    wire WDataSel_from_id_exe;
    wire[4:0] rd_from_id_exe;
//    wire[31:0] rs1_value_from_id_exe;
    wire[31:0] rs2_value_from_id_exe;
    wire Asel_from_id_exe;
    wire Bsel_from_id_exe;
//    wire[31:0] pc_from_id_exe;
//    wire[31:0] Imm_from_id_exe;
    wire MemWriteEn_from_id_exe;
	wire [31:0] rs1_value_pass_in;
	wire [31:0] rs2_value_pass_in;
	
	assign rs1_value_pass_in = (rs1_value_sel == 1)? data1_forward: rs1_value;
	assign rs2_value_pass_in = (rs2_value_sel == 1)? data2_forward: rs2_value;
	
    ID_EXE_Regs id_ex_regs(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop(id_exe_stop),
    .pipeline_flush((id_exe_flush_from_DHD | id_exe_flush_from_CHD)),
	.id_have_inst(id_have_inst),
    //CTRL��Ԫ�����Ŀ����ź�
    .Memsel(MemSel), //ѡ����rf����ALU_value����Mem_value
    .PCsel(PCSel),
    .ALUop(ALUop),
    .RegWE(RegWriteEn),
    .WDataSel(WDataSel), //����д��RF����PC+4����MemSelѡ�����ź�
    .MemWriteEn(MemWriteEn),
    //�Ĵ���ֵ�������Ϣ
    .rs1(rs1),
    .rs2(rs2),//��ȡ���ݵļĴ����ţ�����Ҫ�������id�׶��ж��Ƿ��������ð��,
    .rd(rd), //������д��ļĴ�����
    .rs1_value(rs1_value_pass_in), //�Ĵ���ֵ
    .rs2_value(rs2_value_pass_in),  
    //���������ƺʹ���
    .Asel(op_A_sel),
    .Bsel(op_B_sel),  
    .PC(pc_from_if_id),
    .Imm(Imm),
    
    //output
    .id_Memsel(Memsel_from_id_exe),
    .id_PCsel(PCsel_from_id_exe),
    .id_ALUop(ALUop_from_id_exe),
    .id_RegWE(RegWE_from_id_exe),
    .id_WDataSel(WDataSel_from_id_exe),
    .id_MemWriteEn(MemWriteEn_from_id_exe),
    .id_rd(rd_from_id_exe),
    .id_rs1_value(rs1_value_from_id_exe),
    .id_rs2_value(rs2_value_from_id_exe),
    
    .id_Asel(Asel_from_id_exe),
    .id_Bsel(Bsel_from_id_exe),
    .id_PC(pc_from_id_exe),
    .id_Imm(Imm_from_id_exe),
	.exe_have_inst(exe_have_inst)
    );
   
     wire[31:0] alu_value;
     wire branch;
     wire zero;
     ALU module_alu(
    .A(rs1_value_from_id_exe),
    .PC_out(pc_from_id_exe),
    .Asel(Asel_from_id_exe),//A��·ѡ���ź�
    .B(rs2_value_from_id_exe),
    .Imm(Imm_from_id_exe),
    .Bsel(Bsel_from_id_exe),//B��·ѡ���ź�
    .ALUop(ALUop_from_id_exe),
    //output
    .value(alu_value),
    .Branch(branch), //��֧�ж��ź�
    .zero(zero)
    );
    
//     wire[1:0] PCsel_final;
     PCsel_selected pcsel_selected(
    .PCsel(PCsel_from_id_exe),
    .Branch(branch),
    //output
    .PCsel_out(PCsel_final)
    );
    
   
    wire [31:0] alu_value_from_exe_mem;
    wire [31:0] pc_from_exe_mem;
    wire [31:0] rs2_value_from_exe_mem;
    wire [4:0] rd_from_exe_mem;
    wire Memsel_from_exe_mem;
    wire MemWriteEn_from_exe_mem;
    wire RegWE_from_exe_mem;
    wire WDataSel_from_exe_mem;
    EXE_MEM_Regs ex_mem_regs(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop(exe_mem_stop),
    .pipeline_flush((exe_mem_flush_from_CHD | exe_mem_flush_from_DHD)),//�����ź�
    .exe_have_inst(exe_have_inst),
    //value
    .alu_value(alu_value),
    .id_rs2_value(rs2_value_from_id_exe),
    .id_PC(pc_from_id_exe),
    .id_rd(rd_from_id_exe),
    
    //control unit signal in id/exe register
    .id_Memsel(Memsel_from_id_exe),
    .id_MemWrite(MemWriteEn_from_id_exe),
    .id_RegWE(RegWE_from_id_exe),
    .id_WDataSel(WDataSel_from_id_exe),
    
    //output
    .exe_alu_value(alu_value_from_exe_mem),
    .exe_PC(pc_from_exe_mem),
    .exe_rs2_value(rs2_value_from_exe_mem),
    .exe_rd(rd_from_exe_mem),
    //
    .exe_Memsel(Memsel_from_exe_mem),
    .exe_MemWrite(MemWriteEn_from_exe_mem),
    .exe_RegWE(RegWE_from_exe_mem),
    .exe_WDataSel(WDataSel_from_exe_mem),  
	.mem_have_inst(mem_have_inst)
    );
    
    wire [31:0]data_from_mem;
	
//    data_mem dmem(
//    .clk(clk),
//    .a(alu_value_from_exe_mem[15:2]), //地址就是经过ALU计算输出的结�?
//    .spo(data_from_mem),
//    .we(MemWriteEn_from_exe_mem),
//    .d(rs2_value_from_exe_mem)//写入的其实就是rs2
//    );
    
    DRAM dram(
    .clk_i(clk),
    .addr_i(alu_value_from_exe_mem),
    .rd_data_o(data_from_mem),
    .memwr_i(MemWriteEn_from_exe_mem),
    .wr_data_i(rs2_value_from_exe_mem)
    );
    
    
//    wire [31:0] alu_value_from_mem_wb;
//    wire [31:0] dram_value_from_mem_wb;
//    wire [31:0]pc_from_mem_wb;
//    wire [4:0]rd_from_mem_wb;
//    wire Memsel_from_mem_wb;
//    wire RegWE_from_mem_wb;
//    wire WDataSel_from_mem_wb;
    MEM_WB_Regs mem_wb_regs(
    .clk(clk),
    .rst_n(rst_n),
    .pipeline_stop(mem_wb_stop),
    .pipeline_flush((mem_wb_flush_from_CHD | mem_wb_flush_from_DHD)),//�����ź�
    .mem_have_inst(mem_have_inst),
    //value
    .exe_alu_value(alu_value_from_exe_mem),
    .dram_value(data_from_mem) ,//DataRam��ȡ������
    .exe_PC(pc_from_exe_mem),
    .exe_rd(rd_from_exe_mem),
    
    //signal
    .exe_Memsel(Memsel_from_exe_mem),
    .exe_RegWE(RegWE_from_exe_mem),
    .exe_WDataSel(WDataSel_from_exe_mem),
    
    //output 
    .mem_alu_value(alu_value_from_mem_wb),
    .mem_dram_value(dram_value_from_mem_wb),
    .mem_PC(pc_from_mem_wb),
    .mem_rd(rd_from_mem_wb),
    
    .mem_Memsel(Memsel_from_mem_wb),
    .mem_RegWE(RegWE_from_mem_wb),
    .mem_WDataSel(WDataSel_from_mem_wb),
	.wb_have_inst(wb_have_inst)
    );
    
//    wire selected_pc;
//    wire if_id_flush_from_CHD;
//    wire id_exe_flush_from_CHD;
//    wire exe_mem_flush_from_CHD;
//    wire mem_wb_flush_from_CHD;
    
    Ctrl_Hazard_Detector CHD(
     .clk(clk),
    .rst_n(rst_n),
    
    .pcsel(PCsel_final),//��������pcsel��00���ͱ�ʾ��ǰָ���Ҫ��ת������ִ�о������ˣ�����Ǳ�ľͱ�ʾ��Ҫ��ת�����ʱ��ĳЩ��if/id,id/ex���Ĵ�����Ҫ����
    //output
    .select_pc(selected_pc), //���źŵ�������ѡ����npc��pc��˳�ӵ�pc+4���Ǵ�id/exe�Ĵ������ص�pc,ֻ��Ҫ��ת��ʱ��Ų���pc+4
    
    .if_id_flush(if_id_flush_from_CHD),
    .id_exe_flush(id_exe_flush_from_CHD),
    .exe_mem_flush(exe_mem_flush_from_CHD),
    .mem_wb_flush(mem_wb_flush_from_CHD), //��ˮ�߼Ĵ�������ź�
	.shield_pc_stop(shield_pc_stop)
    );
    
//    wire pc_stop;
//    wire if_id_stop;
//    wire id_exe_stop;
//    wire exe_mem_stop;
//    wire mem_wb_stop;
//    wire if_id_flush_from_DHD;
//    wire id_exe_flush_from_DHD;
//    wire exe_mem_flush_from_DHD;
//    wire mem_wb_flush_from_DHD;


	
    Data_Hazard_Detector DHD(
    .rs1(rs1),
    .rs2(rs2),
    //�ɿ��Ƶ�Ԫ���������ź�
    .exe_we(RegWE_from_id_exe),
	.mem_we(RegWE_from_exe_mem),
	.wb_we(RegWE_from_mem_wb),
    .re1(re1),
    .re2(re2), 
    //����
	.Memsel_from_CTRL_Unit(Memsel_from_id_exe),
	.Memsel_from_exe_mem(Memsel_from_exe_mem),
	.Memsel_from_mem_wb(Memsel_from_mem_wb),
    .exe_rd(rd_from_id_exe),
    .mem_rd(rd_from_exe_mem),
    .wb_rd(rd_from_mem_wb),
    .exe_value(alu_value),
	.mem_value(alu_value_from_exe_mem),
	.wb_value(alu_value_from_mem_wb),
	.dram_value_from_mem(data_from_mem),
	.dram_value_from_mem_wb(dram_value_from_mem_wb),
	
    //output
    .if_id_stop(if_id_stop_temp),
    .id_exe_stop(id_exe_stop_temp),
    .exe_mem_stop(exe_mem_stop_temp),
    .mem_wb_stop(mem_wb_stop_temp),
    .PC_stop(pc_stop) ,// ����PC
    
    .if_id_flush(if_id_flush_from_DHD_temp),
    .id_exe_flush(id_exe_flush_from_DHD_temp),
    .exe_mem_flush(exe_mem_flush_from_DHD_temp),
    .mem_wb_flush(mem_wb_flush_from_DHD_temp), //��ˮ�߼Ĵ��������ź�
	
	.data1_forward(data1_forward),
	.rs1_value_sel(rs1_value_sel),
	
	.data2_forward(data2_forward),
	.rs2_value_sel(rs2_value_sel)
    );
    
endmodule
