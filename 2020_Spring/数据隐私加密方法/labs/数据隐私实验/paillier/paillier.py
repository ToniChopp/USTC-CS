"""
"""
import random, sys 
import datetime
from gmpy2 import mpz, powmod, invert, is_prime, random_state, mpz_urandomb, rint_round, log2, gcd 

rand=random_state(random.randrange(sys.maxsize))

class PrivateKey(object):
    def __init__(self, p, q, n):
        if p==q:
            self.l = p * (p-1)
        else:
            self.l = (p-1) * (q-1)
        try:
            self.m = invert(self.l, n)
        except ZeroDivisionError as e:
            print(e)
            exit()

class PublicKey(object):
    def __init__(self, n):
        self.n = n
        self.n_sq = n * n
        self.g = n + 1
        self.bits=mpz(rint_round(log2(self.n)))

def generate_prime(bits):    
    """Will generate an integer of b bits that is prime using the gmpy2 library  """    
    while True:
        possible =  mpz(2)**(bits-1) + mpz_urandomb(rand, bits-1 )
        if is_prime(possible):
            return possible

def generate_keypair(bits):
    """ Will generate a pair of paillier keys bits>5"""
    p = generate_prime(bits // 2)
    #print(p)
    q = generate_prime(bits // 2)
    #print(q)
    n = p * q
    return PrivateKey(p, q, n), PublicKey(n)

def enc(pub, plain):#(public key, plaintext) #to do
    pubn = mpz(pub.n)
    pubg = mpz(pub.g)
    r = mpz(random.randint(1, pubn-1))
    while gcd(r, pubn)!= 1:
        r = mpz(random.uniform(1, pubn-1))
    cipher = powmod(powmod(pubg, plain, pub.n_sq) * powmod(r, pubn, pub.n_sq), 1, pub.n_sq)
    return cipher

def dec(priv, pub, cipher): #(private key, public key, cipher) #to do
    pubn = mpz(pub.n)
    privl = mpz(priv.l)
    privm = mpz(priv.m)
    x = powmod(cipher, privl, pow(pubn, 2))
    x -= 1
    plain = powmod(x // pubn * privm, 1, pubn)
    plain = powmod(plain, 1, pubn)
    return plain

def enc_add(pub, m1, m2): #to do
    """Add one encrypted integer to another"""
    return powmod(enc(pub, m1) * enc(pub, m2), 1, pub.n_sq)

def enc_add_const(pub, m, c): #to do
    """Add constant n to an encrypted integer"""
    return powmod(enc(pub, m)*pow(pub.g, c), 1, pub.n_sq)

def enc_mul_const(pub, m, c): #to do
    """Multiplies an encrypted integer by a constant"""
    return powmod(pow(enc(pub, c), m), 1, pub.n_sq)#, powmod(pow(enc(pub, c), m), 1, pub.n_sq)

if __name__ == '__main__':
    starttime = datetime.datetime.now()
    priv, pub = generate_keypair(1024)
    """
    test
    """
    m1 = mpz(1073741823)
    m2 = mpz(2154123156)
    print(dec(priv, pub, enc_add(pub, m1, m2)))
    print(dec(priv, pub, enc_add_const(pub, m1, m2)))
    print(dec(priv, pub, enc_mul_const(pub, m1, m2)))
    print("Executing time ",datetime.datetime.now() - starttime)