
;(function(){"use strict";var af=Math.imul;var ag=Math.fround;function FastLZDecoder(){this.i0=0;;this.d=[this];if (arguments.length===1&&arguments[0]===undefined){return;}ae(this);}FastLZDecoder.prototype.encode=function (a1){return ad(this,a1);};FastLZDecoder.prototype.decode=function (a1){return ac(this,a1);};var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};function Q(A,B,y,w,x){var a=0,c=0,d=0,e=0,g=null,h=0,q=null,j=0,i=0,m=0,l=0,o=0,s=0;q=ay([],0,8192,nullObj);if((y|0)<4){if((y|0)===0){return 0|0;}w[x]=y+255|0;if((((B+y|0)+ -2|0)+1|0)>=B){c=0;a=0;while(1){a=a+1|0;w[x+a|0]=A[B+c|0]|0;if((B+c|0)<=((B+y|0)+ -2|0)){c=c+1|0;continue;}break;}}return y+1|0;}a=0;while(1){q[a]={d:A,o:B};a=a+1|0;if((0+a|0)<8192){continue;}break;}w[x]=31;w[x+1|0]=A[B]|0;w[x+2|0]=A[B+1|0]|0;if((B+2|0)<((B+y|0)+ -12|0)){d=2;c=3;a=2;while(1){L1:{e=a+1|0;j=A[B+e|0]&255;i=j<<8|A[B+a|0]&255;m=A[(B+a|0)+2|0]|0;g=q[(i>>>3^i^(m<<8|j))&8191];l=(g.o);o=(B+a|0);s=o-l|0;q[(i>>>3^i^(m<<8|j))&8191]={d:A,o:B+a|0};if((o|0)===(l|0)||s>>>0>8191){a=A[B+a|0]|0;}else{j=g.d[g.o]|0;i=A[B+a|0]|0;if((j&255)===(i&255)){if((g.d[g.o+1|0]|0)===(A[B+e|0]&255)){i=g.d[g.o+2|0]|0;if(i===(A[(B+a|0)+2|0]|0)){j=s-1|0;m=a+3|0;L2:if((j|0)===0){if((B+m|0)<((B+y|0)+ -2|0)){e=3;a=0;while(1){l=m+a|0;if((g.d[g.o+e|0]&255)===i){a=a+1|0;l=m+a|0;e=e+1|0;if((B+l|0)<((B+y|0)+ -2|0)){continue;}else{e=l;}}else{e=l;break L2;}break;}}else{e=m;break L2;}}else{e=a+4|0;if((g.d[g.o+3|0]|0)===(A[B+m|0]&255)){i=a+5|0;if((g.d[g.o+4|0]|0)===(A[B+e|0]&255)){e=a+6|0;if((g.d[g.o+5|0]|0)===(A[B+i|0]&255)){i=a+7|0;if((g.d[g.o+6|0]|0)===(A[B+e|0]&255)){e=a+8|0;if((g.d[g.o+7|0]|0)===(A[B+i|0]&255)){i=a+9|0;if((g.d[g.o+8|0]|0)===(A[B+e|0]&255)){e=a+10|0;if((g.d[g.o+9|0]|0)===(A[B+i|0]&255)){i=a+11|0;if((g.d[g.o+10|0]|0)===(A[B+e|0]&255)){e=0;a=11;while(1){m=i+e|0;if((B+m|0)<((B+y|0)+ -2|0)){l=e+1|0;e=i+l|0;s=a+1|0;if((g.d[g.o+a|0]&255)===(A[B+m|0]&255)){e=l;a=s;continue;}}else{e=m;}break;}}else{e=i;}}}else{e=i;}}}else{e=i;}}}else{e=i;}}}if((d|0)===0){c=c-1|0;}else{w[((x+c|0)+(-d|0)|0)+ -1|0]=d+255|0;}d=((B+e|0)+ -3|0);a=d-o|0;if(a>>>0>262){i=(( -263-o|0)+d>>>0)/262|0;d=((d-262|0)-o|0)+(af(i,-262)|0)|0;h=x+c|0;g=w;while(1){g[h]=(j>>>8)+224|0;g[h+1|0]=253;g[h+2|0]=j;a=a-262|0;if(a>>>0>262){h=h+3|0;g=g;continue;}break;}a=c+3|0;c=a+(af(i,3)|0)|0;a=d;}if(a>>>0<7){w[x+c|0]=(a<<5)+(j>>>8)|0;h=(x+c|0)+2|0;g=w;a=j;d=2;}else{w[x+c|0]=(j>>>8)+224|0;w[(x+c|0)+2|0]=j;h=(x+c|0)+3|0;g=w;d=3;a=a+249|0;}w[(x+c|0)+1|0]=a;c=c+d|0;d=A[(B+e|0)+ -2|0]&255;j=d<<8|A[(B+e|0)+ -3|0]&255;a=e-1|0;q[(j>>>3^j^((A[B+a|0]&255)<<8|d))&8191]={d:A,o:(B+e|0)+ -3|0};d=A[B+a|0]&255;j=d<<8|A[(B+e|0)+ -2|0]&255;q[(j>>>3^j^((A[B+e|0]&255)<<8|d))&8191]={d:A,o:(B+e|0)+ -2|0};g[h]=31;c=c+1|0;d=0;break L1;}else{a=j;}}else{a=j;}}else{a=i;}}w[x+c|0]=a;d=d+1|0;a=c+1|0;if((d|0)===32){w[x+a|0]=31;c=c+2|0;a=e;d=0;}else{c=a;a=e;}}if((B+a|0)<((B+y|0)+ -12|0)){continue;}break;}}else{d=2;c=3;a=2;}if((B+a|0)<=(((B+y|0)+ -2|0)+1|0)){while(1){w[x+c|0]=A[B+a|0]|0;d=d+1|0;e=c+1|0;if((d|0)===32){w[x+e|0]=31;c=c+2|0;d=0;}else{c=e;}e=a+1|0;if((B+a|0)<=((B+y|0)+ -2|0)){a=e;continue;}break;}}if((d|0)===0){c=c-1|0;}else{w[((x+c|0)+(-d|0)|0)+ -1|0]=d+255|0;}return (x+c|0)-(x)|0;}function X(y,z,w,s,t){var c=0,a=0,d=0,j=null,k=0,i=0,e=0,g=0,l=0,o=null,q=0,m=0,$=0,A=0;o=ay([],0,8192,nullObj);if((w|0)<4){if((w|0)===0){return 0|0;}s[t]=w+255|0;if((((z+w|0)+ -2|0)+1|0)>=z){a=0;c=0;while(1){c=c+1|0;s[t+c|0]=y[z+a|0]|0;if((z+a|0)<=((z+w|0)+ -2|0)){a=a+1|0;continue;}break;}}return w+1|0;}c=0;while(1){o[c]={d:y,o:z};c=c+1|0;if((0+c|0)<8192){continue;}break;}s[t]=31;s[t+1|0]=y[z]|0;s[t+2|0]=y[z+1|0]|0;if((z+2|0)<((z+w|0)+ -12|0)){d=2;a=3;c=2;while(1){L1:{L2:{i=y[z+c|0]|0;if((i&255)===(y[(z+c|0)+ -1|0]&255)){i=i&255;g=y[(z+c|0)+1|0]|0;e=y[(z+c|0)+2|0]|0;if((i<<8|i|0)===(e<<8|g|0)){k=(z+c|0)+2|0;j=y;e=3;i=1;break L2;}}else{g=y[(z+c|0)+1|0]|0;e=y[(z+c|0)+2|0]|0;i=i&255;}g=g;l=g<<8|i;j=o[(l^(e<<8|g))&8191^l>>>3];q=(j.o);m=(z+c|0);i=m-q|0;o[(l^(e<<8|g))&8191^l>>>3]={d:y,o:z+c|0};e=c+1|0;if((m|0)===(q|0)||i>>>0>73724){c=y[z+c|0]|0;}else{g=j.d[j.o]|0;l=y[z+c|0]|0;if((g&255)===(l&255)){if((j.d[j.o+1|0]|0)===(y[z+e|0]&255)){if((j.d[j.o+2|0]|0)===(y[(z+c|0)+2|0]|0)){if(i>>>0>8190){if((y[(z+c|0)+3|0]|0)===(j.d[j.o+3|0]|0)){if((y[(z+c|0)+4|0]|0)===(j.d[j.o+4|0]|0)){e=5;k=j.o+5|0;j=j.d;break L2;}else{c=g;}}else{c=g;}}else{e=3;k=j.o+3|0;j=j.d;break L2;}}else{c=g;}}else{c=g;}}else{c=l;}}s[t+a|0]=c;d=d+1|0;c=a+1|0;if((d|0)===32){s[t+c|0]=31;a=a+2|0;c=e;d=0;break L1;}else{a=c;c=e;break L1;}}q=c+e|0;m=i-1|0;L3:if((m|0)===0){g=y[(z+q|0)+ -1|0]|0;if((z+q|0)<((z+w|0)+ -2|0)){e=0;while(1){if((j[k]&255)===(g&255)){e=e+1|0;if(((z+q|0)+e|0)<((z+w|0)+ -2|0)){k=k+1|0;j=j;continue;}}else{break L3;}break;}}else{e=0;break L3;}}else{if((j[k]&255)===(y[z+q|0]&255)){e=1+1|0;if((j[k+1|0]|0)===(y[(z+q|0)+1|0]|0)){g=e+1|0;if((j[k+2|0]|0)===(y[(z+q|0)+e|0]&255)){e=g+1|0;if((j[k+3|0]|0)===(y[(z+q|0)+g|0]&255)){g=e+1|0;if((j[k+4|0]|0)===(y[(z+q|0)+e|0]&255)){e=g+1|0;if((j[k+5|0]|0)===(y[(z+q|0)+g|0]&255)){g=e+1|0;if((j[k+6|0]|0)===(y[(z+q|0)+e|0]&255)){e=g+1|0;if((j[k+7|0]|0)===(y[(z+q|0)+g|0]&255)){l=e;e=g;g=0;while(1){if(((z+q|0)+l|0)<((z+w|0)+ -2|0)){e=e+2|0;$=g+1|0;if((j[(k+8|0)+g|0]&255)===(y[(z+q|0)+l|0]&255)){A=e;g=$;e=l;l=A;continue;}}else{e=l;}break;}}}else{e=g;}}}else{e=g;}}}else{e=g;}}}else{e=1;}}e=q+e|0;if((d|0)===0){a=a-1|0;}else{s[((t+a|0)+(-d|0)|0)+ -1|0]=d+255|0;}g=((z+e|0)+ -3|0);l=(z+c|0);d=g-l|0;L4:if(m>>>0<8191){if(d>>>0<7){s[t+a|0]=(d<<5)+(m>>>8)|0;s[(t+a|0)+1|0]=m;c=a+2|0;break L4;}else{s[t+a|0]=(m>>>8)+224|0;c=a+1|0;d=d-7|0;if(d>>>0>254){i=( -262-l|0)+g|0;while(1){s[t+c|0]=255;a=a+2|0;d=d-255|0;if(d>>>0>254){g=c;c=a;a=g;continue;}break;}k=t+a|0;j=s;d=(i>>>0)%255|0;}else{k=t+c|0;j=s;c=a;}j[k]=d;s[(t+c|0)+2|0]=m;c=c+3|0;}}else{i=i-8192|0;if(d>>>0<7){s[t+a|0]=(d<<5)+31|0;s[(t+a|0)+1|0]=255;s[(t+a|0)+2|0]=i>>>8;s[(t+a|0)+3|0]=i;c=a+4|0;}else{s[t+a|0]=255;c=a+1|0;d=d-7|0;if(d>>>0>254){g=( -262-l|0)+g|0;while(1){s[t+c|0]=255;a=a+2|0;d=d-255|0;if(d>>>0>254){l=c;c=a;a=l;continue;}break;}k=t+a|0;j=s;d=(g>>>0)%255|0;}else{k=t+c|0;j=s;c=a;}j[k]=d;s[(t+c|0)+2|0]=255;s[(t+c|0)+3|0]=i>>>8;s[(t+c|0)+4|0]=i;c=c+5|0;}}a=y[(z+e|0)+ -2|0]&255;d=a<<8|y[(z+e|0)+ -3|0]&255;i=e-1|0;o[(d>>>3^d^((y[z+i|0]&255)<<8|a))&8191]={d:y,o:(z+e|0)+ -3|0};a=y[z+i|0]&255;d=a<<8|y[(z+e|0)+ -2|0]&255;o[(d>>>3^d^((y[z+e|0]&255)<<8|a))&8191]={d:y,o:(z+e|0)+ -2|0};s[t+c|0]=31;a=c+1|0;c=i;d=0;break L1;}if((z+c|0)<((z+w|0)+ -12|0)){continue;}break;}}else{d=2;a=3;c=2;}if((z+c|0)<=(((z+w|0)+ -2|0)+1|0)){while(1){s[t+a|0]=y[z+c|0]|0;d=d+1|0;i=a+1|0;if((d|0)===32){s[t+i|0]=31;a=a+2|0;d=0;}else{a=i;}i=c+1|0;if((z+c|0)<=((z+w|0)+ -2|0)){c=i;continue;}break;}}if((d|0)===0){a=a-1|0;}else{s[((t+a|0)+(-d|0)|0)+ -1|0]=d+255|0;}s[t]=s[t]|32;return (t+a|0)-(t)|0;}function W(y,z,w,s,t){var e=0,a=0,c=0,g=0,d=0,j=0,i=0,l=0,m=0,q=0,o=0,A=0;c=y[z]&255&31;g=1;a=1;e=0;while(1){L1:if(c>>>0>31){d=(c>>>5)-1|0;if((d|0)===6){d=(y[z+a|0]&255)+6|0;a=a+1|0;}i=-(y[z+a|0]&255)|0;if((((t+e|0)+d|0)+3|0)>(t+10485760|0)){return 0|0;}l=i-1|0;if((((t+e|0)+(-(c<<8&7936)|0)|0)+l|0)<t){return 0|0;}j=a+1|0;if((z+j|0)<(z+w|0)){j=y[z+j|0]&255;a=a+2|0;m=g;g=j;j=m;}else{g=c;a=j;j=0;}if(s.length===s.length&&s===s&&(((t+e|0)+(-(c<<8&7936)|0)|0)+i|0)===(t+e|0)){l=s[((t+e|0)+(-(c<<8&7936)|0)|0)+l|0]|0;s[t+e|0]=l;s[(t+e|0)+1|0]=l;s[(t+e|0)+2|0]=l;e=e+3|0;if((d|0)===0){c=g;g=j;break L1;}else{c=d;i=0;while(1){s[(t+e|0)+i|0]=l;c=c-1|0;if((c|0)!==0){i=i+1|0;continue;}break;}e=e+d|0;c=g;g=j;break L1;}}else{i=l+1|0;s[t+e|0]=s[((t+e|0)+(-(c<<8&7936)|0)|0)+l|0]|0;m=i+1|0;s[(t+e|0)+1|0]=s[((t+e|0)+(-(c<<8&7936)|0)|0)+i|0]|0;s[(t+e|0)+2|0]=s[((t+e|0)+(-(c<<8&7936)|0)|0)+m|0]|0;o=e+3|0;if((d|0)===0){c=g;g=j;e=o;break L1;}else{l=d;q=0;while(1){i=i+2|0;s[(t+o|0)+q|0]=s[((t+e|0)+(-(c<<8&7936)|0)|0)+i|0]|0;l=l-1|0;if((l|0)!==0){A=i;i=m;m=A;q=q+1|0;continue;}break;}e=o+d|0;c=g;g=j;}}}else{g=c+1|0;if(((t+e|0)+g|0)>(t+10485760|0)){return 0|0;}if(((z+a|0)+g|0)>(z+w|0)){return 0|0;}s[t+e|0]=y[z+a|0]|0;d=a+1|0;j=e+1|0;if((c|0)===0){c=a;a=d;d=c;e=j;}else{g=e;while(1){s[t+j|0]=y[z+d|0]|0;a=a+2|0;c=c-1|0;e=g+2|0;if((c|0)!==0){e=a;i=g;g=j;j=i+2|0;a=d;d=e;continue;}break;}}c=(z+a|0)<(z+w|0)?1:0;g=c?1:0;if(c){c=y[z+a|0]&255;a=d+2|0;}else{c=0;}}if((g|0)!==0){continue;}break;}return (t+e|0)-(t)|0;}function V(s,t,q,o,p){var c=0,e=0,i=0,a=0,d=0,j=0,g=0,m=null,n=0,l=0;c=s[t]&255&31;a=1;i=1;e=0;while(1){L1:if(c>>>0>31){j=c<<8&7936;d=(c>>>5)-1|0;if((d|0)===6){d=6;while(1){g=s[t+a|0]|0;d=(g&255)+d|0;l=a+1|0;if((g&255)===255){a=a+1|0;continue;}else{a=l;}break;}}l=s[t+a|0]|0;g=a+1|0;if((j|0)===7936&&(l&255)===255){j=s[t+g|0]|0;l=s[(t+a|0)+2|0]|0;g=a+3|0;n=((p+e|0)+(-(((j&255)<<8)+l|0)|0)|0)+ -8191|0;m=o;j=3;}else{n=((p+e|0)+(-j|0)|0)+(-(l&255)|0)|0;m=o;j=1;}if((((p+e|0)+d|0)+3|0)>(p+10485760|0)){return 0|0;}if((n+ -1|0)<p){return 0|0;}if((t+g|0)<(t+q|0)){a=a+j|0;c=s[t+g|0]&255;g=a+1|0;}else{i=0;}l=m[n+ -1|0]|0;o[p+e|0]=l;if(m.length===o.length&&m===o&&n===(p+e|0)){o[(p+e|0)+1|0]=l;o[(p+e|0)+2|0]=l;e=e+3|0;if((d|0)===0){a=g;break L1;}else{a=d;j=0;while(1){o[(p+e|0)+j|0]=l;a=a-1|0;if((a|0)!==0){j=j+1|0;continue;}break;}e=e+d|0;a=g;break L1;}}else{o[(p+e|0)+1|0]=m[n]|0;o[(p+e|0)+2|0]=m[n+1|0]|0;e=e+3|0;if((d|0)===0){a=g;break L1;}else{a=d;l=0;j=0;while(1){o[(p+e|0)+l|0]=m[(n+2|0)+j|0]|0;a=a-1|0;if((a|0)!==0){l=l+1|0;j=j+1|0;continue;}break;}e=e+d|0;a=g;}}}else{i=c+1|0;if(((p+e|0)+i|0)>(p+10485760|0)){return 0|0;}if(((t+a|0)+i|0)>(t+q|0)){return 0|0;}o[p+e|0]=s[t+a|0]|0;d=a+1|0;j=e+1|0;if((c|0)===0){c=a;a=d;d=c;e=j;}else{i=e;while(1){o[p+j|0]=s[t+d|0]|0;a=a+2|0;c=c-1|0;e=i+2|0;if((c|0)!==0){e=i;g=a;a=d;d=g;i=j;j=e+2|0;continue;}break;}}c=(t+a|0)<(t+q|0)?1:0;i=c?1:0;if(c){c=s[t+a|0]&255;a=d+2|0;}else{c=0;}}if((i|0)!==0){continue;}break;}return (p+e|0)-(p)|0;}function ae(a){}function ad(l,j){var a=0,d=0,g=-0.,i=-0.,c=null,e=null;g=+j.length;i=g<0?-g:g;a=~~(i*ag(2.32830644E-10));c=new Int32Array(4);c[0]=a;d=~~(i%4294967296);c[1]=d;c[2]=(d|0)!==0?a^ -1|0:-a|0;c[3]=-d|0;a=(g<0?c:c)[(g<0?2:0)+1|0]|0;c=new Uint8Array((a+1|0)/1|0);Q(j,0,a,c,0)|0;if((a|0)<65536){a=Q(j,0,a,c,0)|0;}else{a=X(j,0,a,c,0)|0;}new Number((+(a|0)));e=new Uint8Array(a/1|0);if((a|0)!==0){d=0;while(1){e[d]=c[d]|0;d=d+1|0;if((a|0)!==(d|0)){continue;}break;}}a=0;c=e;c=c;+c.BYTES_PER_ELEMENT;if((a|0)===0){return c;}c=c.subarray((+(a>>>0)));return c;}function ac(l,j){var c=0,d=0,g=-0.,i=-0.,a=null,b=0,e=null;g=+j.length;i=g<0?-g:g;c=~~(i*ag(2.32830644E-10));a=new Int32Array(4);a[0]=c;d=~~(i%4294967296);a[1]=d;a[2]=(d|0)!==0?c^ -1|0:-c|0;a[3]=-d|0;b=g<0?2:0;a=g<0?a:a;c=a[b]|0;d=a[b+1|0]|0;a=new Number((+(c>>>0))*4294967296+(+(d>>>0)));a=a.toString(10);a=String(a);a=new Uint8Array(10485760);switch((j[0]&255)>>>5|0){case 1:{c=V(j,0,d,a,0)|0;break;}case 0:{c=W(j,0,d,a,0)|0;break;}default:{c=0;}}e=new Number((+(c|0)));e=e.toString(10);e=new Uint8Array(c/1|0);if((c|0)!==0){d=0;while(1){e[d]=a[d]|0;d=d+1|0;if((c|0)!==(d|0)){continue;}break;}}c=0;a=e;a=a;+a.BYTES_PER_ELEMENT;if((c|0)===0){return a;}a=a.subarray((+(c>>>0)));return a;}function T(){}function G(e,f){var c=0,d=0,a=null,g=null;a=String();c=e[f]|0;if((c&255)===0){a=String(a);return a;}else{d=0;}while(1){g=String.fromCharCode(c<<24>>24);a=a.concat(g);d=d+1|0;c=e[f+d|0]|0;if((c&255)!==0){continue;}break;}a=String(a);return a;}var Z=new Uint8Array([100,101,99,111,100,101,32,115,116,97,114,116,0]);var Y=new Uint8Array([100,101,99,111,100,101,32,101,110,100,0]);function ay(r,s,e,v){for(var i=s;i<e;i++)r[i]=v;return r;}T();var __root =	typeof self === 'object' && self.self === self && self ||	typeof global === 'object' && global.global === global && global ||	this;FastLZDecoder.promise=Promise.resolve();__root.FastLZDecoder = FastLZDecoder;})();

