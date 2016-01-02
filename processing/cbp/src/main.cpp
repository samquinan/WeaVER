#include <iostream>
#include <time.h>
#include <cstdlib>
#include "EnsembleHandler.h"
#include "CBD.h"

using namespace std;

int main (int argc, char *argv[]){
    try{

        //Default settings
        unsigned int j = 2, outlierNum = 3;

        if(argc < 6){
            cout << "Correct usage: ./main <src_dir grid_res run level_set des_dir>" << endl;
            exit(-1);
        }

        string src_dir = argv[1], des_dir = argv[5];
        int gridRes = atoi(argv[2]), run = atoi(argv[3]);
        double levelset = atof(argv[4]);

        cout << src_dir << ", " << gridRes << ", " << run << ", " << levelset << endl;

        CBD(src_dir, gridRes, j, outlierNum, levelset, run, des_dir);

        exit(1);


    }catch(int i){
        if( i == 1)
            cout<<"***Dimension mismatch***"<<endl;
        system ("PAUSE");
        return 0;
    }
    exit(1);
}
