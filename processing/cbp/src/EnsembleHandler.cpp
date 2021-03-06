#include "EnsembleHandler.h"

using namespace std;

Ensemble::Ensemble(){
    EnsembleSize = -1;
    Xdim = -1;
    Ydim = -1;
    LevelSet = -1.0;
}

Ensemble::Ensemble(const Ensemble& e)
:EnsembleSize(e.EnsembleSize){
    EnsembleSize = e.EnsembleSize;
    Xdim = e.Xdim;
    Ydim = e.Ydim;
    FieldAvg = e.FieldAvg;
    LevelSet = e.LevelSet;
    gridRes = e.gridRes;

    Members.clear();
    Orders.clear();
    MemFileName.clear();
    for (unsigned int i=0; i<EnsembleSize; i++){
        Members.push_back(e.Members[i]);
        Orders.push_back(e.Orders[i]);
        MemFileName.push_back(e.MemFileName[i]);
    }
}

Ensemble::~Ensemble(){
    Members.clear();
}

void Ensemble::InitializeEnsemble(unsigned int ESize, const double levelSet, unsigned int grid_res){
    // This function has the SREF grid resolution hard coded
    EnsembleSize = ESize;
    gridRes = grid_res;
    if(grid_res == 212){ // SREF (low) resolution
        Xdim = 185; Ydim = 129;
    }else if(grid_res == 132){ // SREF (high) resolution
        Xdim = 697; Ydim = 553;
    }else{
        cerr << "invalid grid resolution for SREF" << grid_res << endl;
        exit(-1);
    }

    LevelSet = levelSet;
    Members.resize(ESize, Matrix<int>(Xdim, Ydim, 0));
    MemFileName.resize(ESize, "");
    FieldAvg = Matrix<double>(Xdim, Ydim, 0.0);
    for(unsigned int i=0; i<ESize; i++)
        Orders.push_back(i);
}

string getFileName(string fname, unsigned int fileNumber){
    stringstream ss;
    string s, fileName;
    s = fname;
    ss.str("");
    ss << s << "_" << fileNumber << ".txt";
    fileName = ss.str();
    return fileName;
}

Matrix<double> Ensemble::LoadFieldFileWithCoord(Matrix<double> &toReturn, string fileName){
    ifstream data(fileName.c_str());

    if(!data.is_open()){
    printf("Bad Vector Filename: %s\n", fileName.c_str());
    exit(-1);
    }

    double d1, d2, d3;
    char separator;
    int counter = 0, i =0, j = 0;
    while(counter < Xdim*Ydim){
        data >> d1 >> separator>> d2 >> separator >> d3;
        i = counter%Xdim; j = counter/Xdim;
        toReturn(i,Ydim-1-j) = d3;
        counter++;
    }
    data.close();
    return toReturn;
}

Matrix<double> Ensemble::LoadFieldFileWithoutCoord(Matrix<double>& toReturn, string fileName){

    ifstream data(fileName.c_str());

    if(!data.is_open()){
    printf("Bad Vector Filename: %s\n", fileName.c_str());
    exit(-1);
    }

    double d;
    int counter = 0, i =0, j = 0;
    while(counter < Xdim*Ydim){
        data >> d;
        i = counter%Xdim; j = counter/Xdim;
		toReturn(i,Ydim-1-j) = d;
        counter++;
    }
    data.close();
    return toReturn;
}

void Ensemble::LoadFieldEnsemble(string fname){

    Matrix<double> m = Matrix<double>(Xdim, Ydim);
    Matrix<double> Fieldsum = Matrix<double>(Xdim, Ydim, 0.0);
    for(unsigned int i=0; i<EnsembleSize; i++){
        string fileName = getFileName(fname, i+1);
        MemFileName[i] = fileName;
        LoadFieldFileWithCoord(m, fileName);
        Fieldsum += m;

        Members[i] = getLevelSetMask(m, LevelSet);
    }

    FieldAvg = Matrix<double>(Xdim, Ydim);
    for(unsigned int i=0; i<Xdim; ++i)
        for(unsigned int j=0; j<Ydim; ++j)
            FieldAvg(i,j) = Fieldsum(i,j)/EnsembleSize;
}

void Ensemble::LoadFieldEnsemble(string dir, vector<unsigned int> FrcstH, unsigned int MRun){
    // This function uses NCEP SREF naming convention

    Matrix<double> mem = Matrix<double>(Xdim, Ydim);
    Matrix<double> Fieldsum = Matrix<double>(Xdim, Ydim, 0.0);

    vector<string> model, perts;
    model.push_back("arw"); model.push_back("nmb");
    perts.push_back("ctl"); perts.push_back("n1"); perts.push_back("n2"); perts.push_back("n3");
    perts.push_back("n4"); perts.push_back("n5"); perts.push_back("n6");
	perts.push_back("p1"); perts.push_back("p2"); perts.push_back("p3");
	perts.push_back("p4"); perts.push_back("p5"); perts.push_back("p6");
	// accurate for runs from before 10/21/2015 Update -- to switch back also need to update ESIZE constant in Utility.h
    // model.push_back("em"); model.push_back("nmb"); model.push_back("nmm");
    // perts.push_back("ctl"); perts.push_back("n1"); perts.push_back("n2"); perts.push_back("n3");
    // perts.push_back("p1"); perts.push_back("p2"); perts.push_back("p3");
	
    stringstream ss;
    int counter = 0;

    for(int f=0; f<FrcstH.size(); f++)
        for(int m=0; m<model.size(); m++)
            for(int p=0; p<perts.size(); p++){
                ss.str(string());
                ss.clear();
                ss << dir << "sref_" << model[m];

                if(MRun < 10)
                    ss << ".t0" << MRun;
                else
                    ss << ".t" << MRun;

                ss << "z.pgrb" << gridRes << "." << perts[p];

                if(FrcstH[f]<10){
                    ss << ".f0";
                }else{
                    ss << ".f";
                }

                ss << FrcstH[f];
                MemFileName[counter] = ss.str();
                ss << ".txt";

				LoadFieldFileWithoutCoord(mem, ss.str());
                Fieldsum += mem;
                if(counter > EnsembleSize){
                    cerr << "wrong size of ensemble: "<< counter << ", " << EnsembleSize << endl;
                    exit(-1);
                }

                Members[counter++] = getLevelSetMask(mem, LevelSet);
            }

    if(counter != EnsembleSize){
        cerr << "size mismatch: " << counter << ", " << EnsembleSize <<endl;
        exit(-1);
    }

    FieldAvg = Matrix<double>(Xdim, Ydim);
    for(unsigned int i=0; i<Xdim; ++i)
        for(unsigned int j=0; j<Ydim; ++j)
            FieldAvg(i,j) = Fieldsum(i,j)/EnsembleSize;

}

int Ensemble::getXdim(){
    return Xdim;
}

void Ensemble::setXdim(int Xdim){
    Xdim = Xdim;
}

void Ensemble::setYdim(int Ydim){
    Ydim = Ydim;
}

int Ensemble::getYdim(){
    return Ydim;
}

Matrix<int> Ensemble::getMember(unsigned int index){
    if(index > EnsembleSize){
        throw 1;
        return Matrix<int>();
    }
    return Members[index];
}

unsigned int Ensemble::getSize() const{
    return EnsembleSize;
}

unsigned int Ensemble::getGridRes(){
    return gridRes;
}
