#include "witnesscalc_commitment.h"
#include "witnesscalc.h"

#define STR(x) #x
#define INCLUDE_FILE(x) STR(x)
#include INCLUDE_FILE(DAT_FILE_BINARY.h)

int witnesscalc_commitment(
    const char* json_buffer,
    unsigned long json_size,
    char* wtns_buffer,
    unsigned long* wtns_size,
    char* error_msg,
    unsigned long error_msg_maxsize
) {
    return CIRCUIT_NAME::witnesscalc(
        reinterpret_cast<const char *>(DAT_FILE_BINARY),
        DAT_FILE_LEN,
        json_buffer,
        json_size,
        wtns_buffer,
        wtns_size,
        error_msg,
        error_msg_maxsize
    );
}
