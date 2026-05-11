`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:20:07 PM
// Design Name: 
// Module Name: tb_pc
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


module tb_pc(
    );
    
    reg clk, rst;
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    pc uut (.clk(clk), .rst(rst), .pc_in(pc_in), .pc_out(pc_out));
    initial clk = 0; always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_pc.vcd"); $dumpvars(0, tb_pc);
        rst = 1; pc_in = 32'hDEAD_BEEF; #12;
        $display("rst=1 -> pc_out=%h (expect 00000000)", pc_out);
        rst = 0;
        pc_in = 32'h1; #10; $display("pc_in=1 -> pc_out=%h", pc_out);
        pc_in = 32'h2; #10; $display("pc_in=2 -> pc_out=%h", pc_out);
        pc_in = 32'h9; #10; $display("pc_in=9 -> pc_out=%h", pc_out);
        rst = 1;       #10; $display("rst=1   -> pc_out=%h (expect 00000000)", pc_out);
        $finish;
    end
endmodule
