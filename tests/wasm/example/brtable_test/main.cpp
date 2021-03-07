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




//////int 
int main() {
	return 0;
}
