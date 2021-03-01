


function op_add (code, _block) {
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
	
	if("ADDVN" == code.op || "ADDNV" == code.op) {
		var src = code.args[2] + "";
		if(src.indexOf(".") == -1) {
			src = src + ".0";
		}
		_block.data.push("f64.const " + src + ";;; const");
	} 
	else {	
		if(src) {
			get_value_from_symblos(src, _block);
		} else {
			_block.data.push(";; run this 1");
			console.log(_block.symblos);
		}
	}
	
	if(dst) {
		get_value_from_symblos(dst, _block);
		
	} else {
		_block.data.push(";; run this 2");
		console.log(_block.symblos);
	}
	
	_block.data.push("f64.add " );
	_block.data.push("f64.store " );
	}catch(e) {
	}
}