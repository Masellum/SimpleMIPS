module WB (
  DataOut, ALUOut, MemToReg, WriteRegAddrIn, RegWriteIn,
  RegWriteOut, WriteRegAddrOut, WriteRegData
);

  input [31:0] DataOut, ALUOut;
  input MemToReg, RegWriteIn;
  input [4:0] WriteRegAddrIn;
  output RegWriteOut;
  output [4:0] WriteRegAddrOut;
  output [31:0] WriteRegData;

  assign WriteRegData = MemToReg ? DataOut : ALUOut;
  assign WriteRegAddrOut = WriteRegAddrIn;
  assign RegWriteOut = RegWriteIn;
endmodule