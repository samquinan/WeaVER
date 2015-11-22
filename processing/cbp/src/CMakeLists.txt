
cmake_minimum_required(VERSION 2.8)

PROJECT(CBD)

find_package(OpenMP)
if (OPENMP_FOUND)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
endif()

find_package(ITK REQUIRED)
include(${ITK_USE_FILE})

add_executable(CBD main.cpp Utility.h Utility.cpp CBD.h CBD.cpp EnsembleHandler.h EnsembleHandler.cpp Matrix.h)

target_link_libraries(CBD ${ITK_LIBRARIES})
