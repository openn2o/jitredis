var stack  = [];
var blocks = [];
var funcIndex_G = 0;
var alloc_pc = 0;


function find_block_index_by_name  (name) {
	console.log(name, ">>>");
	var len = blocks.length;
	var search = "\"" + name + "\"";
	for(var i = 0; i< len; i++) {
		console.log(blocks[i].fname);
		if(blocks[i].fname == search) {
			return i;
		}
	}
	return -1;
}


function find_block_by_idx (idx) {
	var len = blocks.length;
	for(var i = 0; i< len; i++) {
		if(blocks[i].index == idx) {
			return blocks[i];
		}
	}
	
	return null;
}

var gloabl_module = {
	static_pc:8092
}
//var encoder = new TextEncoder('utf8');
//var decoder = new TextDecoder();
var static_data = [];

///静态字符串
function inline_build_in_cstr(arr, n, _block) {
  n = n + "";
  var len = n.length;
  var buff = [n];
  $ebx[$ecx].idx = _block.symblos.length;
  var str = '(data (i32.const '+ gloabl_module.static_pc + ') "'+buff.join("")+'")';
  _block.symblos.push({ pc: gloabl_module.static_pc, type: 'KSTR' , size:len});
  static_data.push(str);
  arr.push(";; i32.const " +  gloabl_module.static_pc + ";; char * " + n);
  return  gloabl_module.static_pc  += len;
}

//  复合类型
//  [type, size, len, ptr]
//  i32 i32 i32 i32 
//  指针放入栈，数据方式堆
var HEAP_SIZE_BLOCK=100;
function inline_build_in_object(arr, _block) {
  ///申请一块数据存放该指针指向的数据
  $ebx[$ecx].idx = _block.symblos.length;
  
  //写入类型
  arr.push("i32.const " +  _block.alloc_pc);
  arr.push("i32.const 1 ;; type object");
  arr.push("i32.store");
  
  //写入尺寸 默认分配100*4 = 400B
  arr.push("i32.const " +  (_block.alloc_pc + 4));
  arr.push("i32.const " +   HEAP_SIZE_BLOCK);
  arr.push("i32.store");
  
  //写入元素个数 
  arr.push("i32.const " +  (_block.alloc_pc + 8));
  arr.push("i32.const 0 ;; ele length");
  arr.push("i32.store");
  
  //写入数据的地址
  arr.push("i32.const " +  (_block.alloc_pc + 12));
  //动态分配内存块
  var msize = 4 /*i32*/ * HEAP_SIZE_BLOCK ;//size of alloc
  
  arr.push("i32.const "+gloabl_module.static_pc+";;  ele ptr");
  arr.push("i32.store");
  gloabl_module.static_pc += msize;
  _block.symblos.push({ pc: _block.alloc_pc , type: 'KOBJECT' });
  return  _block.alloc_pc += 16;
}
/***
*返回增长的内存索引
*/
function inline_build_in_number(arr, n, _block) {
  arr.push("i32.const " + _block.alloc_pc);
  if((n+"").indexOf(".") == -1) {
	 n = n + ".0";
  }
  arr.push("f64.const " + n);
  arr.push("f64.store");
  return _block.alloc_pc+=8;
}

