`timescale 1ns/1ps

/* MEM stage:
 * - Computes PCSrc = Branch & Zero
 * - Accesses data memory
 * - Latches values into MEM/WB register
 */
module mem_stage (
    input  wire        clk,
    input  wire [31:0] ALUResult,
    input  wire [31:0] WriteData,
    input  wire [4:0]  WriteReg,
    input  wire [1:0]  WBControl,
    input  wire        MemWrite,
    input  wire        MemRead,
    input  wire        Branch,
    input  wire        Zero,
    output wire [31:0] ReadData,
    output wire [31:0] ALUResult_out,
    output wire [4:0]  WriteReg_out,
    output wire [1:0]  WBControl_out,
    output wire        PCSrc
);

    wire [31:0] read_data_mem;

    AND and_u (
        .membranch(Branch),
        .zero(Zero),
        .PCSrc(PCSrc)
    );

    data_memory data_mem_u (
        .clk(clk),
        .addr(ALUResult),
        .write_data(WriteData),
        .memread(MemRead),
        .memwrite(MemWrite),
        .read_data(read_data_mem)
    );

    mem_wb mem_wb_u (
        .clk(clk),
        .control_wb_in(WBControl),
        .read_data_in(read_data_mem),
        .alu_result_in(ALUResult),
        .write_reg_in(WriteReg),
        .control_wb_out(WBControl_out),
        .read_data(ReadData),
        .mem_alu_result(ALUResult_out),
        .mem_write_reg(WriteReg_out)
    );

endmodule

/* Compatibility wrapper using the original naming/signature style. */
module MEMORY (
    input  wire        clk,
    input  wire [1:0]  wb_ctlout,
    input  wire        branch,
    input  wire        memread,
    input  wire        memwrite,
    input  wire        zero,
    input  wire [31:0] alu_result,
    input  wire [31:0] rdata2out,
    input  wire [4:0]  five_bit_muxout,
    output wire        MEM_PCSrc,
    output wire        MEM_WB_regwrite,
    output wire        MEM_WB_memtoreg,
    output wire [31:0] read_data,
    output wire [31:0] mem_alu_result,
    output wire [4:0]  mem_write_reg
);
    wire [1:0] wb_control_out;

    mem_stage u_mem_stage (
        .clk(clk),
        .ALUResult(alu_result),
        .WriteData(rdata2out),
        .WriteReg(five_bit_muxout),
        .WBControl(wb_ctlout),
        .MemWrite(memwrite),
        .MemRead(memread),
        .Branch(branch),
        .Zero(zero),
        .ReadData(read_data),
        .ALUResult_out(mem_alu_result),
        .WriteReg_out(mem_write_reg),
        .WBControl_out(wb_control_out),
        .PCSrc(MEM_PCSrc)
    );

    assign MEM_WB_regwrite = wb_control_out[1];
    assign MEM_WB_memtoreg = wb_control_out[0];

endmodule
