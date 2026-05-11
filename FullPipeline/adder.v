`timescale 1ns / 1ps
// Adds NPC + SignExtend to compute branch target address
module adder(
    input  wire [31:0] add_in1,  // NPC
    input  wire [31:0] add_in2,  // sign extended immediate
    output wire [31:0] add_out   // branch target address
);
    assign add_out = add_in1 + add_in2;
endmodule