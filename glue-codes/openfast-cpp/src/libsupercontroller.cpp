#include "SC.h"

extern "C" SuperController* create_sc()
{
  return new SuperController;
}

extern "C" void destroy_sc( SuperController* sc)
{
  delete sc;
}

SuperController::SuperController()
{
   nTurbines = 2;
   nScInputs = 1;
   nScOutputs = 1;
   nGlobStates = 0;
   nTurbineStates = 0;
   globStates = 0;
   turbineStates = 0;
   d2R = 0.01745329251;
}

void SuperController::init( int n, int numScInputs, int numScOutputs)
{
    n = nTurbines;
    numScInputs = nScInputs;
    numScOutputs = nScOutputs;
}

void SuperController::calcOutputs( std::vector<double> & scOutputsGlob)
{
    scOutputsGlob = 0.5;
}

void SuperController::updateStates(std::vector<double> & scInputsGlob)
{
    scInputsGlob = 0.0;
}