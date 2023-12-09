`timescale 1ns / 1ps

module simon64_96(
        input [63:0] plaintext,     // 64-bit block size => 32-bit word size = n
        input [95:0] key,           // 96-bit key size/32-bit words = 3 key words = m
        
        //output [31:0] finalKey,      // test key that prints the keys during generate iterations
        output [63:0] ciphertext    // encrypted text
    );
    
    // For a SIMON64/96 cipher,
    localparam T = 42;  // rounds
    localparam j = 2;   // jth bit of constSeqZ
    
    // Key scheduling
    wire [31:0] roundKeys [41:0];   // 42, 32-bit round keys for 42 rounds SIMON64/96
    /*
    initial begin
        roundKeys[0] = key[31:0];
        $display ("The %d th roundKey is %h. ", 0, roundKeys[0]);
        roundKeys[1] = key[63:32];
        $display ("The %d th roundKey is %h. ", 1, roundKeys[1]);
        roundKeys[2] = key[95:64];
        $display ("The %d th roundKey is %h. ", 2, roundKeys[2]);
    end
    */
    assign roundKeys[0] = key[31:0];
    assign roundKeys[1] = key[63:32];
    assign roundKeys[2] = key[95:64];
    /*
    always @ * begin
        $display ("roundKey %d is %h. ", 0, roundKeys[0]);
        $display ("roundKey %d is %h. ", 1, roundKeys[1]);
        $display ("roundKey %d is %h. ", 2, roundKeys[2]);
    end
    */
    
    reg [31:0] seqC = 32'hfffffffc;
    /*
    reg [61:0] z [4:0];             // Declare 5 constant sequences of 62-bit length
    initial begin                   // Instantiate constant sequences
        z[0] = 62'b11111010001001010110000111001101111101000100101011000011100110;
        z[1] = 62'b10001110111110010011000010110101000111011111001001100001011010;
        z[2] = 62'b10101111011100000011010010011000101000010001111110010110110011; // 64/96
        z[3] = 62'b11011011101011000110010111100000010010001010011100110100001111;
        z[4] = 62'b11010001111001101011011000100000010111000011001010010011101111;
        $display("z[2] is %h", z[2]);
    end
    */
    wire [63:0] shiftZs [39:0];
    assign shiftZs[0] = 64'h7369f885192c0ef5;       // Refer to SIMON Implementation Guide for 64/96
    
    genvar i;
    generate                        // Generate all roundKeys
        for (i = 3; i < 42; i = i + 1) begin
            keySchedule rk(seqC, shiftZs[i-3], roundKeys[i-3], roundKeys[i-1], shiftZs[i-2], roundKeys[i]);
            always @ * begin
                //$display ("Previous shiftZ was %b",shiftZs[i-3]);
                $display ("Newly-generated %d roundKey is %h. ", i, roundKeys[i]);
            end
        end
    endgenerate
    //assign final = roundKeys[41];
    
    // Round
    wire [63:0] intermediates [41:0];
    round r0(plaintext, roundKeys[0], intermediates[0]);
    generate
        for (i = 1; i < 42; i = i + 1) begin
            round r(intermediates[i-1], roundKeys[i], intermediates[i]);
            always @ * begin
                //$display ("Previous shiftZ was %b",shiftZs[i-3]);
                $display ("Intermediate %d is %h. ", i, intermediates[i]);
            end    
        end
    endgenerate
    
    assign ciphertext = intermediates[41];
    
endmodule