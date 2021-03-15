(module
(type $vt_ii (func (param i32)(result i32)))
(type $vt_vi (func (param i32)))
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(func (import "i" "i")(param i32)(result i32))
(func (import "i" "h")(param i32)(result i32))
(func (import "i" "g")(param i32))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "P") 17 128)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local i32)
i32.const 10