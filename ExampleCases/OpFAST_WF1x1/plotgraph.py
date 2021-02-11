import matplotlib.pyplot as plt
import numpy
import pandas as pd
import control.matlab as cnt
import cp
import scipy.optimize as optim
import OBSERVER

kp=8e3
ki=1e6
Jr = 115926
Jg = 534.116
kt = 8.67637e8
rt = 6.215e6
tau = 97
rho = 1.225
R = 63
A = numpy.array([[-rt/Jr, (rt/(Jr*tau)) - kp/Jr, -kt/Jr, (kt/(Jr*tau)) - ki/Jr],[rt/(tau*Jg), -rt/(tau*tau*Jg), kt/(tau*Jg), -kt/(tau*tau*Jg)],[1, 0, 0, 0],[0, 1, 0, 0]])
BQg = numpy.array([[0],[-1/Jg],[0],[0]])
Ctot = numpy.array([[0, 1, 0, 0]])
BQa1 = numpy.array([[kp/Jr],[0],[0],[0]])
BQa2 = numpy.array([[ki/Jr],[0],[0],[0]])
print("A: ", A)
print("BQg: ", BQg)
print("Ctot: ", Ctot)
print("BQa1: ", BQa1)
print("BQa2: ", BQa2)

Q = numpy.dot(numpy.identity(4), 1e5)
print("Q: ", Q)
Rinv = 1e-5

(Pcare_t, Leig_t, Gcare_t) = cnt.care(A.transpose(), Ctot.transpose(), Q.transpose(), Rinv)
Pcare = Pcare_t.transpose()
Gcare = Gcare_t.transpose()
print("G: ", Gcare)

df = pd.read_csv('Error.txt')
data = df.values
df2 = pd.read_csv('ErrorPosg.txt')
data2 = df2.values
df9 = pd.read_csv('ErrorPosr.txt')
data9 = df9.values
df3 = pd.read_csv('ErrorWG.txt')
data3 = df3.values
df5 = pd.read_csv('ErrorWR.txt')
data5 = df5.values
df4 = pd.read_csv('EXSOL.txt')
data4 = df4.values
df6 = pd.read_csv('EWR.txt')
data6 = df6.values
df7 = pd.read_csv('EPOSG.txt')
data7 = df7.values
df10 = pd.read_csv('EPOSR.txt')
data10 = df10.values
df8 = pd.read_csv('EWG.txt')
data8 = df8.values
df12 = pd.read_csv('EPitch.txt')
data12 = df12.values
#df13 = pd.read_csv('EWRFiltered.txt')
#data13 = df13.values
df14 = pd.read_csv('EWIND.txt')
data14 = df14.values
df15 = pd.read_csv('ENum.txt')
data15 = df15.values
df16 = pd.read_csv('EQasol.txt')
data16 = df16.values
plt.plot(data[:,1], data[:,0])
plt.title("ERRORE Qa 1")
plt.show()
plt.show()
plt.plot(data2[:,1], data2[:,0])
plt.title("ERRORE POSIZIONE WG")
plt.show()
plt.plot(data9[:,1], data9[:,0])
plt.title("ERRORE POSIZIONE WR")
plt.show()
plt.plot(data3[:,1], data3[:,0])
plt.title("ERRORE WG")
plt.show()
plt.plot(data5[:,1], data5[:,0])
plt.title("ERRORE WR")
plt.show()
plt.plot(data6[:,1], data6[:,0])
plt.title("WR")
plt.show()
#plt.plot(data4[:,4], data4[:,0],'r--',data4[:,4], data4[:,1],'b--')
#plt.title("VELOCITA SOLUZIONE")
#plt.show()
#plt.plot(data4[:,4], data4[:,2],'r--',data4[:,4], data4[:,3],'b--')
#plt.title("POSIZIONE SOLUZIONE")
#plt.show()
plt.plot(data4[:,4], data4[:,0],'b--', data6[:,1], data6[:,0],'r--') #, data13[:,1], data13[:,0], 'b')
plt.title("WR STIMATA contro WR REALE")
plt.show()
plt.plot(data4[:,4], data4[:,1],'b--', data8[:,1], data8[:,0],'r--')
plt.title("WG STIMATA contro WG REALE")
plt.show()
plt.plot(data4[:,4], data4[:,3],'b--', data7[:,1], data7[:,0],'r--')
plt.title("POSG STIMATA contro POSG REALE")
plt.show()
plt.plot(data4[:,4], data4[:,2],'b--', data10[:,1], data10[:,0],'r--')
plt.title("POSR STIMATA contro POSR REALE")
plt.show()

plt.plot(data12[:,2], data12[:,0])
plt.title("PITCH")
plt.show()

plt.plot(data15[:,1], data15[:,0])
plt.title("Num")
plt.show()

#Qa = kp*(data8[:,0]-data4[:,1])+ki*(data7[:,0]-data4[:,3])

