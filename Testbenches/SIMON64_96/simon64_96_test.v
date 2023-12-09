`timescale 1ns / 1ps

module simon64_96_test(

    );
    
    reg encryptOrDecrypt;
    reg [63:0] inText;
    reg [95:0] key;
    wire[63:0] outText;
    
    simon64_96 DUT(encryptOrDecrypt, inText, key, outText);
    
    initial begin
        encryptOrDecrypt = 1;
        inText = 64'h6f7220676e696c63;
        key = 96'h131211100b0a090803020100;
        // encryption; outText should be 0x 5ca2e27f 111a8fc8, begins @ LSB
        
        #50;
        encryptOrDecrypt = 0;
        inText = 64'h5ca2e27f111a8fc8;
        // outText should go back to the original inText 0x 6f722067 6e696c63
    end
    
endmodule
