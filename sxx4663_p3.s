/*
 *******************************************************
 * @file factorial.s                                   *
 * @author Christopher D. McMurrough                   *
 *Name: Siyu Xiu                                       *
 *Student ID: 1001394663                               *
 *******************************************************
 */
.global main
.func main

main:
BL _scanf                          @ branch to scanf prodecure with return
MOV R8, R0                         @ store n in R8
BL _scanf                          @ branch to scanf prodecure with return
MOV R9, R0                         @ store m in R9

MOV R1, R8                         @ pass n to partition procedure
MOV R2, R9                         @ pass m to partition procedure
BL count_partitions                @ branch to count_partitions prodecure with return

MOV R1, R0                         @ pass result to printf procedure
MOV R2, R8                         @ pass n to printf procedure
MOV R3, R9                         @ pass m to printf procedure
BL _printf                         @ branch to printf prodecure with return

B main                             @ branch to main prodecure with no return



count_partitions:
PUSH {LR}                          @ store the return address
CMP R1, #0                         @ if (n == 0)
MOVEQ R0, #1                       @ let R0 = 1
POPEQ {PC}                         @ return R0

CMP R1, #0                         @ else if (n<0)
MOVLT R0, #0                       @ let R0 = 0
POPLT {PC}                         @ return R0

CMP R2, #0                         @ else if (m == 0)
MOVEQ R0, #0                       @ let R0 = 0
POPEQ {PC}                         @ return R0

PUSH {R1}                          @ backup input argument value(n)
PUSH {R2}                          @ backup input argument value(m)
SUB R1, R1, R2                     @ let n=(n-m),m=m
BL count_partitions                @ compute count_partitions(n-m,m)
MOV R10, R0                        @ store the result in R10
POP {R2}                           @ restore the input argument(m)
POP {R1}                           @ restore the input argument(n)
PUSH {R10}
SUB R2, R2, #1                     @ let n=n, m=(m-1)
BL count_partitions                @ compute count_partitions(n,m-1)
POP {R10}
ADD R0, R10, R0                   @ let R0=count_partitions(n-m,m) + count_partitions(n,m-1)
POP {PC}                           @ restore the stack pointer and return



_scanf:
PUSH {LR}                          @ store the return address
SUB SP, SP, #4                     @ make romm on stack
LDR R0, =format_str                @ R0 contains address of format string
MOV R1, SP                         @ move SP to R1 to store entry on stack
BL scanf                           @ call scanf
LDR R0, [SP]                       @ load value at SP into R0
ADD SP, SP, #4                     @ restore the stack pointer
POP {PC}                           @ restore the stack pointer and return



_printf:
PUSH {LR}                          @ store the return address
LDR R0, =print_str                 @ R0 contains formatted string address
BL printf                          @ call printf
POP {PC}                           @ restore the stack pointer and return


.data
format_str:        .asciz        "%d"
print_str:        .asciz        "There are %d partitions of %d using integers up to %d\n"

