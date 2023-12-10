`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 09:38:38 PM
// Design Name: 
// Module Name: fifo2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fifo2
	#(
	   parameter	DATA_SIZE 	   = 8,	       // number of bits in a data word
			ADDR_SPACE_EXP = 3	       // number of address bits (2^3 = 8 addresses)
	)
	(
	   input clk_100MHz,                              // FPGA clock           
	   input reset,                            // reset button
	   input write_to_fifo,                    // signal start writing to FIFO
	   input read_from_fifo,                   // signal start reading from FIFO
	   input [DATA_SIZE*(ADDR_SPACE_EXP**2)-1:0] write_data_in,    // data word into FIFO (64 bits of encrypted)
	   output [DATA_SIZE-1:0] read_data_out,   // data word out of FIFO (one ascii character at a time)
	   output empty                           // FIFO is empty (no read)
);

	// signal declaration
	reg [DATA_SIZE-1:0] memory [2**ADDR_SPACE_EXP-1:0];		// memory array register
	reg [ADDR_SPACE_EXP-1:0] current_read_addr, current_read_addr_buff, next_read_addr; //varaibles to shift through the memory array when reading
	reg fifo_full, fifo_empty, full_buff, empty_buff;      //keep track of the status of full/empty
	
	
	//NOTE: WHENEVER SOMETHING IS EDITED, THE BUFFER IS EDITED AND THEN THE ACTUAL VALUE IS UPDATED IN AN ALWAYS BLOCK
	
	// register file (memory) is now the data_in
	//IF DATA_SIZE IS CHANGED, THIS HAS TO BE HARDCODED TO WORK WITH NEW DATA
    always @(posedge clk_100MHz) begin
        memory[0] = write_data_in[7:0];
        memory[1] = write_data_in[15:8];
        memory[2] = write_data_in[23:16];
        memory[3] = write_data_in[31:24];
        memory[4] = write_data_in[39:32];
        memory[5] = write_data_in[47:40];
        memory[6] = write_data_in[55:48];
        memory[7] = write_data_in[63:56];
    end		
    
	// register file (memory) read operation, one ascii character at current address
	assign read_data_out = memory[current_read_addr];
	
	// FIFO control logic
	// register logic
	always @(posedge clk_100MHz or posedge reset)
		if(reset) begin
				 //reset means back to first address when reading, no longer empty, now full
			current_read_addr 	<= 0;
			fifo_full 			<= 1'b0;
			fifo_empty 			<= 1'b1;       
		end
		else begin
				//set the current address, full status, empty status to the status in the buffer
			current_read_addr   <= current_read_addr_buff;
			fifo_full  			<= full_buff;
			fifo_empty 			<= empty_buff;
		end

	// next state logic for read and write address pointers
	always @* begin
		// successive pointer values
		next_read_addr  = current_read_addr + 1;
		
		// default: keep old values, make sure buff is same as actual
		current_read_addr_buff  = current_read_addr;
		full_buff  = fifo_full;
		empty_buff = fifo_empty;
		
		// Button press logic
		case({write_to_fifo, read_from_fifo})     // check both buttons
			// 2'b00: neither buttons pressed, do nothing
			// 2'b11: both buttons pressed, do nothing
			
			2'b01:	// read button pressed?
				if(~fifo_empty) begin   // FIFO not empty
					current_read_addr_buff = next_read_addr;   //if read then move to next address
					full_buff = 1'b0;   // after read, FIFO not full anymore
					if(next_read_addr == 0)    //if the next address is 0, that means current address is max meaning the fifo is full
						empty_buff = 1'b1;    //buffer is now "empty" since everything has been read
				end
			
			2'b10:	// write button pressed?
				if(fifo_empty) begin	// FIFO empty
					empty_buff = 1'b0;  // after write, FIFO not empty anymore
					full_buff = 1'b1;   //now fifo full
					current_read_addr_buff = 0;    //functional restart since once the data is written, we can read from 0 up
					                               //reading allowed again since full
				end
		endcase			
	end

	// output
	assign empty = fifo_empty;

endmodule
