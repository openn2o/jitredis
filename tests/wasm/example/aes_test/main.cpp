#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

#define Value int
namespace ccm1 {
	Value  string_new (const char *);
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value , int len);

	////dynamic string
	Value dynamic_string_new();
	void log(Value);
};

using namespace ccm1;


[[cheerp::jsexport]]
int main() {
	
	
	Value my_str = ccm1::string_new("i am");

	for(int i =0; i < 1000; i++) {
		ccm1::log(string_from_cstr_to_value("hello"));
	}
	
	ccm1::log(my_str);

	////stringbuffer
	Value string_buff = ccm1::dynamic_string_new();
	
	/////
	return 0;
}
