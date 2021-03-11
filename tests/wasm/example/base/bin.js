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
var __Z8djb_hashii=null;
var __Z12murmur_hash2ii=null;
var _main=null;
var djb_hash=__dummy;
var main=__dummy;
var murmur_hash2=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		__ZN4ccm125string_from_value_to_cstrEii:__dummy,
	}})
).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z8djb_hashii=__asm.__Z8djb_hashii;
	__Z12murmur_hash2ii=__asm.__Z12murmur_hash2ii;
	_main=__asm._main;
	djb_hash=__Z8djb_hashii;
	main=_main;
	murmur_hash2=__Z12murmur_hash2ii;
	djb_hash.promise=
	main.promise=
	murmur_hash2.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(tmp0){
}
