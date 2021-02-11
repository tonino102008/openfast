import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

'''df1 = pd.read_csv('NN.txt', sep='\t', header=None)
xx = df1.values[:,1:6]
yy = df1.values[:,6].reshape((22000,1))
for i in range(11):
    yy[2000 * i:2000 * (i+1)] = yy[2000 * i:2000 * (i+1)] / xx[2000 * i , 4]
yy = yy / np.amax(abs(yy))
xx = np.multiply(xx ,1/np.amax(abs(xx), axis = 0))
X = xx
y = yy
input("OK")'''

# X = (hours sleeping, hours studying), y = score on test
#X = np.array(([2, 9], [1, 5], [3, 6]), dtype=float)
#y = np.array(([-92], [-86], [-89]), dtype=float)

# scale units
#X = X/np.amax(X, axis=0) # maximum of X array
#y = y/100 # max test score is 100

dfww1 = pd.read_csv('weights1.txt', sep='\t', header=None)
dfww2 = pd.read_csv('weights2.txt', sep='\t', header=None)
normCoef = pd.read_csv('norm.txt', sep='\t', header=None)
ww1 = dfww1.values[:,1:11]
ww2 = dfww2.values[:,1:2]
normC = normCoef.values[:,1:2]
normY = 0.5002698876378495
old_cw = 0.0

class Neural_Network(object):
    def __init__(self, W1 = None, W2 = None):
        #parameters
        self.inputSize = 5
        self.outputSize = 1
        self.hiddenSize = 10

        self.lr = 1e-6

        #weights
        if W1.all() == None and W2.all() == None:
            self.W1 = np.random.randn(self.inputSize, self.hiddenSize) # (3x2) weight matrix from input to hidden layer
            self.W2 = np.random.randn(self.hiddenSize, self.outputSize) # (3x1) weight matrix from hidden to output layer
        else:
            self.W1 = W1
            self.W2 = W2
        print(self.W1, self.W2)

    def forward(self, X):
        #forward propagation through our network
        self.z = np.dot(X, self.W1) # dot product of X (input) and first set of 3x2 weights
        self.z2 = self.sigmoid(self.z) # activation function
        self.z3 = np.dot(self.z2, self.W2) # dot product of hidden layer (z2) and second set of 3x1 weights
        o = self.sigmoid(self.z3) # final activation function
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

        self.z2_error = self.o_delta.dot(self.W2.T) # z2 error: how much our hidden layer weights contributed to output error
        self.z2_delta = self.z2_error*self.sigmoidPrime(self.z2) # applying derivative of sigmoid to z2 error

        self.W1 += self.lr*X.T.dot(self.z2_delta) # adjusting first set (input --> hidden) weights
        self.W2 += self.lr*self.z2.T.dot(self.o_delta) # adjusting second set (hidden --> output) weights

    def train(self, X, y):
        o = self.forward(X)
        self.backward(X, y, o)

    def SaveWeights(self):
        return self.W1, self.W2

NN = Neural_Network(ww1, ww2)

'''
for i in range(10000): # trains the NN 1,000 times    
    #print("Input: \n" + str(X) )
    #print("Actual Output: \n" + str(y) )
    #print("Predicted Output: \n" + str(NN.forward(X)) )
    print("Loss: \n" + str(np.mean(np.square(y - NN.forward(X))))) # mean sum squared loss
    print("\n")
    NN.train(X, y)

weights = NN.SaveWeights()
w1 = np.asarray(weights[0])
w2 = np.asarray(weights[1])

dataset = pd.DataFrame(data=w1)
dataset.to_csv('weights1.txt', sep='\t', header=None)
dataset = pd.DataFrame(data=w2)
dataset.to_csv('weights2.txt', sep='\t', header=None)

plt.scatter(range(len(X[:,1])), NN.forward(X))
plt.scatter(range(len(X[:,1])), y)
plt.show()'''