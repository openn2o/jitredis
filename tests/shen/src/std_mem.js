
/////
// std
////


var inlines_std_mem = [];

// 拷贝内存到另外一个目标
// dist  pc
// cpy   pc
// n     num
var inlines_onces = {
}
function require_copy_to_string () {
	if(inlines_onces["require_copy_to_string"]) {
		return;
	}
	var str = `
(func $copy_to_string (param i32 i32 i32)(result i32)
	(local i32 i32 i32 i32) 
	
	get_local 0 ;; n
	get_local 2 ;; ebx
	i32.add     ;; len = dist + n 
	set_local 2 ;; len = [2]
	
	loop $cont
		;;a[i] = b [j]
		get_local 0 ;; a[i]
		get_local 1 ;; n[j]
		i32.load8_u
		i32.store
		
		;; i++ 
		get_local 0
		i32.const 1
		i32.add 
		set_local 0
		
		;; j++ 
		get_local 1
		i32.const 1
		i32.add 
		set_local 1
		
		;; loop
		get_local 0 ;; i
		get_local 2 ;; len
		i32.le_u    ;; i <= len
		if 
			br $cont
		end
	end
	get_local 2
)
	`
	inlines_std_mem.push(str);
	inlines_onces["require_copy_to_string"] = true;
}


// 比较string是否相等
// src pc
// len n
// dst pc
// len n

// 首元素是否一致
// 尾元素是否一致
// 长度是否一致
// 遍历到最后

function require_str_cmp () {
	if(inlines_onces["require_str_cmp"]) {
		return;
	}
	var str = `
(func $str_cmp (param i32 i32 i32 i32)(result i32)
	(local i32 i32 i32 i32) 
	
	
	;;;frist ele eq
	
	get_local 0
	i32.load8_u
	get_local 2
	i32.load8_u
	i32.ne
	if 
		i32.const 0
		return
	end
	
	;;;len is eq
	get_local 1
	get_local 3
	i32.ne
	if 
		i32.const 0
		return
	end
	
	;;loop eq
	get_local 0 ;; n
	get_local 1 ;; ebx
	i32.add     ;; len = dist + n 
	set_local 3 ;; len = [3]
	
	loop $cont
		;;a[i] != b [j]
		get_local 0 ;; a[i]
		i32.load8_u
		get_local 2 ;; n[j]
		i32.load8_u
		i32.ne
		if 
			i32.const 0
			return 
		end
		
		;; i++ 
		get_local 0
		i32.const 1
		i32.add 
		set_local 0
		
		;; j++ 
		get_local 2
		i32.const 1
		i32.add 
		set_local 2
		
		
		;; loop
		get_local 0 ;; i
		get_local 3 ;; len
		i32.lt_u    ;; i <= len
		if 
			br $cont
		end
	end
	
	
	;; eq 
	i32.const 1
	return 
)
	`
	inlines_std_mem.push(str);
	inlines_onces["require_str_cmp"] = true;
}

///哈希函数
///[0] ptr
///[1] len
///[2] range
function require_hash () {
	if(inlines_onces["require_hash"]) {
		return;
	}
	var str = `
(func $hash_str (param i32 i32 i32)(result i32)
(local i32 i32 i32 i32 i32)
get_local 1
i32.const 3
i32.gt_s
if
get_local 1
i32.const -1
i32.xor
tee_local 5
i32.const -8
get_local 5
i32.const -8
i32.gt_s
select
get_local 1
i32.add
i32.const 4
i32.add
i32.const -4
i32.and
tee_local 6
get_local 0
get_local 1
tee_local 4
set_local 5
set_local 3
  loop
get_local 3
i32.load8_s offset=1
i32.const 8
i32.shl
get_local 3
i32.load8_s
i32.or
get_local 3
i32.load8_s offset=2
i32.const 16
i32.shl
i32.or
get_local 3
i32.load8_u offset=3
i32.const 24
i32.shl
i32.or
i32.const 1540483477
i32.mul
tee_local 7
i32.const 24
i32.shr_s
get_local 7
i32.xor
i32.const 1540483477
i32.mul
get_local 5
i32.const 1540483477
i32.mul
i32.xor
set_local 5
get_local 4
i32.const 7
i32.gt_s
    if
get_local 3
i32.const 4
i32.add
set_local 3
get_local 4
i32.const -4
i32.add
set_local 4
br 1
    end
  end
get_local 1
i32.const -4
i32.add
get_local 6
i32.sub
set_local 7
get_local 0
i32.add
i32.const 4
i32.add
set_local 6
  else
get_local 1
get_local 0
set_local 6
tee_local 5
set_local 7
end
block
  block
    block
      block
        block
          block
            block
get_local 7
i32.const 1
i32.sub
br_table 2 1 0 3
            end
get_local 6
i32.load8_s offset=2
tee_local 7
i32.const 16
i32.shl
get_local 5
i32.xor
set_local 5
br 3
          end
br 2
        end
br 2
      end
br 2
    end
get_local 6
i32.load8_s offset=1
tee_local 7
i32.const 8
i32.shl
get_local 5
i32.xor
set_local 5
  end
get_local 6
i32.load8_s
tee_local 7
get_local 5
i32.xor
i32.const 1540483477
i32.mul
set_local 5
end
get_local 5
i32.const 13
i32.shr_s
get_local 5
i32.xor
i32.const 1540483477
i32.mul
tee_local 5
i32.const 15
i32.shr_s
get_local 5
i32.xor
get_local 2
i32.rem_s
)
	`
	inlines_std_mem.push(str);
	inlines_onces["require_hash"] = true;
}


//// 动态分陪内存 * n

///动态内存位置就是 0
function require_alloc () {
	/////是否为null
	/////
	var str = `
	(func $copy_to_string (param i32 i32 i32)(result i32)
		(local i32 i32 i32 i32) 
		
		get_local 0 ;; n
		get_local 2 ;; ebx
		i32.add     ;; len = dist + n 
		set_local 2 ;; len = [2]
		
		loop $cont
			;;a[i] = b [j]
			get_local 0 ;; a[i]
			get_local 1 ;; n[j]
			i32.load8_u
			i32.store
			
			;; i++ 
			get_local 0
			i32.const 1
			i32.add 
			set_local 0
			
			;; j++ 
			get_local 1
			i32.const 1
			i32.add 
			set_local 1
			
			;; loop
			get_local 0 ;; i
			get_local 2 ;; len
			i32.le_u    ;; i <= len
			if 
				br $cont
			end
		end
		get_local 2
	)
	
	`
	inlines_std_mem.push(str);
}