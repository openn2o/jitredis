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
function __Z7printlnPKcj(Larg0,Marg0,Larg1){
	var tmp0=null,Lgeptoindexphi2=0,L$plcssa13$pi=0,tmp3=0,L$plcssa$pi=0,tmp5=0,tmp6=null;
	tmp0=String();
	a:if((Larg1|0)!==0){
		L$plcssa13$pi=Larg1;
		Lgeptoindexphi2=0;
		while(1){
			L$plcssa$pi=Larg0[Marg0+Lgeptoindexphi2|0]|0;
			if((L$plcssa$pi&255)!==0){
				while(1){
					tmp5=L$plcssa$pi&255;
					if(L$plcssa$pi<<24<=-16777216)if((L$plcssa$pi&255)<192){
						tmp5=tmp5&63|tmp3<<6;
					}else if((L$plcssa$pi&255)<224){
						tmp5&=31;
					}else if((L$plcssa$pi&255)<240){
						tmp5&=15;
					}else{
						tmp5&=7;
					}
					L$plcssa13$pi=L$plcssa13$pi-1|0;
					Lgeptoindexphi2=Lgeptoindexphi2+1|0;
					if((L$plcssa13$pi|0)!==0){
						L$plcssa$pi=Larg0[Marg0+Lgeptoindexphi2|0]|0;
						if((L$plcssa$pi&192)===128){
							if((L$plcssa$pi&255)===0)break a;
							tmp3=tmp5;
							continue;
						}
						L$plcssa$pi=0;
					}else{
						L$plcssa$pi=1;
						L$plcssa13$pi=0;
					}
					break;
				}
				if(tmp5>>>0<65536){
					tmp3=tmp5;
				}else{
					tmp3=tmp5-65536|0;
					tmp6=String.fromCharCode((tmp3>>>10)+55296|0);
					tmp0=tmp0.concat(tmp6);
					tmp5=(tmp3&1023)+56320|0;
				}
				tmp6=String.fromCharCode(tmp5);
				tmp0=tmp0.concat(tmp6);
				if(!(L$plcssa$pi))continue;
			}
			break;
		}
	}
	Lgeptoindexphi2=Larg1-1|0;
	if((Larg0[Marg0+Lgeptoindexphi2|0]&255)===10){
		tmp6=tmp0.substr(0,Lgeptoindexphi2);
		console.log(tmp6);
		return;
	}
	console.log(tmp0);
}
function _abort(){
	throw new Error("Abort called");
}
function ___wrapper___Z7printlnPKcj(Larg0,Larg1){
	Larg0=Larg0|0;
	Larg1=Larg1|0;
	__Z7printlnPKcj(HEAP8,(Larg0>>0),Larg1);
}
function growLinearMemory(bytes){
	var pages=(bytes+65535)>>16;
	try{
		__asm.memory.grow(pages);
		assignHeaps(__asm.memory.buffer);
		return pages<<16;
	}catch(e){
		return -1;
	}
}
function assignHeaps(tmp0){
	HEAP8=new Uint8Array(tmp0);
	HEAP16=new Uint16Array(tmp0);
	HEAP32=new Int32Array(tmp0);
	HEAPF32=new Float32Array(tmp0);
	HEAPF64=new Float64Array(tmp0);
}
var HEAP8=null,HEAP16=null,HEAP32=null,HEAPF32=null,HEAPF64=null,__asm=null,__heap=null;function __dummy(){throw new Error('this should be unreachable');};
fetchBuffer('output.wasm').then(tmp0=>
WebAssembly.instantiate(tmp0,
{i:{
		_abort:_abort,
		___wrapper___Z7printlnPKcj:___wrapper___Z7printlnPKcj,
		growLinearMemory:growLinearMemory,
	}})
,console.log).then(tmp0=>{
	__asm=tmp0.instance.exports;
	__heap=__asm.memory.buffer;
	assignHeaps(__heap);
	Promise.resolve();
	__asm._main();
},console.log,console.log);
