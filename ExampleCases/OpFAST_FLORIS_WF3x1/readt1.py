import matplotlib.pyplot as plt
import numpy
import pandas as pd
import control.matlab as cnt
import cp
import scipy.optimize as optim

dfdata = pd.read_csv('T1.out', sep='\t', header=None)
datadata = dfdata.values

plt.plot(datadata[:,0], 1000*datadata[:,6])
plt.title("QAero")
plt.show()

Jr = 115926
inert = datadata[:,7]*0.01745329*Jr
plt.plot(datadata[:,0], 1000*datadata[:,6]+inert)
plt.title("QAero")
plt.show()

plt.plot(datadata[:,0], 1000*datadata[:,8])
plt.title("POWER")
plt.show()