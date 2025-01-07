project(passportVerificationValidity)

message(STATUS "LIB_SOURCES: ${LIB_SOURCES}")
set(SOURCES ${LIB_SOURCES}
    PassportVerificationValidity.cpp
    witnesscalc_passportVerificationValidity.h
    witnesscalc_passportVerificationValidity.cpp
)

add_library(witnesscalc_${PROJECT_NAME} SHARED ${SOURCES})
add_library(witnesscalc_${PROJECT_NAME}Static STATIC ${SOURCES})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES OUTPUT_NAME witnesscalc_${PROJECT_NAME})

add_executable(${PROJECT_NAME} ../../main.cpp)
target_link_libraries(${PROJECT_NAME} witnesscalc_${PROJECT_NAME}Static)

target_compile_definitions(witnesscalc_${PROJECT_NAME} PUBLIC CIRCUIT_NAME=${PROJECT_NAME})
target_compile_definitions(witnesscalc_${PROJECT_NAME}Static PUBLIC CIRCUIT_NAME=${PROJECT_NAME})
target_compile_definitions(${PROJECT_NAME} PUBLIC CIRCUIT_NAME=${PROJECT_NAME})

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

install(FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/PassportVerificationValidity.dat
    DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

install(FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/witnesscalc_${PROJECT_NAME}.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
