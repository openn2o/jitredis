
/**
*  
*/
function op_isnev (code, _block) {
	//// 1 dst 操作数
	//// 0 堆栈数
	var dst = _block.symblos[code.args[1]];
	var src = _block.symblos[code.args[0]];
	$ebx[$ecx].cond = 1;
	require_str_cmp();
	
	if (src) {
		get_value_from_symblos(src, _block);
	}
	
	if (dst) {
		get_value_from_symblos(dst, _block);
	}
	switch (dst.type) {
		case "KSTR":
		if("eq" == code.args[2]) {
			_block.data.push(";;str eq");
			_block.data.push("call $str_cmp");
			//_block.data.push("call $print_i");
			//_block.data.push("i32.const 0");
			if("ISEQV" == code.op) {
				_block.data.push("i32.const 0");
			} else {
				_block.data.push("i32.const 1");
			}
			
			_block.data.push("i32.eq");
		}
		break;
	}
	
	console.log("===========",_block.symblos[dst]);
}