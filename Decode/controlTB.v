`timescale 1ns / 1ps
module controlTB(
    
    );
    wire [1:0] wb;
    wire [2:0] mem;
    wire [3:0] ex;
    reg   clk,
          rst;
    reg [5:0] opcode; 
    
    parameter RTYPE = 6'b000000;
    parameter LW    = 6'b100011;
    parameter SW    = 6'b101011;
    parameter BEQ   = 6'b000100;
    parameter NOP   = 6'b111111;
    
    control DUT (
    .wb(wb),
    .mem(mem),
    .ex(ex),
    .clk(clk),
    .rst(rst),
    .opcode(opcode)
);

initial begin 
    clk = 0;
    forever #1 clk = ~clk;
    end
    
    //complete: copy and paste the parameters for the opcode types from control.v so that the initial code block
   
    initial begin 
    rst = 1;
    opcode = RTYPE;
    #2;  // reset values initialized
    
    rst = 0; //RTYPE (wb <= 10, mem <= 000, ex <= 1100)
        //RTYPE (wb <= 11, mem <= 010, ex <= 0001)
    //RTYPE (wb <= 00, mem <= 001, ex <= 0001)
        opcode = RTYPE; #2;
        opcode = RTYPE; #2;
        opcode = LW;    #2;
        opcode = BEQ;   #2;
        opcode = NOP;   #2;
        opcode = NOP;   #2;

  //RTYPE (wb <= 00, mem <= 100, ex <= 0010)
    //RTYPE (wb <= 00, mem <= 000, ex <= 0000)
     //Random should be treated as NOP (wb <= 00, mem <= 000, ex <= 0000)
    $finish;
    end
  
    initial begin
        $monitor("Time=%0t opcode=%b wb=%b, mem=%b, ex=%b, rst=%b", $time, opcode, wb, mem, ex, rst);
        end
    
endmodule
