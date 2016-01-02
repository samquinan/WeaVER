#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

// gen_wind_member.cpp -- generates wind speed and direction fields for a particular member (for treating a single member like a deterministic model) from the simulated wind u grid and v grid components

int main(int argc, char* argv[])
{
	//handle argument inputs 
	double conversion_constant = 1;
	if (argc == 8){
		std::string c_flag = argv[7];
		//optional conversion options
		if(c_flag == "-kt") conversion_constant = 1.9438444924406;//KT
		else if (c_flag == "-mph") conversion_constant = 2.2369362920544;//MPH
		else{
			std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN MODEL PERTURBATION OUT_DIR [-kt, -mph]" << std::endl;
			return 1;
		}
	}
	else if (argc != 7) {
	        std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN MODEL PERTURBATION OUT_DIR [-kt, -mph]" << std::endl;
	        return 1;
	}
	
	// INITIALIZATION
	
	std::string dataDirU = argv[1];
	std::string dataDirV = argv[2];
	std::string outDir = argv[6];
	
	std::string model = argv[4];
	std::string perturbation = argv[5];
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[3]);
	
	std::string run = sstmp.str();
	
	// PROCESSING ROUTINE
	std::cout << "gen_wind_member: processing..." << std::endl;
	
	int h;
	for(h=0; h <= 87; h += 3){
		
		// generate forecast hour string
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		std::string fhr = sstmp.str();//"f00";
		
		// read U grid Wind		
		std::ostringstream file;
		file << dataDirU;
		file << "sref_" << model << ".t" << run << "z.pgrb212." << perturbation << ".f" << fhr << ".txt";
			
		std::vector <double> dU;
		if (!readFileToVector(file.str().c_str(), dU)) return 1;
		
		// read V grid Wind		
		file.str(std::string());
		file.clear();
		file << dataDirV;
		file << "sref_" << model << ".t" << run << "z.pgrb212." << perturbation << ".f" << fhr << ".txt";
		
		std::vector <double> dV;
		if (!readFileToVector(file.str().c_str(), dV)) return 1;
		
		//Sanity Check -- Inputs Same Size
		if (dU.size() != dV.size()){
			 std::cerr << "Error: input files not of same size" << std::endl;
			 return 1;
		}
		
		int s = dU.size();
		std::vector <double> speed;
		std::vector <double> direction;
		//for each grid point
		for (int i=0; i < s; i++){
			//calculate speed and convert units if appropriate
			double tmp = (sqrt(pow(dU[i], 2.0) + pow(dV[i], 2.0))) * conversion_constant;// * 2.2369362920544;//converts to MPH 1.9438444924406;//converts to KTs
			speed.push_back(tmp);
			
			//calculate direction
			tmp = atan2(dU[i], dV[i]);
			direction.push_back(tmp);
		}
				
		// write wind speed	
		file.str(std::string());
		file.clear();
		file << outDir << "sref_" << model << ".t" << run << "z.pgrb212." << perturbation << ".f" << fhr << ".WSPD.txt";
		writeVectorToFile(file.str().c_str(), speed);
		
		// write wind direction	
		file.str(std::string());
		file.clear();
		file << outDir << "sref_" << model << ".t" << run << "z.pgrb212." << perturbation << ".f" << fhr << ".WDIR.txt";
		writeVectorToFile(file.str().c_str(), direction);
	}
	
	std::cout << "gen_wind_member: completed" << std::endl;
	
	return 0;
}