# SIMON Said!
Team Members: Renad Alanazi, Jackson Clary, Rayan Syed, Jilin Zheng\
[Demo Link Video]()

## Project Overview
This is an implementation of the SIMON64/96 block cipher on a Nexus A7, using a Python script to input a 96-bit key and 128-bit message to be encrypted or decrypted. The Python script connects to the FPGA and sends/receives data via UART! Have a look at the section below to get started.

## Running the Project
1. Download all files in the `Source Code` directory. Create a new [Vivado](https://www.xilinx.com/products/design-tools/vivado.html#:~:text=Vivado%20is%20the%20design%20software,Route%2C%20Verification%2FSimulation%20tools.) project with the [Nexys A7](https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/) as the target board, and add all downloaded files as Source Files. Program the FPGA board by connecting the board to your PC via microUSB-to-USB, Synthesizing, Implementing, Generating Bitstream, and Program Device.
2. Download the `py2UART.py` script. You will need to have [Python](https://www.python.org/downloads/) installed, as well as the `pyserial` package for serial connections, so run `pip install pyserial` in your favorite terminal to install it.
3. Within the `py2UART.py` script, you must change the port for the serial connection to the port your FPGA is connected to. An useful command is included in the script, but you can also use Device Manager (on Windows) to easily find which port to put in the script. Save your edit!
4. You're all set! Simply execute the `py2UART.py` script, and follow its instructions to encrypt or decrypt your data! Note: encryption mode or decryption mode can be toggled by the *rightmost* switch on the Nexys A7.

To run this program, all the user needs is a message to send. Assuming the FPGA is already programmed, the user should first decide if they are *encrypting* or *decrypting* a message, which can be toggled using a switch on the FPGA board. After running the Python script `py2UART.py`, the user will be asked if their input will be in the form of ASCII or Hexadecimal. After making a decision, the user will be able to send up to 128 bits of data in either format. After inputting their data, ...

...the user can press the center button on the FPGA board to receive the output. This output will be in Hexadecimal, and depending on the user's earlier choice will either be the encrypted or decrypted version of their input.

***OR***

...the FPGA board will automatically output either the encrypted or decrypted version of their input, depending on the user's earlier choice. 

Whether encrypting or decrypting, this output is based on a key, which is meant to be irregularly changed and thus is hard-coded. If the user inputs a real message and our project *encrypts* it, the user will be able to use this key on our or another SIMON64/96 cipher device to decrypt that message back to its original form. This key and its functionality in the SIMON section of the project will be discussed more thoroughly in a later section of this overview.

## Code Overview
Our code combines two mostly separate systems that were combined toward the end of the project's completion date. These two general systems are the SIMON encrypt/decrypt modules and the UART modules. Additionally, we are utilizing a small but impactful Python script to improve the user interface of our project. Each module is commented on thoroughly to improve readability, and we encourage any potential readers to utilize this to gain a better understanding of this project, as this overview is not intended to provide more than a surface-level description of the project's inner workings.

### SIMON64/96
SIMON modules description here.

### UART
The UART system works utilizing eight modules, one of which is the uppermost top module that works with the SIMON modules as well as the UART modules. `uart_top.v` module is the "top" module for the UART system and calls each of the lower modules to make the interaction between the user's inputs and the FPGA possible. `uart_transmitter.v` and `fifo2.v` both work to translate the parallel data from the Python script, named `py2UART.py` into a form that is understood by the FPGA (serial data). `uart_receiver.v` and `fifo.v` do the opposite, and convert the FPGA's serial data into parallel form for `py2UART.py` to interpret. The remaining two modules perform auxiliary functions for the program. The first, `baud_rate_generator.v` creates a baud rate for the rest of the UART modules, which functionally is similar to a clock in other verilog programs. The second and final module is `debounce_explicit.v`, and allows the use of buttons on the FPGA board.

### Python Scripts
Two python scripts are included in this repo. `py2UART.py` is the script used to actually interface with the FPGA via UART, and prompts the user for the desired key and message to be encrypted/decrypted. The script handles the rest of the data transmission and reception in the background, with the FPGA performing the rest of the cipher calculations. `pySIMON64_96.py` is a Python implementation of the same SIMON64/96 cipher, primarily for comparison and benchmarking the performance of the SIMON cipher on FPGA (hardware) versus Python (software). We acknowledge that our implementation will not showcase a significant benefit in using FPGA over Python, but this is because our implementation currently only supports 2 blocks (128 bits). We believe that if a much greater number of bits were being encrypted/decrypted, the FPGA will perform such encryption/decryption many times faster than the Python script, as we are able to utilize the parallel processing of FPGAs over sequential processing of Python.


## Learn More!
This project implemented the SIMON64/96 cipher, which is only one in a family of SIMON block ciphers. Read more about the cipher as well as its optimal performance and usage cases at the National Security Agency's [official GitHub repo for SIMON (and SPECK)!](https://github.com/nsacyber/simon-speck)
