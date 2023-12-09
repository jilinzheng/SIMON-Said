`timescale 1ns / 1ps

module simon64_96(
        input [63:0] plaintext,     // 64-bit block size => 32-bit word size = n
        input [95:0] key,           // 96-bit key size/32-bit words = 3 key words = m
        
        output [31:0] iterKey,      // test key that prints the keys during generate iterations
        output [63:0] ciphertext    // encrypted text
    );
    
    // Key scheduling
    reg [31:0] roundKeys [41:0];    // 42, 32-bit round keys for 42 rounds SIMON64/96
    initial begin
        roundKeys[0] = key[31:0];
        $display ("The %d th roundKey is %h. ", 0, roundKeys[0]);
        roundKeys[1] = key[63:32];
        $display ("The %d th roundKey is %h. ", 1, roundKeys[1]);
        roundKeys[2] = key[95:64];
        $display ("The %d th roundKey is %h. ", 2, roundKeys[2]);
    end
    
    reg [31:0] seqC = 32'hfffffffc;
    
    reg [61:0] z [4:0];             // Declare 5 constant sequences of 62-bit length
    initial begin                   // Instantiate constant sequences
        z[0] = 62'b11111010001001010110000111001101111101000100101011000011100110;
        z[1] = 62'b10001110111110010011000010110101000111011111001001100001011010;
        z[2] = 62'b10101111011100000011010010011000101000010001111110010110110011; // 64/96
        z[3] = 62'b11011011101011000110010111100000010010001010011100110100001111;
        z[4] = 62'b11010001111001101011011000100000010111000011001010010011101111;
    end
    
    wire [61:0] shiftZ = z[2];
    
    genvar i;
    generate                        // Generate all roundKeys
        for (i = 3; i < 42; i = i + 1) begin
            keySchedule rk(seqC, shiftZ, roundKeys[i-3], roundKeys[i-1], roundKeys[i]);
            assign shiftZ = shiftZ >> 1;
            initial begin
                $display ("Newly-generated %d roundKey is %h. ", i, roundKeys[i]);
            end
            assign iterKey = roundKeys[i];
        end
    endgenerate
    
    // Round
    
endmodule