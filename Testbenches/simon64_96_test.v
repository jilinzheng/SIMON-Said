`timescale 1ns / 1ps

module simon64_96_test(

    );
    
    reg [63:0] plaintext;
    reg [95:0] key;
    wire[63:0] ciphertext;
    
    simon64_96 DUT(plaintext, key, ciphertext);
    
    initial begin
        plaintext = 64'h6f7220676e696c63;
        key = 96'h131211100b0a090803020100;
        // ciphertext should be 0x 5ca2e27f 111a8fc8
    end
    
endmodule
