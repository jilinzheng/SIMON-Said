# -*- coding: utf-8 -*-
"""
Created on Sun Dec 10 18:16:38 2023

@author: renad
"""

import serial
import time

ser = serial.Serial(port='COM4', baudrate=9600, timeout=1)
# ser.write('abcdefgh'.encode("utf-8"))  

userChoice = input("ASCII or Hex? Type 'A' or 'H'.")
if userChoice == "H":
    userInput = input("Enter a hex value: ")
    utf8Encode = userInput.encode('utf-8')
    hexConversion = ''.join([f'\\x{byte:02x}' for byte in utf8Encode])
    test = f"b'{hexConversion}'"
   
    ser.write(test)
   
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
    test = f"b'{utf8Encode.decode('unicode_escape')}'"
   
    ser.write(test)
   
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

else:
    print("You entered an invalid character!")
