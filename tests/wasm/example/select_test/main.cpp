

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
	void  log(int i);	
};

using namespace ccm1;

// [[cheerp::jsexport]]
// int test_max1 (int a, int b) {
// 	if (a > b) {
// 		return a;
// 	}	
// 	return b;
// }

// [[cheerp::jsexport]]
// int test_max2 (int a, int b) {
// 	return (a > b ? a: b);
// }

// [[cheerp::jsexport]]
// int test_max3 (int a, int b) {
// 	int max = 0;
// 	if (a > b) {
// 		max = a;
// 	} else {
// 		max = b;
// 	} 
//     return max;
// }

// [[cheerp::jsexport]]
// int test_max4 (int a, int b) {
// 	int max = 0;
// 	if (a > b) {
// 		max = a;
// 	} else {
// 		max = b;
// 	} 

// 	max = max * 100;
//     return max;
// }

// [[cheerp::jsexport]]
// int fab (int n) {
// 	if(n == 1||n ==2) {
// 		return 1;
// 	} 
// 	return fab(n-1) + fab(n-2);
// }

#define BASE64_PAD '='
#define BASE64DE_FIRST '+'
#define BASE64DE_LAST 'z'

/* BASE 64 encode table */
static const uint8 base64en[] = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
	'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
	'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
	'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3',
	'4', '5', '6', '7', '8', '9', '+', '/',
};


/* ASCII order for BASE 64 decode, 255 in unused character */
static const uint8 base64de[] = {
	/* nul, soh, stx, etx, eot, enq, ack, bel, */
	   255, 255, 255, 255, 255, 255, 255, 255,

	/*  bs,  ht,  nl,  vt,  np,  cr,  so,  si, */
	   255, 255, 255, 255, 255, 255, 255, 255,

	/* dle, dc1, dc2, dc3, dc4, nak, syn, etb, */
	   255, 255, 255, 255, 255, 255, 255, 255,

	/* can,  em, sub, esc,  fs,  gs,  rs,  us, */
	   255, 255, 255, 255, 255, 255, 255, 255,

	/*  sp, '!', '"', '#', '$', '%', '&', ''', */
	   255, 255, 255, 255, 255, 255, 255, 255,

	/* '(', ')', '*', '+', ',', '-', '.', '/', */
	   255, 255, 255,  62, 255, 255, 255,  63,

	/* '0', '1', '2', '3', '4', '5', '6', '7', */
	    52,  53,  54,  55,  56,  57,  58,  59,

	/* '8', '9', ':', ';', '<', '=', '>', '?', */
	    60,  61, 255, 255, 255, 255, 255, 255,

	/* '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', */
	   255,   0,   1,  2,   3,   4,   5,    6,

	/* 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', */
	     7,   8,   9,  10,  11,  12,  13,  14,

	/* 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', */
	    15,  16,  17,  18,  19,  20,  21,  22,

	/* 'X', 'Y', 'Z', '[', '\', ']', '^', '_', */
	    23,  24,  25, 255, 255, 255, 255, 255,

	/* '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', */
	   255,  26,  27,  28,  29,  30,  31,  32,

	/* 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', */
	    33,  34,  35,  36,  37,  38,  39,  40,

	/* 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', */
	    41,  42,  43,  44,  45,  46,  47,  48,

	/* 'x', 'y', 'z', '{', '|', '}', '~', del, */
	    49,  50,  51, 255, 255, 255, 255, 255
};

[[cheerp::jsexport]]
Value base64_encode(Value a , Value b , int size)
{
	uint8 * in   = ccm1::warp_from_value_to_uint8ptr(a);
	uint8 * out  = ccm1::warp_from_value_to_uint8ptr(b);
	int inlen = size;
	int s;
	unsigned int i;
	unsigned int j;
	unsigned char c;
	unsigned char l;

	s = 0;
	l = 0;
	for (i = j = 0; i < inlen; i++) {
		c = in[i];

		switch (s) {
		case 0:
			s = 1;
			out[j++] = base64en[(c >> 2) & 0x3F];
			break;
		case 1:
			s = 2;
			out[j++] = base64en[((l & 0x3) << 4) | ((c >> 4) & 0xF)];
			break;
		case 2:
			s = 0;
			out[j++] = base64en[((l & 0xF) << 2) | ((c >> 6) & 0x3)];
			out[j++] = base64en[c & 0x3F];
			break;
		}
		l = c;
	}

	switch (s) {
	case 1:
		out[j++] = base64en[(l & 0x3) << 4];
		out[j++] = BASE64_PAD;
		out[j++] = BASE64_PAD;
		break;
	case 2:
		out[j++] = base64en[(l & 0xF) << 2];
		out[j++] = BASE64_PAD;
		break;
	}

	out[j] = 0;

	return warp_from_uint8ptr_to_value(out);
}

// [[cheerp::jsexport]]
// Value base64_decode(Value a,  Value b , int inlen)
// {
// 	unsigned int i;
// 	unsigned int j;
// 	unsigned char c;

// 	uint8 * in   = ccm1::warp_from_value_to_uint8ptr(a);
// 	uint8 * out  = ccm1::warp_from_value_to_uint8ptr(b);

// 	if (inlen & 0x3) {
// 		return 0;
// 	}

// 	for (i = j = 0; i < inlen; i++) {
// 		if (in[i] == BASE64_PAD) {
// 			break;
// 		}
// 		if (in[i] < BASE64DE_FIRST || in[i] > BASE64DE_LAST) {
// 			return 0;
// 		}

// 		c = base64de[in[i]];
// 		if (c == 255) {
// 			return 0;
// 		}

// 		switch (i & 0x3) {
// 		case 0:
// 			out[j] = (c << 2) & 0xFF;
// 			break;
// 		case 1:
// 			out[j++] |= (c >> 4) & 0x3;
// 			out[j] = (c & 0xF) << 4; 
// 			break;
// 		case 2:
// 			out[j++] |= (c >> 2) & 0xF;
// 			out[j] = (c & 0x3) << 6;
// 			break;
// 		case 3:
// 			out[j++] |= c;
// 			break;
// 		}
// 	}

// 	out[j] = 0;

// 	return ccm1::warp_from_uint8ptr_to_value(out);
// }


int main() {
	// ccm1::log(fab(40));
	const char * in = "hello";
	uint8 out[]= {1,2,3,4,5,6,7,8,9,10};
	Value a    = ccm1::string_from_cstr_to_value(in);
	Value b    = ccm1::warp_from_uint8ptr_to_value(out);
	base64_encode(a, b, sizeof(in));
	ccm1::string_log(b);
	return 0;
}