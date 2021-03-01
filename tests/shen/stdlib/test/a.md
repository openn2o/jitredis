

# 1 内存处理 #

在wasm线性内存中，如果要增量的实现连续内存赋值， 有两种方案。
> 
> 1 如果自己管理内存的话， 需要维护一个全局的pc控制内存增长。
> 
> 2 如果使用偏移量的话，只需要控制偏移的空间的地址。

假设我们有一段代码：
 
    

    
    		get_local 0
    		i32.const 0
    		i32.store offset=4 align=4
    		get_local 0
    		i32.const 1
    		i32.store offset=8 align=4
    		get_local 0
    		i32.const 2
    		i32.store offset=12 align=4
    		get_local 0
    		i32.load align=4

offset就是偏移量， align就是按照的字节数量处理对齐。


