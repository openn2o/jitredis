0000000: 0061 736d                                 ; WASM_BINARY_MAGIC
0000004: 0100 0000                                 ; WASM_BINARY_VERSION
; section "Type" (1)
0000008: 01                                        ; section code
0000009: 00                                        ; section size (guess)
000000a: 04                                        ; num types
; func type 0
000000b: 60                                        ; func
000000c: 01                                        ; num params
000000d: 7f                                        ; i32
000000e: 01                                        ; num results
000000f: 7f                                        ; i32
; func type 1
0000010: 60                                        ; func
0000011: 00                                        ; num params
0000012: 00                                        ; num results
; func type 2
0000013: 60                                        ; func
0000014: 00                                        ; num params
0000015: 01                                        ; num results
0000016: 7f                                        ; i32
; func type 3
0000017: 60                                        ; func
0000018: 03                                        ; num params
0000019: 7f                                        ; i32
000001a: 7f                                        ; i32
000001b: 7f                                        ; i32
000001c: 01                                        ; num results
000001d: 7f                                        ; i32
0000009: 14                                        ; FIXUP section size
; section "Import" (2)
000001e: 02                                        ; section code
000001f: 00                                        ; section size (guess)
0000020: 02                                        ; num imports
; import header 0
0000021: 01                                        ; string length
0000022: 69                                       i  ; import module name
0000023: 28                                        ; string length
0000024: 5f5f 5a4e 3463 636d 3132 3777 6172 705f  __ZN4ccm127warp_
0000034: 6672 6f6d 5f76 616c 7565 5f74 6f5f 7569  from_value_to_ui
0000044: 6e74 3870 7472 4569                      nt8ptrEi  ; import field name
000004c: 00                                        ; import kind
000004d: 00                                        ; import signature index
; import header 1
000004e: 01                                        ; string length
000004f: 69                                       i  ; import module name
0000050: 34                                        ; string length
0000051: 5f5f 5f77 7261 7070 6572 5f5f 5f5a 4e34  ___wrapper___ZN4
0000061: 6363 6d31 3237 7761 7270 5f66 726f 6d5f  ccm127warp_from_
0000071: 7569 6e74 3870 7472 5f74 6f5f 7661 6c75  uint8ptr_to_valu
0000081: 6545 5068                                eEPh  ; import field name
0000085: 00                                        ; import kind
0000086: 00                                        ; import signature index
000001f: 67                                        ; FIXUP section size
; section "Function" (3)
0000087: 03                                        ; section code
0000088: 00                                        ; section size (guess)
0000089: 03                                        ; num functions
000008a: 01                                        ; function 0 signature index
000008b: 02                                        ; function 1 signature index
000008c: 03                                        ; function 2 signature index
0000088: 04                                        ; FIXUP section size
; section "Table" (4)
000008d: 04                                        ; section code
000008e: 00                                        ; section size (guess)
000008f: 01                                        ; num tables
; table 0
0000090: 70                                        ; funcref
0000091: 00                                        ; limits: flags
0000092: 01                                        ; limits: initial
000008e: 04                                        ; FIXUP section size
; section "Memory" (5)
0000093: 05                                        ; section code
0000094: 00                                        ; section size (guess)
0000095: 01                                        ; num memories
; memory 0
0000096: 01                                        ; limits: flags
0000097: 20                                        ; limits: initial
0000098: 20                                        ; limits: max
0000094: 04                                        ; FIXUP section size
; section "Global" (6)
0000099: 06                                        ; section code
000009a: 00                                        ; section size (guess)
000009b: 01                                        ; num globals
000009c: 7f                                        ; i32
000009d: 01                                        ; global mutability
000009e: 41                                        ; i32.const
000009f: 8080 c000                                 ; i32 literal
00000a3: 0b                                        ; end
000009a: 09                                        ; FIXUP section size
; section "Export" (7)
00000a4: 07                                        ; section code
00000a5: 00                                        ; section size (guess)
00000a6: 03                                        ; num exports
00000a7: 06                                        ; string length
00000a8: 6d65 6d6f 7279                           memory  ; export name
00000ae: 02                                        ; export kind
00000af: 00                                        ; export memory index
00000b0: 05                                        ; string length
00000b1: 5f6d 6169 6e                             _main  ; export name
00000b6: 00                                        ; export kind
00000b7: 03                                        ; export func index
00000b8: 15                                        ; string length
00000b9: 5f5f 5a31 3362 6173 6536 345f 656e 636f  __Z13base64_enco
00000c9: 6465 6969 69                             deiii  ; export name
00000ce: 00                                        ; export kind
00000cf: 04                                        ; export func index
00000a5: 2a                                        ; FIXUP section size
; section "Elem" (9)
00000d0: 09                                        ; section code
00000d1: 00                                        ; section size (guess)
00000d2: 01                                        ; num elem segments
; elem segment header 0
00000d3: 00                                        ; segment flags
00000d4: 41                                        ; i32.const
00000d5: 00                                        ; i32 literal
00000d6: 0b                                        ; end
00000d7: 01                                        ; num elems
00000d8: 02                                        ; elem function index
00000d1: 07                                        ; FIXUP section size
; section "Code" (10)
00000d9: 0a                                        ; section code
00000da: 00                                        ; section size (guess)
00000db: 03                                        ; num functions
; function body 0
00000dc: 00                                        ; func body size (guess)
00000dd: 00                                        ; local decl count
00000de: 00                                        ; unreachable
00000df: 0b                                        ; end
00000dc: 03                                        ; FIXUP func body size
; function body 1
00000e0: 00                                        ; func body size (guess)
00000e1: 00                                        ; local decl count
00000e2: 41                                        ; i32.const
00000e3: 00                                        ; i32 literal
00000e4: 0b                                        ; end
00000e0: 04                                        ; FIXUP func body size
; function body 2
00000e5: 00                                        ; func body size (guess)
00000e6: 01                                        ; local decl count
00000e7: 07                                        ; local type count
00000e8: 7f                                        ; i32
00000e9: 20                                        ; local.get
00000ea: 00                                        ; local index
00000eb: 10                                        ; call
00000ec: 00                                        ; function index
00000ed: 21                                        ; local.set
00000ee: 03                                        ; local index
00000ef: 20                                        ; local.get
00000f0: 01                                        ; local index
00000f1: 10                                        ; call
00000f2: 00                                        ; function index
00000f3: 21                                        ; local.set
00000f4: 04                                        ; local index
00000f5: 20                                        ; local.get
00000f6: 02                                        ; local index
00000f7: 45                                        ; i32.eqz
00000f8: 04                                        ; if
00000f9: 40                                        ; void
00000fa: 20                                        ; local.get
00000fb: 04                                        ; local index
00000fc: 41                                        ; i32.const
00000fd: 00                                        ; i32 literal
00000fe: 3a                                        ; i32.store8
00000ff: 00                                        ; alignment
0000100: 00                                        ; store offset
0000101: 20                                        ; local.get
0000102: 04                                        ; local index
0000103: 10                                        ; call
0000104: 01                                        ; function index
0000105: 0f                                        ; return
0000106: 0b                                        ; end
0000107: 41                                        ; i32.const
0000108: 00                                        ; i32 literal
0000109: 22                                        ; local.tee
000010a: 05                                        ; local index
000010b: 22                                        ; local.tee
000010c: 06                                        ; local index
000010d: 22                                        ; local.tee
000010e: 07                                        ; local index
000010f: 21                                        ; local.set
0000110: 08                                        ; local index
0000111: 03                                        ; loop
0000112: 40                                        ; void
0000113: 20                                        ; local.get
0000114: 07                                        ; local index
0000115: 20                                        ; local.get
0000116: 03                                        ; local index
0000117: 6a                                        ; i32.add
0000118: 2d                                        ; i32.load8_u
0000119: 00                                        ; alignment
000011a: 00                                        ; load offset
000011b: 21                                        ; local.set
000011c: 09                                        ; local index
000011d: 02                                        ; block
000011e: 40                                        ; void
000011f: 02                                        ; block
0000120: 40                                        ; void
0000121: 02                                        ; block
0000122: 40                                        ; void
0000123: 02                                        ; block
0000124: 40                                        ; void
0000125: 02                                        ; block
0000126: 40                                        ; void
0000127: 20                                        ; local.get
0000128: 08                                        ; local index
0000129: 0e                                        ; br_table
000012a: 03                                        ; num targets
000012b: 00                                        ; break depth
000012c: 01                                        ; break depth
000012d: 02                                        ; break depth
000012e: 03                                        ; break depth for default
000012f: 0b                                        ; end
0000130: 20                                        ; local.get
0000131: 06                                        ; local index
0000132: 20                                        ; local.get
0000133: 04                                        ; local index
0000134: 6a                                        ; i32.add
0000135: 20                                        ; local.get
0000136: 09                                        ; local index
0000137: 22                                        ; local.tee
0000138: 09                                        ; local index
0000139: 41                                        ; i32.const
000013a: 02                                        ; i32 literal
000013b: 76                                        ; i32.shr_u
000013c: 2d                                        ; i32.load8_u
000013d: 00                                        ; alignment
000013e: 8880 40                                   ; load offset
0000141: 3a                                        ; i32.store8
0000142: 00                                        ; alignment
0000143: 00                                        ; store offset
0000144: 20                                        ; local.get
0000145: 06                                        ; local index
0000146: 41                                        ; i32.const
0000147: 01                                        ; i32 literal
0000148: 6a                                        ; i32.add
0000149: 21                                        ; local.set
000014a: 06                                        ; local index
000014b: 41                                        ; i32.const
000014c: 01                                        ; i32 literal
000014d: 21                                        ; local.set
000014e: 08                                        ; local index
000014f: 0c                                        ; br
0000150: 03                                        ; break depth
0000151: 0b                                        ; end
0000152: 20                                        ; local.get
0000153: 06                                        ; local index
0000154: 20                                        ; local.get
0000155: 04                                        ; local index
0000156: 6a                                        ; i32.add
0000157: 20                                        ; local.get
0000158: 09                                        ; local index
0000159: 22                                        ; local.tee
000015a: 09                                        ; local index
000015b: 41                                        ; i32.const
000015c: 04                                        ; i32 literal
000015d: 76                                        ; i32.shr_u
000015e: 20                                        ; local.get
000015f: 05                                        ; local index
0000160: 41                                        ; i32.const
0000161: 04                                        ; i32 literal
0000162: 74                                        ; i32.shl
0000163: 41                                        ; i32.const
0000164: 30                                        ; i32 literal
0000165: 71                                        ; i32.and
0000166: 72                                        ; i32.or
0000167: 2d                                        ; i32.load8_u
0000168: 00                                        ; alignment
0000169: 8880 40                                   ; load offset
000016c: 3a                                        ; i32.store8
000016d: 00                                        ; alignment
000016e: 00                                        ; store offset
000016f: 20                                        ; local.get
0000170: 06                                        ; local index
0000171: 41                                        ; i32.const
0000172: 01                                        ; i32 literal
0000173: 6a                                        ; i32.add
0000174: 21                                        ; local.set
0000175: 06                                        ; local index
0000176: 41                                        ; i32.const
0000177: 02                                        ; i32 literal
0000178: 21                                        ; local.set
0000179: 08                                        ; local index
000017a: 0c                                        ; br
000017b: 02                                        ; break depth
000017c: 0b                                        ; end
000017d: 20                                        ; local.get
000017e: 06                                        ; local index
000017f: 20                                        ; local.get
0000180: 04                                        ; local index
0000181: 6a                                        ; i32.add
0000182: 20                                        ; local.get
0000183: 09                                        ; local index
0000184: 22                                        ; local.tee
0000185: 09                                        ; local index
0000186: 41                                        ; i32.const
0000187: 06                                        ; i32 literal
0000188: 76                                        ; i32.shr_u
0000189: 20                                        ; local.get
000018a: 05                                        ; local index
000018b: 41                                        ; i32.const
000018c: 02                                        ; i32 literal
000018d: 74                                        ; i32.shl
000018e: 41                                        ; i32.const
000018f: 3c                                        ; i32 literal
0000190: 71                                        ; i32.and
0000191: 72                                        ; i32.or
0000192: 2d                                        ; i32.load8_u
0000193: 00                                        ; alignment
0000194: 8880 40                                   ; load offset
0000197: 3a                                        ; i32.store8
0000198: 00                                        ; alignment
0000199: 00                                        ; store offset
000019a: 20                                        ; local.get
000019b: 06                                        ; local index
000019c: 20                                        ; local.get
000019d: 04                                        ; local index
000019e: 6a                                        ; i32.add
000019f: 20                                        ; local.get
00001a0: 09                                        ; local index
00001a1: 41                                        ; i32.const
00001a2: 3f                                        ; i32 literal
00001a3: 71                                        ; i32.and
00001a4: 2d                                        ; i32.load8_u
00001a5: 00                                        ; alignment
00001a6: 8880 40                                   ; load offset
00001a9: 3a                                        ; i32.store8
00001aa: 00                                        ; alignment
00001ab: 01                                        ; store offset
00001ac: 20                                        ; local.get
00001ad: 06                                        ; local index
00001ae: 41                                        ; i32.const
00001af: 02                                        ; i32 literal
00001b0: 6a                                        ; i32.add
00001b1: 21                                        ; local.set
00001b2: 06                                        ; local index
00001b3: 41                                        ; i32.const
00001b4: 00                                        ; i32 literal
00001b5: 21                                        ; local.set
00001b6: 08                                        ; local index
00001b7: 0c                                        ; br
00001b8: 01                                        ; break depth
00001b9: 0b                                        ; end
00001ba: 20                                        ; local.get
00001bb: 09                                        ; local index
00001bc: 21                                        ; local.set
00001bd: 09                                        ; local index
00001be: 0b                                        ; end
00001bf: 20                                        ; local.get
00001c0: 07                                        ; local index
00001c1: 41                                        ; i32.const
00001c2: 01                                        ; i32 literal
00001c3: 6a                                        ; i32.add
00001c4: 22                                        ; local.tee
00001c5: 07                                        ; local index
00001c6: 20                                        ; local.get
00001c7: 02                                        ; local index
00001c8: 46                                        ; i32.eq
00001c9: 04                                        ; if
00001ca: 40                                        ; void
00001cb: 20                                        ; local.get
00001cc: 06                                        ; local index
00001cd: 20                                        ; local.get
00001ce: 04                                        ; local index
00001cf: 6a                                        ; i32.add
00001d0: 22                                        ; local.tee
00001d1: 07                                        ; local index
00001d2: 02                                        ; block
00001d3: 40                                        ; void
00001d4: 02                                        ; block
00001d5: 40                                        ; void
00001d6: 02                                        ; block
00001d7: 40                                        ; void
00001d8: 20                                        ; local.get
00001d9: 08                                        ; local index
00001da: 41                                        ; i32.const
00001db: 01                                        ; i32 literal
00001dc: 6b                                        ; i32.sub
00001dd: 0e                                        ; br_table
00001de: 02                                        ; num targets
00001df: 00                                        ; break depth
00001e0: 01                                        ; break depth
00001e1: 02                                        ; break depth for default
00001e2: 0b                                        ; end
00001e3: 20                                        ; local.get
00001e4: 07                                        ; local index
00001e5: 20                                        ; local.get
00001e6: 09                                        ; local index
00001e7: 41                                        ; i32.const
00001e8: 04                                        ; i32 literal
00001e9: 74                                        ; i32.shl
00001ea: 41                                        ; i32.const
00001eb: 30                                        ; i32 literal
00001ec: 71                                        ; i32.and
00001ed: 2d                                        ; i32.load8_u
00001ee: 00                                        ; alignment
00001ef: 8880 40                                   ; load offset
00001f2: 3a                                        ; i32.store8
00001f3: 00                                        ; alignment
00001f4: 00                                        ; store offset
00001f5: 20                                        ; local.get
00001f6: 06                                        ; local index
00001f7: 20                                        ; local.get
00001f8: 04                                        ; local index
00001f9: 6a                                        ; i32.add
00001fa: 41                                        ; i32.const
00001fb: 3d                                        ; i32 literal
00001fc: 3a                                        ; i32.store8
00001fd: 00                                        ; alignment
00001fe: 01                                        ; store offset
00001ff: 20                                        ; local.get
0000200: 06                                        ; local index
0000201: 20                                        ; local.get
0000202: 04                                        ; local index
0000203: 6a                                        ; i32.add
0000204: 41                                        ; i32.const
0000205: 3d                                        ; i32 literal
0000206: 3a                                        ; i32.store8
0000207: 00                                        ; alignment
0000208: 02                                        ; store offset
0000209: 20                                        ; local.get
000020a: 06                                        ; local index
000020b: 20                                        ; local.get
000020c: 04                                        ; local index
000020d: 6a                                        ; i32.add
000020e: 41                                        ; i32.const
000020f: 00                                        ; i32 literal
0000210: 3a                                        ; i32.store8
0000211: 00                                        ; alignment
0000212: 03                                        ; store offset
0000213: 20                                        ; local.get
0000214: 04                                        ; local index
0000215: 10                                        ; call
0000216: 01                                        ; function index
0000217: 0f                                        ; return
0000218: 0b                                        ; end
0000219: 20                                        ; local.get
000021a: 07                                        ; local index
000021b: 20                                        ; local.get
000021c: 09                                        ; local index
000021d: 41                                        ; i32.const
000021e: 02                                        ; i32 literal
000021f: 74                                        ; i32.shl
0000220: 41                                        ; i32.const
0000221: 3c                                        ; i32 literal
0000222: 71                                        ; i32.and
0000223: 2d                                        ; i32.load8_u
0000224: 00                                        ; alignment
0000225: 8880 40                                   ; load offset
0000228: 3a                                        ; i32.store8
0000229: 00                                        ; alignment
000022a: 00                                        ; store offset
000022b: 20                                        ; local.get
000022c: 06                                        ; local index
000022d: 20                                        ; local.get
000022e: 04                                        ; local index
000022f: 6a                                        ; i32.add
0000230: 41                                        ; i32.const
0000231: 3d                                        ; i32 literal
0000232: 3a                                        ; i32.store8
0000233: 00                                        ; alignment
0000234: 01                                        ; store offset
0000235: 20                                        ; local.get
0000236: 06                                        ; local index
0000237: 20                                        ; local.get
0000238: 04                                        ; local index
0000239: 6a                                        ; i32.add
000023a: 41                                        ; i32.const
000023b: 00                                        ; i32 literal
000023c: 3a                                        ; i32.store8
000023d: 00                                        ; alignment
000023e: 02                                        ; store offset
000023f: 20                                        ; local.get
0000240: 04                                        ; local index
0000241: 10                                        ; call
0000242: 01                                        ; function index
0000243: 0f                                        ; return
0000244: 0b                                        ; end
0000245: 41                                        ; i32.const
0000246: 00                                        ; i32 literal
0000247: 3a                                        ; i32.store8
0000248: 00                                        ; alignment
0000249: 00                                        ; store offset
000024a: 20                                        ; local.get
000024b: 04                                        ; local index
000024c: 10                                        ; call
000024d: 01                                        ; function index
000024e: 0f                                        ; return
000024f: 0b                                        ; end
0000250: 20                                        ; local.get
0000251: 09                                        ; local index
0000252: 21                                        ; local.set
0000253: 05                                        ; local index
0000254: 0c                                        ; br
0000255: 00                                        ; break depth
0000256: 0b                                        ; end
0000257: 41                                        ; i32.const
0000258: 00                                        ; i32 literal
0000259: 0b                                        ; end
; move data: [e6, 25a) -> [e7, 25b)
00000e5: f402                                      ; FIXUP func body size
; move data: [db, 25b) -> [dc, 25c)
00000da: 8003                                      ; FIXUP section size
; section "Data" (11)
000025c: 0b                                        ; section code
000025d: 00                                        ; section size (guess)
000025e: 01                                        ; num data segments
; data segment header 0
000025f: 00                                        ; segment flags
0000260: 41                                        ; i32.const
0000261: 8880 c000                                 ; i32 literal
0000265: 0b                                        ; end
0000266: 40                                        ; data segment size
; data segment data 0
0000267: 4142 4344 4546 4748 494a 4b4c 4d4e 4f50 
0000277: 5152 5354 5556 5758 595a 6162 6364 6566 
0000287: 6768 696a 6b6c 6d6e 6f70 7172 7374 7576 
0000297: 7778 797a 3031 3233 3435 3637 3839 2b2f   ; data segment data
000025d: 49                                        ; FIXUP section size
; section "name"
00002a7: 00                                        ; section code
00002a8: 00                                        ; section size (guess)
00002a9: 04                                        ; string length
00002aa: 6e61 6d65                                name  ; custom section name
00002ae: 02                                        ; local name type
00002af: 00                                        ; subsection size (guess)
00002b0: 05                                        ; num functions
00002b1: 00                                        ; function index
00002b2: 01                                        ; num locals
00002b3: 00                                        ; local index
00002b4: 00                                        ; string length
00002b5: 01                                        ; function index
00002b6: 01                                        ; num locals
00002b7: 00                                        ; local index
00002b8: 00                                        ; string length
00002b9: 02                                        ; function index
00002ba: 00                                        ; num locals
00002bb: 03                                        ; function index
00002bc: 00                                        ; num locals
00002bd: 04                                        ; function index
00002be: 0a                                        ; num locals
00002bf: 00                                        ; local index
00002c0: 00                                        ; string length
00002c1: 01                                        ; local index
00002c2: 00                                        ; string length
00002c3: 02                                        ; local index
00002c4: 00                                        ; string length
00002c5: 03                                        ; local index
00002c6: 00                                        ; string length
00002c7: 04                                        ; local index
00002c8: 00                                        ; string length
00002c9: 05                                        ; local index
00002ca: 00                                        ; string length
00002cb: 06                                        ; local index
00002cc: 00                                        ; string length
00002cd: 07                                        ; local index
00002ce: 00                                        ; string length
00002cf: 08                                        ; local index
00002d0: 00                                        ; string length
00002d1: 09                                        ; local index
00002d2: 00                                        ; string length
00002af: 23                                        ; FIXUP subsection size
00002a8: 2a                                        ; FIXUP section size