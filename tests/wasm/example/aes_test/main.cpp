#include <cheerp/types.h>

#define Value int

namespace ccm1 {
	Value  string_new (const char *);
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value, int);
	void   string_log(Value);
	////dynamic string
	Value dynamic_string_new();
	Value dynamic_string_append(Value, Value);
	void  dynamic_string_log(Value);
	Value dynamic_string_join(Value);
};

using namespace ccm1;

[[cheerp::jsexport]]
int main() {
	////const str
	Value my_str = ccm1::string_new("i am const1");
	for(int i =0; i < 1000; i++) {
		ccm1::string_log(string_from_cstr_to_value("hello"));
	}
	ccm1::string_log(my_str);
	
	////string buffer
	Value string_buff = ccm1::dynamic_string_new();
	ccm1::dynamic_string_append(string_buff,string_from_cstr_to_value("i am const2,"));
	ccm1::dynamic_string_append(string_buff,my_str);
	ccm1::dynamic_string_log(string_buff);
	/////
	ccm1::dynamic_string_log(ccm1::dynamic_string_join(string_buff));
	return 0;
}
