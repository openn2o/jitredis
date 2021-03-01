function set_value_from_symblos(node, _block) {
	if(node.pc - 8 < 0) {
		node.pc = 8;
	}
	_block.data.push("i32.const "+ (node.pc - 8));
	_block.data.push("f64.load ");
}

function get_value_from_static_section (svip) {
	var static_section_ele = const_section.symblos[svip];
	
	if(static_section_ele) {
		return static_section_ele[0];
	}
	
	return 0;
}


var $eax = 0;
var $ebx = 0;
var $ecx = 0;
var $edx = 0;

function look_up_table_key_tgetb (base, key) {
	var len = $ebx.length;
	for(var i = 0; i< len; i++) {
		if($ebx[i].args[1] == base) {
			if($ebx[i].args[2] == key) {
				return $ebx[i].idx;
			}
		}
	}
	///如果是setV进来的是不在符号表里的。
	
	return -1;
}

///all  pointers
function look_up_table_value_tsetb(_block) {
	var line = $ebx[$ecx-1];
	if(line) {
		if(line.idx) {
			var ele = _block.symblos[line.idx];
			if(ele) {
				return ele.pc ;
			}
		}
	}
	
	var line = $ebx[$ecx].args[2]
	
	if( _block.symblos[line] ) {
		return  _block.symblos[line].pc ;
	}
	
	console.log("not find tsetv ele");
	return 0;
	
}

function make_params_by_pointer(arr) {
	//console.log(arr);
	var global_stack  = [];
	var global_index  =  0;
	var global_string = 0;
	while((global_string = arr[global_index]) != null){
		//console.log(global_string, "call stack");
		if(global_string >= 0) { ////非引用
			global_stack[global_index++] = global_string;
		} else {
			global_stack[global_index++] = const_section.get(0-global_string);
		}
	}
	return global_stack;
}

function get_gloabl_var_by_name(name, _block) {
	//console.log(_block.symblos);
	/*var len = _block.symblos.length;
	var eax = _block.symblos;
	for(var i = 0; i< len; i++ ) {
		var ele = eax[i];
		
		if(ele.vname && ele.vname == name ) {
			return i;
		}
	}
	return -1;*/
	
	if (global[name]) {
		return global[name]
	}
	return null;
}

/////tag for end
function index_tag(ecx, _block) {
	var temp = peekTags(ecx, _block);
	var len  = temp.length ;
	if( len > 0) {
		for(var i = 0; i< len; i++) {
			addTagsEnd(_block, temp[i]);
		}
	}
}

/////选择tag
function peekTags (ecx, _block) {
  var t   = [];
  var eax = _block.tags_end;
  var len = eax.length;
  for(var i = 0; i< len ; i++) {
	 
	if(eax[i].num == ecx){
		t.push(eax[i]);
	}
  }
  return t;
}

////tag 结束
function addTagsEnd  (_block , item) {
	_block.data.push("end" + " ;;@" + item.tag);
}
//////
///TODO
function look_loop_tag (start, end) {
	for(var i = start ; i< end; i++ ){
		console.log(i, $ebx[i]);
	}
}

///向前看函数名
function look_at_function_name(dst , _block) {
	var len = $ecx;
	while (len -- >= 0) {
		var line = $ebx[len];
		if(line) {
			if (line.op == "GGET" &&
				line.args[0] == dst) {
				if(line.fname) {
					return line.fname 
				}
				return line.args[1];
			}
		}
	}
	return "$m" + _block.index;
}

function get_value_from_symblos(node, _block, oneR) {
	if(!node) {
		var pc = inline_build_in_number(_block.data, 0 ,_block);
		$ebx[$ecx].idx = _block.symblos.length;
		_block.symblos.push({pc:pc, type:"KNUM"});
		return pc;
	}
	if(node.pc - 8 < 0) {
		node.pc = 8;
	}
	switch (node.type) {
		case "KSTR":
			debug(_block, "str addr::");
			if(!oneR) {
				_block.data.push("i32.const "+ (node.pc));
				_block.data.push("i32.const "+ (node.size));
			} else {
				_block.data.push("f64.const 1.0");
			}
		break;
		default : ///Numberic
		
		//debug(_block, "numric addr::");
		_block.data.push("i32.const "+ (node.pc - 8));
		_block.data.push("f64.load ");
		break;
	}
	return node.pc;

}


function look_at_is_func(i) {
	return ($ebx[i - 1].op == "FNEW") ;
}

function look_at_is_var (i) {
	return ($ebx[i - 1].op.indexOf("K") != -1) ;
}

