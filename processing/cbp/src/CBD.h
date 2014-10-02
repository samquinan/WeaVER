#ifndef CBD_H
#define CBD_H

#include "Utility.h"
#include "EnsembleHandler.h"
#include "CCLabeling.h"
#include "ContourExtraction.h"
#include "SVG.h"

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

    CBD(Ensemble e, unsigned int j, vector<unsigned int> Frcst, int outlierNum, string dir, unsigned int run);
    CBD(string src_dir, int gridRes, unsigned int j, int outlierNum, double levelSet, unsigned int run, string des_dir);

    // getter & setters
    Matrix<int> getUBand(const Ensemble e, const vector<int>& indx);
    void getUBand2(const Ensemble& e, const vector<int>& indx, Matrix<int>& UBD);
    Matrix<int> getIBand(const Ensemble e, const vector<int>& indx);
    void getIBand2(const Ensemble& e, const vector<int>& indx, Matrix<int>& IBD);

    void getPercentsFast();
    void getPercentProbabilities();
    friend bool sort_pred(const my_pair& left, const my_pair& right);
    friend vector<int> getSortedIndex(const vector<double>& v);
    void WriteSortedProbabilities(string fileName);

    void getTimePercents(unsigned int num, vector<unsigned int> Frcst);
    void genSVG(vector<unsigned int> Frcst, int outlierNum, double xmin, double ymin);
    void genSVG(int outlierNum, string des_dir, double xmin, double ymin, double xmax, double ymax);
	void genBinaryFields(int outlierNum, string des_dir, double xmin, double ymin, double xmax, double ymax);
    void genAnimation(string des_dir, double xmin, double ymin, double xmax, double ymax);
    Matrix<int> getBandMask(const Ensemble e, vector<int> v);
    double getThreshold(int outlierNum);

    Matrix<int> getTrimmedMean(Ensemble e, vector<int> v);
    void Load_lonLat(string fileName);

    friend void WriteLog();
};

#endif // CBD_H
