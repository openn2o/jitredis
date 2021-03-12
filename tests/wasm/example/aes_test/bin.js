"use strict";
function checkBounds(arr,offs){if(offs>=arr.length || offs<0) throw new Error('OutOfBounds');}
function checkDefined(m){if(m===undefined) throw new Error('UndefinedMemberAccess');}
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
function checkBoundsAsmJS(addr,align,size){if((addr&align) || addr>=size || addr<0) throw new Error('OutOfBoundsAsmJS: '+addr);}
var __asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
var _main=null;
var main=__dummy;
__dummy.promise=
fetchBuffer('bin.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		__ZN4ccm110string_newEPKc:__dummy,
		__ZN4ccm13logEi:__dummy,
		__ZN4ccm118dynamic_string_newEv:__dummy,
		__ZN4ccm125string_from_cstr_to_valueEPKc:__dummy,
	}})
).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	_main=__asm._main;
	main=_main;
	main.promise=
	Promise.resolve();
	__asm._main();
});
function assignHeaps(tmp0){
}
