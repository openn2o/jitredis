

//  { op: 'TSETB', args: [ 1, 0, 1, 'newindex' ] },

// [1] is base
// [2] is value

function op_tset(code, _block) {

  var base = code.args[1];
  
  var key  = code.args[2]+"";
  
  if(code.args[3] == "newindex") {
    
    var obj = _block.symblos[base];
	
	//console.log(obj , "CCC");
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

    
	///获取数据range
    _block.data.push("get_local 0") ;
    _block.data.push("i32.const 4");
    _block.data.push("i32.add");
    _block.data.push("i32.load");
    _block.data.push("set_local 2");
    ////key的地址
    var pc = inline_build_in_cstr(_block.data, 
      key, _block);
    ////key的长度
	
    var len= (key+"").length 
    
	pc = pc - len;
	if(pc  < 0) {
		pc = 0;
	}
	
	

    ///哈希函数
    ///内容都是指针
    _block.data.push(";;call hash") ;
    _block.data.push("i32.const " + pc + ";; len") ;
    //_block.data.push("get_local 0 ;; ptr") ;
    _block.data.push("i32.const " + len + ";; len") ;
    _block.data.push("get_local 2 ;; range") ;
    _block.data.push("call $hash_str") ;
    _block.data.push("set_local 3") ;
    ///base + offset
    _block.data.push("get_local 3") ;
	_block.data.push("i32.const 4") ;
	_block.data.push("i32.mul") ;
	_block.data.push("get_local 1") ; 
	_block.data.push("i32.add ") ;

     ///制作hash值
	
	//_block.data.push("set_local 4") ;
	//_block.data.push("get_local 3") ;
	//_block.data.push("call $print_i") ;
	//_block.data.push("get_local 4") ;
	
	var val_i =  look_up_table_value_tsetb (_block) - 8 ;
	
	if (val_i < 0) {
		val_i = 0;
	}
	
	//console.log(val_i, "idx");
	_block.data.push("i32.const " + val_i) ;
	
	 //_block.data.push("call $print_i") ;
	
	 _block.data.push("i32.store") ;
     //look_up_table_value
     ///[0] ptr
     ///[1] len
     ///[2] range
	 
  }
}
