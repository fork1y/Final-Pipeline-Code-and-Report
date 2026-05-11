`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:18:33 PM
// Design Name: 
// Module Name: tb_mux
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


module tb_mux(
    );
    
    reg [31:0] a_true, b_false;
    reg sel;
    wire [31:0] y;

    mux uut (.y(y), .a_true(a_true), .b_false(b_false), .sel(sel));

    initial begin
        $dumpfile("tb_mux.vcd"); $dumpvars(0, tb_mux);
        a_true = 32'hAAAA_AAAA; b_false = 32'hBBBB_BBBB;
        sel = 0; #10; $display("sel=0 -> y=%h (expect AAAAAAAA)", y);
        sel = 1; #10; $display("sel=1 -> y=%h (expect BBBBBBBB)", y);
        sel = 0; a_true = 32'h0000_0005; #10; $display("sel=0 -> y=%h (expect 00000005)", y);
        $finish;
    end
endmodule
