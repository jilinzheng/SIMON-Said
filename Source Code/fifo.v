`timescale 1ns /1ps

//////////////////////////////////////////////////////////////////////////////////////////

module fifo
	#(
	   parameter	DATA_SIZE 	   = 8,	       // number of bits in a data word
				    ADDR_SPACE_EXP = 3	       // number of address bits (2^3 = 8 addresses)
	)
	(
	   input clk_100MHz,                              // FPGA clock           
	   input reset,                            // reset button
	   input write_to_fifo,                    // signal start writing to FIFO
	   input read_from_fifo,                   // signal start reading from FIFO
	   input [DATA_SIZE-1:0] write_data_in,    // data word into FIFO
	   output [DATA_SIZE*(2**ADDR_SPACE_EXP)-1:0] read_data_out,   // data word out of FIFO with all 8 ascii
	   output empty,                           // FIFO is empty (no read)
	   output full	                           // FIFO is full (no write)
);

	// signal declaration
	reg [DATA_SIZE-1:0] memory [2**ADDR_SPACE_EXP-1:0];		// memory array register
	reg [ADDR_SPACE_EXP-1:0] current_write_addr, current_write_addr_buff, next_write_addr;
	reg fifo_full, fifo_empty, full_buff, empty_buff;
	wire write_enabled;
	
	// register file (memory) write operation
	always @(posedge clk_100MHz)
		if(write_enabled)
			memory[current_write_addr] <= write_data_in;
			
	// register file (memory) read operation
	assign read_data_out = {memory[0],memory[1],memory[2],memory[3],memory[4],memory[5],memory[6],memory[7]};
	
	// only allow write operation when FIFO is NOT full
	assign write_enabled = write_to_fifo & ~fifo_full;
	
	// FIFO control logic
	// register logic
	always @(posedge clk_100MHz or posedge reset)
		if(reset) begin
			current_write_addr 	<= 0;
			fifo_full 			<= 1'b0;
			fifo_empty 			<= 1'b1;       // FIFO is empty after reset
		end
		else begin
			current_write_addr  <= current_write_addr_buff;
			fifo_full  			<= full_buff;
			fifo_empty 			<= empty_buff;
		end

	// next state logic for read and write address pointers
	always @* begin
		// successive pointer values
		next_write_addr = current_write_addr + 1;
		
		// default: keep old values
		current_write_addr_buff = current_write_addr;
		full_buff  = fifo_full;
		empty_buff = fifo_empty;
		
		// Button press logic
		case({write_to_fifo, read_from_fifo})     // check both buttons
			// 2'b00: neither buttons pressed, do nothing
			// 2'b11: nothing can happen
			
			2'b01:	// read button pressed?
				if(fifo_full) begin   // FIFO not empty
					full_buff = 1'b0;   // after read, FIFO not full anymore
					empty_buff = 1'b1; //FIFO is empty
					current_write_addr_buff = 0;   //functional restart
				end
			
			2'b10:	// write button pressed?
				if(~fifo_full) begin	// FIFO not full
					current_write_addr_buff = next_write_addr;
					empty_buff = 1'b0;  // after write, FIFO not empty anymore
					if(next_write_addr == 0)
						full_buff = 1'b1;
				end
				
		endcase			
	end

	// output
	assign full = fifo_full;
	assign empty = fifo_empty;

endmodule
