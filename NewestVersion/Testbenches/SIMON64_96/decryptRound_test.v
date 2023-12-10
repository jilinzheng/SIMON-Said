`timescale 1ns / 1ps

module decryptRound_test(

    );
    
    reg [63:0] inBlock;
    reg [31:0] subkey;
    wire [63:0] outBlock;
    
    decryptRound DUT(inBlock, subkey, outBlock);
    
    initial begin
        inBlock = 64'h5ca2e27f111a8fc8;     // First ASCII character entered is LSB (0x63)
        subkey = 32'hb082bddc;              // roundKey[41]    
        
        #10 $finish;
    end
    
endmodule
