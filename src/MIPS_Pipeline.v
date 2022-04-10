module MIPS_Pipeline (
  clk, rst
);

  input clk, rst;

  // Data
  wire [31:0] Imm32_IFIn;

  wire [31:0] NPC_IFOut, NPC_IDIn, NPC_IDOut;
  wire [31:0] Instr_IFOut, Instr_IDIn;
  wire [31:0] RegData1_IDOut, RegData1_EXIn;
  wire [31:0] RegData2_IDOut, RegData2_EXIn, RegData2_EXOut, RegData2_MEMIn;
  wire [31:0] Imm32_IDOut, Imm32_EXIn;
  wire [5:0] Funct_IDOut, Funct_EXIn;
  wire [4:0] Rs_IDOut, Rs_EXIn, Rt_IDOut, Rt_EXIn, /*Rd_IDOut, Rd_EXIn,*/ Shamt_IDOut, Shamt_EXIn;
  // wire [25:0] PCNewFromInstr_IDOut, PCNewFromInstr_EXIn;

  wire [31:0] ALUOut_EXOut, ALUOut_MEMIn, ALUOut_MEMOut, ALUOut_WBIn;
  // wire [31:0] PCSelected_EXOut, PCSelected_MEMIn, PCSelected_MEMOut;
  // wire [31:0] WriteRegData_EXOut, WriteRegData_MEMIn, WriteRegData_MEMOut, WriteRegData_WBIn;
  wire [31:0] WriteRegData_IDIn, WriteRegData_WBOut;
  wire [31:0] DataOut_MEMOut, DataOut_WBIn;

  // Address
  wire [25:0] PCNewFromInstr;
  wire [31:0] PCNewFromReg;
  wire [31:0] PCNew_IFIn;
  wire [4:0] WriteRegAddr_IDIn, WriteRegAddr_IDOut, WriteRegAddr_EXIn, WriteRegAddr_EXOut, WriteRegAddr_MEMIn, WriteRegAddr_MEMOut, WriteRegAddr_WBIn;

  // Control
  // wire PCSel, Jump, PCNewDist;
  wire RegDistDist;
  wire RegWrite_IDIn, RegWrite_IDOut, RegWrite_EXIn, RegWrite_EXOut, RegWrite_MEMIn, RegWrite_MEMOut, RegWrite_WBIn, RegWrite_WBOut;

  wire ALUSrc_IDOut, ALUSrc_EXIn;
  wire [4:0] ALUOp_IDOut, ALUOp_EXIn;
  // wire RegDist_IDOut, RegDist_EXIn;
  // wire RegDistDist_IDOut, RegDistDist_EXIn;

  wire Branch_IDOut;
  wire [1:0] NPCCtrl_IDOut;
  wire MemRead_IDOut, MemRead_EXIn, MemRead_EXOut, MemRead_MEMIn;
  wire MemWrite_IDOut, MemWrite_EXIn, MemWrite_EXOut, MemWrite_MEMIn;

  wire Zero_EXOut, Zero_MEMIn;

  wire PCSel_MEMOut, PCSel_IFIn;

  wire MemToReg_IDOut, MemToReg_EXIn, MemToReg_EXOut, MemToReg_MEMIn, MemToReg_MEMOut, MemToReg_WBIn;

  wire IF_ID_WE, IF_ID_Flush, ID_EX_Flush, PC_WE;
  wire [1:0] Forward1, Forward2, ForwardToID1, ForwardToID2;

  IF U_IF (
    .clk(clk), .rst(rst),
    .Branch(Branch_IDOut), .NPCCtrl(NPCCtrl_IDOut), 
    .Imm32(Imm32_IDOut), //?
    .PCNew(PCNew_IFIn), //?
    .NPCIn(NPC_IDOut),
    .PCWriteEnable(PC_WE),

    .NPCOut(NPC_IFOut),
    .Instr(Instr_IFOut)
  );

  IF_ID U_IF_ID (
    .clk(clk),
    .WriteEnable(IF_ID_WE),
    .Flush(IF_ID_Flush),
    .NPCIn(NPC_IFOut),
    .InstrIn(Instr_IFOut),

    .NPCOut(NPC_IDIn),
    .InstrOut(Instr_IDIn)
  );

  ID U_ID(
    .clk(clk),
    .NPCIn(NPC_IDIn),
    .Instr(Instr_IDIn),

    .RegWriteIn(RegWrite_IDIn),
    .WriteRegAddrIn(WriteRegAddr_IDIn),
    .WriteRegData(WriteRegData_IDIn),
    .Forward1(ForwardToID1),
    .Forward2(ForwardToID2),
    .DataFromEX(ALUOut_EXOut),
    .DataFromMEM(ALUOut_MEMIn),
    .DataFromWB(WriteRegData_IDIn),

    .NPCOut(NPC_IDOut),
    .RegData1(RegData1_IDOut),
    .RegData2(RegData2_IDOut),
    .Imm32(Imm32_IDOut),
    .Funct(Funct_IDOut),
    .Rs(Rs_IDOut),
    .Rt(Rt_IDOut),
    // .Rd(Rd_IDOut),
    .Shamt(Shamt_IDOut),
    // .PCNewFromInstr(PCNewFromInstr_IDOut),
    // .Jump(Jump),
    // .PCDist(PCNewDist),
    .Branch(Branch_IDOut),
    .NPCCtrl(NPCCtrl_IDOut),
    .PCNew(PCNew_IFIn),
    .ALUSrc(ALUSrc_IDOut),
    .ALUOp(ALUOp_IDOut),
    // .RegDist(RegDist_IDOut),
    .WriteRegAddrOut(WriteRegAddr_IDOut), 
    // .RegDistDist(RegDistDist_IDOut),
    .MemRead(MemRead_IDOut),
    .MemWrite(MemWrite_IDOut),
    .MemToReg(MemToReg_IDOut),
    .RegWriteOut(RegWrite_IDOut)
  );

  ID_EX U_ID_EX (
    .clk(clk),
    .Flush(ID_EX_Flush),
    /*.NPCIn(NPC_IDOut), */.RegData1In(RegData1_IDOut), .RegData2In(RegData2_IDOut), .Imm32In(Imm32_IDOut), 
    .FunctIn(Funct_IDOut), .RsIn(Rs_IDOut), .RtIn(Rt_IDOut), /*.RdIn(Rd_IDOut),*/ .ShamtIn(Shamt_IDOut),
    /*.PCNewFromInstrIn(PCNewFromInstr_IDOut),*/
    .ALUSrcIn(ALUSrc_IDOut), .ALUOpIn(ALUOp_IDOut), 
    // .RegDistIn(RegDist_IDOut), 
    .WriteRegAddrIn(WriteRegAddr_IDOut),
    // .RegDistDistIn(RegDistDist_IDOut),
    /*.BranchIn(Branch_IDOut), */.MemReadIn(MemRead_IDOut), .MemWriteIn(MemWrite_IDOut),
    .MemToRegIn(MemToReg_IDOut), .RegWriteIn(RegWrite_IDOut),

    /*.NPCOut(NPC_EXIn),*/ .RegData1Out(RegData1_EXIn), .RegData2Out(RegData2_EXIn), .Imm32Out(Imm32_EXIn), 
    .FunctOut(Funct_EXIn), .RsOut(Rs_EXIn), .RtOut(Rt_EXIn), /*.RdOut(Rd_EXIn),*/ .ShamtOut(Shamt_EXIn),
    /*.PCNewFromInstrOut(PCNewFromInstr_EXIn),*/
    .ALUSrcOut(ALUSrc_EXIn), .ALUOpOut(ALUOp_EXIn), 
    // .RegDistOut(RegDist_EXIn), 
    .WriteRegAddrOut(WriteRegAddr_EXIn),
    // .RegDistDistOut(RegDistDist_EXIn),
    /*.BranchOut(Branch_EXIn), */.MemReadOut(MemRead_EXIn), .MemWriteOut(MemWrite_EXIn),
    .MemToRegOut(MemToReg_EXIn), .RegWriteOut(RegWrite_EXIn)
  );

  EX U_EX (
    // .NPC(NPC_EXIn),
    .RegData1(RegData1_EXIn),
    .RegData2In(RegData2_EXIn),
    .Imm32(Imm32_EXIn),
    .Funct(Funct_EXIn),
    // .Rt(Rt_EXIn),
    // .Rd(Rd_EXIn),
    .Shamt(Shamt_EXIn),
    // .PCNewFromInstr(PCNewFromInstr_EXIn),
    .DataFromMEM(ALUOut_MEMIn),
    .DataFromWB(WriteRegData_IDIn),
    .ALUSrc(ALUSrc_EXIn),
    // .RegDist(RegData1_EXIn),
    .WriteRegAddrIn(WriteRegAddr_EXIn), 
    // .RegDistDist(RegDistDist_EXIn),
    .ALUOp(ALUOp_EXIn),
    // .BranchIn(Branch_EXIn),
    .MemReadIn(MemRead_EXIn),
    .MemWriteIn(MemWrite_EXIn),
    .MemToRegIn(MemToReg_EXIn),  
    .RegWriteIn(RegWrite_EXIn),
    .Forward1(Forward1),
    .Forward2(Forward2),
    .ALUOut(ALUOut_EXOut),
    // .PCSelected(PCSelected_EXOut),
    .RegData2Out(RegData2_EXOut),
    .WriteRegAddrOut(WriteRegAddr_EXOut),
    // .BranchOut(Branch_EXOut),
    .MemReadOut(MemRead_EXOut),
    .MemWriteOut(MemWrite_EXOut),
    .MemToRegOut(MemToReg_EXOut),
    // .Zero(Zero_EXOut),
    .RegWriteOut(RegWrite_EXOut)
  );

  EX_MEM U_EX_MEM (
    .clk(clk),
    .ALUOutIn(ALUOut_EXOut),
    // .PCSelectedIn(PCSelected_EXOut),
    .RegDataIn(RegData2_EXOut),
    .WriteRegAddrIn(WriteRegAddr_EXOut),
    // .BranchIn(Branch_EXOut),
    .MemReadIn(MemRead_EXOut),
    .MemWriteIn(MemWrite_EXOut),
    .MemToRegIn(MemToReg_EXOut),
    .RegWriteIn(RegWrite_EXOut),
    // .ZeroIn(ZeroIn_EXOut),

    .ALUOutOut(ALUOut_MEMIn),
    // .PCSelectedOut(PCSelected_MEMIn),
    .RegDataOut(RegData2_MEMIn),
    .WriteRegAddrOut(WriteRegAddr_MEMIn),
    // .BranchOut(Branch_MEMIn),
    .MemReadOut(MemRead_MEMIn),
    .MemWriteOut(MemWrite_MEMIn),
    .MemToRegOut(MemToReg_MEMIn),
    .RegWriteOut(RegWrite_MEMIn)
    // .ZeroOut(ZeroOut_MEMIn)
  );

  MEM U_MEM (
    .clk(clk),
    .ALUOutIn(ALUOut_MEMIn),
    // .PCSelected(PCSelected_MEMIn),
    .RegData2(RegData2_MEMIn),
    .WriteRegAddrIn(WriteRegAddr_MEMIn),
    // .Branch(Branch_MEMIn),
    .MemRead(MemRead_MEMIn),
    .MemWrite(MemWrite_MEMIn),
    // .Zero(Zero_MEMIn),
    .MemToRegIn(MemToReg_MEMIn),
    .RegWriteIn(RegWrite_MEMIn),

    .DataOut(DataOut_MEMOut),
    .ALUOutOut(ALUOut_MEMOut),
    // .PCSel(PCSel_MEMOut),
    .MemToRegOut(MemToReg_MEMOut),
    .WriteRegAddrOut(WriteRegAddr_MEMOut),
    .RegWriteOut(RegWrite_MEMOut)
  );

  MEM_WB U_MEM_WB (
    .clk(clk),
    .DataOutIn(DataOut_MEMOut), 
    .ALUOutIn(ALUOut_MEMOut),
    .MemToRegIn(MemToReg_MEMOut),
    .WriteRegAddrOutIn(WriteRegAddr_MEMOut),
    .RegWriteIn(RegWrite_MEMOut),

    .DataOutOut(DataOut_WBIn), 
    .ALUOutOut(ALUOut_WBIn),
    .MemToRegOut(MemToReg_WBIn),
    .WriteRegAddrOutOut(WriteRegAddr_WBIn),
    .RegWriteOut(RegWrite_WBIn)
  );

  WB U_WB (
    .DataOut(DataOut_WBIn),
    .ALUOut(ALUOut_WBIn),
    .MemToReg(MemToReg_WBIn),
    .RegWriteIn(RegWrite_WBIn),
    .WriteRegAddrIn(WriteRegAddr_WBIn),

    .RegWriteOut(RegWrite_IDIn),
    .WriteRegAddrOut(WriteRegAddr_IDIn),
    .WriteRegData(WriteRegData_IDIn)
  );

  HazardUnit U_HAZARD_UNIT (
    .ID_EX_MemRead(MemRead_EXIn),
    .EX_MEM_MemRead(MemRead_MEMIn),
    .ID_EX_Rt(Rt_EXIn),
    .EX_MEM_Rt(WriteRegAddr_MEMIn), // TODO
    .IF_ID_Rs(Instr_IDIn[25:21]),
    .IF_ID_Rt(Instr_IDIn[20:16]),
    .Branch(Branch_IDOut),
    .NPCCtrl(NPCCtrl_IDOut),
    .IF_ID_WE(IF_ID_WE),
    .IF_ID_Flush(IF_ID_Flush),
    .ID_EX_Flush(ID_EX_Flush),
    .PC_WE(PC_WE)
  );

  ForwardUnit U_FORWARD_UNIT (
    .IF_ID_Rs(Instr_IDIn[25:21]),
    .IF_ID_Rt(Instr_IDIn[20:16]),
    .ID_EX_Rs(Rs_EXIn),
    .ID_EX_Rt(Rt_EXIn),
    .ID_EX_Rd(WriteRegAddr_EXIn),
    .EX_MEM_Rd(WriteRegAddr_MEMIn),
    .MEM_WB_Rd(WriteRegAddr_WBIn),
    .ID_EX_RegWrite(RegWrite_EXIn),
    .EX_MEM_RegWrite(RegWrite_MEMIn),
    .MEM_WB_RegWrite(RegWrite_WBIn),
    .Forward1(Forward1),
    .Forward2(Forward2),
    .ForwardToID1(ForwardToID1),
    .ForwardToID2(ForwardToID2)
  );

endmodule