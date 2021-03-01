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
function assignHeaps(Larg0){
	HEAP8=new Uint8Array(Larg0);
	HEAP16=new Uint16Array(Larg0);
	HEAP32=new Int32Array(Larg0);
	HEAPF32=new Float32Array(Larg0);
	HEAPF64=new Float64Array(Larg0);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z3fibi=null;
var __Z7size_ofd=null;
var _Z3fibi={};
var _Z7size_ofd={};
_Z3fibi.promise=
_Z7size_ofd.promise=
fetchBuffer('output.wast').then(Larg0=>
WebAssembly.instantiate(Larg0,
{i:{
	}})
,console.log).then(Larg0=>{
	__asm=Larg0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z3fibi=__asm.__Z3fibi;
	__Z7size_ofd=__asm.__Z7size_ofd;
	_Z3fibi=__Z3fibi;
	_Z7size_ofd=__Z7size_ofd;
	_Z3fibi.promise=
	_Z7size_ofd.promise=
	Promise.resolve();
	__asm._main();
	
	console.time("t");
	for(var i = 0; i< 100; i++) {
		_Z7size_ofd(100);
	}
	console.timeEnd("t")
},console.log,console.log);
