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
        for (i=0; i<65536; i = i+1)
            mem[i] = 32'h0000_0000;
            
        mem[0]  = 32'hA000_00AA;
        mem[1]  = 32'h1000_0011;
        mem[2]  = 32'h2000_0022;
        mem[3]  = 32'h3000_0033;
        mem[4]  = 32'h4000_0044;
        mem[5]  = 32'h5000_0055;
        mem[6]  = 32'h6000_0066;
        mem[7]  = 32'h7000_0077;
        mem[8]  = 32'h8000_0088;
        mem[9]  = 32'h9000_0099;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            data <= 32'b0;
        else
            data <= mem[addr[15:0]];
    end
endmodule
