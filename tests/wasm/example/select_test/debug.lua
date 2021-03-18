(module
(type $vt_v (func ))
(type $vt_i (func (result i32)))
(type $vt_iii (func (param i32 i32)(result i32)))
(table anyfunc (elem $__wasm_nullptr))
(memory (export "K") 17 128)
(global (mut i32) (i32.const 1048576))
(func $__wasm_nullptr (export "___wasm_nullptr")
(local)
unreachable
)
(func $main (export "_main")(result i32)
(local)
i32.const 0
)
(func $_Z13br_table_muliii (export "__Z13br_table_muliii")(param i32 i32)(result i32)
(local)
block
  block
    block
get_local 1
i32.const 5
i32.sub
br_table 0 2 2 2 2 2 2 1 2
    end
i32.const 1
return
  end
i32.const 2
return
end
i32.const 2
i32.const 3
i32.const 5
get_local 0
i32.const 2
i32.eq
select
get_local 0
i32.const 1
i32.eq
select
)
)