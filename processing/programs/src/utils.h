#ifndef UTILS_H
#define UTILS_H

// utils.h -- contains various templated convenience functions for reading and writing single column csv data files to vectors.

#include <iostream>
#include <fstream>
#include <iterator>
#include <vector>

#include <sstream>
#include <iomanip>
#include <string>
#include <limits>
#include <functional>
#include <algorithm>

// reads a file to a vector
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

	T val;
	try{
		while(in >> val){
			data.push_back(val);
		}
	}
	catch(std::ifstream::failure e){
		if( in.bad() || (in.fail() && !in.eof()) ){
			std::cerr << "Error reading file: " << fname << std::endl;
			return false;
		}
	}	
	in.close();
    return true;
}

// writes a vector to a file
template<typename T>
bool writeVectorToFile(const char *fname, std::vector<T> &data) { //TODO add proper error checking like read
	std::ofstream out(fname);
	out.precision(std::numeric_limits<T>::digits10);
	std::ostringstream endline;
	endline << std::endl;
	std::copy(data.begin(), data.end(), std::ostream_iterator<T>(out, endline.str().c_str()));
	out.close();
	return true;
}

// check that all members of a vector of vectors are the same size
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

// prints templated vector to std::cout -- useful for debugging scripts with toy files
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