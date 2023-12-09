`timescale 1ns / 1ps

/*
    The expected outputs during each simulation interval are obtained from
    the official NSA SIMON Implementation Guide:
    https://nsacyber.github.io/simon-speck/implementations/ImplementationGuide1.1.pdf
*/

module keySchedule_test(

    );
    
    reg [31:0] seqC;
    reg [61:0] constSeqZ;
    reg [31:0] roundKeyMinus3, roundKeyMinus1;
    
    wire [61:0] shiftZ;
    wire [31:0] roundKey;
    
    keySchedule DUT(seqC, constSeqZ, roundKeyMinus3, roundKeyMinus1, shiftZ, roundKey);
    
    initial begin
        seqC = 32'hfffffffc;
        constSeqZ = 64'h7369f885192c0ef5; // 64/96
        roundKeyMinus3 = 32'h03020100;
        roundKeyMinus1 = 32'h13121110;
        // Output should be 0xffae9dce
        
        #10;
        constSeqZ = shiftZ;
        roundKeyMinus3 = 32'h0b0a0908;
        roundKeyMinus1 = 32'hffae9dce;
        // Output should be 0xc4facc91
        
        // ADD 8 MORE
    end
endmodule