function look_at_make_callm_params2(code, _block) {
	var curr = $ecx - 1;
	
	var far  = code.args[0];
	var $base = $ebx[curr - far];
	
	console.log("base === " , $base);
	if($base.op == "GGET"){///全局
		if ($base.vname) {
			var ele = get_gloabl_var_by_name($base.vname, _block);
			get_value_from_symblos(ele ,_block);
		} else {
			_block.data.push("get_local 0 ;; base");
			_block.data.push("get_local 1 ;; size");
			//_block.data.push("f64.const 0.0 ;; null"); // null
		} 
		
	} else {
		///stack
		if($base.idx >= 0) {
			var dst = _block.symblos[$base.idx];
			if(dst) {
				get_value_from_symblos(dst, _block);
			} else {
				console.log("errr:::::");
			}
		}else {
			console.log("errr:::::");
		}
	}
}

function look_at_reg_for_table(_block) {
	_block.data.push("get_local 8");
	_block.data.push("i32.const 1");
	_block.data.push("i32.add");
	_block.data.push("call $print_i");
	
	_block.data.push("get_local 8");
	_block.data.push("f64.load");
}

function look_at_make_callm_params (n, _block) {
	var len  = n-1;
	//var len  = n;
	var temp = [];
	var start = $ecx - len;
	
	for(var i =start; i< $ecx; i++) {
		//console.log("push " + $ebx[i].idx);
		if(!$ebx[i]) {
			continue;
		}
		if($ebx[i].idx >= 0) {
			///dst 
			var dst = _block.symblos[$ebx[i].idx];
			//console.log("dst==11", dst, $ebx[i].idx);
			if(dst) {
				get_value_from_symblos(dst, _block);
			} else {
				console.log("errr:::::");
			}
		} else {
			//console.log("cc=" , $ebx[i]);
			if($ebx[i].op == "GGET"){///全局
				if ($ebx[i].vname) {
					var ele = get_gloabl_var_by_name($ebx[i].vname, _block);
					get_value_from_symblos(ele ,_block);
				} else {
					_block.data.push("get_local 0 ;; base");
					_block.data.push("get_local 1 ;; size");
					//_block.data.push("f64.const 0.0 ;; null"); // null
				}
			} else {
				
				if("TGETS" == $ebx[i].op) {
					look_at_reg_for_table(_block);
				} else {
					//_block.data.push(";;;caught the null"); // null
					_block.data.push("get_local 0 ;; base");
					_block.data.push("get_local 1 ;; size");
				}
				
			}
			
		}
	}
}

function look_at_make_call_params (n,  _block) {
	//var len  = n-1;
	var len  = n;
	var temp = [];
	var start = $ecx - len;
	
	for(var i =start; i< $ecx; i++) {
		//console.log("push " + $ebx[i].idx);
		if(!$ebx[i]) {
			continue;
		}
		
		if($ebx[i].idx >= 0) {
			///dst 
			var dst = _block.symblos[$ebx[i].idx];
			if(dst) {
				get_value_from_symblos(dst, _block);
			}
		} else {
			_block.data.push("f64.const " + $ebx[i].idx + ".0");
		}
	}
	console.log($ebx);
}

function find_mov_ele(n) {
	return $ebx[dist];
}

function find_fori_ele(n, dist) {
	var base = 0;
	var temp = [];
	for(var i = n ; i>= 0; i-- ) {
		if(!($ebx[i].op.charAt(0) == "K")) {
			continue;
		}
		
		if($ebx[i].args[0] == dist) {
			base = i;
		}
	}
	
	temp = [$ebx[base], $ebx[base + 1], $ebx[base+2]];
	return temp;
}

///查找最近的堆栈元素
function find_nearest_stack_ele_table_setv (n, dist) {
	for(var i = n - 1; i>= 0; i-- ) {
		//console.log($ebx[i])
		if(!$ebx[i].idx) {
			continue;
		}
		if($ebx[i].idx == dist) {
			return $ebx[i];
		}
	}
	return null;
}

///查找最近的堆栈元素
function find_nearest_stack_ele(n, dist) {
	for(var i = n ; i>= 0; i-- ) {
		if(!$ebx[i].idx) {
			continue;
		}
		if($ebx[i].args[0] == dist) {
			return $ebx[i];
		}
	}
	return null;
}

///向后看是否有call 指令
function look_at_hasCall () {
	var max = 10;
	for(var i = $ecx; i< max ; i++) {
		if($ebx[i].op.indexOf("CALL") != -1) {
			return true;
		}
	}
	return false;
}