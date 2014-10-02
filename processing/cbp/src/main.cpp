#include <iostream>
//#include <fstream>
//#include <sstream>
//#include <string>
//#include <math.h>
//#include <vector>
//#include <map>
//#include <algorithm>
#include <time.h>
#include <cstdlib>
#include "EnsembleHandler.h"
#include "CCLabeling.h"
#include "ContourExtraction.h"
#include "CBD.h"

//#include "QuickView.h"

using namespace std;

//./CBP 20130831_212/ 212 9 258 test/
int main (int argc, char *argv[]){
    try{

        //Default settings
        unsigned int j = 2, outlierNum = 3;


        if(argc < 6){
            cout << "Corret usage: ./main <src_dir grid_res run level_set des_dir>" << endl;
            exit(-1);
        }

        cout << argv[1] << ", " << argv[2] << ", " << argv[3] << ", " << argv[4] << endl;

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
