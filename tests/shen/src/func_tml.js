    
	///函数模板
	var func_tml = `
;;;;func
(func $\m{*data.index*}
{%if (data.fname) do %}(export {{fname}}){%end%}
{%ipairs i,v in data.numparams do %}(param f64){%end%}
(result f64) 
{{regnum}}
{{data}}
)`;