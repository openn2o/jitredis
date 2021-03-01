(module
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_iiii (func (param i32 i32 i32)(result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "memory") 17 2048)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z5hash2Pcii (export "__Z5hash2Pcii")(param i32 i32 i32)(result i32)
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
(func $_Z7DJBHashPcii (export "__Z7DJBHashPcii")(param i32 i32 i32)(result i32)
(local i32 i32 i32)
get_local 1
i32.const 0
i32.lt_s
if
i32.const 5381
get_local 2
i32.rem_u
return
end
get_local 1
i32.const 1
i32.add
set_local 3 ;3 is i
i32.const 1
i32.const 5381
set_local 5
set_local 4
loop
get_local 5
i32.const 33
i32.mul
get_local 4
get_local 0
i32.add
i32.load8_s
i32.add
set_local 5
get_local 4
get_local 3
i32.eq
  if
get_local 5
i32.const 2147483647
i32.and
get_local 2
i32.rem_u
return
  end
get_local 4
i32.const 1
i32.add
set_local 4
br 0
end
i32.const 0
)
)