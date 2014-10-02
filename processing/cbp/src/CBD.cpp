#include "CBD.h"

CBD::CBD(Ensemble e, unsigned int j, vector<unsigned int> Frcst, int outlierNum, string dir, unsigned int run){
    cout<<"constructor 2:"<<endl;// <<threshold<<endl;
    E = Ensemble(e);
    cout<<"ensemble size: " << e.getGridRes() << ", " << E.gridRes << endl;
    numJ = j;
    Dir = dir;
    MRun = run;//TODO: put checks for validity
    getTimePercents(21, Frcst);//TODO: not hard coded
    PThreshold = getThreshold(outlierNum);
    getPercentProbabilities();
    WriteSortedProbabilities("analysis_c2.txt");
}

CBD::CBD(string src_dir, int gridRes, unsigned int j, int outlierNum, double levelSet, unsigned int run, string des_dir){
    cout<<"constructor 3:"<<endl;// <<threshold<<endl;
    vector<unsigned int> Frcst;
    Frcst.push_back(12); Frcst.push_back(24); Frcst.push_back(48); Frcst.push_back(60);

    E.InitializeEnsemble(21*Frcst.size(), levelSet, gridRes);//TODO: not hard coded
    E.LoadFieldEnsemble(src_dir, Frcst, run);
    //return;

    std::stringstream ss;
    ss << "lonLat_" << gridRes << ".txt";
    cout << ss.str() << endl;
    Load_lonLat(ss.str());
    //return;
    //WriteMatrixFile(lon, "lon.txt");
    //WriteMatrixFile(lat, "lat.txt");

    double xmin = lon(0,0), ymax = lat(0,0);
    double ymin = lat(0,lat.getYdim()-1);
    double xmax = lon(lon.getXdim()-1, 0);


    cout << xmin << ", " << ymin << ", " << xmax << ", " << ymax << endl;
    //return;

    numJ = j;
    Dir = src_dir;
    MRun = run;
    getTimePercents(21, Frcst);//TODO: not hard coded
    //WriteMatrixFile(UPercents, "test.txt");
    PThreshold = getThreshold(outlierNum);
    cout<<"PThreshold: "<< PThreshold << endl;
    cout << "outlier number: " << outlierNum << endl;
    //return;
	
    getPercentProbabilities();
    ss.str(string());
    ss.clear();
    ss << des_dir << "analysis.txt";
    WriteSortedProbabilities(ss.str());
	
    //TODO: still off by a shift for the map
    // genSVG(outlierNum, des_dir, xmin, ymin, xmax, ymax);
	genBinaryFields(outlierNum, des_dir, xmin, ymin, xmax, ymax);
    //genAnimation(des_dir,xmin, ymin, xmax, ymax);

}

bool sort_predD(const my_pair& left, const my_pair& right){
    return left.first < right.first;
}

void CBD::Load_lonLat(string fileName){
    //TODO: Not stable
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

    cout << E.getXdim() << ", " << E.getYdim() << endl;
    while(counter < E.getXdim()*E.getYdim()){
        data >> d1 >> separator>> d2;
        i = counter%E.getXdim(); j = counter/E.getXdim();
        //toReturn(i,Ydim-1-j) = d3;
        if (E.gridRes == 212){
            cntre_lat = 35.0;
            cntre_lon = -95.0;
            SP = 25.0;
        }else if(E.gridRes == 132){
            cntre_lat = 40.0;
            cntre_lon = -107.0;
            SP = 50.0;
        }else{
            cout << "grid res specified not handled: " << E.gridRes << endl;
            exit(-1);
        }
        prj = getMapProjSphere(-(95.0+265.0-d1), d2, cntre_lat, cntre_lon, SP);
        //the shift required to have the center to be center of the map (the center for the map is 95W, 35N)
        lon(i,E.getYdim()-1-j) = prj.first;//-(95.0+265.0-d1);
        lat(i,E.getYdim()-1-j) = prj.second;//2;
        counter++;
    }

    shift_v = getMapProjSphere(cntre_lon, cntre_lat, 35, -95, 25);
    shift_x = shift_v.first;
    shift_y = shift_v.second;
    cout << "*** shift: " << cntre_lon << ", " << cntre_lat << ", " << shift_x << ", " << shift_y << endl;

    data.close();
    //return toReturn;
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
    Matrix<int> temp(e.Xdim, e.Ydim);
    temp = e.Members[indx[0]];
    for(unsigned int i=1;i<indx.size();i++)
        temp = getBinaryUnion(temp, e.Members[indx[i]]);
    return temp;
}

