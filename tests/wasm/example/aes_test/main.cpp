#include <cheerp/types.h>

#define Value int
#define uint8 unsigned char
namespace ccm1 {
	/// warp
	Value  warp_from_uint8ptr_to_value(uint8 *);
	uint8* warp_from_value_to_uint8ptr(Value);
	///const string
	Value  string_new (const char *);
	Value  string_from_cstr_to_value(const char *);
	char * string_from_value_to_cstr(Value, int);
	void   string_log(Value);
	///dynamic string
	Value dynamic_string_new();
	Value dynamic_string_append(Value, Value);
	void  dynamic_string_log(Value);
	Value dynamic_string_join(Value);
};

using namespace ccm1;

[[cheerp::jsexport]]
void TA_HexToStr(Value a, Value b, int Len){ 
	uint8 *out = (ccm1::warp_from_value_to_uint8ptr(a));
	uint8 *in =  (ccm1::warp_from_value_to_uint8ptr(b));

	char ddl = 0,ddh = 0; 
	int i = 0; 

	for (i=0; i<Len; i++){ 
		ddh = '0' + in[i] / 16; 
		ddl = '0' + in[i] % 16; 
		if (ddh > '9') 
		ddh = ddh + 7; 
		if (ddl > '9') 
		ddl = ddl + 7; 
		out[i*3] = ddh; 
		out[i*3+1] = ddl; 
		out[i*3+2] = ' '; 
	} 

	out[Len*3] = '\0'; 
} 

void TA_HexToStr2(uint8 *out, uint8 *in, int Len){ 
	char ddl = 0,ddh = 0; 
	int i = 0; 

	for (i=0; i<Len; i++){ 
		ddh = '0' + in[i] / 16; 
		ddl = '0' + in[i] % 16; 
		if (ddh > '9') 
		ddh = ddh + 7; 
		if (ddl > '9') 
		ddl = ddl + 7; 
		out[i*3] = ddh; 
		out[i*3+1] = ddl; 
		out[i*3+2] = ' '; 
	} 

	out[Len*3] = '\0'; 
} 
[[cheerp::jsexport]]
int main() {
	////const str
	Value my_str = ccm1::string_new("i am const1");
	for(int i =0; i < 1000; i++) {
		ccm1::string_log(string_from_cstr_to_value("hello"));
	}
	ccm1::string_log(my_str);
	
	////string buffer
	Value string_buff = ccm1::dynamic_string_new();
	ccm1::dynamic_string_append(string_buff, 
								string_from_cstr_to_value("i am const2,"));
	ccm1::dynamic_string_append(string_buff,
								my_str);
	ccm1::dynamic_string_log(string_buff);
	/////
	ccm1::dynamic_string_log(ccm1::dynamic_string_join(string_buff));

    uint8 pow[256] ={7,8,9,10,11,12,13};
    // uint8 log[256] = {8,9,10,11,12,13,14};
 	uint8 log[256];

	TA_HexToStr2(pow, log, 7);

	ccm1::dynamic_string_log(warp_from_uint8ptr_to_value(pow));
	return 0;
}


