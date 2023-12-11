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
    userInput = input("You entered an invalid character! ASCII or Hex? Type 'A' or 'H' in English. ")


if userChoice == "H":                                   # User chooses to input hexadecimal
    userInput = input("\nEnter your hex data (up to 16 hex digits): ")            
    
    startTime = datetime.now()                          # Record the starting time for latency evaluation
    
    # Convert user input into bytes object with padding
    writeData = bytes.fromhex(userKey + userInput + "7E7E7E7E7E7E7E7E7E7E7E7E")
    # print(writeData)
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
    userInput = input("Enter an ASCII string (up to 8 characters): ")        # the hexadecimal conditional block above (if userChoice == "H")
    print(len(userInput))

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
            