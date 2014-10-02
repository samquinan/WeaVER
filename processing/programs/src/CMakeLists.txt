cmake_minimum_required(VERSION 2.8)
PROJECT(derivedData)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_CXX_FLAGS "-std=c++11 -stdlib=libc++")

SET(total_acc_SRCS total_acc.cpp utils.h)
add_executable(totalAcc ${total_acc_SRCS})

SET(x_hr_acc_SRCS x_hr_acc.cpp utils.h)
add_executable(xHrAcc ${x_hr_acc_SRCS})

SET(gen_stats_SRCS gen_stats.cpp utils.h)
add_executable(genStats ${gen_stats_SRCS})

SET(mean_wind_SRCS mean_wind.cpp utils.h)
add_executable(meanWind ${mean_wind_SRCS})
	
SET(member_wind_SRCS gen_wind_speed.cpp utils.h)
add_executable(perMemberWindSpeed ${member_wind_SRCS})

SET(prob_SRCS probability.cpp utils.h)
add_executable(genProb ${prob_SRCS})


