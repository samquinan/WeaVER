#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

// gen_wind_speed.cpp -- generates wind speed only for each member (needed to derive probabilities), again from the simulated wind u grid and v grid components

int main(int argc, char* argv[])
{
	//handle argument inputs 
	double conversion_constant = 1;
	if (argc == 6){
		std::string c_flag = argv[5];
		//optional conversion options
		if(c_flag == "-kt") conversion_constant = 1.9438444924406;//KT
		else if (c_flag == "-mph") conversion_constant = 2.2369362920544;//MPH
		else{
			std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN OUT_DIR [-kt, -mph]" << std::endl;
			return 1;
		}
	}
	else if (argc != 5) {
	        std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN OUT_DIR [-kt, -mph]" << std::endl;
	        return 1;
	}
		
	// INITIALIZATION	
	std::string dataDirU = argv[1];
	std::string dataDirV = argv[2];
	std::string outDir = argv[4];
	
	std::vector<std::string> models{"arw", "nmb"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "n4", "n5", "n6", "p1", "p2", "p3", "p4", "p5", "p6"};
	
	// // accurate for datasets from before the 10/21/2015 SREF update
	// std::vector<std::string> models{"em", "nmb", "nmm"};
	// std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[3]);
	
	std::string run = sstmp.str();
	
	// PROCESSING ROUTINE
	std::cout << "gen_wind_speed: processing..." << std::endl;
	
	int h;
	for(h=0; h <= 87; h += 3){
				
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		std::string fhr = sstmp.str();//"f00";
				
		//for each forecast hour 
		for (int m=0; m < models.size(); m++){
			for (int p=0; p < perturbations.size(); p++){
				
				// read U grid wind
				std::ostringstream file;
				file << dataDirU;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
			
				std::vector <double> dU;
				if (!readFileToVector(file.str().c_str(), dU)) return 1;
				
				// read V grid wind
				file.str(std::string());
				file.clear();
				file << dataDirV;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				
				std::vector <double> dV;
				if (!readFileToVector(file.str().c_str(), dV)) return 1;
				
				//Sanity Check -- Inputs Same Size
				if (dU.size() != dV.size()){
	   				 std::cerr << "Error: input files not of same size" << std::endl;
	   				 return 1;
				}
				
				// for each grid point
				int s = dU.size();
				std::vector <double> speed;
				for (int i=0; i < s; i++){
					// calculate speed and convert units if appropriate
					double tmp = (sqrt(pow(dU[i], 2.0) + pow(dV[i], 2.0))) * conversion_constant;
					speed.push_back(tmp);
				}
				
				// write wind speed	
				file.str(std::string());
				file.clear();
				file << outDir << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				writeVectorToFile(file.str().c_str(), speed);
				
			}
		}
			
	}
	std::cout << "gen_wind_speed: completed" << std::endl;
	
	return 0;
}