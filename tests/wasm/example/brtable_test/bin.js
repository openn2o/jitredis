"use strict";/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/var n=Math.imul;var o=Math.fround;var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};function O(p){var b=null,f='function';if(typeof fetch===f)b=fetch(p).then(r=>r.arrayBuffer());else if(typeof require===f){p=require('path').join(__dirname, p);b=new Promise((y,n)=>{require('fs').readFile(p,(e,d)=>{if(e)n(e);else y(d);});});}else b=new Promise((y,n)=>{y(read(p,'binary'));});return b;}var __asm=null,__heap=null;function L(){throw new Error('this should be unreachable');};var j=null;var i=null;var b64_int=L;var brtable_month_day_p=L;L.promise=O('bin.wasm').then(g=>WebAssembly.instantiate(g,{i:{}})).then(g=>{__asm=g.instance.exports;__heap=__asm.M.buffer;K(__heap);j=__asm.j;i=__asm.i;b64_int=i;brtable_month_day_p=j;b64_int.promise=brtable_month_day_p.promise=Promise.resolve();__asm.k();});function K(g){}