`timescale 1ns / 1ps
module idExLatch(
    input wire        clk,
    input wire        rst,
    input wire [1:0]  ctl_wb,
    input wire [2:0]  ctl_mem,
    input wire [3:0]  ctl_ex,
    input wire [31:0] npc,
    input wire [31:0] readdat1,
    input wire [31:0] readdat2,
    input wire [31:0] sign_ext,
    input wire [4:0]  instr_bits_20_16,
    input wire [4:0]  instr_bits_15_11,
                         
     //outputs
    output reg [1:0]  wb_out,
    output reg [2:0]  mem_out,
    output reg [3:0]  ctl_out,
    output reg [31:0] npc_out,
    output reg [31:0] readdat1_out,
    output reg [31:0] readdat2_out,
    output reg [31:0] sign_ext_out,
    output reg [4:0]  instr_bits_20_16_out,
    output reg [4:0]  instr_bits_15_11_out
    );
    
    always@(posedge clk) begin
        if(rst) begin
        //complete/set all of the outputs to 0
         wb_out               <= 2'b00;
         mem_out              <= 3'b000;
         ctl_out              <= 4'b0000;
         npc_out              <= 32'h00000000;
         readdat1_out         <= 32'h00000000;
         readdat2_out         <= 32'h00000000;
         sign_ext_out         <= 32'h00000000;
         instr_bits_20_16_out <= 5'b00000;
         instr_bits_15_11_out <= 5'b00000;
        end
        else begin
        wb_out <= ctl_wb;
        //complete the rest of the outputs
        mem_out              <= ctl_mem;
        ctl_out              <= ctl_ex;
        npc_out              <= npc;
        readdat1_out         <= readdat1;
        readdat2_out         <= readdat2;
        sign_ext_out         <= sign_ext;
        instr_bits_20_16_out <= instr_bits_20_16;
        instr_bits_15_11_out <= instr_bits_15_11;
       end 
     end
endmodule
