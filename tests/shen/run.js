'use strict';
const fs = require('fs');

function toArrayBuffer(buf) {
  var ab = new ArrayBuffer(buf.length);
  var view = new Uint8Array(ab);
  for (var i = 0; i < buf.length; ++i) {
    view[i] = buf[i];
  }
  return ab;
}




var memory = null;


const buf = fs.readFileSync('build/out.wasm');


var importObject = {
	console:{
		log:function (i) {
			console.log("[info]", i);
		},
		log2:function (base, size) {
			var decoder = new TextDecoder("utf8");
			if(memory) {
				var buff = memory.subarray(base, base + size );
				console.log("[info]", decoder.decode(buff));
			}
			console.log("call " , base , size);
		},
		add:console.log
    } ,
};

function hex_print (buff, prefix) {
		var tmp = [];
		var len = buff.length;
		var chr = '';
		for(var i = 0; i< len; i++) {
			chr= buff[i].toString();	
			if(chr.length < 2) {
				chr = "0" + chr;
			}
			
			if(i == 0) {
				chr = " " + chr;
			}
			if(i != 0 && i % 16 == 0) {
				tmp.push("----" + i);
				tmp.push("\n");
			}
			tmp.push(chr.toUpperCase());
		}
		if(prefix) {
			console.log(prefix + "\n", tmp.join(" "));
		} else {
			console.log(tmp.join(" "));
		}
}



WebAssembly.instantiate(toArrayBuffer(buf), importObject).then(function (obj) 
	{
		 console.time("t");
		 if(obj.instance.exports.main != null) {
			 //console.log("find main entry point");
			 memory = new Uint8Array(obj.instance.exports.mem.buffer);
				
				
			 obj.instance.exports.main();
			
			 if(obj.instance.exports.mem != null) {
				hex_print( new Uint8Array(obj.instance.exports.mem.buffer, 0, 100) );
				//console.log("\n\nmem\n",  new Uint8Array(obj.instance.exports.mem.buffer, 0, 100));
			 }
		 }
		
		 console.timeEnd("t");
	}
 )