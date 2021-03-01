"use strict";
/*Compiled using Cheerp (R) by Leaning Technologies Ltd*/
var __imul=Math.imul;
var __fround=Math.fround;
var oSlot=0;var nullArray=[null];var nullObj={d:nullArray,o:0};
function __Z7webMainv(){
	console.log(_cheerpCreate_ZN6client6StringC2EPKc());
	_vm_exec();
}
function _vm_exec(){
	var LmergedArray=null,L$p06=0,L$p034=0,L$p053=0;
	LmergedArray=new Int32Array(32);
	L$p06=_loop[0]|0;
	L$p053=-1;
	L$p034=1;
	a:while(1){
		b:{
			switch(L$p06|0){
				case 0:
				L$p06=_loop[L$p034]|0;
				break b;
				case 16:
				break a;
				case 11:
				L$p053=L$p053+1|0;
				LmergedArray[L$p053]=LmergedArray[16+(_loop[L$p034]|0)|0]|0;
				L$p034=L$p034+1|0;
				break;
				case 13:
				LmergedArray[16+(_loop[L$p034]|0)|0]=LmergedArray[L$p053]|0;
				L$p034=L$p034+1|0;
				L$p053=L$p053-1|0;
				break;
				case 9:
				L$p053=L$p053+1|0;
				LmergedArray[L$p053]=_loop[L$p034]|0;
				L$p034=L$p034+1|0;
				break;
				case 1:
				L$p06=L$p053-1|0;
				LmergedArray[L$p06]=(LmergedArray[L$p06]|0)+(LmergedArray[L$p053]|0)|0;
				L$p053=L$p06;
				break;
				case 2:
				L$p06=L$p053-1|0;
				LmergedArray[L$p06]=(LmergedArray[L$p06]|0)-(LmergedArray[L$p053]|0)|0;
				L$p053=L$p06;
				break;
				case 3:
				L$p06=L$p053-1|0;
				LmergedArray[L$p06]=__imul(LmergedArray[L$p06]|0,LmergedArray[L$p053]|0)|0;
				L$p053=L$p06;
				break;
				case 4:
				L$p06=L$p053-1|0;
				LmergedArray[L$p06]=(LmergedArray[L$p06]|0)<(LmergedArray[L$p053]|0)?1:0;
				L$p053=L$p06;
				break;
				case 5:
				L$p06=L$p053-1|0;
				LmergedArray[L$p06]=(LmergedArray[L$p06]|0)===(LmergedArray[L$p053]|0)?1:0;
				L$p053=L$p06;
				break;
				case 6:
				L$p034=_loop[L$p034]|0;
				break;
				case 7:
				L$p06=L$p053-1|0;
				if((LmergedArray[L$p053]|0)===1){
					L$p034=_loop[L$p034]|0;
					L$p053=L$p06;
					break;
				}
				L$p034=L$p034+1|0;
				L$p053=L$p06;
				break;
				case 8:
				L$p06=L$p053-1|0;
				if((LmergedArray[L$p053]|0)!==0){
					L$p034=L$p034+1|0;
					L$p053=L$p06;
					break;
				}
				L$p034=_loop[L$p034]|0;
				L$p053=L$p06;
				break;
				case 10:
				L$p053=L$p053+1|0;
				LmergedArray[L$p053]=LmergedArray[(_loop[L$p034]|0)-1|0]|0;
				L$p034=L$p034+1|0;
				break;
				case 12:
				LmergedArray[(_loop[L$p034]|0)-1|0]=LmergedArray[L$p053]|0;
				L$p034=L$p034+1|0;
				L$p053=L$p053-1|0;
				break;
				case 14:
				_iprintf(_$pstr,0,LmergedArray[L$p053]|0)|0;
				L$p053=L$p053-1|0;
				break;
				case 15:
				L$p053=L$p053-1|0;
				break;
				default:
				_iprintf(_$pstr$p1,0,L$p06,L$p034-1|0)|0;
				_exit();
			}
			L$p06=_loop[L$p034]|0;
		}
		if((L$p034|0)<99){
			L$p034=L$p034+1|0;
			continue a;
		}
		break;
	}
	__ZL13vm_print_dataPii(LmergedArray,16,2);
}
function __ZL13vm_print_dataPii(Larg0,Marg0,Larg1){
	var tmp0=null,tmp1=null,tmp2=0,Lmergedinsert$pi$pi=0,tmp4=null,tmp4o=0,Lgeptoindexphi2=0,Lgeptoindexphi16=0,tmp7=0,Lgeptoindexphi49=0,Lgeptoindexphi37=0,L$poptgep79$poptgep83$poptgepsqueezed=null,L$poptgep79$poptgep83$poptgepsqueezedo=0,Lgeptoindexphi25=0,Lgeptoindexphi33=0,L$poptgep79$poptgep85$poptgepsqueezed=null,L$poptgep79$poptgep85$poptgepsqueezedo=0,L$poptgep79$poptgep88$poptgepsqueezed=null,L$poptgep79$poptgep88$poptgepsqueezedo=0;
	tmp0=[{a0:_str,i1:12},{a0:_$pstr$p416,i1:1}];
	if((_impure_data.i6|0)===0)___sinit(_impure_data);
	tmp1=_impure_data.a2;
	Lmergedinsert$pi$pi=tmp1.i3|0;
	if((Lmergedinsert$pi$pi&8192|0)===0){
		Lmergedinsert$pi$pi|=8192;
		tmp1.i3=Lmergedinsert$pi$pi;
		tmp1.i21=tmp1.i21& -8193;
	}
	a:{
		b:{
			if((Lmergedinsert$pi$pi&8|0)!==0){
				tmp4o=tmp1.a4.a0o;
				tmp4=tmp1.a4.a0;
				if(tmp4!==nullArray||tmp4o!==0)break b;
			}
			if((___swsetup_r(_impure_data,tmp1)|0|0)!==0)break a;
			Lmergedinsert$pi$pi=tmp1.i3|0;
		}
		Lmergedinsert$pi$pi=Lmergedinsert$pi$pi<<16>>16;
		b:if((Lmergedinsert$pi$pi&2|0)!==0){
			Lgeptoindexphi16=0;
			tmp4o=0;
			tmp4=nullArray;
			Lgeptoindexphi2=0;
			Lmergedinsert$pi$pi=13;
			while(1){
				if((Lgeptoindexphi16|0)===0){
					while(1){
						Lgeptoindexphi16=tmp0[Lgeptoindexphi2].i1|0;
						if((Lgeptoindexphi16|0)===0){
							Lgeptoindexphi2=Lgeptoindexphi2+1|0;
							continue;
						}
						break;
					}
					tmp4=tmp0[Lgeptoindexphi2].a0;
					tmp4o=0;
					tmp4=tmp4;
					Lgeptoindexphi2=Lgeptoindexphi2+1|0;
				}
				tmp7=tmp1.a9(_impure_data,tmp1.a7,tmp4,tmp4o,Lgeptoindexphi16>>>0<2147482624?Lgeptoindexphi16|0:2147482624|0)|0;
				if((tmp7|0)>=1){
					Lmergedinsert$pi$pi=Lmergedinsert$pi$pi-tmp7|0;
					if((Lmergedinsert$pi$pi|0)===0)break a;
					tmp4o=tmp4o+tmp7|0;
					tmp4=tmp4;
					Lgeptoindexphi16=Lgeptoindexphi16-tmp7|0;
					continue;
				}
				break;
			}
		}else if((Lmergedinsert$pi$pi&1|0)!==0){
			Lgeptoindexphi2=0;
			tmp4o=0;
			tmp4=nullArray;
			Lgeptoindexphi16=0;
			Lgeptoindexphi49=0;
			tmp7=0;
			Lmergedinsert$pi$pi=13;
			while(1){
				c:{
					if((Lgeptoindexphi2|0)!==0){
						if((tmp7|0)!==0)break c;
					}else{
						while(1){
							Lgeptoindexphi2=tmp0[Lgeptoindexphi16].i1|0;
							if((Lgeptoindexphi2|0)===0){
								Lgeptoindexphi16=Lgeptoindexphi16+1|0;
								continue;
							}
							break;
						}
						tmp4=tmp0[Lgeptoindexphi16].a0;
						tmp4o=0;
						tmp4=tmp4;
						Lgeptoindexphi16=Lgeptoindexphi16+1|0;
					}
					tmp7=Lgeptoindexphi2;
					L$poptgep79$poptgep83$poptgepsqueezedo=tmp4o;
					L$poptgep79$poptgep83$poptgepsqueezed=tmp4;
					while(1){
						if((L$poptgep79$poptgep83$poptgepsqueezed[L$poptgep79$poptgep83$poptgepsqueezedo]&255)===10){
							if(L$poptgep79$poptgep83$poptgepsqueezed!==nullArray||L$poptgep79$poptgep83$poptgepsqueezedo!==0){
								Lgeptoindexphi49=(L$poptgep79$poptgep83$poptgepsqueezedo+1|0)-(tmp4o)|0;
								tmp7=1;
								break c;
							}
						}else{
							tmp7=tmp7-1|0;
							if((tmp7|0)!==0){
								L$poptgep79$poptgep83$poptgepsqueezedo=L$poptgep79$poptgep83$poptgepsqueezedo+1|0;
								L$poptgep79$poptgep83$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed;
								continue;
							}
						}
						break;
					}
					Lgeptoindexphi49=Lgeptoindexphi2+1|0;
					tmp7=1;
				}
				Lgeptoindexphi37=Lgeptoindexphi2>>>0<Lgeptoindexphi49>>>0?Lgeptoindexphi2|0:Lgeptoindexphi49|0;
				L$poptgep79$poptgep83$poptgepsqueezed=tmp1.a4;
				Lgeptoindexphi25=L$poptgep79$poptgep83$poptgepsqueezed.i1|0;
				Lgeptoindexphi33=Lgeptoindexphi25+(tmp1.i2|0)|0;
				L$poptgep79$poptgep85$poptgepsqueezedo=tmp1.a0o;
				L$poptgep79$poptgep85$poptgepsqueezed=tmp1.a0;
				L$poptgep79$poptgep83$poptgepsqueezedo=L$poptgep79$poptgep83$poptgepsqueezed.a0o;
				L$poptgep79$poptgep83$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed.a0;
				tmp2=L$poptgep79$poptgep85$poptgepsqueezedo>L$poptgep79$poptgep83$poptgepsqueezedo?1:0;
				c:{
					if((Lgeptoindexphi37|0)>(Lgeptoindexphi33|0))if(tmp2){
						if((Lgeptoindexphi33|0)!==0)if(tmp4o<L$poptgep79$poptgep85$poptgepsqueezedo){
							Lgeptoindexphi25=Lgeptoindexphi33;
							Lgeptoindexphi37=0;
							while(1){
								Lgeptoindexphi37=Lgeptoindexphi37-1|0;
								Lgeptoindexphi25=Lgeptoindexphi25-1|0;
								L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi25|0]=tmp4[(tmp4o+Lgeptoindexphi33|0)+Lgeptoindexphi37|0]|0;
								if(L$poptgep79$poptgep85$poptgepsqueezed!==L$poptgep79$poptgep85$poptgepsqueezed||L$poptgep79$poptgep85$poptgepsqueezedo!==(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi25|0))continue;
								break;
							}
						}else{
							L$poptgep79$poptgep83$poptgepsqueezedo=tmp4o;
							L$poptgep79$poptgep83$poptgepsqueezed=tmp4;
							Lgeptoindexphi37=0;
							while(1){
								L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi37|0]=L$poptgep79$poptgep83$poptgepsqueezed[L$poptgep79$poptgep83$poptgepsqueezedo]|0;
								Lgeptoindexphi37=Lgeptoindexphi37+1|0;
								if(L$poptgep79$poptgep85$poptgepsqueezed!==L$poptgep79$poptgep85$poptgepsqueezed||(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi33|0)!==(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi37|0)){
									L$poptgep79$poptgep83$poptgepsqueezedo=L$poptgep79$poptgep83$poptgepsqueezedo+1|0;
									L$poptgep79$poptgep83$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed;
									continue;
								}
								break;
							}
						}
						L$poptgep79$poptgep85$poptgepsqueezedo=tmp1.a0o;
						L$poptgep79$poptgep85$poptgepsqueezed=tmp1.a0;
						tmp1.a0=L$poptgep79$poptgep85$poptgepsqueezed;
						tmp1.a0o=L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi33|0;
						if((__fflush_r(_impure_data,tmp1)|0|0)!==0)break b;
						break c;
					}
					if((Lgeptoindexphi37|0)<(Lgeptoindexphi25|0)){
						if((Lgeptoindexphi37|0)!==0)if(tmp4o<L$poptgep79$poptgep85$poptgepsqueezedo){
							Lgeptoindexphi33=Lgeptoindexphi37;
							Lgeptoindexphi25=0;
							while(1){
								Lgeptoindexphi25=Lgeptoindexphi25-1|0;
								Lgeptoindexphi33=Lgeptoindexphi33-1|0;
								L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi33|0]=tmp4[(tmp4o+Lgeptoindexphi37|0)+Lgeptoindexphi25|0]|0;
								if(L$poptgep79$poptgep85$poptgepsqueezed!==L$poptgep79$poptgep85$poptgepsqueezed||L$poptgep79$poptgep85$poptgepsqueezedo!==(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi33|0))continue;
								break;
							}
						}else{
							L$poptgep79$poptgep83$poptgepsqueezedo=tmp4o;
							L$poptgep79$poptgep83$poptgepsqueezed=tmp4;
							Lgeptoindexphi25=0;
							while(1){
								L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi25|0]=L$poptgep79$poptgep83$poptgepsqueezed[L$poptgep79$poptgep83$poptgepsqueezedo]|0;
								Lgeptoindexphi25=Lgeptoindexphi25+1|0;
								if(L$poptgep79$poptgep85$poptgepsqueezed!==L$poptgep79$poptgep85$poptgepsqueezed||(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi37|0)!==(L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi25|0)){
									L$poptgep79$poptgep83$poptgepsqueezedo=L$poptgep79$poptgep83$poptgepsqueezedo+1|0;
									L$poptgep79$poptgep83$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed;
									continue;
								}
								break;
							}
						}
						tmp1.i2=(tmp1.i2|0)-Lgeptoindexphi37|0;
						L$poptgep79$poptgep85$poptgepsqueezedo=tmp1.a0o;
						L$poptgep79$poptgep85$poptgepsqueezed=tmp1.a0;
						tmp1.a0=L$poptgep79$poptgep85$poptgepsqueezed;
						tmp1.a0o=L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi37|0;
						Lgeptoindexphi33=Lgeptoindexphi37;
					}else{
						Lgeptoindexphi33=tmp1.a9(_impure_data,tmp1.a7,tmp4,tmp4o,Lgeptoindexphi25)|0;
						if((Lgeptoindexphi33|0)<1)break b;
					}
				}
				Lgeptoindexphi49=Lgeptoindexphi49-Lgeptoindexphi33|0;
				if((Lgeptoindexphi49|0)===0){
					if((__fflush_r(_impure_data,tmp1)|0|0)!==0)break b;
					tmp7=0;
				}
				Lmergedinsert$pi$pi=Lmergedinsert$pi$pi-Lgeptoindexphi33|0;
				if((Lmergedinsert$pi$pi|0)===0)break a;
				tmp4o=tmp4o+Lgeptoindexphi33|0;
				tmp4=tmp4;
				Lgeptoindexphi2=Lgeptoindexphi2-Lgeptoindexphi33|0;
				continue;
			}
		}else{
			Lgeptoindexphi16=0;
			tmp4o=0;
			tmp4=nullArray;
			Lgeptoindexphi2=0;
			Lmergedinsert$pi$pi=13;
			while(1){
				if((Lgeptoindexphi16|0)===0){
					while(1){
						Lgeptoindexphi16=tmp0[Lgeptoindexphi2].i1|0;
						if((Lgeptoindexphi16|0)===0){
							Lgeptoindexphi2=Lgeptoindexphi2+1|0;
							continue;
						}
						break;
					}
					tmp4=tmp0[Lgeptoindexphi2].a0;
					tmp4o=0;
					tmp4=tmp4;
					Lgeptoindexphi2=Lgeptoindexphi2+1|0;
				}
				tmp7=tmp1.i2|0;
				Lgeptoindexphi49=tmp1.i3<<16>>16;
				c:if((Lgeptoindexphi49&512|0)!==0){
					L$poptgep79$poptgep83$poptgepsqueezedo=tmp1.a0o;
					L$poptgep79$poptgep83$poptgepsqueezed=tmp1.a0;
					if(Lgeptoindexphi16>>>0>=tmp7>>>0)if((Lgeptoindexphi49&1152|0)!==0){
						L$poptgep79$poptgep88$poptgepsqueezed=tmp1.a4;
						L$poptgep79$poptgep85$poptgepsqueezedo=L$poptgep79$poptgep88$poptgepsqueezed.a0o;
						L$poptgep79$poptgep85$poptgepsqueezed=L$poptgep79$poptgep88$poptgepsqueezed.a0;
						tmp7=(L$poptgep79$poptgep83$poptgepsqueezedo)-(L$poptgep79$poptgep85$poptgepsqueezedo)|0;
						Lgeptoindexphi37=(Lgeptoindexphi16+1|0)+tmp7|0;
						Lgeptoindexphi25=(__imul(L$poptgep79$poptgep88$poptgepsqueezed.i1|0,3)|0)/2|0;
						Lgeptoindexphi25=Lgeptoindexphi25>>>0<Lgeptoindexphi37>>>0?Lgeptoindexphi37|0:Lgeptoindexphi25|0;
						if((Lgeptoindexphi49&1024|0)!==0){
							L$poptgep79$poptgep83$poptgepsqueezed=new Uint8Array(Lgeptoindexphi25/1|0);
							if(L$poptgep79$poptgep83$poptgepsqueezed===nullArray&&0===0){
								_impure_data.i0=12;
								break b;
							}
							if((tmp7|0)!==0){
								L$poptgep79$poptgep85$poptgepsqueezedo=L$poptgep79$poptgep88$poptgepsqueezed.a0o;
								L$poptgep79$poptgep85$poptgepsqueezed=L$poptgep79$poptgep88$poptgepsqueezed.a0;
								Lgeptoindexphi37=0;
								Lgeptoindexphi49=0;
								while(1){
									L$poptgep79$poptgep83$poptgepsqueezed[Lgeptoindexphi37]=L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo+Lgeptoindexphi49|0]|0;
									Lgeptoindexphi37=Lgeptoindexphi37+1|0;
									if(L$poptgep79$poptgep83$poptgepsqueezed!==L$poptgep79$poptgep83$poptgepsqueezed||(0+tmp7|0)!==(0+Lgeptoindexphi37|0)){
										Lgeptoindexphi49=Lgeptoindexphi49+1|0;
										continue;
									}
									break;
								}
							}
							tmp1.i3=tmp1.i3& -1153|128;
						}else{
							if(L$poptgep79$poptgep85$poptgepsqueezed!==nullArray||L$poptgep79$poptgep85$poptgepsqueezedo!==0){
								L$poptgep79$poptgep83$poptgepsqueezed=(function(){var __old__=L$poptgep79$poptgep85$poptgepsqueezed;
									var __ret__=new Uint8Array(Lgeptoindexphi25/1|0);
									__ret__.set(__old__.subarray(0, Math.min(__ret__.length,__old__.length)));
									return __ret__;})();
							}else{
								L$poptgep79$poptgep83$poptgepsqueezed=new Uint8Array(Lgeptoindexphi25/1|0);
							}
							if(L$poptgep79$poptgep83$poptgepsqueezed===nullArray&&0===0){
								tmp1.i3=tmp1.i3& -129;
								_impure_data.i0=12;
								break b;
							}
						}
						L$poptgep79$poptgep88$poptgepsqueezed.a0=L$poptgep79$poptgep83$poptgepsqueezed;
						L$poptgep79$poptgep88$poptgepsqueezed.a0o=0;
						tmp1.a0=L$poptgep79$poptgep83$poptgepsqueezed;
						tmp1.a0o=0+tmp7|0;
						L$poptgep79$poptgep88$poptgepsqueezed.i1=Lgeptoindexphi25;
						tmp1.i2=Lgeptoindexphi25-tmp7|0;
						L$poptgep79$poptgep83$poptgepsqueezedo=0+tmp7|0;
						L$poptgep79$poptgep83$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed;
						tmp7=Lgeptoindexphi16;
					}
					tmp7=Lgeptoindexphi16>>>0<tmp7>>>0?Lgeptoindexphi16|0:tmp7|0;
					if((tmp7|0)!==0)if(tmp4o<L$poptgep79$poptgep83$poptgepsqueezedo){
						Lgeptoindexphi37=0;
						Lgeptoindexphi49=0;
						while(1){
							Lgeptoindexphi49=Lgeptoindexphi49-1|0;
							Lgeptoindexphi37=Lgeptoindexphi37-1|0;
							L$poptgep79$poptgep83$poptgepsqueezed[(L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0)+Lgeptoindexphi37|0]=tmp4[(tmp4o+tmp7|0)+Lgeptoindexphi49|0]|0;
							if(L$poptgep79$poptgep83$poptgepsqueezed!==L$poptgep79$poptgep83$poptgepsqueezed||L$poptgep79$poptgep83$poptgepsqueezedo!==((L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0)+Lgeptoindexphi37|0))continue;
							break;
						}
					}else{
						L$poptgep79$poptgep85$poptgepsqueezedo=tmp4o;
						L$poptgep79$poptgep85$poptgepsqueezed=tmp4;
						L$poptgep79$poptgep88$poptgepsqueezedo=L$poptgep79$poptgep83$poptgepsqueezedo;
						L$poptgep79$poptgep88$poptgepsqueezed=L$poptgep79$poptgep83$poptgepsqueezed;
						while(1){
							L$poptgep79$poptgep88$poptgepsqueezed[L$poptgep79$poptgep88$poptgepsqueezedo]=L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo]|0;
							if(L$poptgep79$poptgep83$poptgepsqueezed!==L$poptgep79$poptgep88$poptgepsqueezed||(L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0)!==(L$poptgep79$poptgep88$poptgepsqueezedo+1|0)){
								L$poptgep79$poptgep85$poptgepsqueezedo=L$poptgep79$poptgep85$poptgepsqueezedo+1|0;
								L$poptgep79$poptgep85$poptgepsqueezed=L$poptgep79$poptgep85$poptgepsqueezed;
								L$poptgep79$poptgep88$poptgepsqueezedo=L$poptgep79$poptgep88$poptgepsqueezedo+1|0;
								L$poptgep79$poptgep88$poptgepsqueezed=L$poptgep79$poptgep88$poptgepsqueezed;
								continue;
							}
							break;
						}
					}
					tmp1.i2=(tmp1.i2|0)-tmp7|0;
					L$poptgep79$poptgep83$poptgepsqueezedo=tmp1.a0o;
					L$poptgep79$poptgep83$poptgepsqueezed=tmp1.a0;
					tmp1.a0=L$poptgep79$poptgep83$poptgepsqueezed;
					tmp1.a0o=L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0;
					tmp7=Lgeptoindexphi16;
				}else{
					L$poptgep79$poptgep83$poptgepsqueezedo=tmp1.a0o;
					L$poptgep79$poptgep83$poptgepsqueezed=tmp1.a0;
					L$poptgep79$poptgep85$poptgepsqueezed=tmp1.a4;
					L$poptgep79$poptgep88$poptgepsqueezedo=L$poptgep79$poptgep85$poptgepsqueezed.a0o;
					L$poptgep79$poptgep88$poptgepsqueezed=L$poptgep79$poptgep85$poptgepsqueezed.a0;
					if(L$poptgep79$poptgep83$poptgepsqueezedo<=L$poptgep79$poptgep88$poptgepsqueezedo){
						Lgeptoindexphi49=L$poptgep79$poptgep85$poptgepsqueezed.i1|0;
						if(Lgeptoindexphi16>>>0>=Lgeptoindexphi49>>>0){
							tmp7=Lgeptoindexphi16>>>0<2147483647?Lgeptoindexphi16|0:2147483647|0;
							tmp7=tmp1.a9(_impure_data,tmp1.a7,tmp4,tmp4o,tmp7-((tmp7|0)%(Lgeptoindexphi49|0)|0)|0)|0;
							if((tmp7|0)<1)break b;
							break c;
						}
					}
					tmp7=Lgeptoindexphi16>>>0<tmp7>>>0?Lgeptoindexphi16|0:tmp7|0;
					if((tmp7|0)!==0)if(tmp4o<L$poptgep79$poptgep83$poptgepsqueezedo){
						Lgeptoindexphi37=tmp7;
						Lgeptoindexphi49=0;
						while(1){
							Lgeptoindexphi49=Lgeptoindexphi49-1|0;
							Lgeptoindexphi37=Lgeptoindexphi37-1|0;
							L$poptgep79$poptgep83$poptgepsqueezed[L$poptgep79$poptgep83$poptgepsqueezedo+Lgeptoindexphi37|0]=tmp4[(tmp4o+tmp7|0)+Lgeptoindexphi49|0]|0;
							if(L$poptgep79$poptgep83$poptgepsqueezed!==L$poptgep79$poptgep83$poptgepsqueezed||L$poptgep79$poptgep83$poptgepsqueezedo!==(L$poptgep79$poptgep83$poptgepsqueezedo+Lgeptoindexphi37|0))continue;
							break;
						}
					}else{
						L$poptgep79$poptgep85$poptgepsqueezedo=tmp4o;
						L$poptgep79$poptgep85$poptgepsqueezed=tmp4;
						Lgeptoindexphi49=0;
						while(1){
							L$poptgep79$poptgep83$poptgepsqueezed[L$poptgep79$poptgep83$poptgepsqueezedo+Lgeptoindexphi49|0]=L$poptgep79$poptgep85$poptgepsqueezed[L$poptgep79$poptgep85$poptgepsqueezedo]|0;
							Lgeptoindexphi49=Lgeptoindexphi49+1|0;
							if(L$poptgep79$poptgep83$poptgepsqueezed!==L$poptgep79$poptgep83$poptgepsqueezed||(L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0)!==(L$poptgep79$poptgep83$poptgepsqueezedo+Lgeptoindexphi49|0)){
								L$poptgep79$poptgep85$poptgepsqueezedo=L$poptgep79$poptgep85$poptgepsqueezedo+1|0;
								L$poptgep79$poptgep85$poptgepsqueezed=L$poptgep79$poptgep85$poptgepsqueezed;
								continue;
							}
							break;
						}
					}
					Lgeptoindexphi49=(tmp1.i2|0)-tmp7|0;
					tmp1.i2=Lgeptoindexphi49;
					L$poptgep79$poptgep83$poptgepsqueezedo=tmp1.a0o;
					L$poptgep79$poptgep83$poptgepsqueezed=tmp1.a0;
					tmp1.a0=L$poptgep79$poptgep83$poptgepsqueezed;
					tmp1.a0o=L$poptgep79$poptgep83$poptgepsqueezedo+tmp7|0;
					if((Lgeptoindexphi49|0)===0)if((__fflush_r(_impure_data,tmp1)|0|0)!==0)break b;
				}
				Lmergedinsert$pi$pi=Lmergedinsert$pi$pi-tmp7|0;
				if((Lmergedinsert$pi$pi|0)===0)break a;
				tmp4o=tmp4o+tmp7|0;
				tmp4=tmp4;
				Lgeptoindexphi16=Lgeptoindexphi16-tmp7|0;
				continue;
			}
		}
		tmp1.i3=tmp1.i3|64;
	}
	if((Larg1|0)>0){
		Lmergedinsert$pi$pi=0;
		while(1){
			_iprintf(_$pstr$p4,0,Lmergedinsert$pi$pi,Larg0[Marg0+Lmergedinsert$pi$pi|0]|0)|0;
			Lmergedinsert$pi$pi=Lmergedinsert$pi$pi+1|0;
			if((Lmergedinsert$pi$pi|0)!==(Larg1|0))continue;
			break;
		}
	}
}
function __fflush_r(Larg0,Larg1){
	var tmp0=null,tmp0o=0;
	tmp0o=Larg1.a4.a0o;
	tmp0=Larg1.a4.a0;
	if(tmp0!==nullArray||tmp0o!==0){
		if(Larg0!==null)if((Larg0.i6|0)===0)___sinit(Larg0);
		if(Larg1===___sf_fake_stdin){
			tmp0=Larg0.a1;
		}else if(Larg1===___sf_fake_stdout){
			tmp0=Larg0.a2;
		}else if(Larg1===___sf_fake_stderr){
			tmp0=Larg0.a3;
		}else{
			tmp0=Larg1;
		}
		if((tmp0.i3&65535)!==0)return ___sflush_r(Larg0,tmp0)|0|0;
		return 0|0;
	}
	return 0|0;
}
function ___sflush_r(Larg0,Larg1){
	var tmp0=null,tmp0o=0,tmp1=null,tmp1o=0,tmp2=0,Lgeptoindexphi=0,L$poptgep$poptgep25$poptgepsqueezed=null,L$poptgep$poptgep25$poptgepsqueezedo=0,tmp5=0;
	tmp2=Larg1.i3|0;
	Lgeptoindexphi=tmp2<<16>>16;
	if((Lgeptoindexphi&8|0)===0){
		Larg1.i3=tmp2|2048;
		if((Larg1.i1|0)<=0)if((Larg1.i14|0)<=0)return 0|0;
		L$poptgep$poptgep25$poptgepsqueezed=Larg1.a10;
		if(L$poptgep$poptgep25$poptgepsqueezed!==null){
			Lgeptoindexphi=Larg0.i0|0;
			Larg0.i0=0;
			a:if((tmp2&4096|0)!==0){
				tmp2=Larg1.i18|0;
			}else{
				tmp2=L$poptgep$poptgep25$poptgepsqueezed(Larg0,Larg1.a7,0,1)|0;
				if((tmp2|0)===-1){
					switch(Larg0.i0|0){
						case 0:
						tmp2=-1;
						break a;
						case 29:
						case 22:
						Larg0.i0=Lgeptoindexphi;
						return 0|0;
						default:
						Larg1.i3=Larg1.i3|64;
						return  -1|0;
					}
				}
			}
			if((Larg1.i3&4|0)!==0){
				L$poptgep$poptgep25$poptgepsqueezedo=Larg1.a12.a0o;
				L$poptgep$poptgep25$poptgepsqueezed=Larg1.a12.a0;
				tmp2=tmp2-(Larg1.i1|0)|0;
				if(L$poptgep$poptgep25$poptgepsqueezed!==nullArray||L$poptgep$poptgep25$poptgepsqueezedo!==0){
					tmp5=Larg1.i14|0;
					tmp2=tmp2-tmp5|0;
				}
			}
			tmp2=Larg1.a10(Larg0,Larg1.a7,tmp2,0)|0;
			a:if((tmp2|0)===-1){
				switch(Larg0.i0|0){
					case 0:
					case 29:
					case 22:
					break a;
					default:
					Larg1.i3=Larg1.i3|64;
					return  -1|0;
				}
			}
			tmp5=Larg1.i3|0;
			Larg1.i3=tmp5& -2049;
			Larg1.i1=0;
			L$poptgep$poptgep25$poptgepsqueezedo=Larg1.a4.a0o;
			L$poptgep$poptgep25$poptgepsqueezed=Larg1.a4.a0;
			Larg1.a0=L$poptgep$poptgep25$poptgepsqueezed;
			Larg1.a0o=L$poptgep$poptgep25$poptgepsqueezedo;
			a:if((tmp5&4096|0)!==0){
				if((tmp2|0)===-1)if((Larg0.i0|0)!==0)break a;
				Larg1.i18=tmp2;
			}
			Larg0.i0=Lgeptoindexphi;
			L$poptgep$poptgep25$poptgepsqueezedo=Larg1.a12.a0o;
			L$poptgep$poptgep25$poptgepsqueezed=Larg1.a12.a0;
			if(L$poptgep$poptgep25$poptgepsqueezed!==nullArray||L$poptgep$poptgep25$poptgepsqueezedo!==0){
				Larg1.a12.a0=nullArray;
				Larg1.a12.a0o=0;
				return 0|0;
			}
			return 0|0;
		}
		return 0|0;
	}
	L$poptgep$poptgep25$poptgepsqueezed=Larg1.a4;
	tmp0o=L$poptgep$poptgep25$poptgepsqueezed.a0o;
	tmp0=L$poptgep$poptgep25$poptgepsqueezed.a0;
	if(tmp0===nullArray&&tmp0o===0)return 0|0;
	tmp1o=Larg1.a0o;
	tmp1=Larg1.a0;
	tmp2=(tmp1o)-(tmp0o)|0;
	Larg1.a0=tmp0;
	Larg1.a0o=tmp0o;
	if((Lgeptoindexphi&3|0)!==0){
		Lgeptoindexphi=0;
	}else{
		Lgeptoindexphi=L$poptgep$poptgep25$poptgepsqueezed.i1|0;
	}
	Larg1.i2=Lgeptoindexphi;
	if((tmp2|0)<=0)return 0|0;
	Lgeptoindexphi=0;
	while(1){
		tmp5=Larg1.a9(Larg0,Larg1.a7,tmp0,tmp0o+Lgeptoindexphi|0,tmp2)|0;
		if((tmp5|0)<1){
			Larg1.i3=Larg1.i3|64;
			return  -1|0;
		}
		tmp2=tmp2-tmp5|0;
		if((tmp2|0)>0){
			Lgeptoindexphi=Lgeptoindexphi+tmp5|0;
			continue;
		}
		break;
	}
	return 0|0;
}
function ___swsetup_r(Larg0,Larg1){
	var tmp0=0,tmp1=null,Lmergedinsert9=0,tmp3=0,L$poptgep$poptgep9$poptgepsqueezed=null,L$poptgep$poptgep9$poptgepsqueezedo=0,tmp5=null,tmp5o=0,tmp6=0;
	if((_impure_data.i6|0)===0)___sinit(_impure_data);
	if(Larg1===___sf_fake_stdin){
		tmp1=_impure_data.a1;
	}else if(Larg1===___sf_fake_stdout){
		tmp1=_impure_data.a2;
	}else{
		tmp1=_impure_data.a3;
		tmp1=(Larg1===___sf_fake_stderr?tmp1:Larg1);
	}
	Lmergedinsert9=tmp1.i3|0;
	tmp3=Lmergedinsert9<<16>>16;
	if((tmp3&8|0)!==0){
		tmp3=Lmergedinsert9;
	}else{
		if((tmp3&16|0)===0){
			Larg0.i0=9;
			tmp1.i3=Lmergedinsert9&65471|tmp1.i3& -65536|64;
			return  -1|0;
		}
		if((tmp3&4|0)!==0){
			L$poptgep$poptgep9$poptgepsqueezedo=tmp1.a12.a0o;
			L$poptgep$poptgep9$poptgepsqueezed=tmp1.a12.a0;
			if(L$poptgep$poptgep9$poptgepsqueezed!==nullArray||L$poptgep$poptgep9$poptgepsqueezedo!==0){
				tmp1.a12.a0=nullArray;
				tmp1.a12.a0o=0;
			}
			tmp3=Lmergedinsert9&65499;
			Lmergedinsert9=Lmergedinsert9& -65536|tmp3;
			tmp1.i3=Lmergedinsert9;
			tmp1.i1=0;
			L$poptgep$poptgep9$poptgepsqueezedo=tmp1.a4.a0o;
			L$poptgep$poptgep9$poptgepsqueezed=tmp1.a4.a0;
			tmp1.a0=L$poptgep$poptgep9$poptgepsqueezed;
			tmp1.a0o=L$poptgep$poptgep9$poptgepsqueezedo;
		}else{
			tmp3=Lmergedinsert9;
		}
		tmp3|=8;
		Lmergedinsert9=Lmergedinsert9& -65536|tmp3&65535;
		tmp1.i3=Lmergedinsert9;
	}
	L$poptgep$poptgep9$poptgepsqueezed=tmp1.a4;
	tmp5o=L$poptgep$poptgep9$poptgepsqueezed.a0o;
	tmp5=L$poptgep$poptgep9$poptgepsqueezed.a0;
	a:if(tmp5===nullArray&&tmp5o===0){
		if((tmp3&512)!==0)if(tmp3<<24>=0)break a;
		if((Lmergedinsert9&2|0)!==0){
			tmp1.a0=tmp1.a15;
			tmp1.a0o=3;
			L$poptgep$poptgep9$poptgepsqueezed.a0=tmp1.a15;
			L$poptgep$poptgep9$poptgepsqueezed.a0o=3;
			L$poptgep$poptgep9$poptgepsqueezed.i1=1;
		}else{
			b:{
				if(Lmergedinsert9>>16>>>0<3)if(Lmergedinsert9>>>16<<16>-65536){
					Lmergedinsert9&= -2049;
					tmp0=1;
					tmp6=1024;
					break b;
				}
				tmp6=Lmergedinsert9<<24<0?64|0:1024|0;
				tmp0=0;
			}
			tmp1.i3=Lmergedinsert9|2048;
			tmp5=new Uint8Array(tmp6/1|0);
			if(tmp5!==nullArray||0!==0){
				Larg0.a10=__cleanup_r;
				tmp3=tmp1.i3|0;
				Lmergedinsert9=tmp3|128;
				tmp1.i3=Lmergedinsert9;
				tmp1.a0=tmp5;
				tmp1.a0o=0;
				L$poptgep$poptgep9$poptgepsqueezed.a0=tmp5;
				L$poptgep$poptgep9$poptgepsqueezed.a0o=0;
				L$poptgep$poptgep9$poptgepsqueezed.i1=tmp6;
				if((tmp0|0)!==0)if((tmp3>>>16&65535)<=3){
					Lmergedinsert9=tmp3|129;
					tmp1.i3=Lmergedinsert9;
				}
			}else{
				Lmergedinsert9=tmp1.i3|0;
				if((Lmergedinsert9&512|0)===0){
					Lmergedinsert9|=2;
					tmp1.i3=Lmergedinsert9;
					tmp1.a0=tmp1.a15;
					tmp1.a0o=3;
					L$poptgep$poptgep9$poptgepsqueezed.a0=tmp1.a15;
					L$poptgep$poptgep9$poptgepsqueezed.a0o=3;
					L$poptgep$poptgep9$poptgepsqueezed.i1=1;
				}
			}
		}
		tmp3=Lmergedinsert9;
	}
	tmp6=tmp3<<16>>16;
	if((tmp6&1|0)!==0){
		tmp1.i2=0;
		tmp1.i5=-(L$poptgep$poptgep9$poptgepsqueezed.i1|0)|0;
	}else{
		if((tmp6&2|0)!==0){
			tmp6=0;
		}else{
			tmp6=L$poptgep$poptgep9$poptgepsqueezed.i1|0;
		}
		tmp1.i2=tmp6;
	}
	L$poptgep$poptgep9$poptgepsqueezedo=L$poptgep$poptgep9$poptgepsqueezed.a0o;
	L$poptgep$poptgep9$poptgepsqueezed=L$poptgep$poptgep9$poptgepsqueezed.a0;
	if(tmp3<<24<0){
		if(L$poptgep$poptgep9$poptgepsqueezed!==nullArray||L$poptgep$poptgep9$poptgepsqueezedo!==0)return 0|0;
		tmp1.i3=Lmergedinsert9& -65536|(tmp3|64)&65535;
		return  -1|0;
	}
	return 0|0;
}
function __cleanup_r(Larg0){
	var tmp0=0,tmp1=null,Lgeptoindexphi=0,tmp3=null,tmp4=null,tmp5=0,tmp6=0,tmp7=null,tmp7o=0;
	tmp0=Larg0!==null?1:0;
	tmp4=Larg0.a20;
	while(1){
		tmp5=tmp4.i1|0;
		if((tmp5|0)>0){
			tmp1=tmp4.a2;
			Lgeptoindexphi=0;
			while(1){
				tmp6=tmp1[Lgeptoindexphi].i3|0;
				if(tmp1!==nullArray||(0+Lgeptoindexphi|0)!==0)if(tmp6>>>0<=4294901759)if((tmp6&65535)>=2){
					if(tmp0)if((Larg0.i6|0)===0)___sinit(Larg0);
					if(tmp1[Lgeptoindexphi]===___sf_fake_stdin){
						tmp3=Larg0.a1;
					}else if(tmp1[Lgeptoindexphi]===___sf_fake_stdout){
						tmp3=Larg0.a2;
					}else if(tmp1[Lgeptoindexphi]===___sf_fake_stderr){
						tmp3=Larg0.a3;
					}else{
						tmp3=tmp1[Lgeptoindexphi];
					}
					if((tmp3.i3&65535)!==0){
						___sflush_r(Larg0,tmp3)|0;
						tmp7=tmp3.a11;
						if(tmp7!==null)tmp7(Larg0,tmp3.a7)|0;
						tmp6=tmp3.i3|0;
						tmp7o=tmp3.a12.a0o;
						tmp7=tmp3.a12.a0;
						if(tmp7!==nullArray||tmp7o!==0){
							tmp3.a12.a0=nullArray;
							tmp3.a12.a0o=0;
						}
						tmp7o=tmp3.a16.a0o;
						tmp7=tmp3.a16.a0;
						if(tmp7!==nullArray||tmp7o!==0){
							tmp3.a16.a0=nullArray;
							tmp3.a16.a0o=0;
						}
						tmp3.i3=tmp6& -65536;
					}
				}
				if((tmp5|0)>1){
					Lgeptoindexphi=Lgeptoindexphi+1|0;
					tmp5=tmp5-1|0;
					continue;
				}
				break;
			}
		}
		tmp4=tmp4.a0;
		if(tmp4!==null)continue;
		break;
	}
}
function ___sinit(Larg0){
	var L$poptgep$poptgep2$poptgepsqueezed=null;
	if((Larg0.i6|0)===0){
		Larg0.a10=__cleanup_r;
		L$poptgep$poptgep2$poptgepsqueezed=Larg0.a20;
		L$poptgep$poptgep2$poptgepsqueezed.a0=null;
		L$poptgep$poptgep2$poptgepsqueezed.i1=0;
		L$poptgep$poptgep2$poptgepsqueezed.a2=nullArray;
		if(Larg0===_impure_data)Larg0.i6=1;
		Larg0.a1=___sfp(Larg0);
		Larg0.a2=___sfp(Larg0);
		Larg0.a3=___sfp(Larg0);
		_std(Larg0.a1,4,0);
		_std(Larg0.a2,9,1);
		_std(Larg0.a3,17,2);
		Larg0.i6=1;
	}
}
function _std(Larg0,Larg1,Larg2){
	var L$poptgep$poptgep5$poptgepsqueezed=null;
	Larg0.a0=nullArray;
	Larg0.a0o=0;
	Larg0.i1=0;
	Larg0.i2=0;
	Larg0.i21=0;
	Larg0.i3=Larg2<<16|Larg1&65535;
	L$poptgep$poptgep5$poptgepsqueezed=Larg0.a4;
	L$poptgep$poptgep5$poptgepsqueezed.a0=nullArray;
	L$poptgep$poptgep5$poptgepsqueezed.a0o=0;
	L$poptgep$poptgep5$poptgepsqueezed.i1=0;
	Larg0.i5=0;
	L$poptgep$poptgep5$poptgepsqueezed=Larg0.a20;
	L$poptgep$poptgep5$poptgepsqueezed.i0=0;
	L$poptgep$poptgep5$poptgepsqueezed.i1=0;
	Larg0.a7=Larg0;
	Larg0.a8=___sread;
	Larg0.a9=___swrite;
	Larg0.a10=___sseek;
	Larg0.a11=___sclose;
}
function ___sclose(Larg0,Larg1){
	return  -1|0;
}
function ___sseek(Larg0,Larg1,Larg2,Larg3){
	Larg1.i3=Larg1.i3& -4097;
	return  -1|0;
}
function ___swrite(Larg0,Larg1,Larg2,Marg2,Larg3){
	var Lgeptoindexphi2=0,tmp1=null,L$plcssa13$pi$pi$pi$pi=0,tmp3=0,L$plcssa$pi$pi$pi$pi=0,tmp5=0,tmp6=null;
	Lgeptoindexphi2=Larg1.i3|0;
	Larg1.i3=Lgeptoindexphi2& -4097;
	if((Lgeptoindexphi2>>16)-1>>>0<2){
		tmp1=String();
		a:if((Larg3|0)!==0){
			L$plcssa13$pi$pi$pi$pi=Larg3;
			Lgeptoindexphi2=0;
			while(1){
				L$plcssa$pi$pi$pi$pi=Larg2[Marg2+Lgeptoindexphi2|0]|0;
				if((L$plcssa$pi$pi$pi$pi&255)!==0){
					while(1){
						tmp5=L$plcssa$pi$pi$pi$pi&255;
						if(L$plcssa$pi$pi$pi$pi<<24<=-16777216)if((L$plcssa$pi$pi$pi$pi&255)<192){
							tmp5=tmp5&63|tmp3<<6;
						}else if((L$plcssa$pi$pi$pi$pi&255)<224){
							tmp5&=31;
						}else if((L$plcssa$pi$pi$pi$pi&255)<240){
							tmp5&=15;
						}else{
							tmp5&=7;
						}
						L$plcssa13$pi$pi$pi$pi=L$plcssa13$pi$pi$pi$pi-1|0;
						Lgeptoindexphi2=Lgeptoindexphi2+1|0;
						if((L$plcssa13$pi$pi$pi$pi|0)!==0){
							L$plcssa$pi$pi$pi$pi=Larg2[Marg2+Lgeptoindexphi2|0]|0;
							if((L$plcssa$pi$pi$pi$pi&192)===128){
								if((L$plcssa$pi$pi$pi$pi&255)===0)break a;
								tmp3=tmp5;
								continue;
							}
							L$plcssa$pi$pi$pi$pi=0;
						}else{
							L$plcssa$pi$pi$pi$pi=1;
							L$plcssa13$pi$pi$pi$pi=0;
						}
						break;
					}
					if(tmp5>>>0<65536){
						tmp3=tmp5;
					}else{
						tmp3=tmp5-65536|0;
						tmp6=String.fromCharCode((tmp3>>>10)+55296|0);
						tmp1=tmp1.concat(tmp6);
						tmp5=(tmp3&1023)+56320|0;
					}
					tmp6=String.fromCharCode(tmp5);
					tmp1=tmp1.concat(tmp6);
					if(!(L$plcssa$pi$pi$pi$pi))continue;
				}
				break;
			}
		}
		Lgeptoindexphi2=Larg3-1|0;
		if((Larg2[Marg2+Lgeptoindexphi2|0]&255)===10){
			tmp6=tmp1.substr(0,Lgeptoindexphi2);
			console.log(tmp6);
			return Larg3|0;
		}
		console.log(tmp1);
		return Larg3|0;
	}
	throw new Error("Abort called");
}
function ___sread(Larg0,Larg1,Larg2,Marg2,Larg3){
	Larg1.i3=Larg1.i3& -4097;
	return  -1|0;
}
function ___sfp(Larg0){
	var Lgeptoindexphi=0,tmp1=null,L$pbe=null,L$pidx$pi=0,tmp4=null,L$poptgep20$poptgep24=null;
	if((_impure_data.i6|0)===0)___sinit(_impure_data);
	L$pbe=_impure_data.a20;
	while(1){
		L$pidx$pi=L$pbe.i1|0;
		if((L$pidx$pi|0)>0){
			tmp4=L$pbe.a2;
			Lgeptoindexphi=0;
			while(1){
				if((tmp4[Lgeptoindexphi].i3&65535)===0){
					tmp4[Lgeptoindexphi].i3=-65535;
					tmp4[Lgeptoindexphi].i21=0;
					tmp4[Lgeptoindexphi].a0=nullArray;
					tmp4[Lgeptoindexphi].a0o=0;
					tmp4[Lgeptoindexphi].i2=0;
					tmp4[Lgeptoindexphi].i1=0;
					L$pbe=tmp4[Lgeptoindexphi].a4;
					L$pbe.a0=nullArray;
					L$pbe.a0o=0;
					L$pbe.i1=0;
					tmp4[Lgeptoindexphi].i5=0;
					L$pbe=tmp4[Lgeptoindexphi].a20;
					L$pbe.i0=0;
					L$pbe.i1=0;
					L$pbe=tmp4[Lgeptoindexphi].a12;
					L$pbe.a0=nullArray;
					L$pbe.a0o=0;
					L$pbe.i1=0;
					L$pbe=tmp4[Lgeptoindexphi].a16;
					L$pbe.a0=nullArray;
					L$pbe.a0o=0;
					L$pbe.i1=0;
					return tmp4[Lgeptoindexphi];
				}
				if((L$pidx$pi|0)>1){
					Lgeptoindexphi=Lgeptoindexphi+1|0;
					L$pidx$pi=L$pidx$pi-1|0;
					continue;
				}
				break;
			}
		}
		tmp4=L$pbe.a0;
		a:{
			if(tmp4===null){
				tmp4={a0:null,i1:0,a2:nullArray,a3:null};
				tmp1=[new constructor_struct$p_Z7__sFILE(),new constructor_struct$p_Z7__sFILE(),new constructor_struct$p_Z7__sFILE(),new constructor_struct$p_Z7__sFILE()];
				tmp4.a3=tmp1[0];
				if(tmp4!==null){
					tmp4.a0=null;
					tmp4.i1=4;
					tmp4.a2=tmp1;
					L$pidx$pi=0;
					while(1){
						tmp1[L$pidx$pi].a0=nullArray;
						tmp1[L$pidx$pi].a0o=0;
						tmp1[L$pidx$pi].i1=0;
						tmp1[L$pidx$pi].i2=0;
						tmp1[L$pidx$pi].i3=0;
						L$poptgep20$poptgep24=tmp1[L$pidx$pi].a4;
						L$poptgep20$poptgep24.a0=nullArray;
						L$poptgep20$poptgep24.a0o=0;
						L$poptgep20$poptgep24.i1=0;
						tmp1[L$pidx$pi].i5=0;
						tmp1[L$pidx$pi].a6=null;
						tmp1[L$pidx$pi].a7=null;
						tmp1[L$pidx$pi].a8=null;
						tmp1[L$pidx$pi].a9=null;
						tmp1[L$pidx$pi].a10=null;
						tmp1[L$pidx$pi].a11=null;
						L$poptgep20$poptgep24=tmp1[L$pidx$pi].a12;
						L$poptgep20$poptgep24.a0=nullArray;
						L$poptgep20$poptgep24.a0o=0;
						L$poptgep20$poptgep24.i1=0;
						tmp1[L$pidx$pi].a13=null;
						tmp1[L$pidx$pi].i14=0;
						L$poptgep20$poptgep24=tmp1[L$pidx$pi].a15;
						L$poptgep20$poptgep24[0]=0;
						L$poptgep20$poptgep24[1]=0;
						L$poptgep20$poptgep24[2]=0;
						L$poptgep20$poptgep24[3]=0;
						L$poptgep20$poptgep24=tmp1[L$pidx$pi].a16;
						L$poptgep20$poptgep24.a0=nullArray;
						L$poptgep20$poptgep24.a0o=0;
						L$poptgep20$poptgep24.i1=0;
						tmp1[L$pidx$pi].i17=0;
						tmp1[L$pidx$pi].i18=0;
						tmp1[L$pidx$pi].i19=0;
						L$poptgep20$poptgep24=tmp1[L$pidx$pi].a20;
						L$poptgep20$poptgep24.i0=0;
						L$poptgep20$poptgep24.i1=0;
						tmp1[L$pidx$pi].i21=0;
						L$pidx$pi=L$pidx$pi+1|0;
						if((L$pidx$pi|0)!==4)continue;
						break;
					}
					L$pbe.a0=tmp4;
					if(tmp4!==null){
						L$pbe=tmp4;
						break a;
					}
				}else L$pbe.a0=null;
				Larg0.i0=12;
				return null;
			}
			L$pbe=tmp4;
		}
		continue;
	}
}
function _exit(){
	var tmp0=null;
	___call_exitprocs();
	tmp0=_impure_data.a10;
	if(tmp0!==null)tmp0(_impure_data);
	__exit();
}
function _cheerpCreate_ZN6client6StringC2EPKc(){
	return String(__ZN6client6String11fromCharPtrIcEEPS0_PKT_());
}
function __ZN6client6String11fromCharPtrIcEEPS0_PKT_(){
	var tmp0=null;
	tmp0=String();
	tmp0=tmp0.concat(String.fromCharCode(104));
	tmp0=tmp0.concat(String.fromCharCode(101));
	tmp0=tmp0.concat(String.fromCharCode(108));
	tmp0=tmp0.concat(String.fromCharCode(108));
	tmp0=tmp0.concat(String.fromCharCode(111));
	return tmp0.concat(String.fromCharCode(33));
}
function _iprintf(Larg0,Marg0){
	var LmergedArray=null,tmp1=null,tmp2=null,tmp3=null,tmp4=null,Lmaskcond3$pi$pi=0,Lmaskcond$pi$pi=0,tmp7=null,tmp8=null,L$poptgep79$poptgep92$poptgepsqueezed=null,L$poptgep79$poptgep92$poptgepsqueezedo=0,Lgeptoindexphi62=0,Lgeptoindexphi33=0,Lgeptoindexphi32=0,tmp13=0,Lgeptoindexphi=0,Lgeptoindex38=0,Lgeptoindex=0,L$pph=null,L$ppho=0,tmp18=0,Lmaskcond6$pi$pi=0,tmp20=0,tmp21=0,Lgeptoindexphi23=0,tmp23=0,tmp24=0;
	LmergedArray=[nullObj,nullObj];
	if((_impure_data.i6|0)===0)___sinit(_impure_data);
	LmergedArray[0]={d:arguments,o:_iprintf.length};
	tmp8=_impure_data.a2;
	L$poptgep79$poptgep92$poptgepsqueezed=LmergedArray[0];
	tmp1=new Int32Array(2);
	tmp2=new Int32Array(2);
	tmp3=new Int32Array(2);
	tmp4=new constructor_struct$p_Z11_prt_data_t();
	LmergedArray[1]=L$poptgep79$poptgep92$poptgepsqueezed;
	if((_impure_data.i6|0)===0)___sinit(_impure_data);
	if(tmp8===___sf_fake_stdin){
		tmp8=_impure_data.a1;
	}else if(tmp8===___sf_fake_stdout){
		tmp8=_impure_data.a2;
	}else{
		L$poptgep79$poptgep92$poptgepsqueezed=_impure_data.a3;
		tmp8=(tmp8===___sf_fake_stderr?L$poptgep79$poptgep92$poptgepsqueezed:tmp8);
	}
	a:{
		b:{
			if((tmp8.i3&8|0)!==0){
				L$poptgep79$poptgep92$poptgepsqueezedo=tmp8.a4.a0o;
				L$poptgep79$poptgep92$poptgepsqueezed=tmp8.a4.a0;
				if(L$poptgep79$poptgep92$poptgepsqueezed!==nullArray||L$poptgep79$poptgep92$poptgepsqueezedo!==0)break b;
			}
			if((___swsetup_r(_impure_data,tmp8)|0|0)!==0){
				tmp13=-1;
				break a;
			}
		}
		tmp4.i5=0;
		tmp4.i7=32;
		tmp4.i8=48;
		Lgeptoindexphi33=0;
		Lgeptoindexphi62=0;
		b:while(1){
			Lgeptoindexphi32=Lgeptoindexphi33;
			c:while(1){
				tmp13=Larg0[Marg0+Lgeptoindexphi32|0]|0;
				switch(tmp13&255){
					case 0:
					case 37:
					Lgeptoindexphi=(Marg0+Lgeptoindexphi32|0)-(Marg0+Lgeptoindexphi33|0)|0;
					d:{
						if((Lgeptoindexphi|0)!==0){
							if((___sfputs_r(_impure_data,tmp8,Larg0,Marg0+Lgeptoindexphi33|0,Lgeptoindexphi)|0|0)===-1)break d;
							Lgeptoindexphi62=(tmp4.i5|0)+Lgeptoindexphi|0;
							tmp4.i5=Lgeptoindexphi62;
							tmp13=Larg0[Marg0+Lgeptoindexphi32|0]|0;
						}
						if((tmp13&255)!==0){
							tmp4.i0=0;
							tmp4.i3=0;
							tmp4.i1=-1;
							tmp4.i2=0;
							L$poptgep79$poptgep92$poptgepsqueezed=tmp4.a9;
							L$poptgep79$poptgep92$poptgepsqueezed[40]=0;
							tmp4.i11=0;
							Lgeptoindex38=Lgeptoindexphi32+1|0;
							Lgeptoindexphi33=Larg0[Marg0+Lgeptoindex38|0]|0;
							e:{
								switch(Lgeptoindexphi33&255){
									case 35:
									L$ppho=0;
									L$pph=_$pstr$p359;
									break;
									case 45:
									L$ppho=1;
									L$pph=_$pstr$p359;
									break;
									case 48:
									L$ppho=2;
									L$pph=_$pstr$p359;
									break;
									case 43:
									L$ppho=3;
									L$pph=_$pstr$p359;
									break;
									case 32:
									L$ppho=4;
									L$pph=_$pstr$p359;
									break;
									default:
									Lgeptoindex=0;
									tmp13=0;
									break e;
								}
								Lgeptoindexphi=0;
								tmp13=0;
								while(1){
									tmp13|=(1<<((L$ppho)-(0)|0));
									tmp4.i0=tmp13;
									Lgeptoindex=Lgeptoindexphi+1|0;
									Lgeptoindexphi33=Larg0[(Marg0+Lgeptoindex38|0)+Lgeptoindex|0]|0;
									switch(Lgeptoindexphi33&255){
										case 35:
										L$ppho=0;
										L$pph=_$pstr$p359;
										break;
										case 45:
										L$ppho=1;
										L$pph=_$pstr$p359;
										break;
										case 48:
										L$ppho=2;
										L$pph=_$pstr$p359;
										break;
										case 43:
										L$ppho=3;
										L$pph=_$pstr$p359;
										break;
										case 32:
										L$ppho=4;
										L$pph=_$pstr$p359;
										break;
										default:
										Lgeptoindexphi32=Lgeptoindex38+Lgeptoindexphi|0;
										break e;
									}
									Lgeptoindexphi=Lgeptoindex;
									continue;
								}
							}
							Lgeptoindexphi=Lgeptoindex38+Lgeptoindex|0;
							e:{
								if((tmp13&16|0)===0)if(!(((tmp13&8|0)===0?1:0)^1))break e;
								L$poptgep79$poptgep92$poptgepsqueezed[40]=(tmp13&8|0)===0?32|0:43|0;
								Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi|0]|0;
							}
							if((Lgeptoindexphi33&255)===42){
								Lgeptoindexphi33=handleVAArg(LmergedArray[1]);
								tmp4.i3=Lgeptoindexphi33;
								if((Lgeptoindexphi33|0)<0){
									tmp4.i3=-Lgeptoindexphi33|0;
									tmp13|=2;
									tmp4.i0=tmp13;
								}
								Lgeptoindexphi=Lgeptoindexphi32+2|0;
								Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi|0]|0;
							}else{
								Lgeptoindexphi23=(Lgeptoindexphi33<<24>>24)-48|0;
								if(Lgeptoindexphi23>>>0<10){
									Lgeptoindexphi32=0;
									while(1){
										Lgeptoindexphi32=(__imul(Lgeptoindexphi32,10)|0)+Lgeptoindexphi23|0;
										tmp4.i3=Lgeptoindexphi32;
										Lgeptoindex=Lgeptoindex+1|0;
										Lgeptoindexphi=Lgeptoindex38+Lgeptoindex|0;
										Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi|0]|0;
										Lgeptoindexphi23=(Lgeptoindexphi33<<24>>24)-48|0;
										if(Lgeptoindexphi23>>>0<10)continue;
										break;
									}
								}
							}
							if((Lgeptoindexphi33&255)===46){
								Lgeptoindex38=Lgeptoindexphi+1|0;
								if((Larg0[Marg0+Lgeptoindex38|0]&255)===42){
									Lgeptoindexphi33=handleVAArg(LmergedArray[1]);
									Lgeptoindexphi32=(Lgeptoindexphi33|0)>-1?Lgeptoindexphi33|0: -1|0;
									tmp4.i1=Lgeptoindexphi32;
									Lgeptoindexphi=Lgeptoindexphi+2|0;
									Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi|0]|0;
								}else{
									tmp4.i1=0;
									Lgeptoindexphi33=Larg0[Marg0+Lgeptoindex38|0]|0;
									Lgeptoindex=(Lgeptoindexphi33<<24>>24)-48|0;
									if(Lgeptoindex>>>0<10){
										Lgeptoindexphi23=0;
										Lgeptoindexphi32=0;
										while(1){
											Lgeptoindexphi32=(__imul(Lgeptoindexphi32,10)|0)+Lgeptoindex|0;
											tmp4.i1=Lgeptoindexphi32;
											Lgeptoindexphi23=Lgeptoindexphi23+1|0;
											Lgeptoindexphi=Lgeptoindex38+Lgeptoindexphi23|0;
											Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi|0]|0;
											Lgeptoindex=(Lgeptoindexphi33<<24>>24)-48|0;
											if(Lgeptoindex>>>0<10)continue;
											break;
										}
									}else{
										Lgeptoindexphi=Lgeptoindex38;
										Lgeptoindexphi32=0;
									}
								}
							}else{
								Lgeptoindexphi32=-1;
							}
							e:{
								switch(Lgeptoindexphi33&255){
									case 104:
									L$ppho=0;
									L$pph=_$pstr$p356;
									break;
									case 108:
									L$ppho=1;
									L$pph=_$pstr$p356;
									break;
									case 76:
									L$ppho=2;
									L$pph=_$pstr$p356;
									break;
									default:
									break e;
								}
								Lgeptoindexphi33=Lgeptoindexphi+1|0;
								tmp18=(L$ppho)-(0)|0;
								if((tmp18|0)===1){
									if((Larg0[Marg0+Lgeptoindexphi33|0]&255)===108){
										Lgeptoindexphi33=Lgeptoindexphi+2|0;
										Lgeptoindexphi23=512;
									}else{
										Lgeptoindexphi23=128;
									}
								}else{
									Lgeptoindexphi23=64<<tmp18;
								}
								tmp13|=Lgeptoindexphi23;
								tmp4.i0=tmp13;
								Lgeptoindexphi=Lgeptoindexphi33;
								Lgeptoindexphi33=Larg0[Marg0+Lgeptoindexphi33|0]|0;
							}
							tmp4.i6=Lgeptoindexphi33;
							e:{
								f:{
									g:{
										h:{
											i:{
												j:{
													switch(Lgeptoindexphi33<<24>>24|0){
														case 99:
														tmp13=handleVAArg(LmergedArray[1]);
														L$poptgep79$poptgep92$poptgepsqueezed[39]=tmp13;
														tmp4.i4=1;
														L$ppho=39;
														L$pph=L$poptgep79$poptgep92$poptgepsqueezed;
														Lgeptoindexphi32=1;
														break;
														case 100:
														case 105:
														if((tmp13&512|0)!==0){
															L$pph=handleVAArg(LmergedArray[1]);
															tmp20=L$pph.d[L$pph.o+1|0]|0;
															tmp21=L$pph.d[L$pph.o]|0;
														}else if(tmp13<<24<0){
															tmp21=handleVAArg(LmergedArray[1]);
															tmp20=tmp21>>31;
														}else{
															tmp21=handleVAArg(LmergedArray[1]);
															if((tmp13&64|0)!==0){
																tmp21<<=16;
																tmp20=tmp21>>31;
																tmp21>>=16;
															}else{
																tmp20=tmp21>>31;
															}
														}
														tmp1[1]=tmp20;
														tmp1[0]=tmp21;
														if((tmp20|0)<0){
															tmp20=(tmp21|0)!==0?tmp20^ -1|0:-tmp20|0;
															tmp1[1]=tmp20;
															tmp21=-tmp21|0;
															tmp1[0]=tmp21;
															L$poptgep79$poptgep92$poptgepsqueezed[40]=45;
															L$pph=_$pstr$p374;
															tmp18=10;
															break f;
														}
														L$pph=_$pstr$p374;
														tmp18=10;
														break f;
														case 117:
														case 111:
														if((tmp13&512|0)!==0){
															L$pph=handleVAArg(LmergedArray[1]);
															tmp20=L$pph.d[L$pph.o+1|0]|0;
															tmp21=L$pph.d[L$pph.o]|0;
														}else if(tmp13<<24<0){
															tmp21=handleVAArg(LmergedArray[1]);
															tmp20=0;
														}else{
															tmp18=handleVAArg(LmergedArray[1]);
															tmp21=(tmp13&64|0)!==0?tmp18&65535|0:tmp18|0;
															tmp20=0;
														}
														tmp1[1]=tmp20;
														tmp1[0]=tmp21;
														tmp18=(Lgeptoindexphi33&255)===111?8|0:10|0;
														L$pph=_$pstr$p374;
														break g;
														case 88:
														L$poptgep79$poptgep92$poptgepsqueezed[42]=88;
														L$pph=_$pstr$p374;
														break h;
														case 112:
														tmp13|=32;
														tmp4.i0=tmp13;
														break i;
														case 120:
														break i;
														case 110:
														if((tmp13&512|0)!==0){
															L$pph=handleVAArg(LmergedArray[1]);
															L$pph.d[L$pph.o+1|0]=Lgeptoindexphi62>>31;
															L$pph.d[L$pph.o]=Lgeptoindexphi62;
															break j;
														}
														if(tmp13<<24<0){
															L$pph=handleVAArg(LmergedArray[1]);
															L$pph.d[L$pph.o]=Lgeptoindexphi62;
															break j;
														}
														if((tmp13&64|0)!==0){
															L$pph=handleVAArg(LmergedArray[1]);
															L$pph.d[L$pph.o]=Lgeptoindexphi62;
															break j;
														}
														L$pph=handleVAArg(LmergedArray[1]);
														L$pph.d[L$pph.o]=Lgeptoindexphi62;
														break j;
														case 0:
														break j;
														case 115:
														L$pph=handleVAArg(LmergedArray[1]);
														if((Lgeptoindexphi32|0)!==0){
															tmp13=Lgeptoindexphi32;
															Lgeptoindexphi33=0;
															while(1){
																if((L$pph.d[L$pph.o+Lgeptoindexphi33|0]&255)!==0){
																	tmp13=tmp13-1|0;
																	if((tmp13|0)!==0){
																		Lgeptoindexphi33=Lgeptoindexphi33+1|0;
																		continue;
																	}
																}else if(L$pph.d!==nullArray||(L$pph.o+Lgeptoindexphi33|0)!==0){
																	Lgeptoindexphi32=(L$pph.o+Lgeptoindexphi33|0)-(L$pph.o)|0;
																	tmp4.i1=Lgeptoindexphi32;
																}
																break;
															}
														}else{
															Lgeptoindexphi32=0;
														}
														tmp4.i4=Lgeptoindexphi32;
														L$ppho=L$pph.o;
														L$pph=L$pph.d;
														break;
														default:
														L$poptgep79$poptgep92$poptgepsqueezed[39]=Lgeptoindexphi33;
														tmp4.i4=1;
														L$ppho=39;
														L$pph=L$poptgep79$poptgep92$poptgepsqueezed;
														Lgeptoindexphi32=1;
													}
													L$poptgep79$poptgep92$poptgepsqueezed[40]=0;
													break e;
												}
												tmp4.i4=0;
												L$ppho=40;
												L$pph=L$poptgep79$poptgep92$poptgepsqueezed;
												Lgeptoindexphi32=0;
												break e;
											}
											L$poptgep79$poptgep92$poptgepsqueezed[42]=120;
											L$pph=_$pstr$p1$p373;
										}
										if((tmp13&512|0)!==0){
											tmp7=handleVAArg(LmergedArray[1]);
											tmp20=tmp7.d[tmp7.o+1|0]|0;
											tmp21=tmp7.d[tmp7.o]|0;
										}else if(tmp13<<24<0){
											tmp21=handleVAArg(LmergedArray[1]);
											tmp20=0;
										}else{
											Lgeptoindexphi33=handleVAArg(LmergedArray[1]);
											tmp21=(tmp13&64|0)!==0?Lgeptoindexphi33&65535|0:Lgeptoindexphi33|0;
											tmp20=0;
										}
										tmp1[1]=tmp20;
										tmp1[0]=tmp21;
										if((tmp13&1|0)!==0){
											tmp13|=32;
											tmp4.i0=tmp13;
										}
										if((tmp20|tmp21|0)!==0){
											tmp18=16;
										}else{
											tmp13&= -33;
											tmp4.i0=tmp13;
											tmp18=16;
										}
									}
									L$poptgep79$poptgep92$poptgepsqueezed[40]=0;
								}
								tmp4.i2=Lgeptoindexphi32;
								if((Lgeptoindexphi32|0)>-1)tmp4.i0=tmp13& -5;
								if((tmp21|Lgeptoindexphi32|tmp20|0)!==0){
									Lmaskcond6$pi$pi=((Math.imul(0,4))&4|0)===0?1:0;
									Lmaskcond3$pi$pi=((Math.imul(0,4))&4|0)===0?1:0;
									Lmaskcond$pi$pi=((Math.imul(0,4))&7|0)===0?1:0;
									Lgeptoindexphi62=0;
									while(1){
										tmp2[1]=0;
										tmp2[0]=tmp18;
										f:{
											if(tmp18>>>0>=tmp21>>>0)if((tmp20|0)===0){
												Lgeptoindexphi33=tmp18;
												Lgeptoindexphi23=0;
												tmp13=0;
												Lgeptoindexphi32=1;
												break f;
											}
											Lgeptoindexphi33=tmp18;
											Lgeptoindexphi32=1;
											tmp13=0;
											Lgeptoindexphi23=0;
											while(1){
												Lgeptoindexphi23=Lgeptoindexphi33>>>31|Lgeptoindexphi23<<1;
												tmp13=Lgeptoindexphi32>>>31|tmp13<<1;
												Lgeptoindexphi33<<=1;
												Lgeptoindex38=Lgeptoindexphi33>>>0<tmp21>>>0?1:0;
												Lgeptoindex=(Lgeptoindexphi23|0)===(tmp20|0)?1:0;
												tmp23=Lgeptoindexphi23>>>0<tmp20>>>0?1:0;
												Lgeptoindexphi32<<=1;
												tmp24=(tmp13|Lgeptoindexphi32|0)!==0?1:0;
												if((Lgeptoindexphi23|0)>-1){
													if(!(tmp23)){
														if(!(Lgeptoindex38))break f;
														if(!(Lgeptoindex))break f;
													}
													if(tmp24)continue;
												}
												break;
											}
										}
										if((tmp13|Lgeptoindexphi32|0)!==0)while(1){
											Lgeptoindex38=tmp21>>>0>=Lgeptoindexphi33>>>0?1:0;
											Lgeptoindex=(tmp20|0)===(Lgeptoindexphi23|0)?1:0;
											f:{
												if(tmp20>>>0<=Lgeptoindexphi23>>>0){
													if(!(Lgeptoindex))break f;
													if(!(Lgeptoindex38))break f;
												}
												tmp20=(tmp20-Lgeptoindexphi23|0)+((tmp21>>>0<Lgeptoindexphi33>>>0?1:0)<<31>>31)|0;
												tmp21=tmp21-Lgeptoindexphi33|0;
											}
											Lgeptoindexphi32=Lgeptoindexphi32>>>1|tmp13<<31;
											Lgeptoindexphi33=Lgeptoindexphi33>>>1|Lgeptoindexphi23<<31;
											tmp13>>>=1;
											if((Lgeptoindexphi32|tmp13|0)!==0){
												Lgeptoindexphi23>>>=1;
												continue;
											}
											break;
										}
										Lgeptoindexphi62=Lgeptoindexphi62-1|0;
										L$poptgep79$poptgep92$poptgepsqueezed[40+Lgeptoindexphi62|0]=L$pph[tmp21]|0;
										tmp3[1]=0;
										tmp3[0]=tmp18;
										Lgeptoindex38=tmp1[1]|0;
										Lgeptoindex=tmp1[0]|0;
										tmp13=tmp18>>>0<Lgeptoindex>>>0?1:0;
										f:{
											if((Lgeptoindex38|0)===0)if(!(tmp13)){
												Lgeptoindexphi33=tmp18;
												Lgeptoindexphi23=0;
												tmp13=0;
												Lgeptoindexphi32=1;
												break f;
											}
											Lgeptoindexphi33=tmp18;
											Lgeptoindexphi32=1;
											tmp13=0;
											Lgeptoindexphi23=0;
											while(1){
												Lgeptoindexphi23=Lgeptoindexphi33>>>31|Lgeptoindexphi23<<1;
												tmp13=Lgeptoindexphi32>>>31|tmp13<<1;
												Lgeptoindexphi33<<=1;
												tmp20=Lgeptoindexphi33>>>0<Lgeptoindex>>>0?1:0;
												tmp21=(Lgeptoindexphi23|0)===(Lgeptoindex38|0)?1:0;
												tmp23=Lgeptoindexphi23>>>0<Lgeptoindex38>>>0?1:0;
												Lgeptoindexphi32<<=1;
												tmp24=(tmp13|Lgeptoindexphi32|0)!==0?1:0;
												if((Lgeptoindexphi23|0)>-1){
													if(!(tmp23)){
														if(!(tmp20))break f;
														if(!(tmp21))break f;
													}
													if(tmp24)continue;
												}
												break;
											}
										}
										if((tmp13|Lgeptoindexphi32|0)!==0){
											tmp21=0;
											tmp20=0;
											while(1){
												tmp23=Lgeptoindex>>>0>=Lgeptoindexphi33>>>0?1:0;
												tmp24=(Lgeptoindex38|0)===(Lgeptoindexphi23|0)?1:0;
												f:{
													if(Lgeptoindex38>>>0<=Lgeptoindexphi23>>>0){
														if(!(tmp24))break f;
														if(!(tmp23))break f;
													}
													Lgeptoindex38=(Lgeptoindex38-Lgeptoindexphi23|0)+((Lgeptoindex>>>0<Lgeptoindexphi33>>>0?1:0)<<31>>31)|0;
													Lgeptoindex=Lgeptoindex-Lgeptoindexphi33|0;
													tmp20|=tmp13;
													tmp21|=Lgeptoindexphi32;
												}
												Lgeptoindexphi32=Lgeptoindexphi32>>>1|tmp13<<31;
												Lgeptoindexphi33=Lgeptoindexphi33>>>1|Lgeptoindexphi23<<31;
												tmp13>>>=1;
												if((Lgeptoindexphi32|tmp13|0)!==0){
													Lgeptoindexphi23>>>=1;
													continue;
												}
												break;
											}
										}else{
											tmp20=0;
											tmp21=0;
										}
										tmp1[1]=tmp20;
										tmp1[0]=tmp21;
										if((tmp20|tmp21|0)!==0)continue;
										break;
									}
								}else{
									Lgeptoindexphi62=0;
								}
								if((tmp18|0)===8)if((tmp4.i0&1|0)!==0)if((tmp4.i1|0)<=(tmp4.i4|0)){
									Lgeptoindexphi62=Lgeptoindexphi62-1|0;
									L$poptgep79$poptgep92$poptgepsqueezed[40+Lgeptoindexphi62|0]=48;
								}
								Lgeptoindexphi32=(40)-(40+Lgeptoindexphi62|0)|0;
								tmp4.i4=Lgeptoindexphi32;
								L$ppho=40+Lgeptoindexphi62|0;
								L$pph=L$poptgep79$poptgep92$poptgepsqueezed;
							}
							Lgeptoindexphi33=tmp4.i2|0;
							tmp13=L$poptgep79$poptgep92$poptgepsqueezed[40]|0;
							Lgeptoindexphi33=((Lgeptoindexphi33|0)>(Lgeptoindexphi32|0)?Lgeptoindexphi33|0:Lgeptoindexphi32|0)+(tmp13!==0?1:0)|0;
							tmp18=tmp4.i0|0;
							Lgeptoindexphi32=tmp18&32;
							Lgeptoindexphi33=(Lgeptoindexphi32|0)!==0?Lgeptoindexphi33+2|0:Lgeptoindexphi33|0;
							e:{
								if((tmp18&6|0)===0){
									tmp20=tmp4.i3|0;
									if((tmp20|0)>(Lgeptoindexphi33|0)){
										tmp13=0;
										while(1){
											if((tmp8.i21&8192|0)===0){
												if((___sfputc_r(_impure_data,tmp4.i7<<24>>24,tmp8)|0|0)===-1){
													tmp13=-1;
													break e;
												}
												tmp20=tmp4.i3|0;
											}
											tmp13=tmp13+1|0;
											if((tmp13|0)<(tmp20-Lgeptoindexphi33|0))continue;
											break;
										}
										tmp13=tmp4.i0|0;
										Lgeptoindexphi32=tmp13&32;
										tmp13=L$poptgep79$poptgep92$poptgepsqueezed[40]|0;
									}
								}
								if((Lgeptoindexphi32|0)!==0){
									L$poptgep79$poptgep92$poptgepsqueezed[tmp13!==0?41|0:40|0]=48;
									tmp13=tmp13!==0?2|0:1|0;
									L$poptgep79$poptgep92$poptgepsqueezed[tmp13+40|0]=L$poptgep79$poptgep92$poptgepsqueezed[42]|0;
									tmp13=tmp13+1|0;
								}else{
									tmp13=tmp13!==0?1:0;
								}
								if((___sfputs_r(_impure_data,tmp8,L$poptgep79$poptgep92$poptgepsqueezed,40,tmp13)|0|0)===-1){
									tmp13=-1;
								}else{
									tmp13=(tmp4.i3|0)-Lgeptoindexphi33|0;
									tmp13=(tmp13|0)<0||(tmp4.i0&6|0)!==4?0|0:tmp13|0;
									Lmaskcond6$pi$pi=tmp4.i2|0;
									tmp18=tmp4.i4|0;
									if((Lmaskcond6$pi$pi|0)>(tmp18|0)){
										tmp13=(Lmaskcond6$pi$pi-tmp18|0)+tmp13|0;
									}
									if((tmp13|0)>0){
										tmp18=0;
										while(1){
											if((tmp8.i21&8192|0)===0)if((___sfputc_r(_impure_data,tmp4.i8<<24>>24,tmp8)|0|0)===-1){
												tmp13=-1;
												break e;
											}
											tmp18=tmp18+1|0;
											if((tmp18|0)<(tmp13|0))continue;
											break;
										}
										tmp18=tmp4.i4|0;
									}
									if((___sfputs_r(_impure_data,tmp8,L$pph,L$ppho,tmp18)|0|0)===-1){
										tmp13=-1;
									}else{
										tmp13=tmp4.i3|0;
										tmp18=(tmp13|0)>(Lgeptoindexphi33|0)?1:0;
										if((tmp4.i0&2|0)!==0)if(tmp18){
											tmp18=0;
											while(1){
												if((tmp8.i21&8192|0)===0){
													if((___sfputc_r(_impure_data,tmp4.i7<<24>>24,tmp8)|0|0)===-1){
														tmp13=-1;
														break e;
													}
													tmp13=tmp4.i3|0;
												}
												tmp18=tmp18+1|0;
												if((tmp18|0)<(tmp13-Lgeptoindexphi33|0))continue;
												break;
											}
										}
										tmp13=(tmp13|0)>(Lgeptoindexphi33|0)?tmp13|0:Lgeptoindexphi33|0;
									}
								}
							}
							if((tmp13|0)!==-1){
								Lgeptoindexphi62=(tmp4.i5|0)+tmp13|0;
								tmp4.i5=Lgeptoindexphi62;
								Lgeptoindexphi33=Lgeptoindexphi+1|0;
								continue b;
							}
						}
					}
					tmp13=tmp8.i3|0;
					Lgeptoindexphi33=tmp4.i5|0;
					tmp13=(tmp13&64|0)!==0? -1|0:Lgeptoindexphi33|0;
					break a;
					default:
					Lgeptoindexphi32=Lgeptoindexphi32+1|0;
					continue c;
				}
				break;
			}
			break;
		}
	}
	LmergedArray[0]=null;
	return tmp13|0;
}
function ___sfputc_r(Larg0,Larg1,Larg2){
	var tmp0=0,tmp1=null,tmp1o=0,tmp2=0,tmp3=0;
	tmp0=Larg2.i2|0;
	Larg2.i2=tmp0-1|0;
	a:{
		if((tmp0|0)<=0){
			tmp2=Larg2.i5|0;
			tmp3=Larg1&255;
			if((tmp3|0)!==10)if((tmp0|0)>(tmp2|0))break a;
			return ___swbuf_r(Larg0,Larg1,Larg2)|0|0;
		}
		tmp3=Larg1&255;
	}
	tmp1o=Larg2.a0o;
	tmp1=Larg2.a0;
	Larg2.a0=tmp1;
	Larg2.a0o=tmp1o+1|0;
	tmp1[tmp1o]=Larg1;
	return tmp3|0;
}
function ___swbuf_r(Larg0,Larg1,Larg2){
	var tmp0=null,L$poptgep4$poptgep9$poptgepsqueezed=null,tmp2=null,tmp2o=0,Lmergedload=0,tmp4=null,tmp4o=0,tmp5=0;
	if(Larg0!==null)if((Larg0.i6|0)===0)___sinit(Larg0);
	if(Larg2===___sf_fake_stdin){
		tmp0=Larg0.a1;
	}else if(Larg2===___sf_fake_stdout){
		tmp0=Larg0.a2;
	}else if(Larg2===___sf_fake_stderr){
		tmp0=Larg0.a3;
	}else{
		tmp0=Larg2;
	}
	tmp0.i2=tmp0.i5|0;
	Lmergedload=tmp0.i3|0;
	a:{
		if((Lmergedload&8)!==0){
			tmp4o=tmp0.a4.a0o;
			tmp4=tmp0.a4.a0;
			if(tmp4!==nullArray||tmp4o!==0){
				tmp5=Lmergedload;
				break a;
			}
		}
		if((___swsetup_r(Larg0,tmp0)|0|0)!==0)return  -1|0;
		Lmergedload=tmp0.i3|0;
		tmp5=Lmergedload;
	}
	if((tmp5&8192)===0){
		tmp0.i3=Lmergedload& -65536|(tmp5|8192)&65535;
		tmp0.i21=tmp0.i21& -8193;
	}
	tmp4o=tmp0.a0o;
	tmp4=tmp0.a0;
	L$poptgep4$poptgep9$poptgepsqueezed=tmp0.a4;
	tmp2o=L$poptgep4$poptgep9$poptgepsqueezed.a0o;
	tmp2=L$poptgep4$poptgep9$poptgepsqueezed.a0;
	Lmergedload=(tmp4o)-(tmp2o)|0;
	if((Lmergedload|0)>=(L$poptgep4$poptgep9$poptgepsqueezed.i1|0)){
		if((__fflush_r(Larg0,tmp0)|0|0)!==0)return  -1|0;
		tmp4o=tmp0.a0o;
		tmp4=tmp0.a0;
		Lmergedload=0;
	}
	tmp0.i2=(tmp0.i2|0)-1|0;
	tmp0.a0=tmp4;
	tmp0.a0o=tmp4o+1|0;
	tmp4[tmp4o]=Larg1;
	tmp5=Larg1&255;
	a:{
		if((Lmergedload+1|0)!==(L$poptgep4$poptgep9$poptgepsqueezed.i1|0)){
			Lmergedload=tmp0.i3|0;
			if((tmp5|0)!==10)break a;
			if((Lmergedload&1|0)===0)break a;
		}
		if((__fflush_r(Larg0,tmp0)|0|0)!==0)return  -1|0;
	}
	return tmp5|0;
}
function ___sfputs_r(Larg0,Larg1,Larg2,Marg2,Larg3){
	var tmp0=0,tmp1=0,tmp2=0,tmp3=0,tmp4=null,tmp4o=0;
	if((Larg1.i21&8192|0)!==0){
		tmp1=Larg3>>>2;
		if((tmp1|0)===0)return 0|0;
		tmp2=0;
		while(1){
			tmp0=Larg2[Marg2+tmp2|0]|0;
			tmp3=Larg1.i3|0;
			if((tmp3&8192|0)===0){
				Larg1.i3=tmp3|8192;
				Larg1.i21=Larg1.i21|8192;
			}
			if(tmp0>>>0>255)if(tmp0-1>>>0>254){
				Larg1.a20.i0=0;
				Larg0.i0=138;
				Larg1.i3=Larg1.i3|64;
				return  -1|0;
			}
			tmp3=Larg1.i2|0;
			Larg1.i2=tmp3-1|0;
			a:if((tmp3|0)<1){
				if((tmp3|0)>(Larg1.i5|0)){
					tmp4o=Larg1.a0o;
					tmp4=Larg1.a0;
					tmp4[tmp4o]=tmp0;
					tmp4o=Larg1.a0o;
					tmp4=Larg1.a0;
					if((tmp4[tmp4o]&255)!==10){
						Larg1.a0=tmp4;
						Larg1.a0o=tmp4o+1|0;
						break a;
					}
					tmp3=10;
				}else{
					tmp3=tmp0&255;
				}
				if((___swbuf_r(Larg0,tmp3,Larg1)|0|0)===-1)return  -1|0;
			}else{
				tmp4o=Larg1.a0o;
				tmp4=Larg1.a0;
				tmp4[tmp4o]=tmp0;
				tmp4o=Larg1.a0o;
				tmp4=Larg1.a0;
				Larg1.a0=tmp4;
				Larg1.a0o=tmp4o+1|0;
			}
			if((tmp0|0)===-1)return  -1|0;
			tmp2=tmp2+1|0;
			if(tmp2>>>0<tmp1>>>0)continue;
			break;
		}
		return 0|0;
	}else{
		if((Larg3|0)===0)return 0|0;
		tmp1=0;
		while(1){
			if((___sfputc_r(Larg0,Larg2[Marg2+tmp1|0]<<24>>24,Larg1)|0|0)===-1)return  -1|0;
			tmp1=tmp1+1|0;
			if(tmp1>>>0<Larg3>>>0)continue;
			break;
		}
		return 0|0;
	}
}
var _loop=new Int32Array([9,100000000,13,0,9,0,13,1,11,1,11,0,4,8,24,11,1,9,1,1,13,1,6,8,16]);
var _$pstr=new Uint8Array([37,100,10,0]);
var _$pstr$p1=new Uint8Array([105,110,118,97,108,105,100,32,111,112,99,111,100,101,58,32,37,100,32,97,116,32,105,112,61,37,100,10,0]);
var _str=new Uint8Array([68,97,116,97,32,109,101,109,111,114,121,58,0]);
var _$pstr$p416=new Uint8Array([10,0]);
var ___sf_fake_stdin=new constructor_struct$p_Z7__sFILE();
var ___sf_fake_stdout=new constructor_struct$p_Z7__sFILE();
var ___sf_fake_stderr=new constructor_struct$p_Z7__sFILE();
var _$pstr$p18$p109=new Uint8Array([67,0]);
var _promotedMalloc$p2=new constructor_struct$p_Z11_misc_reent();
var _impure_data={i0:0,a1:___sf_fake_stdin,a2:___sf_fake_stdout,a3:___sf_fake_stderr,i4:0,a5:null,i6:0,i7:0,a8:_$pstr$p18$p109[0],a9:null,a10:null,i11:0,i12:0,a13:null,a14:null,a15:null,a16:null,a17:null,a18:null,a19:{a0:null,i1:0,a2:createPointerArray([],0,32,null),a3:null},a20:{a0:null,i1:0,a2:nullArray},a21:null,a22:_promotedMalloc$p2,a23:null};
var _$pstr$p4=new Uint8Array([37,48,52,100,58,32,37,100,10,0]);
var _$pstr$p359=new Uint8Array([35,45,48,43,32,0]);
var _$pstr$p356=new Uint8Array([104,108,76,0]);
var _$pstr$p1$p373=new Uint8Array([48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,0]);
var _$pstr$p374=new Uint8Array([48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70,0]);
function constructor_struct$p_Z11_prt_data_t(){
	this.i0=0;
	this.i1=0;
	this.i2=0;
	this.i3=0;
	this.i4=0;
	this.i5=0;
	this.i6=0;
	this.i7=0;
	this.i8=0;
	this.a9=new Uint8Array(50);
	this.d10=-0.;
	this.i11=0;
}
function constructor_struct$p_Z7__sFILE(){
	this.a0=nullArray;
	this.a0o=0;
	this.i1=0;
	this.i2=0;
	this.i3=0;
	this.a4={a0:nullArray,a0o:0,i1:0};
	this.i5=0;
	this.a6=null;
	this.a7=null;
	this.a8=null;
	this.a9=null;
	this.a10=null;
	this.a11=null;
	this.a12={a0:nullArray,a0o:0,i1:0};
	this.a13=null;
	this.i14=0;
	this.a15=new Uint8Array(4);
	this.a16={a0:nullArray,a0o:0,i1:0};
	this.i17=0;
	this.i18=0;
	this.i19=0;
	this.a20={i0:0,i1:0};
	this.i21=0;
}
function constructor_struct$p_Z11_misc_reent(){
	this.a0=null;
	this.a1={i0:0,i1:0};
	this.a2={i0:0,i1:0};
	this.a3={i0:0,i1:0};
	this.a4=new Uint8Array(8);
	this.i5=0;
	this.a6={i0:0,i1:0};
	this.a7={i0:0,i1:0};
	this.a8={i0:0,i1:0};
	this.a9={i0:0,i1:0};
	this.a10={i0:0,i1:0};
}
function constructor_struct$p_Z6_reent(){
	this.i0=0;
	this.a1=null;
	this.a2=null;
	this.a3=null;
	this.i4=0;
	this.a5=null;
	this.i6=0;
	this.i7=0;
	this.a8=null;
	this.a9=null;
	this.a10=null;
	this.i11=0;
	this.i12=0;
	this.a13=null;
	this.a14=null;
	this.a15=null;
	this.a16=null;
	this.a17=null;
	this.a18=null;
	this.a19={a0:null,i1:0,a2:createPointerArray([],0,32,null),a3:null};
	this.a20={a0:null,i1:0,a2:nullArray};
	this.a21=null;
	this.a22=null;
	this.a23=null;
}
function createPointerArray(r,s,e,v){for(var i=s;i<e;i++)r[i]=v;return r;}
function handleVAArg(ptr){var ret=ptr.d[ptr.o];ptr.o++;return ret;}
Promise.resolve();
__Z7webMainv();
