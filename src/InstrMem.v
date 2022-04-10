module InstrMem_4k( InstrAddr, InstrOut );
    
    input [11:2] InstrAddr;
    output [31:0] InstrOut;
    
    (* ram_style="block" *) reg [31:0] imem[1023:0];
    
    assign InstrOut = imem[InstrAddr];
    
endmodule    