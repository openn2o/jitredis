

function op_call(code, _block) {

  var params_base = code.args[2];
  var len         = code.args[1];
  
  console.log($ebx);
  var is_tget = ($ebx[$ecx-1].op== "TGETB");
  
  if(is_tget) {
		look_at_reg_for_table(_block);
  } else {
		if(code.op == "CALLM") {
			look_at_make_callm_params(params_base, _block);
		} else {
			look_at_make_callm_params(params_base, _block);
		}
  }

  
  //look_at_make_callm_params2(code, _block);
  var fname = look_at_function_name(code.args[0], _block);
  
  if(!fname) {
	   _block.data.push("stack error ");
  }
  
  if(fname.charAt(0) != "$") {
	fname = "$"+fname;
  }
  
  //console.log(fname);
  _block.data.push("call " + fname);
}
