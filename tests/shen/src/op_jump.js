

var hasElse = false;
//var jmp_stack =  [];
function is_else (line) {
	var pre = line - 1;
	
	if(!$ebx[pre].cond) {
		return true;
	}
	
	return false;
}

function insert_nop_eof (idx, _block) {
	//var code = { op: 'EOF', args: [ 1, 9 ] },
	_block.tags_end .push({num : idx,tag : $ecx});
}

function is_else_if(idx) {
	var pre = $ebx[idx-1];
	
	if(!pre.cond) {
		return false;
	}
	
	var next = $ebx[idx+1];
	
	if(!next.cond) {
		return false;
	}
	var next2 = $ebx[idx+2];
	
	if(next2.op != "JMP" ) {
		return false;
	}
	
	return true;
}

function op_jump (code, _block) {
	//console.log(_block.symblos);
	try {
		var e = $ecx + code.args[1] ;
	
		if(is_else($ecx)){
			_block.data.push("else ;; @" + $ecx);
			insert_nop_eof(e, _block);
			//console.log(_block.tags_end );
			
		} else if(is_else_if($ecx)) {
			
		}else {
			console.log($ebx[e], "next");
			_block.data.push("if ;; @"   + $ecx);
			if ($ebx[e].op == "JMP") { ///下一个是JUMP
				if(is_else(e)) { ///是else
					return;
				} 
			}
			insert_nop_eof(e, _block);
		}
		
		
		//console.log("stack", jmp_stack, _block.tags_end);
	}catch(e) {
		console.log(e);
	}
}
