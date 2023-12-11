import serial
from datetime import datetime

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
        raw_data = ser.readline()
        hexData = raw_data.hex(" ")
        
        try:
            print(hexData)
            if len(hexData) > 3:
                print(datetime.now() - startTime)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {raw_data}")

elif userChoice == "A":
    userInput = input("Enter an ASCII string: ")

    startTime = datetime.now()

    writeData = bytes(userInput, 'utf-8')
    ser.write(writeData)
    print("Write Success!")
    
    while True:
        raw_data = ser.readline()
        hexData = raw_data.hex(" ")
        
        try:
            print(hexData)
            if len(hexData) > 3:
                print(datetime.now() - startTime)
                break
                
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {raw_data}")

else:
    print("You entered an invalid character!")
    
