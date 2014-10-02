
cmake_minimum_required(VERSION 2.8)

PROJECT(main)

find_package(ITK REQUIRED)
include(${ITK_USE_FILE})

add_executable(main main.cpp Utility.h Utility.cpp CBD.h CBD.cpp CCLabeling.h CCLabeling.cpp ContourExtraction.h ContourExtraction.cpp EnsembleHandler.h EnsembleHandler.cpp Matrix.h SVG.h SVG.cpp)

target_link_libraries(main ${VTK_LIBRARIES} ${ITK_LIBRARIES})
