
// { op: 'TGETB', args: [ 2, 0, 1, 'index' ] },

function op_tget(code, _block) {

  var base = code.args[1];
  var key  = code.args[2]+"";
 
  if(code.op) {
    var obj = _block.symblos[base];
	//console.log(obj, "DDD");
    ///mov eax, ptr
    ///ptr + 12 -> data addr
    ///获取数据地址
    _block.data.push("i32.const " + (obj.pc-4>0? obj.pc-4: 0)) ;
    _block.data.push("set_local 0") ;
    _block.data.push("get_local 0") ;
    _block.data.push("i32.const 12");
    _block.data.push("i32.add");
   
    ///mov ebx , data[ptr]
    ///保存数据地址 base
	_block.data.push("i32.load") ;
    _block.data.push("set_local 1") ;
	
	////
	
    ///获取数据range
    _block.data.push("get_local 0") ;
    _block.data.push("i32.const 4");
    _block.data.push("i32.add");
    _block.data.push("i32.load");
    _block.data.push("set_local 2");
    ////key的地址
	var idx = look_up_table_key_tgetb(base,key);
	var pc = 0;
	var len= 0;
	if(!idx) {
		///进入8字节模式
		///进入动态字符模式 [TODO]
		pc = inline_build_in_number(_block.data, 
					code.args[2],
					_block);
		_block.symblos.push({pc:pc, type:"KNUM"});
		len= 8;
		/*pc = inline_build_in_cstr(_block.data, key, _block);
		 
		////key的长度

		len= (key+"").length 
		*/
		pc = pc - len;
		if(pc  < 0) {
			pc = 0;
		}
	
	} else {
		if(!_block.symblos[idx]) {
			console.log("null ptr3" , idx);
			return;
		}
		pc  = _block.symblos[idx].pc;
		////key的长度
		len= (key+"").length 
	}
	
    ///哈希函数
    ///内容都是指针
    _block.data.push(";;call hash") ;
    _block.data.push("i32.const " + pc  + ";; pc") ;
    _block.data.push("i32.const " + len + ";; len") ;
    _block.data.push("get_local 2;; range") ;
    _block.data.push("call $hash_str") ;
    
	//_block.data.push("set_local 3") ;
	//_block.data.push("get_local 3") ;
	//_block.data.push("call $print_i") ;
	//_block.data.push("get_local 3") ;
	////base + offset
  
	_block.data.push("i32.const 4");
	_block.data.push("i32.mul");
	_block.data.push("get_local 1"); 
	_block.data.push("i32.add ");
	///add result
	_block.data.push("set_local 9") ;
	_block.data.push("get_local 9") ;
	_block.data.push("call $print_i") ;
	_block.data.push("get_local 9") ;
	
	_block.data.push("i32.load ");
	
	_block.data.push("set_local 8") ;
	_block.data.push("get_local 8") ;
	_block.data.push("call $print_i") ;
  }
}
