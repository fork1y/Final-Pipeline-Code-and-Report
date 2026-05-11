`timescale 1ns / 1ps

module mips_pipeline (
    input wire clk,
    input wire rst
);
    // IF/ID signals
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // WB -> Decode feedback
    wire        wb_reg_write;
    wire [4:0]  wb_write_reg;
    wire [31:0] wb_write_data;

    // ID/EX signals
    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0]  id_ex_instr_20_16;
    wire [4:0]  id_ex_instr_15_11;

    // EX/MEM signals
    wire [1:0]  ex_mem_wb;
    wire [2:0]  ex_mem_mem;
    wire [31:0] ex_mem_npc;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_write_data;
    wire [4:0]  ex_mem_write_reg;
    wire        ex_mem_zero;

    // MEM/WB data path
    wire [31:0] mem_read_data;
    wire [31:0] mem_alu_result;
    wire [4:0]  mem_write_reg;
    wire [1:0]  mem_wb_control;

    // Branch control back to fetch
    wire pc_src;

    fetch u_fetch (
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );

    decode u_decode (
        .clk(clk),
        .rst(rst),
        .wb_reg_write(wb_reg_write),
        .wb_write_reg_location(wb_write_reg),
        .mem_wb_write_data(wb_write_data),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb),
        .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute),
        .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1),
        .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_20_16),
        .id_ex_bits_15_11(id_ex_instr_15_11)
    );

    execute u_execute (
        .clk(clk),
        .rst(rst),
        .ctlwb_in(id_ex_wb),
        .ctlm_in(id_ex_mem),
        .alusrc(id_ex_execute[0]),
        .regdst(id_ex_execute[3]),
        .alu_op(id_ex_execute[2:1]),
        .funct(id_ex_sign_ext[5:0]),
        .npc(id_ex_npc),
        .rdata1(id_ex_readdat1),
        .rdata2(id_ex_readdat2),
        .s_extend(id_ex_sign_ext),
        .instr_2016(id_ex_instr_20_16),
        .instr_1511(id_ex_instr_15_11),
        .ctlwb_out(ex_mem_wb),
        .ctlm_out(ex_mem_mem),
        .adder_out(ex_mem_npc),
        .alu_result_out(ex_mem_alu_result),
        .rdata2_out(ex_mem_write_data),
        .muxout_out(ex_mem_write_reg),
        .zero(ex_mem_zero)
    );

    mem_stage u_mem_stage (
        .clk(clk),
        .ALUResult(ex_mem_alu_result),
        .WriteData(ex_mem_write_data),
        .WriteReg(ex_mem_write_reg),
        .WBControl(ex_mem_wb),
        .MemWrite(ex_mem_mem[0]),
        .MemRead(ex_mem_mem[1]),
        .Branch(ex_mem_mem[2]),
        .Zero(ex_mem_zero),
        .ReadData(mem_read_data),
        .ALUResult_out(mem_alu_result),
        .WriteReg_out(mem_write_reg),
        .WBControl_out(mem_wb_control),
        .PCSrc(pc_src)
    );

    wb_stage u_wb_stage (
        .WBControl(mem_wb_control),
        .ReadData(mem_read_data),
        .ALUResult(mem_alu_result),
        .WriteReg_in(mem_write_reg),
        .RegWrite(wb_reg_write),
        .WriteData(wb_write_data),
        .WriteReg_out(wb_write_reg)
    );

endmodule