///this is newest


var template = {};
template.VERSION = "0.3";
template.AUTHOR  = "agent.zy";
template.cache   = {};
template.isNode = false;
template.opt_level = 1;

try {
	if(window == null) {
		template.isNode  = true;
	}
} catch (e) {
	template.isNode  = true;
}


template.info = function () {
	if(template.isNode){
		console.log("[info] template engine node v" + template.VERSION);
		console.log("[info] template author " + template.AUTHOR);
	} else {
		console.log("[info] template engine browser v" + template.VERSION);
		console.log("[info] template author " + template.AUTHOR);
	}
}

if(template.isNode) {	
template.trim_r = function (arr) {
	var len = arr.length;
	var tem = [];
	for(var i = 0; i< len; i++){
		if(arr[i] == "\t") {
			continue;
		}
		if(arr[i] == "\n") {
			continue;
		}
		if(arr[i]){
			tem.push(arr[i]);
		}
	}
	return tem;
}

template.invalidate_ipairs =  function (arr) {
	var len  = arr.length;
	var tem  = [];
	var cond = [];
	for(var i = 1; i< len; i++){
		
		if(arr[i] == "in") {
			break;
		}
		
		cond.push(arr[i]);
	}
	var p = cond.join("").split(",");
	tem[0] = arr[0];
	tem[1] = p[0];
	tem[2] = p[1];
	tem[3] = "in";
	tem[4] = arr[3];
	tem[5] = "do";
	return tem;
}

template.invalidate_if =  function (arr) {
	var len  = arr.length;
	var tem  = [];
	var cond = [];
	for(var i = 1; i< len; i++){
		
		if(arr[i] == "do") {
			break;
		}
		
		cond.push(arr[i]);
	}
	tem[0] = arr[0];
	tem[1] = cond.join("");
	tem[2] = "do"
	return tem;
}

template.itor = [
"for",
"foreach",
"ipairs",
"if",
"else",
"end",
"EOL"
]
template.eval    = function (str , context) { 
	var cmds = str.split(" ");
	cmds     = template.trim_r(cmds);
	
	if(cmds.length > 0){
		var cmd = cmds[0];
		
		var exists = template.itor.indexOf(cmd);
		
		if(-1 == exists) {
			return str;
		}
		//console.log(cmds);
		
		switch (cmd) {
			case "if":
				cmds = template.invalidate_if(cmds);
				return  "if "  +  cmds[1] + "{";
			break;
			case "ipairs":
				cmds = template.invalidate_ipairs(cmds);
				var temp=[];
				temp[0]= "var $len = " + cmds[4] + ".length;";
				temp[1]= "for(var " + cmds[1] + "=0; " + cmds[1] + "<$len;" +  cmds[1] + "++){";
				temp[2]= "var " + cmds[2] + "=" + cmds[4] + "["+cmds[1]+"];"
				return (temp.join("\n"));
			break;
			case "else":
				return  "}else{"; 
			break;
			case "for":
				return "for(var "+ cmds[1] +" in " + cmds[3] +") {";
			break;
			case "foreach":
				return "for(var k in " + cmds[3] +") { var "+ cmds[1] +"=" + cmds[3] + "[k];";
			break;
			case "end":
				return "};";
			break;
			case "EOL": //new line 
				return 'tml.push("\\n");';
			break;
		}
	}

	return "";
}
template.macro   = function (v){
  //section
  var macro = template.trim_r(v.split(" "));
  return "section[\"" +macro[0] + "\"] = " + "\"" +macro[1]+ "\"" ;
}


////aot
template.opt_trim2 = function (arr) {
	//console.log("start",arr, arr.length);
	var len = arr.length;
	var temp = [];
	var pushbox=[];
	var str  = "";
	for(var i = 0; i< len; i ++ ) {
		//console.log(i,":", arr[i]);
		
		if(arr[i].indexOf("tml.push") == -1) {
			str += arr[i];
			
			if(pushbox.length > 0) {
				temp.push("tml.push(" + pushbox.join("+")+");");
				pushbox = [];
			}
				
		} else {
		    if(str) {
				temp.push(str);
		    }
		    
			temp.push(arr[i]);
			str ="";
		}
	}
	
	if(str) {
		temp.push(str);
	}
	//console.log("code=", temp, temp.length);
	return temp;
	//return arr;
}

///default opt level is open aot
template.opt_trim = function (arr, empty_check_list, empty_names) { 
	var len  = arr.length;
	var concat_tab = [];
	var head = arr[0];
	var includes = [";"];
	//head ;
	for(var k in empty_names) {
		includes.push("var _" + k + "=" + "data[\"" + k + "\"] || '';");
	}
	includes.unshift(arr[0]);
	arr[0] = includes.join("");
	for(var  i = 0; i< len; i++ ) {
		if(arr[i] == 'tml.push("")') {
			arr.splice(i, 1);
		}
		
		if(arr[i] == 'tml.push(" ")') {
			arr.splice(i, 1);
			continue;
		}
	}
	return arr;
}
	} /// end of node
