#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

int main(int argc, char* argv[])
{
	double conversion_constant = 1;
	if (argc == 6){
		std::string c_flag = argv[5];
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
		
	std::string dataDirU = argv[1];
	std::string dataDirV = argv[2];
	std::string outDir = argv[4];
	
	std::vector<std::string> models{"em", "nmb", "nmm"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[3]);
	
	std::string run = sstmp.str();
	
	int h;
	for(h=0; h <= 87; h += 3){
				
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		std::string fhr = sstmp.str();//"f00";
		
		std::cout << "f" << fhr << std::endl;
		
		for (int m=0; m < 3; m++){
			for (int p=0; p < 7; p++){
				
				std::ostringstream file;
				file << dataDirU;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
			
				std::vector <double> dU;
				if (!readFileToVector(file.str().c_str(), dU)) return 1;
				
				file.str(std::string());
				file.clear();
				file << dataDirV;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				
				std::vector <double> dV;
				if (!readFileToVector(file.str().c_str(), dV)) return 1;
				
				//Check Inputs Same Size
				if (dU.size() != dV.size()){
	   				 std::cerr << "Error: input files not of same size" << std::endl;
	   				 return 1;
				}
				
				//Calculate Speed
				int s = dU.size();
				std::vector <double> speed;
				for (int i=0; i < s; i++){
					double tmp = (sqrt(pow(dU[i], 2.0) + pow(dV[i], 2.0))) * conversion_constant;// * 2.2369362920544;//converts to MPH 1.9438444924406;//converts to KTs
					speed.push_back(tmp);
				}
				
				// WRITE OUT	
				file.str(std::string());
				file.clear();
				file << outDir << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				writeVectorToFile(file.str().c_str(), speed);
				
			}
		}
			
	}
	
	return 0;
}