
function op_condi (code, _block) {
	var src =  _block.symblos[code.args[0]];
	var dst =  _block.symblos[code.args[1]];
	$ebx[$ecx].cond = 1;
	if(src) {
		var dd = find_nearest_stack_ele($ecx, code.args[0]);
		if(dd) {
			get_value_from_symblos(_block.symblos[dd.idx], _block);
		} else {
			get_value_from_symblos(src, _block);
		}
	} else {
		console.log(_block.symblos);
	}
	

	
	if("ISNEN" == code.op) {
		_block.data.push("f64.const " + code.args[1] + ".0");
	} else {
		if(dst) {
			var dt = find_nearest_stack_ele($ecx, code.args[1]);
			if(dt) {
				get_value_from_symblos(_block.symblos[dt.idx], _block);
			} else {
				get_value_from_symblos(dst, _block);
			}
		} else {
			console.log(_block.symblos);
		}
	}
	switch(code.op) {
		case  "ISEQN":
		_block.data.push("f64.eq");
		break;
		case  "ISGT":
			if(code.args[2] == "le") {
				_block.data.push("f64.le");
			} else {
				_block.data.push("f64.ge");
			}
		break;
		case  "ISGE":
			if(code.args[2] == "lt") {
				_block.data.push("f64.lt");
			} else {
				_block.data.push("f64.ge");
			}
		break;
		case "ISNEN":
			if(code.args[2] == "eq") {
				_block.data.push("f64.eq");
			} else {
				_block.data.push("f64.ne");
			}
		break;
	}
	
}
