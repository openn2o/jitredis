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
function ___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh(Larg0){
	Larg0=Larg0|0;
	return __ZN4ccm127warp_from_uint8ptr_to_valueEPh()|0|0;
}
function assignHeaps(tmp2){
	HEAP8=new Uint8Array(tmp2);
	HEAP16=new Uint16Array(tmp2);
	HEAP32=new Int32Array(tmp2);
	HEAPF32=new Float32Array(tmp2);
	HEAPF64=new Float64Array(tmp2);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z19ccm1_cheerp_versionv=null;
var __Z20ccm1_cheerp_version2v=null;
var __Z2t1ih=null;
var __Z2t2ih=null;
var _Z19ccm1_cheerp_versionv={};
var _Z20ccm1_cheerp_version2v={};
var _Z2t1ih={};
var _Z2t2ih={};
_Z19ccm1_cheerp_versionv.promise=
_Z20ccm1_cheerp_version2v.promise=
_Z2t1ih.promise=
_Z2t2ih.promise=
fetchBuffer('bin.wasm').then(tmp2=>
WebAssembly.instantiate(tmp2,
{i:{
		___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh:___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh,
		__ZN4ccm110string_logEi:__dummy,
	}})
,console.log).then(tmp2=>{
	__asm=tmp2.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z19ccm1_cheerp_versionv=__asm.__Z19ccm1_cheerp_versionv;
	__Z20ccm1_cheerp_version2v=__asm.__Z20ccm1_cheerp_version2v;
	__Z2t1ih=__asm.__Z2t1ih;
	__Z2t2ih=__asm.__Z2t2ih;
	_Z19ccm1_cheerp_versionv=__Z19ccm1_cheerp_versionv;
	_Z20ccm1_cheerp_version2v=__Z20ccm1_cheerp_version2v;
	_Z2t1ih=__Z2t1ih;
	_Z2t2ih=__Z2t2ih;
	_Z19ccm1_cheerp_versionv.promise=
	_Z20ccm1_cheerp_version2v.promise=
	_Z2t1ih.promise=
	_Z2t2ih.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
