import numpy
import math
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

Q = numpy.dot(numpy.identity(4), 1e3)
print("Q: ", Q)
Rinv = 1e-3
print("Rinv: ", Rinv)
Pcare_t = numpy.array([[4.14959125e+03,1.61477164e+00,-3.86272817e+01,-9.60596877e+02],[1.61477164e+00,5.82165903e+00,9.60596396e-01,-9.99000500e-01],[-3.86272817e+01,9.60596396e-01,7.29902649e-01,1.15725425e+01],[-9.60596877e+02,-9.99000500e-01,1.15725425e+01,4.88818053e+02]])
Gcare_t = numpy.array([[1614.77164018],[5821.65902995],[960.59639633],[-999.00050001]]).transpose()
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
