
function op_cat (code, _block) {
	try {
		var dst = code.args[0];
		var from= code.args[1];
		var to  = code.args[2];
		var idx = [];
		for(var i = from; i <= to ; i++) {
			console.log("===", $ebx[i]);
			idx.push($ebx[i].idx);
		}
		require_copy_to_string(); //导入std库
		///set eax 0 to save ptr
		_block.data.push("i32.const "+_block.alloc_pc+";; new string"); 
		
		_block.data.push("set_local 0"); /// eax is addr
		_block.data.push("get_local 0"); /// eax is addr
		_block.data.push("set_local 1"); /// eax is addr
			
		var size_t = 0;
		for(var i = 0; i < idx.length ; i++) {
			var ele = _block.symblos[idx[i]];
			size_t += ele.size;
			_block.data.push("get_local 1");
			_block.data.push("i32.const " + ele.pc);
			_block.data.push("i32.const " + ele.size);
			_block.data.push("call $copy_to_string");
			_block.data.push("set_local 1");
		}
		$ebx[$ecx].idx = _block.symblos.length ;
		_block.symblos[$ebx[$ecx].idx] = {pc:_block.alloc_pc,
									   type:"KSTR",
									   size:size_t};

		_block.alloc_pc += size_t;
		_block.data.push("i32.const " + size_t); //-->addr, 1 -> len
		_block.data.push("set_local 1"); 
		
		
	} catch(e) {
		
	}
}