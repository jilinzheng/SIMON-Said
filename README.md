# SIMON Said!
**Team Members: Renad Alanazi, Jackson Clary, Rayan Syed, Jilin Zheng**


## Demo Video
[Fake embed video](https://stackoverflow.com/questions/11804820/how-can-i-embed-a-youtube-video-on-github-wiki-pages)


## Project Overview
This is an implementation of the SIMON64/96 block cipher on a Nexus A7, using a Python script to input a 96-bit key and 128-bit message to be encrypted or decrypted. The Python script connects to the FPGA and sends/receives data via UART! Have a look at the section(s) below to get started.


## Running the Project
1. Download all files in the `Source Code` and `Constraints` directories. Create a new [Vivado](https://www.xilinx.com/products/design-tools/vivado.html#:~:text=Vivado%20is%20the%20design%20software,Route%2C%20Verification%2FSimulation%20tools.) project with the [Nexys A7](https://digilent.com/shop/nexys-a7-fpga-trainer-board-recommended-for-ece-curriculum/) as the target board, and add all `Source Code` files as design sources, and the constraint file as a constraint. Program the FPGA board by connecting the board to your PC via microUSB-to-USB, Synthesizing, Implementing, Generating Bitstream, and (Hardware Manager) Program Device.
2. Download the `py2UART.py` script. You will need to have [Python](https://www.python.org/downloads/) installed, as well as the `pyserial` package for serial connections, so run `pip install pyserial` in your favorite terminal to install it.
3. Within the `py2UART.py` script, you must change the port for the serial connection to the port your FPGA is connected to. An useful command is included in the script, but you can also use Device Manager (on Windows) to easily find which port to put in the script. Save your edit!
4. You're all set! Simply execute the `py2UART.py` script, and follow its instructions to encrypt or decrypt your data! Note: Encryption mode or decryption mode can be toggled by the *rightmost* switch on the Nexys A7 (encryption is indicated by the switch being up and the led above it being on; decryption is vice-versa).


## Code Overview
A brief overview is provided here for each major component of our project. For readers wishing to gain a more elaborate understanding of this project, we encourage you to see the source code files, which are commented/documented thoroughly, as well as view the [Demo Video](#demo-video).

### SIMON64/96
SIMON64/96, which supports a *64-bit* block with a *96-bit* key, is a particular implementation of one configuration of the SIMON family of block ciphers. SIMON follows the [Feistel structure](https://en.wikipedia.org/wiki/Feistel_cipher), and as such, SIMON ciphers consist of two main functions (modules in this case), the key-schedule function `keySchedule.v` and the round function(s) (`encryptRound.v` and `decryptRound.v`, which encrypt and decrypt, respectively). 

In the case of SIMON64/96, the key-schedule function receives a 96-bit key and generates 42, 32-bit *round keys* to be used in the round function. The round function receives a 32-bit round key and a 64-bit input *block*. It splits it into two 32-bit *words*, performs a set of bitwise operations on one of the words (one of which includes xor'ing the round key), and performs a final swap between words. The round function is executed for a total of 42 rounds/times (number of rounds is configuration-specific), with the output of the last round being the result of the encryption/decryption. Please refer to the [Learn More!](#learn-more!) section for more information on the exact algorithm of the SIMON family of block ciphers.

### UART
The UART system works utilizing eight modules, one of which is the uppermost top module that works with the SIMON modules as well as the UART modules. `uart.v` module is the "top" module for the UART system and calls each of the lower modules to make the interaction between the user's inputs and the FPGA possible. `uart_transmitter.v` and `fifo_tx.v` both work to translate the parallel data from the Python script, named `py2UART.py` into a form that is understood by the FPGA (serial data). `uart_receiver.v` and `fifo_rx.v` do the opposite, and convert the FPGA's serial data into parallel form for `py2UART.py` to interpret. The remaining module, `baud_rate_generator.v` creates a baud rate for the rest of the UART modules, which functionally is similar to a clock in other Verilog programs.

### Python Scripts
Two Python scripts are included in this repo. `py2UART.py` is the script used on an user's PC to actually interface with the FPGA via UART, and prompts the user for the desired key and message to be encrypted/decrypted. The script handles the rest of the data transmission and reception in the background, with the FPGA receiving data, performing the cipher operations, and transmitting the data back to the PC.

`pySIMON64_96.py` is a Python implementation of the same SIMON64/96 cipher, primarily for comparison and benchmarking the performance of the SIMON cipher on FPGA (hardware) versus Python (software). We acknowledge that our implementation will not showcase a significant benefit in using FPGA over Python, but this is because our implementation currently only supports 2 blocks (128 bits). We believe that if a much greater number of bits were being encrypted/decrypted, the FPGA will perform such encryption/decryption many times faster than the Python script, as we are able to utilize the parallel processing of FPGAs over sequential processing of Python.


## Learn More!
This project implemented the SIMON64/96 cipher, which is only one in a family of SIMON block ciphers. Read more about the cipher as well as its optimal performance and usage cases at the National Security Agency's [official GitHub repo for SIMON (and SPECK)!](https://github.com/nsacyber/simon-speck)
