`include "CtrlDef.v"

module NextPC (
  Branch, NPCCtrl, NPC, PC, Imm, JumpAddr, Result
  // PCSel, Jump, PCDist, NPC, Imm, PCNew, Result
);
  input Branch;
  input [1:0] NPCCtrl;
  input [31:0] NPC, PC, Imm, JumpAddr;
  output reg [31:0] Result;

  always @(*) begin
    case (NPCCtrl)
      `NPC_PLUS4: Result <= PC + 4;
      `NPC_BRANCH: Result <= Branch ? NPC + {Imm[29:0], 2'b00} : PC + 4;
      `NPC_JUMP: Result <= {NPC[31:28], JumpAddr[25:0], 2'b00};
      `NPC_JR: Result <= JumpAddr;
      default: Result <= PC + 4;
    endcase
  end

endmodule