import serial
from datetime import datetime

# Run the following command to view the connected devices
# python -m serial.tools.list_ports

# Set the serial connection
ser = serial.Serial(port='COM5', baudrate=9600, timeout=1)

# Receive user input
print("Make sure your switch is '1' for 'Encryption' and '0' for 'Decryption'!")    
userChoice = input("ASCII or Hex? Type 'A' or 'H' in English.")

# Ensure user enters legal input
while (userChoice != "A") and (userChoice != "H"):
    userInput = input("You entered an invalid character! ASCII or Hex? Type 'A' or 'H' in English.")

# 
if userChoice == "H":                                   # User chooses to input hexadecimal
    userInput = input("Enter a hex value: ")            
    
    startTime = datetime.now()                          # Record the starting time for latency evaluation
    
    writeData = bytes.fromhex(userInput)                # Convert user input into bytes object
    ser.write(writeData)                                # Send data to FPGA
    print("Write Success!")
    
    while True:                                         # Continuously read serial data
        rawData = ser.readline()                        
        # print("Time elapsed: ")
        # print(datetime.now() - startTime)

        hexData = rawData.hex(" ")                      # Format data into hex
        
        try:
            # print(hexData)
            if len(hexData) > 0:                        # If we have received data
                print("Time elapsed: ", end = "")       # Print the elapsed time
                print(datetime.now() - startTime)
                
                print("Hex data: ", end = "")           # Print the hexadecimal data
                print(hexData)
                break
                
        except UnicodeDecodeError as e:                 # If there is a decoding error, raise an exception
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")

elif userChoice == "A":                                 # User chooses to input ASCII; the rest of the script mirrors that of
    userInput = input("Enter an ASCII string: ")        # the hexadecimal conditional block above (if userChoice == "H")

    startTime = datetime.now()

    writeData = bytes(userInput, 'utf-8')
    ser.write(writeData)
    print("Write Success!")
    
    while True:
        rawData = ser.readline()
        # print("Time elapsed: ")
        # print(datetime.now() - startTime)

        hexData = rawData.hex(" ")
        
        try:
            # print(hexData)
            if len(hexData) > 0:
                print("Time elapsed: ", end = "")
                print(datetime.now() - startTime)
                
                print("Hex data: ", end = "")
                print(hexData)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")
            