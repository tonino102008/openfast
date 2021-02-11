#include "genAlg.h"
#include <iostream>
//using namespace std;

int main() 
{

    int nT = 3;
    int Trial = 4;
    int NparMat = 2;
    int Ngen = 10;
    srand(time(NULL));

    vector<double> FitnessVec = {0.0, 0.0, 0.0, 0.0};
    vector<vector<double> > GenPwr (Trial);
    for ( int i = 0 ; i < Trial ; i++ ) { 
        GenPwr[i].resize(nT);
    }
    GenPwr[0] = {1500.0, 2500.0, 3000.0};
    GenPwr[1] = {1800.0, 2100.0, 2200.0};
    GenPwr[2] = {1900.0, 2600.0, 3400.0};
    GenPwr[3] = {1500.0, 2100.0, 1000.0};
    for ( int i = 0 ; i < Trial ; i++ ) {
        double Fit = CalcFitness(GenPwr[i]);
        cout << Fit << "  TotalPower \n";
        cin.get();
    }
    vector<vector<double> > YawAngle (Trial);
    for ( int i = 0 ; i < Trial ; i++ ) { 
        YawAngle[i].resize(nT);
    }

    YawAngle[0] = {0.0, 0.12, 0.23};
    YawAngle[1] = {0.1, 0.02, 0.13};
    YawAngle[2] = {0.05, 0.20, 0.08};
    YawAngle[3] = {0.1, 0.05, 0.18};

    for ( int i = 0 ; i < Ngen ; i++ ) {
        for ( int i = 0 ; i < Trial ; i++ ) {
            FitnessVec[i] = CalcFitness(GenPwr[i]);
        }

        vector<vector<double> > Parents = SelMatPool(YawAngle, FitnessVec, NparMat);
        cout << Parents[0][0] << "  New Population ";
        cout << Parents[0][1] << "  New Population ";
        cout << Parents[0][2] << "  New Population \n";

        cout << Parents[1][0] << "  New Population ";
        cout << Parents[1][1] << "  New Population ";
        cout << Parents[1][2] << "  New Population \n";
        cin.get();

        vector<vector<double> > OffSprCross = CrossOver(Parents, Trial - NparMat, 2);
        cout << OffSprCross[0][0] << "  New Population ";
        cout << OffSprCross[0][1] << "  New Population ";
        cout << OffSprCross[0][2] << "  New Population \n";

        cout << OffSprCross[1][0] << "  New Population ";
        cout << OffSprCross[1][1] << "  New Population ";
        cout << OffSprCross[1][2] << "  New Population \n";
        cin.get();

        vector<vector<double> > OffSprMut = Mutation(OffSprCross, 0);
        cout << OffSprMut[0][0] << "  New Population ";
        cout << OffSprMut[0][1] << "  New Population ";
        cout << OffSprMut[0][2] << "  New Population \n";

        cout << OffSprMut[1][0] << "  New Population ";
        cout << OffSprMut[1][1] << "  New Population ";
        cout << OffSprMut[1][2] << "  New Population \n";
        cin.get();

        vector<vector<double> > NewPop;
        NewPop.insert(NewPop.begin(), Parents.begin(), Parents.end());
        NewPop.insert(NewPop.begin() + Parents.size(), OffSprMut.begin(), OffSprMut.end());

        //cout << NewPop[0][0] << "  New Population ";
        cout << NewPop[0][0] << "  New Population ";
        cout << NewPop[0][1] << "  New Population ";
        cout << NewPop[0][2] << "  New Population \n";

        cout << NewPop[1][0] << "  New Population ";
        cout << NewPop[1][1] << "  New Population ";
        cout << NewPop[1][2] << "  New Population \n";

        cout << NewPop[2][0] << "  New Population ";
        cout << NewPop[2][1] << "  New Population ";
        cout << NewPop[2][2] << "  New Population \n";

        cout << NewPop[3][0] << "  New Population ";
        cout << NewPop[3][1] << "  New Population ";
        cout << NewPop[3][2] << "  New Population \n";
        cin.get();
    }


    return 0;
}