#About#
WeaVER is a visualization system developed as part of a [design study](http://vdl.sci.utah.edu/publications/2015_infovis_weaver/) in collaboration with meteorologists working in a variety of domains. WeaVER is not intended to be a fully viable alternative to current operational forecasting tools; rather, it is a proof-of-concept, designed to allow our collaborators to evaluate our proposals regarding both informed, default encoding choices, which integrate existing meteorological conventions with principles for effective visualization design, and mechanisms for enabling the direct comparison of multiple meteorological features across an ensemble.

A video overview of WeaVER's functionalities can be found [here](https://www.youtube.com/watch?v=Egl_z6oF1oI).

#Dependencies#

WeaVER was written for / designed to be run using Processing 2.2.1. [Processing](https://processing.org) recently went through a major version update to Processing 3, which included fundementally re-working the backend. We are working on getting a modified version of the application running in Processing 3 in a seperate branch; but as this code is no longer under active development, the official branch will remain the version of the code written assumes you have Processing 2.2.1 installed on your system. For the time being, Processing 2.2.1 can still be downloaded from [Processing.org](https://processing.org).

If you simply want to play around with WeaVER, binaries and source code with a pre-processed data set are [available](#binaries).

This repository includes our BASH and C++ data processing routines for downloading the current SREF forecasts and prepping them for WeaVER. 

The dependencies for these routines include:

- [curl](http://curl.haxx.se) -- to download the binary GRIB2 forecasts
- [wgrib2](http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/) -- to process the data out of the binary GRIB2 format
- [CMake](https://cmake.org) -- for easier cross-platform C++ complilation
- [ITK](http://www.itk.org) -- for running the contour boxplot analysis

Downloads and installation instructions for these dependencies can found on the respective sites linked above. Please note that you will want to install CMake before ITK as CMake is also used to compile ITK.

#How to Build / Run#




#<a id="binaries"></a>Demo Binaries#

For the time being, binary demos with pre-processed data can be found at [http://www.sci.utah.edu/\~samquinan/software/WeaVER/](http://www.sci.utah.edu/~samquinan/software/WeaVER/). We are investigating the possibility of rolling these downloads into github's release structure.

#License + Attributions#

All the code contained within this repository is being released under the MIT License. 

The contour boxplot code was written by [Mahsa Mirzargar]() and is being made available with her persmission, along with that of [Ross Whittaker](), and [Mike Kirby](). 

All other code was written by [Sam Quinan]() and is being made avilable with the permission of [Miriah Meyer](). This work was funded by NSF Grant ***INSERT GRANT DETAILS***

#Questions? Comments#

Feel free to contact [Sam Quinan]().
