#include "witnesscalc_@CIRCUIT_NAME_CAMEL@.h"
#include "witnesscalc.h"

@DAT_FILE@

int witnesscalc_@CIRCUIT_NAME_CAMEL@(
    const char* json_buffer,
    unsigned long json_size,
    char* wtns_buffer,
    unsigned long* wtns_size,
    char* error_msg,
    unsigned long error_msg_maxsize
) {
    return @CIRCUIT_NAME_CAMEL@::witnesscalc(
        reinterpret_cast<const char *>(@CIRCUIT_NAME@_dat),
        @CIRCUIT_NAME@_dat_len,
        json_buffer,
        json_size,
        wtns_buffer,
        wtns_size,
        error_msg,
        error_msg_maxsize
    );
}
