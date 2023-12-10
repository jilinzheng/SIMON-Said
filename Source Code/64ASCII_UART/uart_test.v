`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//
//Code adapted from https://www.youtube.com/watch?v=L1D5rBwGTwY, FPGA DUDE
//
//////////////////////////////////////////////////////////////////////////////////

module uart_test(
    input clk_100MHz,       //  FPGA clock signal
    input reset,            // btnR    
    input btn,              //encrypt button
    input rx,               // USB-RS232 Rx
    output tx,              // USB-RS232 Tx
    output [7:0] an,        // 7 segment display digits
    output [0:6] seg        // 7 segment display segments
    );
    
    // Connection Signals
    wire rx_full, rx_empty; //to display on 7 segment to help keep track of whats going on
    
    //variables encrypt in middle of fifos, CHANGE THESE TO EXACT AMOUNT OF BITS WORKING WITH
    wire [511:0] encrypt_in, encrypt_out;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .encrypt(btn_tick),     //encrypt when button pressed
            .rx(rx),                //receieved data
            .tx(tx),                //transmitted data
            .rx_full(rx_full),      //buffer full for 7 segment
            .rx_empty(rx_empty),    //buffer empty for 7 segment
            .read_data(encrypt_in),     //data into output buffer
            .write_data(encrypt_out)    //data from input buffer
        );
        
    // Button Debouncer
    debounce_explicit BUTTON_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn),         
            .db_level(),  
            .db_tick(btn_tick)  //the button will start encoding so needs to be debounced
        );
    
    //display if buffer full or empty    
    assign an = 8'b11111110;        // using only one 7 segment digit 
    assign seg = {~rx_full, 2'b11, ~rx_empty, 3'b111};      //line down if empty, line up if full, only can click button when full
    
    //ENCRYPTION PERFORMED HERE
    assign encrypt_in = encrypt_out;
        
endmodule
