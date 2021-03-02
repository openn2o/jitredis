#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>
#define uint8 unsigned char

namespace client {
	void print(int);
	void print(float);
	void print(double);
	void print(char *);
};


////
// [[cheerp::jsexport]]
// void get_module_version2 (uint8* BUFF, int n) {
// 	///指针
// 	for(int i = *BUFF; i< *BUFF+n; i++) {
// 		client::print(i);
// 		BUFF[i] = 0;
// 	}
// }

///malloc
///
[[cheerp::jsexport]]
void get_module_version2 (int addr, int n) {
	///指针
	uint8 * BUFF = (uint8 *)addr;
	
	for(int i = (int)&BUFF; i< (int)&BUFF+n; i++) {
		client::print(int(*&i));
	}
}

//////int 
int main() {
}



