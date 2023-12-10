`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Reference Book: FPGA Prototyping By Verilog Examples Xilinx Spartan-3 Version
// Authored by: Dr. Pong P. Chu
// Published by: Wiley
//
// Adapted for the Basys 3 Artix-7 FPGA by David J. Marion
//
// UART System Verification Circuit
//
// Comments:
// - Many of the variable names have been changed for clarity
//////////////////////////////////////////////////////////////////////////////////

module uart_test(
    input clk_100MHz,       //  FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    output tx,              // USB-RS232 Tx
    output [7:0] an,        // 7 segment display digits
    output [0:6] seg        // 7 segment display segments
    );
    
    // Connection Signals
    wire rx_full, rx_empty;
    
    //encrypt in middle of fifos
    wire [7:0] encrypt_in, encrypt_out;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .encrypt(btn),
            .rx(rx),
            .tx(tx),
            .rx_full(rx_full),
            .rx_empty(rx_empty),
            .read_data(encrypt_in),
            .write_data(encrypt_out)
        );
        
    // Button Debouncer
    debounce_explicit BUTTON_DEBOUNCER
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn),         
            .db_level(),  
            .db_tick(btn_tick)
        );
    
    //display if buffer full or empty    
    assign an = 8'b11111110;        // using only one 7 segment digit 
    assign seg = {~rx_full, 2'b11, ~rx_empty, 3'b111};      //line down if empty, line up if full
    
    //ENCRYPTION PERFORMED HERE
    assign encrypt_in = encrypt_out;
        
endmodule
