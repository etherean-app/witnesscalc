project(commitment)

set(SOURCE_CIRCUIT_NAME "Commitment")

set(SOURCES
    calcwit.cpp
    witnesscalc.h
    witnesscalc.cpp
    circom.hpp
    ${SOURCE_CIRCUIT_NAME}.cpp
    witnesscalc_${PROJECT_NAME}.h
    witnesscalc_${PROJECT_NAME}.cpp
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(witnesscalc_${PROJECT_NAME}Static STATIC ${SOURCES})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES OUTPUT_NAME witnesscalc_${PROJECT_NAME})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES POSITION_INDEPENDENT_CODE ON)
