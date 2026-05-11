`timescale 1ns/1ps

/* WB stage:
 * WBControl[1] = RegWrite
 * WBControl[0] = MemtoReg (1: memory data, 0: ALU result)
 */
module wb_stage (
    input  wire [1:0]  WBControl,
    input  wire [31:0] ReadData,
    input  wire [31:0] ALUResult,
    input  wire [4:0]  WriteReg_in,
    output wire        RegWrite,
    output wire [31:0] WriteData,
    output wire [4:0]  WriteReg_out
);

    assign RegWrite    = WBControl[1];
    assign WriteData   = (WBControl[0]) ? ReadData : ALUResult;
    assign WriteReg_out = WriteReg_in;

endmodule
