(module
(type $vt_ii (func (param i32)(result i32)))
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_iiii (func (param i32 i32 i32)(result i32)))
(func (import "i" "m")(param i32)(result i32))
(func (import "i" "k")(param i32)(result i32))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "W") 17 128)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z13base64_encodeiii (export "__Z13base64_encodeiii")(param i32 i32 i32)(result i32)
(local i32 i32 i32 i32 i32 i32 i32)
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
tee_local 6
tee_local 7
set_local 8
loop
get_local 7
get_local 3
i32.add
i32.load8_u
set_local 9
  block
    block
      block
        block
          block
get_local 8
br_table 0 1 2 3
          end
get_local 6
get_local 4
i32.add
get_local 9
tee_local 9
i32.const 2
i32.shr_u
i32.load8_u offset=1048584
i32.store8
get_local 6
i32.const 1
i32.add
set_local 6
i32.const 1
set_local 8
br 3
        end
get_local 6
get_local 4
i32.add
get_local 9
tee_local 9
i32.const 4
i32.shr_u
get_local 5
i32.const 4
i32.shl
i32.const 48
i32.and
i32.or
i32.load8_u offset=1048584
i32.store8
get_local 6
i32.const 1
i32.add
set_local 6
i32.const 2
set_local 8
br 2
      end
get_local 6
get_local 4
i32.add
get_local 9
tee_local 9
i32.const 6
i32.shr_u
get_local 5
i32.const 2
i32.shl
i32.const 60
i32.and
i32.or
i32.load8_u offset=1048584
i32.store8
get_local 6
get_local 4
i32.add
get_local 9
i32.const 63
i32.and
i32.load8_u offset=1048584
i32.store8 offset=1
get_local 6
i32.const 2
i32.add
set_local 6
i32.const 0
set_local 8
br 1
    end
get_local 9
set_local 9
  end
get_local 7
i32.const 1
i32.add
tee_local 7
get_local 2
i32.eq
  if
get_local 6
get_local 4
i32.add
tee_local 7
    block
      block
        block
get_local 8
i32.const 1
i32.sub
br_table 0 1 2
        end
get_local 7
get_local 9
i32.const 4
i32.shl
i32.const 48
i32.and
i32.load8_u offset=1048584
i32.store8
get_local 6
get_local 4
i32.add
i32.const 61
i32.store8 offset=1
get_local 6
get_local 4
i32.add
i32.const 61
i32.store8 offset=2
get_local 6
get_local 4
i32.add
i32.const 0
i32.store8 offset=3
get_local 4
call 1
return
      end
get_local 7
get_local 9
i32.const 2
i32.shl
i32.const 60
i32.and
i32.load8_u offset=1048584
i32.store8
get_local 6
get_local 4
i32.add
i32.const 61
i32.store8 offset=1
get_local 6
get_local 4
i32.add
i32.const 0
i32.store8 offset=2
get_local 4
call 1
return
    end
i32.const 0
i32.store8
get_local 4
call 1
return
  end
get_local 9
set_local 5
br 0
end
i32.const 0
)
(data (i32.const 1048584) "\41\42\43\44\45\46\47\48\49\4a\4b\4c\4d\4e\4f\50\51\52\53\54\55\56\57\58\59\5a\61\62\63\64\65\66\67\68\69\6a\6b\6c\6d\6e\6f\70\71\72\73\74\75\76\77\78\79\7a\30\31\32\33\34\35\36\37\38\39\2b\2f")
)