project(@CIRCUIT_NAME_CAMEL@)

set(SOURCE_CIRCUIT_NAME "@CIRCUIT_NAME@")

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

add_library(witnesscalc_${PROJECT_NAME}Objects OBJECT ${SOURCES})
add_library(witnesscalc_${PROJECT_NAME}Static STATIC ${SOURCES})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES OUTPUT_NAME witnesscalc_${PROJECT_NAME})
set_target_properties(witnesscalc_${PROJECT_NAME}Static PROPERTIES POSITION_INDEPENDENT_CODE ON)
set_target_properties(witnesscalc_${PROJECT_NAME}Objects PROPERTIES POSITION_INDEPENDENT_CODE ON)

if (WITH_IMPLEMENTATIONS)
    install(TARGETS witnesscalc_${PROJECT_NAME}Static
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
    )
endif ()
