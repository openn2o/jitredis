#include <stdio.h>

int fab (int n) {
	if(n == 1||n ==2) {
		return 1;
	} 
	return fab(n-1) + fab(n-2);
}



int main() {
	for(int i = 2; i<= 40; i++) {
		printf(fab(i));
	}
	return 0;
}
