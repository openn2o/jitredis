
var Flags = {  	
	"exceptions": false,
	"mutable_globals": true,
	"sat_float_to_int":false,
	"sign_extension":false,
	"simd":false,
	"threads":false,
	"multi_value":false,
	"tail_call":false    
};
								
////解释运行
function run_compc_main(code) {
	console.log("code=", code);
	
	if(!code) {
		code = "(module)";
	}
	var fs = require("fs");
	fs.writeFileSync("build/out.wat", code);
	return null;
}


var template = require("../template.js").template;

function run_comc_file_node (url) {
	
	var fs   = require("fs");
	var code = new Uint8Array(fs.readFileSync(url)).buffer;
	
	var buffer = Buffer(code);
    var protos = parse(buffer);
	console.log(protos);
	return run_compc_main(compile(protos));
}

var cases = [];
function test(name, result, condi) {
	cases .push({
		name:name, 
		result:result == condi,
		value :result
	});
}

function test_display() {
	var len =  cases.length;
	
	for(var i = 0; i<  len; i++ ) {
		console.log((i + 1), cases[i].name , cases[i].value , (cases[i].result?"[success]":"[failed]"));
	}
}

///calc
function testl0case() {
	console.log("testl0 is calc test");
	console.time("testl0case");
	
	// test("test/l0/def_var.luax", Number(run_comc_file_node("test/l0/def_var.luax")) >> 0 , 65536);
	// test("test/l0/def_const.luax", run_comc_file_node("test/l0/def_const.luax") , 30);
	
	//add
	// test("test/l0/def_add.luax", run_comc_file_node("test/l0/def_add.luax") , 30);
	// test("test/l0/def_add_sign.luax", run_comc_file_node("test/l0/def_add_sign.luax") , 30);
	// test("test/l0/def_add_l.luax", Number(run_comc_file_node("test/l0/def_add_l.luax")) >> 0 , -30);
	// test("test/l0/def_add_n.luax", Number(run_comc_file_node("test/l0/def_add_n.luax")) >> 0 , 30);
	
	//mul
	// test("test/l0/def_mul.luax", run_comc_file_node("test/l0/def_mul.luax") ,300);
	// test("test/l0/def_mul_sign.luax", Number(run_comc_file_node("test/l0/def_mul_sign.luax")) >> 0 , 314);
	// test("test/l0/def_mul_n.luax", Number(run_comc_file_node("test/l0/def_mul_n.luax")), 3000); 
	// test("test/l0/def_mul_l.luax", Number(run_comc_file_node("test/l0/def_mul_l.luax")), -3000); 
	
	//sub
	// test("test/l0/def_sub.luax", Number(run_comc_file_node("test/l0/def_sub.luax")) >> 0 ,30);
	// test("test/l0/def_sub_sign.luax", Number(run_comc_file_node("test/l0/def_sub_sign.luax")) >> 0 , 300);
	// test("test/l0/def_sub_n.luax", Number(run_comc_file_node("test/l0/def_sub_n.luax")) >> 0 ,30);
	// test("test/l0/def_sub_l.luax", Number(run_comc_file_node("test/l0/def_sub_l.luax")) >> 0 ,-30);
	
	//div
	// test("test/l0/def_dev.luax", Number(run_comc_file_node("test/l0/def_dev.luax")) >> 0 ,30);
	// test("test/l0/def_dev_sign.luax", Math.floor(Number(run_comc_file_node("test/l0/def_dev_sign.luax"))) ,99);
	// test("test/l0/def_dev_n.luax", Math.floor(Number(run_comc_file_node("test/l0/def_dev_n.luax"))) ,30);
	//test("test/l0/def_dev_l.luax", Math.floor(Number(run_comc_file_node("test/l0/def_dev_l.luax"))) ,30);
	
	//mod
	// test("test/l0/def_mod.luax", Math.floor(Number(run_comc_file_node("test/l0/def_mod.luax"))) ,1);
	// test("test/l0/def_mod_l.luax", Math.floor(Number(run_comc_file_node("test/l0/def_mod_l.luax"))) ,1);
	test("test/l0/def_mod_sign.luax", Math.floor(Number(run_comc_file_node("test/l0/def_mod_sign.luax"))) ,1);
	

	console.timeEnd("testl0case");
	test_display();
}

