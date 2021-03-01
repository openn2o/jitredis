// [
// type , 类型    4 字节
// len,   长度    4 字节 
// pc	  addr    4字节  
// size   n       4 字节
// ]
//////
function compile_cstring_v2p (string) {
	///创建一个str ptr
	//comile_new_ptr("KSTR", string, string.length);
	
}



///设置完 eax
/***
* 构建一个指针
*/
function comile_new_ptr (type, len) {
	//16
	//pc
	var ctype = 0; // null
	switch (type) {
		case "KNUM":
		case "KSHORT":
			ctype =1;
		break;
		case "KSTR":
			ctype =2;
		break;
		case "KOBJECT":
			ctype =3;
		break;
		case "KARRAY":
			ctype =4;
		break;
	}
	var codes = [];
	codes[0] = `
	;; ptr is alloc 
	get_global 0 ;; ptr
	;;set_local  0 ;; push
	i32.const ${ctype}
	i32.store
	`
	/////尺寸
	var size_t = len ? len : 100;
	// var ele_t  = 0;
	
	switch (type) {
		case "KNUM":
		case "KSHORT":
			size_t = 0;
		break;
		case "KSTR":
			size_t =len;
		break;
		case "KOBJECT":
			size_t =len;
		break;
		case "KARRAY":
			size_t =len;
		break;
	}
	codes[1] = `
	i32.const 4 
	get_global 0
	i32.add ;;  obj size 
	i32.const ${size_t}
	i32.store
	`
	//写入元素个数
	codes[2] = `
	i32.const 8 
	get_global 0
	i32.add ;;  obj eles 
	i32.const 0
	i32.store
	`
	//写入内存地址
	//global or block
	//默认为null 没有初始化
	codes[3] = `
	i32.const 12
	get_global 0
	i32.add ;;  value addr 
	i32.const 0
	i32.store
	`
	
	codes [4] = `
	i32.const 16
	get_global 0
	set_global 0 ;; incr pc
	`
	
	return codes.join("\n")
}