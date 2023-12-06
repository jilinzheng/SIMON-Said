`timescale 1ns / 1ps

module round_test(

    );
    
    reg [31:0] inBlock;
    reg [15:0] subkey;
    wire [31:0] outBlock;
    
    round #(16) DUT(inBlock, subkey, outBlock);
    
    initial begin
        inBlock = 32'b11110000111100001111000011110000;
        subkey = 16'b1100110011001100;
        
        #10 $finish;
    end
    
endmodule
