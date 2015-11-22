#ifndef UTILITY_H
#define UTILITY_H

#include <sstream>
#include "Matrix.h"

#include "itkImage.h"
#include "itkImageFileReader.h"
#include "itkConnectedComponentImageFilter.h"

#include "itksys/SystemTools.hxx"
#include <sstream>
#include <iomanip>

#define _USE_MATH_DEFINES

#define ESIZE 21
#define SMALLGRIDRES 212
#define BIGGRIDRES 132

typedef pair<int, int> IntPairVector;
typedef pair<double, double> DoublePairVect;

//////////////////////////////
/// map projection
//////////////////////////////
DoublePairVect LambertConformalConicSphere1SP(double R, double lon, double lon0, double lat, double lat0, double SP1);
DoublePairVect getMapProjSphere(double lon, double lat, double cntre_lat, double cntre_lon, double SP);

////////////////////////////
/// Combinatorics
////////////////////////////
unsigned long choose(unsigned long n, unsigned long k);
template <typename Iterator>
bool next_combination(const Iterator first, Iterator k, const Iterator last);
Matrix<int> getCombinationMatrix(unsigned int n, unsigned int k);
//bool sort_pred(IntPairVector a, IntPairVector b);

////////////////////////////
/// Field utilities
////////////////////////////
Matrix<int> getLevelSetMask(Matrix<double> m, double levelSet);
Matrix<int> getBinaryUnion(Matrix<int> m, Matrix<int> n);
Matrix<int> getBinaryIntersect(Matrix<int> m, Matrix<int> n);
double getBinaryIntersectSum(const Matrix<int>& m, const Matrix<int>& n);
double getPercentBinarySubset(Matrix<int> m, Matrix<int> n);

#endif // UTILITY_H
