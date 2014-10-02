#ifndef ENSEMBLE_H
#define ENSEMBLE_H

#include <algorithm>
//#include <omp.h>
#include "Matrix.h"
#include "Utility.h"

using namespace std;

class Ensemble{
private:
    unsigned int EnsembleSize;
    unsigned int gridRes;
    unsigned int Xdim, Ydim;
    vector< Matrix<int> > Members;
    vector<int> Orders;
    Matrix<double> FieldAvg;
    double LevelSet;
    vector<string> MemFileName;

public:
    friend class CBD;

    //constructors
    Ensemble();
    ~Ensemble();
    Ensemble(const Ensemble& e);

    // getters & setters
    unsigned int getSize() const;
    unsigned int getGridRes();
    int getXdim();
    void setXdim(int Xdim);
    int getYdim();
    void setYdim(int Ydim);
    Matrix<int> getMember(unsigned int index);

    // operations
    void InitializeEnsemble(unsigned int ESize, const double levelSet, unsigned int grid_res);
    Matrix<double> LoadFieldFileWithCoord(Matrix<double> &toReturn, string fileName);
    Matrix<double> LoadFieldFileWithoutCoord(Matrix<double> &toReturn, string fileName);
    void LoadFieldEnsemble(string fileName);//TODO: some how handle sign
    void LoadFieldEnsemble(string dir, vector<unsigned int> FrcstH, unsigned int MRun); //TODO: check for values
    friend void WriteEnsembleLog(const Ensemble& e, string logNum);

    friend string getFileName(string fname, unsigned int fileNumber);
    friend ostream& operator<<(ostream& out, const Ensemble& e);

    void printSize();
};

#endif // ENSEMBLE_H
