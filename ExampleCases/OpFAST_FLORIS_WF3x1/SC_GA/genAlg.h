// genAlg.h
#ifndef GENALG_H
#define GENALG_H

#include <vector>
#include <iostream>
#include <string>
using namespace std;


extern vector<double> FitnessVec; // THESE VECTORS HOLD VALUES FOR ONLY ONE GENERATION
extern vector<double> FitnessVecCopy; 
extern vector<vector<double> > GenPwr;
extern vector<vector<double> > YawAngle;
extern vector<vector<double> > NewPop;
extern int Trial;
extern int NparMat; // NUMBER OF MATING PARENTS
extern int Ngen; // NUMBER OF GENERATIONS
extern int ActualGen; // ACTUAL GENERATION
extern int ActualTrial; // ACTUAL TRIAL
extern double TimePerTrial;
extern int CrossPoint;
extern int MutPoint;
extern int YawStep; // IN DEGREES

double CalcFitness(vector<double>);
vector<vector<double> > SelMatPool      (vector<vector<double> >, vector<double>, int);
vector<double>          SelMatPoolPower (vector<vector<double> >, vector<double>, int);
vector<vector<double> > CrossOver       (vector<vector<double> >, int, int);
vector<vector<double> > Mutation        (vector<vector<double> >, int, vector<double>);
string                  GetCurrentWorkingDir(void);
vector<vector<double> > read_csv(string);
vector<double>          getYaw_csv(vector<vector<double> >);
double                  getPower_csv(vector<vector<double> >);

#endif