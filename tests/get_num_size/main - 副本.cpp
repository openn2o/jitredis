#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>
#define _STATIC_CAST_ __builtin_cheerp_make_regular
extern "C" {
#include "stdlib.h"
}

#define uint8 unsigned char

////
// 增加range范围
////
// [[cheerp::jsexport]]
// unsigned int DJBHash(char *str, int len, int range)    
// {    
//     unsigned int hash = 5381;    
//     int i = 0;
// 	while ( i < len ) {
// 		hash = ((hash << 5) + hash) + (*str++);
// 		i++;
// 	} 
//     hash &= ~(1 << 31); /* strip the highest bit */
//     return hash % range;    
// }


[[cheerp::jsexport]]
int fib(int n)
{
    int y;
    if(n==1||n==2)
    {
        y=1;
    }
    else
    {
        y=fib(n-1)+fib(n-2);
    }
    return y;
}

///////// void * 
#define VAR void * 
/////////out 
//////// int [ok]
[[cheerp::jsexport]]
unsigned int size_of (double n)    
{    
	struct FalseSharing
	{
		char padding1[60];
		volatile int takeIndex;
		char padding2[60];
		volatile int putIndex;
		char padding3[60];
	} EAX;
	
	for (int i = 0; i <  10000; i++) {
		EAX.takeIndex = 1;
		EAX.putIndex  = 2;
	}
	return EAX.putIndex;
}


///////char * [ok]
[[cheerp::jsexport]]
const char * get_module_name () {
	const char * hello = "hello";
	return hello;
}

////
//  ddd->
////
[[cheerp::jsexport]]
void get_module_version2 (uint8* BUFF, int n) {
	///指针
	for(int i = *BUFF; i< *BUFF+n; i++) {
		BUFF[i] = 0;
	}
}

///////uint8 [ok]
[[cheerp::jsexport]]
uint8 get_module_version () {
	return 255;
}

//////int 
int main() {
	return fib(40);
}



