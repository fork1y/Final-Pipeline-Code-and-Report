`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:46:55 PM
// Design Name: 
// Module Name: tb_ifIdLatch
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


module tb_ifIdLatch(
    );
    
    reg clk, rst;
    reg [31:0] pc_in, instr_in;
    wire [31:0] pc_out, instr_out;

    ifIdLatch uut (.clk(clk),.rst(rst),.pc_in(pc_in),
                   .instr_in(instr_in),.pc_out(pc_out),.instr_out(instr_out));
    initial clk = 0; always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_ifIdLatch.vcd"); $dumpvars(0, tb_ifIdLatch);
        rst = 1; pc_in = 32'hDEAD; instr_in = 32'hBEEF; #12;
        $display("rst=1 -> pc_out=%h instr_out=%h (expect 0s)", pc_out, instr_out);
        rst = 0;
        pc_in = 32'h1; instr_in = 32'hA00000AA; #10;
        $display("pc_in=1 instr=A00000AA -> pc_out=%h instr_out=%h", pc_out, instr_out);
        pc_in = 32'h2; instr_in = 32'h10000011; #10;
        $display("pc_in=2 instr=10000011 -> pc_out=%h instr_out=%h", pc_out, instr_out);
        $finish;
    end
endmodule
