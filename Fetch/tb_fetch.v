`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:47:46 PM
// Design Name: 
// Module Name: tb_fetch
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


module tb_fetch(
    );
    
    reg clk, rst, ex_mem_pc_src;
    reg [31:0] ex_mem_npc;
    wire [31:0] if_id_instr, if_id_npc;

    fetch uut (.clk(clk),.rst(rst),.ex_mem_pc_src(ex_mem_pc_src),
               .ex_mem_npc(ex_mem_npc),.if_id_instr(if_id_instr),.if_id_npc(if_id_npc));
    initial clk = 0; always #5 clk = ~clk;

    integer c;
    initial begin
        $dumpfile("tb_fetch.vcd"); $dumpvars(0, tb_fetch);
        rst = 1; ex_mem_pc_src = 0; ex_mem_npc = 0;
        @(posedge clk); #1; @(posedge clk); #1; rst = 0;

        for (c = 0; c < 10; c = c + 1) begin
            @(posedge clk); #1;
            $display("cycle %0d | if_id_npc=%h | if_id_instr=%h", c, if_id_npc, if_id_instr);
        end

        ex_mem_npc = 32'h5; ex_mem_pc_src = 1;
        @(posedge clk); #1;
        $display("BRANCH   | if_id_npc=%h | if_id_instr=%h", if_id_npc, if_id_instr);

        ex_mem_pc_src = 0; 
        @(posedge clk); #1;
        $display("POST-BR  | if_id_npc=%h | if_id_instr=%h", if_id_npc, if_id_instr);
        @(posedge clk); #1;
        $display("POST-BR+1| if_id_npc=%h | if_id_instr=%h", if_id_npc, if_id_instr);

        $finish;
    end
endmodule
