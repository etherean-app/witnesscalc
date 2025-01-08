project(passportVerificationValidityWithCountryIn)

set(SOURCE_CIRCUIT_NAME "PassportVerificationValidityWithCountryIn")


message(STATUS "LIB_SOURCES: ${LIB_SOURCES}")
set(SOURCES ${LIB_SOURCES}
    ${SOURCE_CIRCUIT_NAME}.cpp
    witnesscalc_${PROJECT_NAME}.h
    witnesscalc_${PROJECT_NAME}.cpp
)


execute_process(
    COMMAND bash -c "xxd -i ${SOURCE_CIRCUIT_NAME}.dat | sed 's/unsigned char/const unsigned char/g' > ${CMAKE_CURRENT_BINARY_DIR}/${SOURCE_CIRCUIT_NAME}_dat.h"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_library(witnesscalc_${PROJECT_NAME} SHARED ${SOURCES})
add_library(witnesscalc_${PROJECT_NAME}Static STATIC ${SOURCES})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES OUTPUT_NAME witnesscalc_${PROJECT_NAME})

add_executable(${PROJECT_NAME} ../../main.cpp)
target_link_libraries(${PROJECT_NAME} witnesscalc_${PROJECT_NAME}Static)

target_compile_definitions(witnesscalc_${PROJECT_NAME} PUBLIC
    CIRCUIT_NAME=${PROJECT_NAME}
    DAT_FILE_BINARY=${SOURCE_CIRCUIT_NAME}_dat
    DAT_FILE_LEN=${SOURCE_CIRCUIT_NAME}_dat_len
)
target_compile_definitions(witnesscalc_${PROJECT_NAME}Static PUBLIC
    CIRCUIT_NAME=${PROJECT_NAME}
    DAT_FILE_BINARY=${SOURCE_CIRCUIT_NAME}_dat
    DAT_FILE_LEN=${SOURCE_CIRCUIT_NAME}_dat_len
)
target_compile_definitions(${PROJECT_NAME} PUBLIC
    CIRCUIT_NAME=${PROJECT_NAME}
    DAT_FILE_BINARY=${SOURCE_CIRCUIT_NAME}_dat
    DAT_FILE_LEN=${SOURCE_CIRCUIT_NAME}_dat_len
)

install(TARGETS
    ${PROJECT_NAME}
    DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

install(TARGETS
    witnesscalc_${PROJECT_NAME}
    witnesscalc_${PROJECT_NAME}Static
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/witnesscalc_${PROJECT_NAME}.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
