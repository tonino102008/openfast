import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class Neural_Network(object):
    #def __init__(self, W1 = np.array([None]), W2 = np.array([None]), W3 = np.array([None]), W4 = np.array([None]), b1 = np.array([None]), b2 = np.array([None]), b3 = np.array([None])):
    def __init__(self, W1 = np.array([None]), W2 = np.array([None]), W3 = np.array([None]), W4 = np.array([None])):
        #parameters
        self.inputSize = 5
        self.outputSize = 1
        self.hidden1Size = 10
        self.hidden2Size = 10
        self.hidden3Size = 10

        self.lr = 1e-6

        #weights
        if W1.all() == None and W2.all() == None and W3.all() == None and W4.all() == None:
            self.W1 = np.random.randn(self.inputSize, self.hidden3Size) # (3x2) weight matrix from input to hidden layer
            self.W2 = np.random.randn(self.hidden3Size, self.hidden2Size) # (3x1) weight matrix from hidden to output layer
            self.W3 = np.random.randn(self.hidden2Size, self.hidden1Size) # (3x1) weight matrix from hidden to output layer
            self.W4 = np.random.randn(self.hidden1Size, self.outputSize) # (3x1) weight matrix from hidden to output layer
            #self.b1 = np.random.randn(self.hidden3Size, 1).T # (3x1) weight matrix from hidden to output layer
            #self.b2 = np.random.randn(self.hidden2Size, 1).T # (3x1) weight matrix from hidden to output layer
            #self.b3 = np.random.randn(self.hidden1Size, 1).T # (3x1) weight matrix from hidden to output layer
        else:
            self.W1 = W1
            self.W2 = W2
            self.W3 = W3
            self.W4 = W4
            #self.b1 = b1
            #self.b2 = b2 # (3x1) weight matrix from hidden to output layer
            #self.b3 = b3 # (3x1) weight matrix from hidden to output layer
        print(self.W1, self.W2, self.W3, self.W4)

    def forward(self, X):
        #forward propagation through our network
        self.z = np.dot(X, self.W1) #+ self.b1 # dot product of X (input) and first set of 3x2 weights
        self.z2 = self.sigmoid(self.z) # activation function
        self.z3 = np.dot(self.z2, self.W2) #+ self.b2 # dot product of hidden layer (z2) and second set of 3x1 weights
        self.z4 = self.sigmoid(self.z3) # final activation function
        self.z5 = np.dot(self.z4, self.W3) #+ self.b3
        self.z6 = self.sigmoid(self.z5) # final activation function
        self.z7 = np.dot(self.z6, self.W4)
        o = self.sigmoid(self.z7)
        return o 

    def sigmoid(self, s):
        # activation function 
        #return 1/(1+np.exp(-s))
        return np.tanh(s)
        #return s

    def sigmoidPrime(self, s):
        #derivative of sigmoid
        return 1 - np.power(np.tanh(s),2)
        #return 1

    def backward(self, X, y, o):
        # backward propgate through the network
        self.o_error = y - o # error in output
        self.o_delta = self.o_error*self.sigmoidPrime(o) # applying derivative of sigmoid to error

        self.z6_errorb = self.o_delta
        self.z6_deltab = self.z6_errorb*self.sigmoidPrime(self.z6) # applying derivative of sigmoid to z2 error
        self.z6_error = self.o_delta.dot(self.W4.T) # z2 error: how much our hidden layer weights contributed to output error
        self.z6_delta = self.z6_error*self.sigmoidPrime(self.z6) # applying derivative of sigmoid to z2 error

        self.z4_errorb = self.z6_delta #(np.ones(np.shape(self.W3.T)))
        self.z4_deltab = self.z4_errorb*self.sigmoidPrime(self.z4) # applying derivative of sigmoid to z2 error
        self.z4_error = self.z6_delta.dot(self.W3.T) # z2 error: how much our hidden layer weights contributed to output error
        self.z4_delta = self.z4_error*self.sigmoidPrime(self.z4) # applying derivative of sigmoid to z2 error

        self.z2_errorb = self.z4_delta #(np.ones(np.shape(self.W2.T)))
        self.z2_deltab = self.z2_errorb*self.sigmoidPrime(self.z2) # applying derivative of sigmoid to z2 error
        self.z2_error = self.z4_delta.dot(self.W2.T) # z2 error: how much our hidden layer weights contributed to output error
        self.z2_delta = self.z2_error*self.sigmoidPrime(self.z2) # applying derivative of sigmoid to z2 error
        #print(np.shape(self.z2_deltab))
        #print(np.shape(self.sigmoidPrime(self.z6)))
        #print(np.shape(X.T))
        #input("1")

        self.W1 += self.lr*X.T.dot(self.z2_delta) # adjusting first set (input --> hidden) weights
        self.W2 += self.lr*self.z2.T.dot(self.z4_delta) # adjusting second set (hidden --> output) weights
        self.W3 += self.lr*self.z4.T.dot(self.z6_delta) # adjusting second set (hidden --> output) weights
        self.W4 += self.lr*self.z6.T.dot(self.o_delta) # adjusting second set (hidden --> output) weights
        #self.b3 += np.diag(self.lr*self.z4.T.dot(self.z6_deltab)) # adjusting second set (hidden --> output) weights
        #self.b2 += np.diag(self.lr*self.z2.T.dot(self.z4_deltab)) # adjusting second set (hidden --> output) weights
        #self.b1 += self.lr*self.z2_deltab[1,:] # adjusting first set (input --> hidden) weights
    
    def train(self, X, y):
        o = self.forward(X)
        self.backward(X, y, o)

    def SaveWeights(self):
        return self.W1, self.W2, self.W3, self.W4#, self.b1, self.b2, self.b3

dfww1 = pd.read_csv('weights1Y.txt', sep='\t', header=None)
dfww2 = pd.read_csv('weights2Y.txt', sep='\t', header=None)
dfww3 = pd.read_csv('weights3Y.txt', sep='\t', header=None)
dfww4 = pd.read_csv('weights4Y.txt', sep='\t', header=None)
#dfb1 = pd.read_csv('b1.txt', sep='\t', header=None)
#dfb2 = pd.read_csv('b2.txt', sep='\t', header=None)
#dfb3 = pd.read_csv('b3.txt', sep='\t', header=None)
normCoef = pd.read_csv('normY.txt', sep='\t', header=None)
ww1 = dfww1.values[:,1:11]
ww2 = dfww2.values[:,1:11]
ww3 = dfww3.values[:,1:11]
ww4 = dfww4.values[:,1:2]
#bb1 = dfb1.values[:,1:]
#bb2 = dfb2.values[:,1:]
#bb3 = dfb3.values[:,1:]

normC = normCoef.values[:,1:2]
normY = 0.258864833081411
old_cw = 0.0
old2_cw = 0.0
oldf_cw = 0.0
old2f_cw = 0.0
wc_butt = np.pi * 2 * 5 / (((2**0.5) - 1)**0.5)
Ts_butt = 0.005
n1 = (wc_butt*Ts_butt)**2
n2 = ((wc_butt*Ts_butt)**2)*2 - 8
n3 = ((wc_butt*Ts_butt)**2)*2 + 4 - 4*wc_butt*Ts_butt
d1 = ((wc_butt*Ts_butt)**2)*2 + 4 + 4*wc_butt*Ts_butt

#NN = Neural_Network()
NN = Neural_Network(ww1,ww2,ww3,ww4)
