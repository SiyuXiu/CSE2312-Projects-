//
//  File.s
//  
//
//  Created by Siyu Xiu on 4/11/18.
//
/******************************************************************************
 * @file float_div.s
 * @brief simple example of integer division with a scalar result using the FPU
 *
 * Simple example of using the ARM FPU to compute the division result of
 * two integer values
 *
 * @author Christopher D. McMurrough
 ******************************************************************************/

.global main
.func main

main:

BL  _prompt             @ branch to prompt procedure with return
BL  _scanf              @ branch to scanf procedure with return

VMOV S0, R0             @ move the numerator to floating point register

BL  _prompt             @ branch to prompt procedure with return
BL  _scanf              @ branch to scanf procedure with return

VMOV S1, R1             @ move the denominator to floating point register

VCVT.F32.U32 S0, S0     @ convert unsigned bit representation to single float
VCVT.F32.U32 S1, S1     @ convert unsigned bit representation to single float

VDIV.F32 S2, S0, S1     @ compute S2 = S0 * S1

VCVT.F64.F32 D4, S2     @ covert the result to double precision for printing
VMOV R1, R2, D4         @ split the double VFP register into two ARM registers
BL  _printf_result      @ print the result

B   _exit               @ branch to exit procedure with no return

_exit:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #21             @ print string length
LDR R1, =exit_str       @ string at label exit_str:
SWI 0                   @ execute syscall
MOV R7, #1              @ terminate syscall, 1
SWI 0                   @ execute syscall

_prompt:
MOV R7, #4              @ write syscall, 4
MOV R0, #1              @ output stream to monitor, 1
MOV R2, #31             @ print string length
LDR R1, =prompt_str     @ string at label prompt_str:
SWI 0                   @ execute syscall
MOV PC, LR              @ return

_printf_result:
PUSH {LR}               @ push LR to stack
LDR R0, =result_str     @ R0 contains formatted string address
BL printf               @ call printf
POP {PC}                @ pop LR from stack and return

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

format_str:     .asciz      "%f"
prompt_str:     .asciz      "Type a number and press enter: "


result_str:     .asciz      "%f mod %f = %f \n"
exit_str:       .ascii      "Terminating program.\n"
