#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

int main(int argc, char* argv[])
{
	
	if (argc != 5) {
	        std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN OUT_DIR" << std::endl;
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
		std::vector <std::vector <double>> dataU;
		std::vector <std::vector <double>> dataV;
		
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
	
		std::string fhr = sstmp.str();//"f00";
		
		std::cout << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << std::endl;
		
		for (int m=0; m < 3; m++){
			for (int p=0; p < 7; p++){
				std::ostringstream file;
				file << dataDirU;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
			
				std::vector <double> dU;
				if (!readFileToVector(file.str().c_str(), dU)) return 1;
				dataU.push_back(dU);
				
				file.str(std::string());
				file.clear();
				file << dataDirV;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				
				std::vector <double> dV;
				if (!readFileToVector(file.str().c_str(), dV)) return 1;
				dataV.push_back(dV);
			}
		}
	
		//Check Inputs Same Size
		int s = -1;
		for(std::vector< std::vector<double> >::iterator it = dataU.begin(); it != dataU.end(); ++it) {
			 if (s == -1) s = (*it).size();
			 bool valid = (s == (*it).size());
			 if (!valid){
				 std::cerr << "Error: input files not of same size" << std::endl;
				 return 1;
			 }	 
		}
		for(std::vector< std::vector<double> >::iterator it = dataV.begin(); it != dataV.end(); ++it) {
			 bool valid = (s == (*it).size());
			 if (!valid){
				 std::cerr << "Error: input files not of same size" << std::endl;
				 return 1;
			 }	 
		}
	
		//CALCULATE DERIVED FIELDS
		std::vector <double> meanSpeed;
		std::vector <double> meanDir;
		
		for (int i=0; i < s; i++){
		
			double mean_U, mean_V, tmp;
			
			// mean UGRD
			std::vector< std::vector<double> >::iterator it = dataU.begin();
			tmp = (*it)[i];
			mean_U = tmp;
			for(++it; it != dataU.end(); ++it){
				tmp = (*it)[i];
				mean_U += tmp;
			}
			mean_U = mean_U / dataU.size();
			
			// mean VGRD
			it = dataV.begin();
			tmp = (*it)[i];
			mean_V = tmp;
			for(++it; it != dataV.end(); ++it){
				tmp = (*it)[i];
				mean_V += tmp;
			}
			mean_V = mean_V / dataV.size();
			
			tmp = (sqrt(pow(mean_U, 2.0) + pow(mean_V, 2.0))) * 1.9438444924406;//converts to KTs
			meanSpeed.push_back(tmp);
			
			tmp = atan2(mean_U, mean_V); //+ M_PI //rotation in in radians
			meanDir.push_back(tmp);
		}	
			
		// WRITE OUT	
		std::ostringstream file;
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WSPD.mean.txt";
		writeVectorToFile(file.str().c_str(), meanSpeed);
	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WDIR.mean.txt";
		writeVectorToFile(file.str().c_str(), meanDir);
	
	}
	
	return 0;
}