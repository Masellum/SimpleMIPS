`timescale 1ns/1ns
module MIPS_tb ();
  reg clk, rst;

  MIPS_Pipeline U_MIPS(
    .clk(clk), 
    .rst(rst)
  );

  initial begin
    $readmemh( "../test21.txt" , U_MIPS.U_IF.U_IM4K.imem ) ;
    $monitor("PC = 0x%8X, IR = 0x%8X", U_MIPS.U_IF.U_PC, U_MIPS.U_IF.Instr ); 
    clk = 1 ;
    rst = 0 ;
    #5 ;
    rst = 1 ;
    #20 ;
    rst = 0 ;
  end
  
  always
    #(50) clk = ~clk;
  
endmodule