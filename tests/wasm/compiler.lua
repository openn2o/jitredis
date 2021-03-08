local memoryManager = require("memory")

local compiler = {}
local instructions

--确认是否为test语句
local is_eq_exp = function (str) 
  if str ~= nil then
    if (string.find(str, "and 1 or 0") ~= nil) then 
      return true;
    end
  end
  return false;
end


local kinds = {
  Function = 0,
  Table = 1,
  Memory = 2,
  Global = 3
}

 --- 解码 c++符号
local ccm1_cpp_ns_symblos_decode = function (v)
  local magic_tag = string.sub(v, 1,4);
  if magic_tag ~= "__ZN" then
    return "", v;
  end
  local name_size_t = {};
  local is_long_name = 0;
  local num_of_name  = 0;
  local look_up = string.sub(v, 5, 5);
  if (look_up >= '0' and look_up <= '9') then
    name_size_t [1] = tonumber(look_up) ;
    is_long_name = 1;
  end
  local look_up = string.sub(v, 6, 6);
  if (look_up >= '0' and look_up <= '9') then
    is_long_name = 2;
    name_size_t [2] = tonumber(look_up) ;
  end
  if is_long_name == 2 then
    num_of_name = (name_size_t[1] * 10) + name_size_t[2];
  else
    num_of_name = name_size_t[1];
  end
  ---namespace 
  local ns_name  = string.sub(v, 5 + is_long_name, 5 + is_long_name + num_of_name - 1);
  local next_n   = 5 + is_long_name + num_of_name ;
  local look_up  = string.sub(v, next_n, next_n);
  if (look_up >= '0' and look_up <= '9') then
    name_size_t [1] = tonumber(look_up) ;
    is_long_name = 1;
  end
  local look_up = string.sub(v, next_n+1, next_n+1);
  if (look_up >= '0' and look_up <= '9') then
    is_long_name = 2;
    name_size_t [2] = tonumber(look_up) ;
  end
  if is_long_name == 2 then
    num_of_name = (name_size_t[1] * 10) + name_size_t[2];
  else
    num_of_name = name_size_t[1];
  end
  local method_name = string.sub(v, next_n + is_long_name, next_n + is_long_name + num_of_name - 1);
  return ns_name, method_name;
end



local pageSize = 2^16
local function makeMemory(name, size)
  return ([[
local %s = ffi.new("uint8_t[%d]")
local %sSize = %d
exportTable.memory = A
]]):format(name, size*pageSize, name, size)
end

local function constMemoryStore(memoryName, addr, segment)
  local src = ""
  for i = 1, #segment do
    src = src .. ([[%s[%d] = %d
]]):format(memoryName, addr + i - 1, segment:sub(i, i):byte())
  end

  return src
end

local function mangleImport(ns, field)
  return ns .. "__" .. field
end

local nameDebug = false
local nameCounter = 0
local nameAB = ("A"):byte()
function makeName()
  if nameDebug then
    nameCounter = nameCounter + 1
    return "var" .. nameCounter
  else
    local build = ""
    local thisCount = nameCounter
    repeat
      build = string.char(nameAB + (thisCount % 26)) .. build
      thisCount = math.floor(thisCount / 26)
    until thisCount == 0
    nameCounter = nameCounter + 1
    return build
  end
end

local prefabs = {
  unlinked = [[
for k, v in pairs(imports) do
  if not imports[k] then
    imports[k] = function(...)
      print("Unlinked Method " .. k);
    end
  end
end
]],
  ifTrue = [[
local function checkCondition(cond)
  return cond == true or (cond ~= false and cond ~= 0)
end
]],
  memory = [[
local function storeMem(mem, memSize, addr, val, bytes)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0] = val
  else
    ffi.cast("int" .. bytes .. "_t*", mem + addr)[0] = val
  end
end
local function storeFloat(mem, memSize, addr, val, bytes)
  val = val or 0
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to store outside bounds", 2)
  end
  if bytes == 8 then
    ffi.cast("double*", mem + addr)[0] = val
  else
    ffi.cast("float*", mem + addr)[0] = val
  end
end
local function readMem(mem, memSize, addr, bytes)
  if addr < 0 or addr > memSize*(2^16) then
    error("Attempt to read outside bounds " .. addr, 2)
  end
  if bytes == 8 then
    return ffi.cast("uint" .. bytes .. "_t*", mem + addr)[0]
  else
    return ffi.cast("int" .. bytes .. "_t*", mem + addr)[0]
  end
end
]],
cache = [[
local bit = require("bit");
local ffi = require("ffi");
]]
}

