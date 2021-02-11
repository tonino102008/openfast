#include "genAlg.h"
#include <algorithm>
#include <unistd.h>
#include <fstream>
#include <sstream>

#define GetCurrentDir getcwd

using namespace std;

int Trial = 4;
int NparMat = 2; // NUMBER OF MATING PARENTS
int Ngen = 10; // NUMBER OF GENERATIONS
int ActualGen = 0; // ACTUAL GENERATION
int ActualTrial = 0; // ACTUAL TRIAL
double TimePerTrial = 50.0;
int CrossPoint = 1;
int MutPoint = 2; // THEN WILL BE SUBSTITUTED
int YawStep = 5.0; // IN DEGREES
vector<double> FitnessVec (Trial);
vector<double> FitnessVecCopy (Trial); 
vector<vector<double> > GenPwr (Trial);
vector<vector<double> > YawAngle (Trial);
vector<vector<double> > NewPop (Trial);

double CalcFitness(vector<double> GenPwrTot)
{
    double SumOfEl = 0;
    for(vector<double>::iterator it = GenPwrTot.begin(); it != GenPwrTot.end(); ++it)
    SumOfEl += *it;
    return SumOfEl;
}

vector<vector<double> > SelMatPool(vector<vector<double> > PopGen, vector<double> FitnessGen, int NumParents)
{
    int MaxFitInd;
    vector<vector<double> > Parents (NumParents);
    for ( int i = 0 ; i < NumParents ; i++ ) {
        Parents[i].resize(PopGen[0].size());
    }

    for ( int i = 0 ; i < NumParents ; i++ ) {
        MaxFitInd = distance(FitnessGen.begin(), max_element(FitnessGen.begin(), FitnessGen.end()));
        Parents[i] = PopGen[MaxFitInd];
        FitnessGen[MaxFitInd] = -1;
    }

    return Parents;
}

vector<double> SelMatPoolPower(vector<vector<double> > PopGen, vector<double> FitnessGen, int NumParents)
{
    int MaxFitInd;
    vector<double> FitnessNew (FitnessGen.size());

    for ( int i = 0 ; i < NumParents ; i++ ) {
        MaxFitInd = distance(FitnessGen.begin(), max_element(FitnessGen.begin(), FitnessGen.end()));
        FitnessNew[i] = FitnessGen[MaxFitInd];
        FitnessGen[MaxFitInd] = -1;
    }

    return FitnessNew;
}

vector<vector<double> > CrossOver(vector<vector<double> > Parents, int OffSpringSize, int CrossPoint)
{
    vector<vector<double> > OffSpring (OffSpringSize);
    for ( int i = 0 ; i < OffSpringSize ; i++ ) {
        OffSpring[i].resize(Parents[0].size());
    }

    int Par1Ind, Par2Ind;
    for ( int i = 0 ; i < OffSpringSize ; i++ ) {
        Par1Ind = i % Parents.size();
        Par2Ind = (i + 1) % Parents.size();
        OffSpring[i].insert(OffSpring[i].begin(), Parents[Par1Ind].begin(), Parents[Par1Ind].begin() + CrossPoint);
        OffSpring[i].insert(OffSpring[i].begin() + CrossPoint, Parents[Par2Ind].begin() + CrossPoint, Parents[Par2Ind].end());
    }

    return OffSpring;

}

vector<vector<double> > Mutation(vector<vector<double> > OffSprCross, int MutPoint, vector<double> Bias)
{
    int randNum;
    int randPos;
    for ( int i = 0 ; i < OffSprCross.size() ; i++ ) {
        randNum = (rand() % 6) - 5;
        randPos = rand() % 2;
        OffSprCross[i][randPos] = Bias[randPos] + double(randNum) * 0.01745329251 * YawStep;
    }

    return OffSprCross;
    
}

string GetCurrentWorkingDir( void ) {
  char buff[FILENAME_MAX];
  GetCurrentDir( buff, FILENAME_MAX );
  string current_working_dir(buff);
  return current_working_dir;
}

vector<vector<double> > read_csv(string filename){
  vector<vector<double> > matrix;
  vector<double> linevec;
  //readfile
  fstream file;
  file.open(filename.c_str());
  string line;
  int i = 0;
  while (getline( file, line,'\n'))  
	{
	  istringstream templine(line); 
	  string data;

	  linevec.clear();

	  while (getline( templine, data,',')) 
	  {
		linevec.push_back(atof(data.c_str()));
	  }
	  matrix.push_back(linevec);
	  i++;
	}
  file.close();
  
  return matrix;
}

