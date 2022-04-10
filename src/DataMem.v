module DataMem_4k( DataAddr, WriteData, DMWr, DMRd, clk, DataOut );
   
   input  [11:2] DataAddr;
   input  [31:0] WriteData;
   input         DMRd;
   input         DMWr;
   input         clk;
   output [31:0] DataOut;
     
   reg [31:0] dmem[1023:0];
   
   always @(posedge clk) begin
      $display("DataAddr=%8X",DataAddr);//DataAddr to DM
      $display("WriteData=%8X",WriteData);//data to DM
      $display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",dmem[0],dmem[1],dmem[2],dmem[3],dmem[4],dmem[5],dmem[6],dmem[7]);
    
      if (DMWr)
         dmem[DataAddr] <= WriteData;
   end // end always
   assign DataOut = dmem[DataAddr];
      
endmodule    
