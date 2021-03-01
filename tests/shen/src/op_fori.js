

function op_fori(code, _block) {

  //var params_base = code.args[2];
  //var len         = code.args[1];
 
  if (code.op == "FORL"){
	///base 
	var eles = find_fori_ele($ecx, code.args[0]);

	if(eles.length == 3) {
		var step  = _block.symblos[eles[2].args[0]];
		var end   = _block.symblos[eles[1].args[0]];
		var start = _block.symblos[eles[0].args[0]];
		
		
			/// i != n
		var pc1 = get_value_from_symblos(start, _block);
		var pc3 = get_value_from_symblos(end , _block);
		_block.data.push("f64.ne");
		_block.data.push("set_local 7");
		
		var idx = _block.symblos[eles[0].args[0]].pc - 8;
		if (idx < 0) {
			idx = 0;
		}
		//i ++
		_block.data.push("i32.const " + idx);
		var pc1 = get_value_from_symblos(start, _block);
		var pc2 = get_value_from_symblos(step , _block);
		_block.data.push("f64.add");
		_block.data.push("f64.store");
		
		
		
	
		_block.data.push("get_local 7");
		_block.data.push("if");
		_block.data.push("br $loop" + $ebx[$ecx].loop);
		_block.data.push("end");
	}

	
	_block.data.push("end ;;end fori");
  } else {
	///i = 0;
	var pc = inline_build_in_number(_block.data, 0 ,_block);
	$ebx[$ecx].idx = _block.symblos.length;
	_block.symblos.push({pc:pc, type:"KNUM"});
    
	
	//======================loop===================
	$ebx[$ecx+ code.args[1]].loop = code.args[1];
	
	_block.data.push("loop $loop" + code.args[1]);
	////mov start to i
	
	_block.data.push("i32.const " + ((pc - 8) < 0? 0:pc-8));
	var eles = find_fori_ele($ecx, code.args[0]);
	if(eles && eles.length > 0) {
		var start = _block.symblos[eles[0].args[0]];
		var pc1 = get_value_from_symblos(start, _block);
	}
	_block.data.push("f64.store");
	
	///mov start to i;
  }
}
