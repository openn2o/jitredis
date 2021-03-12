#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

#define Value int

#include <string>
namespace ccm1 {
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value , int len);
};

using namespace ccm1;

[[cheerp::jsexport]]
Value djb_hash(Value ptr, int len) {
	char * str = string_from_value_to_cstr(ptr, len);
	Value hash = 5381;
	while (*str){
		hash = ((hash << 5) + hash) + (*str++); 
	}
	hash &= ~(1 << 31); 
	return hash;
}



[[cheerp::jsexport]]
Value murmur_hash2(Value ptr, int len)
{
	char * data = string_from_value_to_cstr(ptr, len);
	Value h, k;
	
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
	
	return h;
}

[[cheerp::jsexport]]
int main() {
	return 0;
}
