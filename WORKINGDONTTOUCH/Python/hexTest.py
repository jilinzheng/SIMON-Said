# Run the following command to view the connected devices
# python -m serial.tools.list_ports

import serial
import time

ser = serial.Serial(port='COM4', baudrate=9600, timeout=1)
# ser.write('abcdefgh'.encode("utf-8"))  
test = b'\x63\x6c\x69\x6e\x67\x20\x72\x6f'
ser.write(test)

while True:
  raw_data = ser.readline()
  # print(type(raw_data))
  hexData = raw_data.hex(" ")
  try:
    # value = raw_data.decode('utf-8', errors='replace')
    # print(f"Decoded Value: {value}")
    print(hexData)
  except UnicodeDecodeError as e:
    print(f"Error decoding bytes: {e}")
    print(f"Raw Bytes: {raw_data}")

    # output should be: bb 81 21 fd 48 bb c4 d4 [OLD]
    # Actual output should be c8 8f 1a 11 7f e2 a2 5c
    
    # Right now, it might be flipped as: 5c a2 e2 7f 11 1a 8f c8
