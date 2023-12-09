`timescale 1ns / 1ps

module simon64_96(
        input encryptOrDecrypt,     // Select encryption (1) or decryption (0) output
        input [63:0] inText,     // 64-bit block size => 32-bit word size = n
        input [95:0] key,           // 96-bit key size/32-bit words = 3 key words = m
        
        //output [31:0] finalKey,      // test key that prints the keys during generate iterations
        output [63:0] outText    // encrypted text
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
            /*
            always @ * begin
                //$display ("Previous shiftZ was %b",shiftZs[i-3]);
                $display ("Newly-generated %d roundKey is %h. ", i, roundKeys[i]);
            end
            */
        end
    endgenerate
    //assign final = roundKeys[41];
    
    // Encryption Rounds - left off trying to NOT save all rounds (unnecessary)
    wire [63:0] encryptRounds [41:0];
    //wire [63:0] encryptRounds [1:0];
    round r0Encrypt(inText, roundKeys[0], encryptRounds[0]);
    generate
        for (i = 1; i < 42; i = i + 1) begin
            round rEncrypt(encryptRounds[i-1], roundKeys[i], encryptRounds[i]);
            always @ * begin
                $display ("encryptRound %d is %h.",i,encryptRounds[i]);
            end
            /*
            case (i % 2)
                0: round r(intermediates[1], roundKeys[i], intermediates[0]);
                1: round r(intermediates[0], roundKeys[i], intermediates[1]);
            endcase
            */
            /*
            always @ * begin
                //$display ("Previous shiftZ was %b",shiftZs[i-3]);
                $display ("Intermediate %d is %h. ", i, encryptRounds[i]);
            end
            */
        end
    endgenerate
    
    // Decryption Rounds - left off trying to implement decryption
    wire [63:0] decryptRounds [41:0];
    //decryptRound r0Decrypt({ inText[31:0], inText[63:32] }, roundKeys[41], decryptRounds[41]);
    decryptRound r0Decrypt(inText, roundKeys[41], decryptRounds[41]);
    always @ * begin $display ("First(41st?) decryptRound: %h",decryptRounds[41]); end
    
    generate
        for (i = 40; i >= 0; i = i - 1) begin
            decryptRound rDecrypt(decryptRounds[i+1], roundKeys[i], decryptRounds[i]);
            always @ * begin
                $display ("decryptRound %d is %h.",i,decryptRounds[i]);
            end
        end
    endgenerate
    
    // Select appropriate text to output
    assign outText = encryptOrDecrypt ? encryptRounds[41] : decryptRounds[0];
    
endmodule