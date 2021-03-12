(module
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_iiii (func (param i32 i32 i32)(result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "Z") 17 128)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
unreachable
unreachable
)
(func $_Z10b64_decodePcjS_ (export "__Z10b64_decodePcjS_")(param i32 i32 i32)(result i32)
(local i32 i32 i32 i32 i32 i32 i32 i32 i32)
get_global 0
tee_local 3
i32.const -16
i32.add
tee_local 6
set_global 0
get_local 6
tee_local 6
set_local 4
get_local 1
i32.eqz
if
get_local 3
set_global 0
i32.const 0
return
end
i32.const 0
tee_local 7
tee_local 8
set_local 9
loop
get_local 8
i32.const 2
i32.shl
get_local 6
i32.add
tee_local 10
get_local 9
get_local 0
i32.add
i32.load8_s
set_local 5
  block
    block
      block
        block
          block
get_local 5
i32.const 43
i32.sub
br_table 0 3 3 3 1 3 3 3 3 3 3 3 3 3 3 3 3 3 2 3
          end
i32.const 62
set_local 11
br 3
        end
i32.const 63
set_local 11
br 2
      end
i32.const 64
set_local 11
br 1
    end
get_local 5
i32.const -48
i32.add
i32.const 10
i32.lt_u
    if
get_local 5
i32.const 4
i32.add
set_local 11
      else
get_local 5
i32.const -65
i32.add
tee_local 11
i32.const 26
i32.ge_u
      if
get_local 5
i32.const -71
i32.add
i32.const 0
get_local 5
i32.const -97
i32.add
i32.const 26
i32.lt_u
select
set_local 11
      end
    end
  end
get_local 11
i32.store align=4
get_local 8
i32.const 1
i32.add
tee_local 8
i32.const 4
i32.eq
  if
get_local 6
i32.load offset=4 align=4
set_local 8
get_local 7
get_local 2
i32.add
get_local 8
i32.const 4
i32.shr_u
i32.const 3
i32.and
get_local 4
i32.load align=4
i32.const 2
i32.shl
i32.add
i32.store8
get_local 6
i32.load offset=8 align=4
tee_local 10
i32.const 64
i32.eq
    if
i32.const 1
set_local 8
      else
get_local 7
get_local 2
i32.add
get_local 10
i32.const 2
i32.shr_u
i32.const 15
i32.and
get_local 8
i32.const 4
i32.shl
i32.add
i32.store8 offset=1
get_local 6
i32.load offset=12 align=4
tee_local 8
i32.const 64
i32.eq
      if
i32.const 2
set_local 8
        else
get_local 7
get_local 2
i32.add
get_local 8
get_local 10
i32.const 6
i32.shl
i32.add
i32.store8 offset=2
i32.const 3
set_local 8
      end
    end
get_local 8
get_local 7
i32.add
set_local 7
i32.const 0
set_local 8
  end
get_local 9
i32.const 1
i32.add
tee_local 9
get_local 1
i32.ne
br_if 0
end
get_local 3
set_global 0
get_local 7
)
)