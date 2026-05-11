`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2026 02:10:46 PM
// Design Name: 
// Module Name: fetch
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


module fetch(
    input wire clk,
    input wire rst,
    input wire ex_mem_pc_src,
    input wire [31:0] ex_mem_npc,
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_npc
    );
    
    wire [31:0] pc_mux_out;
    wire [31:0] pc_out;
    wire [31:0] next_pc;
    wire [31:0] instr_data;
    
    mux m0 (
        .y       (pc_mux_out),
        .a_true  (next_pc),      
        .b_false (ex_mem_npc),   
        .sel     (ex_mem_pc_src)
    );

    pc pc0 (
        .clk    (clk),
        .rst    (rst),
        .pc_in  (pc_mux_out),
        .pc_out (pc_out)
    );

    incrementer in0 (
        .clk   (clk),
        .rst   (rst),
        .pcin  (pc_out),
        .pcout (next_pc)
    );

    instrMem inMem0 (
        .clk  (clk),
        .rst  (rst),
        .addr (pc_out),
        .data (instr_data)
    );

    ifIdLatch ifIdLatch0 (
        .clk       (clk),
        .rst       (rst),
        .pc_in     (next_pc),
        .instr_in  (instr_data),
        .pc_out    (if_id_npc),
        .instr_out (if_id_instr)
    );
endmodule
