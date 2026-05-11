`timescale 1ns / 1ps

module regfileTB(

    );
reg clk;
reg rst;
reg regwrite;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [31:0] writedata;
wire [31:0] A_readdat1;
wire [31:0] B_readdat2;

    
    regfile DUT (
        .clk(clk),
        .rst(rst),
        .regwrite(regwrite),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .writedata(writedata),
        .A_readdat1(A_readdat1),
        .B_readdat2(B_readdat2)
        );
        
  initial begin 
    clk = 0;
    forever #1 clk = ~clk;
    end
    
    initial begin 
    regwrite = 0;
    rst = 1; 
    rs = 0; 
    rt = 2;
    rd = 2; 
    writedata = 32'h00000000;
    #10  //reset value initialized
    
    rst = 0;
    #10
          rs = 5'd1; rt = 5'd2; #10;  //A_readdat1 <= REG[rs] 
          rs = 5'd3; rt = 5'd4; #10;  //B_readdat2 <= REG[rt]
    
    regwrite = 1;
    rd = 5'd2;
    writedata = 32'h00000064;
    #10        //overwrite REG[2]
                //REG[rd] <= writedata (10101010)
    
    regwrite = 0;
     rs = 5'd1;
     rt = 5'd2;
    #10
    $display("Test Complete");
    
    $finish;
    
    end
    
    initial begin
    $monitor("Time=%0t A=%h B=%h, regwrite=%h, rst=%h", $time,A_readdat1, B_readdat2, regwrite, rst);
    end
        
endmodule
