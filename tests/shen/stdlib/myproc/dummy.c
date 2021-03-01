/*
** This file has been pre-processed with DynASM.
** http://luajit.org/dynasm.html
** DynASM version 1.3.0, DynASM x64 version 1.3.0
** DO NOT EDIT! The original file is in "dummy.dasc".
*/

#line 1 "dummy.dasc"
//|.arch x64
#if DASM_VERSION != 10300
#error "Version mismatch between DynASM and included encoding engine"
#endif
#line 2 "dummy.dasc"
//|.actionlist my_actionlist
static const unsigned char my_actionlist[22] = {
  248,10,85,72,137,229,184,90,0,0,0,187,9,0,0,0,252,247,227,93,195,255
};

#line 3 "dummy.dasc"
//|
//|.macro begin_function
//|  push rbp
//|  mov rbp, rsp
//|.endmacro
//|
//|.macro end_function
//|  pop rbp
//|  ret
//|.endmacro

	
static void create_my_function()
{
	//|->my_function:
	//|  begin_function
	//|  mov eax, 90
	//|  mov ebx, 9
	//|  mul ebx
	//|  end_function
	dasm_put(Dst, 0);
#line 23 "dummy.dasc"
}
