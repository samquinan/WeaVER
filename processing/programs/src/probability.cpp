#include "utils.h"
#include <cmath>
#include <bitset>

// probability.cpp -- generates fields of bitsets representing the which members of the the ensemble do or do not meet a condition (greater than, greater than or equal to, less than, or less than or equal to some value)

#define N 26
// note: ensure N defined as (# models * # perturbations) -- need compile time constant for the bitsets
// pre-10/21/15: #define N 21

// various convenience structures
// lowercase operator
struct to_lower {
  int operator() ( int ch )
  {
    return std::tolower ( ch );
  }
};

// comparison functions
bool gt(double x, double y){ return (x > y);}
bool ge(double x, double y){ return (x >= y);}
bool lt(double x, double y){ return (x < y);}
bool le(double x, double y){ return (x <= y);}

int main(int argc, char* argv[])
{	
	
	// INITAILIZATION
	
	std::vector<std::string> models{"arw", "nmb"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "n4", "n5", "n6", "p1", "p2", "p3", "p4", "p5", "p6"};
	
	// // accurate for datasets from before the 10/21/2015 SREF update
	// std::vector<std::string> models{"em", "nmb", "nmm"};
	// std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	
	if (models.size()*perturbations.size() != N){
	        std::cerr << "Compile-time Constant 'N' does not equal the number of models x perturbations";
	        return 1;
	}
	
	//process arguments
	std::string outDir = "";
	int startHr = 0;
	if (argc == 6) {
		outDir = argv[5];
	}
	else if (argc == 8){
		outDir = argv[7];
		std::string time_flag = argv[5];
		if (time_flag != "-h"){
		    std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN OP VAL [-h START_HR] OUT_DIR" << std::endl;
			std::cerr << "\t where OP takes one of: -gt, -lt, -ge, -le" << std::endl;
			std::cerr << "\t '-h' flag optionally begins processing at "<< std::endl <<"\t specified forecast hour instead of 0" << std::endl;
			return 1;
		}
		try{
			startHr = std::stoi(argv[6]);
			if ((startHr < 0) || (startHr > 87) || ((startHr % 3)!=0)){
				std::cerr << argv[6] << " is not a valid integer multiple of 3 between 0 and 87" << std::endl;
				return 1;
			} 
		}
		catch(std::invalid_argument&){
			std::cerr << argv[6] << " is not a valid integer multiple of 3 between 0 and 87" << std::endl;
			return 1;
		}
	}
	else{
	    std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN OP VAL [-h START_HR] OUT_DIR" << std::endl;
		std::cerr << "\t where OP takes one of: -gt, -lt, -ge, -le" << std::endl;
		std::cerr << "\t '-h' flag optionally begins processing at "<< std::endl <<"\t specified forecast hour instead of 0" << std::endl;
        return 1;
	}
	
	std::string dataDir = argv[1];
	
	//determine run
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[2]); //TODO switch to strtol call that handles error checking
	std::string run = sstmp.str();
		
	//determine comparison operation	
	std::string op_flag = argv[3];
	std::transform(op_flag.begin(), op_flag.end(), op_flag.begin(), to_lower());
	std::function<bool (double, double)> op;
	if (op_flag == "-gt"){
		op = gt;
	}
	else if (op_flag == "-lt"){
		op = lt;
	}
	else if (op_flag == "-ge"){
		op = ge;
	}
	else if (op_flag == "-le"){
		op = le;
	}
	else {
		std::cerr << "OP " << argv[3] << " not one of: -gt, -lt, -ge, -le" << std::endl;
		return 1;
	}
	op_flag.erase(0, 1);
	
	// determine value for comparison
	char *end;
	double compare_val = std::strtod(argv[4], &end);
	if (*end != '\0'){
		std::cerr << "VAL " << argv[4] << " not a valid number" << std::endl;
		return 1;
	}
	
	// PROCESSING ROUTINE
	std::cout << "probability: processing..." << std::endl;
	
	//for each forecast hour
	int h;
	for(h=startHr; h <= 87; h += 3){
		std::vector <std::vector <double>> data;
		
		//generate forecast hour string
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
		std::string fhr = sstmp.str();
		
		//for each member
		for (int m=0; m < models.size(); m++){
			for (int p=0; p < perturbations.size(); p++){
				//read file
				std::ostringstream file;
				file << dataDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";

				std::vector <double> d;
				if (!readFileToVector(file.str().c_str(), d)) return 1;
				//push file into vector
				data.push_back(d);
			}
		}

		//Sanity Check -- Inputs Same Size
		int s = -1;
		for(std::vector< std::vector<double> >::iterator it = data.begin(); it != data.end(); ++it) {
			 if (s == -1) s = (*it).size();
			 bool valid = (s == (*it).size());
			 if (!valid){
				 std::cerr << "Error: input files not of same size" << std::endl;
				 return 1;
			 }
		}
	
		//Calculate Probability Field
		std::vector <int> probability;
		//for each grid point
		for (int i=0; i < s; i++){
			double tmp;
			int pos = 0;
			std::bitset<N> binaryEnsemble;
			
			//for each member, set one bit of bitset according to the result of the comparsion of the member's value to the specified value
			std::vector< std::vector<double> >::iterator it = data.begin();
			tmp = (*it)[i];
			binaryEnsemble.set(pos, op(tmp,compare_val));

			for(++it, ++pos; it != data.end(); ++it, ++pos){
				tmp = (*it)[i];
				binaryEnsemble.set(pos, op(tmp,compare_val));
			}
			
			//cast the bitset to ulong and push into vector
			probability.push_back((int)binaryEnsemble.to_ulong());
		}
		
		// write cast bitsets to file
		std::ostringstream file;
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << "."<< op_flag << "." << compare_val << ".txt";
		writeVectorToFile(file.str().c_str(), probability);
		
	}
	
	std::cout << "probability: completed" << std::endl;
	
	return 0;
}