

/**
*  ret code
*/
function op_ret (code, _block) {
	//console.log("ebx=", $ebx);
	if(code.op == "RET0") {
		_block.data.push("f64.const 0.0");
		_block.data.push("return");
		return;
	}
	
	if(code.op == "RET1") {
		var rbase = find_nearest_stack_ele($ecx - 1,
										   code.args[0]);
		if(rbase) {
			var ret = _block.symblos[rbase.idx];
			if(ret) {
				get_value_from_symblos(ret, _block);
			} 
		} else {
			var ret = _block.symblos[code.args[0]];
			if(ret) {
				get_value_from_symblos(ret, _block);
			} 
		}
	}
	_block.data.push("return");
}