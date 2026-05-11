`timescale 1ns / 1ps
// EX/MEM Pipeline Latch
// Registers all Execute stage outputs on rising clock edge
// Outputs go to MEM stage and back to FETCH (branch target)
module ex_mem(
    input  wire        clk,
    input  wire        rst,
    // Control inputs
    input  wire [1:0]  ctlwb_out,   // WB control bits
    input  wire [2:0]  ctlm_out,    // MEM control bits {branch, memread, memwrite}
    // Data inputs
    input  wire [31:0] adder_out,   // branch target address
    input  wire        aluzero,     // zero flag from ALU
    input  wire [31:0] aluout,      // ALU result
    input  wire [31:0] readdat2,    // rdata2 (for store word)
    input  wire [4:0]  muxout,      // destination register (from bottom_mux)
    // Registered outputs
    output reg  [1:0]  wb_ctlout,
    output reg         branch,
    output reg         memread,
    output reg         memwrite,
    output reg  [31:0] add_result,
    output reg         zero,
    output reg  [31:0] alu_result,
    output reg  [31:0] rdata2out,
    output reg  [4:0]  five_bit_muxout
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wb_ctlout      <= 2'b0;
            branch         <= 1'b0;
            memread        <= 1'b0;
            memwrite       <= 1'b0;
            add_result     <= 32'b0;
            zero           <= 1'b0;
            alu_result     <= 32'b0;
            rdata2out      <= 32'b0;
            five_bit_muxout <= 5'b0;
        end else begin
            wb_ctlout      <= ctlwb_out;
            branch         <= ctlm_out[2];
            memread        <= ctlm_out[1];
            memwrite       <= ctlm_out[0];
            add_result     <= adder_out;
            zero           <= aluzero;
            alu_result     <= aluout;
            rdata2out      <= readdat2;
            five_bit_muxout <= muxout;
        end
    end
endmodule