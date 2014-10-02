#include "SVG.h"

void InitializeSVG(string SVGfname, int width, int height){

    ofstream data(SVGfname.c_str());

    if(!data.is_open()){
        cerr << "bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    data << "<?xml version=\"1.0\" standalone=\"no\"?>" << endl;
    data << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"" << endl;
    data << "  \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">" << endl;
    data << "<svg width=\"" << width <<"\" height=\"" << height << "\"" << endl;
    data << "     xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink= \"http://www.w3.org/1999/xlink\" version=\"1.1\">" << endl << endl;
    data.close();
}

void InitializeSVG(string SVGfname, double xmin, double ymin, double xmax, double ymax, double gridRes){

    ofstream data(SVGfname.c_str());

    if(!data.is_open()){
        cerr << "bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    data << "<?xml version=\"1.0\" standalone=\"no\"?>" << endl;
    data << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"" << endl;
    data << "  \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">" << endl;
    //data << "<svg width=\"" << width <<"cm\" height=\"" << height << "cm\" "  << "viewBox=\"" << 0 << " " << 0 << " " << xmax << " " << ymax << "\" " << endl;
    data << "<svg width=\"" << xmax-xmin <<"\" height=\"" << ymax-ymin << "\" viewBox=\"" << xmin << " " << -(ymax-ymin) << " " << xmax-xmin << ", " << ymax-ymin << "\"" << endl;
    data << "     xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink= \"http://www.w3.org/1999/xlink\" version=\"1.1\">" << endl << endl;
    data << "<g transform=\"scale(1,-1)\">" << endl;
    data << "<image x=\"0\" y=\"0\" width=\"" << xmax-xmin << "\" height=\"" << ymax-ymin << "\" xlink:href=\"map_" << gridRes << ".svg\" />" << endl;
    //data << "<g id=\"00\" transform=\" translate(-" << floor(xmax/2) << ", -" << ymax << ") scale(1.9,2.1) rotate(10 " << floor(xmax/2) << " " << floor(ymax/2) << ")\">" << endl;
    data.close();
}


void AddSVGBG(char* SVGfname, char* BGfname, int x, int y, int width, int height){
    ofstream data;
    data.open(SVGfname, std::ofstream::out | std::ofstream::app);

    if(!data.is_open()){
        cerr << "Bad SVG file name: " << SVGfname << endl;
        exit(-1);
    }

    data << "<image x=\"" << x <<"\" y=\"" << y <<
            "\" width=\"" << width <<"\" height=\"" << height <<
            "\" xlink:href=\"./" << BGfname << "\"/>" <<endl;// << test_map.svg" transform="scale(.4)"/>" << endl;
    data.close();
}

void DrawSVGIntPath(string SVGfname, vector<IntPairVector> PS, char* strokeColor, double strokeWidth, char* StrokeType, char* fill, bool smooth, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin){
    if(PS.size()<=1)
        return;

    //cout << "****got here" << endl;

    ofstream data;
    data.open(SVGfname.c_str(), std::ofstream::out | std::ofstream::app);

    if(!data.is_open()){
        cerr << "Bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    /*
    vector<IntPairVector> Pset;

    //TODO: optimize
    if(smooth)
        Pset = SmoothPath(PS);
    else{
        for(int i=0; i<PS.size(); i++)
        Pset.push_back(PS[i]);
    }
    */
    vector<DoublePairVect> Pset;
    //cout << "about to draw path:" << xmin << ", " << ymin << endl;

    for(int i=0; i<PS.size(); i++)
        Pset.push_back(make_pair(lon(PS[i].first, PS[i].second), lat(PS[i].first, PS[i].second)));

    if(smooth)
        Pset = SmoothPath(Pset);

    //Pset = getMapProjSphere(Pset);

    //cout << "here" << xmin << ", " << ymin << endl;

    printf("\n%s,%d\n", StrokeType, strcmp(StrokeType, "dash"));
    if(strcmp(StrokeType, "dash") == 0)
        data << "<path stroke-dasharray=\"2,2\" fill = \"" << fill <<
                "\" d=\"M" << Pset[0].first-xmin << "," << Pset[0].second-ymin;// << "\"" << endl;
    else
        data << "<path  fill = \"" << fill <<
                "\" d=\"M" << Pset[0].first-xmin << "," << Pset[0].second-ymin;// << endl;

        for(int i=1; i<Pset.size(); i++)
            data << endl << "            L" << Pset[i].first-xmin << ", " << Pset[i].second-ymin;// << endl;

        //data << endl << "            L" << Pset[0].first-xmin << ", " << Pset[0].second-ymin;// << endl;

    //make it conncet to the first point
    data << endl << "            L" << Pset.back().first-xmin << ", " << Pset.back().second-ymin << "\"" << endl;

    data << "            stroke = \"" << strokeColor << "\" stroke-width = \"" <<
            strokeWidth << "\" stroke-linejoin=\"round\"/>" << endl;
    data.close();
}


void DrawSVGIntPath(string SVGfname, vector<IntPairVector> PS, char* strokeColor, double strokeWidth, char* StrokeType, char* fill, bool smooth, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, unsigned int Xdim, unsigned int Ydim){
    if(PS.size()<=1)
        return;

    ofstream data;
    data.open(SVGfname.c_str(), std::ofstream::out | std::ofstream::app);

    if(!data.is_open()){
        cerr << "Bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    //bool path_end = true;
    vector<IntPairVector> Pset;
    IntPairVector border = make_pair(Xdim-1, Ydim-1);
    unsigned int state = -1, initial_state = getState(PS[0], PS[1], border);

    PS.push_back(PS[0]);
    for(int i=1; i<PS.size(); i++){
        state = getState(PS[i-1], PS[i], border);
        //cout << state << ", ";
        if(state == OnPath){
            Pset.push_back(make_pair(PS[i-1].first, PS[i-1].second));
            Pset.push_back(make_pair(PS[i].first, PS[i].second));
        }else if(state == OnBorder){
            continue;
        }else if(state == StartPath){
            Pset.clear();
            Pset.push_back(make_pair(PS[i-1].first, PS[i-1].second));
            Pset.push_back(make_pair(PS[i].first, PS[i].second));
        }else if(state == FinishPath){
            Pset.push_back(make_pair(PS[i-1].first, PS[i-1].second));
            Pset.push_back(make_pair(PS[i].first, PS[i].second));
            //cout << Pset.size() << endl;
            DrawSVGIntPath(SVGfname, Pset, strokeColor, strokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin);
        }
        //cout << endl;
    }

    if(initial_state == OnPath){
        //Pset.push_back(Pset[0]);
        DrawSVGIntPath(SVGfname, Pset, strokeColor, strokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin);
    }

    /*
    //cout << "*: " << PS.size() << endl;
    for(int i=1; i<PS.size(); i++){
        if(!IsOnBorder(PS[i], border)){
            path_end = false;
            Pset.push_back(make_pair(PS[i].first, PS[i].second));
        }else{
            if(path_end)
                continue;
            else{
                Pset.push_back(make_pair(PS[i].first, PS[i].second));
                path_end = true;
                //cout << Pset.size() << endl;
                DrawSVGIntPath(SVGfname, Pset, strokeColor, strokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin);
                Pset.clear();
            }
        }
    }

    if(path_end == false){
        //Pset.push_back(make_pair(Pset[0].first, Pset[0].second));
        DrawSVGIntPath(SVGfname, Pset, strokeColor, strokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin);
    }
    */
}

void FillPolygon(string SVGfname, vector<IntPairVector> PS, char* fillColor, char* StrokeColor, double StrokeWidth, double opacity, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, bool smooth){
    if( PS.size()<=2 )
        return;

    /*
    //TODO: optimize
    vector<IntPairVector> Pset;
    if(smooth)
        Pset = SmoothPath(PS);
    else{
        for(int i=0; i<PS.size(); i++)
        Pset.push_back(PS[i]);
    }
    */

    vector<DoublePairVect> Pset;
    //cout << "about to draw path:" << xmin << ", " << ymin << endl;

    for(int i=0; i<PS.size(); i++)
        Pset.push_back(make_pair(lon(PS[i].first, PS[i].second), lat(PS[i].first, PS[i].second)));

    if(smooth)
        Pset = SmoothPath(Pset);

    //for(int i=0; i<Pset.size(); i++){
    //    cout << Pset[i].first << ", " << Pset[i].second << ": " << PS[i].first << ", " << PS[i].second << endl;
    //}

    //Pset = getMapProjSphere(Pset);

    //for(int i=0; i<Pset.size(); i++)
    //    cout << Pset[i].first << ", " << Pset[i].second << ": " << lon(PS[i].first, PS[i].second) << ", " << lat(PS[i].first, PS[i].second) << ":: " << PS[i].first << ", " << PS[i].second << endl;

    //cout << "here" << xmin << ", " << ymin << endl;

    ofstream data;
    data.open(SVGfname.c_str(), std::ofstream::out | std::ofstream::app);

    if(!data.is_open()){
        cerr << "Bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    data << endl << "<polygon fill=\"" << fillColor << "\" stroke=\"" << StrokeColor << "\" stroke-width=\"" << StrokeWidth
         << "\" stroke-linejoin=\"round\" stroke-opacity=\"" << opacity << "\" fill-opacity=\"" << opacity << "\""
         << endl;
    data << "    points=\"" << Pset[0].first-xmin << "," << Pset[0].second-ymin << endl;
    for(int i=1; i<Pset.size(); i++)
        data << "     " << Pset[i].first-xmin << "," << Pset[i].second-ymin << endl;

    data << "      " << Pset.back().first-xmin << "," << Pset.back().second-ymin << "\"/>" << endl;
    data.close();
}

vector<IntPairVector> SmoothPath(vector<IntPairVector> v){
    vector<IntPairVector> temp;
    temp.push_back(v[0]);

    for(int i=0; i<v.size()-1; i++)
        temp.push_back(make_pair(int((v[i].first+v[i+1].first)/2.0),int((v[i].second+v[i+1].second)/2.0)));
    temp.push_back(v.back());
    return temp;
}

vector<DoublePairVect> SmoothPath(vector<DoublePairVect> v){
    vector<DoublePairVect> temp;
    temp.push_back(v[0]);

    for(int i=0; i<v.size()-1; i++)
        temp.push_back(make_pair((v[i].first+v[i+1].first)/2.0,(v[i].second+v[i+1].second)/2.0));
    temp.push_back(v.back());
    return temp;
}

void DrawConnectedComp1(string SVGfname, Matrix<int> m, char *StrokeColor, double StrokeWidth, double opacity, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, bool smooth){
    Matrix<int> mask = getCCLabeling(m, false);
    WriteMatrixFile(mask,"CC_CC.txt");
    int maxVal = 0;
    maxVal = mask.getMax();
    //cout << "CC max val: " << maxVal << endl;
    vector<IntPairVector> contour;
    Matrix<int> temp;

    //string ff = "b";
    for(int k=1; k<=maxVal; k++){
        contour.clear();
        temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
        for(int i=0; i<temp.getXdim(); i++)
            for(int j=0; j<temp.getYdim(); j++)
                if(mask(i,j) == k)
                    temp(i,j) = 1;
        //if(k==6){
        //    WriteMatrixFile(temp, "check.txt");
        //if(CCWithHole(temp))
            //cout << "HOOOOOLE: " << k << endl;
        //}

        contour = MooreNeighborTracingIndx(temp);
        FillPolygon(SVGfname, contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
    }
}

void DrawConnectedComp(string SVGfname, Matrix<int> m, char *StrokeColor, double StrokeWidth, double opacity, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, bool smooth){
    Matrix<int> mask = getCCLabeling(m, false);
    WriteMatrixFile(mask,"CC_CC.txt");
    Matrix<int> recip_mask = Matrix<int>(m.getXdim(), m.getYdim(), 0);
    int maxVal = 0, recip_max = 0;
    maxVal = mask.getMax();
    //cout << "CC max val: " << maxVal << endl;
    vector<IntPairVector> contour, inner_contour;
    Matrix<int> temp, recip_temp;

    //string ff = "b";
    for(int k=1; k<=maxVal; k++){
        contour.clear();
        temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
        for(int i=0; i<temp.getXdim(); i++)
            for(int j=0; j<temp.getYdim(); j++)
                if(mask(i,j) == k)
                    temp(i,j) = 1;
        contour = MooreNeighborTracingIndx(temp);
        //if(!ContourHitsEdge(contour, temp.getXdim(), temp.getYdim())){
        bool WithHole = false;
        if(CCWithHole(temp)){
            //FillPolygon(SVGfname, contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
            cout << "**HOOOOOLE: " << k << endl;
            recip_mask = getCCLabeling(temp, true);
            recip_max = recip_mask.getMax();
            if(k==2)
            WriteMatrixFile(recip_mask, "recip_mask.txt");
            for(int l=1; l<=recip_max; l++){
                inner_contour.clear();
                recip_temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
                for(int i=0; i<recip_temp.getXdim(); i++)
                    for(int j=0; j<recip_temp.getYdim(); j++)
                        if(recip_mask(i,j) == l)
                            recip_temp(i,j) = 1;
                inner_contour = MooreNeighborTracingIndx(recip_temp);
                if(!ContourHitsEdge(inner_contour, temp.getXdim(), temp.getYdim())){
                    WithHole = true;
                }
            }
            if(WithHole){
                for(int l=1; l<=recip_max; l++){
                    inner_contour.clear();
                    recip_temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
                    for(int i=0; i<recip_temp.getXdim(); i++)
                        for(int j=0; j<recip_temp.getYdim(); j++)
                            if(recip_mask(i,j) == l)
                                recip_temp(i,j) = 1;
                    inner_contour = MooreNeighborTracingIndx(recip_temp);
                    if(!ContourHitsEdge(inner_contour, temp.getXdim(), temp.getYdim())){
                        //cout << "about to cut polygon: " << l << ", " << k<< endl;
                        //cout << "CC hole-----" << endl;
                        double dist = 0.0, min_dist = 1000.0;
                         int min_indx = 0;
                         contour.push_back(contour[0]);
                         for(int h=0; h<contour.size(); h++){
                             dist = sqrt((inner_contour[0].first-contour[h].first)*(inner_contour[0].first-contour[h].first)+
                                         (inner_contour[0].second-contour[h].second)*(inner_contour[0].second-contour[h].second));
                             if(dist<min_dist){
                                 min_dist = dist;
                                 min_indx = h;
                             }
                             //cout << contour[h].first << ", " << contour[h].second << ", " << dist << endl;
                         }
                         /*
                         cout<<inner_contour[0].first << ", " << inner_contour[0].second << endl;
                         cout<<inner_contour.back().first << ", " << inner_contour.back().second << endl;
                         cout << contour[min_indx].first << ", " << contour[min_indx].second << endl;
                         cout << "min index: " << min_indx << ", " << contour.size() << endl;
                         cout << "inner_contour size: " << inner_contour.size() << ", " << contour.size() << endl;
                         */

                         inner_contour.push_back(inner_contour[0]);

                         // to add smoothnes
                         inner_contour.push_back(make_pair(int((inner_contour[0].first+contour[min_indx].first)/2), int((inner_contour[0].second+contour[min_indx].second)/2)));

                         for(int h=min_indx; h>=0; h--)
                             inner_contour.push_back(contour[h]);
                         for(int h=contour.size()-1; h>=min_indx; h--)
                            inner_contour.push_back(contour[h]);

                         // to add smoothnes
                         inner_contour.push_back(make_pair(int((inner_contour[0].first+contour[min_indx].first)/2), int((inner_contour[0].second+contour[min_indx].second)/2)));

                         inner_contour.push_back(inner_contour[0]);
                         //for(int i=0; i<inner_contour.size(); i++)
                         //    cout << inner_contour[i].first << ", " << inner_contour[i].second << endl;
                         FillPolygon(SVGfname, inner_contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
                        break;

                    }
                }
            }else{
                FillPolygon(SVGfname, contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
            }
        }else{
            contour = MooreNeighborTracingIndx(temp);
            FillPolygon(SVGfname, contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
        }
    //}else{
    //        FillPolygon(SVGfname, contour, StrokeColor, StrokeColor, StrokeWidth, opacity,lon, lat, xmin, ymin, smooth);
    //    }
    }
}

void DrawCCSilhouette1(string SVGfname, Matrix<int> m, char* StrokeColor, double StrokeWidth, char* StrokeType, char* fill, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, bool smooth, unsigned int Xdim, unsigned int Ydim){
    Matrix<int> mask = CCLabeling(m);
    int maxVal = 0;
    maxVal = mask.getMax();
    //cout << "sil maxval: " << maxVal << endl;
    vector<IntPairVector> contour;
    Matrix<int> temp;

    //string ff = "b";
    for(int k=1; k<=maxVal; k++){
        contour.clear();
        temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
        for(int i=0; i<temp.getXdim(); i++)
            for(int j=0; j<temp.getYdim(); j++)
                if(mask(i,j) == k)
                    temp(i,j) = 1;
        //if(CCWithHole(temp))
            //cout << "HOOOOOLE: " << k << endl;
        contour = MooreNeighborTracingIndx(temp);
        //cout << "contour sil: " << contour.size() << endl;
        DrawSVGIntPath(SVGfname, contour, StrokeColor, StrokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin);//, Xdim, Ydim);
    }
}

void DrawCCSilhouette(string SVGfname, Matrix<int> m, char* StrokeColor, double StrokeWidth, char* StrokeType, char* fill, Matrix<double> lon, Matrix<double> lat, double xmin, double ymin, bool smooth, unsigned int Xdim, unsigned int Ydim){
    Matrix<int> mask = getCCLabeling(m, false);
    Matrix<int> recip_mask = Matrix<int>(m.getXdim(), m.getYdim(), 0);
    WriteMatrixFile(mask,"CC_sil.txt");
    int maxVal = 0, recip_max = 0;
    maxVal = mask.getMax();
    //cout << "sil maxval: " << maxVal << endl;
    vector<IntPairVector> contour;
    Matrix<int> temp, recip_temp;

    //string ff = "b";
    for(int k=1; k<=maxVal; k++){
        contour.clear();
        temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
        for(int i=0; i<temp.getXdim(); i++)
            for(int j=0; j<temp.getYdim(); j++)
                if(mask(i,j) == k)
                    temp(i,j) = 1;
        if(CCWithHole(temp)){
            contour = MooreNeighborTracingIndx(temp);
            DrawSVGIntPath(SVGfname, contour, StrokeColor, StrokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin, Xdim, Ydim);
            //cout << "**HOOOOOLE: " << k << endl;
            recip_mask = getCCLabeling(temp, true);
            recip_max = recip_mask.getMax();
            //cout << "recip max " << recip_max << endl;
            //WriteMatrixFile(recip_mask, "recip_mask.txt");
            if(recip_max >= 3){
                for(int l=1; l<=recip_max; l++){
                    contour.clear();
                    recip_temp = Matrix<int>(m.getXdim(), m.getYdim(), 0);
                    for(int i=0; i<recip_temp.getXdim(); i++)
                        for(int j=0; j<recip_temp.getYdim(); j++)
                            if(recip_mask(i,j) == l)
                                recip_temp(i,j) = 1;
                    contour = MooreNeighborTracingIndx(recip_temp);
                    //cout <<"l-----"<< l << endl;
                    //for(int ll=0; ll<contour.size(); ll++)
                    //    cout << contour[ll].first << ", " << contour[ll].second << endl;
                    if(!ContourHitsEdge(contour, temp.getXdim(), temp.getYdim())){
                        //cout << "-----" << endl;
                        DrawSVGIntPath(SVGfname, contour, StrokeColor, StrokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin, Xdim, Ydim);
                    }
                }
            }
        }else{
            contour = MooreNeighborTracingIndx(temp);
            //cout << "contour sil: " << contour.size() << endl;
            DrawSVGIntPath(SVGfname, contour, StrokeColor, StrokeWidth, StrokeType, fill, smooth, lon, lat, xmin, ymin, Xdim, Ydim);
        }
    }
}

void CloseSVGFile(string SVGfname){
    ofstream data;
    data.open(SVGfname.c_str(), std::ofstream::out | std::ofstream::app);

    if(!data.is_open()){
        cerr << "Bad SVG Filename: " << SVGfname << endl;
        exit(-1);
    }

    data << endl << "</g>";
    data << endl << "</svg>";
    data.close();
}

