#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

#define Value int

#include <string>
namespace ccm1 {
	Value string_from_cstr(const char *);
};

using namespace ccm1;

[[cheerp::jsexport]]
Value export_string1 () {
	const char * hello = "hello1";
	Value s = string_from_cstr(hello);
	return s;
}

[[cheerp::jsexport]]
Value export_string2 () {
	const char * hello = "hello2";
	Value s = string_from_cstr(hello);
	return s;
}



[[cheerp::jsexport]]
int main() {
	return 0;
}
