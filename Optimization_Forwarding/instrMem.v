`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 01:57:03 PM
// Design Name: 
// Module Name: instrMem
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


module instrMem(
    input wire clk,
    input wire rst,
    input wire [31:0] addr,  
    output reg [31:0] data
    );
    
    reg [31:0] mem [0:65535];

    integer i;
    initial begin
        for (i = 0; i < 65536; i = i + 1) begin
            mem[i] = 32'b0;
        end
        $readmemb("instr.mem", mem);
    end

    // Instruction memory read is combinational for fetch.
    always @(*) begin
        if (rst) begin
            data = 32'b0;
        end else begin
            data = mem[addr[15:0]];
        end
    end
endmodule
