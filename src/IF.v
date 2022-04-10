module IF (
  clk, rst, 
  Branch, NPCCtrl, Imm32, PCNew, NPCIn,
  PCWriteEnable,
  NPCOut, Instr
);
  input clk, rst;
  input Branch;
  input [1:0] NPCCtrl;
  input [31:0] Imm32, PCNew, NPCIn;
  input PCWriteEnable;
  output [31:0] NPCOut, Instr;

  wire [31:0] PC, NextPC;

  assign NPCOut = PC + 4;

  NextPC U_NEXTPC (
    .Branch(Branch),
    .NPCCtrl(NPCCtrl),
    .NPC(NPCIn),
    .PC(PC),
    .Imm(Imm32),
    .JumpAddr(PCNew),
    .Result(NextPC)
  );

  PC U_PC (
    .clk(clk), .rst(rst),
    .WriteEnable(PCWriteEnable),
    .NextPC(NextPC),
    .PC(PC)
  );

  InstrMem_4k U_IM4K(
    .InstrAddr(PC[11:2]),
    .InstrOut(Instr)
  );

endmodule