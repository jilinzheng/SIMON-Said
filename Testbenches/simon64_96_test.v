`timescale 1ns / 1ps

// Test cases based on:
// 1. https://nsacyber.github.io/simon-speck/implementations/ImplementationGuide1.1.pdf
// 2. https://github.com/weidai11/cryptopp/blob/master/TestVectors/simon.txt

module simon64_96_test(

    );
    
    reg encryptOrDecrypt;
    reg [63:0] inText;
    reg [95:0] key;
    wire[63:0] outText;
    
    simon64_96 DUT(encryptOrDecrypt, inText, key, outText);
    
    initial begin
        // Test Case 1: Encryption
        encryptOrDecrypt = 1;
        inText = 64'h6f7220676e696c63;
        key = 96'h131211100b0a090803020100;
        // Expected output: 5ca2e27f 111a8fc8
        
        #50;
        // Test Case 2: Decryption
        encryptOrDecrypt = 0;
        inText = 64'h5ca2e27f111a8fc8;
        // Expected output: 6f722067 6e696c63

        #50;
        // Test Case 3:  Encryption
        encryptOrDecrypt = 1;
        inText = 64'hf8be1e4be52e7efd;
        key = 96'h51b4e07ffd3067d270dd4dc0;
        // Expected output: 8de637a082160b57
        
        #50;
        // Test Case 4: Decryption
        encryptOrDecrypt = 0;
        inText = 64'h8de637a082160b57;
        // Expected output: f8be1e4be52e7efd

        #50;
        // Test Case 5:  Encryption
        encryptOrDecrypt = 1;
        inText = 64'hee7cb6fa9d7b6b70;
        key = 96'h0a44881ec268860d74deac5a;
        // Expected output: 731a0b7101efa776
        
        #50;
        // Test Case 6: Decryption
        encryptOrDecrypt = 0;
        inText = 64'h731a0b7101efa776;
        // Expected output: hee7cb6fa9d7b6b70
        
        #50;
        // Test Case 7:  Encryption
        encryptOrDecrypt = 1;
        inText = 64'h92bc1d624c731163;
        key = 96'h0049155b7bd97b963597a373;
        // Expected output: 718c09ce96dc1bce
        
        #50;
        // Test Case 8: Decryption
        encryptOrDecrypt = 0;
        inText = 64'h718c09ce96dc1bce;
        // Expected output: 92bc1d624c731163
        
        #50;
        // Test Case 9:  Encryption
        encryptOrDecrypt = 1;
        inText = 64'he886ce695553e545;
        key = 96'hbb3f847a756a5650e829645d;
        // Expected output: 15265d5f5818cffe

        #50;
        // Test Case 10: Decryption
        encryptOrDecrypt = 0;
        inText = 64'h15265d5f5818cffe;
        // Expected output: e886ce695553e545       
        
    end
    
endmodule
