cmake_minimum_required(VERSION 3.20)

project(whitecellsimulator LANGUAGES CXX)

include(${CMAKE_CURRENT_SOURCE_DIR}/engine/cmake/FriedEngine.cmake)

fried_add_game(whitecellsimulator)
