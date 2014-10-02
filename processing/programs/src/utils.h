#ifndef UTILS_H
#define UTILS_H

#include <iostream>
#include <fstream>
#include <iterator>
#include <vector>

#include <sstream>
#include <iomanip>
#include <string>
#include <limits>

template<typename T>
bool readFileToVector(const char *fname, std::vector<T> &data) {
	std::ifstream in;
	in.exceptions ( std::ifstream::failbit );
	
	try{
		in.open(fname);
	}
	catch(std::ifstream::failure e){
		std::cerr << "Error opening file: " << fname << std::endl;
		return false;
	}
	
	std::istream_iterator<T> itr(in), eof;
	
	std::copy (	itr,   	 					// start of source
	      		eof,    					// end of source
	      	  	std::back_inserter(data));  // destination
	in.close();
    return true;
}

template<typename T>
bool writeVectorToFile(const char *fname, std::vector<T> &data) {
	std::ofstream out(fname);
	out.precision(std::numeric_limits<T>::digits10);
	std::ostringstream endline;
	endline << std::endl;
	std::copy(data.begin(), data.end(), std::ostream_iterator<T>(out, endline.str().c_str()));
	out.close();
	return true;
}

template<typename T>
bool sizesMatch(std::vector< std::vector<T> > &data) {
	bool valid = true;
	typename std::vector<std::vector<T>>::iterator it = data.begin();
	if (it != data.end()){ //TODO proper handling of null vectors?
		int s = (*it).size();
		for(++it; it != data.end(); ++it) {
			valid = valid && (s == (*it).size());
		}
	}
	return valid;
}

template<typename T>
void printVector(std::vector<T> &d){
	std::cout << std::setprecision(std::numeric_limits<T>::digits10);
	for(typename std::vector<T>::const_iterator i = d.begin(); i != d.end(); ++i){
	    std::cout << *i << ' ';
	}
	std::cout << std::endl;
	return;
}

#endif // UTILS_H