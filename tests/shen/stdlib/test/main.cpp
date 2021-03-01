#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

extern "C" {
#include "stdlib.h"
}

////
// 增加range范围
////
//#define NULL 0
#define KNUM 1
#define KSTR 2
#define KOBJECT 3
#define KARRAY 4

#define BLOCK_SIZE 16

////获取指针数据的地址
[[cheerp::jsexport]] int test1 (int * ptr) {
	return  *(ptr+3);
}


[[cheerp::jsexport]] int test2 (int * ptr) {
	*(ptr+1) = 0;
	*(ptr+2) = 1;
	*(ptr+3) = 2;
	return *(ptr);
}

[[cheerp::jsexport]] int* test3 (int * ptr) {
	int buff [3] = {1,1,1} ;
	return buff;
}




/*
[[cheerp::jsexport]] unsigned int* shen_malloc (int size)    
{    
	return (unsigned int*) malloc(size);
}*/


int main() {
	return 0;
}



