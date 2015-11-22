#ifndef CBD_H
#define CBD_H

#include "Utility.h"
#include "EnsembleHandler.h"
#include <time.h>
//#include <omp.h>

using namespace std;

typedef pair<double, int> my_pair;

class CBD{
private:
    vector<double> Probs;
    double PThreshold;
    Matrix<double> UPercents;
    Matrix<double> IPercents;
    unsigned int numJ;
    Ensemble E;
    unsigned int MRun;
    string Dir;
    Matrix<double> lon;
    Matrix<double> lat;
    double shift_x;
    double shift_y;

public:

    CBD(string src_dir, int gridRes, unsigned int j, int outlierNum, double levelSet, unsigned int run, string des_dir);

    // getter & setters
    Matrix<int> getUBand(const Ensemble e, const vector<int>& indx);
    Matrix<int> getIBand(const Ensemble e, const vector<int>& indx);

    void getPercentProbabilities();
    void checkInclusion(int i, unsigned int num, Matrix<double>& UEnumerator_tmp, Matrix<double> &UDenumerator_tmp,
                        Matrix<double>& IDenumerator_tmp, Matrix<double> &IEnumerator_tmp, Matrix<int> Combinations);

    friend vector<int> getSortedIndex(const vector<double>& v);
    void WriteSortedProbabilities(string fileName);

    void getTimePercents(unsigned int num, vector<unsigned int> Frcst);
	void genBinaryFields(int outlierNum, string des_dir, double xmin, double ymin, double xmax, double ymax);
    double getThreshold(int outlierNum);
    void Load_lonLat(string fileName);

};

#endif // CBD_H
