`timescale 1ns / 1ps

module keySchedule #(
        parameter n = 32,               // word size
        parameter m = 3                 // number of key words
        )(
        input [n-1:0] seqC,             // 2^n - 4; 32 bits to store
        input [61:0] constSeqZ,         // constant sequence z_0...z_5 (z_2 for 64/96)
        input [n-1:0] roundKeyMinus3,   // rk[i-3] input key
        input [n-1:0] roundKeyMinus1,   // rk[i-1] input key
        
        output reg [61:0] shiftZ,
        output reg [n-1:0] roundKey     // generated roundKey
    );
    
    // Only word size of 32 supported right now
    localparam T = 42;      // T rounds (CURRENTLY NOT USED)
    localparam j = 2;       // z_[j] constant sequence (CURRENTLY NOT USED)
    
    // Key scheduling (one key)
    /* doing the overall expansion via generate blocks 'outside', so one roundkey 'inside'
    integer i;
    reg [n-1:0] temp;
    always @ (*) begin
        for (i = m; i < T - 1; i = i+1) begin
            
        end
    end
    */
    always @ * begin
        roundKey = seqC ^
                   (constSeqZ & 1) ^
                   roundKeyMinus3 ^
                   { roundKeyMinus1[2:0], roundKeyMinus1[n-1:3] } ^ // 3-bit right circular shift
                   { roundKeyMinus1[3:0], roundKeyMinus1[n-1:4] };  // 4-bit right circular shift
        shiftZ = constSeqZ >> 1;
    end
    
endmodule