void CBD::getUBand2(const Ensemble& e, const vector<int>& indx, Matrix<int>& UBD){
    // TODO: check for empty ensemble
    //Volume<int> toReturn(e.Xdim, e.Ydim, e.Zdim, 0);

        for(int i=0; i<e.Xdim; i++)
            for(int j=0; j<e.Ydim; j++){
                //for(int k=0; k<e.Zdim; k++){
                    for(int l=0; l<indx.size(); l++){
                        if(e.Members[indx[l]].get(i,j) == 1){
                            UBD(i,j) = 1;
                            //toReturn(i,j,k) = 1;
                            continue;
                        }
                    }
                }
    //return toReturn;
}

void CBD::getIBand2(const Ensemble& e, const vector<int>& indx, Matrix<int>& IBD){
    // TODO: check for empty ensemble

    //Volume<int> toReturn(e.Xdim, e.Ydim, e.Zdim, 1);
    for(int i=0; i<e.Xdim; i++)
        for(int j=0; j<e.Ydim; j++){
            //for(int k=0; k<e.Zdim; k++){
                for(int l=0; l<indx.size(); l++){
                    if(e.Members[indx[l]].get(i,j) == 0){
                        IBD(i,j) = 0;
                        //toReturn(i,j,k) = 0;
                        continue;
                    }
                }
            }

    //return toReturn;
}

Matrix<int> CBD::getIBand(const Ensemble e, const vector<int>& indx){
    Matrix<int> temp(e.Xdim, e.Ydim);
    temp = e.Members[indx[0]];
    for(unsigned int i=1;i<indx.size();i++)
        temp = getBinaryIntersect(temp, e.Members[indx[i]]);
    return temp;
}

void CBD::getPercentsFast(){
    cout<<"running simple fast algorithm"<<endl;
        if(numJ <=0 || numJ > E.EnsembleSize){
                cout<<"***** INVALID J"<<endl;
                return;
        }
        Matrix<int> Combinations = getCombinationMatrix(E.EnsembleSize, numJ);

        Matrix<int> UBD = Matrix<int>(E.Xdim, E.Ydim);
        Matrix<int> IBD = Matrix<int>(E.Xdim, E.Ydim);

        UPercents = Matrix<double>(E.EnsembleSize, Combinations.getXdim());
        IPercents = Matrix<double>(E.EnsembleSize, Combinations.getXdim());

        for(unsigned int j=0; j<Combinations.getXdim(); ++j){
                vector<int> JSet; JSet.push_back(Combinations(j,0)-1); JSet.push_back(Combinations(j,1)-1);
                UBD.set(0);
                IBD.set(1);
                getUBand2(E, JSet, UBD);
                getIBand2(E, JSet, IBD);
                //UBD = getUBand(E, JSet);
                //IBD = getIBand(E, JSet);
                for(unsigned int i=0; i<E.EnsembleSize; ++i){
                    if((JSet[0] == i) || (JSet[1] == i))
                        continue;
                        //Matrix<int> current = E.Members[i];
                        //UPercents(i,j) = getPercentBinarySubset(current, UBD);
                        //IPercents(i,j) = getPercentBinarySubset(IBD, current);
                    UPercents(i,j) = double(getBinaryIntersectSum(E.Members[i], UBD))/double(E.Members[i].getSum());//getPercentBinarySubset(E.Members[i], UBD);
                    IPercents(i,j) = double(getBinaryIntersectSum(IBD, E.Members[i]))/double(IBD.getSum());//getPercentBinarySubset(IBD, E.Members[i]);
                }
        }
}

