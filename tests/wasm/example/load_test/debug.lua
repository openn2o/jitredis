(module
(type $vt_ii (func (param i32)(result i32)))
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_iiii (func (param i32 i32 i32)(result i32)))
(func (import "i" "n")(param i32)(result i32))
(func (import "i" "l")(param i32)(result i32))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "Z") 17 2048)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z13base64_decodeiii (export "__Z13base64_decodeiii")(param i32 i32 i32)(result i32)
(local i32 i32 i32 i32 i32 i32)
get_local 0
call 0
set_local 3
get_local 1
call 0
tee_local 4
get_local 2
i32.const 3
i32.and
if
i32.const 0
return
end
get_local 2
if
i32.const 0
tee_local 5
set_local 6
  loop
get_local 6
get_local 3
i32.add
i32.load8_u
tee_local 7
i32.const 61
i32.ne
    if
get_local 7
i32.const 213
i32.add
i32.const 255
i32.and
i32.const 79
i32.gt_u
      if
i32.const 0
return
      end
get_local 7
i32.load8_u offset=1048584
tee_local 7
i32.const 255
i32.eq
      if
i32.const 0
return
      end
      block
        block
          block
            block
              block
get_local 6
i32.const 3
i32.and
br_table 0 1 2 3 4
              end
get_local 5
get_local 4
i32.add
get_local 7
i32.const 2
i32.shl
i32.store8
br 3
            end
get_local 5
get_local 4
i32.add
tee_local 8
get_local 8
i32.load8_u
get_local 7
i32.const 4
i32.shr_u
i32.const 3
i32.and
i32.or
i32.store8
get_local 5
i32.const 1
i32.add
tee_local 5
get_local 4
i32.add
get_local 7
i32.const 4
i32.shl
i32.store8
br 2
          end
get_local 5
get_local 4
i32.add
tee_local 8
get_local 8
i32.load8_u
get_local 7
i32.const 2
i32.shr_u
i32.const 15
i32.and
i32.or
i32.store8
get_local 5
i32.const 1
i32.add
tee_local 5
get_local 4
i32.add
get_local 7
i32.const 6
i32.shl
i32.store8
br 1
        end
get_local 5
get_local 4
i32.add
tee_local 8
get_local 8
i32.load8_u
get_local 7
i32.or
i32.store8
get_local 5
i32.const 1
i32.add
set_local 5
br 0
      end
get_local 6
i32.const 1
i32.add
tee_local 6
get_local 2
i32.lt_u
br_if 1
    end
  end
  else
i32.const 0
set_local 5
end
get_local 5
get_local 4
i32.add
i32.const 0
i32.store8
call 1
)
(func $_Z13base64_encodeiii (export "__Z13base64_encodeiii")(param i32 i32 i32)(result i32)
(local i32 i32 i32 i32 i32 i32 i32 i32)
get_local 0
call 0
set_local 3
get_local 1
call 0
set_local 4
get_local 2
i32.eqz
if
get_local 4
i32.const 0
i32.store8
get_local 4
call 1
return
end
i32.const 0
tee_local 5
tee_local 7
tee_local 8
set_local 9
loop
get_local 8
get_local 3
i32.add
i32.load8_u
set_local 6
  block
    block
      block
        block
          block
get_local 9
br_table 0 1 2 3
          end
get_local 7
get_local 4
i32.add
get_local 6
tee_local 10
i32.const 2
i32.shr_u
i32.load8_u offset=1048712
i32.store8
get_local 7
i32.const 1
i32.add
set_local 7
i32.const 1
set_local 9
br 3
        end
get_local 7
get_local 4
i32.add
get_local 6
tee_local 10
i32.const 4
i32.shr_u
get_local 5
i32.const 4
i32.shl
i32.const 48
i32.and
i32.or
i32.load8_u offset=1048712
i32.store8
get_local 7
i32.const 1
i32.add
set_local 7
i32.const 2
set_local 9
br 2
      end
get_local 7
get_local 4
i32.add
get_local 6
tee_local 10
i32.const 6
i32.shr_u
get_local 5
i32.const 2
i32.shl
i32.const 60
i32.and
i32.or
i32.load8_u offset=1048712
i32.store8
get_local 7
get_local 4
i32.add
get_local 6
i32.const 63
i32.and
i32.load8_u offset=1048712
i32.store8 offset=1
get_local 7
i32.const 2
i32.add
set_local 7
i32.const 0
set_local 9
br 1
    end
get_local 6
set_local 10
  end
get_local 8
i32.const 1
i32.add
tee_local 8
get_local 2
i32.eq
  if
get_local 7
get_local 4
i32.add
tee_local 8
    block
      block
        block
get_local 9
i32.const 1
i32.sub
br_table 0 1 2
        end
get_local 8
get_local 10
i32.const 4
i32.shl
i32.const 48
i32.and
i32.load8_u offset=1048712
i32.store8
get_local 7
get_local 4
i32.add
i32.const 61
i32.store8 offset=1
get_local 7
get_local 4
i32.add
i32.const 61
i32.store8 offset=2
get_local 7
get_local 4
i32.add
i32.const 0
i32.store8 off