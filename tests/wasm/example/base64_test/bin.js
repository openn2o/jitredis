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
function assignHeaps(tmp2){
	HEAP8=new Uint8Array(tmp2);
	HEAP16=new Uint16Array(tmp2);
	HEAP32=new Int32Array(tmp2);
	HEAPF32=new Float32Array(tmp2);
	HEAPF64=new Float64Array(tmp2);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z10b64_decodePcjS_=null;
var _Z10b64_decodePcjS_={};
_Z10b64_decodePcjS_.promise=
fetchBuffer('bin.wasm').then(tmp2=>
WebAssembly.instantiate(tmp2,
{i:{
	}})
,console.log).then(tmp2=>{
	__asm=tmp2.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z10b64_decodePcjS_=__asm.__Z10b64_decodePcjS_;
	_Z10b64_decodePcjS_=__Z10b64_decodePcjS_;
	_Z10b64_decodePcjS_.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
