var $jscomp=$jscomp||{};$jscomp.scope={};$jscomp.ASSUME_ES5=!1;$jscomp.ASSUME_NO_NATIVE_MAP=!1;$jscomp.ASSUME_NO_NATIVE_SET=!1;$jscomp.SIMPLE_FROUND_POLYFILL=!1;$jscomp.ISOLATE_POLYFILLS=!1;$jscomp.defineProperty=$jscomp.ASSUME_ES5||"function"==typeof Object.defineProperties?Object.defineProperty:function(d,k,l){if(d==Array.prototype||d==Object.prototype)return d;d[k]=l.value;return d};
$jscomp.getGlobal=function(d){d=["object"==typeof globalThis&&globalThis,d,"object"==typeof window&&window,"object"==typeof self&&self,"object"==typeof global&&global];for(var k=0;k<d.length;++k){var l=d[k];if(l&&l.Math==Math)return l}throw Error("Cannot find global object");};$jscomp.global=$jscomp.getGlobal(this);$jscomp.IS_SYMBOL_NATIVE="function"===typeof Symbol&&"symbol"===typeof Symbol("x");$jscomp.TRUST_ES6_POLYFILLS=!$jscomp.ISOLATE_POLYFILLS||$jscomp.IS_SYMBOL_NATIVE;$jscomp.polyfills={};
$jscomp.propertyToPolyfillSymbol={};$jscomp.POLYFILL_PREFIX="$jscp$";var $jscomp$lookupPolyfilledValue=function(d,k){var l=$jscomp.propertyToPolyfillSymbol[k];if(null==l)return d[k];l=d[l];return void 0!==l?l:d[k]};$jscomp.polyfill=function(d,k,l,t){k&&($jscomp.ISOLATE_POLYFILLS?$jscomp.polyfillIsolated(d,k,l,t):$jscomp.polyfillUnisolated(d,k,l,t))};
$jscomp.polyfillUnisolated=function(d,k,l,t){l=$jscomp.global;d=d.split(".");for(t=0;t<d.length-1;t++){var p=d[t];if(!(p in l))return;l=l[p]}d=d[d.length-1];t=l[d];k=k(t);k!=t&&null!=k&&$jscomp.defineProperty(l,d,{configurable:!0,writable:!0,value:k})};
$jscomp.polyfillIsolated=function(d,k,l,t){var p=d.split(".");d=1===p.length;t=p[0];t=!d&&t in $jscomp.polyfills?$jscomp.polyfills:$jscomp.global;for(var y=0;y<p.length-1;y++){var r=p[y];if(!(r in t))return;t=t[r]}p=p[p.length-1];l=$jscomp.IS_SYMBOL_NATIVE&&"es6"===l?t[p]:null;k=k(l);null!=k&&(d?$jscomp.defineProperty($jscomp.polyfills,p,{configurable:!0,writable:!0,value:k}):k!==l&&($jscomp.propertyToPolyfillSymbol[p]=$jscomp.IS_SYMBOL_NATIVE?$jscomp.global.Symbol(p):$jscomp.POLYFILL_PREFIX+p,p=
$jscomp.propertyToPolyfillSymbol[p],$jscomp.defineProperty(t,p,{configurable:!0,writable:!0,value:k})))};$jscomp.polyfill("Math.imul",function(d){return d?d:function(k,l){k=Number(k);l=Number(l);var t=k&65535,p=l&65535;return t*p+((k>>>16&65535)*p+t*(l>>>16&65535)<<16>>>0)|0}},"es6","es3");
$jscomp.polyfill("Math.fround",function(d){if(d)return d;if($jscomp.SIMPLE_FROUND_POLYFILL||"function"!==typeof Float32Array)return function(l){return l};var k=new Float32Array(1);return function(l){k[0]=l;return k[0]}},"es6","es3");$jscomp.arrayIteratorImpl=function(d){var k=0;return function(){return k<d.length?{done:!1,value:d[k++]}:{done:!0}}};$jscomp.arrayIterator=function(d){return{next:$jscomp.arrayIteratorImpl(d)}};
$jscomp.makeIterator=function(d){var k="undefined"!=typeof Symbol&&Symbol.iterator&&d[Symbol.iterator];return k?k.call(d):$jscomp.arrayIterator(d)};$jscomp.FORCE_POLYFILL_PROMISE=!1;
$jscomp.polyfill("Promise",function(d){function k(){this.batch_=null}function l(r){return r instanceof p?r:new p(function(c,a){c(r)})}if(d&&!$jscomp.FORCE_POLYFILL_PROMISE)return d;k.prototype.asyncExecute=function(r){if(null==this.batch_){this.batch_=[];var c=this;this.asyncExecuteFunction(function(){c.executeBatch_()})}this.batch_.push(r)};var t=$jscomp.global.setTimeout;k.prototype.asyncExecuteFunction=function(r){t(r,0)};k.prototype.executeBatch_=function(){for(;this.batch_&&this.batch_.length;){var r=
this.batch_;this.batch_=[];for(var c=0;c<r.length;++c){var a=r[c];r[c]=null;try{a()}catch(e){this.asyncThrow_(e)}}}this.batch_=null};k.prototype.asyncThrow_=function(r){this.asyncExecuteFunction(function(){throw r;})};var p=function(r){this.state_=0;this.result_=void 0;this.onSettledCallbacks_=[];var c=this.createResolveAndReject_();try{r(c.resolve,c.reject)}catch(a){c.reject(a)}};p.prototype.createResolveAndReject_=function(){function r(e){return function(g){a||(a=!0,e.call(c,g))}}var c=this,a=!1;
return{resolve:r(this.resolveTo_),reject:r(this.reject_)}};p.prototype.resolveTo_=function(r){if(r===this)this.reject_(new TypeError("A Promise cannot resolve to itself"));else if(r instanceof p)this.settleSameAsPromise_(r);else{a:switch(typeof r){case "object":var c=null!=r;break a;case "function":c=!0;break a;default:c=!1}c?this.resolveToNonPromiseObj_(r):this.fulfill_(r)}};p.prototype.resolveToNonPromiseObj_=function(r){var c=void 0;try{c=r.then}catch(a){this.reject_(a);return}"function"==typeof c?
this.settleSameAsThenable_(c,r):this.fulfill_(r)};p.prototype.reject_=function(r){this.settle_(2,r)};p.prototype.fulfill_=function(r){this.settle_(1,r)};p.prototype.settle_=function(r,c){if(0!=this.state_)throw Error("Cannot settle("+r+", "+c+"): Promise already settled in state"+this.state_);this.state_=r;this.result_=c;this.executeOnSettledCallbacks_()};p.prototype.executeOnSettledCallbacks_=function(){if(null!=this.onSettledCallbacks_){for(var r=0;r<this.onSettledCallbacks_.length;++r)y.asyncExecute(this.onSettledCallbacks_[r]);
this.onSettledCallbacks_=null}};var y=new k;p.prototype.settleSameAsPromise_=function(r){var c=this.createResolveAndReject_();r.callWhenSettled_(c.resolve,c.reject)};p.prototype.settleSameAsThenable_=function(r,c){var a=this.createResolveAndReject_();try{r.call(c,a.resolve,a.reject)}catch(e){a.reject(e)}};p.prototype.then=function(r,c){function a(b,f){return"function"==typeof b?function(m){try{e(b(m))}catch(n){g(n)}}:f}var e,g,x=new p(function(b,f){e=b;g=f});this.callWhenSettled_(a(r,e),a(c,g));return x};
p.prototype.catch=function(r){return this.then(void 0,r)};p.prototype.callWhenSettled_=function(r,c){function a(){switch(e.state_){case 1:r(e.result_);break;case 2:c(e.result_);break;default:throw Error("Unexpected state: "+e.state_);}}var e=this;null==this.onSettledCallbacks_?y.asyncExecute(a):this.onSettledCallbacks_.push(a)};p.resolve=l;p.reject=function(r){return new p(function(c,a){a(r)})};p.race=function(r){return new p(function(c,a){for(var e=$jscomp.makeIterator(r),g=e.next();!g.done;g=e.next())l(g.value).callWhenSettled_(c,
a)})};p.all=function(r){var c=$jscomp.makeIterator(r),a=c.next();return a.done?l([]):new p(function(e,g){function x(m){return function(n){b[m]=n;f--;0==f&&e(b)}}var b=[],f=0;do b.push(void 0),f++,l(a.value).callWhenSettled_(x(b.length-1),g),a=c.next();while(!a.done)})};return p},"es6","es3");
(function(){function d(){this.i0=0;this.d=[this]}function k(c,a,e,g,x){var b,f;var m=l([],0,8192,y);if(4>(e|0)){if(0===(e|0))return 0;g[x]=e+255|0;if((((a+e|0)+-2|0)+1|0)>=a)for(b=f=0;;)if(b=b+1|0,g[x+b|0]=c[a+f|0]|0,(a+f|0)<=((a+e|0)+-2|0))f=f+1|0;else break;return e+1|0}for(b=0;m[b]={d:c,o:a},b=b+1|0,8192>(0+b|0););g[x]=31;g[x+1|0]=c[a]|0;g[x+2|0]=c[a+1|0]|0;if((a+2|0)<((a+e|0)+-12|0)){var n=2;f=3;for(b=2;;){a:{var h=b+1|0;var q=c[a+h|0]&255;var w=q<<8|c[a+b|0]&255;var v=c[(a+b|0)+2|0]|0;var u=
m[(w>>>3^w^(v<<8|q))&8191];var z=u.o;var A=a+b|0;var B=A-z|0;m[(w>>>3^w^(v<<8|q))&8191]={d:c,o:a+b|0};if((A|0)===(z|0)||8191<B>>>0)b=c[a+b|0]|0;else if(q=u.d[u.o]|0,w=c[a+b|0]|0,(q&255)===(w&255))if((u.d[u.o+1|0]|0)===(c[a+h|0]&255))if(w=u.d[u.o+2|0]|0,w===(c[(a+b|0)+2|0]|0)){q=B-1|0;v=b+3|0;b:if(0===(q|0))if((a+v|0)<((a+e|0)+-2|0))for(h=3,b=0;;){z=v+b|0;if((u.d[u.o+h|0]&255)===w)if(b=b+1|0,z=v+b|0,h=h+1|0,(a+z|0)<((a+e|0)+-2|0))continue;else h=z;else{h=z;break b}break}else h=v;else if(h=b+4|0,(u.d[u.o+
3|0]|0)===(c[a+v|0]&255))if(w=b+5|0,(u.d[u.o+4|0]|0)===(c[a+h|0]&255)){if(h=b+6|0,(u.d[u.o+5|0]|0)===(c[a+w|0]&255))if(w=b+7|0,(u.d[u.o+6|0]|0)===(c[a+h|0]&255)){if(h=b+8|0,(u.d[u.o+7|0]|0)===(c[a+w|0]&255))if(w=b+9|0,(u.d[u.o+8|0]|0)===(c[a+h|0]&255)){if(h=b+10|0,(u.d[u.o+9|0]|0)===(c[a+w|0]&255))if(w=b+11|0,(u.d[u.o+10|0]|0)===(c[a+h|0]&255))for(h=0,b=11;;){v=w+h|0;if((a+v|0)<((a+e|0)+-2|0)){if(z=h+1|0,h=w+z|0,B=b+1|0,(u.d[u.o+b|0]&255)===(c[a+v|0]&255)){h=z;b=B;continue}}else h=v;break}else h=
w}else h=w}else h=w}else h=w;0===(n|0)?f=f-1|0:g[((x+f|0)+(-n|0)|0)+-1|0]=n+255|0;n=(a+h|0)+-3|0;b=n-A|0;if(262<b>>>0){w=((-263-A|0)+n>>>0)/262|0;n=((n-262|0)-A|0)+(t(w,-262)|0)|0;v=x+f|0;for(u=g;;)if(u[v]=(q>>>8)+224|0,u[v+1|0]=253,u[v+2|0]=q,b=b-262|0,262<b>>>0)v=v+3|0;else break;b=f+3|0;f=b+(t(w,3)|0)|0;b=n}7>b>>>0?(g[x+f|0]=(b<<5)+(q>>>8)|0,v=(x+f|0)+2|0,u=g,b=q,n=2):(g[x+f|0]=(q>>>8)+224|0,g[(x+f|0)+2|0]=q,v=(x+f|0)+3|0,u=g,n=3,b=b+249|0);g[(x+f|0)+1|0]=b;f=f+n|0;n=c[(a+h|0)+-2|0]&255;q=n<<8|
c[(a+h|0)+-3|0]&255;b=h-1|0;m[(q>>>3^q^((c[a+b|0]&255)<<8|n))&8191]={d:c,o:(a+h|0)+-3|0};n=c[a+b|0]&255;q=n<<8|c[(a+h|0)+-2|0]&255;m[(q>>>3^q^((c[a+h|0]&255)<<8|n))&8191]={d:c,o:(a+h|0)+-2|0};u[v]=31;f=f+1|0;n=0;break a}else b=q;else b=q;else b=w;g[x+f|0]=b;n=n+1|0;b=f+1|0;32===(n|0)?(g[x+b|0]=31,f=f+2|0,b=h,n=0):(f=b,b=h)}if(!((a+b|0)<((a+e|0)+-12|0)))break}}else n=2,f=3,b=2;if((a+b|0)<=(((a+e|0)+-2|0)+1|0))for(;;)if(g[x+f|0]=c[a+b|0]|0,n=n+1|0,h=f+1|0,32===(n|0)?(g[x+h|0]=31,f=f+2|0,n=0):f=h,h=
b+1|0,(a+b|0)<=((a+e|0)+-2|0))b=h;else break;0===(n|0)?f=f-1|0:g[((x+f|0)+(-n|0)|0)+-1|0]=n+255|0;return(x+f|0)-x|0}function l(c,a,e,g){for(;a<e;a++)c[a]=g;return c}var t=Math.imul,p=Math.fround;d.prototype.encode=function(c){var a=+c.length;var e=0>a?-a:a;var g=~~(e*p(2.32830644E-10));var x=new Int32Array(4);x[0]=g;e=~~(e%4294967296);x[1]=e;x[2]=0!==(e|0)?g^-1|0:-g|0;x[3]=-e|0;g=x[(0>a?2:0)+1|0]|0;x=new Uint8Array(g+1|0);k(c,0,g,x,0)|0;if(65536>(g|0))c=k(c,0,g,x,0)|0;else{e=x;var b;var f=l([],0,
8192,y);if(4>(g|0))if(0===(g|0))c=0;else{e[0]=g+255|0;if(0<=(((0+g|0)+-2|0)+1|0))for(a=b=0;;)if(a=a+1|0,e[0+a|0]=c[0+b|0]|0,(0+b|0)<=((0+g|0)+-2|0))b=b+1|0;else break;c=g+1|0}else{for(a=0;f[a]={d:c,o:0},a=a+1|0,8192>(0+a|0););e[0]=31;e[1]=c[0]|0;e[2]=c[1]|0;if(2<((0+g|0)+-12|0)){var m=2;b=3;for(a=2;;){c:{d:{var n=c[0+a|0]|0;if((n&255)===(c[(0+a|0)+-1|0]&255)){n&=255;var h=c[(0+a|0)+1|0]|0;var q=c[(0+a|0)+2|0]|0;if((n<<8|n|0)===(q<<8|h|0)){var w=(0+a|0)+2|0;var v=c;q=3;n=1;break d}}else h=c[(0+a|0)+
1|0]|0,q=c[(0+a|0)+2|0]|0,n&=255;var u=h<<8|n;v=f[(u^(q<<8|h))&8191^u>>>3];var z=v.o;var A=0+a|0;n=A-z|0;f[(u^(q<<8|h))&8191^u>>>3]={d:c,o:0+a|0};q=a+1|0;if((A|0)===(z|0)||73724<n>>>0)a=c[0+a|0]|0;else if(h=v.d[v.o]|0,u=c[0+a|0]|0,(h&255)===(u&255))if((v.d[v.o+1|0]|0)===(c[0+q|0]&255))if((v.d[v.o+2|0]|0)===(c[(0+a|0)+2|0]|0))if(8190<n>>>0)if((c[(0+a|0)+3|0]|0)===(v.d[v.o+3|0]|0))if((c[(0+a|0)+4|0]|0)===(v.d[v.o+4|0]|0)){q=5;w=v.o+5|0;v=v.d;break d}else a=h;else a=h;else{q=3;w=v.o+3|0;v=v.d;break d}else a=
h;else a=h;else a=u;e[0+b|0]=a;m=m+1|0;a=b+1|0;32===(m|0)?(e[0+a|0]=31,b=b+2|0,a=q,m=0):(b=a,a=q);break c}z=a+q|0;A=n-1|0;d:if(0===(A|0))if(h=c[(0+z|0)+-1|0]|0,(0+z|0)<((0+g|0)+-2|0))for(q=0;;){if((v[w]&255)===(h&255)){if(q=q+1|0,((0+z|0)+q|0)<((0+g|0)+-2|0)){w=w+1|0;continue}}else break d;break}else q=0;else if((v[w]&255)===(c[0+z|0]&255)){if(q=2,(v[w+1|0]|0)===(c[(0+z|0)+1|0]|0))if(h=q+1|0,(v[w+2|0]|0)===(c[(0+z|0)+q|0]&255)){if(q=h+1|0,(v[w+3|0]|0)===(c[(0+z|0)+h|0]&255))if(h=q+1|0,(v[w+4|0]|0)===
(c[(0+z|0)+q|0]&255)){if(q=h+1|0,(v[w+5|0]|0)===(c[(0+z|0)+h|0]&255))if(h=q+1|0,(v[w+6|0]|0)===(c[(0+z|0)+q|0]&255)){if(q=h+1|0,(v[w+7|0]|0)===(c[(0+z|0)+h|0]&255))for(u=q,q=h,h=0;;){if(((0+z|0)+u|0)<((0+g|0)+-2|0)){q=q+2|0;var B=h+1|0;if((v[(w+8|0)+h|0]&255)===(c[(0+z|0)+u|0]&255)){var C=q;h=B;q=u;u=C;continue}}else q=u;break}}else q=h}else q=h}else q=h}else q=1;q=z+q|0;0===(m|0)?b=b-1|0:e[((0+b|0)+(-m|0)|0)+-1|0]=m+255|0;h=(0+q|0)+-3|0;u=0+a|0;m=h-u|0;if(8191>A>>>0)if(7>m>>>0)e[0+b|0]=(m<<5)+(A>>>
8)|0,e[(0+b|0)+1|0]=A,a=b+2|0;else{e[0+b|0]=(A>>>8)+224|0;a=b+1|0;m=m-7|0;if(254<m>>>0){for(n=(-262-u|0)+h|0;;)if(e[0+a|0]=255,b=b+2|0,m=m-255|0,254<m>>>0)h=a,a=b,b=h;else break;w=0+b|0;v=e;m=(n>>>0)%255|0}else w=0+a|0,v=e,a=b;v[w]=m;e[(0+a|0)+2|0]=A;a=a+3|0}else if(n=n-8192|0,7>m>>>0)e[0+b|0]=(m<<5)+31|0,e[(0+b|0)+1|0]=255,e[(0+b|0)+2|0]=n>>>8,e[(0+b|0)+3|0]=n,a=b+4|0;else{e[0+b|0]=255;a=b+1|0;m=m-7|0;if(254<m>>>0){for(h=(-262-u|0)+h|0;;)if(e[0+a|0]=255,b=b+2|0,m=m-255|0,254<m>>>0)u=a,a=b,b=u;else break;
w=0+b|0;v=e;m=(h>>>0)%255|0}else w=0+a|0,v=e,a=b;v[w]=m;e[(0+a|0)+2|0]=255;e[(0+a|0)+3|0]=n>>>8;e[(0+a|0)+4|0]=n;a=a+5|0}b=c[(0+q|0)+-2|0]&255;m=b<<8|c[(0+q|0)+-3|0]&255;n=q-1|0;f[(m>>>3^m^((c[0+n|0]&255)<<8|b))&8191]={d:c,o:(0+q|0)+-3|0};b=c[0+n|0]&255;m=b<<8|c[(0+q|0)+-2|0]&255;f[(m>>>3^m^((c[0+q|0]&255)<<8|b))&8191]={d:c,o:(0+q|0)+-2|0};e[0+a|0]=31;b=a+1|0;a=n;m=0}if(!((0+a|0)<((0+g|0)+-12|0)))break}}else m=2,b=3,a=2;if((0+a|0)<=(((0+g|0)+-2|0)+1|0))for(;;)if(e[0+b|0]=c[0+a|0]|0,m=m+1|0,n=b+1|
0,32===(m|0)?(e[0+n|0]=31,b=b+2|0,m=0):b=n,n=a+1|0,(0+a|0)<=((0+g|0)+-2|0))a=n;else break;0===(m|0)?b=b-1|0:e[((0+b|0)+(-m|0)|0)+-1|0]=m+255|0;e[0]|=32;c=0+b|0}c|=0}g=c;new Number(+(g|0));c=new Uint8Array(g/1|0);if(0!==(g|0))for(e=0;c[e]=x[e]|0,e=e+1|0,(g|0)!==(e|0););g=0;x=c;+x.BYTES_PER_ELEMENT;0!==(g|0)&&(x=x.subarray(+(g>>>0)));return x};d.prototype.decode=function(c){var a=+c.length;var e=0>a?-a:a;var g=~~(e*p(2.32830644E-10));var x=new Int32Array(4);x[0]=g;e=~~(e%4294967296);x[1]=e;x[2]=0!==
(e|0)?g^-1|0:-g|0;x[3]=-e|0;e=0>a?2:0;g=x[e]|0;e=x[e+1|0]|0;x=new Number(4294967296*+(g>>>0)+ +(e>>>0));x.toString(10);x=new Uint8Array(10485760);switch((c[0]&255)>>>5|0){case 1:b:{g=e;e=x;var b,f;a=c[0]&31;var m=f=1;for(b=0;;){if(31<a>>>0){var n=a<<8&7936;var h=(a>>>5)-1|0;if(6===(h|0))for(h=6;;){var q=c[0+f|0]|0;h=(q&255)+h|0;var w=f+1|0;if(255===(q&255))f=f+1|0;else{f=w;break}}w=c[0+f|0]|0;q=f+1|0;if(7936===(n|0)&&255===(w&255)){n=c[0+q|0]|0;w=c[(0+f|0)+2|0]|0;q=f+3|0;var v=((0+b|0)+(-(((n&255)<<
8)+w|0)|0)|0)+-8191|0;var u=e;n=3}else v=((0+b|0)+(-n|0)|0)+(-(w&255)|0)|0,u=e,n=1;if(10485760<(((0+b|0)+h|0)+3|0)||0>(v+-1|0)){c=0;break b}(0+q|0)<(0+g|0)?(f=f+n|0,a=c[0+q|0]&255,q=f+1|0):m=0;w=u[v+-1|0]|0;e[0+b|0]=w;if(u.length===e.length&&u===e&&v===(0+b|0)){if(e[(0+b|0)+1|0]=w,e[(0+b|0)+2|0]=w,b=b+3|0,0!==(h|0)){f=h;for(n=0;;)if(e[(0+b|0)+n|0]=w,f=f-1|0,0!==(f|0))n=n+1|0;else break;b=b+h|0}}else if(e[(0+b|0)+1|0]=u[v]|0,e[(0+b|0)+2|0]=u[v+1|0]|0,b=b+3|0,0!==(h|0)){f=h;for(n=w=0;;)if(e[(0+b|0)+
w|0]=u[(v+2|0)+n|0]|0,f=f-1|0,0!==(f|0))w=w+1|0,n=n+1|0;else break;b=b+h|0}f=q}else{m=a+1|0;if(10485760<((0+b|0)+m|0)||((0+f|0)+m|0)>(0+g|0)){c=0;break b}e[0+b|0]=c[0+f|0]|0;h=f+1|0;n=b+1|0;if(0===(a|0))a=f,f=h,h=a,b=n;else for(m=b;;)if(e[0+n|0]=c[0+h|0]|0,f=f+2|0,a=a-1|0,b=m+2|0,0!==(a|0))b=m,q=f,f=h,h=q,m=n,n=b+2|0;else break;m=(a=(0+f|0)<(0+g|0)?1:0)?1:0;a?(a=c[0+f|0]&255,f=h+2|0):a=0}if(0===(m|0))break}c=0+b|0}g=c|0;break;case 0:b:{g=e;e=x;m=c[0]&31;b=f=1;for(a=0;;){if(31<m>>>0){h=(m>>>5)-1|0;
6===(h|0)&&(h=(c[0+b|0]&255)+6|0,b=b+1|0);q=-(c[0+b|0]&255)|0;if(10485760<(((0+a|0)+h|0)+3|0)){c=0;break b}u=q-1|0;if(0>(((0+a|0)+(-(m<<8&7936)|0)|0)+u|0)){c=0;break b}n=b+1|0;(0+n|0)<(0+g|0)?(n=c[0+n|0]&255,b=b+2|0,v=f,f=n,n=v):(f=m,b=n,n=0);if(e.length===e.length&&e===e&&(((0+a|0)+(-(m<<8&7936)|0)|0)+q|0)===(0+a|0)){u=e[((0+a|0)+(-(m<<8&7936)|0)|0)+u|0]|0;e[0+a|0]=u;e[(0+a|0)+1|0]=u;e[(0+a|0)+2|0]=u;a=a+3|0;if(0!==(h|0)){m=h;for(q=0;;)if(e[(0+a|0)+q|0]=u,m=m-1|0,0!==(m|0))q=q+1|0;else break;a=a+
h|0}m=f;f=n}else{q=u+1|0;e[0+a|0]=e[((0+a|0)+(-(m<<8&7936)|0)|0)+u|0]|0;v=q+1|0;e[(0+a|0)+1|0]=e[((0+a|0)+(-(m<<8&7936)|0)|0)+q|0]|0;e[(0+a|0)+2|0]=e[((0+a|0)+(-(m<<8&7936)|0)|0)+v|0]|0;var z=a+3|0;if(0===(h|0))m=f,f=n,a=z;else{u=h;for(w=0;;)if(q=q+2|0,e[(0+z|0)+w|0]=e[((0+a|0)+(-(m<<8&7936)|0)|0)+q|0]|0,u=u-1|0,0!==(u|0)){var A=q;q=v;v=A;w=w+1|0}else break;a=z+h|0;m=f;f=n}}}else{f=m+1|0;if(10485760<((0+a|0)+f|0)||((0+b|0)+f|0)>(0+g|0)){c=0;break b}e[0+a|0]=c[0+b|0]|0;h=b+1|0;n=a+1|0;if(0===(m|0))m=
b,b=h,h=m,a=n;else for(f=a;;)if(e[0+n|0]=c[0+h|0]|0,b=b+2|0,m=m-1|0,a=f+2|0,0!==(m|0))a=b,q=f,f=n,n=q+2|0,b=h,h=a;else break;f=(m=(0+b|0)<(0+g|0)?1:0)?1:0;m?(m=c[0+b|0]&255,b=h+2|0):m=0}if(0===(f|0))break}c=0+a|0}g=c|0;break;default:g=0}c=new Number(+(g|0));c.toString(10);c=new Uint8Array(g/1|0);if(0!==(g|0))for(e=0;c[e]=x[e]|0,e=e+1|0,(g|0)!==(e|0););g=0;x=c;+x.BYTES_PER_ELEMENT;0!==(g|0)&&(x=x.subarray(+(g>>>0)));return x};var y={d:[null],o:0};new Uint8Array([100,101,99,111,100,101,32,115,116,97,
114,116,0]);new Uint8Array([100,101,99,111,100,101,32,101,110,100,0]);var r="object"===typeof self&&self.self===self&&self||"object"===typeof global&&global.global===global&&global||this;d.promise=Promise.resolve();r.FastLZDecoder=d})();var template={VERSION:"0.3",AUTHOR:"agent.zy",cache:{},isNode:!1,opt_level:1};try{null==window&&(template.isNode=!0)}catch(d){template.isNode=!0}
template.info=function(){template.isNode?console.log("[info] template engine node v"+template.VERSION):console.log("[info] template engine browser v"+template.VERSION);console.log("[info] template author "+template.AUTHOR)};
template.isNode&&(template.trim_r=function(d){for(var k=d.length,l=[],t=0;t<k;t++)"\t"!=d[t]&&"\n"!=d[t]&&d[t]&&l.push(d[t]);return l},template.invalidate_ipairs=function(d){for(var k=d.length,l=[],t=[],p=1;p<k&&"in"!=d[p];p++)t.push(d[p]);k=t.join("").split(",");l[0]=d[0];l[1]=k[0];l[2]=k[1];l[3]="in";l[4]=d[3];l[5]="do";return l},template.invalidate_if=function(d){for(var k=d.length,l=[],t=[],p=1;p<k&&"do"!=d[p];p++)t.push(d[p]);l[0]=d[0];l[1]=t.join("");l[2]="do";return l},template.itor="for foreach ipairs if else end EOL".split(" "),
template.eval=function(d,k){k=d.split(" ");k=template.trim_r(k);if(0<k.length){var l=k[0];if(-1==template.itor.indexOf(l))return d;switch(l){case "if":return k=template.invalidate_if(k),"if "+k[1]+"{";case "ipairs":return k=template.invalidate_ipairs(k),d=[],d[0]="var $len = "+k[4]+".length;",d[1]="for(var "+k[1]+"=0; "+k[1]+"<$len;"+k[1]+"++){",d[2]="var "+k[2]+"="+k[4]+"["+k[1]+"];",d.join("\n");case "else":return"}else{";case "for":return"for(var "+k[1]+" in "+k[3]+") {";case "foreach":return"for(var k in "+
k[3]+") { var "+k[1]+"="+k[3]+"[k];";case "end":return"};";case "EOL":return'tml.push("\\n");'}}return""},template.macro=function(d){d=template.trim_r(d.split(" "));return'section["'+d[0]+'"] = "'+d[1]+'"'},template.opt_trim2=function(d){for(var k=d.length,l=[],t=[],p="",y=0;y<k;y++)-1==d[y].indexOf("tml.push")?(p+=d[y],0<t.length&&(l.push("tml.push("+t.join("+")+");"),t=[])):(p&&l.push(p),l.push(d[y]),p="");p&&l.push(p);return l},template.opt_trim=function(d,k,l){k=d.length;var t=[";"],p;for(p in l)t.push("var _"+
p+'=data["'+p+"\"] || '';");t.unshift(d[0]);d[0]=t.join("");l=[];for(p=0;p<k;p++)'tml.push("")'==d[p]&&(l[p]=1),'tml.push(" ")'==d[p]&&(l[p]=1),'tml.push("\\n")'==d[p]&&(l[p]=1),'tml.push("\\n");'==d[p]&&(l[p]=1);t=[];for(p=0;p<k;p++)l[p]||t.push(d[p]);return t});function utf8Encode(d){for(var k=d.length,l=[],t=0;t<k;t++)l[t]=d.charCodeAt(t);return new Uint8Array((new Uint16Array(l)).buffer)}
function utf8Decode(d){d=new Uint16Array(d.buffer);for(var k="",l=d.length,t=0;t<l;t++)k+=String.fromCharCode(d[t]);return k}template.load=function(d,k){if(template.isNode){var l=require("fs");l.existsSync(d)&&(d=l.readFileSync(d),template.init(d))}else{var t=new XMLHttpRequest;t.responseType="arraybuffer";t.onreadystatechange=function(){if(4==t.readyState){var p=new Uint8Array(t.response);template.init(p);null!=k&&k()}};t.open("GET",d,!0);t.send(null)}};template.render=function(d,k){if(template.cache[d])return template.cache[d](k)};
template.init=function(d){if(80==d[0]&&75==d[1]){var k=d[2];var l=k+3;for(var t=d.subarray(3,3+k),p=[],y=0;y<k;y++)p[y]=t[y];k=Number(p.join(""));t=d.subarray(l,l+k);l+=k;k=utf8Decode(new Uint8Array(t));try{var r=JSON.parse(k),c;for(c in r){var a=(new FastLZDecoder).decode(new Uint8Array(d.subarray(l+r[c].s,l+r[c].s+r[c].e))),e=utf8Decode(a);k=c;var g=new Function(e);k&&(template.cache[k]=g)}}catch(x){console.log("[error] parse meta error",x)}}else console.log("[error] file is bad .")};
template.isNode&&(template.precompile=function(d,k,l){if(template.isNode){l||(l=".html");var t=require("fs");if(t.existsSync(d)){var p=new Uint8Array(10485760),y=t.readdirSync(d),r=[],c=y.length;if(l&&0<c){for(d=0;d<c;d++)if(-1!=y[d].indexOf(l)){var a=t.readFileSync(y[d]).toString("utf8");a=template.compile(a,"",!1,!0);codes=utf8Encode(a);a=(new FastLZDecoder).encode(codes);r.push({b:a,k:y[d]})}l=0;c=[];y={};for(d=0;d<r.length;d++)c.push(l),y[r[d].k]={s:l,e:r[d].b.length},p.set(r[d].b,l),l+=r[d].b.length;
p=p.slice(0,l);r=p.length;d=JSON.stringify(y);l=utf8Encode(d);c=l.length;y=c.toString().split("");var e=y.length;a=new Uint8Array(3+y.length);a[0]=80;a[1]=75;a[2]=Number(e);for(d=0;d<e;d++)a[3+d]=Number(y[d])>>0;d=new Uint8Array(a.length+c+r);d.set(a,0);d.set(l,a.length);d.set(p,a.length+c);t.writeFileSync(k,d,"utf8")}}}else console.log("[error] browser is not implements.")});
template.compile=function(d,k,l,t){k||(k=0);if(template.cache[k])return template.cache[k];d=d.replace(/\n/g,"\\n");d=d.replace(/\t/g,"");d=d.replace(/\r/g,"");d=d.replace(/"/g,"'");var p=d.length;var y=l?[]:["var tml=[];var data =arguments[0] || {};"];for(var r=!1,c=[],a="",e=0,g,x={},b={},f=0;f<p;f++){g=d.charAt(f);if("{"==g){var m=d.charAt(f+1);switch(m){case "{":case "-":case "*":case "%":case "#":case "(":y.push('tml.push("'+a+'")'),c.push(f+2),e=f,a=""}}if("}"==g)switch(m=d.charAt(f-1),m){case "}":if(g=
c.pop())g=d.substring(g,f-1),m='tml.push(data["'+g+'"]);',y.push("tml.push(_"+g+");"),a="",e=f+2,x[m]=1,b[g]=1;break;case "*":if(g=c.pop())g=d.substring(g,f-1),y.push("tml.push("+g+");"),a="",e=f+2;break;case "%":if(g=c.pop())g=d.substring(g,f-1),y.push(template.eval(g)),a="",e=f+2;break;case "-":if(g=c.pop())g=d.substring(g,f-1),y.push("var section={};"),y.push("var domacro=function(v){for(var k in section){v=v.replace(new RegExp(k,'g'),section[k]);}return v;};"),y.push(template.macro(g)),a="",e=
f+2,r=!0;break;case ")":if(template.isNode){if(g=c.pop())g=d.substring(g,f-1),a="",e=f+2,template.cache[g]||(m=require("fs"),m.existsSync(g)?(m=m.readFileSync(g).toString("utf8"),g=template.compile(m,g,!0),y=y.concat(g)):y.push("tml.push('[error] "+g+" is not include.');"))}else console.log("not implements");break;case "#":a="",e=f+2}else f==p-1&&y.push('tml.push("'+d.substring(e-1,p)+'");'),a+=g}y=template.opt_trim(y,x,b);if(l)return y;r?y.push("return domacro(tml.join(''));"):y.push("return tml.join('');");
if(t)return y.join("\n");y=template.opt_trim2(y);try{var n=y.join("\n"),h=new Function(n);template.cache[k]=h}catch(q){console.log("[error] syntax error "+q)}return h};template.isNode?exports.template=template:window.template=template;
const repl = require('repl');
const replServer = repl.start({ 
prompt: 'subtask >' ,
preview:true
});
var display = `
Welcome to Sumavision subtask installer.

Useage : install subtask and new RI 
Author : agent.zy@aliyun.com 
Copy   : Sumavision Inc.

enter  .help to show commands help.
`

