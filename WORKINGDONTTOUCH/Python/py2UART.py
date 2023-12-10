
# Run the following command to view the connected devices
# python -m serial.tools.list_ports

import serial
import time

ser = serial.Serial(port='COM4', baudrate=9600, timeout=1)
ser.write('abcdefgh'.encode("utf-8"))  
while True:
            raw_data = ser.readline().hex(" ")
            print(type(raw_data))
            try:
               # value = raw_data.decode('utf-8', errors='replace')
               # print(f"Decoded Value: {value}")
               print(raw_data)
            except UnicodeDecodeError as e:
                print(f"Error decoding bytes: {e}")
                print(f"Raw Bytes: {raw_data}")

              #  output should be: bb 81 21 fd 48 bb c4 d4