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
function ___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc(Larg0){
	Larg0=Larg0|0;
	return __ZN4ccm125string_from_cstr_to_valueEPKc()|0|0;
}
function ___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh(Larg0){
	Larg0=Larg0|0;
	return __ZN4ccm127warp_from_uint8ptr_to_valueEPh()|0|0;
}
function assignHeaps(tmp0){
	HEAP8=new Uint8Array(tmp0);
	HEAP16=new Uint16Array(tmp0);
	HEAP32=new Int32Array(tmp0);
	HEAPF32=new Float32Array(tmp0);
	HEAPF64=new Float64Array(tmp0);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var __Z9test_max1ii=null;
var __Z9test_max2ii=null;
var __Z9test_max3ii=null;
var __Z9test_max4ii=null;
var __Z3fabi=null;
var __Z13base64_encodeiii=null;
var __Z13base64_decodeiii=null;
var _Z9test_max1ii={};
var _Z9test_max2ii={};
var _Z9test_max3ii={};
var _Z9test_max4ii={};
var _Z3fabi={};
var _Z13base64_encodeiii={};
var _Z13base64_decodeiii={};
_Z9test_max1ii.promise=
_Z9test_max2ii.promise=
_Z9test_max3ii.promise=
_Z9test_max4ii.promise=
_Z3fabi.promise=
_Z13base64_encodeiii.promise=
_Z13base64_decodeiii.promise=
fetchBuffer('bin.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc:___wrapper___ZN4ccm125string_from_cstr_to_valueEPKc,
		___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh:___wrapper___ZN4ccm127warp_from_uint8ptr_to_valueEPh,
		__ZN4ccm110string_logEi:__dummy,
		__ZN4ccm127warp_from_value_to_uint8ptrEi:__dummy,
	}})
,console.log).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z9test_max1ii=__asm.__Z9test_max1ii;
	__Z9test_max2ii=__asm.__Z9test_max2ii;
	__Z9test_max3ii=__asm.__Z9test_max3ii;
	__Z9test_max4ii=__asm.__Z9test_max4ii;
	__Z3fabi=__asm.__Z3fabi;
	__Z13base64_encodeiii=__asm.__Z13base64_encodeiii;
	__Z13base64_decodeiii=__asm.__Z13base64_decodeiii;
	_Z9test_max1ii=__Z9test_max1ii;
	_Z9test_max2ii=__Z9test_max2ii;
	_Z9test_max3ii=__Z9test_max3ii;
	_Z9test_max4ii=__Z9test_max4ii;
	_Z3fabi=__Z3fabi;
	_Z13base64_encodeiii=__Z13base64_encodeiii;
	_Z13base64_decodeiii=__Z13base64_decodeiii;
	_Z9test_max1ii.promise=
	_Z9test_max2ii.promise=
	_Z9test_max3ii.promise=
	_Z9test_max4ii.promise=
	_Z3fabi.promise=
	_Z13base64_encodeiii.promise=
	_Z13base64_decodeiii.promise=
	Promise.resolve();
	__asm._main();
},console.log,console.log);
