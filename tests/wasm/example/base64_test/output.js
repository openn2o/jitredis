"use strict";/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/var A=Math.imul;var B=Math.fround;var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};function aa(p){var b=null,f='function';if(typeof fetch===f)b=fetch(p).then(r=>r.arrayBuffer());else if(typeof require===f){p=require('path').join(__dirname, p);b=new Promise((y,n)=>{require('fs').readFile(p,(e,d)=>{if(e)n(e);else y(d);});});}else b=new Promise((y,n)=>{y(read(p,'binary'));});return b;}function X(f){a=new Uint8Array(f);b=new Uint16Array(f);c=new Int32Array(f);d=new Float32Array(f);e=new Float64Array(f);}var a=null,b=null,c=null,d=null,e=null,__asm=null,__heap=null;function Y(){throw new Error('this should be unreachable');};var v=null;var _Z10b64_decodePcjS_={};_Z10b64_decodePcjS_.promise=aa('output.wast').then(f=>WebAssembly.instantiate(f,{i:{}}),console.log).then(f=>{__asm=f.instance.exports;__heap=__asm.Z.buffer;X(__heap);v=__asm.v;_Z10b64_decodePcjS_=v;_Z10b64_decodePcjS_.promise=Promise.resolve();__asm.u();},console.log,console.log);