local function tee(stack, offset)
  offset = offset or 0
  return stack[#stack - offset]
end

local function pop(stack)
  local val = stack[#stack]
  stack[#stack] = nil
  return val
end

local function push(stack, val)
  stack[#stack + 1] = val
end

local function jumpInstr(loopQ)
  if loopQ then
    return "Start"
  else
    return "Finish"
  end
end

local generators
generators = {
  Try = function (stack, instr, argList, fnLocals)
    print("::::::Try not implement");
  end,
  ReturnCallIndirect = function (stack, instr, argList, fnLocals)
    print("::::::ReturnCallIndirect not implement")
  end,
  CallIndirect = function (stack, instr, argList, fnLocals)
    print("::::::CallIndirect not implement")
  end,
  BrTable      = function (stack, instr, argList, fnLocals, blockStack, instance)
    --b_brtable
    local br_tables = {}
    print("BRTable is run debug2");
    -- print(table.concat(stack),",");
    -- print("222....................", fnLocals[#fnLocals]);
    local loc_br_tables       = fnLocals[#fnLocals].br_tables;
    local loc_br_tables_depth = fnLocals[#fnLocals].brtable_stack_depth;
    local loc_br_table_stack  = fnLocals[#fnLocals].brtable_stack;

    local depth_ = 0;
    local slength= loc_br_tables_depth;

    br_tables[#br_tables + 1] = "\tlocal eax=" .. pop(stack);
    br_tables[#br_tables + 1] = "\tlocal branch_tab = ffi.new('int[" ..  #loc_br_tables .. "]', {" .. table.concat(loc_br_tables, ",") .. "})"; 
    br_tables[#br_tables + 1] = "\tif (eax < ".. #loc_br_tables ..") then"
    br_tables[#br_tables + 1] = "\teax=branch_tab[eax];"
    while depth_ <  slength do
      br_tables[#br_tables + 1] = "\t if eax == " .. (slength - depth_ - 1) .. " then"
      br_tables[#br_tables + 1] = "\t\t goto " .. loc_br_table_stack[depth_ + 1] .. "Finish"
      br_tables[#br_tables + 1] = "\t end"
      depth_ = depth_ + 1;
    end
    br_tables[#br_tables + 1] = "\telse";
    br_tables[#br_tables + 1] = "\t\t goto " .. loc_br_table_stack[slength] .. "Finish"
    br_tables[#br_tables + 1] = "\tend\n";
    return table.concat(br_tables, "\n");
  end,
  Select   = function (stack, instr, argList, fnLocals)
    -- b_select for debug point 
    print("Select stack1 =" , table.concat(stack, ","));
    local effect = "";
    local p1 = pop(stack);
    local p2 = pop(stack);
    local p3 = pop(stack);

    print("p1=", type(p1), string.byte(p1,1));
    if is_eq_exp(p1) then
      push (stack, table.concat(
        {
          "(checkCondition(",
          p1,
          ") and ",
          p3,
          ") or (",
          p2,
          ")"
        }
      ));
    else
      if p2 ~= nil and p3 ~= nil then
        push (stack, table.concat(
          {
            "(checkCondition(",
            p1 .. " == 0",
            ") and ",
            p2,
            ") or (",
            p3,
            ")"
          }
        ));
      end
    end

    print("Select stack2 =" , table.concat(stack, ","))
    return effect;
  end,
  GetLocal = function(stack, instr, argList, fnLocals)
    local index = instr.imVal
    if index < #argList then
      stack[#stack + 1] = argList[index + 1]
    else
      stack[#stack + 1] = fnLocals[index - #argList + 1]
    end
  end,

  SetLocal = function(stack, instr, argList, fnLocals)
    local index = instr.imVal
    if index < #argList then
      return ("  %s = %s\n"):format(argList[index + 1], pop(stack))
    else
      return ("  %s = %s\n"):format(fnLocals[index - #argList + 1], pop(stack))
    end
  end,

  TeeLocal = function(stack, instr, argList, fnLocals)
    local index = instr.imVal

    if index < #argList then
      return ("  %s = %s\n"):format(argList[index + 1], tee(stack))
    else
      return ("  %s = %s\n"):format(fnLocals[index - #argList + 1], tee(stack))
    end
  end,

  GetGlobal = function(stack, instr, _, _, _, instance)
    push(stack, instance.globals[instr.imVal])
  end,
  SetGlobal = function(stack, instr, _, _, _, instance)
    return ("  %s = %s\n"):format(instance.globals[instr.imVal], pop(stack))
  end,

  Call = function(stack, instr, argList, fnLocals, blockStack, instance)
    local realIndex = instr.imVal - instance.functionImportCount
    local fnKind, fnName
    if realIndex >= 0 then
      local fn = instance.functions[instr.imVal]
      fnKind = instance.sectionData[3][realIndex]
      fnName = fn.name
    else
      fnKind = instance.sectionData[2][instr.imVal].typeIndex
      local import = instance.sectionData[2][instr.imVal]
      local ns_name , method_name = ccm1_cpp_ns_symblos_decode(import.field);
      -- import.module = ns_name ;
      -- import.field  = method_name;
      fnName = ("imports.%s"):format(mangleImport(ns_name, method_name))
    end

    local sig = instance.sectionData[1][fnKind]
    local passingArguments = {}
    for i = 1, #sig.params do
      passingArguments[#sig.params - i + 1] = pop(stack)
    end

    local results = {}
    for i = 1, #sig.returns do
      results[#results + 1] = makeName()
      push(stack, results[#results])
    end
    
    if #results > 0 then
      return ("  local %s = %s(%s)\n"):format(table.concat(results, ", "), fnName, table.concat(passingArguments, ", "))
    else
      return ("  %s(%s)\n"):format(fnName, table.concat(passingArguments, ", "))
    end
  end,

  I32Add = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(%s + %s)"):format(a, b))
  end,
  I32Sub = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(%s - %s)"):format(a, b))
  end,
  I32Mul = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(%s * %s)"):format(a, b))
  end,
  I32DivU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(math.abs(math.floor(%s / %s)))"):format(a, b))
  end,
  I32DivS = function(stack)
    -- This is wrong
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(math.floor(%s / %s))"):format(a, b))
  end,
  I32RemU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(math.floor(%s %% %s))"):format(a, b))
  end,
  I32Shl = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.lshift(%s, %s))"):format(a, b))
  end,
  I32ShrU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.rshift(%s, %s))"):format(a, b))
  end,
  I32ShrS = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.arshift(%s, %s))"):format(a, b))
  end,
  I32And = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.band(%s, %s))"):format(a, b))
  end,
  I32Or = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.bor(%s, %s))"):format(a, b))
  end,
  I32Rotr = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.ror(%s, %s))"):format(a, b))
  end,
  I32Rotl = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(bit.rol(%s, %s))"):format(a, b))
  end,
  I32Const = function(stack, instr)
    push(stack, tostring(instr.imVal))
  end,

  I32Ne = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s ~= %s) and 1 or 0)"):format(a, b))
  end,
  I32Eq = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s == %s) and 1 or 0)"):format(a, b))
  end,
  I32Eqz = function(stack)
    local a = pop(stack)
    push(stack, ("((%s == 0) and 1 or 0)"):format(a))
  end,
  I32GtU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s > %s) and 1 or 0)"):format(a, b))
  end,
  I32GeU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s >= %s) and 1 or 0)"):format(a, b))
  end,
  I32LtU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s < %s) and 1 or 0)"):format(a, b))
  end,
  I32LeU = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("((%s <= %s) and 1 or 0)"):format(a, b))
  end,

  F64Div = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("(%s / %s)"):format(a, b))
  end,

  F64ConvertUI32 = function(stack)
    local a = pop(stack)
    push(stack, ("math.abs(%s)"):format(a))
  end,
  I32TruncUF64 = function(stack)
    local a = pop(stack)
    push(stack, ("math.floor(math.abs(%s))"):format(a))
  end,
  I32TruncSF64 = function(stack)
    local a = pop(stack)
    push(stack, ("math.floor(%s)"):format(a))
  end,
  F64Trunc = function(stack)
    local a = pop(stack)
    push(stack, ("math.floor(%s)"):format(a))
  end,
  F64Abs = function(stack)
    local a = pop(stack)
    push(stack, ("math.abs(%s)"):format(a))
  end,
  F64Floor = function(stack)
    local a = pop(stack)
    push(stack, ("math.floor(%s)"):format(a))
  end,
  F64Ceil = function(stack)
    local a = pop(stack)
    push(stack, ("math.ceil(%s)"):format(a))
  end,
  F64Nearest = function(stack)
    -- TODO: actually round
    local a = pop(stack)
    push(stack, ("math.floor(%s)"):format(a))
  end,
  F64Sqrt = function(stack)
    local a = pop(stack)
    push(stack, ("math.sqrt(%s)"):format(a))
  end,
  F64Min = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("math.min(%s, %s)"):format(a, b))
  end,
  F64Max = function(stack)
    local b = pop(stack)
    local a = pop(stack)
    push(stack, ("math.max(%s, %s)"):format(a, b))
  end,

  Block = function(stack, instr, argList, fnLocals, blockStack, instance, fn, customDo, loopq)
    loopq = loopq or false
    customDo = customDo or "do"
      -- print(instr.imVal)
    if instr.imVal == -0x40 then
      -- Block does not return anything
      local blockLabel = makeName()
      push(blockStack, {label = blockLabel, exit = function()
        -- We got popped by an 'End', but we have nothing to return
      end, loop = loopq})
      ---brtables
      if(fnLocals[#fnLocals - 1] and( fnLocals[#fnLocals - 1] == 0x81)) then
        if (customDo == "do" ) then
          local loc_p = fnLocals[#fnLocals];
          loc_p.brtable_stack [#loc_p.brtable_stack+1] = blockLabel;
        end
      end

      return (" %s \n\t::%sStart::\n"):format(customDo, blockLabel);
    else
      -- Block returns something
      local blockResult = makeName()
      local blockLabel  = makeName()
      push(blockStack, {label = blockLabel, exit = function(actor, shouldAct, shouldPop)
        -- We got popped by an 'End'
        local res = shouldPop and pop(stack) or tee(stack)
        actor(("  %s = %s\n"):format(blockResult, res))
        if shouldAct then
          push(stack, blockResult)
        end
      end, loop = loopq})
      print( ("  local %s\n  %s ::%sStart::\n"):format(blockResult, customDo, blockLabel))
      return ("  local %s\n  %s ::%sStart::\n"):format(blockResult, customDo, blockLabel)
    end
  end,
  Loop = function(stack, instr, a, b, blockStack)
    return generators.Block(stack, instr, a, b, blockStack, nil, nil, nil, true)
  end,
  If = function(stack, instr, a, b, blockStack, c, d)
    local cond = pop(stack)
    return generators.Block(stack, instr, a, b, blockStack, c, d, ("if checkCondition(%s) then"):format(cond))
  end,
  Else = function(stack, _, _, _, blockStack)
    local effect = ""
    tee(blockStack).exit(function(str)
      effect = str
    end, false, true)

    return effect .. "  else\n"
  end,
  End = function(stack, _, _, _, blockStack)
    --b_end
    local effect = ""
    local block = pop(blockStack)
    block.exit(function(str)
      effect = str
    end, true, true)
    return ("\t::%sFinish::\n %s end\n"):format(block.label, effect)
  end,
  BrIf = function(stack, instr, a, b, blockStack, c, fn)
    local cond = pop(stack)
    local effect = ""
    for i = 0, instr.imVal - 1 do
      tee(blockStack).exit(function(str)
        effect = effect .. (str or "")
      end, false, false)
    end

    if instr.imVal == #blockStack then
      local retInstr = generators.Return(stack, instr, a, b, blockStack, c, fn)
      return ("  if checkCondition(%s) then\n  %s    %s\n  end\n"):format(cond, effect, retInstr)
    else
      local block = tee(blockStack, instr.imVal)
      local breakLabel = block.label
      local breakInstr = jumpInstr(block.loop)

      return ("  if checkCondition(%s) then\n  %s    goto %s%s\n  end\n"):format(cond, effect, breakLabel, breakInstr)
    end
  end,
  Br = function(stack, instr, a, b, blockStack, c, fn)
    local effect = ""
    for i = 0, instr.imVal - 1 do
      tee(blockStack).exit(function(str)
        effect = effect .. (str or "")
      end, false, false)
    end

    if instr.imVal == #blockStack then
      return generators.Return(stack, instr, a, b, blockStack, c, fn)
    end

    local block = tee(blockStack, instr.imVal)
    local jumpLabel = block.label
    local jumpInstr = jumpInstr(block.loop)

    return ("%s goto %s%s\n"):format(effect, jumpLabel, jumpInstr)
  end,
  Drop = function(stack)
    pop(stack)
  end,

  I32Load = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(readMem(%s, %sSize, %s, 32))]]):format(instance.memories[0], instance.memories[0], addr)) -- ffi.cast("uint32_t*", %s + %s)[0]
  end,
  I32Load8U = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(readMem(%s, %sSize, %s, 8))]]):format(instance.memories[0], instance.memories[0], addr)) -- ffi.cast("uint8_t*", %s + %s)[0]
  end,
  I32Load8S = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(readMem(%s, %sSize, %s, 8))]]):format(instance.memories[0], instance.memories[0], addr)) -- ffi.cast("uint8_t*", %s + %s)[0]
  end,
  I32Load16U = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(readMem(%s, %sSize, %s, 16))]]):format(instance.memories[0], instance.memories[0], addr)) -- ffi.cast("uint16_t*", %s + %s)[0]
  end,
  I32Store = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeMem(%s, %sSize, %s, %s, 32)]] .. "\n"):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("uint32_t*", %s + %s)[0] = %s%s
  end,
  I32StoreU = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeMem(%s, %sSize, %s, %s, 8)]] .. "\n"):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("uint8_t*", %s + %s)[0] = %s%s
  end,
  I32Store8 = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeMem(%s, %sSize, %s, %s, 8)]] .. "\n"):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("uint8_t*", %s + %s)[0] = %s%s
  end,
  I32Store16 = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeMem(%s, %sSize, %s, %s, 16)]] .. "\n"):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("uint16_t*", %s + %s)[0] = %s%s
  end,
  I64Load = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(ffi.cast("uint64_t*", %s + %s)[0])]]):format(instance.memories[0], addr))
  end,
  I64Store = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeMem(%s, %sSize, %s, %s, 64)]] .. "\n"):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("uint64_t*", %s + %s)[0] = %s%s
  end,
  F64Load = function(stack, _, _, _, _, instance)
    local addr = pop(stack)
    push(stack, ([[(ffi.cast("double*", %s + %s)[0])]]):format(instance.memories[0], addr))
  end,
  F64Store = function(stack, _, _, _, _, instance)
    local value = pop(stack)
    local addr = pop(stack)
    return ([[  storeFloat(%s, %sSize, %s, %s, 8)]]):format(instance.memories[0], instance.memories[0], addr, value, "\n") -- ffi.cast("double*", %s + %s)[0] = %s%s
  end,
  MemorySize = function(stack, _, _, _, _, instance)
    push(stack, instance.memories[0] .. "Size")
  end,
  MemoryGrow = function(stack, _, _, _, _, instance)
    print("stack = " , table.concat(stack));
    local temp  = makeName()
    local delta = pop(stack)
    if not delta then
      print("stack is empty and pop is null ptr")
      return;
    end

    -- if tonumber(delta, base) == nil then
    --   delta = 64 * 100;
    -- end
    -- push(stack, 2)
    print("delta=" , delta);

    -- TODO: find a better way to do this
    local extraLogic = ""
    if instance.sectionData[7] then
      for k, v in pairs(instance.sectionData[7]) do
        if v.kind == kinds.Memory then
          -- FIXME: This won't work after wasm MVP, because multiple memories
          extraLogic = ([[
  exportTable.%s = %s
]]):format(k, instance.memories[0])
        end
      end
    end

    return ([[  local %s = ffi.new("uint8_t[" .. (%sSize + %d)*%d .. "]")
  ffi.copy(%s, %s, %sSize*%d)
  %s, %sSize = %s, (%sSize + %d)
]]):format(temp, instance.memories[0], delta, pageSize,
           temp, instance.memories[0], instance.memories[0], pageSize,
           instance.memories[0], instance.memories[0], temp, instance.memories[0], delta) .. extraLogic
  end,

  Return = function(stack, _, _, _, _, instance, fn)
    --debug3
    local fnKind = instance.sectionData[3][fn]
    local sig = instance.sectionData[1][fnKind]

    local results = {}
    for i = 1, #sig.returns do
      push(results, pop(stack))
    end
    return ("  if true then return %s end\n"):format(table.concat(results, ", "))
  end,
  Unreachable = function()
    return "  error(\"Unreachable code reached..\", 2)\n"
  end,
  Nop = function() end
}

