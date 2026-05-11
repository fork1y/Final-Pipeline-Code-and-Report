`timescale 1ns / 1ps
module regfile(
    input wire        clk,
    input wire        rst,
    input wire        regwrite,
    input wire [4:0]  rs,
    input wire [4:0]  rt,
    input wire [4:0]  rd,
    input wire [31:0] writedata,
    output wire [31:0] A_readdat1,
    output wire [31:0] B_readdat2
);
                      
    reg [31:0] REG [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            REG[i] = 32'b0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                REG[i] <= 32'b0;
            end
        end else begin
            if (regwrite && (rd != 5'd0)) begin
                REG[rd] <= writedata;
            end
            REG[0] <= 32'b0;
        end
    end

    assign A_readdat1 = REG[rs];
    assign B_readdat2 = REG[rt];

    endmodule
