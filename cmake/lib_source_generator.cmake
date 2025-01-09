# Prepare the header and source files
set(header_file "${CMAKE_BINARY_DIR}/witness_calculator.h")
set(source_file "${CMAKE_BINARY_DIR}/witness_calculator.cpp")

# Open header file and write contents
file(WRITE "${header_file}" "#pragma once\n\n")
file(APPEND "${header_file}" "#ifdef __cplusplus\nextern \"C\" {\n#endif\n\n")
file(APPEND "${header_file}" "#define WITNESSCALC_OK                  0x0\n")
file(APPEND "${header_file}" "#define WITNESSCALC_ERROR               0x1\n")
file(APPEND "${header_file}" "#define WITNESSCALC_ERROR_SHORT_BUFFER  0x2\n\n")

# Open source file and write contents
file(WRITE "${source_file}" "#include \"witness_calculator.h\"\n\n")

set(index 0)
foreach(func ${CIRCUIT_NAMES_CAMEL})

    list(GET CIRCUIT_NAMES ${index} CIRCUIT_NAME_PASCAL)

    # Generate function declarations for the header file
    file(APPEND "${header_file}" "int calculate_witness_${func}(\n")
    file(APPEND "${header_file}" "    const char* json_buffer,\n")
    file(APPEND "${header_file}" "    unsigned long json_size,\n")
    file(APPEND "${header_file}" "    char* wtns_buffer,\n")
    file(APPEND "${header_file}" "    unsigned long* wtns_size,\n")
    file(APPEND "${header_file}" "    char* error_msg,\n")
    file(APPEND "${header_file}" "    unsigned long error_msg_maxsize\n")
    file(APPEND "${header_file}" ");\n\n")

    # Generate function implementations for the source file
    file(APPEND "${source_file}" "#include \"circuits/${CIRCUIT_NAME_PASCAL}/witnesscalc_${func}.h\"\n\n")
    file(APPEND "${source_file}" "int calculate_witness_${func}(\n")
    file(APPEND "${source_file}" "    const char* json_buffer,\n")
    file(APPEND "${source_file}" "    unsigned long json_size,\n")
    file(APPEND "${source_file}" "    char* wtns_buffer,\n")
    file(APPEND "${source_file}" "    unsigned long* wtns_size,\n")
    file(APPEND "${source_file}" "    char* error_msg,\n")
    file(APPEND "${source_file}" "    unsigned long error_msg_maxsize\n")
    file(APPEND "${source_file}" ") {\n")
    file(APPEND "${source_file}" "  return witnesscalc_${func}(\n")
    file(APPEND "${source_file}" "      json_buffer,\n")
    file(APPEND "${source_file}" "      json_size,\n")
    file(APPEND "${source_file}" "      wtns_buffer,\n")
    file(APPEND "${source_file}" "      wtns_size,\n")
    file(APPEND "${source_file}" "      error_msg,\n")
    file(APPEND "${source_file}" "      error_msg_maxsize\n")
    file(APPEND "${source_file}" "  );\n}\n\n")

    math(EXPR index "${index} + 1")
endforeach()

# Close header file
file(APPEND "${header_file}" "#ifdef __cplusplus\n}\n#endif\n")
