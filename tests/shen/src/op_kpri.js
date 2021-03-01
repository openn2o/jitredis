


function op_kpri (code, _block) {
	console.log(_block.symblos);
	try {
		var zero = 0;
		if(code.args[1]) {
			zero = code.args[1];
			
			if(zero == true) {
				zero = 1;
			}
		}
		
		var pc = inline_build_in_number(_block.data, 
										 zero,
										_block);
		_block.symblos.push({pc:pc, type:"KNUM"});
	}catch(e) {
		
	}
}