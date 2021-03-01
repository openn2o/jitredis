#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <err.h>

	#include "dynasm/dasm_proto.h"
	#include "dynasm/dasm_x86.h"

	Dst_DECL;

	#include "dummy.c"

#define GLOB__MAX 8

// static long get_page_size()
// {
// 	static long sz;
// 	if (0 == sz)
// 		sz = sysconf(_SC_PAGESIZE);
// 	return sz;
// }

// static size_t round_up_to_page_size(size_t size)
// {
// 	long sz = get_page_size();
// 	size_t remainder;
// 	remainder = size % sz;
// 	return size + sz - remainder;
// }

// static void *create_code_mapping(size_t size)
// {
// 	void *ptr;
// 	size = round_up_to_page_size(size);
// 	ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
// 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
// 	if (MAP_FAILED == ptr)
// 		err(EXIT_FAILURE, "mmap");
// 	return ptr;
// }

// static void protect_code_mapping(void *addr, size_t size)
// {
// 	int retval;
// 	size = round_up_to_page_size(size);
// 	retval = mprotect(addr, size, PROT_READ | PROT_EXEC);
// 	if (retval)
// 		err(EXIT_FAILURE, "mprotect");
// }

// static void destroy_code_mapping(void *ptr, size_t size)
// {
// 	int retval;
// 	size = round_up_to_page_size(size);
// 	retval = munmap(ptr, size);
// 	if (retval)
// 		err(EXIT_FAILURE, "munmap");
// }

int main() {
		int retval = 0;
		void *buf;
		size_t size;
		int global [8] = {};
		int (*my_function)();
		void **glob = (void **)malloc(10 * sizeof(void *));
		Dst = (dasm_State**)malloc(sizeof(*Dst));
		dasm_init(Dst, 10);
		dasm_setupglobal(Dst, glob, 10);
		dasm_setup(Dst, my_actionlist);
		create_my_function();
		retval = dasm_link(Dst, &size);
		buf    = malloc(size);
		retval = dasm_encode(Dst, buf);

		my_function = (int (*)())glob[0];
		printf("going to call my_function\n");
		retval = my_function();
		printf("my_function has returned: %d\n", retval);
		dasm_free(Dst);
	return 0;
}
