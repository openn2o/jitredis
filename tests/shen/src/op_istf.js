
function op_istf (code, _block) {
	$ebx[$ecx].cond = 1;
	
	var src = _block.symblos[code.args[0]];
	
	if (src) {
		get_value_from_symblos(src, _block, true);
	}
	
	if(code.op == "IST"){
		_block.data.push("f64.const 0.0");
	} else {
		_block.data.push("f64.const 1.0");
	}
	
	_block.data.push("f64.eq");
}
