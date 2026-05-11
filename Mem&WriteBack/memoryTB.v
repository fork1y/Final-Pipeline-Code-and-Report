`timescale 1ns/1ps

module memoryTB;
    reg clk;
    reg [31:0] ALUResult, WriteData;
    reg [4:0]  WriteReg;
    reg [1:0]  WBControl;
    reg MemWrite, MemRead, Branch, Zero;

    wire [31:0] ReadData, ALUResult_out;
    wire [4:0] WriteReg_out;
    wire [1:0] WBControl_out;
    wire PCSrc;
    integer data_fd;

mem_stage uut (
        .clk(clk),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .WBControl(WBControl),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .Branch(Branch),
        .Zero(Zero),
        .ReadData(ReadData),
        .ALUResult_out(ALUResult_out),
        .WriteReg_out(WriteReg_out),
        .WBControl_out(WBControl_out),
        .PCSrc(PCSrc)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Force-load DMEM for Vivado simulations where working directory may differ.
    // This only touches testbench behavior and does not change design modules.
    initial begin
        #1;
        data_fd = $fopen("data.txt", "r");
        if (data_fd != 0) begin
            $fclose(data_fd);
            $readmemb("data.txt", uut.data_mem_u.DMEM);
            $display("TB preload: loaded data.txt from simulation working directory.");
        end else begin
            $readmemb("D:/4300assignment4/data.txt", uut.data_mem_u.DMEM);
            $display("TB preload: loaded data.txt from fallback path D:/4300assignment4/data.txt.");
        end
    end

    initial begin
        $display("=== Starting Memory Stage Testbench ===");

        // initialize
        ALUResult = 0;
        WriteData = 0;
        WriteReg  = 0;
        WBControl = 0;
        MemWrite  = 0;
        MemRead   = 0;
        Branch    = 0;
        Zero      = 0;

        #10;

        // ------------------------------------------
        // TEST 1: Memory Read
        // data.txt gives DMEM[4] = 4
        // ------------------------------------------
        $display("\nTEST 1: Memory Read");

        ALUResult = 32'd4;
        WriteData = 32'h12345678;
        WriteReg  = 5'd2;
        WBControl = 2'b01;
        MemWrite  = 0;
        MemRead   = 1;
        Branch    = 0;
        Zero      = 0;

        #10;

        $display("ReadData      = %d", ReadData);
        $display("ALUResult_out = %d", ALUResult_out);
        $display("WriteReg_out  = %d", WriteReg_out);
        $display("WBControl_out = %b", WBControl_out);
        $display("PCSrc         = %b", PCSrc);

        // ------------------------------------------
        // TEST 2: Memory Write
        // write value into DMEM[8]
        // ------------------------------------------
        $display("\nTEST 2: Memory Write");

        ALUResult = 32'd8;
        WriteData = 32'hA5A5A5A5;
        WriteReg  = 5'd3;
        WBControl = 2'b10;
        MemWrite  = 1;
        MemRead   = 0;
        Branch    = 0;
        Zero      = 0;

        #10;  // write happens on posedge clk

        // ------------------------------------------
        // TEST 3: Read back written value
        // ------------------------------------------
        $display("\nTEST 3: Read Back After Write");

        MemWrite = 0;
        MemRead  = 1;

        #10;

        $display("ReadData      = %h", ReadData);
        $display("ALUResult_out = %d", ALUResult_out);
        $display("WriteReg_out  = %d", WriteReg_out);
        $display("WBControl_out = %b", WBControl_out);

        // ------------------------------------------
        // TEST 4: Branch NOT taken
        // ------------------------------------------
        $display("\nTEST 4: Branch Not Taken");

        Branch = 1;
        Zero   = 0;

        #10;

        $display("PCSrc = %b (expected 0)", PCSrc);

        // ------------------------------------------
        // TEST 5: Branch taken
        // ------------------------------------------
        $display("\nTEST 5: Branch Taken");

        Branch = 1;
        Zero   = 1;

        #10;

        $display("PCSrc = %b (expected 1)", PCSrc);

        $display("\n=== Testbench Finished ===");
        $finish;
    end

endmodule
