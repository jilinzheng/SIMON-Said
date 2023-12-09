`timescale 1ns / 1ps

module round_test(

    );
    
    reg [63:0] inBlock;
    reg [31:0] subkey;
    wire [63:0] outBlock;
    
    round DUT(inBlock, subkey, outBlock);
    
    initial begin
        inBlock = 64'h6f7220676e696c63;     // first ASCII character entered are LSB "Little Endian"
        subkey = 32'h03020100;              // roundKey[0]    
        
        #10 $finish;
    end
    
endmodule
