/***
* 常量节区
* 该节区数据不可更改，不会释放
*/

var const_section = {}
const_section.const_ip = 0;
const_section.bytes = new Uint8Array(0);//64M
const_section.symblos= [0];

const_section.print = function () {
	console.log(const_section.bytes.subarray(0,100));
	console.log(const_section.symblos);
}

const_section.set = function (bytes, info) {
	info.sip = const_section.symblos.length;
	const_section.symblos.push([const_section.const_ip, bytes.length]);
	const_section.bytes.set(bytes, const_section.const_ip);
	const_section.const_ip += bytes.length;
	const_section.print();
}

const_section.jit = [];

const_section.init = function () {
	var len = const_section.symblos.length;
	const_section.jit = new  Array(len);
	
	for(var i=1;i < len; i++){
		var p = const_section.symblos[i];
		var b = const_section.bytes.subarray(
			p[0],
			p[0] + p[1]
		);
		
		const_section.jit[i] = decoder.decode(b);
	}
	
	console.log(const_section.jit);
}

const_section.get = function (sip) {
	return const_section.jit[sip];
}





