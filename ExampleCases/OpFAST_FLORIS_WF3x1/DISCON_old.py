import numpy
import sys
import math
import globalDISCON
import OBSERVER
from scipy.integrate import odeint

def DISCON(avrSWAP_py, from_SC_py, to_SC_py):
    
    print("SIAMO ENTRATI IN DISCON.py")
    print("from_SC_py in DISCON.py: ", from_SC_py)

    VS_RtGnSp = 121.6805
    VS_SlPc = 10.00
    VS_Rgn2K = 2.332287
    VS_Rgn2Sp = 91.21091
    VS_CtInSp = 70.16224
    VS_RtPwr = 5296610.0
    CornerFreq = 1.570796 #1.570796
    PC_MaxPit = 0.1875 # ERA 1.570796 rad
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

    iStatus = int(round(avrSWAP_py[0]))
    NumBl = int(round(avrSWAP_py[60]))

    PC_MinPit = from_SC_py
    print("PC_MinPit in DISCON.py: ", PC_MinPit)
    print("NumBl in DISCON.py: ", NumBl)
    print("OnePLUSEps ", OnePlusEps)
    BlPitch[0] = min(PC_MinPit, PC_MaxPit )
    BlPitch[1] = min(PC_MinPit, PC_MaxPit )
    BlPitch[2] = min(PC_MinPit, PC_MaxPit )
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
        print("PitCom: ", globalDISCON.PitCom) 
        print("BlPitch: ", BlPitch)          
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
        print("PitCom: ", globalDISCON.PitCom) 

        avrSWAP_py[54] = 0.0       

        '''avrSWAP_py[41] = globalDISCON.PitCom[0]
        avrSWAP_py[42] = globalDISCON.PitCom[1]
        avrSWAP_py[43] = globalDISCON.PitCom[2]

        avrSWAP_py[44] = globalDISCON.PitCom[0]'''
        avrSWAP_py[3] = BlPitch[0]
        avrSWAP_py[32] = BlPitch[1]
        avrSWAP_py[33] = BlPitch[2]
        avrSWAP_py[41] = BlPitch[0]
        avrSWAP_py[42] = BlPitch[1]
        avrSWAP_py[43] = BlPitch[2]

        avrSWAP_py[44] = BlPitch[0]
        
        if 'GenTrq' in locals():
            to_SC_py = GenTrq
        else:
            to_SC_py = globalDISCON.LastGenTrq

        globalDISCON.LastTime = Time
        print("globalDISCON.LastTime: ", globalDISCON.LastTime)
       
        avrSWAP_py = numpy.append(avrSWAP_py,to_SC_py)

        print("to_SC_py in DISCON.py: ", to_SC_py)

        # OBSERVER SECTION

        if 1:
            tmp = float(OBSERVER.tmp) #POSG
            acc = float(OBSERVER.acc) #POSR
            OBSERVER.y = avrSWAP_py[19]
            print("tmp: ", OBSERVER.tmp)
            print("acc: ", OBSERVER.acc)
            print("y: ", OBSERVER.y)
            OBSERVER.Qg = avrSWAP_py[22]
            print("Qg: ", avrSWAP_py[22])
        
            if Time >= 0.0:
                if Time == 0.0:
                    x0 = numpy.array([1, 90, 0, 0])
                else:
                    x0 = OBSERVER.xsol
            
                ts = numpy.linspace(Time, Time + 0.005, 10)
                xsol = odeint(OBSERVER.dx_dt, x0, ts, args=(float(OBSERVER.y), float(OBSERVER.tmp)))
                print("SOL SHAPE: ", numpy.shape(xsol))
            
                OBSERVER.xsol = xsol[9,:]
                OBSERVER.xsolold = numpy.vstack((OBSERVER.xsolold, OBSERVER.xsol))
                xppsolin = numpy.gradient(OBSERVER.xsolold, 0.005, axis=0)
                print("SOL: ", xsol)
                print("XOLD: ", OBSERVER.xsolold)
            
                OBSERVER.tmp = float(avrSWAP_py[19]*0.005 + tmp)
                OBSERVER.acc = float(avrSWAP_py[20]*0.005 + acc)
            
                xppsol = OBSERVER.xpp(xsol[9,:], float(OBSERVER.y), float(OBSERVER.tmp))
                print("INERTIA: ", xppsol)
                print("INERTIA: ", xppsolin[-1,:])
            
                Qasol = OBSERVER.Qacalc(xppsolin[-1,:], xsol[9,:], float(OBSERVER.y), float(OBSERVER.tmp))
                error = (Qasol - (avrSWAP_py[13]/avrSWAP_py[20]))/(avrSWAP_py[13]/avrSWAP_py[20])
                errorposg = (OBSERVER.tmp-xsol[9,3])/xsol[9,3]
                errorposr = (OBSERVER.acc-xsol[9,2])/xsol[9,2]
                errorwr = (avrSWAP_py[20]-xsol[9,0])/avrSWAP_py[20]
                errorwg = (avrSWAP_py[19]-xsol[9,1])/avrSWAP_py[19]
            
            
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
                file = open("EXSOL.txt","a+")
                file.write("%f, %f, %f, %f, %f \n" % (xsol[9,0], xsol[9,1], xsol[9,2], xsol[9,3], Time))
                file.close()
                file = open("EPOSG.txt","a+")
                file.write("%f, %f \n" % (tmp, Time))
                file.close()
                file = open("EPOSR.txt","a+")
                file.write("%f, %f \n" % (acc, Time))
                file.close()
                file = open("EACC.txt","a+")
                file.write("%f, %f, %f, %f, %f \n" % (xppsolin[-1,0], xppsolin[-1,1], xppsolin[-1,2], xppsolin[-1,3], Time))
                file.close()
                file = open("EPitch.txt","a+")
                file.write("%f, %f \n" % ((avrSWAP_py[3]+avrSWAP_py[32]+avrSWAP_py[33])*180/(3*numpy.pi), Time))
                file.close()
        
        
                print("ERROR: ", error)
                print("Qa: ", Qasol) 
                print("Qareal: ", avrSWAP_py[13]/avrSWAP_py[20])
                print("POWER: ", avrSWAP_py[13])

    return avrSWAP_py

