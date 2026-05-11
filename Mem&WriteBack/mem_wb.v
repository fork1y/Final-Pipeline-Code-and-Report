`timescale 1ns/1ps

/* MEM/WB pipeline latch */
module mem_wb (
    input  wire        clk,
    input  wire [1:0]  control_wb_in,
    input  wire [31:0] read_data_in,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  write_reg_in,
    output reg  [1:0]  control_wb_out,
    output reg         regwrite,
    output reg         memtoreg,
    output reg  [31:0] read_data,
    output reg  [31:0] mem_alu_result,
    output reg  [4:0]  mem_write_reg
);

    initial begin
        control_wb_out = 2'b00;
        regwrite       = 1'b0;
        memtoreg       = 1'b0;
        read_data      = 32'b0;
        mem_alu_result = 32'b0;
        mem_write_reg  = 5'b0;
    end

    always @(posedge clk) begin
        control_wb_out <= control_wb_in;
        regwrite       <= control_wb_in[1];
        memtoreg       <= control_wb_in[0];
        read_data      <= read_data_in;
        mem_alu_result <= alu_result_in;
        mem_write_reg  <= write_reg_in;
    end

endmodule
