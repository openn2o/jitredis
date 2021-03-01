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
function assignHeaps(tmp0){
	HEAP8=new Uint8Array(tmp0);
	HEAP16=new Uint16Array(tmp0);
	HEAP32=new Int32Array(tmp0);
	HEAPF32=new Float32Array(tmp0);
	HEAPF64=new Float64Array(tmp0);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z7DJBHashPcii=null;
var __Z5hash2Pcii=null;
var _Z7DJBHashPcii={};
var _Z5hash2Pcii={};
_Z7DJBHashPcii.promise=
_Z5hash2Pcii.promise=
fetchBuffer('output.wast').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
	}})
,console.log).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z7DJBHashPcii=__asm.__Z7DJBHashPcii;
	__Z5hash2Pcii=__asm.__Z5hash2Pcii;
	_Z7DJBHashPcii=__Z7DJBHashPcii;
	_Z5hash2Pcii=__Z5hash2Pcii;
	_Z7DJBHashPcii.promise=
	_Z5hash2Pcii.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
