import matplotlib.pyplot as plt
import numpy
import pandas as pd
import math
import numpy.fft as fourier
import scipy.interpolate as inter

# READ DATA FROM SIMULATION
iT = 0
nT = 3
nend = 30000 #Interrompi risultati qui, perchè dopo non ha più senso
nend = 180000
df1 = pd.read_csv('Bl1outin.txt', header=None)
bl1mom = df1.values[iT:nend:nT,:]
df2 = pd.read_csv('Bl2outin.txt', header=None)
bl2mom = df2.values[iT:nend:nT,:]
df3 = pd.read_csv('Bl3outin.txt', header=None)
bl3mom = df3.values[iT:nend:nT,:]
df4 = pd.read_csv('Azimuth.txt', header=None)
turbinfo = df4.values[iT:nend:nT,:]
df5 = pd.read_csv('/home/antonio/SOWFA/exampleCases/UniWind_3Turb_SC_OBS+YAWERROR_DEMOD/5MW_Baseline/Wind/WindSim.uniform', sep='\t', header=None)
windinfo = df5.values
df6 = pd.read_csv('ECROSS.txt', header=None)
data6 = df6.values[iT:nend:nT,:]
df7 = pd.read_csv('EMOM.txt', header=None)
data7 = df7.values[iT:nend:nT,:]


#GIVEN PARAMETERS
R = 63   #TURBINE RADIUS
print(windinfo)
V0 = windinfo[0,1] # it's a constant vector, so take only 1 value
yawerr = -windinfo[:,2]*numpy.pi/180
vert_shear = windinfo[:,5]
u0_p = V0*numpy.sin(yawerr) #CROSS_WIND
k1_p = vert_shear #VERTICAL WIND SHEAR POWER EXPONENT
dtFAST = 0.005

time = turbinfo[:,3]
timewind = windinfo[:,0]
u0_int = inter.interp1d(timewind, u0_p)
k1_int = inter.interp1d(timewind, k1_p)
wr = turbinfo[:,1]
azimuth1 = turbinfo[:,0]
azimuth2 = turbinfo[:,0] + 2*numpy.pi/3
azimuth3 = turbinfo[:,0] + 4*numpy.pi/3
u0bar = numpy.multiply(u0_int(time), 1/(wr*R))
V0bar = V0/(wr*R)
k1bar = numpy.multiply(k1_int(time), V0bar)
Tper = (2*numpy.pi) / wr
tau = Tper/1.5 #DA ABBASSARE IN SEGUITO per filtrare meglio la risposta a 3P-->1,5P    #CAZZO ATTENTO 3 o 1/3
print(V0)

m_out_notfil = numpy.zeros([len(bl1mom[:,0])*3])
m_in_notfil = numpy.zeros([len(bl1mom[:,0])*3])
for i in range(len(bl1mom[:,0])): # REARRANGING THE MOMENT BLADE VECTOR FOR CALCULATIONS
    m_out_notfil[3*i:3*i+3] = numpy.array([bl1mom[i,0], bl2mom[i,0], bl3mom[i,0]])
    m_in_notfil[3*i:3*i+3] = numpy.array([bl1mom[i,1], bl2mom[i,1], bl3mom[i,1]])

def ColTransf(ang1, ang2, ang3): #COLEMAN MBC TRANSFORMATION
    out = numpy.array([[1, 1, 1], [2*math.cos(ang1), 2*math.cos(ang2), 2*math.cos(ang3)], [2*math.sin(ang1), 2*math.sin(ang2), 2*math.sin(ang3)]])/3
    return out

m_out_tr = numpy.zeros([len(bl1mom[:,0])*3])
m_in_tr = numpy.zeros([len(bl1mom[:,0])*3])
for i in range(len(bl1mom[:,0])): #APPLYING MBC TRANSF. TO MOMENT VECTOR
    ColT = ColTransf(azimuth1[i], azimuth2[i], azimuth3[i])
    m_out_tr[3*i:3*i+3] = numpy.dot(ColT, m_out_notfil[3*i:3*i+3].transpose())
    m_in_tr[3*i:3*i+3] = numpy.dot(ColT, m_in_notfil[3*i:3*i+3].transpose())

#NOW I GO IN FREQUENCY DOMAIN
m_out_tr_time1 = m_out_tr[0::3]
m_out_tr_time2 = m_out_tr[1::3]
m_out_tr_time3 = m_out_tr[2::3]
m_in_tr_time1 = m_in_tr[0::3]
m_in_tr_time2 = m_in_tr[1::3]
m_in_tr_time3 = m_in_tr[2::3]

