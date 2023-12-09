`timescale 1ns / 1ps

module leftCircShift #(parameter n = 16)(           // Default to smallest word size 16
        input [n-1:0] in,
        output [n-1:0] shiftOneOut, shiftTwoOut, shiftEightOut
    );
    
    reg [n-1:0] outArray [2:0]; 
    
    always @ * begin
        outArray[0] = { in[n-2:0], in[n-1] };       // 1-bit left circular shift
        outArray[1] = { in[n-3:0], in[n-1:n-2] };   // 2-bit left circular shift
        outArray[2] = { in[n-9:0], in[n-1:n-8] };   // 8-bit left circular shift
    end
    
    assign shiftOneOut = outArray[0];
    assign shiftTwoOut = outArray[1];
    assign shiftEightOut = outArray[2];
    
endmodule
