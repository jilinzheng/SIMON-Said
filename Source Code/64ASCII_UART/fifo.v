`timescale 1ns /1ps

//////////////////////////////////////////////////////////////////////////////////////////

module fifo
	#(
	   parameter	DATA_SIZE 	   = 8,	       // number of bits in a data word
			ADDR_SPACE_EXP = 6	       // number of address bits (2^3 = 8 addresses)
	)
	(
	   input clk_100MHz,                              // FPGA clock           
	   input reset,                            // reset button
	   input write_to_fifo,                    // signal start writing to FIFO
	   input read_from_fifo,                   // signal start reading from FIFO
	   input [DATA_SIZE-1:0] write_data_in,    // data word into FIFO
	   output [DATA_SIZE*(2**ADDR_SPACE_EXP)-1:0] read_data_out,   // data word out of FIFO with all however many ascii
	   output empty,                           // FIFO is empty (no read)
	   output full	                           // FIFO is full (no write)
);

	// signal declaration
	reg [DATA_SIZE-1:0] memory [2**ADDR_SPACE_EXP-1:0];		// memory array register
	reg [ADDR_SPACE_EXP-1:0] current_write_addr, current_write_addr_buff, next_write_addr;  //varaibles to shift through the memory array when writing
	reg fifo_full, fifo_empty, full_buff, empty_buff;      //keep track of the status of full/empty
	wire write_enabled;        //can only write when fifo not full
	
	//NOTE: WHENEVER SOMETHING IS EDITED, THE BUFFER IS EDITED AND THEN THE ACTUAL VALUE IS UPDATED IN AN ALWAYS BLOCK
	
	// register file (memory) write operation
	always @(posedge clk_100MHz)
		if(write_enabled)
			memory[current_write_addr] <= write_data_in;
			
	// register file (memory) read operation
	//IF DATA_SIZE IS CHANGED, THIS HAS TO BE HARDCODED TO WORK WITH NEW DATA
	assign read_data_out = 
	{
        memory[0], memory[1], memory[2], memory[3], memory[4], memory[5], memory[6], memory[7],
        memory[8], memory[9], memory[10], memory[11], memory[12], memory[13], memory[14], memory[15],
        memory[16], memory[17], memory[18], memory[19], memory[20], memory[21], memory[22], memory[23],
        memory[24], memory[25], memory[26], memory[27], memory[28], memory[29], memory[30], memory[31],
        memory[32], memory[33], memory[34], memory[35], memory[36], memory[37], memory[38], memory[39],
        memory[40], memory[41], memory[42], memory[43], memory[44], memory[45], memory[46], memory[47],
        memory[48], memory[49], memory[50], memory[51], memory[52], memory[53], memory[54], memory[55],
        memory[56], memory[57], memory[58], memory[59], memory[60], memory[61], memory[62], memory[63]
    };
	
	// only allow write operation when FIFO is NOT full
	assign write_enabled = write_to_fifo & ~fifo_full;
	
	// FIFO control logic
	// register logic
	always @(posedge clk_100MHz or posedge reset)
		if(reset) begin
		      //reset means back to first address when writing, no longer empty, now full
			current_write_addr 	<= 0;
			fifo_full 			<= 1'b0;
			fifo_empty 			<= 1'b1;     
		end
		else begin
		      //set the current address, full status, empty status to the status in the buffer
			current_write_addr  <= current_write_addr_buff;
			fifo_full  			<= full_buff;
			fifo_empty 			<= empty_buff;
		end

	// next state logic for read and write address pointers
	always @* begin
		// successive pointer values
		next_write_addr = current_write_addr + 1;
		
		// default: keep old values, make sure buff is same as actual
		current_write_addr_buff = current_write_addr;
		full_buff  = fifo_full;
		empty_buff = fifo_empty;
		
		// Button press logic
		case({write_to_fifo, read_from_fifo})     // check both buttons
			// 2'b00: neither buttons pressed, do nothing
			// 2'b11: both buttons pressed, do nothing
			
			2'b01:	// read button pressed?
				if(fifo_full) begin   // FIFO not empty
					full_buff = 1'b0;   // after read, FIFO not full anymore
					empty_buff = 1'b1; //FIFO is empty, refer to description below
					current_write_addr_buff = 0;   //functional restart since once the data is read we "empty" the buffer by going back to address 0 
					                               //writing is allowed again since empty
				end
			
			2'b10:	// write button pressed?
				if(~fifo_full) begin	// FIFO not full
					current_write_addr_buff = next_write_addr; //if write then move to next address
					empty_buff = 1'b0;  // after write, FIFO not empty anymore
					if(next_write_addr == 0)       //if the next address is 0, that means current address is max meaning the fifo is full
						full_buff = 1'b1;
				end
				
		endcase			
	end

	// output
	assign full = fifo_full;
	assign empty = fifo_empty;

endmodule
