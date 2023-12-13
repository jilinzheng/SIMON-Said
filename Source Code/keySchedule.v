`timescale 1ns / 1ps

module keySchedule #(
        parameter n = 32,               // Word size
        parameter m = 3                 // Number of key words
        )(
        input [n-1:0] seqC,             // 2^n - 4; 32 bits to store
        input [61:0] constSeqZ,         // Constant sequence z_0...z_5 (z_2 for 64/96)
        input [n-1:0] roundKeyMinus3,   // rk[i-3] input key
        input [n-1:0] roundKeyMinus1,   // rk[i-1] input key
        
        output reg [61:0] shiftZ,       // Shifted constant sequence
        output reg [n-1:0] roundKey     // Generated roundKey
    );
    
    // Key Scheduling (just one key)
    always @ * begin
        roundKey = seqC ^
                   (constSeqZ & 1) ^
                   roundKeyMinus3 ^
                   { roundKeyMinus1[2:0], roundKeyMinus1[n-1:3] } ^     // 3-bit right circular shift
                   { roundKeyMinus1[3:0], roundKeyMinus1[n-1:4] };      // 4-bit right circular shift
        shiftZ = constSeqZ >> 1;
    end
    
endmodule