LUAJIT=luajit
DYNASM_DIR=./dynasm
DYNASM=$(LUAJIT) $(DYNASM_DIR)/dynasm.lua
GCC=gcc

all: main

main: main.c dummy.c
	$(GCC) -g -I$(DYNASM_DIR) main.c -o main
	$(GCC) -std=c99 -c -I$(DYNASM_DIR) vm.c 
	$(GCC) -std=c99 -c -I$(DYNASM_DIR) vmtest.c
	$(GCC) -O2 -I$(DYNASM_DIR) -o vmtest.exe vm.o vmtest.o

dummy.c: dummy.dasc
	$(DYNASM) -o dummy.c dummy.dasc

clean:
	rm -f dummy.c main
	rm -f *.o
