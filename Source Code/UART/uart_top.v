`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//
// Code adapted from https://www.youtube.com/watch?v=L1D5rBwGTwY, FPGA DUDE
// Specifically baud rate generator, receiver, and transmitter
//
// Setup for 9600 Baud Rate
//
// For 9600 baud with 100MHz FPGA clock: 
// 9600 * 16 = 153,600
// 100 * 10^6 / 153,600 = ~651      (counter limit M)
// log2(651) = 10                   (counter bits N) 
//
// For 19,200 baud rate with a 100MHz FPGA clock signal:
// 19,200 * 16 = 307,200
// 100 * 10^6 / 307,200 = ~326      (counter limit M)
// log2(326) = 9                    (counter bits N)
//
// For 115,200 baud with 100MHz FPGA clock:
// 115,200 * 16 = 1,843,200
// 100 * 10^6 / 1,843,200 = ~52     (counter limit M)
// log2(52) = 6                     (counter bits N) 
//
// For 1500 baud with 100MHz FPGA clock:
// 1500 * 16 = 24,000
// 100 * 10^6 / 24,000 = ~4,167     (counter limit M)
// log2(4167) = 13                  (counter bits N) 
//
//////////////////////////////////////////////////////////////////////////////////

module uart_top
    #(
        parameter   DBITS = 8,          // number of data bits in a word
                    SB_TICK = 16,       // number of stop bit / oversampling ticks
                    BR_LIMIT = 651,     // baud rate generator counter limit
                    BR_BITS = 10,       // number of baud rate generator counter bits
                    FIFO_EXP = 3        // exponent for number of FIFO addresses (2^3 = 8)
    )
    (
        input clk_100MHz,               // FPGA clock
        input reset,                    // reset
        input encrypt,                  //button
        input rx,                       // serial data in
        output tx,                      // serial data out
        output rx_empty,                //to display on 7 segment
        output rx_full,                 //to display on 7 segment
        output [DBITS*(2**FIFO_EXP)-1:0] read_data,   //data out of rx fifo
        input [DBITS*(2**FIFO_EXP)-1:0] write_data    //data into tx fifo
    );
    
    // Connection Signals
    wire tick;                          // sample tick from baud rate generator
    wire rx_done;                  // data word received
    wire tx_done;                  // data transmission complete
    wire [DBITS-1:0] rx_data_out;       // from UART receiver to Rx FIFO
    wire [DBITS-1:0] tx_fifo_out;       //ascii back to host computer
    wire tx_empty;       //to see when to transmit
    wire tx_fifo_not_empty;        //opposite of tx_empty
    
    // Instantiate Modules for UART Core
    baud_rate_generator 
        #(
            .M(BR_LIMIT), 
            .N(BR_BITS)
         ) 
        BAUD_RATE_GEN   
        (
            .clk_100MHz(clk_100MHz), 
            .reset(reset),
            .tick(tick)
         );
    
    //receive ascii
    uart_receiver
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_RX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .rx(rx),
            .sample_tick(tick),
            .data_ready(rx_done),   //send rx_done signal to fifo
            .data_out(rx_data_out)  //send receieved ascii to fifo
         );
         
    //accumulate data until 8 ascii, send 64 bits when button pressed
    fifo
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_RX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .write_to_fifo(rx_done),    //put ascii into fifo everytime receieve (until all 8 ascii in)
	        .read_from_fifo(encrypt),    //start encryption with button
	        .write_data_in(rx_data_out),   //put ascii into fifo
	        .read_data_out(read_data),  //64 bits of data to encrypt
	        .empty(rx_empty),  //output for display
	        .full(rx_full)     //output for display
	      );
    
    //take in the new 64 bits and send back the 8 ascii one by one when button pressed
    fifo2
        #(
            .DATA_SIZE(DBITS),
            .ADDR_SPACE_EXP(FIFO_EXP)
         )
         FIFO_TX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .write_to_fifo(encrypt),    //load the 64 bits when button pressed
	        .read_from_fifo(tx_done),    //whenever not transmitting, send to transmitter
	        .write_data_in(write_data),   //put 64 bits in memory
	        .read_data_out(tx_fifo_out),  //ascii to output
	        .empty(tx_empty)  //output for display
	      );
    
    //transfer the ascii back
    uart_transmitter
        #(
            .DBITS(DBITS),
            .SB_TICK(SB_TICK)
         )
         UART_TX_UNIT
         (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .tx_start(tx_fifo_not_empty),   //as soon as there is something in the fifo_tx_unit, send it out to screen
            .sample_tick(tick),
            .data_in(tx_fifo_out),  //take in what comes out of fifo2
            .tx_done(tx_done),      //when tx done then the data comes in from fifo2
            .tx(tx)     //send back to host computer
         );
         
     assign tx_fifo_not_empty = ~tx_empty;
  
endmodule
