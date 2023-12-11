# Run the following command to view the connected devices
# python -m serial.tools.list_ports
import serial
import time

ser = serial.Serial(port='COM4', baudrate=9600, timeout=1)
userChoice = input("ASCII or Hex? Type 'A' or 'H'.")
while (userChoice != "A") and (userChoice!= "H"):
    userChoice = input("You entered an invalid character! ASCII or Hex? Type 'A' or 'H'.")
    
if userChoice == "H":
    userInput = input("Enter a hex value: ")
    hexBytes = bytes.fromhex(userInput)
    
    ser.write(hexBytes)
    
    while True:
        raw_data = ser.readline()
        hexData = raw_data.hex(" ")
        try:
            print(hexData)
            if len(hexData) > 3:
                break
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {raw_data}")

elif userChoice == "A":
    userInput = input("Enter an ASCII string: ")
    utf8Encode = userInput.encode('utf-8')
    
    ser.write(utf8Encode)
    
    while True:
        raw_data = ser.readline()
        try:
            value = raw_data.decode('utf-8', errors='replace')
            print(f"Decoded Value: {value}")
            if len(value) > 3:
                break
        except UnicodeDecodeError as e:
            print(f"Error decoding bytes: {e}")
            print(f"Raw Bytes: {raw_data}")


