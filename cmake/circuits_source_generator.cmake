# Fetch and build circuits during configuration time
set(CIRCUITS_SOURCE_DIR "${CMAKE_SOURCE_DIR}/depends/zk-circuits")

if (NOT EXISTS "${CIRCUITS_SOURCE_DIR}")
    execute_process(
        COMMAND git clone git@github.com:etherean-app/zk-circuits.git ${CIRCUITS_SOURCE_DIR}
        RESULT_VARIABLE GIT_CLONE_RESULT
    )
    if (GIT_CLONE_RESULT)
        message(FATAL_ERROR "Failed to clone zk-circuits repository.")
    endif ()
endif ()

execute_process(
    COMMAND npm install
    WORKING_DIRECTORY ${CIRCUITS_SOURCE_DIR}
)

if (NOT EXISTS "${CIRCUITS_SOURCE_DIR}/zkit/artifacts/circuits")
    message(STATUS "Building circuits...")
    execute_process(
        COMMAND npx hardhat zkit make --c --force
        WORKING_DIRECTORY ${CIRCUITS_SOURCE_DIR}
    )
endif ()

# Function to lowercase the first character of a string
function(lowercase_first result input)
    string(SUBSTRING ${input} 0 1 FIRST_CHAR)
    string(TOLOWER ${FIRST_CHAR} FIRST_CHAR_LOWER)
    string(SUBSTRING ${input} 1 -1 REST_STRING)
    set(${result} "${FIRST_CHAR_LOWER}${REST_STRING}" PARENT_SCOPE)
endfunction()

# Process circuits immediately during configuration
file(GLOB CIRCUIT_DIRS ${CIRCUITS_SOURCE_DIR}/zkit/artifacts/circuits/*/*_cpp)
message(STATUS "Found circuits: (${CIRCUITS_SOURCE_DIR}/zkit/artifacts/circuits/*/*_cpp) ${CIRCUIT_DIRS}")
foreach (CIRCUIT ${CIRCUIT_DIRS})
    get_filename_component(CIRCUIT_NAME ${CIRCUIT} NAME_WE)
    string(REPLACE "_cpp" "" CIRCUIT_NAME ${CIRCUIT_NAME})

    # Apply lowercase first function
    lowercase_first(CIRCUIT_NAME_CAMEL ${CIRCUIT_NAME})

    # Create directories and copy sources
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME})

    execute_process(COMMAND ${CMAKE_COMMAND} -E copy
        ${CIRCUIT}/${CIRCUIT_NAME}.cpp
        ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/)

    execute_process(COMMAND ${CMAKE_COMMAND} -E copy
        ${CIRCUIT}/${CIRCUIT_NAME}.dat
        ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/)

    execute_process(COMMAND bash -c "${CMAKE_SOURCE_DIR}/patch_cpp.sh ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/${CIRCUIT_NAME}.cpp")

    # Configure templates
    message(STATUS "Generating circuit: ${CIRCUIT_NAME} (${CIRCUIT_NAME_CAMEL})")
    configure_file(
        ${CMAKE_SOURCE_DIR}/cmake/tpl/CMakeLists.tpl.cmake
        ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/CMakeLists.txt
        @ONLY
        NEWLINE_STYLE UNIX
    )
    configure_file(
        ${CMAKE_SOURCE_DIR}/cmake/tpl/witnesscalc_tpl.h
        ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/witnesscalc_${CIRCUIT_NAME_CAMEL}.h
        @ONLY
        NEWLINE_STYLE UNIX
    )
    configure_file(
        ${CMAKE_SOURCE_DIR}/cmake/tpl/witnesscalc_tpl.cpp
        ${CMAKE_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME}/witnesscalc_${CIRCUIT_NAME_CAMEL}.cpp
        @ONLY
        NEWLINE_STYLE UNIX
    )

    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/src/circuits/${CIRCUIT_NAME})
endforeach ()
