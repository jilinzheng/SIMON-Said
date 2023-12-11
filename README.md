# SIMON Said!
Team Members: Renad Alanazi, Jackson Clary, Rayan Syed, Jilin Zheng \
[Demo Link Video]()

## Project Overview
This is an implementation of the SIMON block cipher on a Nexus A7.

## Running the Project


## Code Overview
Our code combines two mostly separate systems that were combined toward the end of the project's completion date. These two general systems are the SIMON encrypt/decrypt modules and the UART modules. Additionally, we are utilizing a small but impactful Python script to improve the user interface of our project. Each module is commented on thoroughly to improve readability, and we encourage any potential readers to utilize this to gain a better understanding of this project, as this overview is not intended to provide more than a surface-level description of the project's inner workings.

**SIMON64/96**


**UART**

The UART system works utilizing eight modules, one of which is the uppermost top module that works with the SIMON modules as well as the UART modules. [uart_top.v] module is the "top" module for the UART system and calls each of the lower modules to make the interaction between the user's inputs and the FPGA possible. [uart_transmitter.v] and [fifo2.v] both work to translate the parallel data from the Python script, named [jilinpy2UART.py] into a form that is understood by the FPGA (serial data). [uart_receiver.v] and [fifo.v] do the opposite, and convert the FPGA's serial data into parallel form for [jilinpy2UART.py] to interpret. The remaining two modules perform auxiliary functions for the program. The first, [baud_rate_generator.v] creates a baud rate for the rest of the UART modules, which functionally is similar to a clock in other verilog programs. The second and final module is [debounce_explicit.v], and allows the use of buttons on the FPGA board.

**Python Scripts**

