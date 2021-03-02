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
function assignHeaps(L$p01){
	HEAP8=new Uint8Array(L$p01);
	HEAP16=new Uint16Array(L$p01);
	HEAP32=new Int32Array(L$p01);
	HEAPF32=new Float32Array(L$p01);
	HEAPF64=new Float64Array(L$p01);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z19get_module_version2Phi=null;
var _Z19get_module_version2Phi={};
_Z19get_module_version2Phi.promise=
fetchBuffer('bin.wasm').then(L$p01=>
WebAssembly.instantiate(L$p01,
{i:{
		__ZN6client7print_nEi:print_n,
	}})
,console.log).then(L$p01=>{
	__asm=L$p01.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z19get_module_version2Phi=__asm.__Z19get_module_version2Phi;
	_Z19get_module_version2Phi=__Z19get_module_version2Phi;
	_Z19get_module_version2Phi.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
