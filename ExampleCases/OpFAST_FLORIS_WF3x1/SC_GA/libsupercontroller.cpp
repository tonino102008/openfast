#include "SC.h"
#include <vector>
#include <iostream>
#include <fstream>
#include <cmath>
#include <algorithm>
#include "genAlg.h"

using namespace std;

vector<double> GenPwrMeas; // WATT
vector<double> YawAngMeas;
vector<double> CounterY;
vector<double> YawMis;
vector<double> Bias;
vector<vector<double> > YawTot (Trial * Ngen);
vector<double> GenTot;
bool ActivateGen;
double timeActivateGen;
bool StopC;

vector<vector<double> > BestYaw; // BEST SET OF YAW ANGLES FOR THE SUB-SIMULATIONS
vector<double> BestPower;  // BEST POWER OBTAINED FROM SUB-SIMULATIONS
vector<double> YawAng;

//int Trial = 4; // DEFINING SOME PARAMETERS FOR GA --> TRIALS PER GENERATION
//int NparMat = 2; // NUMBER OF MATING PARENTS
//int Ngen = 4; // NUMBER OF GENERATIONS
//int ActualGen = 1; // ACTUAL GENERATION
//int ActualTrial = 0; // ACTUAL TRIAL
//double TimePerTrial = 50.0;
//int CrossPoint = 1;
//int MutPoint = 0;
//int YawStep = 7.5; // IN DEGREES

//vector<double> FitnessVec (Trial); // THESE VECTORS HOLD VALUES FOR ONLY ONE GENERATION
//vector<double> FitnessVecCopy (Trial); 
//vector<vector<double> > GenPwr (Trial);
//vector<vector<double> > YawAngle (Trial);
//vector<vector<double> > Parents;
//vector<vector<double> > OffSprCross;
//vector<vector<double> > OffSprMut;
//vector<vector<double> > NewPop (Trial);

int * globStatesglob;

extern "C" SuperController* create_sc()
{
   cout << "SC RUNNING\n";
  return new SuperController;
}

extern "C" void destroy_sc(SuperController* sc)
{
   cout << "SC RUNNING\n";
  delete sc;
}

SuperController::SuperController()
{
   int nTurbines;
   int nScInputs;
   int nScOutputs;
   double dtF;
   nGlobStates = 0;
   globStates = 0;
   nTurbineStates = 0;
   turbineStates = 0;
   d2R = 0.01745329251;
   cout << "SC RUNNING_START\n";
}

void SuperController::init(int n, int numScInputs, int numScOutputs, double dtFast, int * globS)
{
    //n = nTurbines;
    //numScInputs = nScInputs;
    //numScOutputs = nScOutputs;
    nTurbines = n;
    nScInputs = numScInputs;
    nScOutputs = numScOutputs;
    dtF = dtFast;
    globStatesglob = globS;

    srand(time(NULL));
    StopC = false;
    ActivateGen = false;
    timeActivateGen = 0.0;
    for ( int i = 0 ; i < Trial ; i++ ) { 
        GenPwr[i].resize(nTurbines);
    }
    for ( int i = 0 ; i < Trial ; i++ ) { 
        YawAngle[i].resize(nTurbines);
    }
    GenPwrMeas.resize(nTurbines);
    YawAngMeas.resize(nTurbines);
    CounterY.resize(nTurbines);
    YawMis.resize(nTurbines);
    Bias.resize(nTurbines);

    YawAng.resize(nTurbines);
    for ( int j = 0 ; j < nTurbines ; j++ ) {
        YawAng[j] = 0.0; // YAW ANGLE BEFORE SC CALCULATIONS
    }
    
    //YawAngle[0] = {-27.5 * SuperController::d2R, -25.0 * SuperController::d2R, 0.0 * SuperController::d2R};
    //YawAngle[1] = {-27.5 * SuperController::d2R, -22.5 * SuperController::d2R, 0.0 * SuperController::d2R};
    //YawAngle[2] = {-20.0 * SuperController::d2R, -20.0 * SuperController::d2R, 0.0 * SuperController::d2R};
    //YawAngle[3] = {-25.0 * SuperController::d2R, -25.0 * SuperController::d2R, 0.0 * SuperController::d2R};
    
    for ( int i = 0 ; i < Trial * Ngen ; i++ ) { 
        YawTot[i].resize(nTurbines);
    }
    GenTot.resize(Trial * Ngen);
    


    cout << n << "  SC RUNNING_INIT \n";
    cout << nScInputs << "  SC RUNNING_INIT \n";
    cout << nScOutputs << "  SC RUNNING_INIT \n";
    cout << *globStatesglob << " TIME SC RUNNING_INIT \n";
    cout << dtF << " TIME SC RUNNING_INIT \n";

}

