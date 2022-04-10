module IF_ID (
  clk,
  WriteEnable,
  Flush, 
  NPCIn, InstrIn, 
  NPCOut, InstrOut
);
  input clk, WriteEnable, Flush;
  input [31:0] NPCIn, InstrIn;
  output reg [31:0] NPCOut, InstrOut;

  always @(posedge clk) begin
    if (Flush) begin
      NPCOut <= 0;
      InstrOut <= 0;
    end else begin
      if (WriteEnable) begin
        NPCOut <= NPCIn;
        InstrOut <= InstrIn;
      end else begin
        NPCOut <= NPCOut;
        InstrOut <= InstrOut;
      end
    end
  end
endmodule

module ID_EX (
  clk,
  Flush,
  // NPCIn, 
  RegData1In, RegData2In, Imm32In, 
  FunctIn, RsIn, RtIn, ShamtIn, 
  // PCNewFromInstrIn,
  ALUSrcIn, ALUOpIn, 
  // RegDistIn, 
  WriteRegAddrIn,
  // RegDistDistIn,
  // BranchIn, 
  MemReadIn, MemWriteIn,
  MemToRegIn, RegWriteIn,
  // NPCOut, 
  RegData1Out, RegData2Out, Imm32Out, 
  FunctOut, RsOut, RtOut, ShamtOut, 
  // PCNewFromInstrOut,
  ALUSrcOut, ALUOpOut, 
  // RegDistOut, 
  WriteRegAddrOut,
  // RegDistDistOut,
  // BranchOut, 
  MemReadOut, MemWriteOut,
  MemToRegOut, RegWriteOut
);

  input clk, Flush;
  input [31:0] RegData1In, RegData2In, Imm32In;
  input [5:0] FunctIn;
  input [4:0] RsIn, RtIn, ShamtIn;
  input ALUSrcIn/*, RegDistIn, RegDistDistIn*/;
  input [4:0] ALUOpIn, WriteRegAddrIn;
  input MemReadIn, MemWriteIn, MemToRegIn, RegWriteIn;

  output reg [31:0] RegData1Out, RegData2Out, Imm32Out;
  output reg [5:0] FunctOut;
  output reg [4:0] RsOut, RtOut, ShamtOut;
  output reg ALUSrcOut/*, RegDistOut, RegDistDistOut*/;
  output reg [4:0] ALUOpOut, WriteRegAddrOut;
  output reg MemReadOut, MemWriteOut, MemToRegOut, RegWriteOut;

  always @(posedge clk) begin
    if (Flush) begin
      RegData1Out <= 0;
      RegData2Out <= 0;
      Imm32Out <= 0;
      FunctOut <= 0;
      RsOut <= 0;
      RtOut <= 0;
      ShamtOut <= 0;
      ALUSrcOut <= 0;
      ALUOpOut <= 0;
      // RegDistOut <= 0;
      WriteRegAddrOut <= 0;
      // RegDistDistOut <= 0;
      MemReadOut <= 0;
      MemWriteOut <= 0;
      MemToRegOut <= 0;
      RegWriteOut <= 0;
    end else begin
      RegData1Out <= RegData1In;
      RegData2Out <= RegData2In;
      Imm32Out <= Imm32In;
      FunctOut <= FunctIn;
      RsOut <= RsIn;
      RtOut <= RtIn;
      ShamtOut <= ShamtIn;
      ALUSrcOut <= ALUSrcIn;
      ALUOpOut <= ALUOpIn;
      // RegDistOut <= RegDistIn;
      WriteRegAddrOut <= WriteRegAddrIn;
      // RegDistDistOut <= RegDistDistIn;
      MemReadOut <= MemReadIn;
      MemWriteOut <= MemWriteIn;
      MemToRegOut <= MemToRegIn;
      RegWriteOut <= RegWriteIn;
    end
  end
endmodule

module EX_MEM (
  clk,
  ALUOutIn,
  // PCSelectedIn,
  RegDataIn,
  WriteRegAddrIn,
  // BranchIn,
  MemReadIn,
  MemWriteIn,
  MemToRegIn,
  RegWriteIn,
  // ZeroIn,

  ALUOutOut,
  // PCSelectedOut,
  RegDataOut,
  WriteRegAddrOut,
  // BranchOut,
  MemReadOut,
  MemWriteOut,
  MemToRegOut,
  RegWriteOut
  // ZeroOut
);

  input clk;
  input [31:0] ALUOutIn, RegDataIn;
  input [4:0] WriteRegAddrIn;
  input MemReadIn, MemWriteIn, MemToRegIn, RegWriteIn;
  output reg [31:0] ALUOutOut, RegDataOut;
  output reg [4:0] WriteRegAddrOut;
  output reg MemReadOut, MemWriteOut, MemToRegOut, RegWriteOut;

  always @(posedge clk) begin
    ALUOutOut <= ALUOutIn;
    RegDataOut <= RegDataIn;
    WriteRegAddrOut <= WriteRegAddrIn;
    MemReadOut <= MemReadIn;
    MemWriteOut <= MemWriteIn;
    MemToRegOut <= MemToRegIn;
    RegWriteOut <= RegWriteIn;
  end
endmodule

module MEM_WB (
  clk,
  DataOutIn, 
  ALUOutIn,
  MemToRegIn,
  WriteRegAddrOutIn,
  RegWriteIn,
  DataOutOut, 
  ALUOutOut,
  MemToRegOut,
  WriteRegAddrOutOut,
  RegWriteOut
);

  input clk;
  input [31:0] DataOutIn, ALUOutIn;
  input MemToRegIn, RegWriteIn;
  input [4:0] WriteRegAddrOutIn;
  output reg [31:0] DataOutOut, ALUOutOut;
  output reg MemToRegOut, RegWriteOut;
  output reg [4:0] WriteRegAddrOutOut;

  always @(posedge clk) begin
    DataOutOut <= DataOutIn;
    ALUOutOut <= ALUOutIn;
    MemToRegOut <= MemToRegIn;
    RegWriteOut <= RegWriteIn;
    WriteRegAddrOutOut <= WriteRegAddrOutIn;
  end
endmodule
