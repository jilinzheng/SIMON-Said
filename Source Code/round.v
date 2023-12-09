`timescale 1ns / 1ps
module round #(parameter n = 16)(       
    // Parametrized n-bit word size (Note that n = 16, 24, 32, 48, or 64 ONLY)
    input [2*n-1:0] inBlock,         // Input 2n-bit block
    input [n-1:0] subkey,            // Input n-bit subkey (from keySchedule)

    output [2*n-1:0] outBlock        // Output 2n-bit block
);

    // Split inBlock into n-bit words
    wire [n-1:0] wordX = inBlock[n-1:0];        // Least significant n-bits
    wire [n-1:0] wordY = inBlock[2*n-1:n-1];    // Most significant n-bits
    
    // Originally used for shifting, but not necessary with new implementation
    /*
    // Instantiate left circular shift module and wires to pass shifting output
    wire [n-1:0] shiftOneOut, shiftTwoOut, shiftEightOut;
    leftCircShift shiftThree(wordX, shiftOneOut, shiftTwoOut, shiftEightOut);
    */
    
    // Execute round operations
    reg [n-1:0] newX, newY, temp;               // To hold during and output after the round
    always @ * begin
        temp = wordX;
        //$display ("wordX is: %d", wordX);  // Check wordX has not been accidentally changed
        newX = wordY ^
                ({ wordX[n-2:0], wordX[n-1] } & { wordX[n-9:0], wordX[n-1:n-8] }) ^
                //(shiftOneOut & shiftEightOut) ^
                {wordX[n-3:0], wordX[n-1:n-2]} ^
                //shiftTwoOut ^
                subkey;
        newY = temp;
    end
    
    assign outBlock = {newX, newY};

endmodule
