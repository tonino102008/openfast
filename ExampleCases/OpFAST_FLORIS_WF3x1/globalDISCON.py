import numpy

GenSpeedF = 0
IntSpdErr = 0                                    
LastGenTrq = 0                                    
LastTime = 0                                        
LastTimePC = 0                                    
LastTimeVS = 0 
PitCom = numpy.zeros(3)
VS_Slope15 = 0                                     
VS_Slope25 = 0                                      
VS_SySp = 0                                 
VS_TrGnSp = 0
PosYawRef = 15.0 * numpy.pi/180.0 #0.1
VelYawRef = 0.0349066/2
IntYawRef = 0.0
IntYaw = 0.0
flagyaw = False
yaw = numpy.array([0.0, 0.0, 0.0])
m_out1f_old = 0.0
m_out1_old = 0.0
m_out2f_old = 0.0
m_out2_old = 0.0
m_out3f_old = 0.0
m_out3_old = 0.0
m_in1f_old = 0.0
m_in1_old = 0.0
m_in2f_old = 0.0
m_in2_old = 0.0
m_in3f_old = 0.0
m_in3_old = 0.0
wr_old = 0.0
wrf_old = 0.0
azimuth_old = numpy.array([0.0, 0.0, 0.0])
azimuthf_old = numpy.array([0.0, 0.0, 0.0])
angyawNN = 0.0
angyaw = 0.0
counterY = 0.0
PosFin = 0.0
angyaw_old = 0.0
old_cw = 0.0
old2_cw = 0.0
oldf_cw = 0.0
old2f_cw = 0.0
signold = 0
YawAngleGA = 0.0
YawAngleGAold = 0.0
YawAngleGAprev = 0.0