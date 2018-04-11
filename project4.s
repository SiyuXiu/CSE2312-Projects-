/******************************************************************************
 * @file float_div.s author Christopher D. McMurrough
 * @brief simple example of integer division with a scalar result using the FPU
 *
 * a simple integer division calculator that will compute the floating point 
 * result of the division of two integers n and d
 * Student Name: Siyu Xiu
 * Student ID: 1001394663
 ******************************************************************************/
.global main
.func main

main:

BL  _prompt             @ branch to prompt procedure with return
BL  _scanf              @ branch to scanf procedure with return
MOV R8,R0
VMOV S0, R0             @ move the numerator to floating point register
VCVT.F64.F32 D1, S0     @ covert the result to double precision for printing

BL  _prompt             @ branch to prompt procedure with return
BL  _scanf              @ branch to scanf procedure with return
MOV R9,R0
VMOV S1, R0             @ move the denominator to floating point register
VCVT.F64.F32 D2, S1     @ covert the result to double precision for printing
VDIV.F64 D3, D1, D2     @ compute D3 = D1 / D2

LDR R0,=result_str      @ R0 contains formatted string address
MOV R1,R8               @ move R8 (integer n)to R1
MOV R2,R9               @ move R9 (integer d)to R2
VPUSH {D3}              @ push D3 onto stack
BL printf               @ print the result

B main                  @ loop

_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #31             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_scanf:
PUSH {LR}               @ store LR since scanf call overwrites
SUB SP, SP, #4          @ make room on stack
LDR R0, =format_str     @ R0 contains address of format string
MOV R1, SP              @ move SP to R1 to store entry on stack
BL scanf                @ call scanf
LDR R0, [SP]            @ load value at SP into R0
ADD SP, SP, #4          @ restore the stack pointer
POP {PC}                @ return


.data

format_str:     .asciz      "%d"
prompt_str:     .asciz      "Type a number and press enter: "
result_str:     .asciz      "%d / %d= %f \n"

