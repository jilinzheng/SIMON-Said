import serial
from datetime import datetime

# Run the following command to view the connected devices
# python -m serial.tools.list_ports
ser = serial.Serial(port='COM5', baudrate=9600, timeout=1)

print("Make sure your switch is '1' for 'Encryption' and '0' for 'Decryption'!")
userChoice = input("ASCII or Hex? Type 'A' or 'H'.")

if userChoice == "H":
    userInput = input("Enter a hex value: ")
    
    startTime = datetime.now()
    
    writeData = bytes.fromhex(userInput)
    ser.write(writeData)
    print("Write Success!")
    
    while True:
        rawData = ser.readline()
        print("Time elapsed: " + datetime.now() - startTime)
        print("Raw binary data: " + rawData)

        hexData = rawData.hex(" ")
        
        try:
            print(hexData)
            if len(hexData) > 3:
                print("Time elapsed: " datetime.now() - startTime)
                print("Hex data: " + hexData)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")

elif userChoice == "A":
    userInput = input("Enter an ASCII string: ")

    startTime = datetime.now()

    writeData = bytes(userInput, 'utf-8')
    ser.write(writeData)
    print("Write Success!")
    
    while True:
        rawData = ser.readline()
        print("Time elapsed: " + datetime.now() - startTime)
        print("Raw binary data: " + rawData)

        hexData = rawData.hex(" ")
        
        try:
            print(hexData)
            if len(hexData) > 3:
                print("Time elapsed: " + datetime.now() - startTime)
                print("Hex data: " + hexData)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {rawData}")

else:
    print("You entered an invalid character!")
    
