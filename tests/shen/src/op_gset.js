



var global = {};

function op_gset(code, _block) {

  var params_base = code.args[2];
  var len         = code.args[1];
  
  if(code.args[2] == "newindex") {
	  
	  if(look_at_is_func($ecx)) {
		var fun_e = stack.pop();
		var mblocks= find_block_by_idx(fun_e)
		
		if(mblocks != null) {
			mblocks.fname = "\"" + code.args[1] +"\""
		}
	  } else if(look_at_is_var($ecx)) {
		///全局变量
		_block.symblos[code.args[0]].vname= code.args[1];
		$ebx[$ecx].vname= code.args[1];
		$ebx[$ecx].idx  = code.args[0];
		
		global[$ebx[$ecx].vname] = _block.symblos[code.args[0]];
	  } else {
	  }
		
	}
}
