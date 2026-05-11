`timescale 1ns / 1ps
module signExtend(
  input wire [15:0] immediate,
  output wire [31:0] extended
);
  //pre-pend immediate with 16 bits of the MSB
  //{} - concatenate or replicate operator 
  //concatenate {111,100} -> 111000
  //replicate {4{1}} -> 1111
  assign extended = {{16{immediate[15]}}, immediate};

  /*COMPLETE*/

    endmodule
