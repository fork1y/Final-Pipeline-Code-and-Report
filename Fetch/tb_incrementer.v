`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:21:23 PM
// Design Name: 
// Module Name: tb_incrementer
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


module tb_incrementer(
    );
    
    reg clk, rst;
    reg [31:0] pcin;
    wire [31:0] pcout;

    incrementer uut (.clk(clk), .rst(rst), .pcin(pcin), .pcout(pcout));
    initial clk = 0; always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_incrementer.vcd"); $dumpvars(0, tb_incrementer);
        rst = 1; pcin = 0; #10; $display("pcin=0 -> pcout=%h (expect 1)", pcout);
        rst = 0;
        pcin = 32'h4; #10; $display("pcin=4 -> pcout=%h (expect 5)", pcout);
        pcin = 32'hFFFF_FFFF; #10; $display("pcin=FFFFFFFF -> pcout=%h (rollover)", pcout);
        $finish;
    end
endmodule
