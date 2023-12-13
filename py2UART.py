import serial
from datetime import datetime

# Run the following command to view the connected devices
# python -m serial.tools.list_ports

# Set the serial connection
ser = serial.Serial(port='COM5', baudrate=9600, timeout=1)

# Receive user input
print("Make sure your switch is '1' for 'Encryption' and '0' for 'Decryption'!")

userKey = input("Your key must be 24 hexadecimal characters(12 characters/96 bits). Please enter your key in hex: ")
while (len(userKey) != 24):
    userKey = input("Read carefully. Your key must be 12 characters/96 bits. Please enter your key in hex: ")

userChoice = input("\nNow enter your data in ASCII or Hex. Type 'A' or 'H' in English. ")
while (userChoice != "A") and (userChoice != "H"):
    userChoice = input("You entered an invalid character! ASCII or Hex? Type 'A' or 'H' in English. ")


if userChoice == "H":                                                               # User chooses to input hexadecimal
    userInput = input("\nEnter exactly 32 hex digits for your input data: ")        # For 16 ASCII characters
    while (len(userInput) != 32):
        userInput = input("\nExactly 32! Try again: ")
    
    # Convert user input into bytes object with padding
    writeData = bytes.fromhex(userKey + userInput + "7E7E7E7E")    # 32 hex digits; padding is for the FIFO
    ser.write(writeData)                                # Send data to FPGA

    startTime = datetime.now()                          # Record the starting time for latency evaluation

    while True:                                         # Continuously read serial data
        rawData = ser.readline()                        
        hexData = rawData.hex(" ")                      # Format data into hex

        try:
            if len(hexData) > 0:                        # If we have received data
                print("Time elapsed: ", end = "")       # Print the elapsed time
                print(datetime.now() - startTime)
                
                print("\nHex data: ", end = "")         # Print the hexadecimal data
                print(hexData)

                asciiData = rawData.decode('utf-8', errors="replace")
                print("\nASCII Message: ")
                print(asciiData)
                break
                
        except UnicodeDecodeError as e:                 # If there is a decoding error, raise an exception
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")


elif userChoice == "A":                                                             # User chooses to input ASCII; the rest of the script mirrors that of
    userInput = input("Enter an ASCII string with exactly 16 characters: ")         # the hexadecimal conditional block above (if userChoice == "H")
    while (len(userInput) != 16):
        userInput = input("\nExactly 16! Try again: ")

    # Convert user input into bytes object with padding
    writeData = bytes.fromhex(userKey) + bytes(userInput, 'utf-8') + bytes.fromhex("7E7E7E7E")
    ser.write(writeData)

    startTime = datetime.now()
    
    while True:
        rawData = ser.readline()
        hexData = rawData.hex(" ")
        
        try:
            if len(hexData) > 0:
                print("Time elapsed: ", end = "")
                print(datetime.now() - startTime)
                
                print("Hex data: ", end = "")
                print(hexData)

                asciiData = rawData.decode('utf-8', errors="replace")
                print("\nASCII Message: ")
                print(asciiData)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")
            