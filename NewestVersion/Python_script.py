from datetime import datetime

def ROTL32(value, shift):
    return ((value << shift) & 0xFFFFFFFF) | (value >> (32 - shift))

def ROTR32(value, shift):
    return ((value >> shift)) | (0xFFFFFFFF & value << (32 - shift))
    #return (((x >> r) & 0xFFFFFFFF) | (x << (32-r)))

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
        #print("Round " + str(i) + ": ", end="")
        #print(hex(rk[i]))
    '''
    for i in range(0, 42):
        print("Round " + str(i) + ": ", end="")
        print(hex(rk[i]))
    '''
    return rk
    

def Simon6496Encrypt(Pt, rk):
    #print(Pt, rk)
    Ct = [0, 0]  
    Ct[1] = Pt[1]
    Ct[0] = Pt[0]
    i = 0
    while i < 42:
        Ct[1], Ct[0] = R32x2(Ct[1], Ct[0], rk[i], rk[i + 1])
        i += 2 
    
    #print(Ct)
    return "{:08X}{:08X}".format(Ct[1], Ct[0])

def Simon6496Decrypt(Pt, Ct, rk):
    Pt[1] = Ct[1]
    Pt[0] = Ct[0]
    i = 41
    while i >= 0:
        Pt[0], Pt[1] = R32x2(Pt[0], Pt[1], rk[i], rk[i - 1])
        i -= 2

startTime = datetime.now()
#Key = [0x13121110, 0x0b0a0908, 0x03020100]
Key = [0x03020100, 0x0b0a0908, 0x13121110]
PT = [0x6e696c63, 0x6f722067]
rk = Simon6496KeySchedule(Key)
CT = Simon6496Encrypt(PT, rk)
print(CT)
print("Time elapsed: ", end = "")
print(datetime.now() - startTime)
#output should be: 5ca2e27f111a8fc8
