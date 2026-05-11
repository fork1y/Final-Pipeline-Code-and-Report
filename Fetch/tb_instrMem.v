`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:45:07 PM
// Design Name: 
// Module Name: tb_instrMem
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


module tb_instrMem(
    );
 
    reg clk, rst;
    reg [31:0] addr;
    wire [31:0] data;

    instrMem uut (.clk(clk), .rst(rst), .addr(addr), .data(data));
    initial clk = 0; always #5 clk = ~clk;

    integer k;
    initial begin
        $dumpfile("tb_instrMem.vcd"); $dumpvars(0, tb_instrMem);
        rst = 1; addr = 0; #12;
        $display("rst=1 -> data=%h (expect 00000000)", data);
        rst = 0;
        for (k = 0; k < 10; k = k + 1) begin
            addr = k; #10;
            $display("addr=%0d -> data=%h", addr, data);
        end
        $finish;
    end
endmodule
