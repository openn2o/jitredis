
function op_mul (code, _block) {
		//console.log(_block.symblos);
	var src  =  _block.symblos[code.args[2]];
	var dst  =  _block.symblos[code.args[1]];
	$ebx[$ecx].idx = code.args[0]; 
	try {
		
	if(!_block.symblos[code.args[0]]) {
		var pc = inline_build_in_number(_block.data, code.args[0], _block);
	    _block.symblos[code.args[0]]  = {pc:pc, type:"KNUM"};
		pc = pc -8;
		debug(_block, "op_mul::1");
	} else {
		var pc = _block.symblos[code.args[0]].pc - 8; 
		
		if  (!pc) {
			pc  = 0;
		}
		
		if(pc < 0) {
		 pc = 0;
		}
		debug(_block, "op_mul::2");
	}
	_block.data.push("i32.const " + pc  + ";;; op_mul :: save index");
	
	if("MULVN" == code.op || "MULNV" == code.op ) {
		var src = code.args[2] + "";
		if(src.indexOf(".") == -1) {
			src = src + ".0";
		}
		 
		_block.data.push("f64.const " + src + ";;; const");
	} else {
		if(src) {
			get_value_from_symblos(src, _block);
		}
	}
	
	if(dst) {
		get_value_from_symblos(dst, _block);
	}
	_block.data.push("f64.mul " );
	_block.data.push("f64.store ;;;end mul" );
	//_block.symblos[code.args[0]] = {}
	}catch (e) {
	}
}


