

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
	void  log(int i);	
};

using namespace ccm1;


[[cheerp::jsexport]]
int fab (int n) {
	if(n == 1||n ==2) {
		return 1;
	} 
	return fab(n-1) + fab(n-2);
}

int main() {
	for(int i = 2; i<= 40; i++) {
		ccm1::log(fab(i));
	}
	return 0;
}


