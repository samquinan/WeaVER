#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

// haines.cpp -- generates haines index fields (see http://www.k3jae.com/wxHaines.php for a nice overview of what that is) for each ensemble member

// convenience structure so I could use std::transform
struct to_upper {
  int operator() ( int ch )
  {
    return std::toupper ( ch );
  }
};

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int stability_L(double diff){ 
	int s;
	if(diff < 4) s = 1;
	else if (diff < 8) s = 2;
	else s = 3;
	return s;
}

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int stability_M(double diff){ 
	int s;
	if(diff < 6) s = 1;
	else if (diff < 11) s = 2;
	else s = 3;
	return s;
}

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int stability_H(double diff){ 
	int s;
	if(diff < 18) s = 1;
	else if (diff < 22) s = 2;
	else s = 3;
	return s;
}

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int moisture_L(double diff){ 
	int m;
	if(diff < 6) m = 1;
	else if (diff < 10) m = 2;
	else m = 3;
	return m;
}

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int moisture_M(double diff){ 
	int m;
	if(diff < 6) m = 1;
	else if (diff < 13) m = 2;
	else m = 3;
	return m;
}

// stability and mouiture term functions for low (L), mid (M), and High (H) elevations  
int moisture_H(double diff){ 
	int m;
	if(diff < 15) m = 1;
	else if (diff < 21) m = 2;
	else m = 3;
	return m;
}

int main(int argc, char* argv[])
{
	if (argc != 7) {
	        std::cerr << "Usage: " << argv[0] << " TMP_LOW_DIR TMP_HIGH_DIR DPT_DIR RUN ELEVATION OUT_DIR" << std::endl;
			std::cerr << "\t where ELEVATION takes one of: -L, -M, -H" << std::endl;
	        return 1;
	}
	
	// INITIALIZATION
	
	int retval=0;
	
	std::vector<std::string> models{"arw", "nmb"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "n4", "n5", "n6", "p1", "p2", "p3", "p4", "p5", "p6"};
	
	// // accurate for datasets from before the 10/21/2015 SREF update
	// std::vector<std::string> models{"em", "nmb", "nmm"};
	// std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
		
	std::string tmp1Dir = argv[1];
	std::string tmp2Dir = argv[2];
	std::string dptDir = argv[3];
	std::string outDir = argv[6];
	
	// process the run string
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[4]);
	std::string run = sstmp.str();
		
	// process the elevation flag
	std::string elev_flag = argv[5];
	std::transform(elev_flag.begin(), elev_flag.end(), elev_flag.begin(), to_upper());
	int elevation = -1;
	if (elev_flag == "-L"){
		elevation = 0;
	}
	else if (elev_flag == "-M"){
		elevation = 1;
	}
	else if (elev_flag == "-H"){
		elevation = 2;
	}
	else {
		std::cerr << "ELEVATION " << argv[4] << " not one of: -L, -M, -H" << std::endl;
		return 1;
	}
		
	// PROCESSING ROUTINE
	std::cout << "haines: processing..." << std::endl;
	
	//for each forecast hour 
	int h;
	for(h=0; h <= 87; h += 3){
		
		//generate forecast hour string
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		std::string fhr = sstmp.str();
		
		//for each ensemble member
		for (int m=0; m < models.size(); m++){
			for (int p=0; p < perturbations.size(); p++){
				std::vector <double> tmp1;
				std::vector <double> tmp2;
				std::vector <double> dpt;
				
				//generate filename for member / forucast hour
				sstmp.str(std::string());
				sstmp.clear();
				sstmp << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				std::string filename =  sstmp.str();
				
				//read low temp
				std::ostringstream file;
				file << tmp1Dir << filename;				
				if (!readFileToVector(file.str().c_str(), tmp1)){
					std::cerr << "Error reading file: " << file.str() << std::endl;
					retval = 1;
					continue;
				}
				
				//read high temp
				file.str(std::string());
				file.clear();
				file << tmp2Dir << filename;
				if (!readFileToVector(file.str().c_str(), tmp2)){
					std::cerr << "Error reading file: " << file.str() << std::endl;
					retval = 1;
					continue;
				}
				
				//read dew point				
				file.str(std::string());
				file.clear();
				file << dptDir << filename;
				if (!readFileToVector(file.str().c_str(), dpt)){
					std::cerr << "Error reading file: " << file.str() << std::endl;
					retval = 1;
					continue;
				}
				
				//sanity check -- Inputs Same Size
				int s = tmp1.size();
				if ((tmp2.size() != s)&&(dpt.size() != s)){
					 std::cerr << "Error: input files not of same size" << std::endl;
					 retval = 1;
					 continue;
				}
				
				//Calculate Haines Index
				std::vector <int> haines;
				for (int i=0; i < s; i++){
					int stability, moisture;
					switch (elevation){
						case 0:
							stability = stability_L( tmp1[i] - tmp2[i] );
							moisture  =  moisture_L( tmp2[i] - dpt[i]  );
							break;
						case 1:
							stability = stability_M( tmp1[i] - tmp2[i] );
							moisture  =  moisture_M( tmp1[i] - dpt[i]  );
							break;
						case 2:
							stability = stability_H( tmp1[i] - tmp2[i] );
							moisture  =  moisture_H( tmp1[i] - dpt[i]  );
							break;
						default:
							break;
					}
					haines.push_back((stability + moisture));	
				}
				
				// WRITE OUT
				file.str(std::string());
				file.clear();
				file << outDir << filename;
				writeVectorToFile(file.str().c_str(), haines);
			}
		}
						
	}
	std::cout << "haines: completed" << std::endl;
	return retval;
}