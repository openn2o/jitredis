


function op_sub (code, _block) {
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
	if(dst) {
		if("SUBNV" == code.op) {
			var src = code.args[2] + "";
			if(src.indexOf(".") == -1) {
				src = src + ".0";
			}
			
			_block.data.push("i32.const " + src + ";;; const");
		}else {
			get_value_from_symblos(dst, _block);
		}
		
	}
	 
	if("SUBVN" == code.op) {
		var src = code.args[2] + "";
		if(src.indexOf(".") == -1) {
			src = src + ".0";
		}
		_block.data.push("f64.const " + src + ";;; const");
	} else {	
		if(src) {
			if("SUBNV" == code.op) {
				get_value_from_symblos(dst, _block);
			}else {
				get_value_from_symblos(src, _block);
			}
		}
	}
	_block.data.push("f64.sub " );
	_block.data.push("f64.store " );
	}catch(e) {
		
		console.log(e);
	}
}
