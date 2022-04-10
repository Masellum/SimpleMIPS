/*
Register Number	Conventional Name	Usage
$0	$zero	Hard-wired to 0
$1	$at	Reserved for pseudo-instructions
$2 - $3	$v0, $v1	Return values from functions
$4 - $7	$a0 - $a3	Arguments to functions - not preserved by subprograms
$8 - $15	$t0 - $t7	Temporary data, not preserved by subprograms
$16 - $23	$s0 - $s7	Saved registers, preserved by subprograms
$24 - $25	$t8 - $t9	More temporary registers, not preserved by subprograms
$26 - $27	$k0 - $k1	Reserved for kernel. Do not use.
$28	$gp	Global Area Pointer (base of global data segment)
$29	$sp	Stack Pointer
$30	$fp	Frame Pointer
$31	$ra	Return Address
*/
module RegFile(ReadAddr1, ReadAddr2, WriteAddr, WriteData, clk, RFWr, ReadData1, ReadData2);
    
   input  [4:0]  ReadAddr1, ReadAddr2, WriteAddr;
   input  [31:0] WriteData;
   input         clk;
   input         RFWr;
   output reg [31:0] ReadData1, ReadData2;
   
   reg [31:0] rf[31:0];
   
   integer i;
   initial begin
       for (i=0; i<32; i=i+1)
          rf[i] = 0;
   end
   
   always @(posedge clk) begin
      if (RFWr)
         rf[WriteAddr] <= WriteData;
      
         $display("R[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", rf[0], rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
         $display("R[08-15]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
         $display("R[16-23]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
         $display("R[24-31]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
         $display("R[%4X]=%8X", WriteAddr, rf[WriteAddr]);
      
   end // end always
   always @(negedge clk) begin
      ReadData1 <= (ReadAddr1 == 0) ? 32'd0 : rf[ReadAddr1];
      ReadData2 <= (ReadAddr2 == 0) ? 32'd0 : rf[ReadAddr2];
   end
   
endmodule
