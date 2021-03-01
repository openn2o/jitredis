(module
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_ii (func (param i32)(result i32)))
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
(func $_Z5test3Pi (export "__Z5test3Pi")(param i32)(result i32)
(local i32 i32)
get_global 0
tee_local 1
i32.const -16
i32.add
tee_local 2
set_global 0
get_local 1
set_global 0
get_local 2
i32.const 4
i32.add
)
(func $_Z5test2Pi (export "__Z5test2Pi")(param i32)(result i32)
(local)
get_local 0
i32.const 0
i32.store offset=4 align=4
get_local 0
i32.const 1
i32.store offset=8 align=4
get_local 0
i32.const 2
i32.store offset=12 align=4
get_local 0
i32.load align=4
)
(func $_Z5test1Pi (export "__Z5test1Pi")(param i32)(result i32)
(local)
get_local 0
i32.load offset=12 align=4
)
)