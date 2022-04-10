module EX (
  // NPC,
  RegData1,
  RegData2In,
  Imm32,
  Funct,
  // Rt,
  // Rd,
  Shamt,
  // PCNewFromInstr,
  DataFromMEM,
  DataFromWB,

  ALUSrc,
  ALUOp,
  // RegDist,
  WriteRegAddrIn,
  // RegDistDist,
  // BranchIn,
  MemReadIn,
  MemWriteIn,
  MemToRegIn,
  RegWriteIn,
  Forward1,
  Forward2,
  
  ALUOut,
  // PCSelected,
  RegData2Out,
  WriteRegAddrOut,
  // Zero,
  // BranchOut,
  MemReadOut,
  MemWriteOut,
  MemToRegOut,
  RegWriteOut
);

  input [31:0] /*NPC,*/ RegData1, RegData2In, Imm32, DataFromMEM, DataFromWB;
  input [5:0] Funct;
  // input [4:0] Rt, Rd;
  input [4:0] Shamt;
  // input [25:0] PCNewFromInstr;
  input ALUSrc;
  // input RegDist, RegDistDist;
  input [4:0] ALUOp, WriteRegAddrIn;
  input /*BranchIn,*/ MemReadIn, MemWriteIn;
  input MemToRegIn, RegWriteIn;
  input [1:0] Forward1, Forward2;
  output [31:0] ALUOut, /*PCSelected,*/ RegData2Out;
  output [4:0] WriteRegAddrOut;
  output /*BranchOut,*/ MemReadOut, MemWriteOut/*, Zero*/;
  output MemToRegOut, RegWriteOut;

  wire Zero;
  wire [4:0] ALUCtrl;
  wire [31:0] ALUIn2, PCNewFromReg, ForwardedRegData1, ForwardedRegData2;

  assign WriteRegAddrOut = WriteRegAddrIn;
  // assign BranchOut = BranchIn;
  assign MemReadOut = MemReadIn;
  assign MemWriteOut = MemWriteIn;
  assign MemToRegOut = MemToRegIn;
  assign RegData2Out = ForwardedRegData2;
  assign PCNewFromReg = ForwardedRegData1;
  assign RegWriteOut = RegWriteIn;

  // mux2 #(.WIDTH(5)) U_REGDIST (
  //   .d0(Rt),
  //   .d1(Rd),
  //   .s(RegDist),
  //   .y(WriteRegAddr)
  // );

  mux2 #(.WIDTH(32)) U_ALUSRC (
    .d0(ForwardedRegData2),
    .d1(Imm32),
    .s(ALUSrc),
    .y(ALUIn2)
  );

  mux4 #(.WIDTH(32)) U_FORWARD1 (
    .d0(RegData1),
    .d1(DataFromWB),
    .d2(DataFromMEM),
    .d3(32'h0),
    .s(Forward1),
    .y(ForwardedRegData1)
  );

  mux4 #(.WIDTH(32)) U_FORWARD2 (
    .d0(RegData2In),
    .d1(DataFromWB),
    .d2(DataFromMEM),
    .d3(32'h0),
    .s(Forward2),
    .y(ForwardedRegData2)
  );

  ALUControl U_ALUCONTROL (
    .ALUOp(ALUOp),
    .Funct(Funct),
    .ALUCtrl(ALUCtrl)
  );

  ALU_UsingAdder U_ALU (
    .ALUIn1(ForwardedRegData1),
    .ALUIn2(ALUIn2),
    .ALUInShamt(Shamt),
    .ALUCtrl(ALUCtrl),
    .Zero(Zero),
    .ALUOut(ALUOut)
  );

  // mux2 #(.WIDTH(5)) U_REGDIST (
  //   .d0(Rt),
  //   .d1(Rj),
  //   .s(RegDist),
  //   .y(WriteRegAddr)
  // );

  // mux2 #(.WIDTH(5)) U_REGDISTDIST (
  //   .d0(Rd),
  //   .d1(5'd31),
  //   .s(RegDistDist),
  //   .y(Rj)
  // );

  // mux2 #(.WIDTH(32)) U_PCDIST (
  //   .d0({6'b000000, PCNewFromInstr}),
  //   .d1(PCNewFromReg),
  //   .s(PCDist),
  //   .y(PCNew)
  // );

  // mux2 #(.WIDTH(32)) U_ALUSRC (
  //   .d0(RegData2In),
  //   .d1(Imm32),
  //   .s(ALUSrc),
  //   .y(ALUIn2)
  // );

  // ALUControl U_ALUCONTROL (
  //   .ALUOp(ALUOp),
  //   .Funct(Funct),
  //   .ALUCtrl(ALUCtrl)
  // );

  // ALU_UsingAdder U_ALU (
  //   .ALUIn1(RegData1),
  //   .ALUIn2(ALUIn2),
  //   .ALUInShamt(Shamt),
  //   .ALUCtrl(ALUCtrl),
  //   .Zero(Zero),
  //   .ALUOut(ALUOut)
  // );
  
endmodule