function utf8Encode (string) {
	var len = string.length;
	var temp= [];
	for(var  i= 0; i< len ; i++ ) {
		temp[i] = string.charCodeAt(i);
	}
	var ff = new Uint8Array(new Uint16Array(temp).buffer);
	return (ff);
}


function utf8Decode(uint8array) {
	var temp = new Uint16Array(uint8array.buffer);
	var str  = "";
	var len  = temp.length;
	for(var i = 0; i< len; i++) {
		str += String.fromCharCode(temp[i]);
	}
	return str;
}

template.load  = function (path, initDone) {
	if(template.isNode) {
		var fs  = require("fs");
		if(fs.existsSync(path)){ ///exists
			var buff = fs.readFileSync(path);
			template.init (buff);
		}
	} else {
		var oReq  		  = new XMLHttpRequest();
      	oReq.responseType = "arraybuffer";
      	oReq.onreadystatechange=state_Change;
      	function state_Change() {
	        if (oReq.readyState==4) {// 4 = "loaded"
				var buff = new Uint8Array(oReq.response);
				template.init (buff);
				
				if(initDone != null) {
					initDone();
				}
	        }
	    }
	    oReq.open("GET",  path, true);
	    oReq.send(null);
	}
}

template.render = function (hashcode, data) {
	if(template.cache[hashcode]) {
		return template.cache[hashcode](data);
	}
}

