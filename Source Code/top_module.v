`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//
//Code adapted from https://www.youtube.com/watch?v=L1D5rBwGTwY, FPGA DUDE
//
//////////////////////////////////////////////////////////////////////////////////

module top_module(
    input clk_100MHz,       //  FPGA clock signal
    input reset,            // btn reset    
    input rx,               // USB-RS232 Rx
    output tx,              // USB-RS232 Tx
    input switch,           //switch for encrypt or decrypt
    output led,             
    output [7:0] an,        // 7 segment display digits
    output [0:6] seg        // 7 segment display segments
    );
    
    // Connection Signals
    wire rx_full, rx_empty; //to display on 7 segment to help keep track of whats going on
    
    //variables encrypt in middle of fifos, CHANGE THESE TO EXACT AMOUNT OF BITS WORKING WITH
    wire [63:0] encrypt_out, encrypt_out2;
    wire [255:0] data;  //key is 0-95, encrypt_in1 in is 96-159, encrypt_in2 is 160-223
    
    // Complete UART Core
    uart UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),            //reset when button pressed
            .rx(rx),                //receieved data
            .tx(tx),                //transmitted data
            .rx_full(rx_full),      //buffer full for 7 segment
            .rx_empty(rx_empty),    //buffer empty for 7 segment
            .read_data(data),     //256 bit data from input buffer
            .write_data({encrypt_out2,encrypt_out})    //data into output buffer
        );
    
    //display if buffer full or empty    
    assign an = 8'b11111110;        // using only one 7 segment digit 
    //note: light flickers when full because it immediately empties when full in order to start encoding.
    assign seg = {~rx_full, 2'b11, ~rx_empty, 3'b111};      //line down if empty, line up if full
    
    //ENCRYPTION PERFORMED HERE
    simon64_96 blockCipher1
    (
        .encryptOrDecrypt(switch),
        .inText(data[159:96]),  //first set of 8 characters getting encrypted
        .key(data[95:0]),
        .outText(encrypt_out)
    );
    
    simon64_96 blockCipher2
    (
        .encryptOrDecrypt(switch),
        .inText(data[223:160]), //second set of 8 characters getting encrypted
        .key(data[95:0]),
        .outText(encrypt_out2)
    );
    
    assign led = switch;
      
endmodule
