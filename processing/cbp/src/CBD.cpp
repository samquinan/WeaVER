#include "CBD.h"

CBD::CBD(string src_dir, int gridRes, unsigned int j, int outlierNum, double levelSet, unsigned int run, string des_dir){
    // This constructor will load the nesemble, do that analysis and write  a file called analysis.txt
    // This file will have the rank statistics and Depth values.
    // The forecast hours to do CBD analysis is hard coded

    vector<unsigned int> Frcst;
    Frcst.push_back(12); Frcst.push_back(24); Frcst.push_back(48); Frcst.push_back(60);

    E.InitializeEnsemble(ESIZE*Frcst.size(), levelSet, gridRes);
    E.LoadFieldEnsemble(src_dir, Frcst, run);

    std::stringstream ss;
    ss << "lonLat_" << gridRes << ".txt";
    Load_lonLat(ss.str());

    numJ = j;
    Dir = src_dir;
    MRun = run;

    // computing the band inclusions in space and time (based on the forecast hours specified above)
    getTimePercents(ESIZE, Frcst);

    PThreshold = getThreshold(outlierNum);
	
    // computingt the modified band depth values
    getPercentProbabilities();
    ss.str(string());
    ss.clear();

    // writing the depth values and rank statistics
    ss << des_dir << "analysis.txt";
    WriteSortedProbabilities(ss.str());	
}

bool sort_predD(const my_pair& left, const my_pair& right){
    return left.first < right.first;
}

void CBD::Load_lonLat(string fileName){
    // This function will load in NCEPT SREF longitude/latitude
    // and do the map projection
    ifstream data(fileName.c_str());
    DoublePairVect prj, shift_v;

    if(!data.is_open()){
    printf("Bad Vector Filename: %s\n", fileName.c_str());
    exit(-1);
    }
    lon = Matrix<double>(E.getXdim(), E.getYdim(), 0.0);
    lat = Matrix<double>(E.getXdim(), E.getYdim(), 0.0);

    double d1, d2;
    char separator;
    int counter = 0, i =0, j = 0;
    double cntre_lat, cntre_lon, SP;

    while(counter < E.getXdim()*E.getYdim()){
        data >> d1 >> separator>> d2;
        i = counter%E.getXdim(); j = counter/E.getXdim();
        if (E.gridRes == SMALLGRIDRES){
            cntre_lat = 35.0;
            cntre_lon = -95.0;
            SP = 25.0;
        }else if(E.gridRes == BIGGRIDRES){
            cntre_lat = 40.0;
            cntre_lon = -107.0;
            SP = 50.0;
        }else{
            cout << "grid res specified not handled: " << E.gridRes << endl;
            exit(-1);
        }
        prj = getMapProjSphere(-(95.0+265.0-d1), d2, cntre_lat, cntre_lon, SP);
        //the shift required to have the center to be center of the map (the center for the map is 95W, 35N)
        lon(i,E.getYdim()-1-j) = prj.first;
        lat(i,E.getYdim()-1-j) = prj.second;
        counter++;
    }

    shift_v = getMapProjSphere(cntre_lon, cntre_lat, 35, -95, 25);
    shift_x = shift_v.first;
    shift_y = shift_v.second;
    data.close();
}


vector<int> getSortedIndex(const vector<double>& v){
    vector<my_pair> VIndx;
    for(unsigned int i=0; i<v.size(); i++)
        VIndx.push_back(my_pair(v[i],i));
    sort(VIndx.begin(), VIndx.end(), sort_predD);
    vector<int> indx;
    for(unsigned int i=0; i<VIndx.size(); i++)
        indx.push_back(VIndx[i].second);
    return indx;
}

Matrix<int> CBD::getUBand(const Ensemble e, const vector<int>& indx){
    // Computing the union band
    Matrix<int> temp(e.Xdim, e.Ydim);
    temp = e.Members[indx[0]];
    for(unsigned int i=1;i<indx.size();i++)
        temp = getBinaryUnion(temp, e.Members[indx[i]]);
    return temp;
}

Matrix<int> CBD::getIBand(const Ensemble e, const vector<int>& indx){
    // computing the intersection band
    Matrix<int> temp(e.Xdim, e.Ydim);
    temp = e.Members[indx[0]];
    for(unsigned int i=1;i<indx.size();i++)
        temp = getBinaryIntersect(temp, e.Members[indx[i]]);
    return temp;
}

void CBD::checkInclusion(int i, unsigned int num, Matrix<double>& UEnumerator_tmp, Matrix<double>& UDenumerator_tmp,
                         Matrix<double>& IDenumerator_tmp, Matrix<double>& IEnumerator_tmp, Matrix<int> Combinations){

    double UnionInclusion = 0.0, IntersectionInclusion = 0.0;
    double currentSum = 0.0, IntersectionSum = 0.0;

    Matrix<int> UnionMask = Matrix<int>(E.Xdim, E.Ydim);
    Matrix<int> IntersectionMask = Matrix<int>(E.Xdim, E.Ydim);

    for(unsigned int j=0; j<Combinations.getXdim(); ++j){
            vector<int> JSet; JSet.push_back(Combinations(j,0)-1+num*i); JSet.push_back(Combinations(j,1)-1+num*i);
            UnionMask = getUBand(E, JSet);
            IntersectionMask = getIBand(E, JSet);
            #pragma omp parallel for private(UnionInclusion, IntersectionInclusion, currentSum, IntersectionSum)
            for(unsigned int k=0; k<num; ++k){
                    UnionInclusion = IntersectionInclusion = 0.0;
                    currentSum = IntersectionSum = 0.0;
                    if((JSet[0] == (i*num+k)) || (JSet[1] == (i*num+k))){
                        continue;
                    }else{
                        //Matrix<int> current = E.Members[i*num+k];
                        UnionInclusion = double(getBinaryIntersect(E.Members[i*num+k], UnionMask).getSum());
                        UEnumerator_tmp(k,j) += UnionInclusion;

                        currentSum = double(E.Members[i*num+k].getSum());
                        UDenumerator_tmp(k,j) += currentSum;

                        IntersectionSum = double(getBinaryIntersect(IntersectionMask, E.Members[i*num+k]).getSum());
                        IEnumerator_tmp(k,j) += IntersectionSum;

                        IntersectionSum = double(IntersectionMask.getSum());
                        IDenumerator_tmp(k,j) += IntersectionSum;
                    }
            }
    }
}

