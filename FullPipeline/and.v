`timescale 1ns/1ps

module AND (
    input  wire membranch,
    input  wire zero,
    output wire PCSrc
);
    assign PCSrc = membranch & zero;
endmodule
