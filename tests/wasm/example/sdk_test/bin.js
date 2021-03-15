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
function ___wrapper___ZN4ccm110string_newEPKc(Larg0){
	Larg0=Larg0|0;
	return __ZN4ccm110string_newEPKc()|0|0;
}
function ___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc(Larg0){
	Larg0=Larg0|0;
	return __ZN4ccm125string_from_cstr_to_valueEPKc()|0|0;
}
function assignHeaps(tmp0){
	HEAP8=new Uint8Array(tmp0);
	HEAP16=new Uint16Array(tmp0);
	HEAP32=new Int32Array(tmp0);
	HEAPF32=new Float32Array(tmp0);
	HEAPF64=new Float64Array(tmp0);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var _main=null;
var main={};
main.promise=
fetchBuffer('bin.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		___wrapper___ZN4ccm110string_newEPKc:___wrapper___ZN4ccm110string_newEPKc,
		___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc:___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc,
		__ZN4ccm110string_logEi:__dummy,
		__ZN4ccm118dynamic_string_newEv:__dummy,
		__ZN4ccm121dynamic_string_appendEii:__dummy,
		__ZN4ccm118dynamic_string_logEi:__dummy,
		__ZN4ccm119dynamic_string_joinEi:__dummy,
	}})
,console.log).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	_main=__asm._main;
	main=_main;
	main.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