do -- Redundant Generators
  local g = generators
  g.I64Const = g.I32Const
  g.F32Const = g.I32Const
  g.F64Const = g.I32Const

  g.I32LtS = g.I32LtU
  g.I32LeS = g.I32LeU
  g.I32GtS = g.I32GtU
  g.I32GeS = g.I32GeU

  g.F64Ne = g.I32Ne
  g.F64Eq = g.I32Eq
  g.F64Ge = g.I32GeU
  g.F64Gt = g.I32GtU
  g.F64Lt = g.I32LtU
  g.F64Le = g.I32LeU

  g.F64Add = g.I32Add
  g.F64Sub = g.I32Sub
  g.F64Mul = g.I32Mul

  g.I32TruncSF32 = g.I32TruncSF64

  g.F64ConvertSI32 = g.Nop
end
local static_link = {
  ["client__print"] = [[print]]
}


function compiler.newInstance(sectionData)
  local t = {}
  t.sectionData = sectionData
  t.source = ""
  t.importTable = {}
  dumps = t.source;
  t.tables = {}
  t.globals = {}
  t.memories = {}
  t.functions = {}
  t.functionImportCount = 0
  local importCount = 0
  if sectionData[2] then
    -- TODO other imports
    t.source = t.source .. "local imports = {"
    for k, v in pairs(sectionData[2]) do
      importCount = importCount + 1
      t.functionImportCount = t.functionImportCount + 1
      local ns_name , method_name = ccm1_cpp_ns_symblos_decode(v.field);
      if (static_link[ns_name .. "__" .. method_name]) then
        t.source = t.source .. ("%s = %s\n,"):format(mangleImport(ns_name, method_name),
          static_link[ns_name .. "__" .. method_name]
        );
      else
        t.source = t.source .. ("%s = 0,"):format(mangleImport(ns_name, method_name))
      end
     
    end
    t.source = t.source .. "}\n" .. prefabs.unlinked
  end

  t.source = t.source .. prefabs.cache
  t.source = t.source .. prefabs.ifTrue
  t.source = t.source .. prefabs.memory

  if sectionData[7] then
    -- Forward declare export section so that we can swap out entries at runtime
    t.source = t.source .. "local exportTable = {}\n"
  end

  if sectionData[5] then
    -- Setup memory
    for k, v in pairs(sectionData[5]) do
      local name = makeName()
      t.source = t.source .. makeMemory(name, v.limits.initial)
      t.memories[k] = name
    end
  end

  if sectionData[6] then
    -- Setup globals
    for k, v in pairs(sectionData[6]) do
      t.globals[k] = makeName()
      t.source = t.source .. ("local %s = %d\n"):format(t.globals[k], v.value)
    end
  end

  if sectionData[9] then
    -- Setup tables TODO:
    for k, v in pairs(sectionData[9]) do
      local name = makeName()
      t.tables[k] = name
      t.source = t.source .. ("local %s = { %s }\n"):format(name, table.concat(v, ", "))
    end
  end

  if sectionData[11] then
    for i = 1, #sectionData[11] do
      local segment = sectionData[11][i]

      t.source = t.source .. constMemoryStore(t.memories[segment.index], segment.addr, segment.data)
    end
  end

  if sectionData[10] then
    local names = {}
    for k, v in pairs(sectionData[10]) do
      names[#names + 1] = makeName()
      t.functions[importCount + k] = {name = names[#names], index = k, info = v}
    end

    if #names > 0 then
      t.source = t.source .. "local " .. table.concat(names, ", ") .. "\n"
    end
  end

  for k, v in pairs(sectionData[10]) do
    -- Generate function body
    local argList = {}

    local fnKind = t.sectionData[3][k]
    local sig = t.sectionData[1][fnKind]
    for i = 1, #sig.params do
      argList[#argList + 1] = makeName()
    end

    local fnName = t.functions[importCount + k].name
    t.source = t.source .. ("function %s(%s)\n"):format(fnName, table.concat(argList, ", "))
    
    --b_function_c
    --每个函数创建的时候清理分之table
    -- Function stack, used only for generation, we can optimize away the stack using inlining
    local valueStack = {}
    local blockStack = {}
    -- Generate function locals
    local fnLocals = {}
    for i = 1, #v.locals do
      fnLocals[i] = makeName()
      t.source = t.source .. ("  local %s = 0\n"):format(fnLocals[i])
    end

    -- Generate opcode instructions agent.zy1
    for i, instr in ipairs(v.instructions) do
      print(i, instr.enum)
      if generators[instr.enum] then
        if(v.brtables) then
          fnLocals [#fnLocals + 1] = 0x81; 
          fnLocals [#fnLocals + 1] = v.brtables; 
        end
        local out = generators[instr.enum](valueStack, instr, argList, fnLocals, blockStack, t, k)
        if out then
          t.source = t.source .. out
        end
      else
        print("Source\n" .. t.source)
        error("No generator for '" .. instr.enum .. "'")
      end
    end

    if #valueStack > 0 then
      -- results
      t.source = t.source .. "  return " .. table.concat(valueStack, ", ") .. "\n"
    end

    t.source = t.source .. "end\n"
  end
  
  local ccm1_cpp_symblos_decode = function (v)
    ---解码 c++符号
    if v == "_main" then
      return "main";
    end
    local magic_tag = string.sub(v, 1,3);
    if magic_tag ~= "__Z" then
      return v;
    end

    local name_size_t = {};
    local look_up = string.sub(v, 4, 4);
    local is_long_name = 0;
    local num_of_name  = 0;

    if (look_up >= '0' and look_up <= '9') then
      name_size_t [1] = tonumber(look_up) ;
      is_long_name = 1;
    end
    local look_up = string.sub(v, 5, 5);
    if (look_up >= '0' and look_up <= '9') then
      is_long_name = 2;
      name_size_t [2] = tonumber(look_up) ;
    end
    if is_long_name == 2 then
      num_of_name = (name_size_t[1] * 10) + name_size_t[2];
    else
      num_of_name = name_size_t[1];
    end
    return string.sub(v, 4 + is_long_name, 4 + is_long_name + num_of_name - 1);
  end
  -- Exports
  if sectionData[7] then
    for k, v in pairs(sectionData[7]) do
      t.source = t.source .. "exportTable."
      if v.kind == kinds.Function then
        t.source = t.source .. ("%s = %s\n"):format(ccm1_cpp_symblos_decode(k), t.functions[v.index].name)
      elseif v.kind == kinds.Memory then
        t.source = t.source .. ("%s = %s\n"):format(k, t.memories[v.index])
      elseif v.kind == kinds.Table then
        t.source = t.source .. ("%s = %s\n"):format(k, t.tables[v.index])
      else
        error("Unsupported export: '" .. v.kind .. "'", 0)
      end
    end
  end

  t.source =  t.source .. [[
if exportTable.main ~= nil then
  print(exportTable.main());
end
exportTable.grow_ip = 0;

exportTable.write_uint8_array = function (buff) 
  local len = table.getn(buff);
  if len < 1 then
    return -1;
  end 
  local i    = exportTable.grow_ip;
  local dist = exportTable.grow_ip + len;
  local d    = 1;
  while i < dist do
    exportTable.memory[i] = buff[ d ];
    i = i + 1;
    d = d + 1;
  end
  exportTable.grow_ip = exportTable.grow_ip + len;
  return exportTable.grow_ip - len, len;
end

exportTable.read_uint8_array = function (i, len) 
  local dist = i + len;
  local tmp  = {}
  while dist > i do
    tmp [#tmp + 1] = exportTable.memory[i];
    i = i+1;
  end
  return tmp;
end

]]
  t.source = t.source .. "return { "

  if sectionData[7] then
    t.source = t.source .. "exports = exportTable, "
  end

  -- Import Linking
  if sectionData[2] then
    t.source = t.source .. "importTable = imports, "
  end

  if sectionData[8] then
    t.source = t.source .. "start = "
      .. ("%s "):format(t.functions[sectionData[8]].name)
  end

  t.source = t.source .. "}\n"
  -----------------debug
  do 
     local handle = io.open("debug.out.lua", "w")
     handle:write(t.source)
     handle:close()
  
     local handle = io.open("debug.out.lua", "r")
     t.source = handle:read("*a")
     handle:close()
  end
  ---------------------
  local success, er = load(t.source)
  if not success then
    error("DID NOT COMPILE: " .. er)
  end

  local chunk = success()
  t.chunk = chunk

  setmetatable(t, {__index = compiler})
  return t
end

function compiler:link(module, field, value)
  if self.chunk.importTable then
    local ref = self.chunk.importTable[mangleImport(module, field)]
    if ref then
      self.chunk.importTable[mangleImport(module, field)] = value
    end
  end
end

return compiler
