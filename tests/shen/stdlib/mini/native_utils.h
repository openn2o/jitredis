#include <ctype.h>
#include <stdlib.h>
#include <stdint.h>

uint64_t read_LEB_(uint8_t *bytes, uint32_t *pos, uint32_t maxbits, bool sign) {
    uint64_t result = 0;
    uint32_t shift = 0;
    uint32_t bcnt = 0;
    uint32_t startpos = *pos;
    uint64_t  byte;

    while (true) {
        byte = bytes[*pos];
        *pos += 1;
        result |= ((byte & 0x7f)<<shift);
        shift += 7;
        if ((byte & 0x80) == 0) {
            break;
        }
        bcnt += 1;
        if (bcnt > (maxbits + 7 - 1) / 7) {
           /////return;
        }
    }
    if (sign && (shift < maxbits) && (byte & 0x40)) {
        // Sign extend
        result |= - (1 << shift);
    }
    return result;
}