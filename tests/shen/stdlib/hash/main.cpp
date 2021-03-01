#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>
#define _STATIC_CAST_ __builtin_cheerp_make_regular
extern "C" {
#include "stdlib.h"
}

////
// 增加range范围
////
[[cheerp::jsexport]]
unsigned int DJBHash(char *str, int len, int range)    
{    
    unsigned int hash = 5381;    
    int i = 0;
	/*while ( i < len ) {
		hash = ((hash << 5) + hash) + (*str++);
		i++;
	} */
	while ( i++ <= len ) {
		hash = ((hash << 5) + hash) + str[i];//(*str++);
	} 
    hash &= ~(1 << 31); /* strip the highest bit */
    return hash % range;    
}

////
// hash 算法2
////

[[cheerp::jsexport]]
unsigned int hash2 (char *data, int len,  int range)
{
	int h, k;
	 
	h = 0 ^ len;
	 
	while (len >= 4) {
		k = data[0];
		k |= data[1] << 8;
		k |= data[2] << 16;
		k |= data[3] << 24;
		 
		k *= 0x5bd1e995;
		k ^= k >> 24;
		k *= 0x5bd1e995;
		 
		h *= 0x5bd1e995;
		h ^= k;
		 
		data += 4;
		len -= 4;
	}
 
	switch (len) {
		case 3:
		h ^= data[2] << 16;
		case 2:
		h ^= data[1] << 8;
		case 1:
		h ^= data[0];
		h *= 0x5bd1e995;
	}
	 
	h ^= h >> 13;
	h *= 0x5bd1e995;
	h ^= h >> 15;
	return h % range; 
}


int main() {
	return 0;
}



