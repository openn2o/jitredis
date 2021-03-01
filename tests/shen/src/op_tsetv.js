


function op_tsetv(code, _block) {

  var base = code.args[1];
  if(code.args[3] == "newindex") {
 //    var key_idx   = code.args[2];
	
	// var key_idx2  = find_nearest_stack_ele_table_setv($ecx, key_idx);
	
	// if(!key_idx2) {
	// 	console.log("error:: null ptr 2");
	// 	return;
	// }
	// var len = 0;
	// var pc  = 0;
	
	// var type_ele = _block.symblos[key_idx2.idx];
	// if(key_idx2.idx && type_ele) { //key 的类型
	// 	if("KNUM" == type_ele.type) {
	// 		len = 8;
			
	// 		pc = type_ele.pc;
			
	// 		pc = pc - len;
	// 	}
	// }
	
	
	// if(pc  < 0) {
	// 	pc = 0;
	// }
	

	// ///由于类型是不可知的所以需要动态计算长度
	// ///数值型 8 
	// ///字符串 n*1
	
 //    var obj = _block.symblos[base];
	
	// //console.log(obj , "CCC");
 //    ///mov eax, ptr
 //    ///ptr + 12 -> data addr
 //    ///获取数据地址
 //    _block.data.push("i32.const " + (obj.pc-4>0? obj.pc-4: 0)) ;
 //    _block.data.push("set_local 0") ;
 //    _block.data.push("get_local 0") ;
 //    _block.data.push("i32.const 12");
 //    _block.data.push("i32.add");
    
 //    ///mov ebx , data[ptr]
 //    ///保存数据地址 base
	// _block.data.push("i32.load") ;
 //    _block.data.push("set_local 1") ;

    
	// ///获取数据range
 //    _block.data.push("get_local 0") ;
 //    _block.data.push("i32.const 4");
 //    _block.data.push("i32.add");
 //    _block.data.push("i32.load");
 //    _block.data.push("set_local 2");

    

	

    ///哈希函数
    ///内容都是指针
 //    _block.data.push(";;call hash") ;
 //    _block.data.push("i32.const " + pc + ";; pc") ;
 //    _block.data.push("i32.const " + len + ";; len") ;
 //    _block.data.push("get_local 2 ;; range") ;
 //    _block.data.push("call $hash_str") ;
 //    _block.data.push("set_local 3") ;
 //    ///base + offset
 //    _block.data.push("get_local 3") ;
	// _block.data.push("i32.const 4") ;
	// _block.data.push("i32.mul") ;
	// _block.data.push("get_local 1") ; 
	// _block.data.push("i32.add ") ;

     ///制作hash值
	//_block.data.push("set_local 4") ;
	//_block.data.push("get_local 4") ;
	//_block.data.push("call $print_i") ;
	//_block.data.push("get_local 4") ;
	
	// var val_i =  look_up_table_value_tsetb (_block) - 8;
	
	// if (val_i < 0) {
	// 	val_i = 0;
	// }
	// //{ op: 'TSETV', args: [ 4, 0, 4, 'newindex' ] },
	// //console.log(val_i, "idx");
	// _block.data.push("i32.const "  + val_i);
	// _block.data.push("f64.load ");
	///////获取到value
	
	//
	console.log(compile_num_v2p("KNUM", 1))
	//_block.data.push(build_in_ptr("KNUM", 1));
	
	//
	////idx call test
	// _block.data.push("call $print");
	 //_block.data.push("i32.const " + pc);
	
	////
	// _block.data.push("i32.store");
	// _block.data.push("get_local 0");
	// _block.data.push("i32.store");
     //look_up_table_value
     ///[0] ptr
     ///[1] len
     ///[2] range
	 
  }
}
