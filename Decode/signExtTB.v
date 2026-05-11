`timescale 1ns / 1ps

module signExtTB(
    );
    reg  [15:0] immediate;
    wire [31:0] extended;

    signExtend DUT(
        .immediate(immediate),
        .extended(extended)
    );

    initial begin
        immediate = 16'h0004; #1;
        immediate = 16'h7FFF; #1;
        immediate = 16'h8000; #1;
        immediate = 16'hFFFF; #1;
        $finish;
    end

    initial begin
        $monitor("t=%0t immediate=%h extended=%h", $time, immediate, extended);
    end
endmodule
