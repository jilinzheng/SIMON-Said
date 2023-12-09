`timescale 1ns / 1ps

module rightCircShift #(parameter n = 16)(
        input [n-1:0] in,
        output [n-1:0] shiftOneOut, shiftThreeOut
    );
    
    reg [n-1:0] outArray [1:0];
    
    always @ * begin
        outArray[0] = { in[0], in[n-1:1] };     // 1-bit right circular shift
                                                // also -1-bit left cicular shift
        outArray[1] = { in[2:0], in[n-1:3] };   // 3-bit right circular shift
                                                // also -3-bit left circular shift
    end
    
    assign shiftOneOut = outArray[0];
    assign shiftThreeOut = outArray[1];
    
endmodule
