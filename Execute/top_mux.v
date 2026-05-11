`timescale 1ns / 1ps
// 32-bit 2-to-1 mux: selects between rdata2 and s_extend based on ALUSrc
// alusrc=0 -> use rdata2 (R-type)
// alusrc=1 -> use s_extend (I-type / load / store)
module top_mux(
    output wire [31:0] y,       // goes to ALU input b
    input  wire [31:0] a,       // s_extend (immediate)
    input  wire [31:0] b,       // rdata2 (register)
    input  wire        alusrc   // control signal
);
    assign y = (alusrc) ? a : b;
endmodule