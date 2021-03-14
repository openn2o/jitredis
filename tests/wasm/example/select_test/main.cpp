  


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
	void   string_log(Value);
	///dynamic string
	Value dynamic_string_new();
	Value dynamic_string_append(Value, Value);
	void  dynamic_string_log(Value);
	Value dynamic_string_join(Value);
};

using namespace ccm1;

[[cheerp::jsexport]]
int test_max1 (int a, int b) {
	if (a > b) {
		return a;
	}	
	return b;
}

[[cheerp::jsexport]]
int test_max2 (int a, int b) {
	return (a > b ? a: b);
}

[[cheerp::jsexport]]
int test_max3 (int a, int b) {
	int max = 0;
	if (a > b) {
		max = a;
	} else {
		max = b;
	} 
    return max;
}

[[cheerp::jsexport]]
int test_max4 (int a, int b) {
	int max = 0;
	if (a > b) {
		max = a;
	} else {
		max = b;
	} 

	max = max * 100;

    return max;
}


int main() {
	return 0;
}