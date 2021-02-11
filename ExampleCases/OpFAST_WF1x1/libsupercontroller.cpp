#include "SC.h"
#include <vector>
#include <iostream>
#include <fstream>

//std::vector<double> scdentro = {0, 0, 0};
std::vector<double> scdentro = {0};
int * globStatesglob;

extern "C" SuperController* create_sc()
{
   std::cout << "SC RUNNING\n";
  return new SuperController;
}

extern "C" void destroy_sc(SuperController* sc)
{
   std::cout << "SC RUNNING\n";
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
   std::cout << "SC RUNNING_START\n";
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
   std::cout << n << "  SC RUNNING_INIT \n";
   std::cout << nScInputs << "  SC RUNNING_INIT \n";
   std::cout << nScOutputs << "  SC RUNNING_INIT \n";
   std::cout << *globStatesglob << " TIME SC RUNNING_INIT \n";
   std::cout << dtF << " TIME SC RUNNING_INIT \n";

}

void SuperController::calcOutputs(std::vector<double> & scOutputsGlob)
{

   std::vector<double> pitch_rate = {0.5*d2R, 1*d2R, 0.75*d2R}; // from deg/s to rad/s scemo
   std::cout << scdentro[0] << "  SC RUNNING_CALC \n";
   //std::cout << scdentro[1] << "  SC RUNNING_CALC \n";
   //std::cout << scdentro[2] << "  SC RUNNING_CALC \n";
   int stepglob = *globStatesglob;
   double time = stepglob*dtF;
   std::cout << time << " TIME SC RUNNING_CALC \n";
   //scOutputsGlob[0] = pitch_rate[0]*time;
   //scOutputsGlob[1] = pitch_rate[1]*time;
   //scOutputsGlob[2] = pitch_rate[2]*time;
   scOutputsGlob[0] = 0;
   //scOutputsGlob[1] = 0;
   //scOutputsGlob[2] = 0;
   std::cout << scOutputsGlob[0] << "  SC RUNNING_CALC \n";
   //std::cout << scOutputsGlob[1] << "  SC RUNNING_CALC \n";
   //std::cout << scOutputsGlob[2] << "  SC RUNNING_CALC \n";
}

void SuperController::updateStates(std::vector<double> & scInputsGlob)
{
    scdentro = scInputsGlob;
    std::cout << scdentro[0] << "  SC RUNNING_UPDATE \n";
    //std::cout << scdentro[1] << "  SC RUNNING_UPDATE \n";
    //std::cout << scdentro[2] << "  SC RUNNING_UPDATE \n";
    std::cout << *globStatesglob << " TIME SC RUNNING_UPDATE \n";
    std::cout << "SC RUNNING_UPDATE\n";
    std::ofstream myfile;
    myfile.open("scinputsfromcontrollers.txt", std::ofstream::app);
    myfile << scInputsGlob[0] << std::endl; //", " << scInputsGlob[1] << ", " << scInputsGlob[2] << std::endl;
    myfile.close();
}

int SuperController::writeRestartFile(int n_t_global)
{
    std::cout << "SC RUNNING\n";
    return 0;
}

int SuperController::readRestartFile(int n_t_global)
{
    std::cout << "SC RUNNING\n";
    return 0;
}


SuperController::~SuperController()
{
    delete SuperController::SuperController::turbineStates;
    delete SuperController::SuperController::globStates;
}
