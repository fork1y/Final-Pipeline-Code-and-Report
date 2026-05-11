`timescale 1ns / 1ps

module mips_pipeline_tb;
    reg clk;
    reg rst;
    integer cycle;

    mips_pipeline uut (
        .clk(clk),
        .rst(rst)
    );

    // Top-level debug probes for waveform capture.
    wire [31:0] tb_pc;
    wire [31:0] tb_if_id_instr;
    wire [31:0] tb_if_id_npc;
    wire [31:0] tb_ex_mem_alu_result;
    wire [4:0]  tb_ex_mem_write_reg;
    wire [31:0] tb_mem_read_data;
    wire [31:0] tb_wb_write_data;
    wire [4:0]  tb_wb_write_reg;
    wire        tb_pcsrc;
    wire [31:0] tb_r1;
    wire [31:0] tb_r2;
    wire [31:0] tb_r3;

    assign tb_pc                = uut.u_fetch.pc0.pc_out;
    assign tb_if_id_instr       = uut.if_id_instr;
    assign tb_if_id_npc         = uut.if_id_npc;
    assign tb_ex_mem_alu_result = uut.ex_mem_alu_result;
    assign tb_ex_mem_write_reg  = uut.ex_mem_write_reg;
    assign tb_mem_read_data     = uut.mem_read_data;
    assign tb_wb_write_data     = uut.wb_write_data;
    assign tb_wb_write_reg      = uut.wb_write_reg;
    assign tb_pcsrc             = uut.pc_src;
    assign tb_r1                = uut.u_decode.rf0.REG[1];
    assign tb_r2                = uut.u_decode.rf0.REG[2];
    assign tb_r3                = uut.u_decode.rf0.REG[3];

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    initial begin
        cycle = 0;
        rst = 1'b1;
        #10 rst = 1'b0;

        #220;
        $display("FINAL REGISTERS: r1=%0d r2=%0d r3=%0d",
                 tb_r1,
                 tb_r2,
                 tb_r3);
        if (tb_r1 == 32'd12) begin
            $display("PASS: r1 is 12 as expected.");
        end else begin
            $display("FAIL: expected r1=12.");
        end
        $finish;
    end

    always @(posedge clk) begin
        cycle = cycle + 1;
        if (!rst) begin
            $display("Cycle %0d | PC=%0d | IF/ID instr=%h | r1=%0d r2=%0d r3=%0d",
                     cycle,
                     tb_pc,
                     tb_if_id_instr,
                     tb_r1,
                     tb_r2,
                     tb_r3);
        end
    end

endmodule
