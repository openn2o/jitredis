#include <cheerp/types.h>

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

/// strcut 
class MyValue {
public:
	MyValue();
	int incr (int i) {
		return count ++;
	}

	int get_val() {
		return count;
	}
private:
	int count = 0;
};

[[cheerp::jsexport]]
int main() {
	////const str
	Value my_str = ccm1::string_new("i am const1");
	for(int i =0; i < 2; i++) {
		ccm1::string_log(string_from_cstr_to_value("hello"));
	}
	ccm1::string_log(my_str);
	
	////string buffer
	Value string_buff = ccm1::dynamic_string_new();
	ccm1::dynamic_string_append(string_buff, 
								string_from_cstr_to_value("i am const2,"));
	ccm1::dynamic_string_append(string_buff,
								my_str);
	ccm1::dynamic_string_log(string_buff);
	/////
	ccm1::dynamic_string_log(ccm1::dynamic_string_join(string_buff));

	MyValue * m = new MyValue();
	m->incr(10);
	m->incr(10);
	m->incr(10);
	return m->get_val();
}




