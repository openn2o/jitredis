(module
(type $vt_v (func ))
(type $vt_ii (func (param i32)(result i32)))
(type $vt_i (func (result i32)))
(type $vt_id (func (param f64)(result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "memory") 17 2048)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $_Z3fibi (export "__Z3fibi")(param i32)(result i32)
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
(func $_Z7size_ofd (export "__Z7size_ofd")(param f64)(result i32)
(local i32 i32 i32)
get_global 0
tee_local 1
i32.const -8
i32.add
tee_local 2
set_global 0
i32.const 0
set_local 3
loop
get_local 2
i32.const 1
i32.store offset=4 align=4
get_local 2
i32.const 2
i32.store align=4
get_local 3
i32.const 1
i32.add
tee_local 3
i32.const 10000
i32.ne
br_if 0
end
get_local 2
i32.load align=4
tee_local 2
get_local 1
set_global 0
)
)