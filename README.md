# SIMON Said!
Team Members: Renad Alanazi, Jackson Clary, Rayan Syed, Jilin Zheng\
[Demo Link Video]()

## Project Overview
This is an implementation of the SIMON block cipher on a Nexus A7, using a Python script to input text to be encrypted or decrypted.

## Running the Project
To run this program, all the user needs is a message to send. Assuming the FPGA is already programmed, the user should first decide if they are *encrypting* or *decrypting* a message, which can be toggled using a switch on the FPGA board. After running the Python script `jilinpy2UART.py`, the user will be asked if their input will be in the form of ASCII or Hexadecimal. After making a decision, the user will be able to send up to 64 bits of data in either format. After inputting their data, ...

...the user can press the center button on the FPGA board to receive the output. This output will be in Hexadecimal, and depending on the user's earlier choice will either be the encrypted or decrypted version of their input.

OR

...the FPGA board will automatically output either the encrypted or decrypted version of their input, depending on the user's earlier choice. 

Whether encrypting or decrypting, this output is based on a key, which is meant to be irregularly changed and thus is hard-coded. If the user inputs a real message and our project *encrypts* it, the user will be able to use this key on our or another SIMON64/96 cipher device to decrypt that message back to its original form. This key and its functionality in the SIMON section of the project will be discussed more thoroughly in a later section of this overview.

## Code Overview
Our code combines two mostly separate systems that were combined toward the end of the project's completion date. These two general systems are the SIMON encrypt/decrypt modules and the UART modules. Additionally, we are utilizing a small but impactful Python script to improve the user interface of our project. Each module is commented on thoroughly to improve readability, and we encourage any potential readers to utilize this to gain a better understanding of this project, as this overview is not intended to provide more than a surface-level description of the project's inner workings.

### SIMON64/96
SIMON modules description here.

### UART
The UART system works utilizing eight modules, one of which is the uppermost top module that works with the SIMON modules as well as the UART modules. `uart_top.v` module is the "top" module for the UART system and calls each of the lower modules to make the interaction between the user's inputs and the FPGA possible. `uart_transmitter.v` and `fifo2.v` both work to translate the parallel data from the Python script, named `jilinpy2UART.py` into a form that is understood by the FPGA (serial data). `uart_receiver.v` and `fifo.v` do the opposite, and convert the FPGA's serial data into parallel form for `jilinpy2UART.py` to interpret. The remaining two modules perform auxiliary functions for the program. The first, `baud_rate_generator.v` creates a baud rate for the rest of the UART modules, which functionally is similar to a clock in other verilog programs. The second and final module is `debounce_explicit.v`, and allows the use of buttons on the FPGA board.

### Python Scripts
Python script description here.
