`timescale 1ns / 1ps
// Execute Stage — Top Level
// Connects: adder, top_mux, bottom_mux, alu_control, alu, ex_mem latch
// Port names match executeTB.v exactly
module execute(
    input  wire        clk,
    input  wire        rst,
    // Control inputs from ID/EX latch
    input  wire [1:0]  ctlwb_in,       // WB control
    input  wire [2:0]  ctlm_in,        // MEM control {branch,memread,memwrite}
    input  wire        alusrc,          // ALUSrc: 0=rdata2, 1=s_extend
    input  wire        regdst,          // RegDst: 0=instr[20:16], 1=instr[15:11]
    input  wire [1:0]  alu_op,          // ALUOp from control unit
    input  wire [5:0]  funct,           // instr[5:0] passed separately from TB
    // Data inputs from ID/EX latch
    input  wire [31:0] npc,             // PC+1
    input  wire [31:0] rdata1,          // register read data 1
    input  wire [31:0] rdata2,          // register read data 2
    input  wire [31:0] s_extend,        // sign extended immediate
    input  wire [4:0]  instr_2016,      // instr[20:16] (rt)
    input  wire [4:0]  instr_1511,      // instr[15:11] (rd)
    // Outputs from EX/MEM latch
    output wire [1:0]  ctlwb_out,
    output wire [2:0]  ctlm_out,        // NOTE: see ex_mem note below
    output wire [31:0] adder_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] rdata2_out,
    output wire [4:0]  muxout_out,
    output wire        zero
);
    // Internal wires
    wire [31:0] adder_result;   // adder -> ex_mem
    wire [31:0] b_wire;         // top_mux -> ALU input b
    wire [4:0]  mux5_out;       // bottom_mux -> ex_mem
    wire [2:0]  alu_ctrl;       // alu_control -> ALU
    wire [31:0] alu_out;        // ALU result -> ex_mem
    wire        alu_zero;       // ALU zero flag -> ex_mem

    // Adder: NPC + SignExtend -> branch target
    adder adder3 (
        .add_in1 (npc),
        .add_in2 (s_extend),
        .add_out (adder_result)
    );

    // Top Mux (32-bit): selects ALU second operand
    // alusrc=0 -> rdata2 (R-type), alusrc=1 -> s_extend (I-type)
    top_mux top_mux3 (
        .y      (b_wire),
        .a      (s_extend),
        .b      (rdata2),
        .alusrc (alusrc)
    );

    // Bottom Mux (5-bit): selects destination register
    // regdst=0 -> instr[20:16], regdst=1 -> instr[15:11]
    bottom_mux bottom_mux3 (
        .y   (mux5_out),
        .a   (instr_1511),  // rd — regdst=1
        .b   (instr_2016),  // rt — regdst=0
        .sel (regdst)
    );

    // ALU Control: funct + aluop -> 3-bit select
    alu_control alu_control3 (
        .funct  (funct),        // instr[5:0]
        .aluop  (alu_op),
        .select (alu_ctrl)
    );

    // ALU: performs operation
    alu alu3 (
        .a       (rdata1),
        .b       (b_wire),
        .control (alu_ctrl),
        .result  (alu_out),
        .zero    (alu_zero)
    );

    // EX/MEM Latch: registers everything on clock edge
    // Note: testbench only exposes ctlwb_out, not individual mem control bits
    // We split ctlm_out internally from the latch's branch/memread/memwrite
    wire branch_w, memread_w, memwrite_w;

    ex_mem ex_mem3 (
        .clk            (clk),
        .rst            (rst),
        .ctlwb_out      (ctlwb_in),
        .ctlm_out       (ctlm_in),
        .adder_out      (adder_result),
        .aluzero        (alu_zero),
        .aluout         (alu_out),
        .readdat2       (rdata2),
        .muxout         (mux5_out),
        .wb_ctlout      (ctlwb_out),
        .branch         (branch_w),
        .memread        (memread_w),
        .memwrite       (memwrite_w),
        .add_result     (adder_out),
        .zero           (zero),             
        .alu_result     (alu_result_out),
        .rdata2out      (rdata2_out),
        .five_bit_muxout(muxout_out)
    );

    // Pack mem control bits back into ctlm_out for TB
    assign ctlm_out = {branch_w, memread_w, memwrite_w};

endmodule
