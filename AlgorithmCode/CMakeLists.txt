project(Place_Recognition)
cmake_minimum_required(VERSION 2.8.3)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall")

include_directories(
    "${CMAKE_SOURCE_DIR}/source"
    "${CMAKE_SOURCE_DIR}"
)

add_executable( Place_Recognition source/main.cpp )
