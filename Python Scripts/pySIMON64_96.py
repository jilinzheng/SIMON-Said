from datetime import datetime

def ROTL32(value, shift):
    # Perform bitwise left shift and right shift operations to rotate bits
    return ((value << shift) & 0xFFFFFFFF) | (value >> (32 - shift))

def ROTR32(value, shift):
    # Perform bitwise right shift and left shift operations to rotate bits
    return ((value >> shift)) | (0xFFFFFFFF & value << (32 - shift))

def f32(x):
    # Apply bitwise operations to compute a non-linear function
    return ((ROTL32(x, 1) & ROTL32(x, 8)) ^ ROTL32(x, 2))

def R32x2(x, y, k1, k2):
    # Apply bitwise XOR and rotation operations
    y ^= f32(x)
    y ^= k1
    x ^= f32(y)
    x ^= k2
    return x, y

def Simon6496KeySchedule(K):
    # Key expansion algorithm to generate round keys
    rk = [0] * 42
    c = 0xfffffffc
    z = 0x7369f885192c0ef5
    rk[0] = K[0]
    rk[1] = K[1]
    rk[2] = K[2]
    for i in range(3, 42):
        rk[i] = c ^ (z & 1) ^ rk[i - 3] ^ ROTR32(rk[i - 1], 3) ^ ROTR32(rk[i - 1], 4)
        z >>= 1
    return rk

def Simon6496Encrypt(Pt, rk):
    # Encryption function using Simon 64/96 block cipher
    Ct = [0, 0]
    Ct[1] = Pt[1]
    Ct[0] = Pt[0]
    i = 0
    while i < 42:
        Ct[1], Ct[0] = R32x2(Ct[1], Ct[0], rk[i], rk[i + 1])
        i += 2
    # Format the ciphertext as a hexadecimal string
    return "{:08X}{:08X}".format(Ct[1], Ct[0])

def Simon6496Decrypt(Pt, Ct, rk):
    # Decryption function using Simon 64/96 block cipher
    Pt[1] = Ct[1]
    Pt[0] = Ct[0]
    i = 41
    while i >= 0:
        Pt[0], Pt[1] = R32x2(Pt[0], Pt[1], rk[i], rk[i - 1])
        i -= 2

# Get user input for the key
userKey = str(input("Your key must be 24 hexadecimal characters(12 characters/96 bits). Please enter your key in hex: "))
while (len(userKey) != 24):
    userKey = input("Read carefully. Your key must be 12 characters/96 bits. Please enter your key in hex: ")

# Get user input for data format (Hex only for this script)
userChoice = input("\nYou may only enter your data in hexadecimal. Type 'H' to confirm you have read this message: ")
while (userChoice != "H"):
    userChoice = input("Did you read the message? You may only enter your data in hexadecimal. Type 'H' to confirm you have read this message: ")

if userChoice == "H":  # User chooses to input hexadecimal
    userInput = str(input("\nEnter your hex data (exactly 16 hex digits): "))
    startTime = datetime.now()  # Record the starting time for latency evaluation       
    # Extract two parts of the input and convert to integers
    PT1_1 = int("{:08X}".format(int('0x' + userInput[-2] + userInput[-1] + userInput[-4] + userInput[-3] +
                                      userInput[-6] + userInput[-5] + userInput[-8] + userInput[-7], 16)), 16)
    PT2_1 = int("{:08X}".format(int('0x' + userInput[-10] + userInput[-9] + userInput[-12] + userInput[-11] +
                                      userInput[-14] + userInput[-13] + userInput[-16] + userInput[-15], 16)), 16)

# Extract key components and create key list
k1 = '0x' + userKey[6] + userKey[7] + userKey[4] + userKey[5] + userKey[2] + userKey[3] + userKey[0] + userKey[1]
k2 = '0x' + userKey[14] + userKey[15] + userKey[12] + userKey[13] + userKey[10] + userKey[11] + userKey[8] + userKey[9]
k3 = '0x' + userKey[22] + userKey[23] + userKey[20] + userKey[21] + userKey[18] + userKey[19] + userKey[16] + userKey[17]
Key = [int(k1, 16), int(k2, 16), int(k3, 16)]

# Create plaintext list
PT = [PT2_1, PT1_1]

# Generate round keys
rk = Simon6496KeySchedule(Key)

# Encrypt plaintext
CT = Simon6496Encrypt(PT, rk)

# Extract last two characters of the ciphertext, reverse them, and format as a hexadecimal string
CT_str = str(CT)
CT_flipt_str = '0x' + CT_str[-2] + CT_str[-1] + CT_str[-4] + CT_str[-3] + CT_str[-6] + CT_str[-5] + CT_str[-8] + CT_str[-7] + \
                CT_str[-10] + CT_str[-9] + CT_str[-12] + CT_str[-11] + CT_str[-14] + CT_str[-13] + CT_str[-16] + CT_str[-15]
CT_flipt = "{:08X}".format(int(CT_flipt_str, 16))

# Print the ciphertext and elapsed time
print("Ciphertext:", CT_flipt)
print("Time elapsed: ", end="")
print(datetime.now() - startTime)

#Key: 0001020308090A0B10111213
#Plaintext:636C696E6720726F
#Ciphertext: C88F1A117FE2A25C