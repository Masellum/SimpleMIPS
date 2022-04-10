module MEM (
  clk, 
  ALUOutIn, 
  // PCSelected, 
  RegData2, WriteRegAddrIn,
  // Branch, 
  MemRead, MemWrite, 
  // Zero,
  MemToRegIn, RegWriteIn,
  DataOut, ALUOutOut,
  // PCSel, 
  MemToRegOut, RegWriteOut,
  WriteRegAddrOut
);

  input clk;
  input [31:0] ALUOutIn, /*PCSelected,*/ RegData2;
  input [4:0] WriteRegAddrIn;
  // input Branch;
  input MemRead, MemWrite;
  input MemToRegIn, RegWriteIn;
  output [31:0] DataOut, ALUOutOut;
  output /*PCSel,*/ MemToRegOut, RegWriteOut;
  output [4:0] WriteRegAddrOut;

  assign ALUOutOut = ALUOutIn;
  assign MemToRegOut = MemToRegIn;
  assign RegWriteOut = RegWriteIn;
  assign WriteRegAddrOut = WriteRegAddrIn;

  DataMem_4k U_DM4K (
    .DataAddr(ALUOutIn[11:2]),
    .WriteData(RegData2),
    .DMWr(MemWrite),
    .DMRd(MemRead),
    .clk(clk),
    .DataOut(DataOut)
  );

  // and (PCSel, Branch, Zero);

  // and (PCSel, Branch, Zero);

  // DataMem_4k U_DM4K (
  //   .DataAddr(ALUOutIn[11:2]),
  //   .WriteData(RegData2),
  //   .DMWr(MemWrite),
  //   .DMRd(MemRead),
  //   .clk(clk),
  //   .DataOut(DataOut)
  // );
  
endmodule