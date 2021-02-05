import numpy
import sys
import math

#def DISCON(avrSWAP_py, from_SC_py, to_SC_py, aviFAIL_py, accINFILE_py, avcOUTNAME_py, avcMSG_py):

def DISCON(avrSWAP_py, from_SC_py, to_SC_py):
    
    print("SIAMO ENTRATI IN DISCON.py")
    print("from_SC_py in DISCON.py: ", from_SC_py)

    VS_RtGnSp = 121.6805
    VS_SlPc = 10.00
    VS_Rgn2K = 2.332287
    VS_Rgn2Sp = 91.21091
    VS_CtInSp = 70.16224
    VS_RtPwr = 5296610.0
    CornerFreq = 1.570796
    PC_MaxPit = 1.570796
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
    PC_MaxRat = 0.1396263

    iStatus = int(round(avrSWAP_py[0]))
    NumBl = int(round(avrSWAP_py[60]))

    PC_MinPit = from_SC_py
    BlPitch[0] = min( max( avrSWAP_py[31], PC_MinPit ), PC_MaxPit )
    BlPitch[1] = min( max( avrSWAP_py[32], PC_MinPit ), PC_MaxPit )
    BlPitch[2] = min( max( avrSWAP_py[33], PC_MinPit ), PC_MaxPit )
    GenSpeed = avrSWAP_py[19]
    HorWindV = avrSWAP_py[26]
    Time = avrSWAP_py[2]

    aviFAIL_py = 0

    if iStatus == 0:

        VS_SySp    = VS_RtGnSp/( 1.0 +  0.01*VS_SlPc )
        VS_Slope15 = ( VS_Rgn2K*VS_Rgn2Sp*VS_Rgn2Sp )/( VS_Rgn2Sp - VS_CtInSp )
        VS_Slope25 = ( VS_RtPwr/VS_RtGnSp           )/( VS_RtGnSp - VS_SySp   )

        if VS_Rgn2K == 0:
            VS_TrGnSp = VS_SySp
        else:
            VS_TrGnSp = ( VS_Slope25 - math.sqrt(VS_Slope25*( VS_Slope25 - 4.0*VS_Rgn2K*VS_SySp ) ) )/( 2.0*VS_Rgn2K )

        GenSpeedF  = GenSpeed
        PitCom     = BlPitch            
        GK         = 1.0/( 1.0 + PitCom[1]/PC_KK )
        IntSpdErr  = PitCom[1]/( GK*PC_KI )

        LastTime   = Time                          
        LastTimePC = Time - PC_DT                   
        LastTimeVS = Time - VS_DT

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

        Alpha = math.exp( ( LastTime - Time )*CornerFreq ) 
        GenSpeedF = ( 1.0 - Alpha )*GenSpeed + Alpha*GenSpeedF
        ElapTime = Time - LastTimeVS

        if ( Time*OnePlusEps - LastTimeVS ) >= VS_DT:

            if GenSpeedF >= VS_RtGnSp or  PitCom[1] >= VS_Rgn3MP:
                GenTrq = VS_RtPwr/GenSpeedF
            elif GenSpeedF <= VS_CtInSp:
                GenTrq = 0.0
            elif GenSpeedF <  VS_Rgn2Sp:
                GenTrq = VS_Slope15*( GenSpeedF - VS_CtInSp )
            elif GenSpeedF <  VS_TrGnSp:
                GenTrq = VS_Rgn2K*GenSpeedF*GenSpeedF
            else:
                GenTrq = VS_Slope25*( GenSpeedF - VS_SySp   )
            
        GenTrq = min(GenTrq, VS_MaxTq)

        if iStatus == 0:
            LastGenTrq = GenTrq                 
            TrqRate = ( GenTrq - LastGenTrq )/ElapTime               
            TrqRate = min( max( TrqRate, -VS_MaxRat ), VS_MaxRat )  
            GenTrq  = LastGenTrq + TrqRate*ElapTime  
            LastTimeVS = Time
            LastGenTrq = GenTrq
        
        avrSWAP_py[34] = 1.0          
        avrSWAP_py[55] = 0.0        
        avrSWAP_py[46] = LastGenTrq

        ElapTime = Time - LastTimePC

        if ( Time*OnePlusEps - LastTimePC ) >= PC_DT:
            GK = 1.0/( 1.0 + PitCom[1]/PC_KK )
            SpdErr    = GenSpeedF - PC_RefSpd                                 
            IntSpdErr = IntSpdErr + SpdErr*ElapTime                          
            IntSpdErr = min( max( IntSpdErr, PC_MinPit/( GK*PC_KI ) ), PC_MaxPit/( GK*PC_KI ) ) 

            PitComP   = GK*PC_KP*   SpdErr                                  
            PitComI   = GK*PC_KI*IntSpdErr 

            PitComT   = PitComP + PitComI                                    
            PitComT   = min( max( PitComT, PC_MinPit ), PC_MaxPit )

            for i in range(NumBl):
                PitRate[i] = ( PitComT - BlPitch[i] )/ElapTime                
                PitRate[i] = min( max( PitRate[i], -PC_MaxRat ), PC_MaxRat )   
                PitCom [i] = BlPitch[i] + PitRate[i]*ElapTime                  

                PitCom [i]  = min( max( PitCom[i], PC_MinPit ), PC_MaxPit )
            
            LastTimePC = Time

        avrSWAP_py[54] = 0.0       

        avrSWAP_py[41] = PitCom[0]
        avrSWAP_py[42] = PitCom[1]
        avrSWAP_py[43] = PitCom[2]

        avrSWAP_py[44] = PitCom[0]

        to_SC_py = GenTrq

        print("avrSWAP_py in DISCON.py: ", avrSWAP_py)

        return avrSWAP_py

#        return avrSWAP_py, to_SC_py