void SuperController::calcOutputs(std::vector<double> & scOutputsGlob)
{

    int stepglob = *globStatesglob;
    double time = stepglob*dtF;
    double MP;
    int indP;
    cout << time << " TIME SC RUNNING_CALC \n";
    cout << GenPwrMeas[0] << ", " << GenPwrMeas[1] << ", " << GenPwrMeas[2] << endl;
    if (CounterY[0] < 2 && StopC == true) {
        ActivateGen = true;
        if (!timeActivateGen) {
            timeActivateGen = time + 25.0; // Yaw needs to reach correct position
            Bias = YawAngMeas;
            for ( int i = 0 ; i < Trial ; i++ ) {
                for ( int j = 0 ; j < SuperController::nTurbines ; j++ ) {
                    YawAngle[i][j] = Bias[j] + double((rand() % 6) - 5) * SuperController::d2R * YawStep; // GENERATING FISRT POPULATION OF YAW ANGLES
                }
            }
            YawAngle[0] = Bias;
            YawAngle[1] = {Bias[0] +  -25.0 * SuperController::d2R, Bias[1]-25.0 * SuperController::d2R, Bias[2]+0.0 * SuperController::d2R};
            YawAngle[2] = {Bias[0]-25.0 * SuperController::d2R, Bias[1]-20.0 * SuperController::d2R, Bias[2]+0.0 * SuperController::d2R};
            YawAngle[3] = {Bias[0]-20.0 * SuperController::d2R, Bias[1]-20.0 * SuperController::d2R, Bias[2]+0.0 * SuperController::d2R};
            for ( int i = 0 ; i < Trial ; i++ ) {
                YawTot[ActualGen * Trial + i] = YawAngle[i];
            }
        }
    }

    // START OF GA
    if (ActualGen < (Ngen - 1) && ActualTrial < Trial) {

        if (abs(fmod(time - timeActivateGen, TimePerTrial)) < (SuperController::dtF / 2) && time > SuperController::dtF && ActivateGen == true) {

            cout << ActualTrial << " 1\n";
            GenPwr[ActualTrial] = GenPwrMeas;
            FitnessVec[ActualTrial] = CalcFitness(GenPwr[ActualTrial]);
            GenTot[ActualGen * Trial + ActualTrial] = FitnessVec[ActualTrial];
            ofstream myfilefitvec;
            myfilefitvec.open("FitnessVec.txt", ofstream::app);
            //myfilefitvec << FitnessVec[0] << ", " << FitnessVec[1] << ", " << FitnessVec[2] << ", " << FitnessVec[3] << ", " << FitnessVec[4] << ", " << FitnessVec[5] << ", " << time << endl;
            myfilefitvec << FitnessVec[0] << ", " << FitnessVec[1] << ", " << FitnessVec[2] << ", " << FitnessVec[3] << ", " << time << endl;
            myfilefitvec << YawAngle[ActualTrial][0] << ", " << YawAngle[ActualTrial][1] << ", " << YawAngle[ActualTrial][2] << ", " << time << endl;
            myfilefitvec.close();
            
            if (ActualTrial < (Trial - 1)) {

                ActualTrial++;

            }
            else {

                //MutPoint = rand() % 3;
                FitnessVecCopy = FitnessVec;
                vector<vector<double> > Parents = SelMatPool(YawAngle, FitnessVec, NparMat);
                FitnessVec = SelMatPoolPower(YawAngle, FitnessVecCopy, NparMat);
                vector<vector<double> > OffSprCross = CrossOver(Parents, Trial - NparMat, CrossPoint);
                vector<vector<double> > OffSprMut = Mutation(OffSprCross, MutPoint, Bias);
                NewPop.insert(NewPop.begin(), Parents.begin(), Parents.end());
                NewPop.insert(NewPop.begin() + Parents.size(), OffSprMut.begin(), OffSprMut.end());
                YawAngle = NewPop;
                ActualGen++;
                ActualTrial = NparMat; // SINCE I'M SAVING THE PARENTS, I'LL ALREADY KNOW THE GENERATED POWER FROM THIS CONFIGURATION

                for ( int i = 0 ; i < Trial ; i++ ) {
                    YawTot[ActualGen * Trial + i] = YawAngle[i];
                }
                for ( int i = 0 ; i < Trial - NparMat ; i++ ) {
                    GenTot[ActualGen * Trial + i] = FitnessVec[i];
                }
        
            }

            scOutputsGlob[0] = YawAngle[ActualTrial][0];
            scOutputsGlob[1] = YawAngle[ActualTrial][1];
            scOutputsGlob[2] = YawAngle[ActualTrial][2];
        }
        else {
            if (CounterY[0] >= 2) {
                scOutputsGlob[0] = YawMis[0];
                scOutputsGlob[1] = YawMis[0];
                scOutputsGlob[2] = YawMis[0];
                StopC = true;
            }
            if (ActivateGen == true) {

                for (int i = 0 ; i < Trial * ActualGen + ActualTrial ; i++) {
                    if (YawAngle[ActualTrial] == YawTot[i]) 
                    if ((abs(YawAngle[ActualTrial][0]-YawTot[i][0]) < YawStep/2) && (abs(YawAngle[ActualTrial][1]-YawTot[i][1]) < YawStep/2) && (abs(YawAngle[ActualTrial][2]-YawTot[i][2]) < YawStep/2)) { // devi usare valore assoluto, non ==
                        YawAngle[ActualTrial][rand() % 2] = double((rand() % 6) - 5) * SuperController::d2R * YawStep;
                        i = 0;
                    }
                }
            
                ofstream myfiletot;
                myfiletot.open("yawtotOUT.txt", ofstream::app);
                myfiletot << YawTot[ActualGen * Trial + ActualTrial][0] << ", " << YawTot[ActualGen * Trial + ActualTrial][1] << ", " << YawTot[ActualGen * Trial + ActualTrial][2] << ", " << "0, " << time << endl;
                myfiletot.close();

                YawTot[ActualGen * Trial + ActualTrial] = YawAngle[ActualTrial];

                myfiletot.open("yawtotOUT.txt", ofstream::app);
                myfiletot << YawTot[ActualGen * Trial + ActualTrial][0] << ", " << YawTot[ActualGen * Trial + ActualTrial][1] << ", " << YawTot[ActualGen * Trial + ActualTrial][2] << ", " << "1, " << time << endl;
                myfiletot.close();

                scOutputsGlob[0] = YawAngle[ActualTrial][0];
                scOutputsGlob[1] = YawAngle[ActualTrial][1];
                scOutputsGlob[2] = YawAngle[ActualTrial][2];
            }
            if (CounterY[0] < 2 && ActivateGen == false) {
                scOutputsGlob[0] = YawAngMeas[0];
                scOutputsGlob[1] = YawAngMeas[1];
                scOutputsGlob[2] = YawAngMeas[2];
            }
        }
    }
    else
    {
        string WDirNew = "FitnessVec.txt";
        vector<vector<double> > CSV = read_csv(WDirNew.c_str());
        BestYaw.push_back(getYaw_csv(CSV));
        BestPower.push_back(getPower_csv(CSV));

        // SELECT BEST OVERALL ANGLE ON ALL SIMULATIONS
        MP = *max_element(BestPower.begin(),BestPower.end());
        indP =  distance(BestPower.begin(), max_element(BestPower.begin(),BestPower.end()));
        YawAng = BestYaw[indP];

        scOutputsGlob[0] = YawAng[0];
        scOutputsGlob[1] = YawAng[1];
        scOutputsGlob[2] = YawAng[2];
    }

    cout << scOutputsGlob[0] << "  SC RUNNING_CALC \n";
    cout << scOutputsGlob[1] << "  SC RUNNING_CALC \n";
    cout << scOutputsGlob[2] << "  SC RUNNING_CALC \n";

    ofstream myfileout;
    myfileout.open("scoutputstocontrollers.txt", ofstream::app);
    myfileout << scOutputsGlob[0] << ", " << scOutputsGlob[1] << ", " << scOutputsGlob[2] << ", " << time << endl;
    myfileout.close();

    ofstream myfilelog;
    myfilelog.open("LOGICSC.txt", ofstream::app);
    myfilelog << CounterY[0] << ", " << StopC << ", " << ActivateGen << ", " << timeActivateGen << ", " << YawMis[0] << ", " << ActualTrial << ", " << ActualGen << ", " << time << endl;
    myfilelog.close();

}

