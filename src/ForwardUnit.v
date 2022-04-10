module ForwardUnit(
  IF_ID_Rs,
  IF_ID_Rt,
  ID_EX_Rs,
  ID_EX_Rt,
  ID_EX_Rd,
  EX_MEM_Rd,
  MEM_WB_Rd,
  ID_EX_RegWrite,
  EX_MEM_RegWrite,
  MEM_WB_RegWrite,
  Forward1, 
  Forward2,
  ForwardToID1,
  ForwardToID2
);
  input [4:0] IF_ID_Rs, IF_ID_Rt, ID_EX_Rs, ID_EX_Rt, ID_EX_Rd, EX_MEM_Rd, MEM_WB_Rd;
  input ID_EX_RegWrite, EX_MEM_RegWrite, MEM_WB_RegWrite;
  output reg [1:0] Forward1, Forward2, ForwardToID1, ForwardToID2;

  initial begin
    Forward1 <= 0;
    Forward2 <= 0;
    ForwardToID1 <= 0;
    ForwardToID2 <= 0;
  end

  always @(*) begin
    if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rs)) begin
      Forward1 <= 2'b10;
    end else if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rs)) begin
      Forward1 <= 2'b01;
    end else begin
      Forward1 <= 2'b00;
    end

    if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == ID_EX_Rt)) begin
      Forward2 <= 2'b10;
    end else if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == ID_EX_Rt)) begin
      Forward2 <= 2'b01;
    end else begin
      Forward2 <= 2'b00;
    end

    if (ID_EX_RegWrite && (ID_EX_Rd != 0) && (ID_EX_Rd == IF_ID_Rs)) begin
      ForwardToID1 <= 2'b11;
    end else if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == IF_ID_Rs)) begin
      ForwardToID1 <= 2'b10;
    end else if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == IF_ID_Rs)) begin
      ForwardToID1 <= 2'b01;
    end else begin
      ForwardToID1 <= 2'b00;
    end

    if (ID_EX_RegWrite && (ID_EX_Rd != 0) && (ID_EX_Rd == IF_ID_Rt)) begin
      ForwardToID2 <= 2'b11;
    end else if (EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == IF_ID_Rt)) begin
      ForwardToID2 <= 2'b10;
    end else if (MEM_WB_RegWrite && (MEM_WB_Rd != 0) && (MEM_WB_Rd == IF_ID_Rt)) begin
      ForwardToID2 <= 2'b01;
    end else begin
      ForwardToID2 <= 2'b00;
    end
  end

endmodule