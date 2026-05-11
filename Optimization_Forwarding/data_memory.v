`timescale 1ns/1ps

/* Data memory:
 * - Asynchronous read when memread=1
 * - Synchronous write on posedge clk when memwrite=1
 * Addressing here follows the lab convention: addr is treated as a word index.
 */
module data_memory (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire        memread,
    input  wire        memwrite,
    output reg  [31:0] read_data
);
    reg [31:0] DMEM [0:255];
    wire [7:0] word_addr;
    integer i;

    assign word_addr = addr[7:0];

    initial begin
        read_data = 32'b0;
        for (i = 0; i < 256; i = i + 1) begin
            DMEM[i] = 32'b0;
        end
        $readmemb("data.mem", DMEM);
    end

    always @(posedge clk) begin
        if (memwrite) begin
            DMEM[word_addr] <= write_data;
        end
    end

    always @(*) begin
        if (memread) begin
            read_data = DMEM[word_addr];
        end else begin
            read_data = 32'b0;
        end
    end

endmodule
