#include "utils.h"
#define _USE_MATH_DEFINES
#include <cmath> 

// mean_wind.cpp -- generates the mean wind speed and direction across the ensemble using the simulated wind u grid and v grid components

int main(int argc, char* argv[])
{
	
	if (argc != 5) {
	        std::cerr << "Usage: " << argv[0] << " UGRD_DIR VGRD_DIR RUN OUT_DIR" << std::endl;
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
	std::cout << "mean_wind: processing..." << std::endl;
	
	//for each forecast hour 
	int h;
	for(h=0; h <= 87; h += 3){
		std::vector <std::vector <double>> dataU;
		std::vector <std::vector <double>> dataV;
		
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
	
		std::string fhr = sstmp.str();//"f00";
		
		//for each member
		for (int m=0; m < models.size(); m++){
			for (int p=0; p < perturbations.size(); p++){
				
				// read wind U
				std::ostringstream file;
				file << dataDirU;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
			
				std::vector <double> dU;
				if (!readFileToVector(file.str().c_str(), dU)) return 1;
				dataU.push_back(dU);
				
				// read wind V
				file.str(std::string());
				file.clear();
				file << dataDirV;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
				
				std::vector <double> dV;
				if (!readFileToVector(file.str().c_str(), dV)) return 1;
				dataV.push_back(dV);
			}
		}
	
		//Sanity Check -- Inputs Same Size
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
	
		//Calcualte Derived Fields
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
		
		// calculate max / min win speed and direction
		//TODO -- having second walkthrough for max / min is definitely inefficient, but it's functional
		std::vector <double> maxSpeed;
		std::vector <double> maxDirection;
		
		std::vector <double> minSpeed;
		std::vector <double> minDirection;
		for (int i=0; i < s; i++){
		
			double tmpU, tmpV, tmpSpd, tmpDir, maxSpd, maxDir, minSpd, minDir;
			
			tmpU = (dataU[0])[i];
			tmpV = (dataV[0])[i];
			tmpSpd = (sqrt(pow(tmpU, 2.0) + pow(tmpV, 2.0))) * 1.9438444924406;//converts to KTs
			tmpDir = atan2(tmpU, tmpV);
			
			maxSpd = tmpSpd;
			maxDir = tmpDir;
			minSpd = tmpSpd;
			minDir = tmpDir;
			
			for(int m=1; m < dataU.size(); m++){
				tmpU = (dataU[m])[i];
				tmpV = (dataV[m])[i];
				tmpSpd = (sqrt(pow(tmpU, 2.0) + pow(tmpV, 2.0))) * 1.9438444924406;//converts to KTs
				tmpDir = atan2(tmpU, tmpV);
				
				if (tmpSpd > maxSpd){
					maxSpd = tmpSpd;
					maxDir = tmpDir;
				}
				else if (tmpSpd < minSpd){
					minSpd = tmpSpd;
					minDir = tmpDir;
				}
			}
			
			maxSpeed.push_back(maxSpd);
			maxDirection.push_back(maxDir);
			minSpeed.push_back(minSpd);
			minDirection.push_back(minDir);
			
		}	
			
		// write mean speed	
		std::ostringstream file;
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WSPD.mean.txt";
		writeVectorToFile(file.str().c_str(), meanSpeed);
		
		// write mean direction	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WDIR.mean.txt";
		writeVectorToFile(file.str().c_str(), meanDir);
		
		// write max speed	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WSPD.max.txt";
		writeVectorToFile(file.str().c_str(), maxSpeed);
		
		// write max direction	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WDIR.max.txt";
		writeVectorToFile(file.str().c_str(), maxDirection);
		
		// write min speed	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WSPD.min.txt";
		writeVectorToFile(file.str().c_str(), minSpeed);
		
		// write min direction	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".WDIR.min.txt";
		writeVectorToFile(file.str().c_str(), minDirection);
	
	}
	std::cout << "mean_wind: completed" << std::endl;
	
	return 0;
}