//////func call
function testl1case() {
	console.log("testl1 is calc test");
	console.time("testl1case");
	
	// test("test/l1/nil.luax", Number(run_comc_file_node("test/l1/nil.luax")) >> 0 , 0);
	// test("test/l1/blooean.luax", Number(run_comc_file_node("test/l1/blooean.luax")) >> 0 , 1);
	// test("test/l1/string.luax", Number(run_comc_file_node("test/l1/string.luax")) >> 0 , 0);
	// test("test/l1/string_print.luax", Number(run_comc_file_node("test/l1/string_print.luax")) >> 0 , -1);
	
	///func test
	// test("test/l1/i32_put.luax", Number(run_comc_file_node("test/l1/i32_put.luax")) >> 0 , 0);
	// test("test/l1/i32_put_val.luax", Number(run_comc_file_node("test/l1/i32_put_val.luax")) >> 0 , 0);
	
	//inline call
	// test("test/l1/sub_func.luax", Number(run_comc_file_node("test/l1/sub_func.luax")) >> 0 , 5);
	//test("test/l1/add_func.luax", Number(run_comc_file_node("test/l1/add_func.luax")) >> 0 , 5);
	//test("test/l1/mul_func.luax", Number(run_comc_file_node("test/l1/mul_func.luax")) >> 0 , 5);
	//test("test/l1/div_func.luax", Number(run_comc_file_node("test/l1/div_func.luax")) >> 0 , 5);
	// test("test/l1/inline_fun_add.luax", Number(run_comc_file_node("test/l1/inline_fun_add.luax")) >> 0 , 1);
	// test("test/l1/mod_func.luax", Number(run_comc_file_node("test/l1/mod_func.luax")) >> 0 , 1);
	// test("test/l1/calc.luax", Number(run_comc_file_node("test/l1/calc.luax")) >> 0 , 1);
	
	console.timeEnd("testl1case");
	test_display();
}

//logic
function testl2case() {
	console.log("testl2 is calc test");
	console.time("testl2case");
	
	// test("test/l2/max.luax", Number(run_comc_file_node("test/l2/max.luax")) >> 0 , 0);
	// test("test/l2/ret1.luax", Number(run_comc_file_node("test/l2/ret1.luax")) >> 0 , 0);
	// test("test/l2/if_elif.luax", Number(run_comc_file_node("test/l2/if_elif.luax")) >> 0 , 0);
	// test("test/l2/if_lt.luax", Number(run_comc_file_node("test/l2/if_lt.luax")) >> 0 , 0);
	// test("test/l2/if_ge.luax", Number(run_comc_file_node("test/l2/if_ge.luax")) >> 0 , 0);
	// test("test/l2/if_gt.luax", Number(run_comc_file_node("test/l2/if_gt.luax")) >> 0 , 0);
	// test("test/l2/if_eq.luax", Number(run_comc_file_node("test/l2/if_eq.luax")) >> 0 , 0);
	// test("test/l2/case1.luax", Number(run_comc_file_node("test/l2/case1.luax")) >> 0 , 0);
	///bad case
	
	//test("test/l2/fib401.luax", Number(run_comc_file_node("test/l2/fib401.luax")) >> 0 , 1);
	//test("test/l2/fib402.luax", Number(run_comc_file_node("test/l2/fib402.luax")) >> 0 , 1);
	console.timeEnd("testl2case");
	test_display();
}

//loop
function testl3case() {
	console.log("testl3 is loop test");
	console.time("testl3case");
	
	// test("test/l3/for3.luax", Number(run_comc_file_node("test/l3/for3.luax")) >> 0 , 0);
	// test("test/l3/for.luax", Number(run_comc_file_node("test/l3/for.luax")) >> 0 , 0);
	//test("test/l3/for2.luax", Number(run_comc_file_node("test/l3/for2.luax")) >> 0 , 0);
	
	///bad case
	// test("test/l3/while.luax", Number(run_comc_file_node("test/l3/while.luax")) >> 0 , 0);
	
	console.timeEnd("testl3case");
	test_display();
}

///string
function testl4case() {
	// test("test/l4/require.luax", Number(run_comc_file_node("test/l4/require.luax")) >> 0 , 0);
	// test("test/l4/string_set.luax", Number(run_comc_file_node("test/l4/string_set.luax")) >> 0 , 0);
	//test("test/l4/string_unpas.luax", Number(run_comc_file_node("test/l4/string_unpas.luax")) >> 0 , 0);
	//test("test/l4/string_eq.luax", Number(run_comc_file_node("test/l4/string_eq.luax")) >> 0 , 0);
	//test("test/l4/string_eq_not_pass.luax", Number(run_comc_file_node("test/l4/string_eq_not_pass.luax")) >> 0 , 0);
	//test("test/l4/string_eq_not_pass2.luax", Number(run_comc_file_node("test/l4/string_eq_not_pass2.luax")) >> 0 , 0);
	//test("test/l4/string_neq.luax", Number(run_comc_file_node("test/l4/string_neq.luax")) >> 0 , 0);
	//test("test/l4/string_not.luax", Number(run_comc_file_node("test/l4/string_not.luax")) >> 0 , 0);
	//test("test/l4/table_set.luax", Number(run_comc_file_node("test/l4/table_set.luax")) >> 0 , 0);
	//test("test/l4/table_update.luax", Number(run_comc_file_node("test/l4/table_update.luax")) >> 0 , 0);
	//test("test/l4/table_set_unpass.luax", Number(run_comc_file_node("test/l4/table_set_unpass.luax")) >> 0 , 0);
	
	//test("test/l4/table_set_benchi_unpass.luax", Number(run_comc_file_node("test/l4/table_set_benchi_unpass.luax")) >> 0 , 0);
	//test("test/l4/table_set_benchi.luax", Number(run_comc_file_node("test/l4/table_set_benchi.luax")) >> 0 , 0);
	// test("test/l4/table_incr.luax", Number(run_comc_file_node("test/l4/table_incr.luax")) >> 0 , 0);
	//bad case
	test_display();
}
testl4case();
// testl3case();
//testl2case();
// testl0case();
// testl2case();

