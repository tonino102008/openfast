import numpy
import sys
import math
import logic
from scipy.integrate import odeint
import scipy.optimize as optim
import NNEX_DEEP_NETWORK as NNEX
import NNEX_DEEP_NETWORKY as NNEXY
#import NNEX

def DISCON(avrSWAP_py, from_SC_py, to_SC_py):
    
    if logic.counter == 0:
        import globalDISCON
        import OBSERVER
        import yawerrmeas
        logic.counter = logic.counter + 1
    elif logic.counter == 1:
        import globalDISCON1 as globalDISCON
        import OBSERVER1 as OBSERVER
        import yawerrmeas1 as yawerrmeas
        logic.counter = logic.counter + 1
    elif logic.counter == 2:
        import globalDISCON2 as globalDISCON
        import OBSERVER2 as OBSERVER
        import yawerrmeas2 as yawerrmeas
        logic.counter = 0

    #print("SIAMO ENTRATI IN DISCON.py")
    #print("from_SC_py in DISCON.py: ", from_SC_py)
    #print(avrSWAP_py[95], avrSWAP_py[26])

    VS_RtGnSp = 121.6805
    VS_SlPc = 10.00
    VS_Rgn2K = 2.332287
    VS_Rgn2Sp = 91.21091
    VS_CtInSp = 70.16224
    VS_RtPwr = 5296610.0
    CornerFreq = 1.570796 #1.570796
    PC_MaxPit = 1.570796 # ERA 1.570796 rad
    PC_DT = 0.000125
    VS_DT = 0.000125
    OnePlusEps = 1 + sys.float_info.epsilon
    VS_MaxTq = 47402.91
    BlPitch = numpy.zeros(3)
    PitRate = numpy.zeros(3)
    VS_Rgn3MP = 0.01745329 
    PC_KK = 0.1099965 
    PC_KI = 0.008068634
    PC_KP = 0.01882681 
    PC_RefSpd = 122.9096
    VS_MaxRat = 15000.0
    PC_MaxRat = 0.1396263  #0.1396263
    YawSpr = 9.02832e9
    YawDamp = 1.916e7
    YawIn = 2.60789e6
    kdYaw = 1e7
    kpYaw = 5e7
    kiYaw = 1e9
    tauF = (1/3) * ((2 * numpy.pi) / 1.2671)
    Ts = 0.005

    iStatus = int(round(avrSWAP_py[0]))
    NumBl = int(round(avrSWAP_py[60]))

    PC_MinPit = 0.0
    #print("PC_MinPit in DISCON.py: ", PC_MinPit)
    #print("NumBl in DISCON.py: ", NumBl)
    #print("OnePLUSEps ", OnePlusEps)
    BlPitch[0] = min( max( avrSWAP_py[3], PC_MinPit ), PC_MaxPit )
    BlPitch[1] = min( max( avrSWAP_py[32], PC_MinPit ), PC_MaxPit )
    BlPitch[2] = min( max( avrSWAP_py[33], PC_MinPit ), PC_MaxPit )
    GenSpeed = avrSWAP_py[19]
    HorWindV = avrSWAP_py[26]
    Time = avrSWAP_py[1]

    aviFAIL_py = 0

    if iStatus == 0:

        globalDISCON.VS_SySp    = VS_RtGnSp/( 1.0 +  0.01*VS_SlPc )
        globalDISCON.VS_Slope15 = ( VS_Rgn2K*VS_Rgn2Sp*VS_Rgn2Sp )/( VS_Rgn2Sp - VS_CtInSp )
        globalDISCON.VS_Slope25 = ( VS_RtPwr/VS_RtGnSp           )/( VS_RtGnSp - globalDISCON.VS_SySp   )

        if VS_Rgn2K == 0:
            globalDISCON.VS_TrGnSp = globalDISCON.VS_SySp
        else:
            globalDISCON.VS_TrGnSp = ( globalDISCON.VS_Slope25 - math.sqrt(globalDISCON.VS_Slope25*( globalDISCON.VS_Slope25 - 4.0*VS_Rgn2K*globalDISCON.VS_SySp ) ) )/( 2.0*VS_Rgn2K )

        globalDISCON.GenSpeedF  = GenSpeed
        globalDISCON.PitCom     = BlPitch   
        #print("PitCom: ", globalDISCON.PitCom) 
        #print("BlPitch: ", BlPitch)          
        GK         = 1.0/( 1.0 + globalDISCON.PitCom[0]/PC_KK )
        globalDISCON.IntSpdErr  = globalDISCON.PitCom[0]/( GK*PC_KI )

        globalDISCON.LastTime   = Time                          
        globalDISCON.LastTimePC = Time - PC_DT                   
        globalDISCON.LastTimeVS = Time - VS_DT
        print("0")

    if iStatus >= 0 and aviFAIL_py >= 0:

        avrSWAP_py[35] = 0.0 
        avrSWAP_py[40] = 0.0 
        avrSWAP_py[45] = 0.0 
        avrSWAP_py[47] = 0.0 
        avrSWAP_py[64] = 0.0 
        avrSWAP_py[71] = 0.0 
        avrSWAP_py[78] = 0.0 
        avrSWAP_py[79] = 0.0 
        avrSWAP_py[80] = 0.0

        Alpha = math.exp( ( globalDISCON.LastTime - Time )*CornerFreq ) 
        globalDISCON.GenSpeedF = ( 1.0 - Alpha )*GenSpeed + Alpha*globalDISCON.GenSpeedF
        ElapTime = Time - globalDISCON.LastTimeVS
        print("1 ", ElapTime)

        print("globalDISCON.LastTimeVS: ", globalDISCON.LastTimeVS)    
        print("Time*OnePlusEps - globalDISCON.LastTimeVS: ", Time*OnePlusEps - globalDISCON.LastTimeVS)  
        if ( Time*OnePlusEps - globalDISCON.LastTimeVS ) >= VS_DT:

            print("GenSPeedF: ", globalDISCON.GenSpeedF)
            print("PitCom: ", globalDISCON.PitCom[0])  
            if globalDISCON.GenSpeedF >= VS_RtGnSp or  globalDISCON.PitCom[0] >= VS_Rgn3MP:
                GenTrq = VS_RtPwr/globalDISCON.GenSpeedF
                print("A")
                print("GenTrq: ", GenTrq)
            elif globalDISCON.GenSpeedF <= VS_CtInSp:
                GenTrq = 0.0
                print("B")                
            elif globalDISCON.GenSpeedF <  VS_Rgn2Sp:
                GenTrq = globalDISCON.VS_Slope15*( globalDISCON.GenSpeedF - VS_CtInSp )
                print("C")
            elif globalDISCON.GenSpeedF <  globalDISCON.VS_TrGnSp:
                GenTrq = VS_Rgn2K*globalDISCON.GenSpeedF*globalDISCON.GenSpeedF
                print("D")
            else:
                GenTrq = globalDISCON.VS_Slope25*( globalDISCON.GenSpeedF - globalDISCON.VS_SySp   )
                print("E")
            
            GenTrq = min(GenTrq, VS_MaxTq)
            print("2: ", GenTrq)

            if iStatus == 0:
                globalDISCON.LastGenTrq = GenTrq   

            TrqRate = ( GenTrq - globalDISCON.LastGenTrq )/ElapTime               
            TrqRate = min( max( TrqRate, -VS_MaxRat ), VS_MaxRat )  
            GenTrq  = globalDISCON.LastGenTrq + TrqRate*ElapTime  
            globalDISCON.LastTimeVS = Time
            globalDISCON.LastGenTrq = GenTrq
            print("3")
        
        avrSWAP_py[34] = 1.0          
        avrSWAP_py[55] = 0.0        
        avrSWAP_py[46] = globalDISCON.LastGenTrq
        print("Time ", Time)
        ElapTime = Time - globalDISCON.LastTimePC
        print("ELAP Time ", ElapTime)
        print("LASTTIMEPC Time ", globalDISCON.LastTimePC)

        if ( Time*OnePlusEps - globalDISCON.LastTimePC ) >= PC_DT:
            GK = 1.0/( 1.0 + globalDISCON.PitCom[0]/PC_KK )
            SpdErr    = globalDISCON.GenSpeedF - PC_RefSpd                                 
            globalDISCON.IntSpdErr = globalDISCON.IntSpdErr + SpdErr*ElapTime                          
            globalDISCON.IntSpdErr = min( max( globalDISCON.IntSpdErr, PC_MinPit/( GK*PC_KI ) ), PC_MaxPit/( GK*PC_KI ) ) 

            PitComP   = GK*PC_KP*   SpdErr                                  
            PitComI   = GK*PC_KI*globalDISCON.IntSpdErr 

            PitComT   = PitComP + PitComI                                    
            PitComT   = min( max( PitComT, PC_MinPit ), PC_MaxPit )

            for i in range(NumBl):
                PitRate[i] = ( PitComT - BlPitch[i] )/ElapTime                
                PitRate[i] = min( max( PitRate[i], -PC_MaxRat ), PC_MaxRat )   
                globalDISCON.PitCom[i] = BlPitch[i] + PitRate[i]*ElapTime                  

                globalDISCON.PitCom[i]  = min( max( globalDISCON.PitCom[i], PC_MinPit ), PC_MaxPit )
            
            globalDISCON.LastTimePC = Time

        print("4")
        #print("PitCom: ", globalDISCON.PitCom) 

        avrSWAP_py[54] = 0.0       

        avrSWAP_py[41] = globalDISCON.PitCom[0]
        avrSWAP_py[42] = globalDISCON.PitCom[1]
        avrSWAP_py[43] = globalDISCON.PitCom[2]

        avrSWAP_py[44] = globalDISCON.PitCom[0]

        # COMMANDING YAW RATE

        globalDISCON.YawAngleGA = from_SC_py

        #if Time > 70.0:
        if logic.counter < 4:
            if Time > 40.0 and Time < 55.0:
                avrSWAP_py[28] = 1  # --> YAW CONTROL 0 = SPEED CONTROL, 1 = TORQUE CONTROL
                # SETTING POSITION TO BE REACHED AT 0.1 rad --> PI CONTROLLER ( I is INTEGRAL of 0.1rad in time)
                # avrSwap_py[23] --> YawRate Good for PID -- Derivative term
                if not numpy.isclose(abs(avrSWAP_py[36]), 0.174533) and globalDISCON.flagyaw == False:
                #if (not numpy.isclose(avrSWAP_py[36], globalDISCON.PosYawRef)) and (not numpy.isclose(avrSWAP_py[23], 0.0)) and globalDISCON.flag_yaw == False:
                    #globalDISCON.IntYawRef = globalDISCON.IntYawRef + globalDISCON.PosYawRef * ElapTime
                    #globalDISCON.IntYaw = globalDISCON.IntYaw + avrSWAP_py[36] * ElapTime
                    #avrSWAP_py[47] = kpYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kiYaw * (globalDISCON.IntYawRef - globalDISCON.IntYaw)
                    if abs(globalDISCON.PosYawRef) < 0.174533:
                        globalDISCON.VelYawRef = 0.0349066/3
                        globalDISCON.PosYawRef = globalDISCON.PosYawRef + globalDISCON.VelYawRef*ElapTime
                    else:
                        if Time > 54.0:
                            globalDISCON.flagyaw = True
                        globalDISCON.VelYawRef = 0.0
                    avrSWAP_py[47] = kiYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kpYaw * (globalDISCON.VelYawRef - avrSWAP_py[23]) - YawDamp * avrSWAP_py[23]
                else: # HERE I CONSIDER PERTURBATIONS ABOUT THE NEW WORKING POSITION
                    #globalDISCON.flagyaw = True
                    globalDISCON.IntYawRef = globalDISCON.IntYawRef + globalDISCON.PosYawRef * ElapTime
                    globalDISCON.IntYaw = globalDISCON.IntYaw + avrSWAP_py[36] * ElapTime
                    avrSWAP_py[47] = - YawDamp * (avrSWAP_py[23] - 0.0) - YawSpr * (avrSWAP_py[36] - globalDISCON.PosYawRef) + kpYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kiYaw * (globalDISCON.IntYawRef - globalDISCON.IntYaw)
            else:
                avrSWAP_py[28] = 1  # --> YAW CONTROL 0 = SPEED CONTROL, 1 = TORQUE CONTROL
                # SETTING POSITION TO BE REACHED AT 0.1 rad --> PI CONTROLLER ( I is INTEGRAL of 0.1rad in time)
                globalDISCON.IntYawRef = globalDISCON.IntYawRef + globalDISCON.PosYawRef * ElapTime
                globalDISCON.IntYaw = globalDISCON.IntYaw + avrSWAP_py[36] * ElapTime
                avrSWAP_py[47] = - YawDamp * (avrSWAP_py[23] - 0.0) - YawSpr * (avrSWAP_py[36] - globalDISCON.PosYawRef) + kpYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kiYaw * (globalDISCON.IntYawRef - globalDISCON.IntYaw)
                # avrSwap_py[23] --> YawRate Good for PID -- Derivative term
                if globalDISCON.counterY >= 2.0:
                    avrSWAP_py[28] = 1
                    if not numpy.isclose(abs(avrSWAP_py[36]), abs(globalDISCON.PosYawRef - globalDISCON.PosFin)) and globalDISCON.flagyaw == False:
                    #if (not numpy.isclose(avrSWAP_py[36], globalDISCON.PosYawRef)) and (not numpy.isclose(avrSWAP_py[23], 0.0)) and globalDISCON.flag_yaw == False:
                        #globalDISCON.IntYawRef = globalDISCON.IntYawRef + globalDISCON.PosYawRef * ElapTime
                        #globalDISCON.IntYaw = globalDISCON.IntYaw + avrSWAP_py[36] * ElapTime
                        #avrSWAP_py[47] = kpYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kiYaw * (globalDISCON.IntYawRef - globalDISCON.IntYaw)
                        #if numpy.sign(globalDISCON.PosFin - globalDISCON.PosYawRef) == globalDISCON.signold:
                        if abs(globalDISCON.PosYawRef - globalDISCON.PosFin) >  0.004:
                            globalDISCON.VelYawRef = globalDISCON.signold * 0.0349066/3
                            globalDISCON.PosYawRef = globalDISCON.PosYawRef + globalDISCON.VelYawRef*ElapTime
                        else:
                            #if Time > 72.0:
                            globalDISCON.flagyaw = True
                            globalDISCON.VelYawRef = 0.0
                        avrSWAP_py[47] = kiYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kpYaw * (globalDISCON.VelYawRef - avrSWAP_py[23]) - YawDamp * avrSWAP_py[23]
                    else: # HERE I CONSIDER PERTURBATIONS ABOUT THE NEW WORKING POSITION
                        #globalDISCON.flagyaw = True
                        globalDISCON.IntYawRef = globalDISCON.IntYawRef + globalDISCON.PosYawRef * ElapTime
                        globalDISCON.IntYaw = globalDISCON.IntYaw + avrSWAP_py[36] * ElapTime
                        avrSWAP_py[47] = - YawDamp * (avrSWAP_py[23] - 0.0) - YawSpr * (avrSWAP_py[36] - globalDISCON.PosYawRef) + kpYaw * (globalDISCON.PosYawRef - avrSWAP_py[36]) + kiYaw * (globalDISCON.IntYawRef - globalDISCON.IntYaw)
                    #globalDISCON.signold = numpy.sign(globalDISCON.PosFin - globalDISCON.PosYawRef)
                print("TOTAL TORQUE TERM PASSED TO SERVODYN FOR YAW CONTROL ---->     ", avrSWAP_py[47])
            '''if Time > 70.0 and Time < 85.0:
                avrSWAP_py[47] = 0.0349066/3
            else:
                avrSWAP_py[47] = 0.0'''
        else:
            avrSWAP_py[28] = 0
        #else:
        #    avrSWAP_py[28] = 0
        '''avrSWAP_py[28] = 0  # DOPO LEVALO
        avrSWAP_py[47] = 0.0'''
        # END OF COMMANDED YAW RATE ON TURBINE 1
        
        #YAW LOGIC BLOCK

        globalDISCON.LastTime = Time
        print("globalDISCON.LastTime: ", globalDISCON.LastTime)
        
        # INPUTS FOR SUPERCONTROLLER
        to_SC_py = avrSWAP_py[14] # MEASURED POWER OUTPUT
        avrSWAP_py = numpy.append(avrSWAP_py,to_SC_py)
        to_SC_py = avrSWAP_py[36] # ACTUAL YAW ANGLE
        avrSWAP_py = numpy.append(avrSWAP_py,to_SC_py)
        # END OF SECTION

        # WIND SPEED OBSERVER SECTION

        file = open("Bl1outin.txt","a+")
        file.write("%f, %f, %f \n" % (avrSWAP_py[29], avrSWAP_py[68], Time))
        file.close()
        file = open("Bl2outin.txt","a+")
        file.write("%f, %f, %f \n" % (avrSWAP_py[30], avrSWAP_py[69], Time))
        file.close()
        file = open("Bl3outin.txt","a+")
        file.write("%f, %f, %f \n" % (avrSWAP_py[31], avrSWAP_py[70], Time))
        file.close()
        #file = open("Azimuth.txt","a+")
        #file.write("%f, %f, %f, %f \n" % (avrSWAP_py[59], avrSWAP_py[20], avrSWAP_py[26], Time))
        #file.close()

        #if from_SC_py == 0:

        tmp = float(OBSERVER.tmp) #POSG
        acc = float(OBSERVER.acc) #POSR
        OBSERVER.y = avrSWAP_py[19]
        #print("tmp: ", OBSERVER.tmp)
        #print("acc: ", OBSERVER.acc)
        #print("y: ", OBSERVER.y)
        OBSERVER.Qg = avrSWAP_py[22]
        #print("Qg: ", avrSWAP_py[22])
    
        if numpy.isclose(Time, 0.0):
            x0 = numpy.array([1.5, 120, 0, 0])
            xsol = numpy.array([1.5, 120, 0, 0])
            OBSERVER.xsol = xsol
            xppsolin = numpy.array([0, 0, 1.5, 120])
            #print(xsol)
            Qasol = OBSERVER.Qacalc(xppsolin, xsol, float(OBSERVER.y), float(OBSERVER.tmp))

            error = 0.0
            errorposg = 0.0
            errorposr = 0.0
            errorwr = 0.0
            errorwg = 0.0

            pitch_obs = (avrSWAP_py[3]+avrSWAP_py[32]+avrSWAP_py[33])*180/(3*numpy.pi)
            if pitch_obs > 17.9:
                pitch_obs = 17.9
            elif pitch_obs < -10:
                pitch_obs = -10

            num = (2*Qasol)/(numpy.pi*OBSERVER.rho*(xsol[0]**2)*(OBSERVER.R**5))
            tsr_obs = optim.fsolve(OBSERVER.func_impl, 4.5, args=(num, pitch_obs))
            vento_obs = xsol[0]*OBSERVER.R/tsr_obs

            file = open("EXSOL.txt","a+")
            file.write("%f, %f, %f, %f, %f \n" % (xsol[0], xsol[1], xsol[2], xsol[3], Time))
            file.close()

            file = open("Azimuth.txt","a+")
            file.write("%f, %f, %f, %f \n" % (xsol[2], xsol[0], vento_obs, Time))
            file.close()


        else:
            x0 = OBSERVER.xsol

            if numpy.isclose(ElapTime, 0.0):
                ElapTime = 0.005
                #print(OBSERVER.xsolold)
                #input("ELAP TIME = 0.0 PROBLEM")
            
            ts = numpy.linspace(Time - ElapTime, Time, 2)
            xsol = odeint(OBSERVER.dx_dt, x0, ts, args=(float(OBSERVER.y), float(OBSERVER.tmp)))
            #print("SOL SHAPE: ", numpy.shape(xsol))
        
            OBSERVER.xsol = xsol[-1,:]
            OBSERVER.xsolold = numpy.vstack((OBSERVER.xsolold, OBSERVER.xsol))
            xppsolin = numpy.gradient(OBSERVER.xsolold, ElapTime, axis=0)
            #print("SOL: ", xsol)
            #print("XOLD: ", OBSERVER.xsolold)
        
            xppsol = OBSERVER.xpp(xsol[-1,:], float(OBSERVER.y), float(OBSERVER.tmp))
            #print("INERTIA: ", xppsol)
            #print("INERTIA: ", xppsolin[-1,:])
        
            Qasol = OBSERVER.Qacalc(xppsolin[-1,:], xsol[-1,:], float(OBSERVER.y), float(OBSERVER.tmp))

            error = (Qasol - (avrSWAP_py[13]/avrSWAP_py[20]))/(avrSWAP_py[13]/avrSWAP_py[20])
            errorposg = (OBSERVER.tmp-xsol[-1,3])/xsol[-1,3]
            errorposr = (OBSERVER.acc-xsol[-1,2])/xsol[-1,2]
            errorwr = (avrSWAP_py[20]-xsol[-1,0])/avrSWAP_py[20]
            errorwg = (avrSWAP_py[19]-xsol[-1,1])/avrSWAP_py[19]

            pitch_obs = (avrSWAP_py[3]+avrSWAP_py[32]+avrSWAP_py[33])*180/(3*numpy.pi)
            if pitch_obs > 17.9:
                pitch_obs = 17.9
            elif pitch_obs < -10:
                pitch_obs = -10

            num = (2*Qasol)/(numpy.pi*OBSERVER.rho*(xsol[-1,0]**2)*(OBSERVER.R**5))
            tsr_obs = optim.fsolve(OBSERVER.func_impl, 4.5, args=(num, pitch_obs))
            vento_obs = xsol[-1,0]*OBSERVER.R/tsr_obs
            
            file = open("EXSOL.txt","a+")
            file.write("%f, %f, %f, %f, %f \n" % (xsol[-1,0], xsol[-1,1], xsol[-1,2], xsol[-1,3], Time))
            file.close()

            file = open("Azimuth.txt","a+")
            file.write("%f, %f, %f, %f \n" % (xsol[-1,2], xsol[-1,0], vento_obs, Time))
            file.close()

        if vento_obs > 25:
            vento_obs = 25
        elif vento_obs < 3:
            vento_obs = 3
        
        file = open("Error.txt","a+")
        file.write("%f, %f \n" % (error, Time))
        file.close()
        file = open("ErrorPosg.txt","a+")
        file.write("%f, %f \n" % (errorposg, Time))
        file.close()
        file = open("ErrorPosr.txt","a+")
        file.write("%f, %f \n" % (errorposr, Time))
        file.close()
        file = open("ErrorWG.txt","a+")
        file.write("%f, %f \n" % (errorwg, Time))
        file.close()
        file = open("ErrorWR.txt","a+")
        file.write("%f, %f \n" % (errorwr, Time))
        file.close()
        file = open("EWR.txt","a+")
        file.write("%f, %f \n" % (avrSWAP_py[20], Time))
        file.close()
        file = open("EWG.txt","a+")
        file.write("%f, %f \n" % (avrSWAP_py[19], Time))
        file.close()
        file = open("EPOSG.txt","a+")
        file.write("%f, %f \n" % (tmp, Time))
        file.close()
        file = open("EPOSR.txt","a+")
        file.write("%f, %f \n" % (acc, Time))
        file.close()
        file = open("EPitch.txt","a+")
        file.write("%f, %f, %f \n" % ((avrSWAP_py[3]+avrSWAP_py[32]+avrSWAP_py[33])*180/(3*numpy.pi), pitch_obs, Time))
        file.close()
        file = open("EWIND.txt","a+")
        file.write("%f, %f, %f \n" % (vento_obs, Time, HorWindV))
        file.close()
        file = open("EQasol.txt","a+")
        file.write("%f, %f \n" % (Qasol, Time))
        file.close()
        file = open("ENum.txt","a+")
        file.write("%f, %f \n" % (num, Time))
        file.close()

        OBSERVER.tmp = float(avrSWAP_py[19]*ElapTime + tmp)
        OBSERVER.acc = float(avrSWAP_py[20]*ElapTime + acc)


        #print("ERROR: ", error)
        #print("Qa: ", Qasol) 
        #print("Qareal: ", avrSWAP_py[13]/avrSWAP_py[20])
        #print("POWER: ", avrSWAP_py[13])

        #WIND YAW ERROR OBSERVER SECTION

        blmom1 = numpy.array([avrSWAP_py[29], avrSWAP_py[68]])
        blmom2 = numpy.array([avrSWAP_py[30], avrSWAP_py[69]])
        blmom3 = numpy.array([avrSWAP_py[31], avrSWAP_py[70]])
        N = 1

        if numpy.isclose(Time, 0.0):

            azimuth = numpy.array([xsol[2],xsol[2] + 2*numpy.pi/3, xsol[2] + 4*numpy.pi/3])
            wryaw = xsol[0]
            globalDISCON.wr_old = wryaw # (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_out1f_old + Ts*(m_out1 + globalDISCON.m_out1_old))
            globalDISCON.wrf_old = wryaw
            globalDISCON.azimuth_old = azimuth
            globalDISCON.azimuthf_old = azimuth
            m_out1 = 1
            m_out2 = 0
            m_out3 = 0
            m_in1 = 1
            m_in2 = 0
            m_in3 = 0
            yawerrmeas.bl1_old = blmom1
            yawerrmeas.bl2_old = blmom2
            yawerrmeas.bl3_old = blmom3
            yawerrmeas.azimuth_old = azimuth[0]

        else:

            #azimuth = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.azimuthf_old + Ts*(numpy.array([xsol[-1,2], xsol[-1,2] + 2*numpy.pi/3, xsol[-1,2] + 4*numpy.pi/3]) + globalDISCON.azimuth_old))
            #wryaw = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.wrf_old + Ts*(xsol[-1,0] + globalDISCON.wr_old))
            azimuth = numpy.array([xsol[-1,2], xsol[-1,2] + 2*numpy.pi/3, xsol[-1,2] + 4*numpy.pi/3])
            wryaw = xsol[-1,0]
            globalDISCON.wr_old = xsol[-1,0]
            globalDISCON.azimuth_old = numpy.array([xsol[-1,2], xsol[-1,2] + 2*numpy.pi/3, xsol[-1,2] + 4*numpy.pi/3])
            globalDISCON.wrf_old = wryaw
            globalDISCON.azimuthf_old = azimuth
            yawerrmeas.bl1_old = numpy.vstack((yawerrmeas.bl1_old, blmom1))
            yawerrmeas.bl2_old = numpy.vstack((yawerrmeas.bl2_old, blmom2))
            yawerrmeas.bl3_old = numpy.vstack((yawerrmeas.bl3_old, blmom3))
            yawerrmeas.azimuth_old = numpy.hstack((yawerrmeas.azimuth_old, azimuth[0]))

            #if ((azimuth[0] - 2*N*numpy.pi) > yawerrmeas.azimuth_old[0]) and ((azimuth[0] - 2*N*numpy.pi) > yawerrmeas.azimuth_old[1]):
            inddel = numpy.where(yawerrmeas.azimuth_old < azimuth[0] - 2*N*numpy.pi)
            #print("INDDEL: ", inddel[0])
            if inddel[0].size > 1:
                #print(yawerrmeas.azimuth_old.size)
                yawerrmeas.bl1_old = numpy.delete(yawerrmeas.bl1_old, [inddel[0][:-2]], 0)
                yawerrmeas.bl2_old = numpy.delete(yawerrmeas.bl2_old, [inddel[0][:-2]], 0)
                yawerrmeas.bl3_old = numpy.delete(yawerrmeas.bl3_old, [inddel[0][:-2]], 0)
                yawerrmeas.azimuth_old = numpy.delete(yawerrmeas.azimuth_old, [inddel[0][:-2]], None)
                #print(yawerrmeas.azimuth_old.size)
                #print("DELETED OBJECT")

            ind = numpy.where(yawerrmeas.azimuth_old > azimuth[0] - 2*N*numpy.pi)
            #print("IND: ", ind[0])
            a = 0

            if ind[0][0] == 0:
                ind[0][0] = 1
                a = 1

            blmom1into = numpy.interp(azimuth[0] - 2*N*numpy.pi, [yawerrmeas.azimuth_old[ind[0][0]-1], yawerrmeas.azimuth_old[ind[0][0]]], [yawerrmeas.bl1_old[ind[0][0]-1,0], yawerrmeas.bl1_old[ind[0][0],0]])
            blmom1inti = numpy.interp(azimuth[0] - 2*N*numpy.pi, [yawerrmeas.azimuth_old[ind[0][0]-1], yawerrmeas.azimuth_old[ind[0][0]]], [yawerrmeas.bl1_old[ind[0][0]-1,1], yawerrmeas.bl1_old[ind[0][0],1]])
            blmom2into = numpy.interp(azimuth[0] - 2*N*numpy.pi + 2*numpy.pi/3, [yawerrmeas.azimuth_old[ind[0][0]-1] + 2*numpy.pi/3, yawerrmeas.azimuth_old[ind[0][0]] + 2*numpy.pi/3], [yawerrmeas.bl2_old[ind[0][0]-1,0], yawerrmeas.bl2_old[ind[0][0],0]])
            blmom2inti = numpy.interp(azimuth[0] - 2*N*numpy.pi + 2*numpy.pi/3, [yawerrmeas.azimuth_old[ind[0][0]-1] + 2*numpy.pi/3, yawerrmeas.azimuth_old[ind[0][0]] + 2*numpy.pi/3], [yawerrmeas.bl2_old[ind[0][0]-1,1], yawerrmeas.bl2_old[ind[0][0],1]])
            blmom3into = numpy.interp(azimuth[0] - 2*N*numpy.pi + 4*numpy.pi/3, [yawerrmeas.azimuth_old[ind[0][0]-1] + 4*numpy.pi/3, yawerrmeas.azimuth_old[ind[0][0]] + 4*numpy.pi/3], [yawerrmeas.bl3_old[ind[0][0]-1,0], yawerrmeas.bl3_old[ind[0][0],0]])
            blmom3inti = numpy.interp(azimuth[0] - 2*N*numpy.pi + 4*numpy.pi/3, [yawerrmeas.azimuth_old[ind[0][0]-1] + 4*numpy.pi/3, yawerrmeas.azimuth_old[ind[0][0]] + 4*numpy.pi/3], [yawerrmeas.bl3_old[ind[0][0]-1,1], yawerrmeas.bl3_old[ind[0][0],1]])
            
            if a == 1:
                ind[0][0] = 0

            mo10= numpy.trapz(numpy.hstack((blmom1into, yawerrmeas.bl1_old[ind[0],0])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(2*N*numpy.pi)
            mo1c= numpy.trapz(numpy.multiply(numpy.hstack((blmom1into, yawerrmeas.bl1_old[ind[0],0])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(N*numpy.pi)
            mo1s= numpy.trapz(numpy.multiply(numpy.hstack((blmom1into, yawerrmeas.bl1_old[ind[0],0])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(N*numpy.pi)
            mi10= numpy.trapz(numpy.hstack((blmom1inti, yawerrmeas.bl1_old[ind[0],1])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(2*N*numpy.pi)
            mi1c= numpy.trapz(numpy.multiply(numpy.hstack((blmom1inti, yawerrmeas.bl1_old[ind[0],1])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(N*numpy.pi)
            mi1s= numpy.trapz(numpy.multiply(numpy.hstack((blmom1inti, yawerrmeas.bl1_old[ind[0],1])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])))/(N*numpy.pi)
            mo20= numpy.trapz(numpy.hstack((blmom2into, yawerrmeas.bl2_old[ind[0],0])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(2*N*numpy.pi)
            mo2c= numpy.trapz(numpy.multiply(numpy.hstack((blmom2into, yawerrmeas.bl2_old[ind[0],0])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(N*numpy.pi)
            mo2s= numpy.trapz(numpy.multiply(numpy.hstack((blmom2into, yawerrmeas.bl2_old[ind[0],0])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(N*numpy.pi)
            mi20= numpy.trapz(numpy.hstack((blmom2inti, yawerrmeas.bl2_old[ind[0],1])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(2*N*numpy.pi)
            mi2c= numpy.trapz(numpy.multiply(numpy.hstack((blmom2inti, yawerrmeas.bl2_old[ind[0],1])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(N*numpy.pi)
            mi2s= numpy.trapz(numpy.multiply(numpy.hstack((blmom2inti, yawerrmeas.bl2_old[ind[0],1])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 2*numpy.pi/3)/(N*numpy.pi)
            mo30= numpy.trapz(numpy.hstack((blmom3into, yawerrmeas.bl3_old[ind[0],0])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(2*N*numpy.pi)
            mo3c= numpy.trapz(numpy.multiply(numpy.hstack((blmom3into, yawerrmeas.bl3_old[ind[0],0])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(N*numpy.pi)
            mo3s= numpy.trapz(numpy.multiply(numpy.hstack((blmom3into, yawerrmeas.bl3_old[ind[0],0])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(N*numpy.pi)
            mi30= numpy.trapz(numpy.hstack((blmom3inti, yawerrmeas.bl3_old[ind[0],1])), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(2*N*numpy.pi)
            mi3c= numpy.trapz(numpy.multiply(numpy.hstack((blmom3inti, yawerrmeas.bl3_old[ind[0],1])), numpy.cos(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(N*numpy.pi)
            mi3s= numpy.trapz(numpy.multiply(numpy.hstack((blmom3inti, yawerrmeas.bl3_old[ind[0],1])), numpy.sin(numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)), x=numpy.hstack((azimuth[0] - 2*N*numpy.pi, yawerrmeas.azimuth_old[ind[0]])) + 4*numpy.pi/3)/(N*numpy.pi)
            m_out1 = (mo10 + mo20 + mo30)/3
            m_out2 = (mo1c + mo2c + mo3c)/3
            m_out3 = (mo1s + mo2s + mo3s)/3
            m_in1 = (mi10 + mi20 + mi30)/3
            m_in2 = (mi1c + mi2c + mi3c)/3
            m_in3 = (mi1s + mi2s + mi3s)/3

        m_out1f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_out1f_old + Ts*(m_out1 + globalDISCON.m_out1_old))
        m_out2f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_out2f_old + Ts*(m_out2 + globalDISCON.m_out2_old))
        m_out3f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_out3f_old + Ts*(m_out3 + globalDISCON.m_out3_old))
        m_in1f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_in1f_old + Ts*(m_in1 + globalDISCON.m_in1_old))
        m_in2f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_in2f_old + Ts*(m_in2 + globalDISCON.m_in2_old))
        m_in3f = (1/(2*tauF + Ts)) * ((2*tauF - Ts)*globalDISCON.m_in3f_old + Ts*(m_in3 + globalDISCON.m_in3_old))

        globalDISCON.m_out1f_old = m_out1f
        globalDISCON.m_out1_old = m_out1
        globalDISCON.m_out2f_old = m_out2f
        globalDISCON.m_out2_old = m_out2
        globalDISCON.m_out3f_old = m_out3f
        globalDISCON.m_out3_old = m_out3
        globalDISCON.m_in1f_old = m_in1f
        globalDISCON.m_in1_old = m_in1
        globalDISCON.m_in2f_old = m_in2f
        globalDISCON.m_in2_old = m_in2
        globalDISCON.m_in3f_old = m_in3f
        globalDISCON.m_in3_old = m_in3

        #m_yaw_u0 = numpy.array([m_out2/m_out1, m_out3/m_out1, m_in2/m_in1, m_in3/m_in1])
        m_yaw_u0 = numpy.array([m_out2f/m_out1f, m_out3f/m_out1f, m_in2f/m_in1f, m_in3f/m_in1f])
        m_yaw_k1 = numpy.array([1, m_out2, m_out3, m_in2, m_in3])
        m_yaw = numpy.hstack((m_yaw_u0, m_yaw_k1))

        Tmat = yawerrmeas.Tmat_int(vento_obs)
        #Tmat = yawerrmeas.Tmat_int(HorWindV)

        ris_yaw = numpy.dot(Tmat, m_yaw.transpose())
        crosswind_NF = wryaw*yawerrmeas.R*ris_yaw[0] # VERSION WITHOUT YAW ANGLE
        #angyaw = numpy.arcsin(crosswind/vento_obs)
        #crosswind = vento_obs * math.sin(angyaw + avrSWAP_py[36])
        vertshear = wryaw*yawerrmeas.R*ris_yaw[1]/vento_obs
        #vertshear = wryaw*yawerrmeas.R*ris_yaw[1]/HorWindV

        # FILTERING THE SIGNAL OF CROSS WIND WITH BUTTERWORTH 2nd ORDER FILTER
        #crosswind = (NNEXY.n1 * (globalDISCON.old_cw + globalDISCON.old2_cw + crosswind_NF) - NNEXY.n2 * globalDISCON.oldf_cw - NNEXY.n3 * globalDISCON.old2f_cw) / NNEXY.d1
        crosswind = crosswind_NF
        if numpy.isclose(Time % 17.5, 0.0):
            globalDISCON.angyaw_old = globalDISCON.angyaw
            globalDISCON.angyaw = numpy.arctan(crosswind/vento_obs)
            if abs(globalDISCON.angyaw - globalDISCON.angyaw_old) < 0.035 and abs(globalDISCON.angyaw) > 0.07:
                globalDISCON.counterY = globalDISCON.counterY + 1.0
                if globalDISCON.counterY >= 2.0:
                    globalDISCON.PosFin = globalDISCON.PosYawRef + globalDISCON.angyaw
                    #globalDISCON.VelYawRef = numpy.sign(globalDISCON.angyaw)*0.0349066/3
                    globalDISCON.flagyaw = False
                    #globalDISCON.signold = numpy.sign(globalDISCON.PosFin - globalDISCON.PosYawRef)
                    globalDISCON.signold = numpy.sign(globalDISCON.angyaw)
            else:
                globalDISCON.counterY = 0.0
            
            file = open("EVALUE.txt","a+")
            file.write("%f, %f, %f, %f, %f, %f, %f \n" % (globalDISCON.flagyaw, globalDISCON.PosFin, globalDISCON.VelYawRef, globalDISCON.counterY, globalDISCON.angyaw, globalDISCON.angyaw_old, Time))
            file.close()
        #globalDISCON.oldf_cw = crosswind
        #globalDISCON.old2f_cw = globalDISCON.oldf_cw
        #globalDISCON.old_cw = crosswind_NF
        #globalDISCON.old2_cw = globalDISCON.old_cw
        #globalDISCON.old_cw = crosswind

        # YAW ERROR ESTIMATION WITH TRAINED FORWARD NEURAL NETWORK
        flagind = 0
        if logic.counter == 1:
            toNN_in = numpy.hstack((m_yaw_u0, vento_obs))
            #toNN = numpy.hstack((toNN, 0.0349066/3))
            toNN = numpy.multiply(toNN_in, 1/NNEX.normC.T)
            toNNY = numpy.multiply(toNN_in, 1/NNEXY.normC.T)
            if toNN.any() > 1:
                ii = numpy.where(toNN >= 1)
                toNN[ii] = 1
                flagind = 1
            if toNNY.any() > 1:
                ii = numpy.where(toNNY >= 1)
                toNNY[ii] = 1
                flagind = 1
            if abs(avrSWAP_py[36]) > 0.02:
                crosswindNN_NF = NNEXY.NN.forward(toNNY) * vento_obs * NNEXY.normY
            else:
                crosswindNN_NF = NNEX.NN.forward(toNN) * vento_obs * NNEX.normY # VERSION WITHOUT YAW ANGLE
            #crosswindNN = (NNEXY.n1 * (NNEXY.old_cw + NNEXY.old2_cw + crosswindNN_NF) - NNEXY.n2 * NNEXY.oldf_cw - NNEXY.n3 * NNEXY.old2f_cw) / NNEXY.d1
            crosswindNN = crosswindNN_NF
            #NNEXY.oldf_cw = crosswindNN
            #NNEXY.old2f_cw = NNEXY.oldf_cw
            #NNEXY.old_cw = crosswindNN_NF
            #NNEXY.old2_cw = NNEXY.old_cw
            globalDISCON.angyawNN = numpy.arctan(crosswindNN/vento_obs)
        else:
            crosswindNN = 0.0

        file = open("ECROSS.txt","a+")
        file.write("%f, %f, %f, %f, %f \n" % (crosswind, crosswindNN, flagind, vertshear, Time))
        file.close()

        file = open("EAzimuth.txt","a+")
        file.write("%f, %f, %f, %f \n" % (azimuth[0], azimuth[1], azimuth[2], Time))
        file.close()

        file = open("EMOM.txt","a+")
        file.write("%f, %f, %f, %f, %f, %f, %f \n" % (m_out1, m_out2, m_out3, m_in1, m_in2, m_in3, Time))
        file.close()

    return avrSWAP_py

