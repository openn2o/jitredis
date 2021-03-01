
/***
*
*/
var vm_func = {
	"print":1,
	"print_t":1,
	"print_s":1,
	"array":1
}

function op_gget (code, _block) {
  ////
  	if(code.args[2] == "index") { 
		var name = code.args[1];
		var ele = get_gloabl_var_by_name(name, _block);
		
		if(ele != null) {
			$ebx[$ecx].vname = ele.vname;
			//console.log(";;;;1", ele, name);
			//get_value_from_symblos(ele ,_block);
		}else if(look_at_hasCall()) { /// isFunction
			////搜索内部函数
		
			var idx  = find_block_index_by_name(name);
			//console.log("idx=", name);
			if( idx != -1 ){
				$ebx[$ecx].fname = "$m" + idx;
			} else {
				////搜索vm级别函数
				
				if(vm_func[name]) {
					$ebx[$ecx].fname = "$" + name;
				} else {
					$ebx[$ecx].fname = "$m" + _block.index;
				}
			}
		}
	}
}
