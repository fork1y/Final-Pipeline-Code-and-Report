`timescale 1ns / 1ps

// ============================================================
// TB 1: ALU Control
// ============================================================
module test;
    wire [2:0] select;
    reg  [1:0] alu_op;
    reg  [5:0] funct;

    alu_control aluccontrol1 (
        .select (select),
        .aluop  (alu_op),
        .funct  (funct)
    );

    initial begin
        $monitor("ALUOp=%b | funct=%b | select=%b", alu_op, funct, select);

        alu_op = 2'b00; funct = 6'b100000; #1; // LW/SW -> 010
        alu_op = 2'b01; funct = 6'b100000; #1; // BEQ   -> 110
        alu_op = 2'b10; funct = 6'b100000; #1; // ADD   -> 010
                        funct = 6'b100010; #1; // SUB   -> 110
                        funct = 6'b100100; #1; // AND   -> 000
                        funct = 6'b100101; #1; // OR    -> 001
                        funct = 6'b101010; #1; // SLT   -> 111
        $finish;
    end
endmodule

// ============================================================
// TB 2: ALU
// ============================================================
module alu_test;
    reg  [31:0] a, b;
    reg  [2:0]  control;
    wire [31:0] result;
    wire        zero;

    alu uut (
        .a       (a),
        .b       (b),
        .control (control),
        .result  (result),
        .zero    (zero)
    );

    initial begin
        a = 32'd10; b = 32'd7;
        $display("A=%0d B=%0d", a, b);
        $monitor("control=%b | result=%0d | zero=%b", control, result, zero);

        control = 3'b010; #1; // ADD: expect 17
        control = 3'b110; #1; // SUB: expect 3
        control = 3'b000; #1; // AND: expect 2
        control = 3'b001; #1; // OR:  expect 15
        control = 3'b111; #1; // SLT: a<b? no, expect 0
        control = 3'b011; #1; // unknown -> X
        $finish;
    end
endmodule

// ============================================================
// TB 3: Full Execute Stage - ports match execute.v exactly
// ============================================================
module executeTB;
    reg        clk, rst;
    reg  [1:0] ctlwb_in, ctlm_in;
    reg  [31:0] npc, rdata1, rdata2, s_extend;
    reg  [4:0]  instr_2016, instr_1511;
    reg  [1:0]  alu_op;
    reg  [5:0]  funct;
    reg         alusrc, regdst;

    wire [1:0]  ctlwb_out, ctlm_out;
    wire [31:0] adder_out, alu_result_out, rdata2_out;
    wire [4:0]  muxout_out;
    wire        zero;

    execute uut (
        .clk            (clk),
        .rst            (rst),
        .ctlwb_in       (ctlwb_in),
        .ctlm_in        (ctlm_in),
        .npc            (npc),
        .rdata1         (rdata1),
        .rdata2         (rdata2),
        .s_extend       (s_extend),
        .instr_2016     (instr_2016),
        .instr_1511     (instr_1511),
        .alu_op         (alu_op),
        .funct          (funct),
        .alusrc         (alusrc),
        .regdst         (regdst),
        .ctlwb_out      (ctlwb_out),
        .ctlm_out       (ctlm_out),
        .adder_out      (adder_out),
        .alu_result_out (alu_result_out),
        .rdata2_out     (rdata2_out),
        .muxout_out     (muxout_out),
        .zero           (zero),
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; #12; rst = 0;   // reset for >1 cycle

        // Test 1: R-type ADD
        // rdata1=10, rdata2=20, funct=ADD -> alu_result should be 30
        ctlwb_in  = 2'b10; ctlm_in  = 3'b001;
        npc       = 32'd100;
        rdata1    = 32'd10;  rdata2   = 32'd20;
        s_extend  = 32'd4;
        instr_2016 = 5'd5;  instr_1511 = 5'd10;
        alu_op    = 2'b10;  funct     = 6'b100000; // R-type ADD
        alusrc    = 1'b0;   regdst    = 1'b1;      // use rdata2, dest=rd
        #15;
        $display("TEST 1 R-ADD | adder=%0d | alu_result=%0d (expect 30) | muxout=%0d (expect 10)",
                  adder_out, alu_result_out, muxout_out);

        // Test 2: I-type BEQ (ALUOp=01 -> subtract)
        // rdata1=10, s_extend=10 -> result=0, zero=1
        alusrc    = 1'b1;   regdst    = 1'b0;      // use s_extend, dest=rt
        alu_op    = 2'b01;  funct     = 6'b100010;
        rdata1    = 32'd10; s_extend  = 32'd10;
        #15;
        $display("TEST 2 BEQ   | adder=%0d | alu_result=%0d (expect 0)  | muxout=%0d (expect 5)",
                  adder_out, alu_result_out, muxout_out);

        // Test 3: LW/SW (ALUOp=00 -> add for address)
        // rdata1=100, s_extend=8 -> result=108
        alu_op    = 2'b00;  funct     = 6'b000000;
        rdata1    = 32'd100; s_extend = 32'd8;
        alusrc    = 1'b1;
        #15;
        $display("TEST 3 LW/SW | adder=%0d | alu_result=%0d (expect 108)",
                  adder_out, alu_result_out);

        $stop;
    end
endmodule