function pre_gen_function (codes) {
	////快速预处理不可预测分支的内容
	var len = codes.length;
	for(var i = 0; i< len; i++){
		var block = codes[i];
		
		if(block.bcins) {
			var eax = block.bcins;
			var ebx = eax.length;
			
			for(var k = 0; k < ebx; k ++) {
				//console.log(eax[k]);
				if(eax[k].op == "FNEW"){
					console.log("fnew");
					var precodes = eax[k].args[1].bcins;
					gen_block_code(precodes, -1, false, 2);
				}
			}
		}
	}
	console.log(global);
	//gen_block_code(codes, -1, false, 2);
}
function gen_block_code (codes, cindex, main , numparams) {
		 
		  
			var _block = new Block();
		  _block.numparams = [];
		  _block.index = cindex ;
		  _block.symblos   = [];
		  _block.data.push(";;param");
			
		  for(var i = 0; i< numparams; i++) {
			_block.numparams[i] = 1;///参数索引
			_block.data.push("i32.const " + _block.alloc_pc);
			_block.data.push("get_local "+ i);
			_block.data.push("f64.store");
			_block.alloc_pc+=8
			_block.symblos.push({pc:_block.alloc_pc, type:"KNUM"});		
		  }
		 
		  funcIndex_G  = 0;
		  var index = 0;
		  $ebx  = codes;
		  var len  = codes.length;
		  for(var i = 0; i< len; i++) {
			var code = codes[i];
			$ecx = i;
			
			_block.data.push(";; " + code.op);
			
			switch (code.op){
				case "TSETV":
				op_tsetv(code, _block);
				break;
				case "TGETB":
				case "TGETS":
					op_tget(code, _block)
					break;
				case "TSETB":
				case "TSETS":
					op_tset(code, _block)
				break;
				case "IST":
				case "ISF":
					op_istf( code, _block);
				break;
				case "ISNEV":
				case "ISEQV":
					op_isnev(code, _block);
				break;
				case "FORI":
				case "FORL":
					op_fori(code, _block);
				break;
				case "ADDVN" :
				case "ADDVV" :
				case "ADDNV" :
					op_add(code, _block);
				break;
				case "MULVV":
				case "MULVN":
				case "MULNV":
					op_mul(code, _block);
				break;
				case "SUBVV"://sub
				case "SUBVN":
				case "SUBNV":
					op_sub(code, _block);
				break;
				case "DIVVV":
				case "DIVVN":
				case "DIVNV":
					op_dev(code, _block);
				break;
				case "JMP":
					op_jump(code, _block);
				break;
				case "ISGE":
				case "ISEQN":
				case "ISNEN":
				case "ISGT":
					op_condi(code, _block);
				break;
				case "TNEW":
					require_hash();
					var pc = inline_build_in_object(_block.data , _block);
				break;
				case "KSHORT":
					var pc = inline_build_in_number(_block.data, 
					code.args[1],
					_block);
					codes[i].idx = _block.symblos.length;
					_block.symblos.push({pc:pc, type:"KSHORT"});
				break;
				case "KNUM":
					var pc = inline_build_in_number(_block.data, 
					code.args[1], _block);
					codes[i].idx = _block.symblos.length;
					_block.symblos.push({pc:pc, type:"KNUM"});
				break;
				case "KSTR":
					var pc = inline_build_in_cstr(_block.data, 
					code.args[1], _block);
					//codes[i].idx = _block.symblos.length * -1;
				break;
				case "RET1":
				case "RET":
				case "RET0":
					op_ret(code, _block);
				break;
				case "MODVV":
				case "MODNV":
				case "MODVN":
					op_mod(code, _block);
				break;
				case "KPRI":
					op_kpri(code, _block);
				break;
				case "MOV":
					op_mov (code, _block);
				break;
				case "FNEW":
					var inline = code.args[1];
					var id     = code.args[1].index;
					stack.push(id);
					
				
					//console.log(id, blocks);
					//console.log("inline=:>" , inline);
				break;
				case "GSET":
					op_gset(code, _block);
				break;
				case "GGET":
					op_gget(code, _block);
				break;
				case "CALL":
				case "CALLT":
				case "CALLM":
					op_call(code, _block);
				break;
				case "CAT":
					op_cat(code, _block);
				break;
				default:
					_block.data.push(";;; not implements " + code.op);
				break;
			}
			index_tag(i, _block); ///tag
			
		  }
		  
		  var f = template.compile( func_tml );
		  _block.func = f;
		  if(main) {
			  _block.fname = "\"main\"";
		  }
		  _block.data = _block.data.join("\n");
		  _block.regnum = "(local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)";
		
		  console.log(codes);
		  console.log(_block.symblos);
		  blocks[_block.index] = _block;
	  }
	 
	  function compile (v) {
		var len = v.length;
		pre_gen_function(v);
		
		for(var i = 0; i< len; i++){
			var block = v[i];
//				console.log(block);
			if(block.bcins) {
				///生成函数
				if(block.flags == 3 || len ==1) {
					gen_block_code(block.bcins, block.index, true, block.numparams);
				} else {
					gen_block_code(block.bcins, block.index, false,block.numparams );
				}
			}
		}
		
		var output=  [];
		for(var i = 0; i< blocks.length; i++){
			var block = blocks[i];
			output.push(block.func (block));
		}
		
		//data
		output.unshift(static_data.join("\n"));
		//调试内存
		output.unshift(inlines_std_mem.join("\n"));
		
		output.unshift('(memory (export "mem") 10)')
		//output.unshift('(global i32 (i32.const 1) ;; eax')
			
		output.unshift('(global (mut i32) (i32.const 0)) ;; eax')
		output.unshift('(global (mut i32) (i32.const 0)) ;; ebx')
		output.unshift('(global (mut i32) (i32.const 0)) ;; ecx')
		output.unshift('(global (mut i32) (i32.const 0)) ;; edx')
		output.unshift('(global (mut i32) (i32.const 0)) ;; pc')
		//output.unshift('(global (mut i32) (i32.const 0)) ;; edx')
		
		output.unshift('(import "console" "log"  (func $print (param f64)))')
		output.unshift('(import "console" "log"  (func $print_i  (param i32)))')
		output.unshift('(import "console" "log2" (func $print_s (param i32)(param i32) ))')
		
		var code = (output.join("\n"))
		
		if(code.indexOf("not implements") != -1) {
			console.log(code);
			console.log("error::failed to compile. ");
			return "(module)"
		}
		
		return code;
		
	  }