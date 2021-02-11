import matplotlib.pyplot as plt
import numpy
import pandas as pd
import control.matlab as cnt
import scipy.interpolate as inter


df = pd.read_csv('cp3.txt', sep='\t', header=None)
data = df.values
tsr = data[2:,1]
print(numpy.shape(tsr))
pitch = data[1,2:]
#pitch = pitch.reshape((1,13))
print(numpy.shape(pitch))
cp = data[2:,2:]
print(numpy.shape(cp))

tsr_new = numpy.array([0])
cp_new = numpy.zeros([1, 13])
print(numpy.shape(cp_new))
print(cp_new)


for i in range(len(tsr)-1):
    if i == 0:
        if tsr[i] != tsr[i+1]:
            tsr_new = tsr[0]
            cp_new = cp[0,:]
    else:
        if tsr[i] != tsr[i+1]:
            tsr_new = numpy.vstack((tsr_new,tsr[i]))
            cp_new = numpy.vstack((cp_new, cp[i,:]))
tsr_new = numpy.vstack((tsr_new,tsr[-1]))
tsr_new = tsr_new.reshape((204,))
cp_new = numpy.vstack((cp_new, cp[-1,:]))
print(tsr_new)
print(pitch)
print(numpy.shape(cp_new))
print(cp_new)

fun = inter.RectBivariateSpline(tsr_new, pitch, cp_new)

def cp_int(TSR_int, pitch_int):
    if TSR_int < tsr[0]:
        if pitch_int < pitch[0]:
            cp_ret = fun(tsr[0], pitch[0])
        elif pitch_int > pitch[-1]:
            cp_ret = fun(tsr[0], pitch[-1])
        else:
            cp_ret = fun(tsr[0], pitch_int)
    elif TSR_int > tsr[-1]:
        if pitch_int < pitch[0]:
            cp_ret = fun(tsr[-1], pitch[0])
        elif pitch_int > pitch[-1]:
            cp_ret = fun(tsr[-1], pitch[-1])
        else:
            cp_ret = fun(tsr[-1], pitch_int)
    else:
        if pitch_int < pitch[0]:
            cp_ret = fun(TSR_int, pitch[0])
        elif pitch_int > pitch[-1]:
            cp_ret = fun(TSR_int, pitch[-1])
        else:
            cp_ret = fun(TSR_int, pitch_int)
    return cp_ret