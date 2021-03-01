


function op_dev (code, _block) {
	//console.log(_block.symblos);
	
	try {
	var src =  _block.symblos[code.args[1]];
	var dst =  _block.symblos[code.args[2]];
	$ebx[$ecx].idx = code.args[0];
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
	
	if(src) {
		get_value_from_symblos(src, _block);
	}
	
	
	if("DIVVN" == code.op || "DIVNV" == code.op) {
		var src = code.args[2] + "";
		if(src.indexOf(".") == -1) {
			src = src + ".0";
		}
		
		_block.data.push("f64.const " + src + ";;; const");
	} else {	
		if(src) {
			get_value_from_symblos(dst, _block);
		}
	}
	

	
	_block.data.push("f64.div " );
	_block.data.push("f64.store " );
	}catch(e) {
	}
}