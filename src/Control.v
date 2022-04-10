`include "CtrlDef.v"
`include "InstrDef.v"

module Control (
  OpCode, Funct, PCDist, NPCCtrl, BranchEql, MemRead, MemToReg, MemWrite, RegDist, RegWrite, ALUSrc, RegDistDist, ExtOp, ALUOp
);

  input [5:0] OpCode, Funct;
  output PCDist, BranchEql;
  output reg MemRead, MemToReg, MemWrite, RegDist, RegWrite, ALUSrc, RegDistDist;
  output [1:0] ExtOp, NPCCtrl;
  output reg [4:0] ALUOp;

  assign PCDist = (OpCode == `INSTR_RTYPE_OP && Funct == `INSTR_JR_FUNCT);
  assign BranchEql = (OpCode == `INSTR_BEQ_OP ? 1 : 0);
  assign ExtOp = (OpCode == `INSTR_LUI_OP ? `EXT_HIGHPOS : (OpCode == `INSTR_ORI_OP ? `EXT_ZERO : `EXT_SIGNED));
  assign NPCCtrl = (OpCode == `INSTR_J_OP || OpCode == `INSTR_JAL_OP ? `NPC_JUMP : (OpCode == `INSTR_BEQ_OP || OpCode == `INSTR_BNE_OP ? `NPC_BRANCH : (PCDist ? `NPC_JR : `NPC_PLUS4)));

  always @(OpCode or Funct) begin
    case (OpCode)
      `INSTR_RTYPE_OP: begin
        RegDist = 1'b1;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
        if (Funct == `INSTR_JR_FUNCT) begin
          ALUOp = `ALUOp_NULL;
          RegWrite = 1'b0;
        end else begin
          ALUOp = `ALUOp_RTYPE;
          RegWrite = 1'b1;
        end
      end
      `INSTR_LW_OP: begin
        ALUOp = `ALUOp_ADD;
        RegDist = 1'b0;
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        MemToReg = 1'b1;
        RegDistDist = 1'b0;
      end
      `INSTR_SW_OP: begin
        ALUOp = `ALUOp_ADD;
        RegDist = 1'b0;
        RegWrite = 1'b0;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b1;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_ADDI_OP: begin
        ALUOp = `ALUOp_ADD;
        RegDist = 1'b0;
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_ORI_OP: begin
        ALUOp = `ALUOp_OR;
        RegDist = 1'b0;
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_LUI_OP: begin // TODO
        ALUOp = `ALUOp_LUI;
        RegDist = 1'b0;
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_SLTI_OP: begin
        ALUOp = `ALUOp_SLT;
        RegDist = 1'b0;
        RegWrite = 1'b1;
        ALUSrc = 1'b1;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_BEQ_OP: begin
        ALUOp = `ALUOp_BEQ;
        RegDist = 1'b0;
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_BNE_OP: begin
        ALUOp = `ALUOp_BNE;
        RegDist = 1'b0;
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_J_OP: begin
        ALUOp = `ALUOp_NULL;
        RegDist = 1'b0;
        RegWrite = 1'b0;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b0;
      end
      `INSTR_JAL_OP: begin
        ALUOp = `ALUOp_JAL;
        RegDist = 1'b1;
        RegWrite = 1'b1;
        ALUSrc = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        MemToReg = 1'b0;
        RegDistDist = 1'b1;
      end
      default: begin
        ALUOp = `ALUOp_NULL;
      end
    endcase
  end
endmodule