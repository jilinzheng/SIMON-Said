`timescale 1ns / 1ps

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
        constSeqZ = 62'b10101111011100000011010010011000101000010001111110010110110011; // 64/96
        roundKeyMinus3 = 32'h03020100;
        roundKeyMinus1 = 32'h13121110;
        // Output should be 0xffae9dce
        
        #10;
        constSeqZ = shiftZ;
        roundKeyMinus3 = 32'h0b0a0908;
        roundKeyMinus1 = 32'hffae9dce;
        // Output should be 0xc4facc91
        
    end
endmodule
