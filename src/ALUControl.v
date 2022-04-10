`include "CtrlDef.v"
`include "InstrDef.v"

module ALUControl (
  ALUOp, Funct, ALUCtrl
);

input [4:0] ALUOp;
input [5:0] Funct;
output reg [4:0] ALUCtrl;

always @(ALUOp or Funct) begin
  if (ALUOp == `ALUOp_RTYPE) begin
    case (Funct)
      `INSTR_ADD_FUNCT: ALUCtrl = `ALUCtrl_ADD;
      `INSTR_ADDU_FUNCT: ALUCtrl = `ALUCtrl_ADDU;
      `INSTR_SUB_FUNCT: ALUCtrl = `ALUCtrl_SUB;
      `INSTR_SUBU_FUNCT: ALUCtrl = `ALUCtrl_SUBU;
      `INSTR_AND_FUNCT: ALUCtrl = `ALUCtrl_AND;
      `INSTR_NOR_FUNCT: ALUCtrl = `ALUCtrl_NOR;
      `INSTR_OR_FUNCT: ALUCtrl = `ALUCtrl_OR;
      `INSTR_XOR_FUNCT: ALUCtrl = `ALUCtrl_XOR;
      `INSTR_SLT_FUNCT: ALUCtrl = `ALUCtrl_SLT;
      `INSTR_SLTU_FUNCT: ALUCtrl = `ALUCtrl_SLTU;
      `INSTR_SLL_FUNCT: ALUCtrl = `ALUCtrl_SLL;
      `INSTR_SRL_FUNCT: ALUCtrl = `ALUCtrl_SRL;
      `INSTR_SRA_FUNCT: ALUCtrl = `ALUCtrl_SRA;
      // case `INSTR_SLLV_FUNCT: ALUCtrl = `ALUCtrl_SLLV;
      // case `INSTR_SRLV_FUNCT: ALUCtrl = `ALUCtrl_SRLV;
      // case `INSTR_SRAV_FUNCT: ALUCtrl = `ALUCtrl_SRAV;
      // case `INSTR_JR_FUNCT: ALUCtrl = `ALUCtrl_JR;
      // case `INSTR_JALR_FUNCT: ALUCtrl = `ALUCtrl_JALR;
      default: ALUCtrl = 5'b00000;
    endcase
  end else begin
    ALUCtrl = ALUOp;
  end
end

endmodule