


function op_mod (code, _block) {
	console.log(_block.symblos);
	try {
	var src =  _block.symblos[code.args[2]];
	var dst =  _block.symblos[code.args[1]];
	$ebx[$ecx].idx = code.args[0];
///eax
	if(!_block.symblos[code.args[0]]) {
		var pc = inline_build_in_number(_block.data, 0 , _block);
	    _block.symblos[code.args[0]]  = {pc:pc, type:"KNUM"};
		pc = pc - 8;
	} else {
		var pc = _block.symblos[code.args[0]].pc - 8; 
		if  (!pc) {
			pc  = 0;
		}
		
		if(pc < 0) {
			pc = 0;
		}
	}
	
	_block.data.push("i32.const " + pc + ";;;idx");
	
	if("MODVN" == code.op || "MODNV" == code.op) {
		var src = code.args[2] + "";
		if(src.indexOf(".") != -1) {
			src = src + ".0";
		}
		
		_block.data.push("f64.const " + src + ";;; const");
		_block.data.push("i32.trunc_s/f64");
		if("MODNV" == code.op) {
			_block.data.push("set_local 2");
		} else {
			_block.data.push("set_local 1");
		}
		
	} 
	else {	
		if(src) {
			get_value_from_symblos(src, _block);
			_block.data.push("i32.trunc_s/f64");
			_block.data.push("set_local 1");
		}
	}
	
	if(dst) {
		get_value_from_symblos(dst, _block);
		_block.data.push("i32.trunc_s/f64");
		
		if("MODNV" == code.op) {
			_block.data.push("set_local 1");
		} else {
			_block.data.push("set_local 2");
		}
	}
	_block.data.push("get_local 2");
	_block.data.push("get_local 1");
	
	_block.data.push("i32.rem_u " );
	_block.data.push("f64.convert_u/i32");
	_block.data.push("f64.store " );
	}catch(e) {
	}
}