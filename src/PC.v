module PC (
   // clk, rst, PCSel, Imm, PC, PCNew, Jump
   clk, rst, WriteEnable,
   NextPC, PC
   // clk, rst, PCSel, Jump, PCDist, Imm, PCNew, PC
);
   // input clk, rst, PCSel, Jump, PCDist;
   input clk, rst;
   input WriteEnable;
   input [31:0] NextPC;
   // Jump is a signal that is asserted when you want to jump to a new PC
   // If Jump is asserted: 
   //    PCDist = 1: jr
   //    PCDist = 0: j or jal
   // Else:
   //    PCSel = 1: branch
   //    PCSel = 0: no branch
   // input [31:0] Imm;
   // input [31:0] PCNew;
   output reg [31:0] PC;

   // wire  [31:0] NPC;
   // assign NPC = PC + 4;
   
   always @(posedge clk or posedge rst) begin
      if (rst) begin
         PC <= 32'h00003000;
      end else begin
         if (WriteEnable) begin
            PC <= NextPC;
         end else begin
            PC <= PC;
         end
//       end else begin
// //         NPC = PC + 4;
//          if (Jump) begin
//             if (PCDist) begin
//                PC = PCNew;
//             end else begin
//                PC = {NPC[31:28], PCNew[25:0], 2'b00};
//             end
//          end else if (PCSel) begin
//             PC = NPC + {Imm[29:0], 2'b00};
//          end else begin
//             PC = NPC;
//          end
      end
   end

   // mux2 #(.WIDTH(1)) (
   //    .d0(NPC), 
   //    .d1(NPC + {Imm[29:0], 2'b00}), 
   //    .s(PCSel), 
   //    .y(SelectedPC));
   // mux2 #(.WIDTH(1)) (
   //    .d0(SelectedPC),
   //    .d1({NPC[31:28], PCNew[25:0], 2'b00}),
   //    .s(Jump),
   //    .y(NPC);
   // );
endmodule
