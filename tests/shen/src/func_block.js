    
function Block () {
this.data     = [];
this.func     = null;
this.fname    = "";
this.index    = -1;
this.regnum   = "";//寄存器
this.symblos  = [];
this.isfloat  = 0;
this.alloc_pc = 0;
this.tags_start  = {};
this.tags_end    = [];
this.static_data = [];
this.static_pc   = 8092; ///8KB 每页
}
	