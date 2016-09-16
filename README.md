#About#
WeaVER is a visualization system developed as part of a [design study](http://vdl.sci.utah.edu/publications/2015_infovis_weaver/) in collaboration with meteorologists working in a variety of domains. WeaVER is not intended to be a fully viable alternative to current operational forecasting tools; rather, it is a proof-of-concept, designed to allow our collaborators to evaluate our proposals regarding both informed, default encoding choices, which integrate existing meteorological conventions with principles for effective visualization design, and mechanisms for enabling the direct comparison of multiple meteorological features across an ensemble.

A video overview of WeaVER's functionalities can be found [here](https://www.youtube.com/watch?v=Egl_z6oF1oI).

#Dependencies#

WeaVER was written for / designed to be run using Processing 2.2.1. [Processing](https://processing.org) recently went through a major version update to Processing 3, which included fundementally re-working the backend. We are working on getting a modified version of the application running in Processing 3 in a seperate branch; but as this code is no longer under active development, the official branch will remain the version of the code for Processing 2.2.1. For the time being, Processing 2.2.1 can still be downloaded from [Processing.org](https://processing.org).

If you simply want to play around with WeaVER, binaries and source code with a pre-processed data set are [available](#binaries). *This* repository includes our BASH and C++ data processing routines for downloading the current SREF forecasts and prepping them for WeaVER. By nature of our use of BASH scripts, only OSX and Linux are suppoted at this time.

The dependencies for these routines include:

- [curl](http://curl.haxx.se) -- to download the binary GRIB2 forecasts
- [wgrib2](http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/) -- to process the data out of the binary GRIB2 format
- [CMake](https://cmake.org) [version >= 3.1] -- for easier cross-platform C++ complilation
- [ITK](http://www.itk.org) -- for running the contour boxplot analysis

Downloads and installation instructions for these dependencies can found on the respective sites linked above. Please note that you will want to install CMake before ITK, as CMake is used to compile ITK. 

Also, note that both wgrib2 and the contour boxplat routines will benefit from OpenMP if supported by your compiler.
 
#How to Build / Run#

##Check Dependencies / Path##

First please check that you've build / installed all the dependencies properly and that they are on your PATH. For the first three dependencies, this can quickly checked via:

```bash
which curl
which wgrib2
which cmake
```

ITK's default install location should be ```/usr/local``` and it shuld have placed files in

```bash
/usr/local/bin
/usr/local/include/InsightToolkit
/usr/local/lib/InsightToolkit
``` 

If you installed ITK somewhere else, use the ```ITK_DIR``` env variable to tell cmake where it should look for the ITK files.

```bash
export ITK_DIR=<custom_itk_install_root>
``` 

##Build Data Processing Routines##

Simply run the included bootstrap.sh program

```bash
./bootstrap.sh
```

## Download and Process the Data##

All the data processing code and routines can be found in the ```processing``` directory.

There is a wrapper script that will attempt approximate the most recent version of the data, attempt to download and process it.

```bash
./processing/fetchDialog.sh
```

As far as getting up an going quickly, that's your best bet.

These processing routines can take a good 20-30 minutes. That timing may vary depedning on the specs of your system. Given the fact that this was designed to be a prototype of the data visaulization and interaction mechanisms, I didn't really put any time into acclerating the data processinpsqg.

The download and processing are actually broken into independent sub-routines. For an overview, take a look at the ```getData.sh``` script in the ```processing``` directory.


## Run WeaVER ##

Once the data processing routines have finished, there should be a populated ```datasets``` directory in the main repository directory, along with an associated ```dataset.properties``` file. These, respectively, are where WeaVER expects to read data from.

The simplest way to run WeaVER is to simply open ```WeaVER/WeaVER.pde``` directly in Processing and run it.

Alternatively, if you make sure ```processing-java``` is on your PATH, you can simply run the included script

```bash
./run.sh
```

On OSX, processing-java needs to be enabled by opening processing, going to the Tools menu (in the menu bar), and clicking "install processing-java" from the drop down. On Linux, processing-java is included in the processing.tgz, so simply add the corresponding directory to your PATH.

#<a id="binaries"></a>Demo Binaries#

For the time being, binary demos with pre-processed data can be found at [http://www.sci.utah.edu/\~samquinan/software/WeaVER/](http://www.sci.utah.edu/~samquinan/software/WeaVER/).

#License + Attributions#

All the code contained within this repository is being released under the MIT License. 

The contour boxplot code was written by [Mahsa Mirzargar]() and is being made available with her persmission, along with that of [Ross Whittaker](), and [Mike Kirby](). All other code was written by [Sam Quinan]() and is being made avilable with his permission along with that of [Miriah Meyer](). This work was funded by NSF Grant IIS–1212806.

#Questions? Comments#

Feel free to contact [Sam Quinan]().
