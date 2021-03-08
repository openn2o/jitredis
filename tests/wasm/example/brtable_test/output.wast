(module
(type $vt_v (func ))
(type $vt_ii (func (param i32)(result i32)))
(type $vt_i (func (result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "P") 17 2048)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $_Z3fabi (export "__Z3fabi")(param i32)(result i32)
(local i32 i32 i32)
get_local 0
i32.const -1
i32.add
tee_local 2
i32.const 2
i32.lt_u
if
i32.const 1
return
end
get_local 0
i32.const 1
set_local 3
set_local 1
loop
get_local 1
i32.const -3
i32.add
get_local 2
call 1
get_local 3
i32.add
set_local 3
tee_local 2
i32.const 2
i32.lt_u
  if
get_local 3
return
  end
get_local 1
i32.const -2
i32.add
set_local 1
br 0
end
i32.const 0
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z7b64_inti (export "__Z7b64_inti")(param i32)(result i32)
(local i32)
block
  block
    block
      block
get_local 0
i32.const 43
i32.sub
br_table 0 3 3 3 1 3 3 3 3 3 3 3 3 3 3 3 3 3 2 3
      end
i32.const 62
return
    end
i32.const 63
return
  end
i32.const 64
return
end
get_local 0
i32.const -48
i32.add
i32.const 10
i32.lt_u
if
get_local 0
i32.const 4
i32.add
return
end
get_local 0
i32.const -65
i32.add
tee_local 1
i32.const 26
i32.lt_u
if
get_local 1
return
end
get_local 0
i32.const -71
i32.add
i32.const 0
get_local 0
i32.const -97
i32.add
i32.const 26
i32.lt_u
select
)
(func $_Z20brtable_month_day_p2i (export "__Z20brtable_month_day_p2i")(param i32)(result i32)
(local)
block
  block
    block
get_local 0
i32.const 1
i32.sub
br_table 0 2 0 1 0 1 0 0 1 0 1 0 2
    end
i32.const 31
return
  end
i32.const 30
return
end
i32.const 29
)
(func $_Z19brtable_month_day_pi (export "__Z19brtable_month_day_pi")(param i32)(result i32)
(local)
block
  block
    block
get_local 0
i32.const 1
i32.sub
br_table 0 2 0 1 0 1 0 0 1 0 1 0 2
    end
i32.const 31
return
  end
i32.const 30
return
end
i32.const 28
)
)