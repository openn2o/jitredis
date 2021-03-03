(module
(type $vt_vi (func (param i32)))
(type $vt_v (func ))
(type $vt_ii (func (param i32)(result i32)))
(type $vt_i (func (result i32)))
(type $vt_vii (func (param i32 i32)))
(func (import "i" "__ZN6client5printEi")(param i32))
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
call 2
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
(func $_Z19get_module_version2Phi (export "__Z19get_module_version2Phi")(param i32 i32)
(local i32 i32)
get_local 1
i32.const 0
i32.ge_s
if
i32.const 0
set_local 2
  loop
get_local 2
get_local 0
i32.add
tee_local 3
i32.load8_u
call 0
get_local 3
i32.const 1
i32.store8
get_local 2
get_local 1
i32.ne
    if
get_local 2
i32.const 1
i32.add
set_local 2
br 1
    end
  end
end
)
)