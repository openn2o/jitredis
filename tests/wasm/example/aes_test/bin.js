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
var _main=null;
var main=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(tmp2=>
WebAssembly.instantiate(tmp2,
{i:{
		__ZN4ccm127warp_from_uint8ptr_to_valueEPh:__dummy,
		__ZN4ccm118dynamic_string_logEi:__dummy,
	}})
).then(tmp2=>{
	__asm=tmp2.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	_main=__asm._main;
	main=_main;
	main.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(tmp2){
}