void SuperController::updateStates(std::vector<double> & scInputsGlob)
{

    cout << scInputsGlob[0] << "  SC RUNNING_UPDATE \n";
    cout << scInputsGlob[1] << "  SC RUNNING_UPDATE \n";
    cout << scInputsGlob[2] << "  SC RUNNING_UPDATE \n";
    cout << scInputsGlob[3] << "  SC RUNNING_UPDATE \n";
    cout << scInputsGlob[4] << "  SC RUNNING_UPDATE \n";
    cout << scInputsGlob[5] << "  SC RUNNING_UPDATE \n";
    //copy(scInputsGlob.begin(), scInputsGlob.begin() + SuperController::nTurbines, back_inserter(GenPwrMeas));
    //copy(scInputsGlob.begin() + SuperController::nTurbines, scInputsGlob.end(), back_inserter(YawAngMeas));
    GenPwrMeas[0] = scInputsGlob[0];
    GenPwrMeas[1] = scInputsGlob[4];
    GenPwrMeas[2] = scInputsGlob[8];
    YawAngMeas[0] = scInputsGlob[1];
    YawAngMeas[1] = scInputsGlob[5];
    YawAngMeas[2] = scInputsGlob[9];
    CounterY[0] = scInputsGlob[2];
    CounterY[1] = scInputsGlob[6];
    CounterY[2] = scInputsGlob[10];
    YawMis[0] = scInputsGlob[3];
    YawMis[1] = scInputsGlob[7];
    YawMis[2] = scInputsGlob[11];
    cout << GenPwrMeas[0] << "  SC RUNNING_UPDATE \n";
    cout << GenPwrMeas[1] << "  SC RUNNING_UPDATE \n";
    cout << GenPwrMeas[2] << "  SC RUNNING_UPDATE \n";
    cout << YawAngMeas[0] << "  SC RUNNING_UPDATE \n";
    cout << YawAngMeas[1] << "  SC RUNNING_UPDATE \n";
    cout << YawAngMeas[2] << "  SC RUNNING_UPDATE \n";
    cout << *globStatesglob << " TIME SC RUNNING_UPDATE \n";
    cout << "SC RUNNING_UPDATE\n";
    ofstream myfilein;
    myfilein.open("scinputsfromcontrollers.txt", ofstream::app);
    myfilein << scInputsGlob[0] << ", " << scInputsGlob[1] << ", " << scInputsGlob[2] << ", " <<  scInputsGlob[3] << endl;
    myfilein << scInputsGlob[4] << ", " << scInputsGlob[5] << ", " << scInputsGlob[6] << ", " <<  scInputsGlob[7] << endl;
    myfilein << scInputsGlob[8] << ", " << scInputsGlob[9] << ", " << scInputsGlob[10] << ", " <<  scInputsGlob[11] << endl;
    myfilein.close();

}

int SuperController::writeRestartFile(int n_t_global)
{
    cout << "SC RUNNING\n";
    return 0;
}

int SuperController::readRestartFile(int n_t_global)
{
    cout << "SC RUNNING\n";
    return 0;
}


SuperController::~SuperController()
{
    delete SuperController::SuperController::turbineStates;
    delete SuperController::SuperController::globStates;
}
