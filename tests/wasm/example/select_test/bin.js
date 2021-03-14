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
var __Z9test_max1ii=null;
var __Z9test_max2ii=null;
var __Z9test_max3ii=null;
var __Z9test_max4ii=null;
var test_max1=__dummy;
var test_max2=__dummy;
var test_max3=__dummy;
var test_max4=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(Larg0=>
WebAssembly.instantiate(Larg0,
{i:{
	}})
).then(Larg0=>{
	__asm=Larg0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	__Z9test_max1ii=__asm.__Z9test_max1ii;
	__Z9test_max2ii=__asm.__Z9test_max2ii;
	__Z9test_max3ii=__asm.__Z9test_max3ii;
	__Z9test_max4ii=__asm.__Z9test_max4ii;
	test_max1=__Z9test_max1ii;
	test_max2=__Z9test_max2ii;
	test_max3=__Z9test_max3ii;
	test_max4=__Z9test_max4ii;
	test_max1.promise=
	test_max2.promise=
	test_max3.promise=
	test_max4.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(Larg0){
}
