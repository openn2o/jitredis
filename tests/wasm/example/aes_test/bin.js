"use strict";
/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/
var __imul=Math.imul;
var __fround=Math.fround;
var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};
function fetchBuffer(p){
	var b=null,f='function';
	if(typeof fetch===f)b=fetch(p).then(r=>r.arrayBuffer());
	else if(typeof require===f){
		p=require('path').join(__dirname, p);
		b=new Promise((y,n)=>{
			require('fs').readFile(p,(e,d)=>{
				if(e)n(e);
				else y(d);
			});
		});
	}else b=new Promise((y,n)=>{
		y(read(p,'binary'));
	});
	return b;
}
var __asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z11TA_HexToStriii=null;
var _main=null;
var TA_HexToStr=__dummy;
var main=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		__ZN4ccm110string_newEPKc:__dummy,
		__ZN4ccm110string_logEi:__dummy,
		__ZN4ccm118dynamic_string_newEv:__dummy,
		__ZN4ccm125string_from_cstr_to_valueEPKc:__dummy,
		__ZN4ccm121dynamic_string_appendEii:__dummy,
		__ZN4ccm118dynamic_string_logEi:__dummy,
		__ZN4ccm119dynamic_string_joinEi:__dummy,
		__ZN4ccm127warp_from_uint8ptr_to_valueEPh:__dummy,
		__ZN4ccm127warp_from_value_to_uint8ptrEi:__dummy,
	}})
).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z11TA_HexToStriii=__asm.__Z11TA_HexToStriii;
	_main=__asm._main;
	TA_HexToStr=__Z11TA_HexToStriii;
	main=_main;
	TA_HexToStr.promise=
	main.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(tmp0){
}
