`timescale 1ns / 1ps

module simon64_96(
        input encryptOrDecrypt,                     // Select encryption (1, outText = ciphertext) or 
                                                    //        decryption (0, outText = plaintext) output
        input [63:0] inText,                        // Input 64-bit block size => 32-bit word size = n
        input [95:0] key,                           // 96-bit key size/32-bit words = 3 key words = m
        output [63:0] outText                       // Output text 
    );
    
    // For a SIMON64/96 cipher,
    localparam T = 42;                              // Rounds
    localparam j = 2;                               // jth bit of constSeqZ
    
    
    // Key-Scheduling
    wire [31:0] roundKeys [41:0];                   // 42, 32-bit round keys for 42 rounds SIMON64/96
    assign roundKeys[0] = key[31:0];                // Split the "base" key into the first three roundKeys
    assign roundKeys[1] = key[63:32];
    assign roundKeys[2] = key[95:64];
    
    reg [31:0] seqC = 32'hfffffffc;                 // The constant sequence C, 2^32(word size) - 4

    wire [63:0] shiftZs [39:0];                     // The constant sequence Z (Z_[2] for SIMON64/96)
    assign shiftZs[0] = 64'h7369f885192c0ef5;       // Refer to SIMON Implementation Guide for more info
    
    genvar i;
    generate                                        // Generate all roundKeys via the keySchedule module
        for (i = 3; i < 42; i = i + 1) begin
            keySchedule rk(seqC, shiftZs[i-3], roundKeys[i-3], roundKeys[i-1], shiftZs[i-2], roundKeys[i]);
        end
    endgenerate
    
    
    // Encryption Rounds
    wire [63:0] encryptRounds [41:0];                                   // 42, 64-bit blocks after 42 encryption rounds
    encryptRound r0Encrypt(inText, roundKeys[0], encryptRounds[0]);     // First round of encryption
    generate                                                            // Generate 42 rounds of encryption,
        for (i = 1; i < 42; i = i + 1) begin                            // with the last round (index 41) being the appropriate ciphertext
            encryptRound rEncrypt(encryptRounds[i-1], roundKeys[i], encryptRounds[i]);
        end
    endgenerate
    
    
    // Decryption Rounds
    wire [63:0] decryptRounds [41:0];                                   // 42, 64-bit blocks after 42 decryption rounds
    decryptRound r0Decrypt(inText, roundKeys[41], decryptRounds[41]);   // First round of decryption
    generate                                                            // Generate 42 rounds of decryption,
        for (i = 40; i >= 0; i = i - 1) begin                           // with the last round (index 0) being the appropriate plaintext
            decryptRound rDecrypt(decryptRounds[i+1], roundKeys[i], decryptRounds[i]);
        end
    endgenerate
    
    
    // Select appropriate text to output based on user-input - CONSTRAINTS
    assign outText = encryptOrDecrypt ? encryptRounds[41] : decryptRounds[0];
    
endmodule