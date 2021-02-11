import matplotlib.pyplot as plt
import numpy
import pandas as pd
import control.matlab as cnt
import cp
import scipy.optimize as optim

dfdata = pd.read_csv('t1.T1.out', sep='\t', header=None, skiprows=10)
datadata = dfdata.values
dfdata2 = pd.read_csv('t2.T2.out', sep='\t', header=None, skiprows=10)
datadata2 = dfdata2.values
dfdata3 = pd.read_csv('t3.T3.out', sep='\t', header=None, skiprows=10)
datadata3 = dfdata3.values

D = 126.0
R = D/2
Np = 9
Nbl = 3

r = numpy.array([0.0, 6.8333000, 10.2500, 18.45000, 26.650, 34.85000, 47.1500, 54.6667, 61.5])

nn = min(len(datadata[:,0]), len(datadata2[:,0]), len(datadata3[:,0]))
#AIF1 = numpy.zeros((len(datadata[:nn:,0]),1))
#AIF2 = numpy.zeros((len(datadata2[:nn:,0]),1))
#AIF3 = numpy.zeros((len(datadata3[:nn:,0]),1))

print(datadata[:nn:,24:33][0])
print(datadata[:nn:,33:42][0])
print(datadata[:nn:,42:51][0])
print(r)

a1 = numpy.sum(numpy.multiply(datadata[:nn:,24:33], r) + numpy.multiply(datadata[:nn:,33:42], r) + numpy.multiply(datadata[:nn:,42:51], r), axis=1)
a2 = numpy.sum(numpy.multiply(datadata2[:nn:,24:33], r) + numpy.multiply(datadata2[:nn:,33:42], r) + numpy.multiply(datadata2[:nn:,42:51], r), axis=1)
a3 = numpy.sum(numpy.multiply(datadata3[:nn:,24:33], r) + numpy.multiply(datadata3[:nn:,33:42], r) + numpy.multiply(datadata3[:nn:,42:51], r), axis=1)
AIF1 = (1/(Nbl * numpy.sum(r))) * a1
AIF2 = (1/(Nbl * numpy.sum(r))) * a2
AIF3 = (1/(Nbl * numpy.sum(r))) * a3

print(numpy.shape(a1))
input("PREMI TASTO")

nn = min(len(datadata[:,0]), len(datadata2[:,0]), len(datadata3[:,0]))
plt.plot(datadata[:nn:,0], AIF1, 'b', label = 'T1')
plt.plot(datadata2[:nn:,0], AIF2, 'r', label = 'T2')
plt.plot(datadata3[:nn:,0], AIF3, 'g', label = 'T3')
plt.title("Rotor Averaged Axial Induction Factor", fontsize = 20)
plt.ylabel("Rotor Avg. AIF", fontsize = 20)
plt.xlabel("Simulated Time (s)", fontsize = 20)
plt.xticks(fontsize=20, rotation=0)
plt.yticks(fontsize=20, rotation=0)
plt.legend(fontsize = 20)
plt.ylim(0.4, 0.6)
plt.show()