void CBD::getTimePercents(unsigned int num, vector<unsigned int> Frcst){
    // Doing the CBD analysis over the forecast hours specified in the constructor
    if((E.getSize())%num != 0){
        cerr << "size mismatch: " << E.getSize() << ", " << num << endl;
        exit(-1);
    }

    Matrix<int> Combinations = getCombinationMatrix(num, numJ);

    Matrix<double> UEnumerator = Matrix<double>(num, Combinations.getXdim(), 0.0), UDenumerator = Matrix<double>(num, Combinations.getXdim(), 0.0);
    Matrix<double> IDenumerator = Matrix<double>(num, Combinations.getXdim(), 0.0), IEnumerator = Matrix<double>(num, Combinations.getXdim(), 0.0);

    UPercents = Matrix<double>(num, Combinations.getXdim(), 0.0);
    IPercents = Matrix<double>(num, Combinations.getXdim(), 0.0);

    #pragma omp parallel for
    for(int i=0; i<Frcst.size(); i++){

        Matrix<double> UEnumerator_tmp = Matrix<double>(num, Combinations.getXdim(), 0.0);
        Matrix<double> UDenumerator_tmp = Matrix<double>(num, Combinations.getXdim(), 0.0);
        Matrix<double> IDenumerator_tmp = Matrix<double>(num, Combinations.getXdim(), 0.0);
        Matrix<double> IEnumerator_tmp = Matrix<double>(num, Combinations.getXdim(), 0.0);

        checkInclusion(i, num, UEnumerator_tmp, UDenumerator_tmp, IDenumerator_tmp, IEnumerator_tmp, Combinations);

        UEnumerator += UEnumerator_tmp;
        UDenumerator += UDenumerator_tmp;
        IEnumerator += IEnumerator_tmp;
        IDenumerator += IDenumerator_tmp;

    }

    for(int i=0; i<num; i++){
        for(int j=0; j<Combinations.getXdim(); j++){
            if(UDenumerator(i,j) == 0.0 || IDenumerator(i,j) == 0){
                UPercents(i,j) = 0.0;
                IPercents(i,j) = 0.0;
            }else{
                UPercents(i,j) = double(UEnumerator(i,j))/double(UDenumerator(i,j));
                IPercents(i,j) = double(IEnumerator(i,j))/double(IDenumerator(i,j));
            }
        }
    }
}

double CBD::getThreshold(int outlierNum){
    // computing the outlier detection threshold based on the
    // the number of outliers specified in the main.cpp
    double toReturn = 0.0;
    vector<double> UV(UPercents.getXdim(), 0.0), IV(IPercents.getXdim(), 0.0);

    for(int i=0; i<UPercents.getXdim(); i++)
        for(int j=0; j<UPercents.getYdim(); j++){
            if(UPercents(i,j) > UV[i])
                UV[i] = UPercents(i,j);
            if(IPercents(i,j) > IV[i])
                IV[i] = IPercents(i,j);
    }
    sort(UV.begin(), UV.end());
    sort(IV.begin(), IV.end());

    if(outlierNum > UV.size()){
        cerr << "Outlier num is bigger than the size of ensemble: " << outlierNum << ", "  << UV.size() << endl;
        exit(-1);
    }

    toReturn = min(UV[outlierNum-1], IV[outlierNum-1]);
    return toReturn;
}

void CBD::getPercentProbabilities(){
    // computing the modified band depth values
    // see Eq. 7 in
    // Ross T. Whitaker, Mahsa Mirzargar, Robert M. Kirby,
    // “Contour Boxplots: A Method for Charac- terizing Uncertainty in Feature Sets from Simulation Ensembles”,
    // IEEE Transactions on Visualization and Computer Graphics (TVCG), vol. 19, no. 12, pp. 2713-2722, 2013.

    if(Probs.size() != 0)
        cout<<"The probabilities are about to be overwritten"<<endl;
    Probs.clear();
    double temp;
    for(unsigned int i=0; i<UPercents.getXdim(); ++i){
        temp = 0.0;
        for(unsigned int j=0; j<UPercents.getYdim(); ++j)
            temp += (((UPercents(i,j) >= PThreshold) && (IPercents(i,j) >= PThreshold))? 1.0 : 0.0);
        Probs.push_back(temp/double(UPercents.getYdim()));
    }
}

void CBD::WriteSortedProbabilities(string fileName){
    // writes the anaysis.txt function (that include the rank statisitcs and depth values)
    ofstream data(fileName.c_str());
    int counter = Probs.size();
    vector<int> SortedIndices = getSortedIndex(Probs);
    vector<double> SortedProbs = Probs;
    sort(SortedProbs.begin(), SortedProbs.end());
    while(--counter>= 0)
        data << SortedProbs[counter] << "\t" << SortedIndices[counter] << endl;;
}
