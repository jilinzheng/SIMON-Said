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

			ADDR_SPACE_EXP = 6	       // number of address bits (2^3 = 8 addresses)
	)
	(
	   input clk_100MHz,                              // FPGA clock           
	   input reset,                            // reset button
	   input write_to_fifo,                    // signal start writing to FIFO
	   input read_from_fifo,                   // signal start reading from FIFO
	   input [DATA_SIZE*(2**ADDR_SPACE_EXP)-1:0] write_data_in,    // data word into FIFO (howevr many bits of encrypted)
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
        memory[0] = write_data_in[511:504];
        memory[1] = write_data_in[503:496];
        memory[2] = write_data_in[495:488];
        memory[3] = write_data_in[487:480];
        memory[4] = write_data_in[479:472];
        memory[5] = write_data_in[471:464];
        memory[6] = write_data_in[463:456];
        memory[7] = write_data_in[455:448];
        memory[8] = write_data_in[447:440];
        memory[9] = write_data_in[439:432];
        memory[10] = write_data_in[431:424];
        memory[11] = write_data_in[423:416];
        memory[12] = write_data_in[415:408];
        memory[13] = write_data_in[407:400];
        memory[14] = write_data_in[399:392];
        memory[15] = write_data_in[391:384];
        memory[16] = write_data_in[383:376];
        memory[17] = write_data_in[375:368];
        memory[18] = write_data_in[367:360];
        memory[19] = write_data_in[359:352];
        memory[20] = write_data_in[351:344];
        memory[21] = write_data_in[343:336];
        memory[22] = write_data_in[335:328];
        memory[23] = write_data_in[327:320];
        memory[24] = write_data_in[319:312];
        memory[25] = write_data_in[311:304];
        memory[26] = write_data_in[303:296];
        memory[27] = write_data_in[295:288];
        memory[28] = write_data_in[287:280];
        memory[29] = write_data_in[279:272];
        memory[30] = write_data_in[271:264];
        memory[31] = write_data_in[263:256];
        memory[32] = write_data_in[255:248];
        memory[33] = write_data_in[247:240];
        memory[34] = write_data_in[239:232];
        memory[35] = write_data_in[231:224];
        memory[36] = write_data_in[223:216];
        memory[37] = write_data_in[215:208];
        memory[38] = write_data_in[207:200];
        memory[39] = write_data_in[199:192];
        memory[40] = write_data_in[191:184];
        memory[41] = write_data_in[183:176];
        memory[42] = write_data_in[175:168];
        memory[43] = write_data_in[167:160];
        memory[44] = write_data_in[159:152];
        memory[45] = write_data_in[151:144];
        memory[46] = write_data_in[143:136];
        memory[47] = write_data_in[135:128];
        memory[48] = write_data_in[127:120];
        memory[49] = write_data_in[119:112];
        memory[50] = write_data_in[111:104];
        memory[51] = write_data_in[103:96];
        memory[52] = write_data_in[95:88];
        memory[53] = write_data_in[87:80];
        memory[54] = write_data_in[79:72];
        memory[55] = write_data_in[71:64];
        memory[56] = write_data_in[63:56];
        memory[57] = write_data_in[55:48];
        memory[58] = write_data_in[47:40];
        memory[59] = write_data_in[39:32];
        memory[60] = write_data_in[31:24];
        memory[61] = write_data_in[23:16];
        memory[62] = write_data_in[15:8];
        memory[63] = write_data_in[7:0];
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