print(m_out_tr_time1)
plt.plot(time, bl1mom[:,0])
plt.title("M_OUT_TR_1")
plt.show()
print(m_out_tr_time1)
plt.plot(time, bl2mom[:,0])
plt.title("M_OUT_TR_1")
plt.show()
print(m_out_tr_time1)
plt.plot(time, bl3mom[:,0])
plt.title("M_OUT_TR_1")
plt.show()
print(m_out_tr_time1)
plt.plot(time, bl1mom[:,1])
plt.title("M_OUT_TR_1")
plt.show()
print(m_out_tr_time1)
plt.plot(time, bl2mom[:,1])
plt.title("M_OUT_TR_1")
plt.show()
print(m_out_tr_time1)
plt.plot(time, bl3mom[:,1])
plt.title("M_OUT_TR_1")
plt.show()

plt.plot(time, wr)
plt.title("WR")
plt.show()
plt.plot(time, m_out_tr_time1)
plt.title("M_OUT_1")
plt.show()

freq = fourier.fftfreq(len(m_out_tr_time1), d=dtFAST)

m_out_tr_freq1 = fourier.fft(m_out_tr_time1)
m_out_tr_freq2 = fourier.fft(m_out_tr_time2)
m_out_tr_freq3 = fourier.fft(m_out_tr_time3)
m_in_tr_freq1 = fourier.fft(m_in_tr_time1)
m_in_tr_freq2 = fourier.fft(m_in_tr_time2)
m_in_tr_freq3 = fourier.fft(m_in_tr_time3)

def FILTER_LP(input, freq, tau):
    s = 2*numpy.pi*freq*1j
    output = (1/(tau*s + 1))*input
    return output

m_out_freq1 = numpy.zeros([len(m_out_tr_freq1)], dtype=complex)
m_out_freq2 = numpy.zeros([len(m_out_tr_freq2)], dtype=complex)
m_out_freq3 = numpy.zeros([len(m_out_tr_freq3)], dtype=complex)
m_in_freq1 = numpy.zeros([len(m_in_tr_freq1)], dtype=complex)
m_in_freq2 = numpy.zeros([len(m_in_tr_freq2)], dtype=complex)
m_in_freq3 = numpy.zeros([len(m_in_tr_freq3)], dtype=complex)
for i in range(len(m_out_tr_freq1)):
    m_out_freq1[i] = FILTER_LP(m_out_tr_freq1[i], freq[i], tau[i])
    m_out_freq2[i] = FILTER_LP(m_out_tr_freq2[i], freq[i], tau[i])
    m_out_freq3[i] = FILTER_LP(m_out_tr_freq3[i], freq[i], tau[i])
    m_in_freq1[i] = FILTER_LP(m_in_tr_freq1[i], freq[i], tau[i])
    m_in_freq2[i] = FILTER_LP(m_in_tr_freq2[i], freq[i], tau[i])
    m_in_freq3[i] = FILTER_LP(m_in_tr_freq3[i], freq[i], tau[i])

m_out_time1 = fourier.ifft(m_out_freq1).real # I CAN DO IT---> NEGATIVE PART IS NEGLIGIBLE (about 0) + the signal is real
m_out_time2 = fourier.ifft(m_out_freq2).real
m_out_time3 = fourier.ifft(m_out_freq3).real
m_in_time1 = fourier.ifft(m_in_freq1).real
m_in_time2 = fourier.ifft(m_in_freq2).real
m_in_time3 = fourier.ifft(m_in_freq3).real

print(m_out_time1)
print(data7)
plt.plot(time, m_out_time1,'b',data7[:,6], data7[:,0],'r')
plt.title("M_OUT_1")
plt.show()
plt.plot(time, m_out_time2,'b',data7[:,6], data7[:,1],'r')
plt.title("M_OUT_2")
plt.show()
plt.plot(time, m_out_time3,'b',data7[:,6], data7[:,2],'r')
plt.title("M_OUT_3")
plt.show()
plt.plot(time, m_in_time1,'b',data7[:,6], data7[:,3],'r')
plt.title("M_IN_1")
plt.show()
plt.plot(time, m_in_time2,'b',data7[:,6], data7[:,4],'r')
plt.title("M_IN_2")
plt.show()
plt.plot(time, m_in_time3,'b',data7[:,6], data7[:,5],'r')
plt.title("M_IN_3")
plt.show()

ind = numpy.random.randint(low = 0, high=len(m_out_time1), size=10000)
m_u0 = numpy.zeros((4,10000))
m_k1V0 = numpy.zeros((5,10000))
m_u0 = numpy.array([[numpy.multiply(m_out_time2[ind], 1/m_out_time1[ind])], [numpy.multiply(m_out_time3[ind], 1/m_out_time1[ind])], [numpy.multiply(m_in_time2[ind], 1/m_in_time1[ind])], [numpy.multiply(m_in_time3[ind], 1/m_in_time1[ind])]])
m_k1V0 = numpy.array([[numpy.ones((10000,))], [m_out_time2[ind]], [m_out_time3[ind]], [m_in_time2[ind]], [m_in_time3[ind]]])
w_vec = numpy.array([u0bar[ind], k1bar[ind]])
print(m_u0)
print(m_k1V0)
print(w_vec)
m_u0 = numpy.reshape(m_u0, (4,10000))
m_k1V0 = numpy.reshape(m_k1V0, (5,10000))
print(numpy.shape(m_k1V0))

