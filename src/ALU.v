`include "CtrlDef.v"

module ALU_UsingAdder (
  ALUIn1,
  ALUIn2,
  ALUInShamt,
  ALUCtrl,
  Zero,
  ALUOut
);

  input [31:0] ALUIn1, ALUIn2;
  input [4:0] ALUInShamt;
  input [4:0] ALUCtrl;
  output Zero;
  output [31:0] ALUOut;

  reg [1:0] Operation; // 0: AND; 1: OR; 2: Adder; 3: Less;
  reg Anegate, Bnegate; // Act as negate signal in arithmatical operations and bitwise not signal in bitwise operations
  wire Signed, Carry;

  wire [31:0] AdderOut;
  reg signed [31:0] ShifterOut;
  wire AdderZero, Overflow;

  assign Signed = ~(ALUCtrl[0]);
  assign Carry = (ALUCtrl != `ALUCtrl_XOR);
  assign Zero = (ALUCtrl[0] & ALUCtrl[1] & ~ALUCtrl[2] & ALUCtrl[3]) ? AdderZero : ~AdderZero;
  assign ALUOut = (ALUCtrl[4]) & (ALUCtrl[1] || ALUCtrl[0]) ? ShifterOut : AdderOut;

  FullAdder32Bits fullAdder32Bits(
    .a(ALUIn1),
    .b(ALUIn2),
    .Operation(Operation),
    .Anegate(Anegate),
    .Bnegate(Bnegate),
    .Signed(Signed),
    .Carry(Carry),
    .Result(AdderOut),
    .Zero(AdderZero),
    .Overflow(Overflow)
  );

  always @(ALUIn1 or ALUIn2 or ALUCtrl) begin
    case (ALUCtrl)
      `ALUCtrl_ADD, `ALUCtrl_ADDU : begin
        Operation = `ALUInner_ADD;
        Anegate = 1'b0;
        Bnegate = 1'b0;
      end
      `ALUCtrl_SUB, `ALUCtrl_SUBU : begin
        Operation = `ALUInner_ADD;
        Anegate = 1'b0;
        Bnegate = 1'b1;
      end
      `ALUCtrl_AND : begin
        Operation = `ALUInner_AND;
        Anegate = 1'b0;
        Bnegate = 1'b0;
      end
      `ALUCtrl_NOR : begin
        Operation = `ALUInner_AND;
        Anegate = 1'b1;
        Bnegate = 1'b1;
      end
      `ALUCtrl_OR : begin
        Operation = `ALUInner_OR;
        Anegate = 1'b0;
        Bnegate = 1'b0;
      end
      `ALUCtrl_XOR : begin
        Operation = `ALUInner_ADD;
        Anegate = 1'b0;
        Bnegate = 1'b0;
      end
      `ALUCtrl_SLT, `ALUCtrl_SLTU : begin
        Operation = `ALUInner_LESS;
        Anegate = 1'b0;
        Bnegate = 1'b1;
      end
      `ALUCtrl_BEQ : begin
        Operation = `ALUInner_ADD;
        Anegate = 1'b0;
        Bnegate = 1'b1;
//        Zero = AdderZero;
      end
      `ALUCtrl_BNE : begin
        Operation = `ALUInner_ADD;
        Anegate = 1'b0;
        Bnegate = 1'b1;
//        Zero = ~AdderZero;
      end
      `ALUCtrl_SLL : begin
        ShifterOut = $signed(ALUIn2) << ALUInShamt;
      end
      `ALUCtrl_SRL : begin
        ShifterOut = $signed(ALUIn2) >> ALUInShamt;
      end
      `ALUCtrl_SRA : begin
        ShifterOut = $signed(ALUIn2) >>> ALUInShamt;
      end
      `ALUCtrl_LUI, `ALUCtrl_JAL : begin
        ShifterOut = ALUIn2;
      end
      `ALUCtrl_NULL : begin
//        AdderOut = 0;
        ShifterOut = 0;
      end
      default : begin
        Operation = 1'b0;
        Anegate = 1'b0;
        Bnegate = 1'b0;
      end
    endcase
  end
endmodule

// module ALU_UsingBehavior (
//   ALUIn1,
//   ALUIn2,
//   ALUCtrl,
//   Zero,
//   ALUOut
// );
//   input [31:0] ALUIn1, ALUIn2;
//   input [4:0] ALUCtrl;
//   output Zero;
//   output [31:0] ALUOut;

//   reg [31:0] AdderIn1, AdderIn2;
//   reg [1:0] Operation; // 0: AND; 1: OR; 2: Adder; 3: Less;
//   wire Signed;

//   reg [31:0] AdderOut, ShifterOut;
//   wire AdderZero, Overflow;

//   assign Signed = ~(ALUCtrl[0]);
//   assign ALUOut = (ALUCtrl[4]) & (ALUCtrl[1] || ALUCtrl[0]) ? ShifterOut : AdderOut;

//   always @(A or B or ALUCtrl) begin
//     case (ALUCtrl)
//       case `ALUCtrl_ADD, `ALUCtrl_ADDU: begin
//       end
//       case `ALUCtrl_SUB, `ALUCtrl_SUBU: 
//       case `ALUCtrl_AND: 
//       case `ALUCtrl_NOR: 
//       case `ALUCtrl_OR: 
//       case `ALUCtrl_XOR: 
//       case `ALUCtrl_SLT, `ALUCtrl_SLTU: 
//       case `ALUCtrl_SLL: 
//       case `ALUCtrl_SRL: 
//       case `ALUCtrl_SRA: 
//       default: 
//     endcase
//   end
// endmodule