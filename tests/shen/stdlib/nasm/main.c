
#include <stdio.h>


int my_function (a, b) {
	return a * b;
}

int main(void) {
	
	struct FalseSharing
	{
		char padding1[60];
		volatile int takeIndex;
		char padding2[60];
		volatile int putIndex;
		char padding3[60];
	} EAX;

	EAX.takeIndex = 1;
	int i   = 0;
	int sum = 0;
	for (i ; i <  100000000; i++) {
		sum = my_function(EAX.takeIndex, i) ;
	}
	printf("the num is %d" ,  sum);
	return 0;
}