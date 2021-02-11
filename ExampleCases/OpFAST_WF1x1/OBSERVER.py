import numpy
import math
import control.matlab as cnt
from scipy.integrate import odeint
import cp
import scipy.interpolate as inter

Jr = 115926
Jg = 534.116
kt = 8.67637e8
rt = 6.215e6
tau = 97
kp = 8e3
ki = 1e6
R = 63
rho = 1.225
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

Qg = 0
tmp = 0
y = 0
acc = 0
xsol = numpy.array([1.5, 120, 0, 0])
xsolold = numpy.array([1.5, 120, 0, 0])

def dx_dt(x, t, yobs, yint):
    x = x.reshape((4,1))
    fun = numpy.dot(A,x) + numpy.dot(BQg,Qg) + numpy.dot(BQa1,yobs) + numpy.dot(BQa2,yint) + numpy.dot(Gcare,yobs) - numpy.dot(numpy.dot(Gcare,Ctot),x)
    fun = fun.reshape((4,))
    return fun

def xpp(x, yobs, yint):
    x = x.reshape((4,1))
    fun = numpy.dot(A,x) + numpy.dot(BQg,Qg) + numpy.dot(BQa1,yobs) + numpy.dot(BQa2,yint) + numpy.dot(Gcare,yobs) - numpy.dot(numpy.dot(Gcare,Ctot),x)
    fun = fun.reshape((4,))
    return fun


def Qacalc(xp, x, yobs, tmp):
    x = x.reshape((4,1))
    fun = kp*(yobs-x[1]) + ki*(tmp-x[3])
    return fun

def func_impl(x, num, pitch):
    return float(cp.cp_int(x, pitch))/(x**3)-num
