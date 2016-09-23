#About#
WeaVER is a visualization system developed as part of a [design study](http://vdl.sci.utah.edu/publications/2015_infovis_weaver/) in collaboration with meteorologists working in a variety of domains. WeaVER is not intended to be a fully viable alternative to current operational forecasting tools; rather, it is a proof-of-concept, designed to allow our collaborators to evaluate our proposals regarding both informed, default encoding choices, which integrate existing meteorological conventions with principles for effective visualization design, and mechanisms for enabling the direct comparison of multiple meteorological features across an ensemble.

A video overview of WeaVER's functionalities can be found on [YouTube](https://www.youtube.com/watch?v=Egl_z6oF1oI).

[![youtube link](http://i.imgur.com/Hd0XPMF.jpg)](https://www.youtube.com/watch?v=Egl_z6oF1oI)


#Dependencies#

WeaVER was written for / designed to be run using Processing 2.2.1. Around the time we published our [design study](http://vdl.sci.utah.edu/publications/2015_infovis_weaver/), Processing went through a major version update to Processing 3, which included fundamentally re-working the rendering engine. While I looked into updating the application to run in Processing 3, the changes would have required more time than I have to devote to a project no longer under active development. As such, the official branch remains dependent on Processing 2.2.1, which, at least for the time being, can still be downloaded from [Processing.org](https://processing.org).

If you simply want to play around with WeaVER, binaries and source code with a pre-processed data set are available through [github's release system](https://github.com/samquinan/WeaVER/releases). *This* repository includes our BASH and C++ data processing routines for downloading the current SREF forecasts (as of the 10/21/2015 [SREF Upgrade](http://www.nws.noaa.gov/os/notification/tin15-32srefaae.htm))and prepping them for WeaVER. By nature of our use of BASH scripts, only OSX and Linux are supported at this time.

The dependencies for these routines include:

- [curl](http://curl.haxx.se) -- to download the binary GRIB2 forecasts
- [wgrib2](http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/) -- to process the data out of the binary GRIB2 format
- [CMake](https://cmake.org) [version >= 3.1] -- for easier cross-platform C++ compilation
- [ITK](http://www.itk.org) -- for running the contour boxplot analysis

Downloads and installation instructions for these dependencies can found on the respective sites linked above. Please note that you will want to install CMake before ITK, as CMake is used to compile ITK. 


##Taking Advantage of OpenMP Support##

Both wgrib2 and the contour boxplot routines will benefit from OpenMP if supported by your compiler. Before building wgrib2 or WeaVER's data processing routines, set the CC, CX, and FC environmental variables to point to compilers with OpenMP support (e.g., current versions of gcc, g++, and gfortran). Then, before running the data processing scripts you'll need to set the following 2 environmental variables:

```bash
export OMP_NUM_THREADS=4
export OMP_WAIT_POLICY=PASSIVE # or ACTIVE
```
 
#How to Build / Run#

##Check Dependencies / Path##

First please check that you've build / installed all the dependencies properly and that they are on your PATH. For the first three dependencies, this can quickly checked via:

```bash
which curl
which wgrib2
which cmake
```

ITK's default install location should be ```/usr/local``` and it should have placed files in

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

These processing routines can take a good 20-30 minutes. That timing may vary depending on the specs of your system. Given the fact that this was designed to be a prototype of the data visualization and interaction mechanisms, I didn't really put any time into accelerating the data processing.

The download and processing are actually broken into independent sub-routines. For an overview, take a look at the ```getData.sh``` script in the ```processing``` directory.


## Run WeaVER ##

Once the data processing routines have finished, there should be a populated ```datasets``` directory in the main repository directory, along with an associated ```dataset.properties``` file. These, respectively, are where WeaVER expects to read data from.

You will likely need to increase the maximum amount of memory available to Processing due to the amount of data (~2Gb) WeaVER will attempt to read in. To do this, launch the Processing application and open the Preferences. Enable the 'Increase Maximum Available Memory' option and increase the value to to 2500 MB. That should be more than sufficient.

The simplest way to run WeaVER is to simply open ```WeaVER/WeaVER.pde``` directly in Processing and run it.

Alternatively, if you make sure ```processing-java``` is on your PATH, you can simply run the included script

```bash
./run.sh
```

On OSX, ```processing-java``` can be enabled on the command-line by opening the Processing application, going to the Tools menu (in the menu bar), and clicking "install processing-java" from the drop down. On Linux, ```processing-java``` is included in the ```processing.tgz``` download, so simply add the unpacked ```processing-2.2.1/``` directory to your PATH.

#### A Note on the Current Contour Boxplot Display ####

While the contour boxplot analysis is pre-processed, in order to create high-resolution bands for display, WeaVER currently generates and caches the bands on load, which takes a decent chunk of time. On my system, it adds about 5 minutes to the load process.  

At the top of the ```WeaVER/EnsembleView.pde``` file, there are 2 boolean flags you can use to modify WeaVER's default behavior.

```java
	private boolean demo_min = false; // if true, only loads 4 ensembles of features
	private boolean cacheMe = true; // setting false offloads contour boxplot envelope generation to the display loop -- shorter load time, but less responsive
```

Changing ```demo_min``` to ```true``` will load only 4 features for a minimum demo, which should reduce the load time by almost two thirds. Alternatively, you can turn off caching which minimizes load time by moving the band / envelope generation into the draw loop. While the cost in terms of interactivity isn't too bad for a single contour box plot feature, the simultaneous display of 3 features does incur a pretty significant performance hit (2-3 seconds between frames). As such, I don't really recommend disabling caching in this version of the code.

#License + Attributions#

The code contained within this repository is released under the [MIT License](https://tldrlegal.com/license/mit-license). 

The contour boxplot code was written by [Mahsa Mirzargar](http://www.cs.miami.edu/home/mirzargar/) and is being made available with her permission, along with that of [Ross Whittaker](http://www.cs.utah.edu/~whitaker/), and [Mike Kirby](http://www.cs.utah.edu/~kirby/). All other code was written by [Sam Quinan](http://www.sci.utah.edu/~samquinan/) and is being made available with his permission along with that of [Miriah Meyer](https://www.cs.utah.edu/~miriah/). 

This work was funded by NSF Grant IIS–1212806.

#Questions? Comments#

Feel free to contact [Sam Quinan](http://www.sci.utah.edu/~samquinan/).
