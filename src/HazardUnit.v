module HazardUnit (
  ID_EX_MemRead, 
  EX_MEM_MemRead,
  ID_EX_Rt,
  EX_MEM_Rt,
  IF_ID_Rs,
  IF_ID_Rt,
  Branch,
  NPCCtrl,
  IF_ID_WE,
  IF_ID_Flush,
  ID_EX_Flush,
  PC_WE
);

  input EX_MEM_MemRead, ID_EX_MemRead, Branch;
  input [4:0] ID_EX_Rt, EX_MEM_Rt, IF_ID_Rs, IF_ID_Rt;
  input [1:0] NPCCtrl;
  output reg IF_ID_WE, IF_ID_Flush, ID_EX_Flush, PC_WE;
  initial begin
    IF_ID_WE = 1;
    IF_ID_Flush = 0;
    ID_EX_Flush = 0;
    PC_WE = 1;
  end

  always @(*) begin
    if (ID_EX_MemRead && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt)) begin
      IF_ID_WE <= 0;
      IF_ID_Flush <= 0;
      ID_EX_Flush <= 1;
      PC_WE <= 0;
    end else if (NPCCtrl != 2'b00) begin
      if (NPCCtrl == 2'b01) begin
        if (EX_MEM_MemRead && (EX_MEM_Rt == IF_ID_Rs || EX_MEM_Rt == IF_ID_Rt)) begin
          IF_ID_WE <= 0;
          IF_ID_Flush <= 0;
          ID_EX_Flush <= 1;
          PC_WE <= 0;
        end else if (Branch) begin
          IF_ID_WE <= 1;
          IF_ID_Flush <= 1;
          ID_EX_Flush <= 0;
          PC_WE <= 1;
        end else begin
          IF_ID_WE <= 1;
          IF_ID_Flush <= 0;
          ID_EX_Flush <= 0;
          PC_WE <= 1;
        end
      end else begin
        IF_ID_WE <= 1;
        IF_ID_Flush <= 1;
        ID_EX_Flush <= 0;
        PC_WE <= 1;
      end
    end else begin
      IF_ID_WE <= 1;
      IF_ID_Flush <= 0;
      ID_EX_Flush <= 0;
      PC_WE <= 1;
    end
  end

endmodule