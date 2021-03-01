
#include <stdio.h>
#include <stdlib.h>

#include "vm.h"

#define DEFAULT_STACK_SIZE 16
#define FALSE 0
#define TRUE 1

typedef struct {
    char name[8];
    int nargs;
} VM_INSTRUCTION;

VM_INSTRUCTION vm_instructions[] = {
    { "noop",   0 },
    { "iadd",   0 },
    { "isub",   0 },
    { "imul",   0 },
    { "ilt",    0 },
    { "ieq",    0 },
    { "ret",    0 },
    { "br",     1 },
    { "brt",    1 },
    { "brf",    1 },
    { "iconst", 1 },
    { "load",   1 },
    { "gload",  1 },
    { "store",  1 },
    { "gstore", 1 },
    { "print",  0 },
    { "pop",    0 },
    { "halt",   0 }
};

static void vm_print_instr(int *code, int ip);
static void vm_print_stack(int *stack, int count);
static void vm_print_data(int *globals, int count);

void vm_exec(int *code, int count, int startip, int nglobals, int trace)
{
    // registers
   register  int ip = 0;         // instruction pointer register
   register  int sp = -1;          // stack pointer register
   register  int fp = -1;        // frame pointer register

    int opcode = code[ip];
    int a = 0;
    int b = 0;
    int addr = 0;
    int offset = 0;

    // global variable space
    int globals[16];

    // Operand stack, grows upwards
    int stack[DEFAULT_STACK_SIZE];
    int regs [DEFAULT_STACK_SIZE];
    regs[0] = ip;
    ip++;
for ( ; ip < count ; ip++ ) {
    //while (opcode != HALT && ip < count) {
        //if (trace) vm_print_instr(code, ip);
       // vm_print_instr(code, ip);
       // ip++; //jump to next instruction or to operand
        if (opcode == NOOP) {
            opcode = code[ip];
            continue;
        }
        if (opcode == HALT) {
            break;
        }
        switch (opcode) {
            case GLOAD: // load from global memory
                addr = code[ip++];
                stack[++sp] = globals[addr];
                break;
			case GSTORE:
                addr = code[ip++];
                globals[addr] = stack[sp--];
                break;
            case ICONST:
                stack[++sp] = code[ip++];  // push operand
                break;
            case IADD:
                b = stack[sp--];           // 2nd opnd at top of stack
                a = stack[sp--];           // 1st opnd 1 below top
                stack[++sp] = a + b;       // push result
                break;
            case ISUB:
                b = stack[sp--];
                a = stack[sp--];
                stack[++sp] = a - b;
                break;
            case IMUL:
                b = stack[sp--];
                a = stack[sp--];
                stack[++sp] = a * b;
                break;
            case ILT:
                b = stack[sp--];
                a = stack[sp--];
                stack[++sp] = (a < b) ? TRUE : FALSE;
                break;
            case IEQ:
                b = stack[sp--];
                a = stack[sp--];
                stack[++sp] = (a == b) ? TRUE : FALSE;
                break;
            case BR:
                ip = code[ip];
                break;
            case BRT:
                addr = code[ip++];
                if (stack[sp--] == TRUE) ip = addr;
                break;
            case BRF:
                addr = code[ip++];
                if (stack[sp--] == FALSE) ip = addr;
                break;
            case LOAD: // load local or arg; 1st local is fp+1, args are fp-3, fp-4, fp-5, ...
                offset = code[ip++];
                stack[++sp] = stack[fp+offset];
                break;
            case STORE:
                offset = code[ip++];
                stack[fp+offset] = stack[sp--];
                break;
            case PRINT:
                printf("%d\n", stack[sp--]);
                break;
            case POP:
                --sp;
                break;
            default:
                printf("invalid opcode: %d at ip=%d\n", opcode, (ip - 1));
                exit(1);
        }
        //if (trace) vm_print_stack(stack, sp);
        opcode = code[ip];
    }
    //if (trace) vm_print_instr(code, ip);
    //if (1) vm_print_stack(stack, sp);
    if (1) vm_print_data(globals, nglobals);
}

static void vm_print_instr(int *code, int ip)
{
    int opcode = code[ip];
    VM_INSTRUCTION *inst = &vm_instructions[opcode];
    switch (inst->nargs) {
    case 0:
        printf("%04d:  %-20s\n", ip, inst->name);
        break;

    case 1:
        printf("%04d:  %-10s%-10d\n", ip, inst->name, code[ip + 1]);
        break;
    }
}

static void vm_print_stack(int *stack, int count)
{
    printf("stack=[");
    for (int i = 0; i <= count; i++) {
        printf(" %d", stack[i]);
    }
    printf(" ]\n");
}

static void vm_print_data(int *globals, int count)
{
    printf("Data memory:\n");
    for (int i = 0; i < count; i++) {
        printf("%04d: %d\n", i, globals[i]);
    }
}

