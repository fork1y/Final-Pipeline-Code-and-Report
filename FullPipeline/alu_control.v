`timescale 1ns / 1ps
// Takes ALUOp (from control unit) and funct field (from instruction[5:0])
// and outputs a 3-bit ALU control select signal
module alu_control(
    input  wire [5:0] funct,    // instruction[5:0] via s_extend[5:0]
    input  wire [1:0] aluop,    // from ID/EX latch control
    output reg  [2:0] select    // to ALU
);
    // ALUOp values
    parameter lwsw    = 2'b00;
    parameter Itype   = 2'b01;
    parameter Rtype   = 2'b10;
    parameter unknown = 2'b11;

    // ALU control output values
    parameter ALUadd = 3'b010;
    parameter ALUsub = 3'b110;
    parameter ALUand = 3'b000;
    parameter ALUor  = 3'b001;
    parameter ALUslt = 3'b111;
    parameter ALUx   = 3'b011;

    // R-type funct field values
    parameter FUNCTadd = 6'b100000;
    parameter FUNCTsub = 6'b100010;
    parameter FUNCTand = 6'b100100;
    parameter FUNCTor  = 6'b100101;
    parameter FUNCTslt = 6'b101010;

    initial select = 3'b0;

    always @* begin
        case(aluop)
            lwsw:    select = ALUadd;   // LW/SW always add for address calc
            Itype:   select = ALUsub;   // BEQ subtracts to check equality
            Rtype: begin                // R-type: decode funct field
                case(funct)
                    FUNCTadd: select = ALUadd;
                    FUNCTsub: select = ALUsub;
                    FUNCTand: select = ALUand;
                    FUNCTor:  select = ALUor;
                    FUNCTslt: select = ALUslt;
                    default:  select = ALUx;
                endcase
            end
            default: select = ALUx;     // unknown opcode
        endcase
    end
endmodule