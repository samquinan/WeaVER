#include "utils.h"
#include <cmath> 

int main(int argc, char* argv[])
{
	std::string outDir = "";
	int startHr = 0;
	if (argc == 4) {
		outDir = argv[3];
	}
	else if (argc == 6){
		outDir = argv[5];
		std::string time_flag = argv[3];
		if (time_flag != "-h"){
		    std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN [-h START_HR] OUT_DIR" << std::endl;
			std::cerr << "\t where '-h' flag optionally begins processing at "<< std::endl <<"\t specified forecast hour instead of 0" << std::endl;
			return 1;
		}
		try{
			startHr = std::stoi(argv[4]);
			if ((startHr < 0) || (startHr > 87) || ((startHr % 3)!=0)){
				std::cerr << argv[4] << " is not a valid integer multiple of 3 between 0 and 87" << std::endl;
				return 1;
			} 
		}
		catch(std::invalid_argument&){
			std::cerr << argv[4] << " is not a valid integer multiple of 3 between 0 and 87" << std::endl;
			return 1;
		}
	}
	else{
	    std::cerr << "Usage: " << argv[0] << " DATA_DIR RUN [-h START_HR] OUT_DIR" << std::endl;
		std::cerr << "\t where '-h' flag optionally begins processing at "<< std::endl <<"\t specified forecast hour instead of 0" << std::endl;
		return 1;
	}
	
	std::string dataDir = argv[1];//"../data/"
	
	std::vector<std::string> models{"em", "nmb", "nmm"};
	std::vector<std::string> perturbations{"ctl", "n1", "n2", "n3", "p1", "p2", "p3"};
	
	std::stringstream sstmp;
	sstmp.str(std::string());
	sstmp.clear();
	sstmp << std::setw(2) << std::setfill('0') << atoi(argv[2]);
	
	std::string run = sstmp.str();//"03";
	
	int h;
	for(h=startHr; h <= 87; h += 3){
		std::vector <std::vector <double>> data;
		
		sstmp.str(std::string());
		sstmp.clear();
		sstmp << std::setw(2) << std::setfill('0') << h;
	
		std::string fhr = sstmp.str();//"f00";
		
		std::cout << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << std::endl;
		
		for (int m=0; m < models.size(); m++){
			for (int p=0; p < perturbations.size(); p++){
				std::ostringstream file;
				file << dataDir;
				file << "sref_" << models[m] << ".t" << run << "z.pgrb212." << perturbations[p] << ".f" << fhr << ".txt";
			
				// std::cout << file.str() << std::endl;
				std::vector <double> d;
				if (!readFileToVector(file.str().c_str(), d)) return 1;
				data.push_back(d);
			}
		}
	
		//Check Inputs Same Size
		int s = -1;
		for(std::vector< std::vector<double> >::iterator it = data.begin(); it != data.end(); ++it) {
			 if (s == -1) s = (*it).size();
			 bool valid = (s == (*it).size());
			 if (!valid){
				 std::cerr << "Error: input files not of same size" << std::endl;
				 return 1;
			 }	 
		}
	
		//CALCULATE DERIVED FIELDS
		std::vector <double> stddevf;
		std::vector <double> meanf;
		std::vector <double> maxf;
		std::vector <double> minf;
	
		for (int i=0; i < s; i++){
		
			double mean_val, max_val, min_val, tmp;
		
			std::vector< std::vector<double> >::iterator it = data.begin();
			tmp = (*it)[i];
			min_val = tmp;
			max_val = tmp;
			mean_val = tmp;
		
			for(++it; it != data.end(); ++it){
				tmp = (*it)[i];
				min_val = std::min(min_val, tmp);
				max_val = std::max(max_val, tmp);
				mean_val += tmp;
			}
		
			minf.push_back(min_val);
			maxf.push_back(max_val);
			meanf.push_back(mean_val/data.size());
		
			double stddev = 0;
			for (it = data.begin(); it != data.end(); ++it){
				tmp = (*it)[i] -  meanf[i];
				stddev += tmp*tmp;
			}		
			stddevf.push_back(sqrt(stddev/(data.size()-1)));
		
		}	
			
		// WRITE OUT	
		std::ostringstream file;
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".mean" << ".txt";
		writeVectorToFile(file.str().c_str(), meanf);
	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".stddev" << ".txt";
		writeVectorToFile(file.str().c_str(), stddevf);
	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".min" << ".txt";
		writeVectorToFile(file.str().c_str(), minf);
	
		file.clear();
		file.str(std::string());
		file << outDir << "sref" << ".t" << run << "z.pgrb212" << ".f" << fhr << ".max" << ".txt";
		writeVectorToFile(file.str().c_str(), maxf);
	}
	
	return 0;
}