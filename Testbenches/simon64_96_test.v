`timescale 1ns / 1ps

module simon64_96_test(

    );
    
    reg [63:0] plaintext;
    reg [95:0] key; 
    wire[31:0] iterKey;
    wire[63:0] ciphertext;
    
    simon64_96 DUT(plaintext, key, iterKey, ciphertext);
    
    initial begin
        plaintext = 1;
        key = 96'h131211100b0a090803020100;
    end
    
endmodule
