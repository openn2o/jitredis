#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

#define Value int
namespace ccm1 {
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value , int len);
	void log(Value);
};

using namespace ccm1;


[[cheerp::jsexport]]
int main() {
	ccm1::log(string_from_cstr_to_value("hello"));
	return 0;
}