var help_display = `
.exit            ;;is exit this repl.
.install         ;;is begin install ri and subtask.
`;
console.log(display);
replServer.displayPrompt();

replServer.defineCommand('help', {
    help: '帮助程序',
    action(name) {
      this.clearBufferedCommand();
      console.log(help_display);
      this.displayPrompt();
    }
});

var cmds_queue = [];

var need_install_dir = [
    "/home/admin/backup/",
    "/home/admin/lua/" ,
    "/home/admin/conf/",
    "/home/admin/logs/",
    "/home/admin/app/" ,
    "/home/admin/java/",
    "/home/admin/ccm1/",
    "/home/admin/tml/" ,
    "/home/admin/wasm/",
]
var fs  = require("fs");

function sync_mkdir_op () {
    var length  = need_install_dir.length;
    for(var i = 0; i < length; i++) {
        try {
            fs.mkdirSync(need_install_dir[i], {recursive:true});
            fs.chmodSync(need_install_dir[i], 0o777);
            console.log(`[+] ${need_install_dir[i]} create done.`);
        } catch (e) {
            console.log(`[+] ${need_install_dir[i]} exists skip.`);
        }
    }
}

function sync_write_config_system_type(val) {
   try {
    fs.writeFileSync("/home/admin/conf/suma_system_type.lua", val);
   } catch (e) {
        return 0;
   }
   return 1;
}

replServer.defineCommand('install', {
    help: '安装服务或者安装负载均衡',
    action() {
      replServer.question(
          "你要安装的是负载均衡系统吗?[Y/N]",
          function (ans) {
            var result = ans.toLowerCase() ;
            var os_type_code ;
            if (result != "Y") {
                console.log("\n[+]开始安装负载均衡型程序");
                os_type = `
                return { [type] = "loadavg" }
                `
            } else {
                console.log("\n[+]开始安装服务型程序");
                os_type = `
                return { [type] = "webservice" }
                `
            }
            sync_mkdir_op ();
            if (0x1 == sync_write_config_system_type(os_type)) {
                console.log("[+]系统类型写入完成");
            } else {
                console.log("[-]系统类型写入失败");
                replServer.displayPrompt();
            }
          }
      );
    }
});
replServer.defineCommand('exit', function saybye() {
  console.log('bye.');
  this.close();
});