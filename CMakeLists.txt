cmake_minimum_required(VERSION 3.5)

include(cmake/platform.cmake)

set(USE_ASM ON CACHE BOOL "Use asm implementation for Fr and Fq")

project(witnesscalc LANGUAGES CXX ASM)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message("USE_ASM=" ${USE_ASM})
message("CMAKE_CROSSCOMPILING=" ${CMAKE_CROSSCOMPILING})

message("GMP_PREFIX=" ${GMP_PREFIX})
message("GMP_INCLUDE_DIR=" ${GMP_INCLUDE_DIR})
message("GMP_LIB_DIR=" ${GMP_LIB_DIR})

if (NOT EXISTS ${GMP_INCLUDE_FILE_FULLPATH})
    message("WARNING: ${GMP_INCLUDE_FILE_FULLPATH} is not found and so system ${GMP_INCLUDE_FILE} is used.")
endif ()

if (NOT EXISTS ${GMP_LIB_FILE_FULLPATH})
    message("WARNING: ${GMP_LIB_FILE_FULLPATH} is not found and so system ${GMP_LIB_FILE} is used.")
    set(GMP_LIB gmp)
endif ()

include_directories(
    src
    src/fr
    depends/json/single_include
)
include_directories(BEFORE ${GMP_INCLUDE_DIR})

link_libraries(${GMP_LIB})
add_definitions(${GMP_DEFINIONS})

if (USE_ASM)
    if (ARCH MATCHES "arm64")
        add_definitions(-DUSE_ASM -DARCH_ARM64)
    elseif (ARCH MATCHES "x86_64")
        add_definitions(-DUSE_ASM -DARCH_X86_64)
    endif ()
endif ()

if (USE_ASM AND ARCH MATCHES "x86_64")

    if (CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin" AND NOT TARGET_PLATFORM MATCHES "^android(_x86_64)?")
        set(NASM_FLAGS -fmacho64 --prefix _)
    else ()
        set(NASM_FLAGS -felf64 -DPIC)
    endif ()

    add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/src/fr/fq_asm.o
        COMMAND nasm ${NASM_FLAGS} fq.asm -o fq_asm.o
        DEPENDS ${CMAKE_SOURCE_DIR}/src/fr/fq.asm
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src/fr)

    add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/src/fr/fr_asm.o
        COMMAND nasm ${NASM_FLAGS} fr.asm -o fr_asm.o
        DEPENDS ${CMAKE_SOURCE_DIR}/src/fr/fr.asm
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/src/fr)
endif ()

set(FR_SOURCES
    ${CMAKE_SOURCE_DIR}/src/fr/fr.hpp
    ${CMAKE_SOURCE_DIR}/src/fr/fr.cpp
)

if (USE_ASM)
    if (ARCH MATCHES "arm64")
        set(FR_SOURCES ${FR_SOURCES}
            ${CMAKE_SOURCE_DIR}/src/fr/fr_raw_arm64.s
            ${CMAKE_SOURCE_DIR}/src/fr/fr_raw_generic.cpp
            ${CMAKE_SOURCE_DIR}/src/fr/fr_generic.cpp
        )
    elseif (ARCH MATCHES "x86_64")
        set(FR_SOURCES ${FR_SOURCES}
            ${CMAKE_SOURCE_DIR}/src/fr/fr_asm.o
        )
    endif ()
else ()
    set(FR_SOURCES ${FR_SOURCES}
        ${CMAKE_SOURCE_DIR}/src/fr/fr_generic.cpp
        ${CMAKE_SOURCE_DIR}/src/fr/fr_raw_generic.cpp
    )
endif ()

add_library(fr STATIC ${FR_SOURCES})
set_target_properties(fr PROPERTIES POSITION_INDEPENDENT_CODE ON)
link_libraries(fr)

add_executable(tests src/tests.cpp)
add_executable(test_platform src/test_platform.cpp)


#set(LIB_SOURCES
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/calcwit.cpp
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/witnesscalc.h
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/witnesscalc.cpp
#    CACHE INTERNAL "Library sources"
#)


set(WC_LIBS "")
include(cmake/circuits_source_generator.cmake)
include(cmake/lib_source_generator.cmake)

set(AGGREGATED_LIB_SOURCES ${CMAKE_BINARY_DIR}/witness_calculator.h ${CMAKE_BINARY_DIR}/witness_calculator.cpp)
add_library(witness_calculator SHARED ${AGGREGATED_LIB_SOURCES})
target_compile_definitions(witness_calculator PRIVATE WITNESS_CALCULATOR_EXPORT)
target_link_libraries(witness_calculator PRIVATE ${WC_LIBS})

# Create the final static library
add_library(witness_calculatorStatic STATIC ${AGGREGATED_LIB_SOURCES})

# Dynamically add objects from WC_LIBS
foreach (lib ${WC_LIBS})
    target_sources(witness_calculatorStatic PRIVATE $<TARGET_OBJECTS:${lib}>)
endforeach ()

# Set output properties for the static library
set_target_properties(witness_calculatorStatic PROPERTIES
    OUTPUT_NAME witness_calculator
)

install(TARGETS
    fr
    witness_calculatorStatic
    witness_calculator
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    BUNDLE DESTINATION ${CMAKE_INSTALL_PREFIX}/app
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(FILES "${GMP_LIB_DIR}/${GMP_LIB_FILE}"
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(FILES
    ${CMAKE_BINARY_DIR}/witness_calculator.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
