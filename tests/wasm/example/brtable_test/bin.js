"use strict";/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/var o=Math.imul;var p=Math.fround;var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};function P(p){var b=null,f='function';if(typeof fetch===f)b=fetch(p).then(r=>r.arrayBuffer());else if(typeof require===f){p=require('path').join(__dirname, p);b=new Promise((y,n)=>{require('fs').readFile(p,(e,d)=>{if(e)n(e);else y(d);});});}else b=new Promise((y,n)=>{y(read(p,'binary'));});return b;}function L(f){a=new Uint8Array(f);b=new Uint16Array(f);c=new Int32Array(f);d=new Float32Array(f);e=new Float64Array(f);}var a=null,b=null,c=null,d=null,e=null,__asm=null,__heap=null;function M(){throw new Error('this should be unreachable');};var m=null;var i=null;var _Z19brtable_month_day_pi={};var _Z3fabi={};_Z19brtable_month_day_pi.promise=_Z3fabi.promise=P('bin.wasm').then(f=>WebAssembly.instantiate(f,{i:{}}),console.log).then(f=>{__asm=f.instance.exports;__heap=__asm.N.buffer;L(__heap);m=__asm.m;i=__asm.i;_Z19brtable_month_day_pi=m;_Z3fabi=i;_Z19brtable_month_day_pi.promise=_Z3fabi.promise=Promise.resolve();__asm.l();},console.log,console.log);