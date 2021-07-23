
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
//	output        debug_wb_have_inst,   // WB闃舵鏄惁鏈夋寚浠?(瀵瑰崟鍛ㄦ湡CPU锛屾flag鎭掍负1)
//    output [31:0] debug_wb_pc,          // WB闃舵鐨凱C (鑻b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
//    output        debug_wb_ena,         // WB闃舵鐨勫瘎瀛樺櫒鍐欎娇鑳?(鑻b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
//    output [4:0]  debug_wb_reg,         // WB闃舵鍐欏叆鐨勫瘎瀛樺櫒鍙?(鑻b_ena鎴杦b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
//    output [31:0] debug_wb_value        // WB闃舵鍐欏叆瀵勫瓨鍣ㄧ殑鍊?(鑻b_ena鎴杦b_have_inst=0锛屾椤瑰彲涓轰换鎰忓€?
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
    
    wire [31:0] pc_from_pc;//从pc模块传出的pc信号
    wire [31:0] instruction; //指令
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
    .PC_out(pc_from_pc) //从pc传出的pc信号
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
    //CTRL单元产生的控制信号
    .Memsel(MemSel), //选择传入rf的是ALU_value还是Mem_value
    .PCsel(PCSel),
    .ALUop(ALUop),
    .RegWE(RegWriteEn),
    .WDataSel(WDataSel), //控制写入RF的是PC+4还是MemSel选择后的信号
    .MemWriteEn(MemWriteEn),
    //寄存器值和相关信息
    .rs1(rs1),
    .rs2(rs2),//读取数据的寄存器号，不需要输出，在id阶段判断是否存在数据冒险,
    .rd(rd), //计算结果写入的寄存器号
    .rs1_value(rs1_value_pass_in), //寄存器值
    .rs2_value(rs2_value_pass_in),  
    //操作数控制和传入
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
    .Asel(Asel_from_id_exe),//A多路选择信号
    .B(rs2_value_from_id_exe),
    .Imm(Imm_from_id_exe),
    .Bsel(Bsel_from_id_exe),//B多路选择信号
    .ALUop(ALUop_from_id_exe),
    //output
    .value(alu_value),
    .Branch(branch), //分支判断信号
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
    .pipeline_flush((exe_mem_flush_from_CHD | exe_mem_flush_from_DHD)),//清零信号
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
//    .a(alu_value_from_exe_mem[15:2]), //鍦板潃灏辨槸缁忚繃ALU璁＄畻杈撳嚭鐨勭粨鏋?
//    .spo(data_from_mem),
//    .we(MemWriteEn_from_exe_mem),
//    .d(rs2_value_from_exe_mem)//鍐欏叆鐨勫叾瀹炲氨鏄痳s2
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
    .pipeline_flush((mem_wb_flush_from_CHD | mem_wb_flush_from_DHD)),//清零信号
    .mem_have_inst(mem_have_inst),
    //value
    .exe_alu_value(alu_value_from_exe_mem),
    .dram_value(data_from_mem) ,//DataRam读取的数据
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
    
    .pcsel(PCsel_final),//如果传入的pcsel是00，就表示当前指令不需要跳转，继续执行就完事了，如果是别的就表示需要跳转，这个时候某些（if/id,id/ex）寄存器需要清零
    //output
    .select_pc(selected_pc), //该信号的作用是选择传入npc的pc是顺延的pc+4还是从id/exe寄存器传回的pc,只有要跳转的时候才不是pc+4
    
    .if_id_flush(if_id_flush_from_CHD),
    .id_exe_flush(id_exe_flush_from_CHD),
    .exe_mem_flush(exe_mem_flush_from_CHD),
    .mem_wb_flush(mem_wb_flush_from_CHD), //流水线寄存器清空信号
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
    //由控制单元产生控制信号
    .exe_we(RegWE_from_id_exe),
	.mem_we(RegWE_from_exe_mem),
	.wb_we(RegWE_from_mem_wb),
    .re1(re1),
    .re2(re2), 
    //传回
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
    .PC_stop(pc_stop) ,// 更新PC
    
    .if_id_flush(if_id_flush_from_DHD_temp),
    .id_exe_flush(id_exe_flush_from_DHD_temp),
    .exe_mem_flush(exe_mem_flush_from_DHD_temp),
    .mem_wb_flush(mem_wb_flush_from_DHD_temp), //流水线寄存器清零信号
	
	.data1_forward(data1_forward),
	.rs1_value_sel(rs1_value_sel),
	
	.data2_forward(data2_forward),
	.rs2_value_sel(rs2_value_sel)
    );
    
endmodule
