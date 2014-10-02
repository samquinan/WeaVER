#include "utils.h"

//************ INPUT *************

int main(int argc, char* argv[])
{
	
	if (argc != 4) {
	        std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN OUT_DIR" << std::endl;
			std::cerr << "\t note: input data is expected to be 3 hr acc" << std::endl;
	        return 1;
	}
	
	std::vector <std::vector <double>> data;
	
	std::string dataDir = argv[1];
	std::string outDir = argv[3];
	std::vector<std::string> models{"em", "nmb", "nmm"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};	
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[2]);//NOTE: TODO handle atoi fails silently to 0
	std::string run = sstmp.str();//argv[2];
	
	// generate forecastHours
	std::vector<std::string> forecastHours;
	for(int h=0; h <= 87; h += 3){
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		forecastHours.push_back(sstmp.str());
	}
	
	std::cout << "processing..." << std::endl;
	//for each ensemble member 
	for (int m=0; m < 3; m++){
		for (int p=0; p < 7; p++){
			
			std::cout << "\t" << models[m] << "\t" << perturbations[p] << std::endl;
			data.clear();
			
			//load all forecast hours
			for(std::vector<std::string>::iterator fhr = forecastHours.begin(); fhr != forecastHours.end(); ++fhr){
				std::ostringstream file;
				file << dataDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << (*fhr) << ".txt";
				
				//std::cout << file.str() << std::endl;
				std::vector <double> d;
				if (!readFileToVector(file.str().c_str(), d)){
					std::cerr << "terminating due to error..." << std::endl;
					return 1;
				}
				data.push_back(d);
			}
			
			//check sizes match for grids being accumulated over
			if (!sizesMatch(data)){
				std::cerr << "Error: input files not of same size" << std::endl;
				std::cerr << "terminating due to error..." << std::endl;
				return 1;
			}
			
			//walk through and accumulate
			std::vector< std::vector<double> >::iterator it = data.begin();
			std::vector< std::vector<double> >::iterator prev = it;
			if (it != data.end()){ //TODO proper handling of null vectors?
				for(++it; it != data.end(); ++it, ++prev) {
					for(std::vector<double>::iterator vcur = (*it).begin(), vprev = (*prev).begin();
						vcur != (*it).end();
						++vcur, ++vprev )
						{
							*vcur += *vprev; // add previous to current at each data point
						}
				}
			}
			
			//output total accumulations
			it = data.begin();
			std::vector<std::string>::iterator fhr = forecastHours.begin();
			for( ; it != data.end(); ++it, ++fhr){
				std::ostringstream file;
				file << outDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << (*fhr) << ".txt";
				writeVectorToFile(file.str().c_str(), *it);
			}
		}
	}
	
	return 0;
}