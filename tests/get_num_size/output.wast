(module
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_ii (func (param i32)(result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "J") 17 2048)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z7b64_inth (export "__Z7b64_inth")(param i32)(result i32)
(local)
block
block
block
get_local 0
i32.const 43
i32.sub
i32.const 255
i32.and
br_table 0 2 2 2 1 2
end
i32.const 62
return
  end
i32.const 63
return
end
i32.const 64
i32.const 0
get_local 0
i32.const 255
i32.and
i32.const 61
i32.eq
select
)
)