#plt.plot(data4[:,4], Qa,'b--', data16[:,1], data16[:,0], 'r')
plt.plot(data16[:,1], data16[:,0], 'r')
plt.title("Qasol")
plt.show()

plt.plot(data14[:,1], data14[:,0])
plt.title("WIND ONLINE")
plt.show()


dfdata = pd.read_csv('t1.T1.out', sep='\t', header=None, skiprows=10)
datadata = dfdata.values
vento_vero = datadata[:,1]
inert = datadata[:,7]*0.01745329*Jr
#Qa = Jr*data11[:,0] + rt*data4[:,0] + kt*data4[:,2] - (rt/tau)*data4[:,1] - (kt/tau)*data4[:,3] - Gcare[0]*data7[:,0] + Gcare[0]*data4[:,1]
#plt.plot(data4[:,4], Qa,'b--',datadata[:,0], 1000*datadata[:,6]+inert,'r--')
#plt.title("Qa a posteriori")
#plt.show()

Qa = kp*(data8[:,0]-data4[:,1])+ki*(data7[:,0]-data4[:,3])
plt.plot(data4[:,4], Qa,'b--',datadata[:,0], 1000*datadata[:,6]+inert,'r--', data16[:,1], data16[:,0], 'b')
#plt.plot(data4[:,4], Qa,'b--')
plt.title("Qa a posteriori")
plt.show()

for i in range(len(data12[:,1])):
    if data12[i,0] >= 17:
        data12[i,0] = 17
    elif data12[i,0] <= -10:
        data12[i,0] = -10



pitch_vec = data12[:,0]
pitch_vec1 = numpy.zeros(numpy.shape(pitch_vec))
pmean = numpy.mean(pitch_vec)
nn=0
for i in range(len(pitch_vec)):
    if nn < 12:
        pitch_vec1[i] = 0
        nn = nn+1
    elif nn==24:
        pitch_vec1[i] = numpy.mean(pitch_vec[i-24:i])
        nn=12
    else:
        pitch_vec1[i] = pitch_vec1[i-1]
        nn=nn+1
#pitch_vec1[:] = pmean
plt.plot(data12[:,2], pitch_vec1)
plt.title("PITCH MEAN")
plt.show()
#wr = data6[:,0] #VERA
wr = data4[:,0] #STIMATA
wr2 = numpy.power(wr, 2)
print(wr[-1]**2, wr2[-1])
print("wr^2: ", wr2)
den = numpy.dot(numpy.pi*rho*(R**5), wr2)
print("den: ", den)
numero = numpy.multiply(2*Qa, numpy.reciprocal(den))
#print("SHAPE: ", numpy.shape(datadata[0:18390,6]))
#print("SHAPE: ", numpy.shape(den))
#numero = numpy.multiply(2*1000*datadata[0:5709,6]+inert[0:5709], numpy.reciprocal(den[0:5709]))
print("numero: ", numero)

def funz(x, num, pitch):
    return float(cp.cp_int(x, pitch))/(x**3)-num

b = float(cp.cp_int(10, 1))
print("b: ", b)
a = optim.fsolve(funz, 10, args=(float(numero[0]), float(pitch_vec[0])))
print("a: ", a)

vento = numpy.array([0])
tsrres = numpy.array([2.4])
for j in range(len(numero)):
    if j == 0:
        (vento, infos, ier, msg) = optim.fsolve(funz, 2.4, args=(numero[j], pitch_vec[j]), full_output=1)
        tsrres = vento
        if ier == 1:
            vento = wr[j]*R/vento
        else:
            vento = 0
    else:
        flag = 0
        for jj in range(1):#10
            tento = numpy.arange(0.4,11.4,step=1)
            (vento_tmp, infos, ier, msg) = optim.fsolve(OBSERVER.func_impl, 4.4, args=(numero[j], pitch_vec[j]), full_output=1)
            if ier == 1:
                tsrtemp = vento_tmp
                flag = flag+1
            #tsrres = numpy.vstack((tsrres, tsrres[j-1]))
            #vento[j] = vento[j-1]
        if flag == 0:
            tsrres = numpy.vstack((tsrres, 0))
            vento = numpy.vstack((vento, 0))
        else:
            vento = numpy.vstack((vento, tsrtemp))
            tsrres = numpy.vstack((tsrres, tsrtemp))
            vento[j] = wr[j]*R/vento[j]

plt.plot(data6[:,1], vento,'b',datadata[:,0], vento_vero,'r', data14[:,1], data14[:,0], 'b--')
#plt.plot(data6[:,1], vento,'b')
plt.title("VENTO")
plt.show()

plt.plot(data6[:,1], tsrres)
plt.title("TSR")
plt.show()


#plt.plot(data4[:,4], data4[:,1],'b--', data6[:,1], data6[:,0],'r--',data4[:,4], data4[:,1],'b--', data6[:,1], data6[:,0],'r--')
#plt.show()