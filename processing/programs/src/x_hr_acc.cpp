#include "utils.h"

//x_hr_acc.cpp -- takes the total APCP (accumulated precipitation) for the entire forecast period up to each given forecast-hour, y, and generates the appropriate accumulations for an x-hour period (note that since the SREF is only forecasted every 3 hours, both x and y in this description must be multiples of 3).

int main(int argc, char* argv[])
{
	
	if (argc != 5) {
	        std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN ACC_PERIOD OUT_DIR" << std::endl;
			std::cerr << "\t note: input data is expected to be total acc" << std::endl;
			std::cerr << "\t and ACC_PERIOD is expected to be a multiple of 3" << std::endl;
	        return 1;
	}
	
	// INITIALIZATION
	std::vector <std::vector <double>> data;
	data.reserve(29);
	std::vector <std::vector <double>> output;
	output.reserve(29);
	
	std::string dataDir = argv[1];
	std::string outDir = argv[4];
	
	std::vector<std::string> models{"arw", "nmb"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "n4", "n5", "n6", "p1", "p2", "p3", "p4", "p5", "p6"};
	/*// accurate for datasets from before the 10/21/2015 SREF update
	std::vector<std::string> models{"em", "nmb", "nmm"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	*/	
	
	// process the run string
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[2]);//NOTE: TODO handle atoi fails silently to 0
	std::string run = sstmp.str();//argv[2];
	
	// process the accumulation period string
	int accumulationPeriod = atoi(argv[3]);//NOTE: TODO handle atoi fails silently to 0
	if (accumulationPeriod%3 != 0){
		std::cerr << "Error: accumulation period " << accumulationPeriod << " is not a multiple of 3" << std::endl;
		std::cerr << "terminating due to error..." << std::endl;
		return 1;
	}
	
	// PROCESSING ROUTINE
	
	std::cout << "x_hr_acc: processing..." << std::endl;
	//for each ensemble member 
	for (int m=0; m < models.size(); m++){
		for (int p=0; p < perturbations.size(); p++){
			
			// clear any data loaded and generated from previous ensemble member
			data.clear();
			output.clear();
			
			//load all forecast hours
			int h;
			for(h=0; h <= 87; h += 3){
				//generate forecast hour string
				sstmp.str(std::string());
				sstmp.clear();
				sstmp << std::setw(2) << std::setfill('0') << h;
				
				//generate the file name
				std::ostringstream file;
				file << dataDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << sstmp.str() << ".txt";
				
				//read the file to a vector
				std::vector <double> d;
				if (!readFileToVector(file.str().c_str(), d)){
					std::cerr << "terminating due to error..." << std::endl;
					return 1;
				}
				
				//push that vector into the data vector
				data.push_back(d);
			}
			
			//sanity check -- sizes match for grids being accumulated over
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
				//generate forecast hour string
				sstmp.str(std::string());
				sstmp.clear();
				sstmp << std::setw(2) << std::setfill('0') << h;
				
				//generate the file name
				std::ostringstream file;
				file << outDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << sstmp.str() << ".txt";
				
				// write vector to file
				writeVectorToFile(file.str().c_str(), *it);
			}
		}
	}
	std::cout << "x_hr_acc: completed" << std::endl;
	return 0;
}