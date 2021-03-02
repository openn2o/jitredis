#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>
#define uint8 unsigned char


namespace client {
	void print_n(int i);
};
////
[[cheerp::jsexport]]
void get_module_version2 (uint8* BUFF, int n) {
	///指针
	for(int i = *BUFF; i< *BUFF+n; i++) {
		client::print_n(i);
		client::print_n(0);
		client::print_n(1);
		BUFF[i] = 0;
	}
}

//////int 
int main() {
}



