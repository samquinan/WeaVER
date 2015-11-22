#include "Utility.h"

////////////////////////////
/// Combinatorics
////////////////////////////
unsigned long choose(unsigned long n, unsigned long k) {
    // Binomial coefficient or all combinations
    if (k > n) {
        return 0;
    }
    unsigned long r = 1;
    for (unsigned long d = 1; d <= k; ++d) {
        r *= n--;
        r /= d;
    }
    return r;
}

template <typename Iterator>
bool next_combination(const Iterator first, Iterator k, const Iterator last){
    // nex combination in Binomial coefficients for n, k
   /* Credits: Thomas Draper */
   if ((first == last) || (first == k) || (last == k))
      return false;
   Iterator itr1 = first;
   Iterator itr2 = last;
   ++itr1;
   if (last == itr1)
      return false;
   itr1 = last;
   --itr1;
   itr1 = k;
   --itr2;
   while (first != itr1){
      if (*--itr1 < *itr2){
         Iterator j = k;
         while (!(*itr1 < *j)) ++j;
         std::iter_swap(itr1,j);
         ++itr1;
         ++j;
         itr2 = k;
         std::rotate(itr1,j,last);
         while (last != j){
            ++j;
            ++itr2;
         }
         std::rotate(k,itr2,last);
         return true;
      }
   }
   std::rotate(first,k,last);
   return false;
}

Matrix<int> getCombinationMatrix(unsigned int n, unsigned int k){
    std::vector<int> ints;
    for (unsigned int i = 1; i <= n; ints.push_back(i++));
    unsigned long chooseCount = choose(n,k);

    Matrix<int> combinations(chooseCount, k);

    int counter = 0;
    do{
       for (unsigned int i = 0; i < k; ++i)
            combinations(counter,i) = ints[i];
       counter++;
    }while(next_combination(ints.begin(),ints.begin() + k,ints.end()));
    return combinations;
}

Matrix<int> getLevelSetMask(Matrix<double> m, double levelSet){
    // Given a field of value and an isovluae,
    // this function return a binary mask
    Matrix<int> mask = Matrix<int>(m.getXdim(), m.getYdim(), 0);
    for(unsigned int i=0; i<m.getXdim(); ++i)
        for(unsigned int j=0; j<m.getYdim(); ++j){
            mask(i,j) = ((m(i,j) <= levelSet) ? 0 : 1);
        }
        return mask;
}

Matrix<int> getBinaryUnion(Matrix<int> m, Matrix<int> n){
    // Given two binary masks, this function returns the union mask
    Matrix<int> temp(m.getXdim(), m.getYdim());
    temp = MaxMatrix(m, n);
    return temp;
}

double getBinaryIntersectSum(const Matrix<int>& m, const Matrix<int>& n){
    // Given two binary masks, this function first take the intersection
    // and then compute the volume measure of the intesection
    if((m.getXdim() != n.getXdim()) || (m.getYdim() != n.getYdim())){
        throw 1;
        return -1;
    }

    double toReturn = 0.0;
    for(unsigned int i=0; i<m.getXdim();++i)
        for(unsigned int j=0; j<m.getYdim();++j){
                if(m(i,j) == 1 && n(i,j) == 1)
                    toReturn += 1;
        }
    return toReturn;
}

Matrix<int> getBinaryIntersect(Matrix<int> m, Matrix<int> n){
    // Given two binary masks, this function return the intersection mask
    if((m.getXdim() != n.getXdim()) || (m.getYdim() != n.getYdim())){
        throw 1;
        return Matrix<int>();
    }

    Matrix<int> temp(m.getXdim(), m.getYdim());
    for(unsigned int i=0; i<temp.getXdim();++i)
        for(unsigned int j=0; j<temp.getYdim();++j){
            if(m(i,j) == 1 && n(i,j) == 1)
                temp(i,j) = 1;
        }
    return temp;
}

double getPercentBinarySubset(Matrix<int> m, Matrix<int> n){
    // This function computes the epsilon subset function defined in Eq. 6 in
    // Ross T. Whitaker, Mahsa Mirzargar, Robert M. Kirby,
    // “Contour Boxplots: A Method for Charac- terizing Uncertainty in Feature Sets from Simulation Ensembles”,
    // IEEE Transactions on Visualization and Computer Graphics (TVCG), vol. 19, no. 12, pp. 2713-2722, 2013.
    if((m.getXdim() != n.getXdim()) || (m.getYdim() != n.getYdim())){
        throw 1;
        return -1.0;
    }

    Matrix<int> diffMatrix(m.getXdim(), m.getYdim());
    diffMatrix = getBinaryIntersect(m, n);
    double temp = 0.0;
    temp = double(diffMatrix.getSum())/double(m.getSum());
    return fabs(temp);
}

//////////////////////////////
/// map projection
//////////////////////////////
DoublePairVect LambertConformalConicSphere1SP(double R, double lon, double lon0, double lat, double lat0, double SP1){
    // This is standard map projection function
    DoublePairVect toReturn;

    double n = sin(SP1);
    double theta = n*(lon-lon0);
    double F =  (cos(SP1)*pow(tan(M_PI/4.0+SP1/2.0), n))/n;
    double rho = (R*F)/(pow(tan(M_PI/4.0+lat/2.0), n));
    double rho0 = (R*F)/(pow(tan(M_PI/4.0+lat0/2.0), n));

    toReturn.first = rho*sin(theta);
    toReturn.second = rho0 - rho*cos(theta);

    return toReturn;
}

DoublePairVect getMapProjSphere(double lon, double lat, double cntre_lat, double cntre_lon, double SP){
    //This function has hard coded information for NCEP SREF ensemble map projection specifications

    DoublePairVect toReturn;

    // NCEP specifications
    double R = 637.1200; //radius of earth
    double lon0 = cntre_lon*M_PI/180; //centre longitude
    double lat0 = cntre_lat*M_PI/180; // centre latitude
    double SP1 = SP*M_PI/180;  // standard parallel

    toReturn = LambertConformalConicSphere1SP(R, M_PI*(lon)/180, lon0, M_PI*(lat)/180, lat0, SP1);

    return toReturn;
}

