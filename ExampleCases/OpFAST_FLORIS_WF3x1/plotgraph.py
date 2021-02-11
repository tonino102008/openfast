import matplotlib.pyplot as plt
import numpy
import pandas as pd
import control.matlab as cnt
import cp
import scipy.optimize as optim

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

Q = numpy.dot(numpy.identity(4), 1e3)
print("Q: ", Q)
Rinv = 1e-3

(Pcare_t, Leig_t, Gcare_t) = cnt.care(A.transpose(), Ctot.transpose(), Q.transpose(), Rinv)
Pcare = Pcare_t.transpose()
Gcare = Gcare_t.transpose()
print("G: ", Gcare)

iT = 2
nT = 3
nend = 30000 #Interrompi risultati qui, perchè dopo non ha più senso
nend = 180000
df = pd.read_csv('Error.txt', header=None)
data = df.values[iT:nend:nT,:]
df2 = pd.read_csv('ErrorPosg.txt', header=None)
data2 = df2.values[iT:nend:nT,:]
df9 = pd.read_csv('ErrorPosr.txt', header=None)
data9 = df9.values[iT:nend:nT,:]
df3 = pd.read_csv('ErrorWG.txt', header=None)
data3 = df3.values[iT:nend:nT,:]
df5 = pd.read_csv('ErrorWR.txt', header=None)
data5 = df5.values[iT:nend:nT,:]
df4 = pd.read_csv('EXSOL.txt', header=None)
data4 = df4.values[iT:nend:nT,:]
df6 = pd.read_csv('EWR.txt', header=None)
data6 = df6.values[iT:nend:nT,:]
df7 = pd.read_csv('EPOSG.txt', header=None)
data7 = df7.values[iT:nend:nT,:]
df10 = pd.read_csv('EPOSR.txt', header=None)
data10 = df10.values[iT:nend:nT,:]
df8 = pd.read_csv('EWG.txt', header=None)
data8 = df8.values[iT:nend:nT,:]
#df11 = pd.read_csv('EACC.txt')
#data11 = df11.values[iT:nend:nT,:]
df12 = pd.read_csv('EPitch.txt', header=None)
data12 = df12.values[iT:nend:nT,:]
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
plt.plot(data4[:,4], data4[:,0],'b--', data6[:,1], data6[:,0],'r--')
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


dfdata = pd.read_csv('t3.T3.out', sep='\t', header=None, skiprows=10)
datadata = dfdata.values[0:180000,:]
vento_vero = datadata[:,1]
inert = datadata[:,7]*0.01745329*Jr
#Qa = Jr*data11[:,0] + rt*data4[:,0] + kt*data4[:,2] - (rt/tau)*data4[:,1] - (kt/tau)*data4[:,3] - Gcare[0]*data7[:,0] + Gcare[0]*data4[:,1]
#plt.plot(data4[:,4], Qa,'b--',datadata[:,0], 1000*datadata[:,6]+inert,'r--')
#plt.title("Qa a posteriori")
#plt.show()


Qa = kp*(data8[:,0]-data4[:,1])+ki*(data7[:,0]-data4[:,3])
plt.plot(data4[:,4], Qa,'b--',datadata[:,0], 1000*datadata[:,6]+inert,'r--')
#plt.plot(data4[:,4], Qa,'b--')
plt.title("Qa a posteriori")
plt.show()

plt.plot(data12[:,2], data12[:,0], 'b', datadata[:,0], datadata[:,4], 'r')
plt.title("PITCH")
plt.show()

for i in range(len(data12[:,2])):
    if data12[i,0] >= 18:
        data12[i,0] = 18
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
            (vento_tmp, infos, ier, msg) = optim.fsolve(funz, tento[4], args=(numero[j], pitch_vec[j]), full_output=1)
            if ier == 1:
                tsrtemp = vento_tmp
                flag = flag+1
            #tsrres = numpy.vstack((tsrres, tsrres[j-1]))
            #vento[j] = vento[j-1]
        print(flag)
        if flag == 0:
            tsrres = numpy.vstack((tsrres, 0))
            vento = numpy.vstack((vento, 0))
        else:
            vento = numpy.vstack((vento, tsrtemp))
            tsrres = numpy.vstack((tsrres, tsrtemp))
            vento[j] = wr[j]*R/vento[j]
print("VENTO: ", vento)

plt.plot(data6[:,1], vento,'b',datadata[:,0], vento_vero,'r')
#plt.plot(data6[:,1], vento,'b')
plt.title("VENTO")
plt.show()

plt.plot(data6[:,1], tsrres)
plt.title("TSR")
plt.show()


#plt.plot(data4[:,4], data4[:,1],'b--', data6[:,1], data6[:,0],'r--',data4[:,4], data4[:,1],'b--', data6[:,1], data6[:,0],'r--')
#plt.show()