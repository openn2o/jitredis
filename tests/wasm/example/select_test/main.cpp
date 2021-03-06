#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

[[cheerp::jsexport]]
int test_max1 (int a, int b) {
	if (a > b) {
		return a;
	}	
	return b;
}

[[cheerp::jsexport]]
int test_max2 (int a, int b) {
	return (a > b ? a: b);
}

[[cheerp::jsexport]]
int test_max3 (int a, int b) {
	int max = 0;
	if (a > b) {
		max = a;
	} else {
		max = b;
	} 
    return max;
}

[[cheerp::jsexport]]
int test_max4 (int a, int b) {
	int max = 0;
	if (a > b) {
		max = a;
	} else {
		max = b;
	} 

	max = max * 100;

    return max;
}




//////int 
int main() {
	return 0;
}
