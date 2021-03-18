(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func))
  (type (;3;) (func (result i32)))
  (type (;4;) (func (param i32 i32 i32) (result i32)))
  (type (;5;) (func (param i32 i32) (result i32)))
  (import "i" "__ZN4ccm13logEi" (func (;0;) (type 0)))
  (import "i" "__ZN4ccm127warp_from_value_to_uint8ptrEi" (func (;1;) (type 1)))
  (import "i" "___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh" (func (;2;) (type 1)))
  (func (;3;) (type 2)
    unreachable)
  (func (;4;) (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.const -1
    i32.add
    local.tee 2
    i32.const 2
    i32.lt_u
    if  ;; label = @1
      i32.const 1
      return
    end
    local.get 0
    i32.const 1
    local.set 3
    local.set 1
    loop  ;; label = @1
      local.get 1
      i32.const -3
      i32.add
      local.get 2
      call 4
      local.get 3
      i32.add
      local.set 3
      local.tee 2
      i32.const 2
      i32.lt_u
      if  ;; label = @2
        local.get 3
        return
      end
      local.get 1
      i32.const -2
      i32.add
      local.set 1
      br 0 (;@1;)
    end
    i32.const 0)
  (func (;5;) (type 3) (result i32)
    i32.const 40
    call 4
    call 0
    i32.const 0)
  (func (;6;) (type 4) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    call 1
    local.set 3
    local.get 1
    call 1
    local.set 4
    local.get 2
    i32.eqz
    if  ;; label = @1
      local.get 4
      i32.const 0
      i32.store8
      local.get 4
      call 2
      return
    end
    i32.const 0
    local.tee 5
    local.tee 6
    local.tee 7
    local.set 8
    loop  ;; label = @1
      local.get 7
      local.get 3
      i32.add
      i32.load8_u
      local.set 9
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 8
                br_table 0 (;@6;) 1 (;@5;) 2 (;@4;) 3 (;@3;)
              end
              local.get 6
              local.get 4
              i32.add
              local.get 9
              local.tee 9
              i32.const 2
              i32.shr_u
              i32.load8_u offset=1048584
              i32.store8
              local.get 6
              i32.const 1
              i32.add
              local.set 6
              i32.const 1
              local.set 8
              br 3 (;@2;)
            end
            local.get 6
            local.get 4
            i32.add
            local.get 9
            local.tee 9
            i32.const 4
            i32.shr_u
            local.get 5
            i32.const 4
            i32.shl
            i32.const 48
            i32.and
            i32.or
            i32.load8_u offset=1048584
            i32.store8
            local.get 6
            i32.const 1
            i32.add
            local.set 6
            i32.const 2
            local.set 8
            br 2 (;@2;)
          end
          local.get 6
          local.get 4
          i32.add
          local.get 9
          local.tee 9
          i32.const 6
          i32.shr_u
          local.get 5
          i32.const 2
          i32.shl
          i32.const 60
          i32.and
          i32.or
          i32.load8_u offset=1048584
          i32.store8
          local.get 6
          local.get 4
          i32.add
          local.get 9
          i32.const 63
          i32.and
          i32.load8_u offset=1048584
          i32.store8 offset=1
          local.get 6
          i32.const 2
          i32.add
          local.set 6
          i32.const 0
          local.set 8
          br 1 (;@2;)
        end
        local.get 9
        local.set 9
      end
      local.get 7
      i32.const 1
      i32.add
      local.tee 7
      local.get 2
      i32.eq
      if  ;; label = @2
        local.get 6
        local.get 4
        i32.add
        local.tee 7
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 8
              i32.const 1
              i32.sub
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;)
            end
            local.get 7
            local.get 9
            i32.const 4
            i32.shl
            i32.const 48
            i32.and
            i32.load8_u offset=1048584
            i32.store8
            local.get 6
            local.get 4
            i32.add
            i32.const 61
            i32.store8 offset=1
            local.get 6
            local.get 4
            i32.add
            i32.const 61
            i32.store8 offset=2
            local.get 6
            local.get 4
            i32.add
            i32.const 0
            i32.store8 offset=3
            local.get 4
            call 2
            return
          end
          local.get 7
          local.get 9
          i32.const 2
          i32.shl
          i32.const 60
          i32.and
          i32.load8_u offset=1048584
          i32.store8
          local.get 6
          local.get 4
          i32.add
          i32.const 61
          i32.store8 offset=1
          local.get 6
          local.get 4
          i32.add
          i32.const 0
          i32.store8 offset=2
          local.get 4
          call 2
          return
        end
        i32.const 0
        i32.store8
        local.get 4
        call 2
        return
      end
      local.get 9
      local.set 5
      br 0 (;@1;)
    end
    i32.const 0)
  (func (;7;) (type 5) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    local.get 1
    i32.gt_s
    select
    i32.const 100
    i32.mul)
  (func (;8;) (type 5) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    local.get 1
    i32.gt_s
    select)
  (func (;9;) (type 5) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    local.get 1
    i32.gt_s
    select)
  (func (;10;) (type 5) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 0
    local.get 1
    i32.gt_s
    select)
  (table (;0;) 1 funcref)
  (memory (;0;) 17 128)
  (global (;0;) (mut i32) (i32.const 1048576))
  (export "memory" (memory 0))
  (export "_main" (func 5))
  (export "__Z9test_max1ii" (func 10))
  (export "__Z9test_max2ii" (func 9))
  (export "__Z9test_max3ii" (func 8))
  (export "__Z9test_max4ii" (func 7))
  (export "__Z3fabi" (func 4))
  (export "__Z13base64_encodeiii" (func 6))
  (elem (;0;) (i32.const 0) func 3)
  (data (;0;) (i32.const 1048584) "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"))
