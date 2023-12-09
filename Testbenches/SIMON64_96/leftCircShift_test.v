`timescale 1ns / 1ps

module leftCircShift_test(

    );
    
    reg [15:0] in;
    wire [15:0] shiftOneOut, shiftTwoOut, shiftEightOut;
    
    leftCircShift #(16) DUT(in, shiftOneOut, shiftTwoOut, shiftEightOut);
    
    initial begin
        in = 16'b1010010010001111;
        
        #10 in = 16'b1111000011110000;
        
        #10 in = 16'b1100110011001100;
        
        #10 in = 16'b1111000111110001;
        
        #10 $finish;
    end
    
endmodule