template.init  = function (buff) {
	if(buff[0] == 0x50 && buff[1] == 0x4B){
		var pos = 0;
		var  len    = buff[2];
		pos = len + 3;
		var  tmp    = buff.subarray(3, 3+len);
		var  offset = [] ;
		for(var i = 0; i< len; i++){
			offset[i] = tmp[i];
		}
		var  meta_len = Number(offset.join(""));
		var  meta_b   = buff.subarray(pos, pos+meta_len);
		pos += meta_len;
		var  json_meta = utf8Decode(new Uint8Array(meta_b));
		
		try {
			
			var m = JSON.parse(json_meta);
			//编译
			for(var k in m) {
				var encoder = new FastLZDecoder();
				var raw     = encoder.decode(new Uint8Array(buff.subarray(pos+m[k].s,
											 pos+m[k].s+m[k].e)));
				var str     = utf8Decode(raw);
				//console.log(str);
				var hashcode= k;
				var func = new Function(str);
				if(hashcode) {
					template.cache[hashcode] = func;
				}
			}
		}catch (e) {
			console.log("[error] parse meta error", e);
		}
	} else {
		console.log("[error] file is bad .");
	}
}
if(template.isNode) { 
template.precompile  = function (path, out ,ext) {
	if(template.isNode) {
		if(!ext) {
			ext =".html";
		}
		var fs  = require("fs");
		
		if(fs.existsSync(path)){
			var buff = new Uint8Array(1024*1024* 10);
			var arr  = fs.readdirSync(path);
			var temp = [];
			var len  = arr.length;
			if(ext && len > 0) {
				for(var i  = 0; i< len;i ++) {
					if(arr[i].indexOf(ext) != -1){
						var str	     = fs.readFileSync(arr[i]).toString("utf8");
						var subcodes = template.compile(str, "", false, true);
						codes        = utf8Encode(subcodes);
						var encoder  = new FastLZDecoder();
						var bytes    = encoder.encode(codes);
						
						temp.push({b:bytes, k:arr[i]});
					}
				}
				
				var pos = 0;
				var queue = [];
				var hash  = {};
				for(var i = 0; i < temp.length; i++ ) {
					queue.push(pos);
					hash[temp[i].k] = {
						s:pos,
						e:temp[i].b.length
					}
					
					//console.log(queue);
					buff.set(temp[i].b, pos);
					pos += temp[i].b.length;
				}
				
				buff= buff.slice(0, pos);
				var buff_l = buff.length;
				///meta
				var meta   = JSON.stringify(hash);
				var meta_b = utf8Encode(meta);
				var meta_l = meta_b.length;
				
				//header 
				
				var arr      = meta_l.toString().split("");	
				var eax      = arr.length;
				var header_b = new Uint8Array(3+arr.length);
				header_b [0] = 0x50;
				header_b [1] = 0x4B;
				header_b [2] = Number(eax);
				//console.log(arr);
				for(var i =0 ;i< eax; i++){
					header_b[3+i] = Number(arr[i]) >> 0;
				}
				
				var size_t = header_b.length + meta_l + buff_l;
				
				var nbuff = new Uint8Array(size_t);
				nbuff.set(header_b, 0);
				nbuff.set(meta_b, header_b.length);
				nbuff.set(buff  , header_b.length + meta_l);
				//console.log(nbuff);
				fs.writeFileSync(out, nbuff, "utf8");
			}
		}
	} else {
		console.log("[error] browser is not implements.");
	}
}
} //end of node
template.compile = function (view, hashcode, inline, strexports) {
	if(!hashcode) {
		var hashcode = 0;
		//console.error("[warn]compile prototype (string, hashcode) hashcode reuire");
	}
	
	if(template.cache[hashcode]){ ///cache code
		return template.cache[hashcode];
	}
	
	var tok_l  = "{";
    var tok_r  = "}";
	
	///
	view = view.replace(/\n/g, "\\n");
	view = view.replace(/\t/g, "");
	view = view.replace(/\r/g, "");
	view = view.replace(/\"/g, "'");
	
	var len   = view.length;
	var codes = [];
	if(inline) {
		codes = [];
	} else {
		codes = [
		"var tml=[];var data =arguments[0] || {};"
		];
	}
	var hasMacro = false;
	var stack = [];
	var line  = '';
	var last  = 0;
	var c     = '';
	var empty_check_list = {};
	var empty_names  = {};
    for ( var i = 0; i < len; i ++ ) {
      c = view.charAt(i);
	  if(c == tok_l) {
		var look_at_after = view.charAt(i+1);
		
		switch (look_at_after) {
			case "{" :
			case "-" :
			case "*" :
			case "%" :
			case "#" :
			case "(" :
			codes.push("tml.push(\"" + line +"\")");
			stack.push(i + 2);
			last = i ;
			line = "";
			break;
		}
	  }
	  
	  if(c == tok_r) {
		var look_at_after = view.charAt(i-1);
		
		switch (look_at_after) {
			case "}":
				var j = stack.pop();
				if(j) {
					var k = view.substring(j, i - 1);
					var v = "tml.push(data[\"" + k +"\"]);";
					codes.push("tml.push(_" + k + ");");
					line = "";
					last = i + 2;
					empty_check_list[v] = 1;
					empty_names[k] = 1;
				}
			break;
			case "*":
				var j = stack.pop();
				if(j) {
					var k = view.substring(j, i - 1);
					codes.push("tml.push("+k+");");
					line = "";
					last = i + 2;
				}
			break;
			case "%":
				var j = stack.pop();
				if(j) {
					var k = view.substring(j, i - 1);
					codes.push(template.eval(k));
					line = "";
					last = i + 2;
				}
			break;
			case "-": //macro
				var j = stack.pop();
				if(j) {
					var k = view.substring(j, i - 1);
					codes.push("var section={};");
					codes.push("var domacro=function(v){for(var k in section){v=v.replace(new RegExp(k,'g'),section[k]);}return v;};");
					codes.push(template.macro(k));
					line = "";
					last = i + 2;
					hasMacro = true;
				}
			break;
			case ")" : //include
				if(template.isNode) {
					var j = stack.pop();
					if(j) {
						var k = view.substring(j, i - 1);
						line = "";
						last = i + 2;
						if(!template.cache[k]) {
							///read and compile
							var fs  = require("fs");
							if(fs.existsSync(k)){ ///exists
								var str	  = fs.readFileSync(k).toString("utf8");
								var subcodes = template.compile(str , k, true);
								codes = codes.concat(subcodes);
							} else {
								codes.push("tml.push('[error] "+ k +" is not include.');");
							}
						}
					} 
				} else {
					console.log("not implements");
				}
			break;
			case "#":
				line = "";
				last = i + 2;
			break;
		}
		continue;
	  }
	  
	  if( i == len -1) {
		codes.push("tml.push(\"" + view.substring(last - 1, len) +"\");");
	  }
	  line += c;
    }
	
	if(template.opt_level > 0) {
		codes = template.opt_trim(codes, empty_check_list, empty_names);
	}
	
	if(inline) {
		return codes;
	}
	
	if(hasMacro) {
		codes.push("return domacro(tml.join(''));");
	} else {
		codes.push("return tml.join('');");
	}
	
	if(strexports) {
		var exports_str = codes.join("\n");
		return exports_str;
	}
	//console.log("codes length=", codes.length);
	//console.log(codes);
	codes = template.opt_trim2(codes);
	try {
		var code_str = codes.join("\n");
		var func = new Function(code_str);
		template.cache[hashcode] = func;
	} catch (e) {
		console.log("[error] syntax error " + e);
	}
	return func;
}



if (template.isNode){
	exports.template  = template;
} else {
	window.template   = template;
}