Tu0 = numpy.dot(u0bar[ind], numpy.linalg.pinv(m_u0))
print(Tu0)
Tk1V0 = numpy.dot(k1bar[ind], numpy.linalg.pinv(m_k1V0))
print(Tk1V0)
m_prova = m_u0
m_prova = numpy.vstack((m_prova, m_k1V0))
m_prova = numpy.reshape(m_prova, (9,10000))
print(m_prova)
T = numpy.zeros([2,9])
T[0,0:4] = Tu0
T[1,4:9] = Tk1V0
print(T)
w_prova = numpy.dot(T, m_prova)
print(numpy.shape(w_prova))
print(w_vec)
print(w_prova[0,:]-u0bar[ind])

CWIND = numpy.multiply(w_prova[0,:], wr[ind])*R
CREAL_ind = u0_int(time)
CREAL = CREAL_ind[ind]
print(numpy.mean(numpy.abs(CWIND-CREAL)))
timep = time[ind]
i1 = numpy.argsort(timep)
plt.plot(timep[i1], CWIND[i1],'b', timep[i1], CREAL[i1], 'r')
plt.title("RESULTS")
plt.show()
print(numpy.shape(CREAL[i1]))

T_tocsv = numpy.hstack((numpy.array([[V0], [V0]]), T))
dataset = pd.DataFrame(data=T_tocsv)
dataset.to_csv('Tmatrices.txt', sep='\t', header=None)

dfa = pd.read_csv('T_DEMOD.txt', sep='\t', header=None)
Tmat1 = dfa.values
Tmat = Tmat1[:,2:]
Vel = Tmat1[::2,1]
print(Tmat)
print(Vel)

T00_int = inter.interp1d(Vel, Tmat[::2,0])
T01_int = inter.interp1d(Vel, Tmat[::2,1])
T02_int = inter.interp1d(Vel, Tmat[::2,2])
T03_int = inter.interp1d(Vel, Tmat[::2,3])
T14_int = inter.interp1d(Vel, Tmat[1::2,4])
T15_int = inter.interp1d(Vel, Tmat[1::2,5])
T16_int = inter.interp1d(Vel, Tmat[1::2,6])
T17_int = inter.interp1d(Vel, Tmat[1::2,7])
T18_int = inter.interp1d(Vel, Tmat[1::2,8])

def Tmat_int(V):
    T00 = T00_int(V)
    T01 = T01_int(V)
    T02 = T02_int(V)
    T03 = T03_int(V)
    T14 = T14_int(V)
    T15 = T15_int(V)
    T16 = T16_int(V)
    T17 = T17_int(V)
    T18 = T18_int(V)
    Tret = numpy.array([[T00, T01, T02, T03, 0, 0, 0, 0, 0], [0, 0, 0, 0, T14, T15, T16, T17, T18]])
    return Tret

V0a = windinfo[:,1] # it's a constant vector, so take only 1 value
yawerr = -windinfo[:,2]*numpy.pi/180
vert_shear = windinfo[:,5]
V0a_int = inter.interp1d(timewind, V0a)
yawerr_int = inter.interp1d(timewind, yawerr)
u0_tot = numpy.multiply(V0a_int(time), numpy.sin(yawerr_int(time)))

exp = numpy.zeros((2,len(m_out_time1)))
for i in range(len(m_out_time1)):
    mmm = numpy.array([m_out_time2[i]/m_out_time1[i], m_out_time3[i]/m_out_time1[i], m_in_time2[i]/m_in_time1[i], m_in_time3[i]/m_in_time1[i], 1, m_out_time2[i], m_out_time3[i], m_in_time2[i], m_in_time3[i]])
    exp[:,i] = numpy.dot(Tmat_int(V0a_int(time[i])), mmm.transpose())

exp1 = numpy.multiply(exp, wr*R)
plt.plot(time, exp1[0,:], 'b', time, u0_tot,'r')
plt.title("CROSS WIND ESTIMATE")
plt.show()

dfdata = pd.read_csv('t3.T3.out', sep='\t', header=None, skiprows=10)
datadata = dfdata.values[0:180000,:]
plt.plot(time, data6[:,0], 'b', time, u0_tot,'r', datadata[:,0], datadata[:,2], 'r--')
plt.title("CROSS WIND ESTIMATE")
plt.show()