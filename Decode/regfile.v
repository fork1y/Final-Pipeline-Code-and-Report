`timescale 1ns / 1ps
module regfile(
    input wire        clk,
    input wire        rst,
    input wire        regwrite,
    input wire [4:0]  rs,
    input wire [4:0]  rt,
    input wire [4:0]  rd,
    input wire [31:0] writedata,
    output reg [31:0] A_readdat1,
    output reg [31:0] B_readdat2
);
                      
  //complete, create an internal regfile called REG that is 32 bit wide regs with 32 addr
  reg [31:0] REG [0:31];
    integer i;

  initial begin 
  //$readmeemh({"/regData.mrm"}, REG};
        REG[0] = 'hA00000AA;
        REG[1] = 'h10000011;
        REG[2] = 'h20000022;
        REG[3] = 'h30000033;
        REG[4] = 'h40000044;
        REG[5] = 'h50000055;
        REG[6] = 'h60000066;
        REG[7] = 'h70000077;
        REG[8] = 'h80000088;
        REG[9] = 'h90000099;
          for (i = 10; i < 32; i = i + 1)
            REG[i] = 32'h00000000;
end

always @(posedge clk) begin
    if (rst) begin
    //complete, set A_readdat1 and B_readdat2 to 32 bits of 0's
    A_readdat1 <= 32'h00000000;
            B_readdat2 <= 32'h00000000;
        end
    else begin
        if (regwrite) 
        //complete
        //overwrite the value location rd within REG with writedata
        REG[rd] <= writedata;
        end
        
            A_readdat1 <= REG[rs];
            B_readdat2 <= REG[rt];
        end
        //complete, set A_readdat1 to the value at location rs within REG
        //complete, set B_readdat2 to the value at location rt within REG
    
    endmodule

