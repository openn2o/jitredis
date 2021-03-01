

/**
*  ret code
*/
function op_mov (code, _block) {
	//// 1 dst 操作数
	//// 0 堆栈数
	var dst = code.args[1];
	var line= find_nearest_stack_ele($ecx, dst);
	if(line) {
		$ebx[$ecx].idx = line.idx;
		//_block.data.push(";;;;;;;error stack0");
	} else {
		//_block.data.push(";;;;;;;error stack1");
		if($ebx[$ecx]) {
			$ebx[$ecx].idx =  code.args[1];
		}
	}
	
	if(!_block.symblos[dst]){
		//_block.data.push(";;;;;;;error stack2");
		_block.symblos[code.args[0]] =  _block.symblos[0];
		get_value_from_symblos( null , _block);
		/*
		var ele = find_mov_ele(code.args[0]);
		
		if(ele['idx'] != null) {
			get_value_from_symblos( _block.symblos[ele['idx']] , _block);
		}*/
	}
	_block.symblos[code.args[0]] = _block.symblos[dst];
}