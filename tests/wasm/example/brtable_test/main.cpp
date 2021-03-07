#include <cheerp/client.h>
#include <cheerp/clientlib.h>
#include <cheerp/types.h>

[[cheerp::jsexport]]
int brtable_month_day_p(int m) {
	switch (m) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
		case 4:
		case 6:
		case 9:
		case 11:
			return 30;
		default :
			return 28;
	}
	return 31;
}


// [[cheerp::jsexport]]
// int b64_int (int ch) {

// 	if (ch==43) {
// 		return 62;
// 	}
	
// 	if (ch==47) {
// 		return 63;
// 	}
	
// 	if (ch==61) {
// 		return 64;
// 	}
	
// 	if ((ch>47) && (ch<58)) {
// 		return ch + 4;
// 	}
	
// 	if ((ch>64) && (ch<91)) {
// 		return ch - 'A';
// 	}
	
// 	if ((ch>96) && (ch<123)) {
// 		return (ch - 'a') + 26;
// 	}
	
// 	return 0;
// }

[[cheerp::jsexport]]
int fab (int n) {
	if(n == 1||n ==2) {
		return 1;
	} 
	return fab(n-1) + fab(n-2);
}


//////int 
int main() {
	return 0;
}
