`timescale 1ns / 1ps
// 5-bit 2-to-1 mux: selects destination register
// regdst=0 -> instr[20:16] (I-type rt)
// regdst=1 -> instr[15:11] (R-type rd)
module bottom_mux(
    output wire [4:0] y,    // selected destination register
    input  wire [4:0] a,    // instr[15:11] (rd) - sel=1
    input  wire [4:0] b,    // instr[20:16] (rt) - sel=0
    input  wire       sel   // RegDst control signal
);
    assign y = sel ? a : b;
endmodule