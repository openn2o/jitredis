"use strict";/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/var q=Math.imul;var r=Math.fround;var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};function R(p){var b=null,f='function';if(typeof fetch===f)b=fetch(p).then(r=>r.arrayBuffer());else if(typeof require===f){p=require('path').join(__dirname, p);b=new Promise((y,n)=>{require('fs').readFile(p,(e,d)=>{if(e)n(e);else y(d);});});}else b=new Promise((y,n)=>{y(read(p,'binary'));});return b;}function N(f){a=new Uint8Array(f);b=new Uint16Array(f);c=new Int32Array(f);d=new Float32Array(f);e=new Float64Array(f);}var a=null,b=null,c=null,d=null,e=null,__asm=null,__heap=null;function O(){throw new Error('this should be unreachable');};var o=null;var m=null;var n=null;var i=null;var _Z19brtable_month_day_pi={};var _Z20brtable_month_day_p2i={};var _Z7b64_inti={};var _Z3fabi={};_Z19brtable_month_day_pi.promise=_Z20brtable_month_day_p2i.promise=_Z7b64_inti.promise=_Z3fabi.promise=R('bin.wasm').then(f=>WebAssembly.instantiate(f,{i:{}}),console.log).then(f=>{__asm=f.instance.exports;__heap=__asm.P.buffer;N(__heap);o=__asm.o;m=__asm.m;n=__asm.n;i=__asm.i;_Z19brtable_month_day_pi=o;_Z20brtable_month_day_p2i=m;_Z7b64_inti=n;_Z3fabi=i;_Z19brtable_month_day_pi.promise=_Z20brtable_month_day_p2i.promise=_Z7b64_inti.promise=_Z3fabi.promise=Promise.resolve();__asm.l();},console.log,console.log);