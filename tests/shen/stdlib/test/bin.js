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
var __Z5test1Pi=null;
var __Z5test2Pi=null;
var __Z5test3Pi=null;
var _Z5test1Pi={};
var _Z5test2Pi={};
var _Z5test3Pi={};
_Z5test1Pi.promise=
_Z5test2Pi.promise=
_Z5test3Pi.promise=
fetchBuffer('bin.wasm').then(tmp1=>
WebAssembly.instantiate(tmp1,
{i:{
	}})
,console.log).then(tmp1=>{
	__asm=tmp1.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z5test1Pi=__asm.__Z5test1Pi;
	__Z5test2Pi=__asm.__Z5test2Pi;
	__Z5test3Pi=__asm.__Z5test3Pi;
	_Z5test1Pi=__Z5test1Pi;
	_Z5test2Pi=__Z5test2Pi;
	_Z5test3Pi=__Z5test3Pi;
	_Z5test1Pi.promise=
	_Z5test2Pi.promise=
	_Z5test3Pi.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
