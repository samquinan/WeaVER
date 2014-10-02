#include "utils.h"

//************ INPUT *************

int main(int argc, char* argv[])
{
	
	if (argc != 5) {
	        std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN ACC_PERIOD OUT_DIR" << std::endl;
			std::cerr << "\t note: input data is expected to be total acc" << std::endl;
	        return 1;
	}
	
	std::vector <std::vector <double>> data;
	data.reserve(29);
	std::vector <std::vector <double>> output;
	output.reserve(29);
	
	std::string dataDir = argv[1];
	std::string outDir = argv[4];
	std::vector<std::string> models{"em", "nmb", "nmm"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[2]);//NOTE: TODO handle atoi fails silently to 0
	std::string run = sstmp.str();//argv[2];
		
	int accumulationPeriod = atoi(argv[3]);//NOTE: TODO handle atoi fails silently to 0
	if (accumulationPeriod%3 != 0){
		std::cerr << "Error: accumulation period " << accumulationPeriod << " is not a multiple of 3" << std::endl;
		std::cerr << "terminating due to error..." << std::endl;
		return 1;
	}
	
	std::cout << "processing..." << std::endl;
	//for each ensemble member 
	for (int m=0; m < 3; m++){
		for (int p=0; p < 7; p++){
			
			std::cout << "\t" << models[m] << "\t" << perturbations[p] << std::endl;
			data.clear();
			output.clear();
			
			//load all forecast hours
			int h;
			for(h=0; h <= 87; h += 3){
				sstmp.str(std::string());
				sstmp.clear();
				sstmp << std::setw(2) << std::setfill('0') << h;
				
				std::ostringstream file;
				file << dataDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << sstmp.str() << ".txt";
				
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
			
			//walk through and subtract
			std::vector< std::vector<double> >::iterator it = data.begin() + accumulationPeriod/3; // TODO proper handling of null vectors? -- implicitly handled by read failure?
			std::vector< std::vector<double> >::iterator prev = data.begin();
			for( ; it != data.end(); ++it, ++prev) {
				std::vector<double> difference;
				difference.reserve((*it).size());
				for(std::vector<double>::iterator vcur = (*it).begin(), vprev = (*prev).begin();
					vcur != (*it).end();
					++vcur, ++vprev)
					{
						difference.push_back(*vcur - *vprev); // subtract previous from current at each data point
					}
				output.push_back(difference);
			}
						
			//output differences
			it = output.begin();
			h = accumulationPeriod;
			for( ; it != output.end(); ++it, h+=3){
				sstmp.str(std::string());
				sstmp.clear();
				sstmp << std::setw(2) << std::setfill('0') << h;
				
				std::ostringstream file;
				file << outDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << sstmp.str() << ".txt";
				writeVectorToFile(file.str().c_str(), *it);
			}
		}
	}
	
	return 0;
}