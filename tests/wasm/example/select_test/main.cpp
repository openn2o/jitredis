

#define Value int
#define uint8 unsigned char
namespace ccm1 {
	/// warp
	Value  warp_from_uint8ptr_to_value(uint8 *);
	uint8* warp_from_value_to_uint8ptr(Value);
	///const string
	Value  string_new (const char *);
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value, int);
	void   string_log (Value);

	///dynamic string
	Value dynamic_string_new();
	Value dynamic_string_append(Value, Value);
	void  dynamic_string_log(Value);
	Value dynamic_string_join(Value);
	void  log(int i);	
};


[[cheerp::jsexport]]
Value ccm1_cheerp_version () {
	uint8 ccm1_magic[7]  = {
	'c','h','e','e','r','p', 0
	};

	ccm1::string_log(ccm1::warp_from_uint8ptr_to_value(ccm1_magic));
	return ccm1::warp_from_uint8ptr_to_value(ccm1_magic);
}


[[cheerp::jsexport]]
Value ccm1_cheerp_version2 () {
	uint8 ccm1_magic[7]  = {
	'p','h','e','e','r','p', 0
	};
	ccm1::string_log(ccm1::warp_from_uint8ptr_to_value(ccm1_magic));
	return ccm1::warp_from_uint8ptr_to_value(ccm1_magic);
}



using namespace ccm1;


#define BASE64_PAD '='
#define BASE64DE_FIRST '+'
#define BASE64DE_LAST 'z'

/* BASE 64 encode table */
static const uint8 base64en[] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
	'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
	'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
	'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3',
	'4', '5', '6', '7', '8', '9', '+', '/',
};

/// 26 指令
[[cheerp::jsexport]]
int t1 (int n, uint8 target) {
    int i = 0;
    while (i<n) {
    	if(base64en[i] == target) break;
        i++;
    }
	return i < n ? i : -1;
}

/// 22 指令
[[cheerp::jsexport]]
int t2 (int n, uint8 target) {
    while (--n >= 0) {
    	if(base64en[n] == target) 
			return n;
    }
	return -1;
}

int main() {
	uint8 in = 'H';
	return t1 (sizeof(base64en), in);
}


