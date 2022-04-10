module ID (
  clk, 
  NPCIn, Instr, RegWriteIn, WriteRegAddrIn, WriteRegData,
  Forward1, Forward2,
  DataFromEX, DataFromMEM, DataFromWB,

  NPCOut, 
  RegData1, RegData2, Imm32, 
  Funct, Rs, Rt, /*Rd,*/ Shamt, 
  Branch, NPCCtrl, PCNew,
  ALUSrc, ALUOp, 
  // RegDist, 
  WriteRegAddrOut,
  // RegDistDist,
  MemRead, MemWrite,
  MemToReg, RegWriteOut
);

  input clk;
  input [31:0] NPCIn, Instr, WriteRegData;
  input [4:0] WriteRegAddrIn;
  input RegWriteIn;
  input [1:0] Forward1, Forward2;
  input [31:0] DataFromEX, DataFromMEM, DataFromWB;
  output [31:0] NPCOut, RegData1, RegData2, Imm32;
  output [5:0] Funct;
  output [4:0] Rs, Rt, /*Rd,*/ Shamt;
  // output Jump, PCDist;
  output Branch;
  output [1:0] NPCCtrl;
  output [31:0] PCNew;
  output ALUSrc;
  // output RegDist;
  // output RegDistDist;
  output [4:0] ALUOp, WriteRegAddrOut;
  output MemRead, MemWrite;
  output MemToReg;
  output RegWriteOut;
  // output EXCtrl;
  // output MEMCtrl;
  // output WBCtrl;

  // Control signal
  wire [1:0] ExtOp;
  wire Equal, BranchEql;

  // Address & Data;
  wire [5:0]  OpCode;
  // wire [4:0] Rs;
  wire [25:0] PCNewFromInstr;
  wire [31:0] PCNewFromReg;
  wire [31:0] RegOut1, RegOut2, ForwardedRegOut1, ForwardedRegOut2;
  wire [4:0] Rd, Rj;
  // wire [4:0]  rs, rt, rd, rj;
  wire [15:0] Imm16;
  wire PCDist, RegDistDist, RegDist;

  assign NPCOut = NPCIn;

  assign OpCode = Instr[31:26];
  assign Funct = Instr[5:0];
  assign Rs = Instr[25:21];
  assign Rt = Instr[20:16];
  assign Rd = Instr[15:11];
  assign Imm16 = Instr[15:0];
  assign Shamt = Instr[10:6];
  assign PCNewFromInstr = Instr[25:0];
  assign PCNewFromReg = RegData1;

  assign Equal = ~(|(RegData1 ^ RegData2));
  assign Branch = ~(BranchEql ^ Equal);

  // mux2 #(.WIDTH(32)) U_PCDIST (
  //   .d0({6'b000000, PCNewFromInstr}),
  //   .d1(PCNewFromReg),
  //   .s(PCDist),
  //   .y(PCNew)
  // );
  assign PCNew = PCDist ? PCNewFromReg : {6'b000000, PCNewFromInstr};

  // mux2 #(.WIDTH(5)) U_REGDISTDIST(
  //   .d0(Rd),
  //   .d1(5'd31),
  //   .s(RegDistDist),
  //   .y(Rj)
  // );
  assign Rj = RegDistDist ? 5'd31 : Rd;

  // mux2 #(.WIDTH(5)) U_REGDIST (
  //   .d0(Rt),
  //   .d1(Rj),
  //   .s(RegDist),
  //   .y(WriteRegAddrOut)
  // );
  assign WriteRegAddrOut = RegDist ? Rj : Rt;

  assign RegData1 = RegDistDist ? 5'd0  : ForwardedRegOut1;
  assign RegData2 = RegDistDist ? NPCIn : ForwardedRegOut2;

  mux4 #(.WIDTH(32)) U_FORWARD1 (
    .d0(RegOut1),
    .d1(DataFromWB),
    .d2(DataFromMEM),
    .d3(DataFromEX),
    .s(Forward1),
    .y(ForwardedRegOut1)
  );

  mux4 #(.WIDTH(32)) U_FORWARD2 (
    .d0(RegOut2),
    .d1(DataFromWB),
    .d2(DataFromMEM),
    .d3(DataFromEX),
    .s(Forward2),
    .y(ForwardedRegOut2)
  );

  RegFile U_REGFILE (
    .ReadAddr1(Rs),
    .ReadAddr2(Rt),
    .WriteAddr(WriteRegAddrIn),
    .WriteData(WriteRegData),
    .clk(clk),
    .RFWr(RegWriteIn),
    .ReadData1(RegOut1),
    .ReadData2(RegOut2)
  );

  Control U_CONTROL (
    .OpCode(OpCode),
    .Funct(Funct),
    // .Jump(Jump),
    .PCDist(PCDist),
    .NPCCtrl(NPCCtrl),
    .BranchEql(BranchEql),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemToReg(MemToReg),
    .RegWrite(RegWriteOut),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .RegDist(RegDist),
    .RegDistDist(RegDistDist),
    .ExtOp(ExtOp)
  );

  Extender U_EXTENDER (
    .Imm16(Imm16),
    .ExtOp(ExtOp),
    .Imm32(Imm32)
  );

  // mux2 #(.WIDTH(32)) U_PCTOREG (
  //   .d0(ALUOut),
  //   .d1(PC + 4),
  //   .s(RegDistDist),
  //   .y(ALUOutOrPC)
  // );

  // mux2 #(.WIDTH(32)) U_MEMTOREG (
  //   .d0(ALUOutOrPC),
  //   .d1(DataOut),
  //   .s(MemToReg),
  //   .y(WriteDataReg)
  // );

  // assign rj = RegDistDist ? 5'd31 : rd;
  // // mux2 #(.WIDTH(5)) U_REGDISTDIST (
  // //   .d0(rd),
  // //   .d1(5'd31),
  // //   .s(RegDistDist),
  // //   .y(rj)
  // // );

  // Extender U_EXTENDER (
  //   .Imm16(Imm16),
  //   .ExtOp(ExtOp),
  //   .Imm32(Imm32)
  // );

  // RegFile U_REGFILE (
  //   .ReadAddr1(rs),
  //   .ReadAddr2(rt),
  //   .WriteAddr(WriteRegAddr),
  //   .WriteData(WriteDataReg),
  //   .clk(clk),
  //   .RFWr(RegWrite),
  //   .ReadData1(RegData1),
  //   .ReadData2(RegData2)
  // );

  // Control U_CONTROL (
  //   .OpCode(OpCode),
  //   .Funct(Funct),
  //   .Jump(Jump),
  //   .Branch(Branch),
  //   .MemRead(MemRead),
  //   .MemToReg(MemToReg),
  //   .MemWrite(MemWrite),
  //   .RegDist(RegDist),
  //   .RegWrite(RegWrite),
  //   .ALUSrc(ALUSrc),
  //   .RegDistDist(RegDistDist),
  //   .PCDist(PCDist),
  //   .ExtOp(ExtOp),
  //   .ALUOp(ALUOp)
  // );
  
endmodule