void CBD::getTimePercents(unsigned int num, vector<unsigned int> Frcst){
    if((E.getSize())%num != 0){
        cerr << "size mismatch: " << E.getSize() << ", " << num << endl;
        exit(-1);
    }

    Matrix<int> Combinations = getCombinationMatrix(num, numJ);
    Matrix<int> UBD = Matrix<int>(E.Xdim, E.Ydim);
    Matrix<int> IBD = Matrix<int>(E.Xdim, E.Ydim);

    Matrix<double> UEnumerator = Matrix<double>(num, Combinations.getXdim(), 0.0), UDenumerator = Matrix<double>(num, Combinations.getXdim(), 0.0);
    Matrix<double> IDenumerator = Matrix<double>(num, Combinations.getXdim(), 0.0), IEnumerator = Matrix<double>(num, Combinations.getXdim(), 0.0);
    UPercents = Matrix<double>(num, Combinations.getXdim(), 0.0);
    IPercents = Matrix<double>(num, Combinations.getXdim(), 0.0);

    //#pragma omp parallel for schedule(dynamic,1)
    for(int i=0; i<Frcst.size(); i++){
        for(unsigned int j=0; j<Combinations.getXdim(); ++j){
                vector<int> JSet; JSet.push_back(Combinations(j,0)-1+num*i); JSet.push_back(Combinations(j,1)-1+num*i);
                UBD = getUBand(E, JSet);
                IBD = getIBand(E, JSet);
                for(unsigned int k=0; k<num; ++k){
                        if((JSet[0] == (i*num+k)) || (JSet[1] == (i*num+k)))
                            continue;
                        Matrix<int> current = E.Members[i*num+k];
                        UEnumerator(k,j) += double(getBinaryIntersect(current, UBD).getSum());//(-.5)*double((AddConstant(MaxMatrix(current, UBD),-1).getSum()));
                        UDenumerator(k,j) += double(current.getSum());//(-.5)*double((AddConstant(current,-1).getSum()));

                        IEnumerator(k,j) += double(getBinaryIntersect(IBD, current).getSum());//(-.5)*double((AddConstant(MaxMatrix(IBD, current),-1).getSum()));
                        IDenumerator(k,j) += double(IBD.getSum());//(-.5)*double((AddConstant(IBD,-1).getSum()));
                }
        }
    }
    for(int i=0; i<num; i++)
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

double CBD::getThreshold(int outlierNum){
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
    if(Probs.size() != 0)
        cout<<"The probabilities are about to be overwritten"<<endl;
    Probs.clear();
    double temp;
    PThreshold = PThreshold;
    for(unsigned int i=0; i<UPercents.getXdim(); ++i){
        temp = 0.0;
        for(unsigned int j=0; j<UPercents.getYdim(); ++j)
            temp += (((UPercents(i,j) >= PThreshold) && (IPercents(i,j) >= PThreshold))? 1.0 : 0.0);
        Probs.push_back(temp/double(UPercents.getYdim()));
    }
}

void CBD::WriteSortedProbabilities(string fileName){
    ofstream data(fileName.c_str());
    int counter = Probs.size();
    vector<int> SortedIndices = getSortedIndex(Probs);
    vector<double> SortedProbs = Probs;
    sort(SortedProbs.begin(), SortedProbs.end());
    while(--counter>= 0)
        data << SortedProbs[counter] << "\t" << SortedIndices[counter] << endl;;
}

Matrix<int> getMask(Matrix<int> m){
    Matrix<int> toReturn = Matrix<int>(m.getXdim(), m.getYdim());
    for(int i=0; i<toReturn.getXdim(); i++)
        for(int j=0; j<toReturn.getYdim(); j++)
            toReturn(i,j) = int((m(i,j)-1)*.5);
    return toReturn;
}

Matrix<int> CBD::getBandMask(const Ensemble e, vector<int> v){
    for(int i=0; i<v.size(); i++)
        cout << v[i] << ", ";
    cout << endl << "E size " << e.getSize() << endl;
    Matrix<int> U = getUBand(e, v);
    Matrix<int> I = getIBand(e, v);
    Matrix<int> toReturn = Matrix<int>(U.getXdim(), U.getYdim(), 0);

    for(int i=0; i<toReturn.getXdim(); i++)
        for(int j=0; j<toReturn.getYdim(); j++){
            toReturn(i,j) = int((U(i,j) - I(i,j)));
        }
    return toReturn;
}

Matrix<int> CBD::getTrimmedMean(Ensemble e, vector<int> v){
    Matrix<double> TMean = Matrix<double>(e.getXdim(), e.getYdim(), 0.0);
    Matrix<int> toReturn = Matrix<int>(e.getXdim(), e.getYdim(), 0);
    Matrix<int> current = Matrix<int>(e.getXdim(), e.getYdim(), 0);
    //cout<<"v size:" << v.size()<<endl;
    for(int k=0; k<v.size(); k++){
        current = e.Members[v[k]];
        for(int i=0; i<e.getXdim(); i++)
            for(int j=0; j<e.getYdim(); j++)
                TMean(i,j) = TMean(i,j) + double(current(i,j))/double(v.size());
    }

    for(int i=0; i<e.getXdim(); i++)
        for(int j=0; j<e.getYdim(); j++){
            if(TMean(i,j) >= .5)
                toReturn(i,j) = 1;
        }
    return toReturn;
}

void CBD::genAnimation(string des_dir, double xmin, double ymin, double xmax, double ymax){
    stringstream ss;
    string filename = "";
    //string map_filename = "map.svg"; //TODO: not be hard coded

    ss << des_dir << "anim_" << E.getGridRes() << ".svg";
    filename = ss.str();

    ofstream data(filename.c_str());

    if(!data.is_open()){
        cerr << "bad SVG Filename: " << filename << endl;
        exit(-1);
    }

    //data << "<svg version=\"1.1\" baseProfile=\"tiny\" id=\"svg-root\"" << endl ;
    //data << "width=\""  << E.getXdim() << "\" height=\"" << E.getYdim() << "\" viewBox=\"0 0 " << E.getYdim() << " " << E.getXdim() << "\"" << endl;
    data << "<svg version=\"1.1\" baseProfile=\"tiny\" id=\"svg-root\" width=\"" << xmax-xmin <<"\" height=\"" << ymax-ymin << "\" viewBox=\"" << 0 << " " << 0 << " " << xmax-xmin << ", " << ymax-ymin << "\"" << endl;
    data << "xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">" << endl;

    //putting map
    data << "<g transform=\"scale(1,-1)\">" << endl;
    data << "<image x=\"0\" y=\""<< -(ymax-ymin) << "\" width=\"" << xmax-xmin << "\" height=\"" << ymax-ymin << "\" xlink:href=\"map_" << E.gridRes << ".svg\" />" << endl;
    data << "</g>" << endl;

    for(int k=0; k<=29; k++){
        //data << "<image width=\"" << E.getXdim() << "\" height=\"" << E.getYdim() << "\" xlink:href=\""<< "./weather_" << E.getGridRes() << "_" << 3*k << ".svg" << "\">" << endl;
        data << "<image width=\"" << xmax-xmin << "\" height=\"" << ymax-ymin << "\" xlink:href=\""<< "./weather_" << E.getGridRes() << "_" << 3*k << ".svg" << "\">" << endl;
        ss.str(string());
        ss.clear();
        for(int j=0; j<=29; j++){
            if(j==k)
                ss << "inline;";
            else
                ss << "none;";
        }
        data << "     <animate id='frame_" << k/3 << "' attributeName='display' values='" << ss.str() <<"'" << endl;
        data << "     dur='6s' fill='freeze' begin=\"" << 0 << "s\" repeatCount=\"indefinite\"/></image>" << endl;

        data << "<text x=\"" << (xmax-xmin)/6.0 << "\" y=\"" << (ymax-ymin)*9.0/10.0 << "\" fill=\"black\">Forecast hour:" << k*3 << endl;
        data << "     <animate id='frame_" << k/3 << "' attributeName='display' values='" << ss.str() <<"'" << endl;
        data << "     dur='6s' fill='freeze' begin=\"" << 0 << "s\" repeatCount=\"indefinite\"/></text>" << endl;
    }
    data << "</svg>" << endl;
    data.close();
}

void CBD::genSVG(int outlierNum, string des_dir, double xmin, double ymin, double xmax, double ymax){
    vector<unsigned int> Frcst; //TODO: not hard coded
    Ensemble currentEnsemble;
    stringstream ss;
    string filename = "";
    unsigned int num = 21;//TODO: not hard code
    cout << "about to start SVG-----------------" << endl;
    //return;

    for(int k=0; k<=29; k++){
        Frcst.clear(); Frcst.push_back(k*3);
        currentEnsemble.InitializeEnsemble(num, E.LevelSet, E.gridRes);
        currentEnsemble.LoadFieldEnsemble(Dir, Frcst, MRun);
        ss.str(string());
        ss.clear();
        ss << des_dir << "weather_" << E.getGridRes() << "_" << Frcst[0] << ".svg";
        filename = ss.str();
        cout << ss.str() << endl;

        cout << xmin << ", " << ymin << ", " << xmax << ", " << ymax << endl;


        //InitializeSVG(filename, 12, 12, E.Xdim, E.Ydim);
        InitializeSVG(filename, 0, 0, xmax-xmin, ymax-ymin, E.gridRes);

        vector<int> SortedIndices = getSortedIndex(Probs);
        vector<double> SortedProbs = Probs;
        sort(SortedProbs.begin(), SortedProbs.end());

        Matrix<int> mask = Matrix<int>(E.getXdim(), E.getYdim());

        cout << "about t odraw" << endl;

        //*******************
        //***Drawing outliers
        //*******************

        for(int i=0; i<outlierNum; i++){
            mask = currentEnsemble.Members[SortedIndices[i]];
            DrawCCSilhouette(filename, mask, "red", 1, "dash", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());
        }
        cout<<"done drawing outliers"<<endl;

        //********************
        //***Draw envelop
        //********************
        vector<int> envelop (SortedIndices.begin()+outlierNum, SortedIndices.end());
        mask = getBandMask(currentEnsemble, envelop);
        //cout<< "got envelop" << endl;
        //WriteMatrixFile(mask, "envelop.txt");
        DrawConnectedComp(filename, mask, "#bbbbff", 1, .5, lon, lat, xmin, ymin, true);
        cout<<"done drawing envelop"<<endl;


        //********************
        //***Drawing band
        //********************
        vector<int> BWidth (SortedIndices.end()-floor(SortedIndices.size()/2), SortedIndices.end());
        //cout << "Band Width" << endl;
        //for(int i=0; i<BWidth.size(); i++)
        //    cout << BWidth[i] << ", ";
        //cout << endl << E.EnsembleSize << endl;
        mask = getBandMask(currentEnsemble, BWidth);//getUBand(BWidth);
        WriteMatrixFile(mask, "band.txt");
        DrawConnectedComp(filename, mask, "#8888bb", 1, .5, lon, lat, xmin, ymin, true);
        cout<<"done drawing band"<<endl;

        //********************
        //***Drawing Trimmead mean
        //********************
        vector<int> vv (SortedIndices.begin(), SortedIndices.end());
        mask = getTrimmedMean(currentEnsemble, vv);
        DrawCCSilhouette(filename, mask, "#cc00ff", 1, "fill", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());
        //WriteMatrixFile(mask, "junk.txt");
        cout<<"done drawing the trimmed mean"<<endl;

        //******************
        //***Drawing median
        //******************
        mask = currentEnsemble.Members[SortedIndices.back()];
        WriteMatrixFile(mask, "median.txt");
        //cout << "med index: " << SortedIndices.back() << endl;
        DrawCCSilhouette(filename, mask, "yellow", 1, "fill", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());

        CloseSVGFile(filename);
    }
}

void CBD::genSVG(vector<unsigned int> Frcst, int outlierNum, double xmin, double ymin){
    stringstream ss;
    string filename = "";
    int num = 21;//TODO: not hard coded
    for(int f=0; f<Frcst.size(); f++){
        ss.str(string());
        ss.clear();
        ss << "weather_" << Frcst[f] << ".svg";
        filename = ss.str();


        InitializeSVG(filename, 12, 12, E.Xdim, E.Ydim, E.gridRes);
        //vector<IntPairVector> contour;

        vector<int> SortedIndices = getSortedIndex(Probs);
        vector<double> SortedProbs = Probs;
        sort(SortedProbs.begin(), SortedProbs.end());

        Matrix<int> mask = Matrix<int>(E.getXdim(), E.getYdim());

        //*******************
        //***Drawing outliers
        //*******************
        for(int i=0; i<outlierNum; i++){
            mask = E.Members[f*num + SortedIndices[i]];
            DrawCCSilhouette(filename, mask, "red", 1, "dash", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());
        }
        cout<<"done drawing outliers"<<endl;

        //********************
        //***Draw envelop
        //********************
        vector<int> envelop (SortedIndices.begin()+outlierNum, SortedIndices.end());
        for(int i=0; i<envelop.size(); i++)
            envelop[i] = envelop[i] + f*num;
        mask = getBandMask(E, envelop);
        DrawConnectedComp(filename, mask, "#bbbbff", 1, .5, lon, lat, xmin, ymin, true);
        cout<<"done drawing envelop"<<endl;

        //********************
        //***Drawing band
        //********************
        vector<int> BWidth (SortedIndices.end()-floor(SortedIndices.size()/2), SortedIndices.end());
        for(int i=0; i<BWidth.size(); i++)
            BWidth[i] = BWidth[i] + f*num;
        mask = getBandMask(E, BWidth);//getUBand(BWidth);

        DrawConnectedComp(filename, mask, "#8888bb", 1, .5, lon, lat, xmin, ymin, true);
        cout<<"done drawing band"<<endl;

        //********************
        //***Drawing Trimmead mean
        //********************
        vector<int> vv (SortedIndices.begin(), SortedIndices.end());
        for(int i=0; i<vv.size(); i++)
            vv[i] = vv[i] + f*num;
        mask = getTrimmedMean(E, vv);
        DrawCCSilhouette(filename, mask, "#cc00ff", 1, "fill", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());
        cout<<"done drawing the trimmed mean"<<endl;

        //******************
        //***Drawing median
        //******************
        mask = E.Members[f*num + SortedIndices.back()];

        DrawCCSilhouette(filename, mask, "yellow", 1, "fill", "none", lon, lat, xmin, ymin, true, E.getXdim(), E.getYdim());

        CloseSVGFile(filename);
    }
}

void CBD::genBinaryFields(int outlierNum, string des_dir, double xmin, double ymin, double xmax, double ymax){
    vector<unsigned int> Frcst; //TODO: not hard coded
    Ensemble currentEnsemble;
    stringstream ss;
    string filename = "";
    unsigned int num = 21;//TODO: not hard code
	
	std::stringstream ssfhr;
	string fhr = "";
	
    cout << "---------- GENERATE BINARY FIELDS ---------" << endl;
    //return;

    for(int k=0; k<=29; k++){
        Frcst.clear(); Frcst.push_back(k*3);
        currentEnsemble.InitializeEnsemble(num, E.LevelSet, E.gridRes);
        currentEnsemble.LoadFieldEnsemble(Dir, Frcst, MRun);
        //ss.str(string());
        //ss.clear();
        //ss << des_dir << "weather_" << E.getGridRes() << "_" << Frcst[0] << ".svg";
        //filename = ss.str();
        //cout << ss.str() << endl;
		
		ssfhr.str(string());
		ssfhr.clear();
		ssfhr << std::setw(2) << std::setfill('0') << Frcst[0];
		fhr = ssfhr.str();

        //cout << xmin << ", " << ymin << ", " << xmax << ", " << ymax << endl;


        //InitializeSVG(filename, 12, 12, E.Xdim, E.Ydim);
        //InitializeSVG(filename, 0, 0, xmax-xmin, ymax-ymin, E.gridRes);

        vector<int> SortedIndices = getSortedIndex(Probs);
        vector<double> SortedProbs = Probs;
        sort(SortedProbs.begin(), SortedProbs.end());

        Matrix<int> mask = Matrix<int>(E.getXdim(), E.getYdim());

        //cout << "about to draw" << endl;

        //*******************
        //***Drawing outliers
        //*******************
		// for(int i=0; i<outlierNum; i++){
		// 	mask = currentEnsemble.Members[SortedIndices[i]];
		// 	ss.str(string());
		// 	ss.clear();
		// 	ss << des_dir << "outlier_" << i << "_gridRes_" << E.getGridRes() << "_f" << fhr << ".csv";
		// 	filename = ss.str();
		// 	cout << "generating: " << filename << endl;
		// 	WriteMatrixLinesFile(mask, filename);
		// }

        //********************
        //***Draw envelop
        //********************
        vector<int> envelop (SortedIndices.begin()+outlierNum, SortedIndices.end());
        mask = getBandMask(currentEnsemble, envelop);
		
		ss.str(string());
        ss.clear();
        ss << des_dir << "envelop" << "_gridRes_" << E.getGridRes() << "_f" << fhr << ".csv";
        filename = ss.str();
        cout << "generating: " << filename << endl;
		WriteMatrixLinesFile(mask, filename);


        //********************
        //***Drawing band
        //********************
        vector<int> BWidth (SortedIndices.end()-floor(SortedIndices.size()/2), SortedIndices.end());
        mask = getBandMask(currentEnsemble, BWidth);
		
		ss.str(string());
        ss.clear();
        ss << des_dir << "band" << "_gridRes_" << E.getGridRes() << "_f" << fhr << ".csv";
        filename = ss.str();
        cout << "generating: " << filename << endl;
		WriteMatrixLinesFile(mask, filename);

        //********************
        //***Drawing Trimmed mean
        //********************
        // vector<int> vv (SortedIndices.begin(), SortedIndices.end());
        // mask = getTrimmedMean(currentEnsemble, vv);
        //
		// ss.str(string());
        // ss.clear();
        // ss << des_dir << "trimmedMean" << "_gridRes_" << E.getGridRes() << "_f" << fhr << ".csv";
        // filename = ss.str();
        // cout << "generating: " << filename << endl;
		// WriteMatrixLinesFile(mask, filename);
		

        //******************
        //***Drawing median
        //******************
		// mask = currentEnsemble.Members[SortedIndices.back()];
		//
		// ss.str(string());
		// ss.clear();
		// ss << des_dir << "median" << "_gridRes_" << E.getGridRes() << "_f" << fhr << ".csv";
		// filename = ss.str();
		// cout << "generating: " << filename << endl;
		// WriteMatrixLinesFile(mask, filename);

        //CloseSVGFile(filename);
    }
}



