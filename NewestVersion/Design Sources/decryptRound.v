`timescale 1ns / 1ps

module decryptRound #(parameter n = 32)(       
    // Parametrized n-bit word size (Note that n = 16, 24, 32, 48, or 64 ONLY)
    input [2*n-1:0] inBlock,         // Input 2n-bit block
    input [n-1:0] roundKey,          // Input n-bit roundKey (from keySchedule)

    output [2*n-1:0] outBlock        // Output 2n-bit block
    );

    // Split inBlock into n-bit words
    wire [n-1:0] wordX = inBlock[n-1:0];         // Least-significant n-bits P/Ct[0]
    wire [n-1:0] wordY = inBlock[2*n-1:n];       // Most-significant n-bits P/Ct[1]
    
    
    // Execute round operations
    reg [n-1:0] newX, newY, temp;                // To hold during and output after the round
    always @ * begin
        temp = wordX;
        newX = wordY ^
                ({ wordX[n-2:0], wordX[n-1] } & { wordX[n-9:0], wordX[n-1:n-8] }) ^
                {wordX[n-3:0], wordX[n-1:n-2]} ^
                roundKey;
        newY = temp;
    end
    
    
    assign outBlock = {newY, newX};

endmodule