vector<double> getYaw_csv(vector<vector<double> > CSV) {
  vector<vector<double> > Power;
  vector<vector<double> > YawAng;
  vector<int> indmax;
  vector<vector<double> > YawMax;
  vector<double> PowerMax;
  int count = 0;
  int tmp = 0;
  int indPow;
  double PowerOpt;
  vector<double> YawOpt;

  for ( int i = 0; i < CSV.size(); i++ )
	{
		if (i % 2 == 0) {
			CSV[i].pop_back();
			Power.push_back(CSV[i]);
		}
		else
		{
			CSV[i].pop_back();
			YawAng.push_back(CSV[i]);
		}
		
	}

    // SECTION: FIND MAXIMA IN POWER AND YAW ANGLES
	for ( int i = 3; i < Power.size(); i = i + 2)
	{

		double max = *max_element(Power[i].begin(),Power[i].end());
		cout << distance(Power[i].begin(), max_element(Power[i].begin(),Power[i].end())) << endl;
		indmax.push_back(distance(Power[i].begin(), max_element(Power[i].begin(),Power[i].end())));
		PowerMax.push_back(Power[i][indmax[count]]);
		if (i > 3 && indmax[count] < 2) {
			YawMax.push_back(YawMax.back());
		}
		else if (i == 3) {
			YawMax.push_back(YawAng[indmax[count]]);
		}
		else
		{
			cout << tmp << ", " << indmax[count] - 1 << endl;
			YawMax.push_back(YawAng[tmp + indmax[count] - 1]);
		}

		count++;
		tmp = i;
		
		cout << indmax[count-1] <<  "INDICE" << endl;
	}

	PowerOpt = *max_element(PowerMax.begin(),PowerMax.end());
	indPow =  distance(PowerMax.begin(), max_element(PowerMax.begin(),PowerMax.end()));
	YawOpt.resize(YawMax[0].size());
	YawOpt = YawMax[indPow];
	
	cout << endl << indPow <<  "INDICE" << PowerOpt << "POTENZA" << endl;

    return YawOpt;

}

double getPower_csv(vector<vector<double> > CSV) {
  vector<vector<double> > Power;
  vector<vector<double> > YawAng;
  vector<int> indmax;
  vector<vector<double> > YawMax;
  vector<double> PowerMax;
  int count = 0;
  int tmp = 0;
  int indPow;
  double PowerOpt;
  vector<double> YawOpt;

  for ( int i = 0; i < CSV.size(); i++ )
	{
		if (i % 2 == 0) {
			CSV[i].pop_back();
			Power.push_back(CSV[i]);
		}
		else
		{
			CSV[i].pop_back();
			YawAng.push_back(CSV[i]);
		}
		
	}

    // SECTION: FIND MAXIMA IN POWER AND YAW ANGLES
	for ( int i = 3; i < Power.size(); i = i + 2)
	{

		double max = *max_element(Power[i].begin(),Power[i].end());
		cout << distance(Power[i].begin(), max_element(Power[i].begin(),Power[i].end())) << endl;
		indmax.push_back(distance(Power[i].begin(), max_element(Power[i].begin(),Power[i].end())));
		PowerMax.push_back(Power[i][indmax[count]]);
		if (i > 3 && indmax[count] < 2) {
			YawMax.push_back(YawMax.back());
		}
		else if (i == 3) {
			YawMax.push_back(YawAng[indmax[count]]);
		}
		else
		{
			cout << tmp << ", " << indmax[count] - 1 << endl;
			YawMax.push_back(YawAng[tmp + indmax[count] - 1]);
		}

		count++;
		tmp = i;
		
		cout << indmax[count-1] <<  "INDICE" << endl;
	}

	PowerOpt = *max_element(PowerMax.begin(),PowerMax.end());
	indPow =  distance(PowerMax.begin(), max_element(PowerMax.begin(),PowerMax.end()));
	YawOpt.resize(YawMax[0].size());
	YawOpt = YawMax[indPow];
	
	cout << endl << indPow <<  "INDICE" << PowerOpt << "POTENZA" << endl;

    return PowerOpt;

}