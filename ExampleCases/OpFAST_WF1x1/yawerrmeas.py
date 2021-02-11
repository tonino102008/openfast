import numpy
import sys
import math
import numpy.fft as fourier
import scipy.interpolate as inter
import pandas as pd

R = 63

df = pd.read_csv('T.txt', sep='\t', header=None)
Tmat1 = df.values
Tmat = Tmat1[:,2:]
Vel = Tmat1[::2,1]
print(Tmat)
print(Vel)

dtFAST = 0.005
tau_nn = 1/1.5
tau_mis = 3
wryaw = numpy.zeros((2,))
wryaw_f = numpy.zeros((2,))
blmom1_tr = numpy.zeros((2,2))
blmom2_tr = numpy.zeros((2,2))
blmom3_tr = numpy.zeros((2,2))
m_out1 = numpy.zeros((2,))
m_in1 = numpy.zeros((2,))
m_out2 = numpy.zeros((2,))
m_in2 = numpy.zeros((2,))
m_out3 = numpy.zeros((2,))
m_in3 = numpy.zeros((2,))

def ColTransf(ang1, ang2, ang3): #COLEMAN MBC TRANSFORMATION
    out = numpy.array([[1, 1, 1], [2*math.cos(ang1), 2*math.cos(ang2), 2*math.cos(ang3)], [2*math.sin(ang1), 2*math.sin(ang2), 2*math.sin(ang3)]])/3
    return out

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