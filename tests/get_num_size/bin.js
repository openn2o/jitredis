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
var __Z19get_module_version2ii=null;
var get_module_version2=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(tmp1=>
WebAssembly.instantiate(tmp1,
{i:{
		__ZN6client5printEi:print,
	}})
).then(tmp1=>{
	__asm=tmp1.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z19get_module_version2ii=__asm.__Z19get_module_version2ii;
	get_module_version2=__Z19get_module_version2ii;
	get_module_version2.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(tmp1){
}
