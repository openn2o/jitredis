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
function assignHeaps(tmp1){
	HEAP8=new Uint8Array(tmp1);
	HEAP16=new Uint16Array(tmp1);
	HEAP32=new Int32Array(tmp1);
	HEAPF32=new Float32Array(tmp1);
	HEAPF64=new Float64Array(tmp1);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z19get_module_version2Phi=null;
var __Z3fibi=null;
var _Z19get_module_version2Phi={};
var _Z3fibi={};
_Z19get_module_version2Phi.promise=
_Z3fibi.promise=
fetchBuffer('output.wast').then(tmp1=>
WebAssembly.instantiate(tmp1,
{i:{
		__ZN6client5printEi:print,
	}})
,console.log).then(tmp1=>{
	__asm=tmp1.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z19get_module_version2Phi=__asm.__Z19get_module_version2Phi;
	__Z3fibi=__asm.__Z3fibi;
	_Z19get_module_version2Phi=__Z19get_module_version2Phi;
	_Z3fibi=__Z3fibi;
	_Z19get_module_version2Phi.promise=
	_Z3fibi.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
