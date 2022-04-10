`include "CtrlDef.v"
module Extender( Imm16, ExtOp, Imm32 );
    
   input  [15:0] Imm16;
   input  [1:0]  ExtOp;
   output reg [31:0] Imm32;
   
   wire [31:0] ZeroExt, SignedExt, HighPos;

   assign ZeroExt = {16'd0, Imm16};
   assign SignedExt = {{16{Imm16[15]}}, Imm16};
   assign HighPos = {Imm16, 16'd0};
    
   always @(*) begin
      case (ExtOp)
         // `EXT_ZERO:    Imm32 = {16'd0, Imm16};
         // `EXT_SIGNED:  Imm32 = {{16{Imm16[15]}}, Imm16};
         // `EXT_HIGHPOS: Imm32 = {Imm16, 16'd0};
         `EXT_ZERO:    Imm32 = ZeroExt;
         `EXT_SIGNED:  Imm32 = SignedExt;
         `EXT_HIGHPOS: Imm32 = HighPos;
         default: ;
      endcase
   end // end always
    
endmodule
