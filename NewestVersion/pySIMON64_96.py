from datetime import datetime

def ROTL32(value, shift):
    return ((value << shift) & 0xFFFFFFFF) | (value >> (32 - shift))

def ROTR32(value, shift):
    return ((value >> shift)) | (0xFFFFFFFF & value << (32 - shift))

def f32(x):
    return ((ROTL32(x, 1) & ROTL32(x, 8)) ^ ROTL32(x, 2))

def R32x2(x, y, k1, k2):
    y ^= f32(x)
    y ^= k1
    x ^= f32(y)
    x ^= k2
    return x, y

def Simon6496KeySchedule(K):
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
    Ct = [0, 0]  
    Ct[1] = Pt[1]
    Ct[0] = Pt[0]
    i = 0
    while i < 42:
        Ct[1], Ct[0] = R32x2(Ct[1], Ct[0], rk[i], rk[i + 1])
        i += 2 
    return "{:08X}{:08X}".format(Ct[1], Ct[0])

def Simon6496Decrypt(Pt, Ct, rk):
    Pt[1] = Ct[1]
    Pt[0] = Ct[0]
    i = 41
    while i >= 0:
        Pt[0], Pt[1] = R32x2(Pt[0], Pt[1], rk[i], rk[i - 1])
        i -= 2

userKey = str(input("Your key must be 24 hexadecimal characters(12 characters/96 bits). Please enter your key in hex: "))
while (len(userKey) != 24):
        userKey = input("Read carefully. Your key must be 12 characters/96 bits. Please enter your key in hex: ")

userChoice = input("\nNow enter your data in ASCII or Hex. Type 'A' or 'H' in English. ")
while (userChoice != "A") and (userChoice != "H"):
    userInput = input("You entered an invalid character! ASCII or Hex? Type 'A' or 'H' in English. ")

if userChoice == "H":                                   # User chooses to input hexadecimal
    userInput = str(input("\nEnter your hex data (exactly 32 hex digits): "))            
    PT1_1 = str('0x' +userInput[-2]+ userInput[-1]+ userInput[-4]+ userInput[-3]+ userInput[-6]+ userInput[-5]+userInput[-8]+ userInput[-7])
    PT2_1 = str('0x' +userInput[-10]+ userInput[-9]+ userInput[-12]+ userInput[-11]+ userInput[-14]+ userInput[-13]+userInput[-16]+ userInput[-15])
    PT_1 = int("{:08X}".format(int(PT1_1, 16)), 16)
    PT_2 = int("{:08X}".format(int(PT2_1, 16)), 16)
    startTime = datetime.now()                         # Record the starting time for latency evaluation

k1 ='0x'+userKey[6]+userKey[7]+userKey[4]+userKey[5]+userKey[2]+userKey[3]+userKey[0]+userKey[1]
k2 ='0x'+userKey[14]+userKey[15]+userKey[12]+userKey[13]+userKey[10]+userKey[11]+userKey[8]+userKey[9]
k3 ='0x'+userKey[22]+userKey[23]+userKey[20]+userKey[21]+userKey[18]+userKey[19]+userKey[16]+userKey[17]
Key = [int(k1, 16), int(k2, 16), int(k3, 16)]
PT = [PT_2, PT_1]
rk = Simon6496KeySchedule(Key)
CT = Simon6496Encrypt(PT, rk)
CT_str= str(CT)
CT_flipt_str='0x'+ CT_str[-2]+CT_str[-1]+CT_str[-4]+CT_str[-3]+CT_str[-6]+CT_str[-5]+CT_str[-8]+CT_str[-7]+CT_str[-10]+CT_str[-9]+CT_str[-12]+CT_str[-11]+CT_str[-14]+CT_str[-13]+CT_str[-16]+CT_str[-15]
CT_flipt="{:08X}".format(int(CT_flipt_str, 16))
print("Ciphertext:", CT_flipt)
print("Time elapsed: ", end = "")
print(datetime.now() - startTime)
#Key: 0001020308090A0B10111213
#Plaintext:636C696E6720726F
#Ciphertext: C88F1A117FE2A25C
