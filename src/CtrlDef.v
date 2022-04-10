// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10   
`define NPC_JR      2'b11

// EXT control signal
`define EXT_ZERO    2'b00
`define EXT_SIGNED  2'b01
`define EXT_HIGHPOS 2'b10

// ALUOp signal
`define ALUOp_RTYPE 5'b00000
// arithmatic
`define ALUOp_ADDU  5'b00001
`define ALUOp_ADD   5'b00010
`define ALUOp_SUBU  5'b00011
`define ALUOp_SUB   5'b00100 
// bitwise
`define ALUOp_AND   5'b00101
`define ALUOp_OR    5'b00110
`define ALUOp_NOR   5'b00111
`define ALUOp_XOR   5'b01000
// set on less than
`define ALUOp_SLTU  5'b01001
`define ALUOp_SLT   5'b01010 
// equality
`define ALUOp_BEQ   5'b01011
`define ALUOp_BNE   5'b01100
// compare with zero
`define ALUOp_GT0   5'b01101
`define ALUOp_GE0   5'b01110
`define ALUOp_LT0   5'b01111
`define ALUOp_LE0   5'b10000
// shift
`define ALUOp_SLL   5'b10001
`define ALUOp_SRL   5'b10010
`define ALUOp_SRA   5'b10011
// lui
`define ALUOp_LUI   5'b10111
// jal
`define ALUOp_JAL   5'b11011
// null
`define ALUOp_NULL  5'b11111

// ALU control signal
// arithmatic
`define ALUCtrl_ADDU  5'b00001
`define ALUCtrl_ADD   5'b00010
`define ALUCtrl_SUBU  5'b00011
`define ALUCtrl_SUB   5'b00100 
// bitwise
`define ALUCtrl_AND   5'b00101
`define ALUCtrl_OR    5'b00110
`define ALUCtrl_NOR   5'b00111
`define ALUCtrl_XOR   5'b01000
// set on less than
`define ALUCtrl_SLTU  5'b01001
`define ALUCtrl_SLT   5'b01010 
// equality
`define ALUCtrl_BEQ   5'b01011
`define ALUCtrl_BNE   5'b01100
// compare with zero
`define ALUCtrl_GT0   5'b01101
`define ALUCtrl_GE0   5'b01110
`define ALUCtrl_LT0   5'b01111
`define ALUCtrl_LE0   5'b10000
// shift
`define ALUCtrl_SLL   5'b10001
`define ALUCtrl_SRL   5'b10010
`define ALUCtrl_SRA   5'b10011
// lui
`define ALUCtrl_LUI   5'b10111
`define ALUCtrl_JAL   5'b11011
`define ALUCtrl_NULL  5'b11111

// ALU Inner Operation signal
`define ALUInner_AND  2'b00
`define ALUInner_OR   2'b01
`define ALUInner_ADD  2'b10
`define ALUInner_LESS 2'b11

// EXT control signal
`define EXT_ZERO    2'b00
`define EXT_SIGNED  2'b01
`define EXT_HIGHPOS 2'b10